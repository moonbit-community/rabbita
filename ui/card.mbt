///|
pub(all) enum CardSize {
  Default
  Sm
} derive(Debug, Eq)

///|
const CardBaseStyle : String = "--rui-card-radius:calc(var(--rui-radius,0.625rem) + 0.125rem);display:flex;flex-direction:column;gap:var(--rui-card-spacing,1.5rem);border:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:var(--rui-card-radius,0.75rem);background:var(--rui-card,oklch(1 0 0));padding-block:var(--rui-card-spacing,1.5rem);color:var(--rui-card-foreground,oklch(0.145 0 0));font-size:0.875rem;line-height:1.25rem;box-shadow:0 1px 3px 0 rgb(0 0 0 / 0.1),0 1px 2px -1px rgb(0 0 0 / 0.1)"

///|
const CardDefaultSizeStyle : String = "--rui-card-spacing:1.5rem;--rui-card-title-size:1rem;--rui-card-title-line-height:1"

///|
const CardSmSizeStyle : String = "--rui-card-spacing:1rem;--rui-card-title-size:0.875rem;--rui-card-title-line-height:1.25rem"

///|
const CardHeaderStyle : String = "display:grid;grid-template-columns:var(--rui-card-header-columns,minmax(0,1fr));grid-template-rows:auto auto;align-items:start;column-gap:var(--rui-card-header-column-gap,0);row-gap:0.5rem;padding-inline:var(--rui-card-spacing,1.5rem);border-radius:var(--rui-card-radius,0.75rem) var(--rui-card-radius,0.75rem) 0 0"

///|
const CardTitleStyle : String = "grid-column:1;grid-row:1;min-width:0;font-size:var(--rui-card-title-size,1rem);line-height:var(--rui-card-title-line-height,1);font-weight:600;overflow-wrap:anywhere"

///|
const CardDescriptionStyle : String = "grid-column:1;grid-row:2;min-width:0;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem;line-height:1.25rem;overflow-wrap:anywhere"

///|
const CardActionStyle : String = "grid-column:2;grid-row:1 / span 2;align-self:start;justify-self:end"

///|
const CardContentStyle : String = "min-width:0;padding-inline:var(--rui-card-spacing,1.5rem)"

///|
const CardFooterStyle : String = "display:flex;align-items:center;padding-inline:var(--rui-card-spacing,1.5rem);border-radius:0 0 var(--rui-card-radius,0.875rem) var(--rui-card-radius,0.875rem)"

///|
fn card_size_style(size : CardSize) -> String {
  match size {
    Default => CardDefaultSizeStyle
    Sm => CardSmSizeStyle
  }
}

///|
fn card_size_value(size : CardSize) -> String {
  match size {
    Default => "default"
    Sm => "sm"
  }
}

///|
fn card_part_attrs(attrs : @html.Attrs?, slot : String) -> @html.Attrs {
  ui_attrs(attrs).data_set("slot", slot)
}

///|
/// Render the root of a composable Vega card.
///
/// `--rui-card-spacing` is inherited by every card part. Appending a value through
/// `style` changes the spacing of the complete composition without CSS setup.
pub fn[C : @html.IsChildren] card(
  size? : CardSize = Default,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = card_part_attrs(attrs, "card").data_set(
    "size",
    card_size_value(size),
  )
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        CardBaseStyle,
        card_size_style(size),
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
pub fn[C : @html.IsChildren] card_header(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, CardHeaderStyle], style),
    id?,
    class?,
    title?,
    attrs=card_part_attrs(attrs, "card-header"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] card_title(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, CardTitleStyle], style),
    id?,
    class?,
    title?,
    attrs=card_part_attrs(attrs, "card-title"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] card_description(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, CardDescriptionStyle], style),
    id?,
    class?,
    title?,
    attrs=card_part_attrs(attrs, "card-description"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] card_action(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, CardActionStyle], style),
    id?,
    class?,
    title?,
    attrs=card_part_attrs(attrs, "card-action"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] card_content(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, CardContentStyle], style),
    id?,
    class?,
    title?,
    attrs=card_part_attrs(attrs, "card-content"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] card_footer(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, CardFooterStyle], style),
    id?,
    class?,
    title?,
    attrs=card_part_attrs(attrs, "card-footer"),
    children,
  )
}
