#!/usr/bin/env python3
"""
DARUSSHOLAH - TOKOBUKU-V2 BACKEND SERVER
Cloud-Native Python Backend with Standard Library Supabase (PostgreSQL) Client.
Supports Cloudflare Container/Serverless Deployment, Asynchronous Database Handshakes,
and Graceful Structured Error Handling.
"""

import os
import sys
import json
import time
import re
import base64
import ssl
import logging
import urllib.parse
import urllib.request
import urllib.error
import concurrent.futures
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer

# Configure Structured Logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] [%(name)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)
logger = logging.getLogger("tokobuku.server")

# Environment Configurations (Injected via Cloudflare / Docker Environment)
PORT = int(os.environ.get("PORT", sys.argv[1] if len(sys.argv) > 1 else 8000))
HOST = os.environ.get("HOST", "")
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
BOOKS_FILE = os.path.join(BASE_DIR, "books.json")
UPLOADS_DIR = os.path.join(BASE_DIR, "uploads")

SUPABASE_URL = os.environ.get("SUPABASE_URL", "").rstrip("/")
SUPABASE_KEY = os.environ.get("SUPABASE_KEY") or os.environ.get("SUPABASE_ANON_KEY") or os.environ.get("SUPABASE_SERVICE_ROLE_KEY", "")
DB_TIMEOUT = float(os.environ.get("DB_TIMEOUT", 8.0))

os.makedirs(UPLOADS_DIR, exist_ok=True)


def slugify(text):
    text = text.lower().strip()
    text = re.sub(r"[^\w\s-]", "", text)
    text = re.sub(r"[\s_-]+", "-", text)
    return text.strip("-")


# ==============================================================================
# 1. DATA MAPPING ENGINE (Cloud PostgreSQL Schema <-> Frontend Store Schema)
# ==============================================================================

def clean_int(val, default=0):
    if val is None or val == "":
        return default
    try:
        clean = re.sub(r"[^\d-]", "", str(val))
        return int(clean) if clean else default
    except (ValueError, TypeError):
        return default


def clean_float(val, default=0.0):
    if val is None or val == "":
        return default
    try:
        clean = str(val).replace(",", ".").strip()
        matches = re.findall(r"[-+]?\d*\.?\d+", clean)
        return float(matches[0]) if matches else default
    except (ValueError, TypeError, IndexError):
        return default


def map_db_to_book(row):
    """
    Transforms a Supabase PostgreSQL row into the application book object.
    Guarantees all 14 mandatory product fields:
    title, author, genre, publisher, published_date, isbn, pages,
    length_cm, width_cm, weight_gram, original_price, selling_price,
    synopsis, warranty.
    """
    if not isinstance(row, dict):
        return {}

    raw_metadata = row.get("metadata") or {}
    if isinstance(raw_metadata, str):
        try:
            raw_metadata = json.loads(raw_metadata)
        except Exception:
            raw_metadata = {}

    # Extract 14 Core Variables
    title = row.get("title") or raw_metadata.get("title") or "Buku Tanpa Judul"
    author = row.get("author") or raw_metadata.get("author") or "Darussholah Press"
    genre = row.get("genre") or raw_metadata.get("genre") or "umum"
    publisher = row.get("publisher") or raw_metadata.get("publisher") or "Darussholah"
    published_date = str(row.get("published_date") or row.get("publication_year") or raw_metadata.get("releaseDate") or "2026")
    isbn = str(row.get("isbn") or raw_metadata.get("isbn") or "Belum Terdaftar")
    pages = clean_int(row.get("pages") or raw_metadata.get("pages"), 180)
    length_cm = clean_float(row.get("length_cm") or raw_metadata.get("length_cm") or raw_metadata.get("height_cm"), 21.0)
    width_cm = clean_float(row.get("width_cm") or raw_metadata.get("width_cm"), 14.0)
    weight_gram = clean_int(row.get("weight_gram") or raw_metadata.get("weight_gram"), 200)
    original_price = clean_int(row.get("original_price") or row.get("originalPrice") or raw_metadata.get("original_price"), 0)
    selling_price = clean_int(row.get("selling_price") or row.get("price") or raw_metadata.get("selling_price"), original_price)
    synopsis = row.get("synopsis") or raw_metadata.get("synopsis") or "Buku berkualitas terbitan resmi Darussholah."
    warranty = row.get("warranty") or raw_metadata.get("warranty") or "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik."

    # Derived Properties
    book_id = str(row.get("id") or raw_metadata.get("id") or slugify(title))
    alt_id = row.get("altId") or raw_metadata.get("altId") or f"{slugify(title)}-saku"
    format_type = row.get("format") or raw_metadata.get("format") or "print"
    status = row.get("status") or raw_metadata.get("status") or "normal"
    cover_img = row.get("cover_img") or row.get("coverImg") or raw_metadata.get("coverImg") or ""
    cover_class = row.get("cover_class") or row.get("coverClass") or raw_metadata.get("coverClass") or (
        "" if cover_img else "bg-gradient-to-br from-indigo-950 via-slate-900 to-indigo-900"
    )
    marketplace_links = row.get("marketplace_links") or raw_metadata.get("marketplace_links") or {
        "shopee": raw_metadata.get("shopee"),
        "tokopedia": raw_metadata.get("tokopedia"),
        "whatsapp_sales": raw_metadata.get("whatsapp_sales")
    }

    # Calculate discount
    discount = 0
    if original_price > selling_price and original_price > 0:
        discount = round(((original_price - selling_price) / original_price) * 100)

    # Thickness calculation
    thickness_cm = clean_float(row.get("thickness_cm") or raw_metadata.get("thickness_cm"), 1.5)
    size_str = f"{width_cm} × {length_cm} × {thickness_cm} cm"

    return {
        # Core 14 Variables
        "id": book_id,
        "altId": alt_id,
        "title": title,
        "author": author,
        "genre": genre,
        "publisher": publisher,
        "published_date": published_date,
        "isbn": isbn,
        "pages": pages,
        "length_cm": length_cm,
        "width_cm": width_cm,
        "weight_gram": weight_gram,
        "original_price": original_price,
        "selling_price": selling_price,
        "synopsis": synopsis,
        "warranty": warranty,

        # Frontend Compatibility Aliases
        "price": selling_price,
        "originalPrice": original_price,
        "discount": discount,
        "format": format_type,
        "status": status,
        "coverImg": cover_img,
        "coverClass": cover_class,
        "marketplace_links": marketplace_links,
        "dimensions": {
            "width_cm": width_cm,
            "height_cm": length_cm,
            "length_cm": length_cm,
            "thickness_cm": thickness_cm,
            "type": "Saku" if (length_cm <= 15 and width_cm <= 11) else "Standar"
        },
        "pricing": {
            "original_price": original_price,
            "discount_percentage": discount,
            "selling_price": selling_price,
            "currency": "IDR"
        },
        "specs": {
            "language": raw_metadata.get("language", "Indonesia & Arab"),
            "pages": f"{pages} Halaman",
            "size": size_str,
            "width": f"{width_cm} cm",
            "height": f"{length_cm} cm",
            "length": f"{length_cm} cm",
            "thickness": f"{thickness_cm} cm",
            "weight": f"{weight_gram} gram",
            "releaseDate": published_date,
            "publisher": publisher
        },
        "samplePages": raw_metadata.get("samplePages", [
            {
                "left": f"<h2>{title}</h2><p>Buku ini diterbitkan secara resmi oleh {publisher}.</p><p>{synopsis}</p>",
                "right": f"<h2>DAFTAR ISI & SPESIFIKASI</h2><p>Kategori: {genre.upper()}<br>ISBN: {isbn}<br>Tebal: {pages} Halaman<br>Dimensi: {size_str}</p>"
            }
        ])
    }


def map_book_to_db(payload):
    """
    Transforms payload received from frontend/admin into Supabase PostgreSQL format.
    """
    specs = payload.get("specs") or {}
    dimensions = payload.get("dimensions") or {}
    pricing = payload.get("pricing") or {}

    title = payload.get("title", "").strip() or "Buku Baru"
    author = payload.get("author", "").strip() or "Darussholah Press"
    genre = payload.get("genre", "").strip() or "umum"
    publisher = payload.get("publisher") or specs.get("publisher") or "Darussholah"
    published_date = str(payload.get("published_date") or specs.get("releaseDate") or "2026")
    isbn = payload.get("isbn") or "Belum Terdaftar"

    raw_pages = payload.get("pages") or specs.get("pages")
    pages = clean_int(raw_pages, 180)

    length_cm = clean_float(payload.get("length_cm") or dimensions.get("length_cm") or dimensions.get("height_cm"), 21.0)
    width_cm = clean_float(payload.get("width_cm") or dimensions.get("width_cm"), 14.0)
    thickness_cm = clean_float(payload.get("thickness_cm") or dimensions.get("thickness_cm"), 1.5)
    weight_gram = clean_int(payload.get("weight_gram") or dimensions.get("weight_gram") or specs.get("weight"), 200)

    original_price = clean_int(payload.get("original_price") or payload.get("originalPrice") or pricing.get("original_price"), 0)
    selling_price = clean_int(payload.get("selling_price") or payload.get("price") or pricing.get("selling_price"), original_price)

    synopsis = payload.get("synopsis", "").strip() or "Buku berkualitas terbitan resmi Darussholah."
    warranty = payload.get("warranty", "").strip() or "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik."

    metadata = {
        "format": payload.get("format", "print"),
        "status": payload.get("status", "normal"),
        "coverImg": payload.get("coverImg", ""),
        "coverClass": payload.get("coverClass", ""),
        "marketplace_links": payload.get("marketplace_links", {}),
        "language": specs.get("language", "Indonesia & Arab"),
        "samplePages": payload.get("samplePages", []),
        "thickness_cm": thickness_cm,
        "altId": payload.get("altId") or f"{slugify(title)}-saku"
    }

    db_row = {
        "title": title,
        "author": author,
        "genre": genre,
        "publisher": publisher,
        "published_date": published_date,
        "isbn": isbn,
        "pages": pages,
        "length_cm": length_cm,
        "width_cm": width_cm,
        "weight_gram": weight_gram,
        "original_price": original_price,
        "selling_price": selling_price,
        "synopsis": synopsis,
        "warranty": warranty,
        "metadata": metadata
    }

    book_id = payload.get("id")
    if book_id:
        db_row["id"] = str(book_id)

    return db_row


# ==============================================================================
# 2. STANDARD LIBRARY SUPABASE POSTGREST CLIENT
# ==============================================================================

class SupabaseClient:
    """
    Lightweight, production-grade Supabase PostgREST client implemented purely
    with Python Standard Library (urllib.request / json / ssl).
    Zero external dependencies required.
    """

    def __init__(self, url, key, timeout=8.0):
        self.url = (url or "").rstrip("/")
        self.key = (key or "").strip()
        self.timeout = timeout
        self.ssl_context = ssl.create_default_context()
        self.ssl_context.check_hostname = False
        self.ssl_context.verify_mode = ssl.CERT_NONE

    @property
    def is_configured(self):
        return bool(self.url and self.key)

    def _headers(self, extra=None):
        headers = {
            "apikey": self.key,
            "Authorization": f"Bearer {self.key}",
            "Content-Type": "application/json",
            "Accept": "application/json"
        }
        if extra:
            headers.update(extra)
        return headers

    def execute_request(self, method, endpoint, payload=None, extra_headers=None):
        """Executes an HTTP request against the Supabase PostgREST REST API."""
        if not self.is_configured:
            raise ConnectionError("Supabase credentials not configured (SUPABASE_URL or SUPABASE_KEY missing).")

        full_url = f"{self.url}/rest/v1/{endpoint.lstrip('/')}"
        data_bytes = None
        if payload is not None:
            data_bytes = json.dumps(payload, ensure_ascii=False).encode("utf-8")

        req = urllib.request.Request(
            full_url,
            data=data_bytes,
            headers=self._headers(extra_headers),
            method=method
        )

        start_time = time.time()
        try:
            with urllib.request.urlopen(req, timeout=self.timeout, context=self.ssl_context) as resp:
                elapsed = time.time() - start_time
                body_bytes = resp.read()
                logger.info(f"[SUPABASE] {method} {endpoint} -> HTTP {resp.status} ({elapsed:.3f}s)")
                if body_bytes:
                    return json.loads(body_bytes.decode("utf-8"))
                return None
        except urllib.error.HTTPError as he:
            elapsed = time.time() - start_time
            err_content = he.read().decode("utf-8", errors="replace")
            logger.error(f"[SUPABASE] HTTPError {he.code} on {method} {endpoint}: {err_content} ({elapsed:.3f}s)")
            raise RuntimeError(f"Supabase HTTP {he.code}: {err_content}") from he
        except (urllib.error.URLError, TimeoutError, OSError) as ue:
            elapsed = time.time() - start_time
            logger.error(f"[SUPABASE] Network/Timeout error on {method} {endpoint}: {ue} ({elapsed:.3f}s)")
            raise ConnectionError(f"Supabase handshake failed: {ue}") from ue

    def select_books(self):
        """Asynchronously executable SELECT * FROM books ORDER BY created_at DESC, title ASC."""
        return self.execute_request("GET", "books?select=*&order=created_at.desc.nullslast,title.asc")

    def upsert_book(self, db_row):
        """Inserts or updates a book in the cloud PostgreSQL table."""
        book_id = db_row.get("id")
        headers = {"Prefer": "return=representation"}

        # If id exists, check whether to update or insert
        if book_id:
            try:
                # Attempt to update via PATCH
                res = self.execute_request("PATCH", f"books?id=eq.{urllib.parse.quote(str(book_id))}", db_row, headers)
                if res and isinstance(res, list) and len(res) > 0:
                    return res[0]
            except Exception as e:
                logger.warning(f"[SUPABASE] PATCH update failed, falling back to POST: {e}")

        # Insert new record via POST
        res = self.execute_request("POST", "books", db_row, headers)
        if res and isinstance(res, list) and len(res) > 0:
            return res[0]
        return db_row

    def delete_book(self, book_id):
        """Deletes a book from the cloud PostgreSQL table."""
        headers = {"Prefer": "return=representation"}
        return self.execute_request("DELETE", f"books?id=eq.{urllib.parse.quote(str(book_id))}", extra_headers=headers)


# Initialize Global Supabase Client
supabase_client = SupabaseClient(SUPABASE_URL, SUPABASE_KEY, timeout=DB_TIMEOUT)
thread_pool = concurrent.futures.ThreadPoolExecutor(max_workers=8, thread_name_prefix="SupabaseWorker")


# ==============================================================================
# 3. LOCAL FILE FALLBACK STORAGE (Resilience Engine)
# ==============================================================================

def load_books_local():
    """Reads local books.json fallback data."""
    if not os.path.exists(BOOKS_FILE):
        return []
    try:
        with open(BOOKS_FILE, "r", encoding="utf-8") as f:
            data = json.load(f)
            return [map_db_to_book(item) for item in data]
    except Exception as e:
        logger.error(f"[LOCAL_FALLBACK] Error loading local books.json: {e}")
        return []


def save_books_local(books):
    """Saves books to local books.json fallback storage."""
    try:
        with open(BOOKS_FILE, "w", encoding="utf-8") as f:
            json.dump(books, f, indent=2, ensure_ascii=False)
    except Exception as e:
        logger.error(f"[LOCAL_FALLBACK] Error saving local books.json: {e}")


# ==============================================================================
# 4. HTTP REQUEST HANDLER (REST API & STATIC FILE SERVING)
# ==============================================================================

class TokobukuHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=BASE_DIR, **kwargs)

    def _send_json(self, data, status_code=200, extra_headers=None):
        response_bytes = json.dumps(data, ensure_ascii=False).encode("utf-8")
        self.send_response(status_code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(response_bytes)))
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, DELETE, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type, Authorization, X-Requested-With")
        if extra_headers:
            for k, v in extra_headers.items():
                self.send_header(k, v)
        self.end_headers()
        self.wfile.write(response_bytes)

    def do_OPTIONS(self):
        self.send_response(204)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, DELETE, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type, Authorization, X-Requested-With")
        self.end_headers()

    # --------------------------------------------------------------------------
    # GET Endpoints
    # --------------------------------------------------------------------------
    def do_GET(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path

        # Healthcheck Endpoint
        if path in ("/api/health", "/health"):
            is_cloud = supabase_client.is_configured
            self._send_json({
                "status": "UP",
                "service": "darussholah-tokobuku",
                "port": PORT,
                "database_mode": "cloud_supabase" if is_cloud else "local_fallback",
                "supabase_configured": is_cloud,
                "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
            })
            return

        # Fetch Book Catalog (Asynchronous Query with Fallback)
        if path == "/api/books":
            # Attempt Cloud Supabase Query asynchronously
            if supabase_client.is_configured:
                try:
                    future = thread_pool.submit(supabase_client.select_books)
                    raw_rows = future.result(timeout=DB_TIMEOUT)
                    mapped_books = [map_db_to_book(row) for row in (raw_rows or [])]
                    logger.info(f"[API] Retrieved {len(mapped_books)} books from Supabase cloud database.")

                    # Keep local cache warm
                    if mapped_books:
                        save_books_local(mapped_books)

                    self._send_json(
                        mapped_books,
                        extra_headers={"X-Database-Provider": "cloud-supabase-postgresql"}
                    )
                    return
                except Exception as err:
                    logger.warning(f"[API] Cloud Supabase query failed ({err}). Falling back to local store.")

            # Graceful Fallback to Local Storage
            local_books = load_books_local()
            self._send_json(
                local_books,
                extra_headers={"X-Database-Provider": "local-fallback"}
            )
            return

        # Fallback to standard static file serving
        super().do_GET()

    # --------------------------------------------------------------------------
    # POST Endpoints (Create & Update Books, Upload Covers)
    # --------------------------------------------------------------------------
    def do_POST(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path

        content_length = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(content_length)

        # Upsert Book
        if path == "/api/books":
            try:
                payload = json.loads(body.decode("utf-8"))
            except Exception as e:
                self._send_json({"success": False, "error": f"Invalid JSON payload: {e}"}, status_code=400)
                return

            saved_book = None
            db_provider = "local-fallback"

            # 1. Try Cloud Supabase Upsert
            if supabase_client.is_configured:
                try:
                    db_row = map_book_to_db(payload)
                    future = thread_pool.submit(supabase_client.upsert_book, db_row)
                    saved_row = future.result(timeout=DB_TIMEOUT)
                    saved_book = map_db_to_book(saved_row)
                    db_provider = "cloud-supabase-postgresql"
                    logger.info(f"[API] Successfully saved book '{saved_book.get('title')}' to Supabase cloud.")
                except Exception as err:
                    logger.error(f"[API] Supabase upsert error: {err}. Executing local fallback save.")

            # 2. Local Fallback Persistence
            local_books = load_books_local()
            if not saved_book:
                saved_book = map_db_to_book(payload)
                if not saved_book.get("id"):
                    saved_book["id"] = slugify(saved_book.get("title", f"buku-{int(time.time())}"))

            # Update in local list
            existing_idx = None
            for idx, b in enumerate(local_books):
                if b.get("id") == saved_book.get("id") or (saved_book.get("altId") and b.get("altId") == saved_book.get("altId")):
                    existing_idx = idx
                    break

            if existing_idx is not None:
                local_books[existing_idx] = {**local_books[existing_idx], **saved_book}
            else:
                local_books.insert(0, saved_book)

            save_books_local(local_books)

            self._send_json(
                {"success": True, "book": saved_book, "provider": db_provider},
                extra_headers={"X-Database-Provider": db_provider}
            )
            return

        # Upload Cover Image
        if path == "/api/upload":
            try:
                content_type = self.headers.get("Content-Type", "")
                if "application/json" in content_type:
                    upload_payload = json.loads(body.decode("utf-8"))
                    filename = upload_payload.get("filename", f"cover_{int(time.time())}.jpg")
                    data_str = upload_payload.get("data", "")

                    if "," in data_str:
                        _, b64data = data_str.split(",", 1)
                    else:
                        b64data = data_str

                    file_bytes = base64.b64decode(b64data)
                    clean_name = f"{int(time.time())}_{slugify(os.path.splitext(filename)[0])}{os.path.splitext(filename)[1]}"
                    target_path = os.path.join(UPLOADS_DIR, clean_name)

                    with open(target_path, "wb") as f:
                        f.write(file_bytes)

                    file_url = f"/uploads/{clean_name}"
                    self._send_json({"success": True, "url": file_url, "filename": clean_name})
                    return

                # Raw multipart / binary
                clean_name = f"upload_{int(time.time())}.jpg"
                target_path = os.path.join(UPLOADS_DIR, clean_name)
                with open(target_path, "wb") as f:
                    f.write(body)

                self._send_json({"success": True, "url": f"/uploads/{clean_name}", "filename": clean_name})
            except Exception as e:
                logger.error(f"[API] Upload error: {e}")
                self._send_json({"success": False, "error": str(e)}, status_code=400)
            return

        self._send_json({"error": "Not Found"}, status_code=404)

    # --------------------------------------------------------------------------
    # DELETE Endpoints
    # --------------------------------------------------------------------------
    def do_DELETE(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path

        if path.startswith("/api/books/"):
            target_id = path.replace("/api/books/", "").strip()
            db_provider = "local-fallback"

            # 1. Delete from Supabase
            if supabase_client.is_configured:
                try:
                    future = thread_pool.submit(supabase_client.delete_book, target_id)
                    future.result(timeout=DB_TIMEOUT)
                    db_provider = "cloud-supabase-postgresql"
                    logger.info(f"[API] Deleted book ID '{target_id}' from Supabase cloud.")
                except Exception as err:
                    logger.error(f"[API] Failed deleting from Supabase: {err}")

            # 2. Delete from local cache
            local_books = load_books_local()
            new_books = [b for b in local_books if b.get("id") != target_id and b.get("altId") != target_id]
            save_books_local(new_books)

            self._send_json(
                {"success": True, "deletedId": target_id, "provider": db_provider},
                extra_headers={"X-Database-Provider": db_provider}
            )
            return

        self._send_json({"error": "Not Found"}, status_code=404)


# ==============================================================================
# 5. SERVER ENTRYPOINT
# ==============================================================================

def run():
    server_address = (HOST, PORT)
    httpd = ThreadingHTTPServer(server_address, TokobukuHandler)
    db_mode = f"Supabase Cloud ({SUPABASE_URL})" if supabase_client.is_configured else "Local Storage (books.json)"
    logger.info(f"Darussholah Tokobuku Server active at http://localhost:{PORT}")
    logger.info(f"Database Mode: {db_mode}")
    logger.info(f"Healthcheck: http://localhost:{PORT}/api/health")

    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        logger.info("Server shutting down gracefully...")
        httpd.server_close()
        thread_pool.shutdown(wait=False)


if __name__ == "__main__":
    run()
