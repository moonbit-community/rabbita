///|
const AspectRatioStyle : String = "position:relative;width:100%;overflow:hidden"

///|
/// Keep content at a stable width-to-height ratio without external CSS.
pub fn[C : @html.IsChildren] aspect_ratio(
  ratio? : Double = 1.0,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let safe_ratio = if ratio > 0.0 { ratio } else { 1.0 }
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "aspect-ratio"),
    style=ui_styles(
      [UiBoxSizing, AspectRatioStyle, "aspect-ratio:\{safe_ratio}"],
      style,
    ),
    children,
  )
}
