///|
// Standalone server source; keep resource semantics aligned with rabbita/server/assets.mbt.
let bundle_server_source =
  #|///|
  #|import {
  #|  "moonbitlang/async",
  #|  "moonbitlang/async/http",
  #|  "moonbitlang/async/socket",
  #|  "moonbitlang/core/env",
  #|  "moonbitlang/core/string",
  #|  "moonbitlang/core/buffer",
  #|  "moonbitlang/core/encoding/utf8",
  #|}
  #|
  #|///|
  #|async fn main {
  #|  let host = @env.get_env_var("WARREN_HOST").unwrap_or("127.0.0.1")
  #|  let port = @string.parse_uint(@env.get_env_var("WARREN_PORT").unwrap_or("4300"))
  #|  guard port > 0 && port <= 65535 else { fail("Invalid WARREN_PORT") }
  #|  let files = warren_assets()
  #|  let server = @http.Server(@socket.Addr::parse("\{host}:\{port}"), reuse_addr=true)
  #|  defer server.close()
  #|  println("Server is running on http://\{host}:\{port}")
  #|  server.run_forever((req, _, conn) => {
  #|    guard req.meth is Get || req.meth is Head else {
  #|      conn.send_response(405, "Method Not Allowed", extra_headers={ "Allow": "GET, HEAD" })
  #|      conn.end_response()
  #|      return
  #|    }
  #|    guard asset_request_path(req.path) is Some(path) else {
  #|      conn.send_response(400, "Bad Request")
  #|      conn.end_response()
  #|      return
  #|    }
  #|    guard files.get(path) is Some(content) else {
  #|      conn.send_response(404, "Not Found")
  #|      conn.end_response()
  #|      return
  #|    }
  #|    conn.send_response(200, "OK", extra_headers={
  #|      "Content-Type": asset_content_type(path),
  #|      "Content-Length": content.length().to_string(),
  #|      "X-Content-Type-Options": "nosniff",
  #|    })
  #|    if req.meth is Get { conn.write(content) }
  #|    conn.end_response()
  #|  }, allow_failure=true)
  #|}
  #|
  #|///|
  #|fn asset_content_type(path : String) -> String {
  #|  match path.to_lower() {
  #|    [.., .. ".html"] | [.., .. ".htm"] => "text/html; charset=utf-8"
  #|    [.., .. ".js"] | [.., .. ".mjs"] => "text/javascript; charset=utf-8"
  #|    [.., .. ".css"] => "text/css; charset=utf-8"
  #|    [.., .. ".json"] | [.., .. ".map"] => "application/json"
  #|    [.., .. ".txt"] => "text/plain; charset=utf-8"
  #|    [.., .. ".svg"] => "image/svg+xml"
  #|    [.., .. ".png"] => "image/png"
  #|    [.., .. ".jpg"] | [.., .. ".jpeg"] => "image/jpeg"
  #|    [.., .. ".gif"] => "image/gif"
  #|    [.., .. ".webp"] => "image/webp"
  #|    [.., .. ".avif"] => "image/avif"
  #|    [.., .. ".ico"] => "image/x-icon"
  #|    [.., .. ".woff"] => "font/woff"
  #|    [.., .. ".woff2"] => "font/woff2"
  #|    [.., .. ".ttf"] => "font/ttf"
  #|    [.., .. ".otf"] => "font/otf"
  #|    [.., .. ".wasm"] => "application/wasm"
  #|    [.., .. ".pdf"] => "application/pdf"
  #|    [.., .. ".mp4"] => "video/mp4"
  #|    [.., .. ".webm"] => "video/webm"
  #|    [.., .. ".mp3"] => "audio/mpeg"
  #|    [.., .. ".ogg"] => "audio/ogg"
  #|    [.., .. ".wav"] => "audio/wav"
  #|    [.., .. ".xml"] => "application/xml"
  #|    [.., .. ".webmanifest"] => "application/manifest+json"
  #|    _ => "application/octet-stream"
  #|  }
  #|}
  #|
  #|///|
  #|fn asset_hex_digit(byte : Byte) -> Int? {
  #|  match byte.to_int() {
  #|    n if n >= 48 && n <= 57 => Some(n - 48)
  #|    n if n >= 65 && n <= 70 => Some(n - 65 + 10)
  #|    n if n >= 97 && n <= 102 => Some(n - 97 + 10)
  #|    _ => None
  #|  }
  #|}
  #|
  #|///|
  #|fn asset_request_path(raw : String) -> String? {
  #|  let raw = raw.split("?").collect()[0].to_owned()
  #|  let bytes = @utf8.encode(raw)
  #|  let decoded = @buffer.Buffer()
  #|  for i = 0 {
  #|    guard i < bytes.length() else { break }
  #|    if bytes[i] == b'%' {
  #|      guard i + 2 < bytes.length() &&
  #|        asset_hex_digit(bytes[i + 1]) is Some(high) &&
  #|        asset_hex_digit(bytes[i + 2]) is Some(low) else { return None }
  #|      decoded.write_byte((high * 16 + low).to_byte())
  #|      continue i + 3
  #|    } else {
  #|      decoded.write_byte(bytes[i])
  #|      continue i + 1
  #|    }
  #|  }
  #|  let path = try @utf8.decode(decoded.to_bytes(), ignore_bom=true) catch {
  #|    _ => return None
  #|  }
  #|  guard path.has_prefix("/") && !path.contains("\\") && !path.contains("\u{0}") else {
  #|    return None
  #|  }
  #|  let parts = []
  #|  for part in path.split("/") {
  #|    match part {
  #|      ".." => return None
  #|      "" | "." => ()
  #|      _ => parts.push(part.to_owned())
  #|    }
  #|  }
  #|  let normalized = "/" + parts.join("/")
  #|  if path.has_suffix("/") {
  #|    Some(if normalized == "/" { "/index.html" } else { normalized + "/index.html" })
  #|  } else {
  #|    Some(normalized)
  #|  }
  #|}
  #|
