///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request
#cfg(target="js")
#external
type Request

///|
#cfg(target="js")
pub impl @js.Cast for Request with fn into(value) {
  ffi_to_request(value).to_option()
}

///|
#cfg(target="js")
pub impl @js.Cast for Request with fn from(value) {
  @js.Value::cast_from(value)
}

///|
#cfg(target="js")
pub extend Request with @js.Cast::{from, into}

///|
#cfg(target="js")
extern "js" fn ffi_to_request(value : @js.Value) -> @js.Nullable[Request] =
  #| value => typeof Request !== 'undefined' && value instanceof Request ? value : null

///|
/// Creates a native Request from a URL string or another Request.
/// Native constructor errors are thrown synchronously.
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/Request
#cfg(target="js")
pub fn[T : IsRequestInfo] Request::new(
  resource : T,
  init? : RequestInit,
) -> Request {
  request_new_ffi(@js.Cast::from(resource), @js.Optional::from_option(init))
}

///|
#cfg(target="js")
extern "js" fn request_new_ffi(
  resource : @js.Value,
  init : @js.Optional[RequestInit],
) -> Request =
  #| (resource, init) => new Request(resource, init)

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/body
#cfg(target="js")
pub extern "js" fn Request::get_body(
  self : Self,
) -> @js.Nullable[@js_async.JsReadableStream] =
  #| self => self.body

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/bodyUsed
#cfg(target="js")
pub extern "js" fn Request::get_body_used(self : Self) -> Bool =
  #| self => self.bodyUsed

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/cache
#cfg(target="js")
pub extern "js" fn Request::get_cache(self : Self) -> String =
  #| self => self.cache

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/credentials
#cfg(target="js")
pub extern "js" fn Request::get_credentials(self : Self) -> String =
  #| self => self.credentials

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/destination
#cfg(target="js")
pub extern "js" fn Request::get_destination(self : Self) -> String =
  #| self => self.destination

///|
/// Experimental. Some browsers accept the duplex option without exposing this getter.
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/duplex
#cfg(target="js")
pub extern "js" fn Request::get_duplex(self : Self) -> String =
  #| self => self.duplex

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/headers
#cfg(target="js")
pub extern "js" fn Request::get_headers(self : Self) -> Headers =
  #| self => self.headers

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/integrity
#cfg(target="js")
pub extern "js" fn Request::get_integrity(self : Self) -> String =
  #| self => self.integrity

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/keepalive
#cfg(target="js")
pub extern "js" fn Request::get_keepalive(self : Self) -> Bool =
  #| self => self.keepalive

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/method
#cfg(target="js")
pub extern "js" fn Request::get_method(self : Self) -> String =
  #| self => self.method

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/mode
#cfg(target="js")
pub extern "js" fn Request::get_mode(self : Self) -> String =
  #| self => self.mode

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/redirect
#cfg(target="js")
pub extern "js" fn Request::get_redirect(self : Self) -> String =
  #| self => self.redirect

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/referrer
#cfg(target="js")
pub extern "js" fn Request::get_referrer(self : Self) -> String =
  #| self => self.referrer

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/referrerPolicy
#cfg(target="js")
pub extern "js" fn Request::get_referrer_policy(self : Self) -> String =
  #| self => self.referrerPolicy

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/signal
#cfg(target="js")
pub extern "js" fn Request::get_signal(self : Self) -> @js_async.AbortSignal =
  #| self => self.signal

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/url
#cfg(target="js")
pub extern "js" fn Request::get_url(self : Self) -> String =
  #| self => self.url

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/clone
#cfg(target="js")
pub extern "js" fn Request::clone(self : Self) -> Request =
  #| self => self.clone()

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/arrayBuffer
#cfg(target="js")
pub extern "js" fn Request::array_buffer(
  self : Self,
) -> @js.Promise[ArrayBuffer] =
  #| self => self.arrayBuffer()

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/blob
#cfg(target="js")
pub extern "js" fn Request::blob(self : Self) -> @js.Promise[Blob] =
  #| self => self.blob()

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/bytes
#cfg(target="js")
pub extern "js" fn Request::bytes(self : Self) -> @js.Promise[Bytes] =
  #| self => self.bytes()

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/formData
#cfg(target="js")
pub extern "js" fn Request::form_data(self : Self) -> @js.Promise[FormData] =
  #| self => self.formData()

///|
/// Reads the body with native json() and converts the result to MoonBit Json.
/// Native read failures and conversion errors reject the returned promise.
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/json
#cfg(target="js")
pub fn Request::json(self : Self) -> @js.Promise[Json] {
  self.json_ffi().then(value => value.to_json())
}

///|
#cfg(target="js")
extern "js" fn Request::json_ffi(self : Self) -> @js.Promise[@js.Value] =
  #| self => self.json()

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Request/text
#cfg(target="js")
pub extern "js" fn Request::text(self : Self) -> @js.Promise[String] =
  #| self => self.text()
