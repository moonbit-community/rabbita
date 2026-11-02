///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Response
#cfg(target="js")
#external
type Response

///|
#cfg(target="js")
pub impl @js.Cast for Response with fn into(value) {
  ffi_to_response(value).to_option()
}

///|
#cfg(target="js")
pub impl @js.Cast for Response with fn from(value) {
  @js.Value::cast_from(value)
}

///|
#cfg(target="js")
pub extend Response with @js.Cast::{from, into}

///|
#cfg(target="js")
extern "js" fn ffi_to_response(value : @js.Value) -> @js.Nullable[Response] =
  #| value => typeof Response !== 'undefined' && value instanceof Response ? value : null

///|
/// Creates a native Response. body must be a native BodyInit value or null.
/// Native constructor errors are thrown synchronously.
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/Response
#cfg(target="js")
pub fn Response::new(body? : @js.Value, init? : ResponseInit) -> Response {
  response_new_ffi(
    @js.Optional::from_option(body),
    @js.Optional::from_option(init),
  )
}

///|
#cfg(target="js")
extern "js" fn response_new_ffi(
  body : @js.Optional[@js.Value],
  init : @js.Optional[ResponseInit],
) -> Response =
  #| (body, init) => new Response(body, init)

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/error_static
#cfg(target="js")
pub extern "js" fn Response::error() -> Response =
  #| () => Response.error()

///|
/// Calls native Response.redirect(). Invalid URLs or statuses throw synchronously.
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/redirect_static
#cfg(target="js")
pub fn Response::redirect(url : String, status? : Int32) -> Response {
  response_redirect_ffi(url, @js.Optional::from_option(status))
}

///|
#cfg(target="js")
extern "js" fn response_redirect_ffi(
  url : String,
  status : @js.Optional[Int32],
) -> Response =
  #| (url, status) => Response.redirect(url, status)

///|
/// Converts MoonBit Json to a native JS value and calls Response.json(data, init).
/// Native constructor errors are thrown synchronously.
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/json_static
#cfg(target="js")
pub fn Response::with_json(data : Json, init? : ResponseInit) -> Response {
  response_with_json_ffi(data.stringify(), @js.Optional::from_option(init))
}

///|
#cfg(target="js")
extern "js" fn response_with_json_ffi(
  data : String,
  init : @js.Optional[ResponseInit],
) -> Response =
  #| (data, init) => Response.json(JSON.parse(data), init)

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/body
#cfg(target="js")
pub extern "js" fn Response::get_body(
  self : Self,
) -> @js.Nullable[@js_async.JsReadableStream] =
  #| self => self.body

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/bodyUsed
#cfg(target="js")
pub extern "js" fn Response::get_body_used(self : Self) -> Bool =
  #| self => self.bodyUsed

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/headers
#cfg(target="js")
pub extern "js" fn Response::get_headers(self : Self) -> Headers =
  #| self => self.headers

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/ok
#cfg(target="js")
pub extern "js" fn Response::get_ok(self : Self) -> Bool =
  #| self => self.ok

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/redirected
#cfg(target="js")
pub extern "js" fn Response::get_redirected(self : Self) -> Bool =
  #| self => self.redirected

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/status
#cfg(target="js")
pub extern "js" fn Response::get_status(self : Self) -> Int32 =
  #| self => self.status

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/statusText
#cfg(target="js")
pub extern "js" fn Response::get_status_text(self : Self) -> String =
  #| self => self.statusText

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/type
#cfg(target="js")
pub extern "js" fn Response::get_type(self : Self) -> String =
  #| self => self.type

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/url
#cfg(target="js")
pub extern "js" fn Response::get_url(self : Self) -> String =
  #| self => self.url

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/clone
#cfg(target="js")
pub extern "js" fn Response::clone(self : Self) -> Response =
  #| self => self.clone()

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/arrayBuffer
#cfg(target="js")
pub extern "js" fn Response::array_buffer(
  self : Self,
) -> @js.Promise[ArrayBuffer] =
  #| self => self.arrayBuffer()

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/blob
#cfg(target="js")
pub extern "js" fn Response::blob(self : Self) -> @js.Promise[Blob] =
  #| self => self.blob()

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/bytes
#cfg(target="js")
pub extern "js" fn Response::bytes(self : Self) -> @js.Promise[Bytes] =
  #| self => self.bytes()

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/formData
#cfg(target="js")
pub extern "js" fn Response::form_data(self : Self) -> @js.Promise[FormData] =
  #| self => self.formData()

///|
/// Reads the body with native json() and converts the result to MoonBit Json.
/// Native read failures and conversion errors reject the returned promise.
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/json
#cfg(target="js")
pub fn Response::json(self : Self) -> @js.Promise[Json] {
  self.json_ffi().then(value => value.to_json())
}

///|
#cfg(target="js")
extern "js" fn Response::json_ffi(self : Self) -> @js.Promise[@js.Value] =
  #| self => self.json()

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/text
#cfg(target="js")
pub extern "js" fn Response::text(self : Self) -> @js.Promise[String] =
  #| self => self.text()
