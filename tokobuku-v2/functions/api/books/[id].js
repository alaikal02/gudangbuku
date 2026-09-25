import { CORS_HEADERS, ensureD1Initialized, mapRowToBook } from "../../_d1.js";

/**
 * Cloudflare Pages Function: /api/books/:id
 * Handles fetching single book or deleting book by ID against context.env.DB.
 */

export async function onRequestOptions(context) {
  return new Response(null, {
    status: 204,
    headers: CORS_HEADERS
  });
}

export async function onRequestGet(context) {
  const db = context.env.DB;
  const bookId = context.params.id;

  if (context.env.DB && bookId) {
    await ensureD1Initialized(context.env.DB);
    try {
      const row = await context.env.DB.prepare(
        "SELECT * FROM books WHERE id = ? OR altId = ? LIMIT 1"
      ).bind(bookId, bookId).first();

      if (row) {
        return new Response(JSON.stringify(mapRowToBook(row)), {
          headers: CORS_HEADERS
        });
      }
    } catch (e) {
      console.warn("[Pages Functions] Fetch single book error:", e);
    }
  }

  return new Response(JSON.stringify({ error: "Book not found", id: bookId }), {
    status: 404,
    headers: CORS_HEADERS
  });
}

export async function onRequestDelete(context) {
  const db = context.env.DB;
  const bookId = context.params.id;

  if (context.env.DB && bookId) {
    try {
      await context.env.DB.prepare(
        "DELETE FROM books WHERE id = ? OR altId = ?"
      ).bind(bookId, bookId).run();
    } catch (e) {
      console.warn("[Pages Functions] Delete book error:", e);
    }
  }

  return new Response(JSON.stringify({ success: true, deletedId: bookId }), {
    headers: CORS_HEADERS
  });
}
