///|
/// A host-backed clamped byte array, such as `ImageData.data`. Mutations write
/// through to the backing platform buffer.
#cfg(target="js")
#external
type Uint8ClampedArray

///|
/// Number of bytes in this live array.
#cfg(target="js")
pub extern "js" fn Uint8ClampedArray::length(self : Self) -> Int = "(self) => self.length"

///|
#cfg(target="js")
extern "js" fn Uint8ClampedArray::get_ffi(
  self : Self,
  index : Int,
) -> @js.Nullable[Int] = "(self, index) => self[index]"

///|
/// Returns the clamped byte at `index`, or `None` when the index is outside the
/// array (the platform yields `undefined` there).
#cfg(target="js")
pub fn Uint8ClampedArray::get(self : Self, index : Int) -> Int? {
  self.get_ffi(index).to_option()
}

///|
/// Stores `value` at `index`, saturating to 0..255 per the platform rules.
/// Writes past the end are ignored by the platform.
#cfg(target="js")
pub extern "js" fn Uint8ClampedArray::set(
  self : Self,
  index : Int,
  value : Int,
) -> Unit = "(self, index, value) => { self[index] = value }"
