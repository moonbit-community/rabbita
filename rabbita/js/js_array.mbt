///|
/// A native JavaScript `Array` whose length and elements may be mutated in
/// place.
///
/// Unlike MoonBit's `Array`, this external type has the JavaScript value ABI
/// by definition and can therefore cross a JavaScript FFI boundary directly.
#cfg(target="js")
#external
pub type JsArray[T]

///|
/// Creates an empty native JavaScript array.
#cfg(target="js")
pub fn[T] JsArray::new() -> JsArray[T] {
  Value::cast_from(js_array_new()).cast()
}

///|
#cfg(target="js")
pub fn[T] JsArray::length(self : JsArray[T]) -> Int32 {
  js_array_length(Value::cast_from(self))
}

///|
#cfg(target="js")
pub fn[T] JsArray::is_empty(self : JsArray[T]) -> Bool {
  self.length() == 0
}

///|
/// Returns `None` for an out-of-bounds index, a hole, or `undefined`.
#cfg(target="js")
pub fn[T] JsArray::get(self : JsArray[T], index : Int32) -> T? {
  guard js_array_has_value(Value::cast_from(self), index) else { None }
  Some(Value::cast_from(js_array_get(Value::cast_from(self), index)).cast())
}

///|
#cfg(target="js")
pub fn[T] JsArray::unsafe_get(self : JsArray[T], index : Int32) -> T {
  Value::cast_from(js_array_get(Value::cast_from(self), index)).cast()
}

///|
/// Sets an element in place, expanding the array with holes when needed.
/// Aborts when `index` is negative.
#cfg(target="js")
pub fn[T] JsArray::set(self : JsArray[T], index : Int32, value : T) -> Unit {
  guard index >= 0 else { abort("JsArray::set: negative index") }
  js_array_set(Value::cast_from(self), index, Value::cast_from(value))
}

///|
#cfg(target="js")
pub fn[T] JsArray::push(self : JsArray[T], value : T) -> Unit {
  js_array_push(Value::cast_from(self), Value::cast_from(value))
}

///|
#cfg(target="js")
pub fn[T] JsArray::pop(self : JsArray[T]) -> T? {
  guard !self.is_empty() else { None }
  let value = js_array_pop(Value::cast_from(self))
  guard !value.is_undefined() else { None }
  Some(value.cast())
}

///|
/// Iterates the current JavaScript array by index without copying it.
#cfg(target="js")
pub fn[T] JsArray::iter(self : JsArray[T]) -> Iter[T?] {
  let mut index = 0
  Iter(fn() {
    guard index < self.length() else { None }
    let value = self.get(index)
    index += 1
    Some(value)
  })
}

///|
#cfg(target="js")
extern "js" fn js_array_new() -> Value = "() => []"

///|
#cfg(target="js")
extern "js" fn js_array_length(array : Value) -> Int32 = "(array) => array.length"

///|
#cfg(target="js")
extern "js" fn js_array_has_value(array : Value, index : Int32) -> Bool =
  #| (array, index) => index >= 0
  #|   && Object.hasOwn(array, index)
  #|   && array[index] !== undefined

///|
#cfg(target="js")
extern "js" fn js_array_get(array : Value, index : Int32) -> Value = "(array, index) => array[index]"

///|
#cfg(target="js")
extern "js" fn js_array_set(
  array : Value,
  index : Int32,
  value : Value,
) -> Unit = "(array, index, value) => { array[index] = value }"

///|
#cfg(target="js")
extern "js" fn js_array_push(array : Value, value : Value) -> Unit = "(array, value) => { array.push(value) }"

///|
#cfg(target="js")
extern "js" fn js_array_pop(array : Value) -> Value = "(array) => array.pop()"
