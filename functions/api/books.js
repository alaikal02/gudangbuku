import { CORS_HEADERS, ensureD1Initialized, mapRowToBook } from "../_d1.js";

/**
 * Cloudflare Pages Function: /api/books
 * Handles Catalog retrieval and Book creation/updates against context.env.DB.
 */

export async function onRequestOptions(context) {
  return new Response(null, {
    status: 204,
    headers: CORS_HEADERS
  });
}

export async function onRequestGet(context) {
  // Database Binding Alignment: Accurate reference using context.env.DB
  const db = context.env.DB;

  if (context.env.DB) {
    await ensureD1Initialized(context.env.DB);
    try {
      const { results } = await context.env.DB.prepare(
        "SELECT * FROM books ORDER BY created_at DESC, title ASC"
      ).all();

      if (results && results.length > 0) {
        const catalog = results.map(row => mapRowToBook(row));
        return new Response(JSON.stringify(catalog), {
          headers: {
            ...CORS_HEADERS,
            "X-Database-Provider": "cloudflare-d1-pages-functions"
          }
        });
      }
    } catch (err) {
      console.warn("[Pages Functions] D1 query error:", err);
    }
  }

  // Fallback: Return empty or empty array with CORS
  return new Response(JSON.stringify([]), {
    headers: {
      ...CORS_HEADERS,
      "X-Database-Provider": context.env.DB ? "cloudflare-d1-empty" : "d1-unbound-fallback"
    }
  });
}

export async function onRequestPost(context) {
  // Database Binding Alignment: Accurate reference using context.env.DB
  const db = context.env.DB;

  try {
    const payload = await context.request.json();
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

    if (context.env.DB) {
      await ensureD1Initialized(context.env.DB);
      await context.env.DB.prepare(`
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
      { headers: CORS_HEADERS }
    );
  } catch (err) {
    return new Response(
      JSON.stringify({ success: false, error: err.message }),
      { status: 500, headers: CORS_HEADERS }
    );
  }
}
