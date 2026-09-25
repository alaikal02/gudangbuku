/**
 * Darussholah Tokobuku - Cloudflare Edge Worker
 * Serverless API router with Cloudflare D1 Database integration
 * and native Workers Static Assets serving.
 */

// 6 Production Catalog Models for Automated Bulk Seeding
const DEFAULT_SEEDED_BOOKS = [
  {
    id: "pengantar-kaidah-fiqh",
    altId: "pengantar-kaidah-fiqh-saku",
    title: "Pengantar Kaidah Fiqh",
    author: "K.H. A. Yasin Asymuni",
    genre: "fiqih",
    publisher: "Darussholah",
    published_date: "2026",
    isbn: "978-602-0853-26-6",
    pages: 120,
    length_cm: 21,
    width_cm: 14,
    thickness_cm: 1.2,
    weight_gram: 150,
    original_price: 50000,
    selling_price: 45000,
    synopsis: "Penjelasan sistematis seputar kaidah-kaidah fikih penting (Qawa'id Fiqhiyyah) madzhab Syafi'i untuk membimbing santri dalam memahami dasar penetapan hukum Islam dan menganalisis persoalan-persoalan kontemporer.",
    warranty: "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.",
    format: "print",
    status: "new",
    cover_img: "",
    cover_class: "bg-gradient-to-br from-emerald-900 via-teal-900 to-emerald-950",
    marketplace_links: { tokopedia: "https://tokopedia.com", shopee: "https://shopee.co.id", whatsapp_sales: "https://wa.me" }
  },
  {
    id: "terjemah-ta-lim-muta-allim",
    altId: "terjemah-talimul-mutaallim-saku",
    title: "Ta'lim Muta'allim",
    author: "Syaikh Az-Zarnuji",
    genre: "akhlak",
    publisher: "Darussholah",
    published_date: "2026",
    isbn: "978-602-0853-27-3",
    pages: 180,
    length_cm: 21,
    width_cm: 14,
    thickness_cm: 1.5,
    weight_gram: 200,
    original_price: 65000,
    selling_price: 65000,
    synopsis: "Kitab rujukan paling otentik seputar etika belajar, memilih guru, memilih teman, adab terhadap ilmu dan penghormatan kepada ustadz agar ilmu yang didapatkan berkah dan bermanfaat di dunia maupun akhirat.",
    warranty: "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.",
    format: "print",
    status: "normal",
    cover_img: "",
    cover_class: "bg-gradient-to-br from-stone-900 via-amber-950 to-stone-950",
    marketplace_links: { tokopedia: "https://tokopedia.com", shopee: "https://shopee.co.id", whatsapp_sales: "https://wa.me" }
  },
  {
    id: "nadham-qaidah-sharfiyyah",
    altId: "nadham-qaidah-sharfiyyah-saku",
    title: "Ilmu Sharaf",
    author: "K.H. M. Anwar",
    genre: "tatabahasa",
    publisher: "Darussholah",
    published_date: "2026",
    isbn: "978-602-0853-20-4",
    pages: 96,
    length_cm: 14,
    width_cm: 10,
    thickness_cm: 1.0,
    weight_gram: 120,
    original_price: 55000,
    selling_price: 55000,
    synopsis: "Buku saku praktis yang memuat kaidah ilmu sharaf dan bait-bait Nadham Qaidah Sharfiyyah untuk memudahkan para santri menghafal dan memahami perubahan kata (tashrif) dalam tata bahasa Arab secara cepat.",
    warranty: "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.",
    format: "print",
    status: "bestseller",
    cover_img: "",
    cover_class: "bg-gradient-to-br from-indigo-950 via-slate-900 to-indigo-900",
    marketplace_links: { tokopedia: "https://tokopedia.com", shopee: "https://shopee.co.id", whatsapp_sales: "https://wa.me" }
  },
  {
    id: "trjmh-f-qorib-zaman-now",
    altId: "trjmh-fqorib-zaman-now-saku",
    title: "Fathul Qorib Zaman Now",
    author: "Tim Redaksi Darussholah",
    genre: "fiqih",
    publisher: "Darussholah",
    published_date: "2026",
    isbn: "978-602-0853-21-1",
    pages: 180,
    length_cm: 14,
    width_cm: 10,
    thickness_cm: 1.5,
    weight_gram: 180,
    original_price: 75000,
    selling_price: 60000,
    synopsis: "Terjemah Kitab Fathul Qorib Al-Mujib yang disajikan secara kekinian dengan bahasa yang mudah dicerna oleh generasi millenial dan santri era digital, tanpa mengurangi orisinalitas hukum fikih Syafi'iyah.",
    warranty: "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.",
    format: "print",
    status: "new",
    cover_img: "",
    cover_class: "bg-gradient-to-br from-emerald-900 via-green-900 to-stone-900",
    marketplace_links: { tokopedia: "https://tokopedia.com", shopee: "https://shopee.co.id", whatsapp_sales: "https://wa.me" }
  },
  {
    id: "cerita-indah-dibalik-asmaul-husna",
    altId: "cerita-indah-dibalik-asmaul-husna-saku",
    title: "Asma'ul Husna",
    author: "K.H. Mustofa Bisri / Tim Darussholah",
    genre: "aqidah",
    publisher: "Darussholah",
    published_date: "2026",
    isbn: "978-602-0853-25-9",
    pages: 240,
    length_cm: 20,
    width_cm: 14,
    thickness_cm: 2.0,
    weight_gram: 290,
    original_price: 150000,
    selling_price: 140000,
    synopsis: "Buku inspiratif yang mengisahkan cerita indah di balik makna 99 Nama Allah (Asma'ul Husna) berdasarkan kitab Al-Maqshodul Asna Fi Syarhi Asma'illahil Husna karya Imam Al-Ghazali, memudahkan santri membumikan tauhid dan akhlak ilahiyah dalam kehidupan sehari-hari.",
    warranty: "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.",
    format: "print",
    status: "bestseller",
    cover_img: "/uploads/1790069869_cidbah-depan-siap.png",
    cover_class: "",
    marketplace_links: { tokopedia: "https://tokopedia.com", shopee: "https://shopee.co.id", whatsapp_sales: "https://wa.me" }
  },
  {
    id: "menyingkap-fathal-qarib",
    altId: "menyingkap-sejuta-permasalahan-fath-al-qarib-saku",
    title: "Menyingkap Sejuta Permasalahan Fath al-Qarib",
    author: "Lembaga Kajian Fikih Darussholah",
    genre: "fiqih",
    publisher: "Darussholah",
    published_date: "2026",
    isbn: "978-602-0853-22-8",
    pages: 310,
    length_cm: 21,
    width_cm: 14,
    thickness_cm: 2.2,
    weight_gram: 350,
    original_price: 120000,
    selling_price: 120000,
    synopsis: "Kajian komprehensif fikih Syafi'iyah yang menyingkap tuntas berbagai problematika ibadah dan muamalah harian berdasarkan matan Taqrib dan Syarah Fath al-Qarib dengan ulasan fatwa lintas mazhab yang otoritatif.",
    warranty: "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.",
    format: "print",
    status: "bestseller",
    cover_img: "",
    cover_class: "bg-gradient-to-br from-emerald-950 via-green-950 to-emerald-900",
    marketplace_links: { tokopedia: "https://tokopedia.com", shopee: "https://shopee.co.id", whatsapp_sales: "https://wa.me" }
  }
];

let d1Initialized = false;

async function ensureD1Initialized(db) {
  if (d1Initialized || !db) return;
  try {
    const tableCheck = await db.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name='books'").first();
    if (!tableCheck) {
      await db.batch([
        db.prepare(`
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
        `),
        db.prepare("CREATE INDEX IF NOT EXISTS idx_books_isbn ON books(isbn);"),
        db.prepare("CREATE INDEX IF NOT EXISTS idx_books_genre ON books(genre);"),
        db.prepare("CREATE INDEX IF NOT EXISTS idx_books_created_at ON books(created_at DESC);")
      ]);
    }

    const countRes = await db.prepare("SELECT COUNT(*) as count FROM books").first();
    if (countRes && (countRes.count === 0 || countRes.count === "0")) {
      const inserts = DEFAULT_SEEDED_BOOKS.map(b => {
        const metadata = JSON.stringify({
          format: b.format,
          status: b.status,
          coverImg: b.cover_img,
          coverClass: b.cover_class,
          marketplace_links: b.marketplace_links,
          thickness_cm: b.thickness_cm,
          altId: b.altId
        });
        return db.prepare(`
          INSERT INTO books (
            id, title, author, genre, publisher, published_date, isbn,
            pages, length_cm, width_cm, thickness_cm, weight_gram,
            original_price, selling_price, synopsis, warranty,
            format, status, cover_img, cover_class, metadata
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `).bind(
          b.id, b.title, b.author, b.genre, b.publisher, b.published_date, b.isbn,
          b.pages, b.length_cm, b.width_cm, b.thickness_cm, b.weight_gram,
          b.original_price, b.selling_price, b.synopsis, b.warranty,
          b.format, b.status, b.cover_img, b.cover_class, metadata
        );
      });
      await db.batch(inserts);
    }
    d1Initialized = true;
  } catch (err) {
    console.warn("[Cloudflare D1 Auto-Init] Notice:", err);
  }
}

export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const method = request.method;

    // Handle CORS Preflight
    if (method === "OPTIONS") {
      return new Response(null, {
        status: 204,
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST, DELETE, OPTIONS",
          "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Requested-With",
          "Access-Control-Max-Age": "86400"
        }
      });
    }

    const corsHeaders = {
      "Content-Type": "application/json; charset=utf-8",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET, POST, DELETE, OPTIONS"
    };

    // 1. Healthcheck Endpoint
    if (url.pathname === "/api/health" || url.pathname === "/health") {
      const hasD1 = Boolean(env.DB);
      if (hasD1) {
        await ensureD1Initialized(env.DB);
      }
      return new Response(
        JSON.stringify({
          status: "UP",
          service: "darussholah-tokobuku",
          runtime: "cloudflare-workers-edge",
          database_mode: hasD1 ? "cloudflare_d1_native" : "local_assets_fallback",
          d1_bound: hasD1,
          timestamp: new Date().toISOString()
        }),
        { headers: corsHeaders }
      );
    }

    // 2. GET /api/books (Fetch Catalog from D1 or Asset Fallback)
    if (url.pathname === "/api/books" && method === "GET") {
      if (env.DB) {
        await ensureD1Initialized(env.DB);
        try {
          const { results } = await env.DB.prepare(
            "SELECT * FROM books ORDER BY created_at DESC, title ASC"
          ).all();

          if (results && results.length > 0) {
            const mapped = results.map(row => {
              let metadata = {};
              try {
                metadata = typeof row.metadata === "string" ? JSON.parse(row.metadata) : (row.metadata || {});
              } catch (e) {}

              return {
                id: row.id,
                altId: row.altId || metadata.altId || `${row.id}-saku`,
                title: row.title,
                author: row.author,
                genre: row.genre,
                publisher: row.publisher || "Darussholah",
                published_date: row.published_date || "2026",
                isbn: row.isbn || "Belum Terdaftar",
                pages: row.pages || 180,
                length_cm: row.length_cm || 21.0,
                width_cm: row.width_cm || 14.0,
                thickness_cm: row.thickness_cm || 1.5,
                weight_gram: row.weight_gram || 200,
                original_price: row.original_price || 0,
                selling_price: row.selling_price || 0,
                synopsis: row.synopsis || "",
                warranty: row.warranty || "",
                price: row.selling_price || 0,
                originalPrice: row.original_price || 0,
                discount: (row.original_price > row.selling_price && row.original_price > 0)
                  ? Math.round(((row.original_price - row.selling_price) / row.original_price) * 100)
                  : 0,
                format: row.format || "print",
                status: row.status || "normal",
                coverImg: row.cover_img || "",
                coverClass: row.cover_class || (row.cover_img ? "" : "bg-gradient-to-br from-indigo-950 via-slate-900 to-indigo-900"),
                marketplace_links: metadata.marketplace_links || {},
                dimensions: {
                  width_cm: row.width_cm || 14.0,
                  height_cm: row.length_cm || 21.0,
                  length_cm: row.length_cm || 21.0,
                  thickness_cm: row.thickness_cm || 1.5,
                  type: (row.length_cm <= 15 && row.width_cm <= 11) ? "Saku" : "Standar"
                },
                pricing: {
                  original_price: row.original_price || 0,
                  discount_percentage: (row.original_price > row.selling_price && row.original_price > 0)
                    ? Math.round(((row.original_price - row.selling_price) / row.original_price) * 100)
                    : 0,
                  selling_price: row.selling_price || 0,
                  currency: "IDR"
                },
                specs: {
                  language: metadata.language || "Indonesia & Arab",
                  pages: `${row.pages || 180} Halaman`,
                  size: `${row.width_cm || 14.0} × ${row.length_cm || 21.0} × ${row.thickness_cm || 1.5} cm`,
                  width: `${row.width_cm || 14.0} cm`,
                  height: `${row.length_cm || 21.0} cm`,
                  length: `${row.length_cm || 21.0} cm`,
                  thickness: `${row.thickness_cm || 1.5} cm`,
                  weight: `${row.weight_gram || 200} gram`,
                  releaseDate: row.published_date || "2026",
                  publisher: row.publisher || "Darussholah"
                },
                samplePages: metadata.samplePages || []
              };
            });

            return new Response(JSON.stringify(mapped), {
              headers: { ...corsHeaders, "X-Database-Provider": "cloudflare-d1-native" }
            });
          }
        } catch (err) {
          console.warn("[Cloudflare D1] Query error, falling back to static assets:", err);
        }
      }

      // Fallback: serve local books.json from Assets
      if (env.ASSETS) {
        const booksAssetUrl = new URL("/books.json", request.url);
        const assetResp = await env.ASSETS.fetch(new Request(booksAssetUrl));
        if (assetResp.ok) {
          const rawData = await assetResp.text();
          return new Response(rawData, {
            headers: { ...corsHeaders, "X-Database-Provider": "local-assets-fallback" }
          });
        }
      }

      return new Response(JSON.stringify([]), { headers: corsHeaders });
    }

    // 3. POST /api/books (Create or Update in D1)
    if (url.pathname === "/api/books" && method === "POST") {
      try {
        const payload = await request.json();
        const bookId = payload.id || `buku-${Date.now()}`;
        const title = payload.title || "Buku Baru";
        const author = payload.author || "Darussholah Press";
        const genre = payload.genre || "umum";
        const publisher = payload.publisher || payload.specs?.publisher || "Darussholah";
        const publishedDate = String(payload.published_date || payload.specs?.releaseDate || "2026");
        const isbn = payload.isbn || "Belum Terdaftar";
        const pages = parseInt(String(payload.pages || payload.specs?.pages || 180).replace(/\D/g, "")) || 180;
        const lengthCm = parseFloat(String(payload.length_cm || payload.dimensions?.length_cm || 21.0).replace(",", ".")) || 21.0;
        const widthCm = parseFloat(String(payload.width_cm || payload.dimensions?.width_cm || 14.0).replace(",", ".")) || 14.0;
        const thicknessCm = parseFloat(String(payload.dimensions?.thickness_cm || 1.5).replace(",", ".")) || 1.5;
        const weightGram = parseInt(String(payload.weight_gram || payload.specs?.weight || 200).replace(/\D/g, "")) || 200;
        const originalPrice = parseInt(String(payload.original_price || payload.originalPrice || 0).replace(/\D/g, "")) || 0;
        const sellingPrice = parseInt(String(payload.selling_price || payload.price || originalPrice).replace(/\D/g, "")) || originalPrice;
        const synopsis = payload.synopsis || "Buku berkualitas terbitan resmi Darussholah.";
        const warranty = payload.warranty || "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.";
        const formatVal = payload.format || "print";
        const statusVal = payload.status || "normal";
        const coverImg = payload.coverImg || "";
        const coverClass = payload.coverClass || "";

        const metadata = JSON.stringify({
          marketplace_links: payload.marketplace_links || {},
          language: payload.specs?.language || "Indonesia & Arab",
          samplePages: payload.samplePages || []
        });

        if (env.DB) {
          await env.DB.prepare(`
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
          `).bind(
            bookId, title, author, genre, publisher, publishedDate, isbn,
            pages, lengthCm, widthCm, thicknessCm, weightGram,
            originalPrice, sellingPrice, synopsis, warranty,
            formatVal, statusVal, coverImg, coverClass, metadata
          ).run();
        }

        return new Response(
          JSON.stringify({ success: true, book: { id: bookId, ...payload } }),
          { headers: corsHeaders }
        );
      } catch (err) {
        return new Response(
          JSON.stringify({ success: false, error: err.message }),
          { status: 500, headers: corsHeaders }
        );
      }
    }

    // 4. DELETE /api/books/:id
    if (url.pathname.startsWith("/api/books/") && method === "DELETE") {
      const bookId = url.pathname.replace("/api/books/", "").trim();
      if (env.DB && bookId) {
        try {
          await env.DB.prepare("DELETE FROM books WHERE id = ?").bind(bookId).run();
        } catch (e) {
          console.warn("[Cloudflare D1] Delete error:", e);
        }
      }
      return new Response(JSON.stringify({ success: true, deletedId: bookId }), { headers: corsHeaders });
    }

    // 5. Fallback: Serve Static Assets (HTML, CSS, JS, Images)
    if (env.ASSETS) {
      return env.ASSETS.fetch(request);
    }

    return new Response("Not Found", { status: 404 });
  }
};
