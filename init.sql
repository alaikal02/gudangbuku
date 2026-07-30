-- =============================================================================
-- PostgreSQL 16 Initial DDL Schema - Enterprise WMS Gudang Buku
-- Clean Architecture & High-Scalability Database Design
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- -----------------------------------------------------------------------------
-- 1. TABEL BOOKS (Katalog Metadata Buku)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS books (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    isbn VARCHAR(20) NOT NULL,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    publisher VARCHAR(255) NOT NULL,
    category_id UUID NULL,
    publication_year INT NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_books_isbn UNIQUE (isbn)
);

-- Indeks Kritis untuk Tabel Books
CREATE INDEX idx_books_isbn ON books(isbn);
CREATE INDEX idx_books_title_trgm ON books USING gin (title gin_trgm_ops);
CREATE INDEX idx_books_metadata_gin ON books USING gin (metadata);
CREATE INDEX idx_books_category_year ON books(category_id, publication_year);

-- -----------------------------------------------------------------------------
-- 2. TABEL WAREHOUSE_LOCATIONS (Mapping Denah & Rak Gudang)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS warehouse_locations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    zone VARCHAR(50) NOT NULL,
    rack VARCHAR(50) NOT NULL,
    shelf VARCHAR(50) NOT NULL,
    bin_id VARCHAR(50) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_warehouse_bin UNIQUE (zone, rack, shelf, bin_id)
);

CREATE INDEX idx_locations_zone_rack ON warehouse_locations(zone, rack);
CREATE INDEX idx_locations_bin_id ON warehouse_locations(bin_id);

-- -----------------------------------------------------------------------------
-- 3. TABEL BOOK_INVENTORIES (Stok Fisik per Lokasi Rak)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS book_inventories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    book_id UUID NOT NULL REFERENCES books(id) ON DELETE RESTRICT,
    location_id UUID NOT NULL REFERENCES warehouse_locations(id) ON DELETE RESTRICT,
    quantity INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    safety_threshold INT NOT NULL DEFAULT 10 CHECK (safety_threshold >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_book_location UNIQUE (book_id, location_id)
);

CREATE INDEX idx_inventories_book_id ON book_inventories(book_id);
CREATE INDEX idx_inventories_location_id ON book_inventories(location_id);
-- Partial Index untuk query buku menipis (CRITICAL_LOW) secara instan
CREATE INDEX idx_inventories_low_stock ON book_inventories(book_id) WHERE quantity <= safety_threshold;

-- -----------------------------------------------------------------------------
-- 4. TABEL STOCK_MOVEMENTS (Partitioned Table by Range Date - Annual Partitions)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS stock_movements (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    book_id UUID NOT NULL,
    from_location_id UUID NULL,
    to_location_id UUID NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    type VARCHAR(50) NOT NULL, -- 'INBOUND', 'OUTBOUND', 'RELOCATION', 'OPNAME_ADJUSTMENT'
    reference_number VARCHAR(100) NULL,
    notes TEXT NULL,
    created_by UUID NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);

-- Partisi Tabel Stock Movements per Tahun
CREATE TABLE stock_movements_2025 PARTITION OF stock_movements
    FOR VALUES FROM ('2025-01-01 00:00:00+00') TO ('2026-01-01 00:00:00+00');

CREATE TABLE stock_movements_2026 PARTITION OF stock_movements
    FOR VALUES FROM ('2026-01-01 00:00:00+00') TO ('2027-01-01 00:00:00+00');

CREATE TABLE stock_movements_2027 PARTITION OF stock_movements
    FOR VALUES FROM ('2027-01-01 00:00:00+00') TO ('2028-01-01 00:00:00+00');

-- Default Partition untuk Mengantisipasi Transaksi di Luar Rentang Tahun
CREATE TABLE stock_movements_default PARTITION OF stock_movements DEFAULT;

-- Local Index pada Partitioned Table
CREATE INDEX idx_stock_movements_book_created ON stock_movements(book_id, created_at DESC);
CREATE INDEX idx_stock_movements_type ON stock_movements(type);
CREATE INDEX idx_stock_movements_ref ON stock_movements(reference_number);

-- -----------------------------------------------------------------------------
-- 5. AUTOMATED TRIGGER FUNCTION (Auto Update updated_at Timestamp)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER trg_books_updated_at 
    BEFORE UPDATE ON books 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_locations_updated_at 
    BEFORE UPDATE ON warehouse_locations 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_inventories_updated_at 
    BEFORE UPDATE ON book_inventories 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
