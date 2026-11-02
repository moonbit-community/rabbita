///|
/// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer
#cfg(target="js")
#external
type ArrayBuffer

///|
/// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer/byteLength
#cfg(target="js")
pub extern "js" fn ArrayBuffer::get_byte_length(self : Self) -> Double =
  #| self => self.byteLength

///|
/// Creates a Uint8Array view of this buffer without copying its data.
#cfg(target="js")
pub extern "js" fn ArrayBuffer::to_bytes(self : Self) -> Bytes =
  #| self => new Uint8Array(self)
