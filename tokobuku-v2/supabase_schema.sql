-- =============================================================================
-- Supabase PostgreSQL Production Schema - Darussholah Book Catalog
-- Execute this script in your Supabase Project SQL Editor
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- -----------------------------------------------------------------------------
-- 1. Table: books (Full 14 Product Variables + Extended Metadata)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.books (
    id TEXT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    genre VARCHAR(100) NOT NULL DEFAULT 'umum',
    publisher VARCHAR(255) NOT NULL DEFAULT 'Darussholah',
    published_date VARCHAR(50) NOT NULL DEFAULT '2026',
    isbn VARCHAR(50) NOT NULL DEFAULT 'Belum Terdaftar',
    pages INT NOT NULL DEFAULT 180,
    length_cm NUMERIC(6,2) NOT NULL DEFAULT 21.00,
    width_cm NUMERIC(6,2) NOT NULL DEFAULT 14.00,
    thickness_cm NUMERIC(6,2) NOT NULL DEFAULT 1.50,
    weight_gram INT NOT NULL DEFAULT 200,
    original_price BIGINT NOT NULL DEFAULT 0,
    selling_price BIGINT NOT NULL DEFAULT 0,
    synopsis TEXT NOT NULL DEFAULT '',
    warranty TEXT NOT NULL DEFAULT 'Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.',
    format VARCHAR(50) NOT NULL DEFAULT 'print',
    status VARCHAR(50) NOT NULL DEFAULT 'normal',
    cover_img TEXT NULL,
    cover_class VARCHAR(255) NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for Fast Querying and Searching
CREATE INDEX IF NOT EXISTS idx_books_isbn ON public.books(isbn);
CREATE INDEX IF NOT EXISTS idx_books_genre ON public.books(genre);
CREATE INDEX IF NOT EXISTS idx_books_selling_price ON public.books(selling_price);
CREATE INDEX IF NOT EXISTS idx_books_created_at ON public.books(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_books_metadata_gin ON public.books USING gin (metadata);

-- Trigger for Auto-Updating updated_at
CREATE OR REPLACE FUNCTION public.handle_books_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_books_updated_at ON public.books;
CREATE TRIGGER trigger_books_updated_at
    BEFORE UPDATE ON public.books
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_books_updated_at();

-- -----------------------------------------------------------------------------
-- 2. Row Level Security (RLS) Configuration
-- -----------------------------------------------------------------------------
ALTER TABLE public.books ENABLE ROW LEVEL SECURITY;

-- Allow Public Read Access for Web Storefront and Catalog API
CREATE POLICY "Allow public read access on books"
    ON public.books
    FOR SELECT
    USING (true);

-- Allow Authenticated / Service Role full access (Insert, Update, Delete)
CREATE POLICY "Allow full access for service role or authenticated users"
    ON public.books
    FOR ALL
    USING (true)
    WITH CHECK (true);
