-- =============================================================================
-- Cloudflare D1 (SQLite) Production Schema - Darussholah Book Catalog
-- Execute via Wrangler CLI or Cloudflare D1 Console:
-- wrangler d1 execute <database-name> --file=./d1_schema.sql
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Table: books (Full 14 Product Variables + Extended Metadata)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS books (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    genre TEXT NOT NULL DEFAULT 'umum',
    publisher TEXT NOT NULL DEFAULT 'Darussholah',
    published_date TEXT NOT NULL DEFAULT '2026',
    isbn TEXT NOT NULL DEFAULT 'Belum Terdaftar',
    pages INTEGER NOT NULL DEFAULT 180,
    length_cm REAL NOT NULL DEFAULT 21.0,
    width_cm REAL NOT NULL DEFAULT 14.0,
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

-- Fast Indexing for Search and Category Filtering
CREATE INDEX IF NOT EXISTS idx_books_isbn ON books(isbn);
CREATE INDEX IF NOT EXISTS idx_books_genre ON books(genre);
CREATE INDEX IF NOT EXISTS idx_books_selling_price ON books(selling_price);
CREATE INDEX IF NOT EXISTS idx_books_created_at ON books(created_at DESC);
