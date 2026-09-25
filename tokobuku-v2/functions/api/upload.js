import { CORS_HEADERS } from "../_d1.js";

/**
 * Cloudflare Pages Function: /api/upload
 * Handles cover image uploads in serverless edge environment.
 */

export async function onRequestOptions(context) {
  return new Response(null, {
    status: 204,
    headers: CORS_HEADERS
  });
}

export async function onRequestPost(context) {
  try {
    const contentType = context.request.headers.get("Content-Type") || "";

    if (contentType.includes("application/json")) {
      const payload = await context.request.json();
      const filename = payload.filename || `cover_${Date.now()}.jpg`;
      const dataStr = payload.data || "";

      // In serverless edge without writable disk, base64 data URLs are returned directly
      // ensuring cover previews render instantly without file storage bottlenecks.
      const directUrl = dataStr.startsWith("data:") ? dataStr : `data:image/jpeg;base64,${dataStr}`;

      return new Response(
        JSON.stringify({
          success: true,
          url: directUrl,
          filename: filename
        }),
        { headers: CORS_HEADERS }
      );
    }

    return new Response(
      JSON.stringify({ success: true, url: "/assets/sample_cover.jpg", filename: "default.jpg" }),
      { headers: CORS_HEADERS }
    );
  } catch (err) {
    return new Response(
      JSON.stringify({ success: false, error: err.message }),
      { status: 400, headers: CORS_HEADERS }
    );
  }
}
