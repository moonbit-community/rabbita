///|
/// https://developer.mozilla.org/en-US/docs/Web/API/RequestInit
#cfg(target="js")
#external
type RequestInit

///|
/// Builds a native RequestInit dictionary, omitting every unspecified field.
/// String options are passed unchanged and validated by the browser.
/// body must be a native BodyInit value (e.g. String, Bytes/Uint8Array, Blob,
/// FormData, URLSearchParams, ArrayBuffer, or ReadableStream), or null.
/// signal can explicitly be null; omitting it preserves native inheritance.
/// https://developer.mozilla.org/en-US/docs/Web/API/RequestInit
#cfg(target="js")
pub fn RequestInit::new(
  method_? : String,
  headers? : Headers,
  body? : @js.Value,
  mode? : String,
  credentials? : String,
  cache? : String,
  redirect? : String,
  referrer? : String,
  referrer_policy? : String,
  integrity? : String,
  keepalive? : Bool,
  signal? : @js.Nullable[@js_async.AbortSignal],
  duplex? : String,
  priority? : String,
) -> RequestInit {
  let options = @js.Object::new()
  if method_ is Some(value) {
    options["method"] = value
  }
  if headers is Some(value) {
    options["headers"] = value
  }
  if body is Some(value) {
    options["body"] = value
  }
  if mode is Some(value) {
    options["mode"] = value
  }
  if credentials is Some(value) {
    options["credentials"] = value
  }
  if cache is Some(value) {
    options["cache"] = value
  }
  if redirect is Some(value) {
    options["redirect"] = value
  }
  if referrer is Some(value) {
    options["referrer"] = value
  }
  if referrer_policy is Some(value) {
    options["referrerPolicy"] = value
  }
  if integrity is Some(value) {
    options["integrity"] = value
  }
  if keepalive is Some(value) {
    options["keepalive"] = value
  }
  if signal is Some(value) {
    options["signal"] = value
  }
  if duplex is Some(value) {
    options["duplex"] = value
  }
  if priority is Some(value) {
    options["priority"] = value
  }
  options.to_value().cast()
}
