///|
pub(all) enum SeparatorOrientation {
  Horizontal
  Vertical
} derive(Debug, Eq)

///|
const SeparatorBaseStyle : String = "display:block;flex-shrink:0;background:var(--rui-border,oklch(0.922 0 0))"

///|
const SeparatorHorizontalStyle : String = "width:100%;height:1px"

///|
const SeparatorVerticalStyle : String = "width:1px;height:100%;align-self:stretch"

///|
fn separator_orientation_value(orientation : SeparatorOrientation) -> String {
  match orientation {
    Horizontal => "horizontal"
    Vertical => "vertical"
  }
}

///|
fn separator_orientation_style(orientation : SeparatorOrientation) -> String {
  match orientation {
    Horizontal => SeparatorHorizontalStyle
    Vertical => SeparatorVerticalStyle
  }
}

///|
/// Render a decorative divider by default, matching shadcn/Radix semantics.
/// Set `decorative=false` when the divider conveys document structure.
pub fn separator(
  orientation? : SeparatorOrientation = Horizontal,
  decorative? : Bool = true,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  slot? : String = "separator",
) -> @html.Html {
  let orientation_value = separator_orientation_value(orientation)
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", slot)
    .data_set("orientation", orientation_value)
  if decorative {
    ignore(element_attrs.role("none"))
  } else {
    ignore(element_attrs.role("separator").aria_orientation(orientation_value))
  }
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        SeparatorBaseStyle,
        separator_orientation_style(orientation),
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
