import { CORS_HEADERS, ensureD1Initialized } from "../_d1.js";

/**
 * Cloudflare Pages Function: /api/health
 * Validates edge serverless environment, context.env.DB binding, and table handshake status.
 */

export async function onRequestOptions(context) {
  return new Response(null, {
    status: 204,
    headers: CORS_HEADERS
  });
}

export async function onRequestGet(context) {
  const db = context.env.DB;
  let count = 0;
  let tableReady = false;

  if (context.env.DB) {
    try {
      await ensureD1Initialized(context.env.DB);
      const res = await context.env.DB.prepare("SELECT COUNT(*) as count FROM books").first();
      count = res ? Number(res.count) : 0;
      tableReady = true;
    } catch (e) {
      console.warn("[Pages Functions] Healthcheck D1 validation error:", e);
    }
  }

  const payload = {
    status: "UP",
    service: "gudangbuku-pages-functions",
    runtime: "cloudflare-pages-edge",
    d1_bound: Boolean(context.env.DB),
    database_name: "gudangbuku-db",
    table_ready: tableReady,
    catalog_count: count,
    timestamp: new Date().toISOString()
  };

  return new Response(JSON.stringify(payload), {
    headers: {
      ...CORS_HEADERS,
      "X-Database-Provider": context.env.DB ? "cloudflare-d1-native" : "d1-unbound"
    }
  });
}
