///|
pub(all) enum EmptyMediaVariant {
  EmptyMediaDefault
  EmptyMediaIcon
} derive(Debug, Eq)

///|
pub extend EmptyMediaVariant with Debug::{to_repr}

///|
pub extend EmptyMediaVariant with Eq::{equal, not_equal}

///|
const EmptyStyle : String = "display:flex;width:100%;min-width:0;flex:1;flex-direction:column;align-items:center;justify-content:center;gap:1rem;border:0 dashed var(--rui-border,oklch(0.922 0 0));border-radius:calc(var(--rui-radius,0.625rem) + 0.25rem);padding:var(--rui-empty-padding,1.5rem);text-align:center;text-wrap:balance"

///|
const EmptyHeaderStyle : String = "display:flex;max-width:24rem;min-width:0;flex-direction:column;align-items:center;gap:0.5rem;text-align:center;overflow-wrap:anywhere"

///|
const EmptyMediaStyle : String = "display:flex;flex-shrink:0;align-items:center;justify-content:center;margin-bottom:0.5rem"

///|
const EmptyMediaIconStyle : String = "width:2rem;height:2rem;border-radius:0.5rem;background:var(--rui-muted,oklch(0.97 0 0));color:var(--rui-foreground,oklch(0.145 0 0));--rui-icon-size:1rem"

///|
const EmptyTitleStyle : String = "font-size:0.875rem;line-height:1.25rem;font-weight:500;letter-spacing:-0.025em"

///|
const EmptyDescriptionStyle : String = "color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem;line-height:1.625"

///|
const EmptyContentStyle : String = "display:flex;width:100%;max-width:24rem;min-width:0;flex-direction:column;align-items:center;gap:0.625rem;font-size:0.875rem;text-wrap:balance;overflow-wrap:anywhere"

///|
pub fn[C : @html.IsChildren] empty(
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
    attrs=ui_attrs(attrs).data_set("slot", "empty"),
    style=ui_styles([UiBoxSizing, UiFontSans, EmptyStyle], style),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] empty_header(
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
    attrs=ui_attrs(attrs).data_set("slot", "empty-header"),
    style=ui_styles([UiBoxSizing, EmptyHeaderStyle], style),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] empty_media(
  variant? : EmptyMediaVariant = EmptyMediaDefault,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let variant_value = match variant {
    EmptyMediaDefault => "default"
    EmptyMediaIcon => "icon"
  }
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "empty-icon")
      .data_set("variant", variant_value),
    style=ui_styles(
      [
        UiBoxSizing,
        EmptyMediaStyle,
        if variant is EmptyMediaIcon {
          EmptyMediaIconStyle
        } else {
          ""
        },
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] empty_title(
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
    attrs=ui_attrs(attrs).data_set("slot", "empty-title"),
    style=ui_styles([EmptyTitleStyle], style),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] empty_description(
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
    attrs=ui_attrs(attrs).data_set("slot", "empty-description"),
    style=ui_styles([EmptyDescriptionStyle], style),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] empty_content(
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
    attrs=ui_attrs(attrs).data_set("slot", "empty-content"),
    style=ui_styles([UiBoxSizing, EmptyContentStyle], style),
    children,
  )
}
