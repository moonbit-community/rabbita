///|
/// A native fetch resource: a URL string or an existing Request.
/// This sealed marker trait restricts inputs to String and Request.
/// Native value conversion is provided by @js.Cast.
#cfg(target="js")
pub trait IsRequestInfo: @js.Cast {}

///|
#cfg(target="js")
pub impl IsRequestInfo for String

///|
#cfg(target="js")
pub impl IsRequestInfo for Request
