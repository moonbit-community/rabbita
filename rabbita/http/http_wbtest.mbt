///|
#external
type Fetch

///|
extern "js" fn install_mock_fetch() -> Fetch =
  #| () => {
  #|   const originalFetch = globalThis.fetch;
  #|   globalThis.fetch = (url, options) => {
  #|     const responses = {
  #|       "/not-found": {
  #|         ok: false,
  #|         status: 404,
  #|         statusText: "Not Found",
  #|         body: "missing",
  #|       },
  #|       "/server-error": {
  #|         ok: false,
  #|         status: 500,
  #|         statusText: "Internal Server Error",
  #|         body: "failed",
  #|       },
  #|       "/ok": {
  #|         ok: true,
  #|         status: 200,
  #|         statusText: "OK",
  #|         body: "success",
  #|       },
  #|     };
  #|     const response = responses[new URL(url).pathname] ?? {
  #|       body: options.method + " " + url,
  #|       status: 200,
  #|       statusText: "OK",
  #|     };
  #|     return Promise.resolve(new Response(response.body, {
  #|       status: response.status,
  #|       statusText: response.statusText,
  #|       headers: { "Content-Type": "text/plain" },
  #|     }));
  #|   };
  #|   return originalFetch;
  #| }

///|
extern "js" fn restore_fetch(fetch : Fetch) -> Unit =
  #| (fetch) => {
  #|   globalThis.fetch = fetch;
  #| }

///|
struct TestScheduler {
  base_uri : String
  commands : Array[Cmd]
}

///|
impl @cmd.Scheduler for TestScheduler with fn queue_command(self, cmd) {
  self.commands.push(cmd)
}

///|
impl @cmd.Scheduler for TestScheduler with fn set_url_changed_injector(
  self,
  injector,
) {
  ignore((self, injector))
}

///|
impl @cmd.Scheduler for TestScheduler with fn set_url_request_injector(
  self,
  injector,
) {
  ignore((self, injector))
}

///|
impl @cmd.Context for TestScheduler with fn get_base_uri(self) {
  self.base_uri
}

///|
impl @cmd.Context for TestScheduler with fn inject_url_changed(_self, _url) {
  @cmd.none
}

///|
impl @cmd.Context for TestScheduler with fn inject_url_request(_self, _url) {
  @cmd.none
}

///|
async fn TestScheduler::run(self : TestScheduler) -> Unit {
  for index = 0; index < self.commands.length(); index = index + 1 {
    let cmd = self.commands[index]
    for task in @cmd.flatten(@key.key, cmd) {
      let (op, extension) = task
      match @cmd.invoke(@key.key, op, extension, self) {
        None => ()
        Ready(cmd) => self.commands.push(cmd)
        Async(f) => self.commands.push(f())
        AfterLayout(f) => self.commands.push(f())
        LegacyEffect(_, f) => f(self)
      }
    }
  }
}

///|
async fn invoke_text_request(
  url : String,
  base_uri : String,
  http_method? : String = "GET",
) -> Result[String, Error] {
  let mut result : Result[String, Error]? = None
  let request = match http_method {
    "GET" => get(url)
    "POST" => post(url).with_text("body")
    "PUT" => put(url).with_text("body")
    "PATCH" => patch(url).with_text("body")
    "DELETE" => delete(url)
    _ => fail("unexpected HTTP method")
  }
  let cmd = request.expect_text(value => {
    result = Some(value)
    @cmd.none
  })
  let scheduler : TestScheduler = { base_uri, commands: [cmd], }
  scheduler.run()
  result.unwrap()
}

///|
async test "HTTP methods resolve base URIs and report non-2xx responses" {
  let original_fetch = install_mock_fetch()
  defer restore_fetch(original_fetch)
  guard invoke_text_request(
      "https://example.test/not-found", "https://example.test",
    )
    is Err(RequestError(not_found)) else {
    fail("expected 404 response to fail")
  }
  assert_eq(not_found, "HTTP 404 Not Found")
  guard invoke_text_request(
      "https://example.test/server-error", "https://example.test",
    )
    is Err(RequestError(server_error)) else {
    fail("expected 500 response to fail")
  }
  assert_eq(server_error, "HTTP 500 Internal Server Error")
  guard invoke_text_request("https://example.test/ok", "https://example.test")
    is Ok(text) else {
    fail("expected successful response")
  }
  assert_eq(text, "success")
  guard invoke_text_request("/ok", "https://example.test") is Ok(root_relative) else {
    fail("expected root-relative request to succeed")
  }
  assert_eq(root_relative, "success")
  guard invoke_text_request("ok", "https://example.test") is Ok(path_relative) else {
    fail("expected path-relative request to succeed")
  }
  assert_eq(path_relative, "success")
  for http_method in ["GET", "POST", "PUT", "PATCH", "DELETE"] {
    let result = invoke_text_request(
      "./examples-manifest.json?lang=en",
      "https://example.test/uml/",
      http_method~,
    )
    guard result is Ok(text) else { fail("expected \{http_method} to succeed") }
    assert_eq(
      text,
      "\{http_method} https://example.test/uml/./examples-manifest.json?lang=en",
    )
  }
}
