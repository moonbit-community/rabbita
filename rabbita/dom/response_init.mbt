///|
/// The native ResponseInit dictionary used by Response() and Response.json().
/// https://developer.mozilla.org/en-US/docs/Web/API/Response/Response
#cfg(target="js")
#external
type ResponseInit

///|
/// Omits unspecified fields so the native response defaults apply.
#cfg(target="js")
pub fn ResponseInit::new(
  status? : Int32,
  status_text? : String,
  headers? : Headers,
) -> ResponseInit {
  let options = @js.Object::new()
  if status is Some(value) {
    options["status"] = value
  }
  if status_text is Some(value) {
    options["statusText"] = value
  }
  if headers is Some(value) {
    options["headers"] = value
  }
  options.to_value().cast()
}
