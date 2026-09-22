///|
/// Performs a checked cast from a `Value` to a `Self?` type.
/// 
/// This trait abstracts a function that ensures the cast is valid and returns `null` if the cast fails.
/// It is useful for safely handling dynamic types in MoonBit.
#cfg(target="js")
pub(open) trait Cast {
  fn into(Value) -> Self?
  fn from(Self) -> Value
}

// NOTE: Do we need a default implementation for the `from` method in `Cast` trait?
// 
// If the type `Self` can be cast from a `Value`, then it must can be cast back to a `Value` safely,
// only when the `Self` type is a abstract type that represents a JavaScript type.
//
// ```
// impl Cast with from(self) { Value::cast_from(self) }
// ```
//
// But if some one implements the `Cast` trait for a type that not an abstract type, 
// then the default implementation is not type-safe.

///|
#cfg(target="js")
extern "js" fn checked_cast_string_ffi(value : Value) -> Nullable[String] =
  #| (x) => typeof x === 'string' ? x : null

///|
#cfg(target="js")
extern "js" fn checked_cast_int_ffi(value : Value) -> Nullable[Int] =
  #| (x) => typeof x === 'number' && Number.isInteger(x) ? x : null

///|
#cfg(target="js")
extern "js" fn checked_cast_double_ffi(value : Value) -> Nullable[Double] =
  #| (x) => typeof x === 'number' ? x : null

///|
#cfg(target="js")
extern "js" fn checked_cast_bool_ffi(value : Value) -> Nullable[Bool] =
  #| (x) => typeof x === 'boolean' ? x : null

///|
#cfg(target="js")
extern "js" fn checked_cast_array_ffi(
  value : Value,
) -> Nullable[JsArray[Value]] =
  #| (x) => Array.isArray(x) ? x : null

///|
#cfg(target="js")
pub impl Cast for String with fn into(value) {
  checked_cast_string_ffi(value).to_option()
}

///|
#cfg(target="js")
pub impl Cast for String with fn from(value) {
  Value::cast_from(value)
}

///|
#cfg(target="js")
pub impl Cast for Int with fn into(value) {
  checked_cast_int_ffi(value).to_option()
}

///|
#cfg(target="js")
pub impl Cast for Int with fn from(value) {
  Value::cast_from(value)
}

///|
#cfg(target="js")
pub impl Cast for Double with fn into(value) {
  checked_cast_double_ffi(value).to_option()
}

///|
#cfg(target="js")
pub impl Cast for Double with fn from(value) {
  Value::cast_from(value)
}

///|
#cfg(target="js")
pub impl Cast for Bool with fn into(value) {
  checked_cast_bool_ffi(value).to_option()
}

///|
#cfg(target="js")
pub impl Cast for Bool with fn from(value) {
  Value::cast_from(value)
}

///|
#cfg(target="js")
pub impl[A : Cast] Cast for JsArray[A] with fn into(value) {
  checked_cast_array_ffi(value)
  .to_option()
  .bind(fn(arr) {
    let is_type_a = fn(elem) {
      elem is Some(elem) && !((Cast::into(elem) : A?) is None)
    }
    if arr.iter().all(is_type_a) {
      Some(Value::cast_from(arr).cast())
    } else {
      None
    }
  })
}

///|
#cfg(target="js")
pub extend JsArray with Cast::{from, into}

///|
#cfg(target="js")
pub impl[A : Cast] Cast for JsArray[A] with fn from(value) {
  Value::cast_from(value)
}
