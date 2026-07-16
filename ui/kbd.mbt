///|
const KbdStyle : String = "display:inline-flex;width:fit-content;min-width:1.25rem;height:1.25rem;align-items:center;justify-content:center;gap:0.25rem;border-radius:0.25rem;background:var(--rui-muted,oklch(0.97 0 0));padding-inline:0.25rem;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.75rem;line-height:1rem;font-weight:500;user-select:none;pointer-events:none;--rui-icon-size:0.75rem"

///|
const KbdGroupStyle : String = "display:inline-flex;align-items:center;gap:0.25rem"

///|
pub fn[C : @html.IsChildren] kbd(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.kbd(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "kbd"),
    style=ui_styles([UiBoxSizing, UiFontSans, KbdStyle], style),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] kbd_group(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.kbd(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "kbd-group"),
    style=ui_styles([UiBoxSizing, KbdGroupStyle], style),
    children,
  )
}
