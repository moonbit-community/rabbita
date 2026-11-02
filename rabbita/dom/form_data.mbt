///|
/// https://developer.mozilla.org/en-US/docs/Web/API/FormData
#cfg(target="js")
#external
type FormData

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/FormData/FormData
#cfg(target="js")
pub extern "js" fn FormData::new() -> FormData =
  #| () => new FormData()

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/FormData/append
#cfg(target="js")
pub extern "js" fn FormData::append(
  self : Self,
  name : String,
  value : String,
) -> Unit =
  #| (self, name, value) => self.append(name, value)

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/FormData/set
#cfg(target="js")
pub extern "js" fn FormData::set(
  self : Self,
  name : String,
  value : String,
) -> Unit =
  #| (self, name, value) => self.set(name, value)

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/FormData/delete
#cfg(target="js")
pub extern "js" fn FormData::delete(self : Self, name : String) -> Unit =
  #| (self, name) => self.delete(name)

///|
/// Values are native JS strings or File objects, preserved unchanged.
/// https://developer.mozilla.org/en-US/docs/Web/API/FormData/get
#cfg(target="js")
pub extern "js" fn FormData::get(
  self : Self,
  name : String,
) -> @js.Nullable[@js.Value] =
  #| (self, name) => self.get(name)

///|
/// Values are native JS strings or File objects, preserved unchanged.
/// https://developer.mozilla.org/en-US/docs/Web/API/FormData/getAll
#cfg(target="js")
pub extern "js" fn FormData::get_all(
  self : Self,
  name : String,
) -> @js.JsArray[@js.Value] =
  #| (self, name) => self.getAll(name)

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/FormData/has
#cfg(target="js")
pub extern "js" fn FormData::has(self : Self, name : String) -> Bool =
  #| (self, name) => self.has(name)

///|
/// Uses the native Blob overload, preserving the default filename when omitted.
/// https://developer.mozilla.org/en-US/docs/Web/API/FormData/append
#cfg(target="js")
pub fn FormData::append_blob(
  self : Self,
  name : String,
  value : Blob,
  filename? : String,
) -> Unit {
  form_data_append_blob_ffi(
    self,
    name,
    value,
    @js.Optional::from_option(filename),
  )
}

///|
#cfg(target="js")
extern "js" fn form_data_append_blob_ffi(
  form : FormData,
  name : String,
  value : Blob,
  filename : @js.Optional[String],
) -> Unit =
  #| (self, name, value, filename) => filename === undefined
  #|   ? self.append(name, value)
  #|   : self.append(name, value, filename)

///|
/// Uses the native Blob overload, preserving the default filename when omitted.
/// https://developer.mozilla.org/en-US/docs/Web/API/FormData/set
#cfg(target="js")
pub fn FormData::set_blob(
  self : Self,
  name : String,
  value : Blob,
  filename? : String,
) -> Unit {
  form_data_set_blob_ffi(self, name, value, @js.Optional::from_option(filename))
}

///|
#cfg(target="js")
extern "js" fn form_data_set_blob_ffi(
  form : FormData,
  name : String,
  value : Blob,
  filename : @js.Optional[String],
) -> Unit =
  #| (self, name, value, filename) => filename === undefined
  #|   ? self.set(name, value)
  #|   : self.set(name, value, filename)
