///|
pub(all) enum TextDirection {
  Ltr
  Rtl
} derive(Debug, Eq)

///|
fn text_direction_value(direction : TextDirection) -> String {
  match direction {
    Ltr => "ltr"
    Rtl => "rtl"
  }
}

///|
/// Apply native writing direction to a subtree.
pub fn[C : @html.IsChildren] direction(
  direction? : TextDirection = Ltr,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let direction_value = text_direction_value(direction)
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .dir(direction_value)
      .data_set("slot", "direction")
      .data_set("direction", direction_value),
    style=ui_styles([UiBoxSizing], style),
    children,
  )
}
