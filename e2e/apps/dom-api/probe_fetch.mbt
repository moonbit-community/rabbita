///|
fn probe_fetch_apis() -> Unit {
  let failures : Array[String] = []
  @js.Promise::from_async(() => {
    let data = @dom.fetch("/fetch-api/json")
      .flat_map(response => response.json())
      .wait()
    record(failures, data is { "name": "rabbit", .. }, "fetch_json")
    let json_response = @dom.Response::with_json(
      data,
      init=@dom.ResponseInit::new(status=202),
    )
    record(failures, json_response.get_status() == 202, "response_json_status")
    record(
      failures,
      json_response.clone().json().wait() == data,
      "response_json_roundtrip",
    )
    let json_request = @dom.Request::new(
      "/fetch-api/json",
      init=@dom.RequestInit::new(
        method_="POST",
        body=@js.Value::cast_from(json_response.text().wait()),
      ),
    )
    record(
      failures,
      json_request.json().wait() == data,
      "request_json_roundtrip",
    )

    let headers = @dom.Headers::new(init=[
      ("content-type", "text/plain"),
      ("x-rabbit", "browser"),
    ])
    let request = @dom.Request::new(
      "http://127.0.0.1:4308/fetch-api/echo",
      init=@dom.RequestInit::new(
        method_="POST",
        headers~,
        body=@js.Value::cast_from(b"rabbit"),
      ),
    )
    let response = @dom.fetch(
      request,
      init=@dom.RequestInit::new(cache="no-store"),
    ).wait()
    record(failures, response.get_status() == 201, "fetch_status")
    record(failures, response.get_ok(), "fetch_ok")
    record(failures, response.get_type() == "basic", "fetch_type")
    record(failures, response.get_url() == request.get_url(), "fetch_url")
    record(failures, !response.get_body().is_null(), "fetch_body")
    record(failures, !response.get_body_used(), "fetch_body_unused")
    record(
      failures,
      response.get_headers().get("x-response").to_option() == Some("native"),
      "fetch_headers",
    )
    let echoed = response.clone().json().wait()
    record(failures, echoed is { "method": "POST", .. }, "fetch_method")
    record(failures, echoed is { "body": "rabbit", .. }, "fetch_request_body")
    record(
      failures,
      echoed is { "header": "browser", .. },
      "fetch_request_headers",
    )
    let buffer = response.array_buffer().wait()
    record(failures, buffer.get_byte_length() > 0.0, "fetch_array_buffer")
    record(failures, response.get_body_used(), "fetch_body_used")
    let repeated = response
      .text()
      .then(_ => "fulfilled")
      .catch_(error => error.get_with_string("name"))
      .wait()
    record(failures, repeated == "TypeError", "fetch_body_consumed")

    let missing = @dom.fetch("/fetch-api/missing").wait()
    record(
      failures,
      missing.get_status() == 404 && !missing.get_ok(),
      "fetch_http_error",
    )
    record(
      failures,
      missing.text().wait() == "missing",
      "fetch_http_error_body",
    )

    let controller = @js_async.AbortController::new()
    let pending = @dom.fetch(
        "/fetch-api/json",
        init=@dom.RequestInit::new(
          signal=@js.Nullable::from_option(Some(controller.signal())),
        ),
      )
      .then(_ => "fulfilled")
      .catch_(error => error.get_with_string("name"))
    controller.abort()
    record(failures, pending.wait() == "AbortError", "fetch_abort")

    let network_error = @dom.fetch("/fetch-api/network")
      .then(_ => "fulfilled")
      .catch_(error => error.get_with_string("name"))
      .wait()
    record(failures, network_error == "TypeError", "fetch_network_error")
    set_result("fetch-result", finish_probe(failures))
  }).catch_(error => set_result("fetch-result", "failed: \{error}"))
  |> ignore
}
