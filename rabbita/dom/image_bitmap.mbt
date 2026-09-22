///|
#cfg(target="js")
#external
type ImageBitmap

///|
#cfg(target="js")
pub impl @js.Cast for ImageBitmap with fn into(value) {
  value |> ffi_to_image_bitmap |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub extend ImageBitmap with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for ImageBitmap with fn from(value) {
  value |> js_identity
}

///|
#cfg(target="js")
extern "js" fn ffi_to_image_bitmap(
  value : @js.Value,
) -> @js.Nullable[ImageBitmap] = "(value) => value instanceof ImageBitmap ? value : null"
