///|
const ButtonGroupBaseStyle : String = "display:flex;width:fit-content;max-width:100%;align-items:stretch;gap:0;overflow:visible"

///|
const ButtonGroupVerticalStyle : String = "flex-direction:column"

///|
const ButtonGroupHorizontalStyle : String = "flex-direction:row"

///|
const ButtonGroupTextStyle : String = "display:flex;align-items:center;gap:0.5rem;border-style:solid;border-color:var(--rui-border,oklch(0.922 0 0));border-top-width:var(--rui-control-border-top-width,var(--rui-control-border-width,1px));border-right-width:var(--rui-control-border-right-width,var(--rui-control-border-width,1px));border-bottom-width:var(--rui-control-border-bottom-width,var(--rui-control-border-width,1px));border-left-width:var(--rui-control-border-left-width,var(--rui-control-border-width,1px));border-top-left-radius:var(--rui-control-radius-top-left,var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem)));border-top-right-radius:var(--rui-control-radius-top-right,var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem)));border-bottom-right-radius:var(--rui-control-radius-bottom-right,var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem)));border-bottom-left-radius:var(--rui-control-radius-bottom-left,var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem)));background:var(--rui-muted,oklch(0.97 0 0));padding-inline:0.625rem;color:var(--rui-foreground,oklch(0.145 0 0));font-size:0.875rem;line-height:1.25rem;font-weight:500;box-shadow:0 1px 2px rgb(0 0 0 / 0.05)"

///|
fn button_group_orientation_style(orientation : SeparatorOrientation) -> String {
  match orientation {
    Horizontal => ButtonGroupHorizontalStyle
    Vertical => ButtonGroupVerticalStyle
  }
}

///|
/// Group Buttons, Toggles, inputs, or text into one contiguous Vega control.
///
/// The interaction sheet merges adjacent borders and corner radii. Keeping
/// those rules on the children preserves each control's own variant surface.
pub fn[C : @html.IsChildren] button_group(
  orientation? : SeparatorOrientation = Horizontal,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let orientation_value = separator_orientation_value(orientation)
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "button-group")
    .data_set("orientation", orientation_value)
    .role("group")
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  }
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        ButtonGroupBaseStyle,
        button_group_orientation_style(orientation),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    attrs=element_attrs,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] button_group_text(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, UiFontSans, ButtonGroupTextStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "button-group-text"),
    children,
  )
}

///|
pub fn button_group_separator(
  orientation? : SeparatorOrientation = Vertical,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let orientation_value = separator_orientation_value(orientation)
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "button-group-separator")
    .data_set("orientation", orientation_value)
    .aria_hidden("true")
  let orientation_style = match orientation {
    Horizontal => "width:100%;height:1px"
    Vertical => "width:1px;min-height:100%;align-self:stretch"
  }
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        "position:relative;flex-shrink:0;align-self:stretch;background:var(--rui-input,oklch(0.922 0 0))",
        orientation_style,
      ],
      style,
    ),
    id?,
    class?,
    title?,
    attrs=element_attrs,
    @html.nothing,
  )
}
