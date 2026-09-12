///|
fn asset_content_type(path : String) -> String {
  match path.to_lower() {
    [.., .. ".html"] | [.., .. ".htm"] => "text/html; charset=utf-8"
    [.., .. ".js"] | [.., .. ".mjs"] => "text/javascript; charset=utf-8"
    [.., .. ".css"] => "text/css; charset=utf-8"
    [.., .. ".json"] | [.., .. ".map"] => "application/json"
    [.., .. ".txt"] => "text/plain; charset=utf-8"
    [.., .. ".svg"] => "image/svg+xml"
    [.., .. ".png"] => "image/png"
    [.., .. ".jpg"] | [.., .. ".jpeg"] => "image/jpeg"
    [.., .. ".gif"] => "image/gif"
    [.., .. ".webp"] => "image/webp"
    [.., .. ".avif"] => "image/avif"
    [.., .. ".ico"] => "image/x-icon"
    [.., .. ".woff"] => "font/woff"
    [.., .. ".woff2"] => "font/woff2"
    [.., .. ".ttf"] => "font/ttf"
    [.., .. ".otf"] => "font/otf"
    [.., .. ".wasm"] => "application/wasm"
    [.., .. ".pdf"] => "application/pdf"
    [.., .. ".mp4"] => "video/mp4"
    [.., .. ".webm"] => "video/webm"
    [.., .. ".mp3"] => "audio/mpeg"
    [.., .. ".ogg"] => "audio/ogg"
    [.., .. ".wav"] => "audio/wav"
    [.., .. ".xml"] => "application/xml"
    [.., .. ".webmanifest"] => "application/manifest+json"
    _ => "application/octet-stream"
  }
}

///|
fn asset_hex_digit(byte : Byte) -> Int? {
  match byte.to_int() {
    n if n >= 48 && n <= 57 => Some(n - 48)
    n if n >= 65 && n <= 70 => Some(n - 65 + 10)
    n if n >= 97 && n <= 102 => Some(n - 97 + 10)
    _ => None
  }
}

///|
fn asset_request_path(raw : String) -> String? {
  let raw = raw.split("?").collect()[0].to_owned()
  let bytes = @utf8.encode(raw)
  let decoded = @buffer.Buffer()
  for i = 0 {
    guard i < bytes.length() else { break }
    if bytes[i] == b'%' {
      guard i + 2 < bytes.length() &&
        asset_hex_digit(bytes[i + 1]) is Some(high) &&
        asset_hex_digit(bytes[i + 2]) is Some(low) else {
        return None
      }
      decoded.write_byte((high * 16 + low).to_byte())
      continue i + 3
    } else {
      decoded.write_byte(bytes[i])
      continue i + 1
    }
  }
  let path = @utf8.decode(decoded.to_bytes(), ignore_bom=true) catch {
    _ => return None
  }
  guard path.has_prefix("/") && !path.contains("\\") && !path.contains("\u{0}") else {
    return None
  }
  let parts = []
  for part in path.split("/") {
    match part {
      ".." => return None
      "" | "." => ()
      _ => parts.push(part.to_owned())
    }
  }
  let normalized = "/" + parts.join("/")
  if path.has_suffix("/") {
    Some(
      if normalized == "/" {
        "/index.html"
      } else {
        normalized + "/index.html"
      },
    )
  } else {
    Some(normalized)
  }
}

///|
// Assets are a complete static filesystem. Missing entries fall through to
// application routes, never to the working directory of the executable.
fn bundled_assets(
  files : Map[String, Bytes],
  serve_root~ : Bool,
) -> @moonback.Middleware {
  @moonback.Middleware(next => {
    (req, res) => {
      guard req.meth is Get || req.meth is Head else {
        next(req, res)
        return
      }
      guard asset_request_path(req.path.to_owned()) is Some(path) else {
        res.send_void(status=400)
        return
      }
      guard !(req.path == "/" && !serve_root) &&
        files.get(path) is Some(content) else {
        next(req, res)
        return
      }
      let writer = res.respond(headers=[
        ("Content-Type", asset_content_type(path)),
        ("Content-Length", content.length().to_string()),
        ("X-Content-Type-Options", "nosniff"),
      ])
      if req.meth is Get {
        writer.write(content)
      }
    }
  })
}
