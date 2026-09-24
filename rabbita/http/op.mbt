///|
extenum @cmd.Extension += {
  Get(String, Expecting)
  Delete(String, Expecting)
  Post(String, Body, Expecting)
  Put(String, Body, Expecting)
  Patch(String, Body, Expecting)
}

///|
priv enum Expecting {
  Json((Result[Json, HttpError]) -> Cmd)
  Text((Result[String, HttpError]) -> Cmd)
  Bytes((Result[(ContentType, Bytes), HttpError]) -> Cmd)
  Blob((Result[Blob, HttpError]) -> Cmd)
}

///|
priv enum RequestResult {
  Responded(@async_http.Response, Bytes, Expecting)
  Failed(HttpError, Expecting)
}

///|
let op : @cmd.Op = @cmd.Op()
  ..on_identify(extension => {
    fn identify(
      http_method : String,
      url : String,
      body : Body,
      expect : Expecting,
    ) -> String raise @cmd.Unhandled {
      let hasher = Hasher(seed=0)
      hasher.combine_string(http_method)
      hasher.combine_char('\u{0000}')
      hasher.combine_string(url)
      hasher.combine_char('\u{0000}')
      match body {
        Json(json) => {
          hasher.combine_int(0)
          hasher.combine_string(json.stringify())
        }
        Text(text) => {
          hasher.combine_int(1)
          hasher.combine_string(text)
        }
        BytesBody(content_type, bytes) => {
          hasher.combine_int(2)
          hasher.combine_string(content_type)
          hasher.combine_char('\u{0000}')
          hasher.combine_bytes(bytes)
        }
        BlobBody(_, _) => raise Unhandled
        Empty => hasher.combine_int(3)
      }
      match expect {
        Json(_) => hasher.combine_int(0)
        Text(_) => hasher.combine_int(1)
        Bytes(_) => hasher.combine_int(2)
        Blob(_) => raise @cmd.Unhandled::Unhandled
      }
      let hash = hasher.finalize().reinterpret_as_uint().to_string(radix=16)
      "\{http_method} \{url} \{hash}"
    }

    match extension {
      Get(url, expect) => identify("GET", url, Empty, expect)
      Delete(url, expect) => identify("DELETE", url, Empty, expect)
      Post(url, body, expect) => identify("POST", url, body, expect)
      Put(url, body, expect) => identify("PUT", url, body, expect)
      Patch(url, body, expect) => identify("PATCH", url, body, expect)
      _ => raise Unhandled
    }
  })
  ..on_debug(extension => {
    match extension {
      Get(url, expect) =>
        Repr::ctor("Get", [(None, Repr(url)), (None, expect.to_repr())])
      Delete(url, expect) =>
        Repr::ctor("Delete", [(None, Repr(url)), (None, expect.to_repr())])
      Post(url, body, expect) =>
        Repr::ctor("Post", [
          (None, Repr(url)),
          (None, body.to_repr()),
          (None, expect.to_repr()),
        ])
      Put(url, body, expect) =>
        Repr::ctor("Put", [
          (None, Repr(url)),
          (None, body.to_repr()),
          (None, expect.to_repr()),
        ])
      Patch(url, body, expect) =>
        Repr::ctor("Patch", [
          (None, Repr(url)),
          (None, body.to_repr()),
          (None, expect.to_repr()),
        ])
      _ => raise Unhandled
    }
  })
  ..on_invoke((_, _) => None)

///|
fn Expecting::to_repr(self : Expecting) -> Repr {
  match self {
    Json(_) => Repr::ctor("Json", [])
    Text(_) => Repr::ctor("Text", [])
    Bytes(_) => Repr::ctor("Bytes", [])
    Blob(_) => Repr::ctor("Blob", [])
  }
}

///|
fn Body::to_repr(self : Body) -> Repr {
  match self {
    Json(_) => Repr::ctor("Json", [])
    Text(_) => Repr::ctor("Text", [])
    BytesBody(_, _) => Repr::ctor("Bytes", [])
    BlobBody(_, _) => Repr::ctor("Blob", [])
    Empty => Repr::ctor("Empty", [])
  }
}

///|
fn resolve_request_url(url : String, origin : String) -> String {
  if url.contains("://") {
    return url
  }
  if url.has_prefix("/") {
    "\{origin}\{url}"
  } else {
    "\{origin}/\{url}"
  }
}

///|
fn request_target(url : String, origin : String) -> (String, String) raise {
  let parsed = @url.parse(resolve_request_url(url, origin))
  let protocol = match parsed.protocol {
    Http => "http"
    Https => "https"
    Other(protocol) =>
      raise RequestError("unsupported HTTP protocol: \{protocol}")
  }
  let port = if parsed.port is Some(port) { ":\{port}" } else { "" }
  let query = if parsed.query is Some(query) { "?\{query}" } else { "" }
  ("\{protocol}://\{parsed.host}\{port}", "/\{parsed.path}\{query}")
}

///|
fn content_type_headers(
  content_type : String,
  headers? : @async_http.Headers = Map([]),
) -> @async_http.Headers {
  if !content_type.is_empty() {
    headers["Content-Type"] = content_type
  }
  headers
}

///|
#cfg(not(target="js"))
fn settle_request_headers() -> @async_http.Headers {
  let headers : @async_http.Headers = Map([])
  headers["User-Agent"] = "MoonBit"
  headers
}

///|
fn decode_json(response_body : Bytes) -> Result[Json, HttpError] {
  try @json.parse(@utf8.decode(response_body[:])) catch {
    @utf8.Malformed(_) => Err(RequestError("Malformed UTF-8 response body"))
    error => Err(RequestError(error.to_string()))
  } noraise {
    json => Ok(json)
  }
}

///|
fn decode_text(response_body : Bytes) -> Result[String, HttpError] {
  try @utf8.decode(response_body[:]) catch {
    Malformed(_) => Err(RequestError("Malformed UTF-8 response body"))
  } noraise {
    text => Ok(text)
  }
}

///|
fn decode_bytes(
  response : @async_http.Response,
  response_body : Bytes,
) -> Result[(ContentType, Bytes), HttpError] {
  if response.headers.get("content-type") is Some(content_type) {
    Ok((content_type, response_body))
  } else {
    Err(RequestError("Missing Content-Type header"))
  }
}

///|
fn RequestResult::to_cmd(self : RequestResult) -> Cmd {
  match self {
    Failed(error, Json(f)) => f(Err(error))
    Failed(error, Text(f)) => f(Err(error))
    Failed(error, Bytes(f)) => f(Err(error))
    Failed(error, Blob(f)) => f(Err(error))
    Responded(_, response_body, Json(f)) => f(decode_json(response_body))
    Responded(_, response_body, Text(f)) => f(decode_text(response_body))
    Responded(response, response_body, Bytes(f)) =>
      f(decode_bytes(response, response_body))
    Responded(response, response_body, Blob(f)) => {
      let content_type = response.headers.get("content-type").unwrap_or("")
      f(Ok(@dom.Blob::from_bytes(response_body, content_type)))
    }
  }
}

///|
#cfg(not(target="js"))
fn[T : ToJson] settle_result(
  result : Result[T, HttpError],
  on_result : (Result[T, HttpError]) -> Cmd,
) -> (Json, Cmd) raise @cmd.HydrateExn {
  match result {
    Err(_) => raise @cmd.HydrateExn::Fallback
    Ok(_) => (ToJson::to_json(result), on_result(result))
  }
}

///|
#cfg(not(target="js"))
fn RequestResult::settle(
  self : RequestResult,
) -> (Json, Cmd) raise @cmd.HydrateExn {
  match self {
    Failed(_, _) => raise @cmd.HydrateExn::Fallback
    Responded(_, response_body, Json(f)) =>
      settle_result(decode_json(response_body), f)
    Responded(_, response_body, Text(f)) =>
      settle_result(decode_text(response_body), f)
    Responded(response, response_body, Bytes(f)) =>
      settle_result(decode_bytes(response, response_body), f)
    Responded(_, _, Blob(_)) => raise @cmd.HydrateExn::Fallback
  }
}

///|
async fn execute_request(
  extension : @cmd.Extension,
  origin : String,
  headers : @async_http.Headers,
) -> RequestResult {
  async fn run(
    expect : Expecting,
    request : async () -> (@async_http.Response, Bytes),
  ) -> RequestResult {
    try {
      let (response, response_body) = request()
      if response.code is (200..<300) {
        Responded(response, response_body, expect)
      } else {
        let reason = if response.reason.is_empty() {
          ""
        } else {
          " \{response.reason}"
        }
        Failed(RequestError("HTTP \{response.code}\{reason}"), expect)
      }
    } catch {
      RequestError(message) => Failed(RequestError(message), expect)
      error => Failed(RequestError(error.to_string()), expect)
    }
  }

  match extension {
    Get(url, expect) =>
      run(expect, () => {
        let url = resolve_request_url(url, origin)
        let (response, response_body) = @async_http.get(url, headers~)
        (response, response_body.binary())
      })
    Delete(url, expect) =>
      run(expect, () => {
        let (request_origin, path) = request_target(url, origin)
        let client = @async_http.Client(request_origin, headers~)
        defer client.close()
        client.request(Delete, path)
        let response = client.end_request()
        (response, client.read_all().binary())
      })
    Post(url, body, expect) =>
      run(expect, () => {
        let url = resolve_request_url(url, origin)
        let (response, response_body) = match body {
          Json(json) => {
            let headers = content_type_headers("application/json", headers~)
            @async_http.post(url, json, headers~)
          }
          Text(text) => {
            let headers = content_type_headers("text/plain", headers~)
            @async_http.post(url, text, headers~)
          }
          BytesBody(content_type, bytes) => {
            let headers = content_type_headers(content_type, headers~)
            @async_http.post(url, bytes, headers~)
          }
          BlobBody(content_type, blob) => {
            let headers = content_type_headers(content_type, headers~)
            @async_http.post(url, blob.bytes(), headers~)
          }
          Empty => @async_http.post(url, b"", headers~)
        }
        (response, response_body.binary())
      })
    Put(url, body, expect) =>
      run(expect, () => {
        let url = resolve_request_url(url, origin)
        let (response, response_body) = match body {
          Json(json) => {
            let headers = content_type_headers("application/json", headers~)
            @async_http.put(url, json, headers~)
          }
          Text(text) => {
            let headers = content_type_headers("text/plain", headers~)
            @async_http.put(url, text, headers~)
          }
          BytesBody(content_type, bytes) => {
            let headers = content_type_headers(content_type, headers~)
            @async_http.put(url, bytes, headers~)
          }
          BlobBody(content_type, blob) => {
            let headers = content_type_headers(content_type, headers~)
            @async_http.put(url, blob.bytes(), headers~)
          }
          Empty => @async_http.put(url, b"", headers~)
        }
        (response, response_body.binary())
      })
    Patch(url, body, expect) =>
      run(expect, () => {
        let (request_origin, path) = request_target(url, origin)
        let client = @async_http.Client(request_origin, headers~)
        defer client.close()
        match body {
          Json(json) => {
            let headers = content_type_headers("application/json")
            client.request(Patch, path, extra_headers=headers)
            client.write(json)
          }
          Text(text) => {
            let headers = content_type_headers("text/plain")
            client.request(Patch, path, extra_headers=headers)
            client.write(text)
          }
          BytesBody(content_type, bytes) => {
            let headers = content_type_headers(content_type)
            client.request(Patch, path, extra_headers=headers)
            client.write(bytes)
          }
          BlobBody(content_type, blob) => {
            let headers = content_type_headers(content_type)
            client.request(Patch, path, extra_headers=headers)
            client.write(blob.bytes())
          }
          Empty => client.request(Patch, path)
        }
        let response = client.end_request()
        (response, client.read_all().binary())
      })
    _ => raise @cmd.Unhandled::Unhandled
  }
}

///|
#cfg(not(target="js"))
fn init {
  op.on_settle((extension, context) => {
    Async(() => {
      execute_request(extension, context.get_origin(), settle_request_headers()).settle()
    })
  })
}

///|
#cfg(target="js")
fn resume_request(expect : Expecting, json : Json) -> Cmd raise @cmd.HydrateExn {
  match expect {
    Json(f) => f(@json.from_json(json)) catch { _ => raise Fallback }
    Text(f) => f(@json.from_json(json)) catch { _ => raise Fallback }
    Bytes(f) => f(@json.from_json(json)) catch { _ => raise Fallback }
    Blob(_) => raise Fallback
  }
}

///|
#cfg(target="js")
fn init {
  op.on_resume((extension, json, _context) => {
    match extension {
      Get(_, expect) => resume_request(expect, json)
      Delete(_, expect) => resume_request(expect, json)
      Post(_, _, expect) => resume_request(expect, json)
      Put(_, _, expect) => resume_request(expect, json)
      Patch(_, _, expect) => resume_request(expect, json)
      _ => raise Fallback
    }
  })
}

///|
fn init {
  op.on_invoke((extension, context) => {
    Async(() => {
      execute_request(extension, context.get_origin(), Map([])).to_cmd()
    })
  })
}
