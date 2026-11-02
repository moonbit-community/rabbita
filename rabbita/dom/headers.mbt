///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Headers
#cfg(target="js")
#external
type Headers

///|
#cfg(target="js")
pub impl @js.Cast for Headers with fn into(value) {
  ffi_to_headers(value).to_option()
}

///|
#cfg(target="js")
pub impl @js.Cast for Headers with fn from(value) {
  @js.Value::cast_from(value)
}

///|
#cfg(target="js")
pub extend Headers with @js.Cast::{from, into}

///|
#cfg(target="js")
extern "js" fn ffi_to_headers(value : @js.Value) -> @js.Nullable[Headers] =
  #| value => typeof Headers !== 'undefined' && value instanceof Headers ? value : null

///|
/// Creates native Headers from name/value pairs, preserving duplicate entries.
/// Converts each MoonBit tuple to a native two-element string array.
/// https://developer.mozilla.org/en-US/docs/Web/API/Headers/Headers
#cfg(target="js")
pub fn Headers::new(init? : FixedArray[(String, String)]) -> Headers {
  let entries : FixedArray[FixedArray[String]]? = init.map(pairs => {
    pairs.map(pair => [pair.0, pair.1])
  })
  headers_new_ffi(@js.Optional::from_option(entries))
}

///|
#cfg(target="js")
extern "js" fn headers_new_ffi(
  init : @js.Optional[FixedArray[FixedArray[String]]],
) -> Headers =
  #| init => new Headers(init)

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Headers/append
#cfg(target="js")
pub extern "js" fn Headers::append(
  self : Self,
  name : String,
  value : String,
) -> Unit =
  #| (self, name, value) => self.append(name, value)

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Headers/delete
#cfg(target="js")
pub extern "js" fn Headers::delete(self : Self, name : String) -> Unit =
  #| (self, name) => self.delete(name)

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Headers/get
#cfg(target="js")
pub extern "js" fn Headers::get(
  self : Self,
  name : String,
) -> @js.Nullable[String] =
  #| (self, name) => self.get(name)

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Headers/getSetCookie
#cfg(target="js")
pub extern "js" fn Headers::get_set_cookie(self : Self) -> @js.JsArray[String] =
  #| self => self.getSetCookie()

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Headers/has
#cfg(target="js")
pub extern "js" fn Headers::has(self : Self, name : String) -> Bool =
  #| (self, name) => self.has(name)

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Headers/set
#cfg(target="js")
pub extern "js" fn Headers::set(
  self : Self,
  name : String,
  value : String,
) -> Unit =
  #| (self, name, value) => self.set(name, value)

///|
/// The callback receives (value, name, headers), in native argument order.
/// https://developer.mozilla.org/en-US/docs/Web/API/Headers/forEach
#cfg(target="js")
pub extern "js" fn Headers::for_each(
  self : Self,
  callback : (String, String, Headers) -> Unit,
) -> Unit =
  #| (self, callback) => self.forEach(callback)
