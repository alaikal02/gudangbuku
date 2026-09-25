#!/usr/bin/env python3
"""
DARUSSHOLAH - TOKOBUKU BACKEND SERVER
Cloud-Native Python Backend with Native Cloudflare D1 (SQLite) REST Client.
Optimized for Serverless Edge Runtimes and Cloudflare Container Environments.
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
from http.server import SimpleHTTPRequestHandler, HTTPServer

# Configure Structured Logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] [%(name)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)
logger = logging.getLogger("tokobuku.d1")

def _resolve_port():
    env_p = os.environ.get("PORT")
    if env_p and env_p.isdigit():
        return int(env_p)
    for arg in sys.argv[1:]:
        if arg.isdigit():
            return int(arg)
    return 8000

PORT = _resolve_port()
HOST = os.environ.get("HOST", "0.0.0.0")
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
BOOKS_FILE = os.path.join(BASE_DIR, "books.json")
UPLOADS_DIR = os.path.join(BASE_DIR, "uploads")

# Cloudflare D1 Database Credentials
CF_ACCOUNT_ID = os.environ.get("CLOUDFLARE_ACCOUNT_ID") or os.environ.get("CF_ACCOUNT_ID", "").strip()
CF_DATABASE_ID = os.environ.get("CLOUDFLARE_D1_DATABASE_ID") or os.environ.get("CF_D1_DATABASE_ID", "").strip()
CF_API_TOKEN = os.environ.get("CLOUDFLARE_API_TOKEN") or os.environ.get("CF_API_TOKEN", "").strip()
D1_TIMEOUT = float(os.environ.get("D1_TIMEOUT", 6.0))

os.makedirs(UPLOADS_DIR, exist_ok=True)


def slugify(text):
    text = text.lower().strip()
    text = re.sub(r"[^\w\s-]", "", text)
    text = re.sub(r"[\s_-]+", "-", text)
    return text.strip("-")


# ==============================================================================
# 1. DATA MAPPING ENGINE (Cloudflare D1 SQLite <-> Frontend Store Schema)
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
    Transforms a Cloudflare D1 SQLite row into the application book object.
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
    published_date = str(row.get("published_date") or raw_metadata.get("releaseDate") or "2026")
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

    marketplace_links = row.get("marketplace_links")
    if isinstance(marketplace_links, str):
        try:
            marketplace_links = json.loads(marketplace_links)
        except Exception:
            marketplace_links = None
    if not marketplace_links:
        marketplace_links = raw_metadata.get("marketplace_links") or {
            "shopee": raw_metadata.get("shopee"),
            "tokopedia": raw_metadata.get("tokopedia"),
            "whatsapp_sales": raw_metadata.get("whatsapp_sales")
        }

    # Calculate discount
    discount = 0
    if original_price > selling_price and original_price > 0:
        discount = round(((original_price - selling_price) / original_price) * 100)

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
    Transforms payload received from frontend/admin into Cloudflare D1 row format.
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

    format_val = payload.get("format", "print")
    status_val = payload.get("status", "normal")
    cover_img_val = payload.get("coverImg", "")
    cover_class_val = payload.get("coverClass", "")

    metadata = {
        "format": format_val,
        "status": status_val,
        "coverImg": cover_img_val,
        "coverClass": cover_class_val,
        "marketplace_links": payload.get("marketplace_links", {}),
        "language": specs.get("language", "Indonesia & Arab"),
        "samplePages": payload.get("samplePages", []),
        "thickness_cm": thickness_cm,
        "altId": payload.get("altId") or f"{slugify(title)}-saku"
    }

    book_id = str(payload.get("id") or slugify(title))

    return {
        "id": book_id,
        "title": title,
        "author": author,
        "genre": genre,
        "publisher": publisher,
        "published_date": published_date,
        "isbn": isbn,
        "pages": pages,
        "length_cm": length_cm,
        "width_cm": width_cm,
        "thickness_cm": thickness_cm,
        "weight_gram": weight_gram,
        "original_price": original_price,
        "selling_price": selling_price,
        "synopsis": synopsis,
        "warranty": warranty,
        "format": format_val,
        "status": status_val,
        "cover_img": cover_img_val,
        "cover_class": cover_class_val,
        "metadata": json.dumps(metadata, ensure_ascii=False)
    }


# ==============================================================================
# 2. CLOUDFLARE D1 REST API CLIENT (Zero-Dependency Standard Library)
# ==============================================================================

class CloudflareD1Client:
    """
    Lightweight, production-ready Cloudflare D1 Database Client.
    Communicates directly with Cloudflare D1 v4 REST API via standard library urllib.
    Non-blocking, serverless-friendly, and thread-leak free.
    """

    def __init__(self, account_id, database_id, api_token, timeout=6.0):
        self.account_id = (account_id or "").strip()
        self.database_id = (database_id or "").strip()
        self.api_token = (api_token or "").strip()
        self.timeout = timeout
        self.ssl_context = ssl.create_default_context()

    @property
    def is_configured(self):
        return bool(self.account_id and self.database_id and self.api_token)

    def execute_query(self, sql, params=None):
        """
        Executes a SQL statement on Cloudflare D1 via the Cloudflare REST API.
        Endpoint: POST /client/v4/accounts/{account_id}/d1/database/{database_id}/query
        """
        if not self.is_configured:
            raise ConnectionError("Cloudflare D1 credentials missing (CLOUDFLARE_ACCOUNT_ID, CLOUDFLARE_D1_DATABASE_ID, or CLOUDFLARE_API_TOKEN).")

        url = f"https://api.cloudflare.com/client/v4/accounts/{self.account_id}/d1/database/{self.database_id}/query"
        payload = {
            "sql": sql,
            "params": params or []
        }

        body_bytes = json.dumps(payload).encode("utf-8")
        headers = {
            "Authorization": f"Bearer {self.api_token}",
            "Content-Type": "application/json",
            "Accept": "application/json"
        }

        req = urllib.request.Request(url, data=body_bytes, headers=headers, method="POST")
        start_time = time.time()

        try:
            with urllib.request.urlopen(req, timeout=self.timeout, context=self.ssl_context) as resp:
                elapsed = time.time() - start_time
                res_data = json.loads(resp.read().decode("utf-8"))
                logger.info(f"[CLOUDFLARE_D1] Query OK ({elapsed:.3f}s)")

                if not res_data.get("success"):
                    errors = res_data.get("errors", [])
                    raise RuntimeError(f"Cloudflare D1 query error: {errors}")

                # D1 returns results in result[0].results
                result_array = res_data.get("result", [])
                if result_array and isinstance(result_array, list):
                    return result_array[0].get("results", [])
                return []
        except urllib.error.HTTPError as he:
            elapsed = time.time() - start_time
            err_content = he.read().decode("utf-8", errors="replace")
            logger.error(f"[CLOUDFLARE_D1] HTTPError {he.code}: {err_content} ({elapsed:.3f}s)")
            raise RuntimeError(f"Cloudflare D1 HTTP {he.code}: {err_content}") from he
        except (urllib.error.URLError, TimeoutError, OSError) as ue:
            elapsed = time.time() - start_time
            logger.error(f"[CLOUDFLARE_D1] Connection/Timeout error: {ue} ({elapsed:.3f}s)")
            raise ConnectionError(f"Cloudflare D1 handshake failed: {ue}") from ue

    def select_books(self):
        """Queries the 'books' table on the Cloudflare D1 instance."""
        sql = """
            SELECT id, title, author, genre, publisher, published_date, isbn,
                   pages, length_cm, width_cm, thickness_cm, weight_gram,
                   original_price, selling_price, synopsis, warranty,
                   format, status, cover_img, cover_class, metadata
            FROM books
            ORDER BY created_at DESC, title ASC
        """
        return self.execute_query(sql)

    def upsert_book(self, row):
        """
        Inserts or updates a book record in Cloudflare D1 SQLite.
        Uses SQLite native UPSERT: INSERT INTO ... ON CONFLICT(id) DO UPDATE SET ...
        """
        sql = """
            INSERT INTO books (
                id, title, author, genre, publisher, published_date, isbn,
                pages, length_cm, width_cm, thickness_cm, weight_gram,
                original_price, selling_price, synopsis, warranty,
                format, status, cover_img, cover_class, metadata, updated_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, datetime('now'))
            ON CONFLICT(id) DO UPDATE SET
                title = excluded.title,
                author = excluded.author,
                genre = excluded.genre,
                publisher = excluded.publisher,
                published_date = excluded.published_date,
                isbn = excluded.isbn,
                pages = excluded.pages,
                length_cm = excluded.length_cm,
                width_cm = excluded.width_cm,
                thickness_cm = excluded.thickness_cm,
                weight_gram = excluded.weight_gram,
                original_price = excluded.original_price,
                selling_price = excluded.selling_price,
                synopsis = excluded.synopsis,
                warranty = excluded.warranty,
                format = excluded.format,
                status = excluded.status,
                cover_img = excluded.cover_img,
                cover_class = excluded.cover_class,
                metadata = excluded.metadata,
                updated_at = datetime('now')
        """
        params = [
            row["id"], row["title"], row["author"], row["genre"], row["publisher"],
            row["published_date"], row["isbn"], row["pages"], row["length_cm"],
            row["width_cm"], row["thickness_cm"], row["weight_gram"],
            row["original_price"], row["selling_price"], row["synopsis"],
            row["warranty"], row["format"], row["status"], row["cover_img"],
            row["cover_class"], row["metadata"]
        ]
        self.execute_query(sql, params)
        return row

    def delete_book(self, book_id):
        """Deletes a book by ID from Cloudflare D1."""
        sql = "DELETE FROM books WHERE id = ?"
        self.execute_query(sql, [str(book_id)])

    def check_table_exists(self, table_name="books"):
        """Validates if 'books' table exists within the Cloudflare D1 database."""
        try:
            sql = "SELECT name FROM sqlite_master WHERE type='table' AND name = ?"
            res = self.execute_query(sql, [table_name])
            return bool(res and len(res) > 0)
        except Exception as e:
            logger.warning(f"[CLOUDFLARE_D1] Table existence check warning: {e}")
            return False

    def count_books(self):
        """Returns the total number of records currently in the 'books' table."""
        try:
            sql = "SELECT COUNT(*) as count FROM books"
            res = self.execute_query(sql)
            if res and len(res) > 0:
                return int(res[0].get("count", 0))
            return 0
        except Exception as e:
            logger.warning(f"[CLOUDFLARE_D1] Book count query warning: {e}")
            return 0

    def init_schema(self):
        """
        Executes automated D1 schema migration.
        Explicitly maps out all 14 required product fields:
        title (TEXT), author (TEXT), genre (TEXT), publisher (TEXT),
        published_date (TEXT), isbn (TEXT), pages (INTEGER), length_cm (INTEGER),
        width_cm (INTEGER), weight_gram (INTEGER), original_price (INTEGER),
        selling_price (INTEGER), synopsis (TEXT), and warranty (TEXT).
        """
        sql_table = """
            CREATE TABLE IF NOT EXISTS books (
                id TEXT PRIMARY KEY,
                title TEXT NOT NULL,
                author TEXT NOT NULL,
                genre TEXT NOT NULL DEFAULT 'umum',
                publisher TEXT NOT NULL DEFAULT 'Darussholah',
                published_date TEXT NOT NULL DEFAULT '2026',
                isbn TEXT NOT NULL DEFAULT 'Belum Terdaftar',
                pages INTEGER NOT NULL DEFAULT 180,
                length_cm INTEGER NOT NULL DEFAULT 21,
                width_cm INTEGER NOT NULL DEFAULT 14,
                thickness_cm REAL NOT NULL DEFAULT 1.5,
                weight_gram INTEGER NOT NULL DEFAULT 200,
                original_price INTEGER NOT NULL DEFAULT 0,
                selling_price INTEGER NOT NULL DEFAULT 0,
                synopsis TEXT NOT NULL DEFAULT '',
                warranty TEXT NOT NULL DEFAULT 'Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.',
                format TEXT NOT NULL DEFAULT 'print',
                status TEXT NOT NULL DEFAULT 'normal',
                cover_img TEXT DEFAULT '',
                cover_class TEXT DEFAULT '',
                metadata TEXT DEFAULT '{}',
                created_at TEXT DEFAULT (datetime('now')),
                updated_at TEXT DEFAULT (datetime('now'))
            );
        """
        self.execute_query(sql_table)
        self.execute_query("CREATE INDEX IF NOT EXISTS idx_books_isbn ON books(isbn);")
        self.execute_query("CREATE INDEX IF NOT EXISTS idx_books_genre ON books(genre);")
        self.execute_query("CREATE INDEX IF NOT EXISTS idx_books_created_at ON books(created_at DESC);")
        logger.info("[CLOUDFLARE_D1] Automated schema migration: 'books' table & indexes initialized.")

    def seed_initial_books(self):
        """
        Performs automated bulk seeding for all 6 catalog data models
        (Pengantar Kaidah Fiqh, Ta'lim Muta'allim, Ilmu Sharaf,
        Fathul Qorib Zaman Now, Asma'ul Husna, Menyingkap Sejuta Permasalahan Fath al-Qarib).
        """
        logger.info(f"[CLOUDFLARE_D1] Initiating automated bulk seeding ({len(DEFAULT_SEEDED_BOOKS)} catalog models)...")
        seeded_count = 0
        for book in DEFAULT_SEEDED_BOOKS:
            db_row = map_book_to_db(book)
            self.upsert_book(db_row)
            seeded_count += 1
        logger.info(f"[CLOUDFLARE_D1] Bulk data seeding complete: {seeded_count} records inserted.")
        return seeded_count

    def ensure_schema_and_seed(self):
        """
        Startup Validation Check:
        1. Validates table existence; auto-executes schema migration if missing.
        2. Validates record count; if newly created and empty, bulk-inserts all 6 catalog books.
        Stateless, serverless-safe, and runs completely in the background.
        """
        if not self.is_configured:
            logger.info("[CLOUDFLARE_D1] Credentials not set. Automated D1 validation skipped.")
            return {"status": "SKIPPED", "reason": "No credentials configured"}

        try:
            has_table = self.check_table_exists("books")
            if not has_table:
                logger.info("[CLOUDFLARE_D1] 'books' table not detected. Starting schema initialization...")
                self.init_schema()

            count = self.count_books()
            if count == 0:
                logger.info("[CLOUDFLARE_D1] 'books' table is empty. Executing automated bulk seeding...")
                seeded = self.seed_initial_books()
                return {"status": "INITIALIZED_AND_SEEDED", "seeded": seeded}

            logger.info(f"[CLOUDFLARE_D1] Startup validation confirmed. 'books' table active with {count} records.")
            return {"status": "READY", "count": count}
        except Exception as e:
            logger.warning(f"[CLOUDFLARE_D1] Schema handshake notice: {e}")
            return {"status": "ERROR", "error": str(e)}


# ==============================================================================
# 2.1 CATALOG DATA SEEDING MODELS (6 Production Books)
# ==============================================================================

DEFAULT_SEEDED_BOOKS = [
    {
        "id": "pengantar-kaidah-fiqh",
        "altId": "pengantar-kaidah-fiqh-saku",
        "title": "Pengantar Kaidah Fiqh",
        "author": "K.H. A. Yasin Asymuni",
        "genre": "fiqih",
        "publisher": "Darussholah",
        "published_date": "2026",
        "isbn": "978-602-0853-26-6",
        "pages": 120,
        "length_cm": 21,
        "width_cm": 14,
        "thickness_cm": 1.2,
        "weight_gram": 150,
        "original_price": 50000,
        "selling_price": 45000,
        "synopsis": "Penjelasan sistematis seputar kaidah-kaidah fikih penting (Qawa'id Fiqhiyyah) madzhab Syafi'i untuk membimbing santri dalam memahami dasar penetapan hukum Islam dan menganalisis persoalan-persoalan kontemporer.",
        "warranty": "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.",
        "format": "print",
        "status": "new",
        "cover_img": "",
        "cover_class": "bg-gradient-to-br from-emerald-900 via-teal-900 to-emerald-950",
        "marketplace_links": {"tokopedia": "https://tokopedia.com", "shopee": "https://shopee.co.id", "whatsapp_sales": "https://wa.me"}
    },
    {
        "id": "terjemah-ta-lim-muta-allim",
        "altId": "terjemah-talimul-mutaallim-saku",
        "title": "Ta'lim Muta'allim",
        "author": "Syaikh Az-Zarnuji",
        "genre": "akhlak",
        "publisher": "Darussholah",
        "published_date": "2026",
        "isbn": "978-602-0853-27-3",
        "pages": 180,
        "length_cm": 21,
        "width_cm": 14,
        "thickness_cm": 1.5,
        "weight_gram": 200,
        "original_price": 65000,
        "selling_price": 65000,
        "synopsis": "Kitab rujukan paling otentik seputar etika belajar, memilih guru, memilih teman, adab terhadap ilmu dan penghormatan kepada ustadz agar ilmu yang didapatkan berkah dan bermanfaat di dunia maupun akhirat.",
        "warranty": "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.",
        "format": "print",
        "status": "normal",
        "cover_img": "",
        "cover_class": "bg-gradient-to-br from-stone-900 via-amber-950 to-stone-950",
        "marketplace_links": {"tokopedia": "https://tokopedia.com", "shopee": "https://shopee.co.id", "whatsapp_sales": "https://wa.me"}
    },
    {
        "id": "nadham-qaidah-sharfiyyah",
        "altId": "nadham-qaidah-sharfiyyah-saku",
        "title": "Ilmu Sharaf",
        "author": "K.H. M. Anwar",
        "genre": "tatabahasa",
        "publisher": "Darussholah",
        "published_date": "2026",
        "isbn": "978-602-0853-20-4",
        "pages": 96,
        "length_cm": 14,
        "width_cm": 10,
        "thickness_cm": 1.0,
        "weight_gram": 120,
        "original_price": 55000,
        "selling_price": 55000,
        "synopsis": "Buku saku praktis yang memuat kaidah ilmu sharaf dan bait-bait Nadham Qaidah Sharfiyyah untuk memudahkan para santri menghafal dan memahami perubahan kata (tashrif) dalam tata bahasa Arab secara cepat.",
        "warranty": "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.",
        "format": "print",
        "status": "bestseller",
        "cover_img": "",
        "cover_class": "bg-gradient-to-br from-indigo-950 via-slate-900 to-indigo-900",
        "marketplace_links": {"tokopedia": "https://tokopedia.com", "shopee": "https://shopee.co.id", "whatsapp_sales": "https://wa.me"}
    },
    {
        "id": "trjmh-f-qorib-zaman-now",
        "altId": "trjmh-fqorib-zaman-now-saku",
        "title": "Fathul Qorib Zaman Now",
        "author": "Tim Redaksi Darussholah",
        "genre": "fiqih",
        "publisher": "Darussholah",
        "published_date": "2026",
        "isbn": "978-602-0853-21-1",
        "pages": 180,
        "length_cm": 14,
        "width_cm": 10,
        "thickness_cm": 1.5,
        "weight_gram": 180,
        "original_price": 75000,
        "selling_price": 60000,
        "synopsis": "Terjemah Kitab Fathul Qorib Al-Mujib yang disajikan secara kekinian dengan bahasa yang mudah dicerna oleh generasi millenial dan santri era digital, tanpa mengurangi orisinalitas hukum fikih Syafi'iyah.",
        "warranty": "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.",
        "format": "print",
        "status": "new",
        "cover_img": "",
        "cover_class": "bg-gradient-to-br from-emerald-900 via-green-900 to-stone-900",
        "marketplace_links": {"tokopedia": "https://tokopedia.com", "shopee": "https://shopee.co.id", "whatsapp_sales": "https://wa.me"}
    },
    {
        "id": "cerita-indah-dibalik-asmaul-husna",
        "altId": "cerita-indah-dibalik-asmaul-husna-saku",
        "title": "Asma'ul Husna",
        "author": "K.H. Mustofa Bisri / Tim Darussholah",
        "genre": "aqidah",
        "publisher": "Darussholah",
        "published_date": "2026",
        "isbn": "978-602-0853-25-9",
        "pages": 240,
        "length_cm": 20,
        "width_cm": 14,
        "thickness_cm": 2.0,
        "weight_gram": 290,
        "original_price": 150000,
        "selling_price": 140000,
        "synopsis": "Buku inspiratif yang mengisahkan cerita indah di balik makna 99 Nama Allah (Asma'ul Husna) berdasarkan kitab Al-Maqshodul Asna Fi Syarhi Asma'illahil Husna karya Imam Al-Ghazali, memudahkan santri membumikan tauhid dan akhlak ilahiyah dalam kehidupan sehari-hari.",
        "warranty": "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.",
        "format": "print",
        "status": "bestseller",
        "cover_img": "/uploads/1790069869_cidbah-depan-siap.png",
        "cover_class": "",
        "marketplace_links": {"tokopedia": "https://tokopedia.com", "shopee": "https://shopee.co.id", "whatsapp_sales": "https://wa.me"}
    },
    {
        "id": "menyingkap-fathal-qarib",
        "altId": "menyingkap-sejuta-permasalahan-fath-al-qarib-saku",
        "title": "Menyingkap Sejuta Permasalahan Fath al-Qarib",
        "author": "Lembaga Kajian Fikih Darussholah",
        "genre": "fiqih",
        "publisher": "Darussholah",
        "published_date": "2026",
        "isbn": "978-602-0853-22-8",
        "pages": 310,
        "length_cm": 21,
        "width_cm": 14,
        "thickness_cm": 2.2,
        "weight_gram": 350,
        "original_price": 120000,
        "selling_price": 120000,
        "synopsis": "Kajian komprehensif fikih Syafi'iyah yang menyingkap tuntas berbagai problematika ibadah dan muamalah harian berdasarkan matan Taqrib dan Syarah Fath al-Qarib dengan ulasan fatwa lintas mazhab yang otoritatif.",
        "warranty": "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.",
        "format": "print",
        "status": "bestseller",
        "cover_img": "",
        "cover_class": "bg-gradient-to-br from-emerald-950 via-green-950 to-emerald-900",
        "marketplace_links": {"tokopedia": "https://tokopedia.com", "shopee": "https://shopee.co.id", "whatsapp_sales": "https://wa.me"}
    }
]


# Initialize Global Cloudflare D1 Client
d1_client = CloudflareD1Client(CF_ACCOUNT_ID, CF_DATABASE_ID, CF_API_TOKEN, timeout=D1_TIMEOUT)


def verify_local_database_handshake():
    """
    Validates the database schema handshake logic locally using Python standard library sqlite3.
    Ensures that the exact table structure and bulk seeding behave deterministically.
    """
    import sqlite3
    db_test_path = os.path.join(BASE_DIR, "test_handshake.db")
    try:
        conn = sqlite3.connect(db_test_path)
        cur = conn.cursor()
        cur.execute("""
            CREATE TABLE IF NOT EXISTS books (
                id TEXT PRIMARY KEY,
                title TEXT NOT NULL,
                author TEXT NOT NULL,
                genre TEXT NOT NULL DEFAULT 'umum',
                publisher TEXT NOT NULL DEFAULT 'Darussholah',
                published_date TEXT NOT NULL DEFAULT '2026',
                isbn TEXT NOT NULL DEFAULT 'Belum Terdaftar',
                pages INTEGER NOT NULL DEFAULT 180,
                length_cm INTEGER NOT NULL DEFAULT 21,
                width_cm INTEGER NOT NULL DEFAULT 14,
                thickness_cm REAL NOT NULL DEFAULT 1.5,
                weight_gram INTEGER NOT NULL DEFAULT 200,
                original_price INTEGER NOT NULL DEFAULT 0,
                selling_price INTEGER NOT NULL DEFAULT 0,
                synopsis TEXT NOT NULL DEFAULT '',
                warranty TEXT NOT NULL DEFAULT 'Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.',
                format TEXT NOT NULL DEFAULT 'print',
                status TEXT NOT NULL DEFAULT 'normal',
                cover_img TEXT DEFAULT '',
                cover_class TEXT DEFAULT '',
                metadata TEXT DEFAULT '{}',
                created_at TEXT DEFAULT (datetime('now')),
                updated_at TEXT DEFAULT (datetime('now'))
            );
        """)
        for b in DEFAULT_SEEDED_BOOKS:
            db_row = map_book_to_db(b)
            cur.execute("""
                INSERT OR REPLACE INTO books (
                    id, title, author, genre, publisher, published_date, isbn,
                    pages, length_cm, width_cm, thickness_cm, weight_gram,
                    original_price, selling_price, synopsis, warranty,
                    format, status, cover_img, cover_class, metadata
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                db_row["id"], db_row["title"], db_row["author"], db_row["genre"], db_row["publisher"],
                db_row["published_date"], db_row["isbn"], db_row["pages"], db_row["length_cm"],
                db_row["width_cm"], db_row["thickness_cm"], db_row["weight_gram"],
                db_row["original_price"], db_row["selling_price"], db_row["synopsis"],
                db_row["warranty"], db_row["format"], db_row["status"], db_row["cover_img"],
                db_row["cover_class"], db_row["metadata"]
            ))
        conn.commit()
        cur.execute("SELECT COUNT(*) FROM books")
        count = cur.fetchone()[0]
        cur.execute("SELECT id, title, length_cm, width_cm, weight_gram, selling_price FROM books")
        rows = cur.fetchall()
        conn.close()
        if os.path.exists(db_test_path):
            os.remove(db_test_path)
        logger.info(f"[HANDSHAKE_TEST] Local SQLite handshake OK: {count} books seeded.")
        return {"success": True, "count": count, "rows": rows}
    except Exception as err:
        logger.error(f"[HANDSHAKE_TEST] Local handshake test failed: {err}")
        if os.path.exists(db_test_path):
            try:
                os.remove(db_test_path)
            except Exception:
                pass
        return {"success": False, "error": str(err)}


def init_database_handshake():
    """
    Automated startup validation check and schema handshake.
    If D1 credentials are set, ensures table exists and seeds 6 catalog books.
    If local fallback, ensures books.json has the 6 catalog books.
    Runs silently without breaking stateless serverless handlers.
    """
    logger.info("[STARTUP] Initializing database handshake and automated schema validation...")
    if d1_client.is_configured:
        d1_result = d1_client.ensure_schema_and_seed()
        logger.info(f"[STARTUP] Cloudflare D1 Handshake: {d1_result}")
    else:
        logger.info("[STARTUP] Cloudflare D1 credentials not supplied in environment. Validating local fallback storage...")
        local_books = load_books_local()
        if not local_books:
            logger.info(f"[STARTUP] Local fallback empty. Seeding {len(DEFAULT_SEEDED_BOOKS)} catalog models...")
            seeded = [map_db_to_book(map_book_to_db(b)) for b in DEFAULT_SEEDED_BOOKS]
            save_books_local(seeded)
            logger.info("[STARTUP] Local fallback storage initialized.")


# ==============================================================================
# 3. LOCAL FALLBACK STORAGE (Reliability & Offline Guard)
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
# 4. SERVERLESS-COMPATIBLE HTTP HANDLER
# ==============================================================================

class TokobukuHandler(SimpleHTTPRequestHandler):
    """
    Lightweight, synchronous, non-blocking HTTP request handler.
    Complies with serverless and containerized edge execution environments.
    """

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
            is_d1 = d1_client.is_configured
            self._send_json({
                "status": "UP",
                "service": "darussholah-tokobuku",
                "port": PORT,
                "database_mode": "cloudflare_d1_sqlite" if is_d1 else "local_fallback",
                "cloudflare_d1_configured": is_d1,
                "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
            })
            return

        # Fetch Book Catalog (Cloudflare D1 Query with Fallback)
        if path == "/api/books":
            if d1_client.is_configured:
                try:
                    raw_rows = d1_client.select_books()
                    mapped_books = [map_db_to_book(row) for row in (raw_rows or [])]
                    logger.info(f"[API] Retrieved {len(mapped_books)} books from Cloudflare D1.")

                    # Keep local cache warm
                    if mapped_books:
                        save_books_local(mapped_books)

                    self._send_json(
                        mapped_books,
                        extra_headers={"X-Database-Provider": "cloudflare-d1-sqlite"}
                    )
                    return
                except Exception as err:
                    logger.warning(f"[API] Cloudflare D1 query failed ({err}). Falling back to local storage.")

            # Graceful Fallback
            local_books = load_books_local()
            self._send_json(
                local_books,
                extra_headers={"X-Database-Provider": "local-fallback"}
            )
            return

        # Fallback to static asset serving
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

            # 1. Attempt Cloudflare D1 Upsert
            if d1_client.is_configured:
                try:
                    db_row = map_book_to_db(payload)
                    d1_client.upsert_book(db_row)
                    saved_book = map_db_to_book(db_row)
                    db_provider = "cloudflare-d1-sqlite"
                    logger.info(f"[API] Successfully saved book '{saved_book.get('title')}' to Cloudflare D1.")
                except Exception as err:
                    logger.error(f"[API] Cloudflare D1 upsert error: {err}. Executing local fallback save.")

            # 2. Local Fallback Persistence
            local_books = load_books_local()
            if not saved_book:
                saved_book = map_db_to_book(payload)
                if not saved_book.get("id"):
                    saved_book["id"] = slugify(saved_book.get("title", f"buku-{int(time.time())}"))

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

            # 1. Delete from Cloudflare D1
            if d1_client.is_configured:
                try:
                    d1_client.delete_book(target_id)
                    db_provider = "cloudflare-d1-sqlite"
                    logger.info(f"[API] Deleted book ID '{target_id}' from Cloudflare D1.")
                except Exception as err:
                    logger.error(f"[API] Failed deleting from Cloudflare D1: {err}")

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
    # 1. Startup Database Validation & Handshake Check
    init_database_handshake()

    server_address = (HOST, PORT)
    httpd = HTTPServer(server_address, TokobukuHandler)
    db_mode = f"Cloudflare D1 SQLite ({CF_DATABASE_ID})" if d1_client.is_configured else "Local Storage (books.json)"
    logger.info(f"Darussholah Tokobuku Server active at http://{HOST or 'localhost'}:{PORT}")
    logger.info(f"Database Mode: {db_mode}")
    logger.info(f"Healthcheck: http://{HOST or 'localhost'}:{PORT}/api/health")

    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        logger.info("Server shutting down cleanly...")
        httpd.server_close()


if __name__ == "__main__":
    if "--verify-handshake" in sys.argv:
        test_res = verify_local_database_handshake()
        print(json.dumps(test_res, indent=2))
        sys.exit(0 if test_res.get("success") else 1)
    run()
