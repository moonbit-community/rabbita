///|
pub(all) enum MarkerVariant {
  MarkerDefault
  MarkerSeparator
  MarkerBorder
} derive(Debug, Eq)

///|
const MarkerBaseStyle : String = "position:relative;display:flex;width:100%;min-height:1rem;align-items:center;gap:0.5rem;color:var(--rui-marker-fg,var(--rui-muted-foreground,oklch(0.556 0 0)));box-shadow:var(--rui-marker-shadow,none);font-size:0.875rem;line-height:1.25rem;text-align:start;outline:none"

///|
fn marker_variant_value(variant : MarkerVariant) -> String {
  match variant {
    MarkerDefault => "default"
    MarkerSeparator => "separator"
    MarkerBorder => "border"
  }
}

///|
fn marker_variant_style(variant : MarkerVariant) -> String {
  match variant {
    MarkerDefault => ""
    MarkerSeparator => "justify-content:center"
    MarkerBorder =>
      "border-bottom:1px solid var(--rui-border,oklch(0.922 0 0));padding-bottom:0.5rem"
  }
}

///|
pub fn[C : @html.IsChildren] marker(
  variant? : MarkerVariant = MarkerDefault,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "marker")
      .data_set("variant", marker_variant_value(variant)),
    style=ui_styles([MarkerBaseStyle, marker_variant_style(variant)], style),
    children,
  )
}

///|
#cfg(target="js")
fn marker_bind_disabled_link(attrs : @html.Attrs, disabled : Bool) -> Unit {
  if disabled {
    ignore(
      attrs.on_click_after(event => {
        event.prevent_default()
        @cmd.none
      }),
    )
  }
}

///|
#cfg(not(target="js"))
fn marker_bind_disabled_link(attrs : @html.Attrs, disabled : Bool) -> Unit {
  ignore((attrs, disabled))
}

///|
/// Render the marker `asChild` anchor path as a native, focusable link.
pub fn[C : @html.IsChildren] marker_link(
  href~ : String,
  variant? : MarkerVariant = MarkerDefault,
  disabled? : Bool = false,
  aria_label? : String,
  target? : @html.Target = Self,
  rel? : String,
  download? : String,
  escape? : Bool = false,
  on_click? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "marker")
    .data_set("variant", marker_variant_value(variant))
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  }
  if disabled {
    ignore(
      element_attrs.aria_disabled("true").data_set("disabled", "").tabindex(-1),
    )
  } else if on_click is Some(command) {
    ignore(element_attrs.on_click_after(_ => command))
  }
  marker_bind_disabled_link(element_attrs, disabled)
  @html.a(
    href~,
    target~,
    rel?,
    download?,
    id?,
    class?,
    title?,
    attrs=element_attrs,
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTransition,
        MarkerBaseStyle,
        marker_variant_style(variant),
        "text-decoration:underline;text-underline-offset:3px;cursor:pointer",
        ui_disabled_style(disabled),
      ],
      style,
    ),
    children,
    escape~,
  )
}

///|
pub fn[C : @html.IsChildren] marker_icon(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.span(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "marker-icon").aria_hidden("true"),
    style=ui_styles(
      [
        "display:inline-flex;width:1rem;height:1rem;flex-shrink:0;align-items:center;justify-content:center;--rui-icon-size:1rem",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] marker_content(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.span(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "marker-content"),
    style=ui_styles(["min-width:0;overflow-wrap:anywhere"], style),
    children,
  )
}
