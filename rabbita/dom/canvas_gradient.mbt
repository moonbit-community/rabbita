///|
#cfg(target="js")
#external
type CanvasGradient

///|
#cfg(target="js")
pub extern "js" fn CanvasGradient::add_color_stop(
  self : CanvasGradient,
  offset : Double,
  color : String,
) = "(self,offset,color) => self.addColorStop(offset,color)"

///|
#cfg(target="js")
extern "js" fn checked_to_canvas_gradient(
  value : @js.Value,
) -> @js.Nullable[CanvasGradient] =
  #| (value) => value instanceof CanvasGradient ? value : null

///|
#cfg(target="js")
pub impl @js.Cast for CanvasGradient with fn into(value) {
  checked_to_canvas_gradient(value).to_option()
}

///|
#cfg(target="js")
pub extend CanvasGradient with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for CanvasGradient with fn from(value) {
  @js.Value::cast_from(value)
}
