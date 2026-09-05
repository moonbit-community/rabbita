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
pub extern "js" fn Blob::get_size(self : Self) -> Int = "(self) => self.size"

///|
#cfg(not(target="js"))
pub fn Blob::get_size(self : Self) -> Int {
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
  start : Int,
  end_ : @js.Optional[Int],
) -> Blob = "(self, start, end) => self.slice(start, end)"

///|
#cfg(target="js")
pub fn Blob::slice(self : Self, start : Int, end_? : @js.Optional[Int]) -> Blob {
  let end_value = if end_ is Some(end_) {
    end_
  } else {
    @js.Optional::undefined()
  }
  self.slice_ffi(start, end_value)
}

///|
#cfg(target="js")
extern "js" fn Blob::text_ffi(self : Self) -> @js.Promise = "(self) => self.text()"

///|
#cfg(target="js")
pub async fn Blob::text(self : Self) -> String {
  self.text_ffi().wait().cast()
}

///|
#cfg(target="js")
extern "js" fn Blob::bytes_ffi(self : Self) -> @js.Promise =
  #| (self) => self.arrayBuffer().then((buffer) => new Uint8Array(buffer))

///|
#cfg(target="js")
pub async fn Blob::bytes(self : Self) -> Bytes {
  self.bytes_ffi().wait().cast()
}

///|
#cfg(not(target="js"))
#warnings("-unused_async")
pub async fn Blob::bytes(self : Self) -> Bytes {
  self.data
}
