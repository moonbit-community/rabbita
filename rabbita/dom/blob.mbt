///|
#cfg(target="js")
type Blob

///|
#cfg(not(target="js"))
struct Blob {
  data : Bytes
  content_type : String
}

///|
#cfg(target="js")
pub extern "js" fn Blob::get_size(self : Self) -> Int32 = "(self) => self.size"

///|
#cfg(not(target="js"))
pub fn Blob::get_size(self : Self) -> Int32 {
  self.data.length()
}

///|
#cfg(target="js")
pub extern "js" fn Blob::get_type(self : Self) -> String = "(self) => self.type"

///|
#cfg(not(target="js"))
pub fn Blob::get_type(self : Self) -> String {
  self.content_type
}

///|
#cfg(target="js")
pub extern "js" fn Blob::from_bytes(
  bytes : Bytes,
  content_type : String,
) -> Blob =
  #| (bytes, contentType) => new Blob([bytes], { type: contentType })

///|
#cfg(not(target="js"))
pub fn Blob::from_bytes(bytes : Bytes, content_type : String) -> Blob {
  { data: bytes, content_type, }
}

///|
#cfg(target="js")
extern "js" fn Blob::slice_ffi(
  self : Self,
  start : Int32,
  end_ : @js.Optional[Int32],
) -> Blob = "(self, start, end) => self.slice(start, end)"

///|
#cfg(target="js")
pub fn Blob::slice(
  self : Self,
  start : Int32,
  end_? : @js.Optional[Int32],
) -> Blob {
  let end_value = if end_ is Some(end_) {
    end_
  } else {
    @js.Optional::undefined()
  }
  self.slice_ffi(start, end_value)
}

///|
/// Reads the blob as UTF-8 text.
/// https://developer.mozilla.org/en-US/docs/Web/API/Blob/text
#cfg(target="js")
pub extern "js" fn Blob::text(self : Self) -> @js.Promise[String] = "(self) => self.text()"

///|
/// Reads the blob as bytes using the native Blob.bytes() method.
/// https://developer.mozilla.org/en-US/docs/Web/API/Blob/bytes
#cfg(target="js")
pub extern "js" fn Blob::bytes(self : Self) -> @js.Promise[Bytes] =
  #| (self) => self.bytes()

///|
#cfg(not(target="js"))
#warnings("-unused_async")
pub async fn Blob::bytes(self : Self) -> Bytes {
  self.data
}
