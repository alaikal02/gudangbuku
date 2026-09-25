/**
 * Darussholah - Cloudflare Pages Functions D1 Data Access Layer
 * Automated Database Handshake, Table Schema Migration, and 6-Book Bulk Seeding
 */

export const CORS_HEADERS = {
  "Content-Type": "application/json; charset=utf-8",
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Requested-With",
  "Access-Control-Max-Age": "86400"
};

export const DEFAULT_SEEDED_BOOKS = [
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

/**
 * Validates Cloudflare D1 database handshake.
 * 1. Verifies if 'books' table exists; executes schema migration if missing.
 * 2. Verifies if table is empty; executes bulk insert for all 6 catalog data models.
 */
export async function ensureD1Initialized(db) {
  if (d1Initialized || !db) return;
  try {
    const tableCheck = await db.prepare(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='books'"
    ).first();

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

export function mapRowToBook(row) {
  let metadata = {};
  try {
    metadata = typeof row.metadata === "string" ? JSON.parse(row.metadata) : (row.metadata || {});
  } catch (e) {}

  const origPrice = Number(row.original_price || 0);
  const sellPrice = Number(row.selling_price || origPrice);
  const discount = (origPrice > sellPrice && origPrice > 0)
    ? Math.round(((origPrice - sellPrice) / origPrice) * 100)
    : 0;

  const lengthCm = Number(row.length_cm || 21.0);
  const widthCm = Number(row.width_cm || 14.0);
  const thicknessCm = Number(row.thickness_cm || 1.5);
  const weightGram = Number(row.weight_gram || 200);
  const pages = Number(row.pages || 180);

  return {
    id: row.id,
    altId: row.altId || metadata.altId || `${row.id}-saku`,
    title: row.title,
    author: row.author,
    genre: row.genre,
    publisher: row.publisher || "Darussholah",
    published_date: row.published_date || "2026",
    isbn: row.isbn || "Belum Terdaftar",
    pages: pages,
    length_cm: lengthCm,
    width_cm: widthCm,
    thickness_cm: thicknessCm,
    weight_gram: weightGram,
    original_price: origPrice,
    selling_price: sellPrice,
    synopsis: row.synopsis || "",
    warranty: row.warranty || "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.",
    price: sellPrice,
    originalPrice: origPrice,
    discount: discount,
    format: row.format || "print",
    status: row.status || "normal",
    coverImg: row.cover_img || "",
    coverClass: row.cover_class || (row.cover_img ? "" : "bg-gradient-to-br from-indigo-950 via-slate-900 to-indigo-900"),
    marketplace_links: metadata.marketplace_links || {},
    dimensions: {
      width_cm: widthCm,
      height_cm: lengthCm,
      length_cm: lengthCm,
      thickness_cm: thicknessCm,
      type: (lengthCm <= 15 && widthCm <= 11) ? "Saku" : "Standar"
    },
    pricing: {
      original_price: origPrice,
      discount_percentage: discount,
      selling_price: sellPrice,
      currency: "IDR"
    },
    specs: {
      language: metadata.language || "Indonesia & Arab",
      pages: `${pages} Halaman`,
      size: `${widthCm} × ${lengthCm} × ${thicknessCm} cm`,
      width: `${widthCm} cm`,
      height: `${lengthCm} cm`,
      length: `${lengthCm} cm`,
      thickness: `${thicknessCm} cm`,
      weight: `${weightGram} gram`,
      releaseDate: row.published_date || "2026",
      publisher: row.publisher || "Darussholah"
    },
    samplePages: metadata.samplePages || []
  };
}
