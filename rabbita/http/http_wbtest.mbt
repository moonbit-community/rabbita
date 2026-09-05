///|
#external
type Fetch

///|
extern "js" fn install_mock_fetch() -> Fetch =
  #| () => {
  #|   const originalFetch = globalThis.fetch;
  #|   globalThis.fetch = (url) => {
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
  #|     const response = responses[new URL(url).pathname];
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
  origin_value : String
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
impl @cmd.Context for TestScheduler with fn get_origin(self) {
  self.origin_value
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
  origin : String,
) -> Result[String, HttpError] {
  let mut result : Result[String, HttpError]? = None
  let cmd = op.request(
    Get(
      url,
      Text(value => {
        result = Some(value)
        @cmd.none
      }),
    ),
  )
  let scheduler : TestScheduler = { origin_value: origin, commands: [cmd], }
  scheduler.run()
  result.unwrap()
}

///|
async test "async HTTP reports non-2xx responses" {
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
}

///|
async test "async HTTP resolves relative request URLs from the origin" {
  let original_fetch = install_mock_fetch()
  defer restore_fetch(original_fetch)
  guard invoke_text_request("/ok", "https://example.test") is Ok(root_relative) else {
    fail("expected root-relative request to succeed")
  }
  assert_eq(root_relative, "success")
  guard invoke_text_request("ok", "https://example.test") is Ok(path_relative) else {
    fail("expected path-relative request to succeed")
  }
  assert_eq(path_relative, "success")
}
