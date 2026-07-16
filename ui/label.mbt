///|
const LabelBaseStyle : String = "display:flex;align-items:center;gap:0.5rem;color:var(--rui-foreground,oklch(0.145 0 0));font-size:0.875rem;line-height:1;font-weight:500;user-select:none"

///|
/// Render a native label. `disabled` supplies the standalone equivalent of
/// shadcn/ui's field-context disabled state.
pub fn[C : @html.IsChildren] label(
  for_? : String,
  disabled? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let attrs = ui_attrs(attrs).data_set("slot", "label")
  if disabled {
    ignore(attrs.aria_disabled("true").data_set("disabled", ""))
  }
  @html.label(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        LabelBaseStyle,
        ui_disabled_style(disabled),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    for_?,
    attrs~,
    children,
  )
}
