///|
test "Headers preserves native normalization, duplicates, and callback order" {
  let pairs : FixedArray[(String, String)] = [
    ("X-Rabbit", "  first  "),
    ("x-rabbit", "second"),
    ("Set-Cookie", "a=1"),
    ("Set-Cookie", "b=2"),
  ]
  let headers = @dom.Headers::new(init=pairs)
  pairs[0] = ("X-Rabbit", "changed after construction")
  assert_eq(headers.get("X-RABBIT").to_option(), Some("first, second"))
  assert_true(headers.get("missing").is_null())
  let cookies = headers.get_set_cookie()
  assert_eq(cookies.length(), 2)
  assert_eq(cookies.get(0), Some("a=1"))
  assert_eq(cookies.get(1), Some("b=2"))
  let mut visited = false
  let mut correct_receiver = true
  headers.for_each((value, name, owner) => {
    correct_receiver = correct_receiver && physical_equal(owner, headers)
    if name == "x-rabbit" {
      visited = value == "first, second"
    }
  })
  assert_true(visited)
  assert_true(correct_receiver)
  headers.set("x-rabbit", "replacement")
  headers.append("x-rabbit", "extra")
  assert_eq(headers.get("x-rabbit").to_option(), Some("replacement, extra"))
  headers.delete("x-rabbit")
  assert_false(headers.has("x-rabbit"))
  assert_false(@dom.Headers::new(init=[]).has("x-rabbit"))
  assert_true(@dom.Headers::into(@js.Value::cast_from(headers)) is Some(_))
}

///|
async test "RequestInit preserves omission, false values, and native inheritance" {
  let headers = @dom.Headers::new()
  headers.set("X-Rabbit", "request")
  let controller = @js_async.AbortController::new()
  let init = @dom.RequestInit::new(
    method_="POST",
    headers~,
    body=@js.Value::cast_from("rabbit"),
    cache="no-store",
    credentials="include",
    mode="cors",
    redirect="manual",
    referrer="",
    referrer_policy="no-referrer",
    integrity="",
    keepalive=false,
    signal=@js.Nullable::from_option(Some(controller.signal())),
    duplex="half",
    priority="high",
  )
  let request = @dom.Request::new("https://example.test/api", init~)
  assert_eq(request.get_method(), "POST")
  assert_eq(request.get_url(), "https://example.test/api")
  assert_eq(request.get_cache(), "no-store")
  assert_eq(request.get_credentials(), "include")
  assert_eq(request.get_mode(), "cors")
  assert_eq(request.get_redirect(), "manual")
  assert_eq(request.get_referrer(), "")
  assert_eq(request.get_referrer_policy(), "no-referrer")
  assert_eq(request.get_integrity(), "")
  assert_eq(request.get_destination(), "")
  assert_eq(request.get_duplex(), "half")
  assert_false(request.get_keepalive())
  assert_eq(request.get_headers().get("x-rabbit").to_option(), Some("request"))
  let defaulted = @dom.RequestInit::new()
  let raw = @js.Value::cast_from(defaulted)
  assert_true((raw.get_with_string("method") : @js.Value).is_undefined())
  assert_true((raw.get_with_string("signal") : @js.Value).is_undefined())
  let copied = @dom.Request::new(request, init=defaulted)
  assert_eq(copied.get_method(), "POST")
  assert_eq(copied.get_cache(), "no-store")
  assert_eq(copied.get_headers().get("x-rabbit").to_option(), Some("request"))
  assert_eq(copied.text().wait(), "rabbit")
  let signal = @js.Value::cast_from(copied.get_signal())
  assert_false(signal.get_with_string("aborted"))
  controller.abort()
  assert_true(signal.get_with_string("aborted"))
  let cleared = @dom.RequestInit::new(signal=@js.Nullable::null())
  assert_true(
    (@js.Value::cast_from(cleared).get_with_string("signal") : @js.Value).is_null(),
  )
  assert_true(@dom.Request::into(@js.Value::cast_from(copied)) is Some(_))
}

///|
async test "Response body readers retain native bytes, values, and single-use behavior" {
  let headers = @dom.Headers::new()
  headers.set("x-rabbit", "response")
  let response = @dom.Response::new(
    body=@js.Value::cast_from("你好"),
    init=@dom.ResponseInit::new(status=201, status_text="Created", headers~),
  )
  assert_eq(response.get_status(), 201)
  assert_eq(response.get_status_text(), "Created")
  assert_true(response.get_ok())
  assert_false(response.get_redirected())
  assert_eq(response.get_type(), "default")
  assert_eq(response.get_url(), "")
  assert_eq(
    response.get_headers().get("x-rabbit").to_option(),
    Some("response"),
  )
  assert_false(response.get_body().is_null())
  assert_false(response.get_body_used())
  assert_eq(response.clone().bytes().wait(), b"\xe4\xbd\xa0\xe5\xa5\xbd")
  let buffer = response.clone().array_buffer().wait()
  assert_eq(buffer.get_byte_length(), 6.0)
  assert_eq(buffer.to_bytes(), b"\xe4\xbd\xa0\xe5\xa5\xbd")
  assert_eq(
    response.clone().blob().flat_map(blob => blob.text()).wait(),
    "你好",
  )
  assert_eq(response.text().wait(), "你好")
  assert_true(response.get_body_used())
  assert_eq(
    response
    .text()
    .then(_ => "fulfilled")
    .catch_(error => error.get_with_string("name"))
    .wait(),
    "TypeError",
  )
  assert_true(@dom.Response::into(@js.Value::cast_from(response)) is Some(_))
  assert_true(@dom.Response::new().get_body().is_null())
  for json_text in ["null", "42", "true", "[1,2]", "{\"name\":\"rabbit\"}"] {
    let parsed = @dom.Response::new(body=@js.Value::cast_from(json_text))
      .json()
      .wait()
    assert_eq(parsed, @json.parse(json_text))
  }
  let invalid = @dom.Response::new(body=@js.Value::cast_from("{invalid"))
  assert_eq(
    invalid
    .json()
    .then(_ => "fulfilled")
    .catch_(error => error.get_with_string("name"))
    .wait(),
    "SyntaxError",
  )
}

///|
async test "Request body readers use native body consumption and cloning" {
  let request = @dom.Request::new(
    "https://example.test/body",
    init=@dom.RequestInit::new(method_="POST", body=@js.Value::cast_from("42")),
  )
  assert_false(request.get_body().is_null())
  assert_false(request.get_body_used())
  assert_eq(request.clone().bytes().wait(), b"42")
  assert_eq(request.clone().array_buffer().wait().to_bytes(), b"42")
  assert_eq(request.clone().blob().flat_map(blob => blob.bytes()).wait(), b"42")
  assert_eq(request.clone().json().wait(), @json.parse("42"))
  assert_eq(request.text().wait(), "42")
  assert_true(request.get_body_used())
  assert_eq(
    request
    .text()
    .then(_ => "fulfilled")
    .catch_(error => error.get_with_string("name"))
    .wait(),
    "TypeError",
  )
  let empty = @dom.Request::new("https://example.test/empty")
  assert_true(empty.get_body().is_null())
}

///|
async test "FormData preserves repeated fields and native File values" {
  let form = @dom.FormData::new()
  form.append("name", "rabbit")
  form.append("name", "tea")
  assert_eq(form.get_all("name").length(), 2)
  assert_true(form.get("missing").is_null())
  form.set("name", "rabbita")
  form.append("remove", "value")
  form.delete("remove")
  assert_false(form.has("remove"))
  let blob = @dom.Blob::from_bytes(b"attachment", "text/plain")
  form.append_blob("file", blob, filename="rabbit.txt")
  form.set_blob("default-file", blob)
  for
    parsed in [
      @dom.Response::new(body=@js.Value::cast_from(form)).form_data().wait(),
      @dom.Request::new(
        "https://example.test/form",
        init=@dom.RequestInit::new(
          method_="POST",
          body=@js.Value::cast_from(form),
        ),
      )
      .form_data()
      .wait(),
    ] {
    assert_eq((parsed.get("name").unwrap().cast() : String), "rabbita")
    let file = parsed.get("file").unwrap()
    assert_eq(file.get_with_string("name"), "rabbit.txt")
    let file_blob : @dom.Blob = file.cast()
    assert_eq(file_blob.text().wait(), "attachment")
    assert_eq(
      parsed.get("default-file").unwrap().get_with_string("name"),
      "blob",
    )
  }
}

///|
async test "Response static factories preserve native status and JSON serialization" {
  let error = @dom.Response::error()
  assert_eq(error.get_status(), 0)
  assert_eq(error.get_type(), "error")
  assert_false(error.get_ok())
  let redirect = @dom.Response::redirect(
    "https://example.test/next",
    status=307,
  )
  assert_eq(redirect.get_status(), 307)
  assert_eq(
    redirect.get_headers().get("location").to_option(),
    Some("https://example.test/next"),
  )
  let data = @json.parse("{\"count\":2}")
  let response = @dom.Response::with_json(
    data,
    init=@dom.ResponseInit::new(status=202),
  )
  assert_eq(response.get_status(), 202)
  assert_eq(
    response.get_headers().get("content-type").to_option(),
    Some("application/json"),
  )
  assert_eq(response.json().wait(), data)
  for
    json_text in [
      "null", "false", "42.5", "\"你好\\n\"", "[]", "[1,true,null]", "{\"nested\":{\"items\":[1,\"rabbit\",false,null]}}",
      "{\"__proto__\":{\"name\":\"rabbit\"},\"constructor\":1}",
    ] {
    let data = @json.parse(json_text)
    let response = @dom.Response::with_json(data)
    assert_eq(response.clone().json().wait(), data)
    assert_eq(@json.parse(response.text().wait()), data)
    let request = @dom.Request::new(
      "https://example.test/json",
      init=@dom.RequestInit::new(
        method_="POST",
        body=@js.Value::cast_from(json_text),
      ),
    )
    assert_eq(request.json().wait(), data)
  }
}

///|
test "Fetch constructors retain native synchronous validation errors" {
  for
    operation in [
      () => ignore(@dom.Request::new("not a URL")),
      () => ignore(@dom.Response::new(init=@dom.ResponseInit::new(status=99))),
      () => {
        ignore(
          @dom.Response::with_json(
            Json::null(),
            init=@dom.ResponseInit::new(status=99),
          ),
        )
      },
      () => ignore(@dom.Response::redirect("https://example.test/", status=200)),
      () => @dom.Headers::new().set("bad\nname", "value"),
      () => ignore(@dom.Headers::new(init=[("bad\nname", "value")])),
    ] {
    guard capture_js_error(operation).to_option() is Some(_) else {
      fail("expected native validation to throw synchronously")
    }
  }
}

///|
extern "js" fn install_fetch_probe(rejected : Bool) -> @js.Value =
  #| rejected => {
  #|   const state = { original: globalThis.fetch, reason: new Error('network failed') };
  #|   state.promise = rejected
  #|     ? Promise.reject(state.reason)
  #|     : Promise.resolve(new Response('not found', { status: 404 }));
  #|   globalThis.fetch = function(resource, init) {
  #|     state.resource = resource;
  #|     state.init = init;
  #|     state.receiver = this;
  #|     return state.promise;
  #|   };
  #|   return state;
  #| }

///|
extern "js" fn restore_fetch_probe(state : @js.Value) -> Unit =
  #| state => { globalThis.fetch = state.original; }

///|
async test "fetch preserves native promises, HTTP statuses, rejections, and cancellation" {
  // Keep all global fetch replacements in one test so async tests cannot overlap.
  let state = install_fetch_probe(false)
  defer restore_fetch_probe(state)
  let request = @dom.Request::new("https://example.test/api")
  let init = @dom.RequestInit::new(cache="reload")
  let promise = @dom.fetch(request, init~)
  assert_true(
    physical_equal(
      @js.Value::cast_from(promise.0),
      state.get_with_string("promise"),
    ),
  )
  assert_true(
    physical_equal(
      @js.Value::cast_from(request),
      state.get_with_string("resource"),
    ),
  )
  assert_true(
    physical_equal(@js.Value::cast_from(init), state.get_with_string("init")),
  )
  assert_true(physical_equal(@js.globalThis, state.get_with_string("receiver")))
  let response = promise.wait()
  assert_eq(response.get_status(), 404)
  assert_false(response.get_ok())
  assert_eq(response.text().wait(), "not found")
  @dom.fetch("/relative") |> ignore
  assert_eq(state.get_with_string("resource"), "/relative")
  assert_true((state.get_with_string("init") : @js.Value).is_undefined())
  restore_fetch_probe(state)
  let state = install_fetch_probe(true)
  let reason : @js.Value = state.get_with_string("reason")
  let mut caught = false
  @dom.fetch("https://example.test/")
  .catch_(error => {
    assert_true(physical_equal(error, reason))
    caught = true
    @dom.Response::error()
  })
  .wait()
  |> ignore
  assert_true(caught)
  restore_fetch_probe(state)
  let text = @dom.fetch("data:text/plain,rabbit")
    .flat_map(response => response.text())
    .wait()
  assert_eq(text, "rabbit")
  let controller = @js_async.AbortController::new()
  controller.abort()
  let init = @dom.RequestInit::new(
    signal=@js.Nullable::from_option(Some(controller.signal())),
  )
  let error_name = @dom.fetch("data:text/plain,rabbit", init~)
    .then(_ => "fulfilled")
    .catch_(error => error.get_with_string("name"))
    .wait()
  assert_eq(error_name, "AbortError")
}
