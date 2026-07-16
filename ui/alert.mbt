///|
pub(all) enum AlertVariant {
  Default
  Destructive
} derive(Debug, Eq)

///|
const AlertBaseStyle : String = "position:relative;display:grid;grid-template-columns:var(--rui-alert-columns,0 minmax(0,1fr) auto);grid-template-rows:auto auto;width:100%;min-width:0;align-items:start;column-gap:var(--rui-alert-column-gap,0);row-gap:0.125rem;border:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:var(--rui-radius,0.625rem);padding:0.75rem 1rem;text-align:start;font-size:0.875rem;line-height:1.25rem;--rui-icon-size:1rem"

///|
const AlertDefaultStyle : String = "--rui-alert-description-color:var(--rui-muted-foreground,oklch(0.556 0 0));background:var(--rui-card,oklch(1 0 0));color:var(--rui-card-foreground,oklch(0.145 0 0))"

///|
const AlertDestructiveStyle : String = "--rui-alert-description-color:color-mix(in oklab,var(--rui-destructive,oklch(0.577 0.245 27.325)) 90%,transparent);background:var(--rui-card,oklch(1 0 0));color:var(--rui-destructive,oklch(0.577 0.245 27.325))"

///|
const AlertTitleStyle : String = "grid-column:2;grid-row:1;min-width:0;min-height:1rem;overflow:hidden;font-weight:500;letter-spacing:-0.025em;text-overflow:ellipsis;white-space:nowrap"

///|
const AlertDescriptionStyle : String = "grid-column:2;grid-row:2;display:grid;min-width:0;justify-items:start;gap:0.25rem;color:var(--rui-alert-description-color,var(--rui-muted-foreground,oklch(0.556 0 0)));font-size:0.875rem;line-height:1.25rem;text-wrap:balance"

///|
const AlertActionStyle : String = "grid-column:3;grid-row:1 / span 2;align-self:start;justify-self:end;margin-inline-start:1rem;transform:translate(var(--rui-alert-action-offset-inline,0.25rem),-0.125rem)"

///|
fn alert_variant_style(variant : AlertVariant) -> String {
  match variant {
    Default => AlertDefaultStyle
    Destructive => AlertDestructiveStyle
  }
}

///|
fn alert_part_attrs(attrs : @html.Attrs?, slot : String) -> @html.Attrs {
  ui_attrs(attrs).data_set("slot", slot)
}

///|
/// Render a semantic live alert using the Vega default or destructive recipe.
///
/// Title, description, and action parts occupy stable grid tracks. This keeps
/// optional actions from covering text without relying on stylesheet `:has()`.
pub fn[C : @html.IsChildren] alert(
  variant? : AlertVariant = Default,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = alert_part_attrs(attrs, "alert").role("alert")
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        AlertBaseStyle,
        alert_variant_style(variant),
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
pub fn[C : @html.IsChildren] alert_title(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, AlertTitleStyle], style),
    id?,
    class?,
    title?,
    attrs=alert_part_attrs(attrs, "alert-title"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] alert_description(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, AlertDescriptionStyle], style),
    id?,
    class?,
    title?,
    attrs=alert_part_attrs(attrs, "alert-description"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] alert_action(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, AlertActionStyle], style),
    id?,
    class?,
    title?,
    attrs=alert_part_attrs(attrs, "alert-action"),
    children,
  )
}
