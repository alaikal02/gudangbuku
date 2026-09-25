import { CORS_HEADERS, ensureD1Initialized, mapRowToBook } from "../_d1.js";

/**
 * Cloudflare Pages Function: /api/[[route]] (Catch-all router)
 * Fallback serverless handler ensuring all API variants route reliably to D1.
 */

export async function onRequest(context) {
  const url = new URL(context.request.url);
  const method = context.request.method;

  if (method === "OPTIONS") {
    return new Response(null, { status: 204, headers: CORS_HEADERS });
  }

  // Healthcheck fallback
  if (url.pathname.includes("/health")) {
    const hasD1 = Boolean(context.env.DB);
    let count = 0;
    if (context.env.DB) {
      await ensureD1Initialized(context.env.DB);
      const res = await context.env.DB.prepare("SELECT COUNT(*) as count FROM books").first();
      count = res ? Number(res.count) : 0;
    }
    return new Response(JSON.stringify({
      status: "UP",
      service: "gudangbuku-catchall",
      d1_bound: hasD1,
      catalog_count: count
    }), { headers: CORS_HEADERS });
  }

  // Catalog fallback
  if (url.pathname.includes("/books")) {
    if (method === "GET") {
      if (context.env.DB) {
        await ensureD1Initialized(context.env.DB);
        const { results } = await context.env.DB.prepare(
          "SELECT * FROM books ORDER BY created_at DESC, title ASC"
        ).all();
        if (results) {
          return new Response(JSON.stringify(results.map(mapRowToBook)), { headers: CORS_HEADERS });
        }
      }
      return new Response(JSON.stringify([]), { headers: CORS_HEADERS });
    }
  }

  return new Response(JSON.stringify({ error: "API Route Not Found", path: url.pathname }), {
    status: 404,
    headers: CORS_HEADERS
  });
}
