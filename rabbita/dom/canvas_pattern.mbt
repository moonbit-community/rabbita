///|
#cfg(target="js")
#external
type CanvasPattern

///|
#cfg(target="js")
extern "js" fn checked_to_canvas_pattern(
  value : @js.Value,
) -> @js.Nullable[CanvasPattern] =
  #| (value) => value instanceof CanvasPattern ? value : null

///|
#cfg(target="js")
pub impl @js.Cast for CanvasPattern with fn into(value) {
  checked_to_canvas_pattern(value).to_option()
}

///|
#cfg(target="js")
pub extend CanvasPattern with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for CanvasPattern with fn from(value) {
  @js.Value::cast_from(value)
}

///|
#cfg(target="js")
pub extern "js" fn CanvasPattern::set_transform(
  self : Self,
  transform : @js.Optional[DOMMatrix2DInit],
) = "(self,transform) => self.setTransform(transform)"
