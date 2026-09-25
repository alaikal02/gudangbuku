/**
 * Darussholah Tokobuku - Cloudflare Edge Worker
 * Serverless API router with Cloudflare D1 Database integration
 * and native Workers Static Assets serving.
 */

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
