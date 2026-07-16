///|
const SkeletonBaseStyle : String = "display:block;border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-accent,oklch(0.97 0 0));animation:rui-pulse 2s cubic-bezier(0.4,0,0.6,1) infinite"

///|
/// Render the Vega pulse skeleton. `theme` supplies its static keyframes and a
/// reduced-motion override; no external stylesheet is required.
pub fn skeleton(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = ui_attrs(attrs).data_set("slot", "skeleton")
  @html.div(
    style=ui_styles([UiBoxSizing, SkeletonBaseStyle], style),
    id?,
    class?,
    title?,
    attrs=element_attrs,
    @html.nothing,
  )
}
