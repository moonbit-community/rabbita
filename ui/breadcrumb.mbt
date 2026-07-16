///|
const BreadcrumbRootStyle : String = "display:block"

///|
const BreadcrumbListStyle : String = "display:flex;flex-wrap:wrap;align-items:center;gap:clamp(0.375rem,1vw,0.625rem);margin:0;padding:0;list-style:none;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem;line-height:1.25rem;overflow-wrap:anywhere"

///|
const BreadcrumbItemStyle : String = "display:inline-flex;align-items:center;gap:0.375rem;min-width:0"

///|
const BreadcrumbLinkStyle : String = "min-width:0;border-radius:0.25rem;color:var(--rui-link-fg,var(--rui-link-base-fg,inherit));text-decoration:none;overflow-wrap:anywhere;outline-offset:2px;transition:color 150ms ease"

///|
const BreadcrumbPageStyle : String = "color:var(--rui-foreground,oklch(0.145 0 0));font-weight:400"

///|
const BreadcrumbSeparatorStyle : String = "display:inline-flex;align-items:center;justify-content:center;color:inherit"

///|
const BreadcrumbChevronBoxStyle : String = "display:inline-flex;width:0.875rem;height:0.875rem;flex-shrink:0;align-items:center;justify-content:center"

///|
const BreadcrumbChevronStyle : String = "display:block;width:0.4375rem;height:0.4375rem;border-right:1.5px solid currentColor;border-bottom:1.5px solid currentColor;transform:rotate(-45deg);transform-origin:center"

///|
const BreadcrumbEllipsisStyle : String = "display:inline-flex;width:1.25rem;height:1.25rem;align-items:center;justify-content:center;color:inherit"

///|
const BreadcrumbDotsStyle : String = "display:block;width:0.1875rem;height:0.1875rem;border-radius:9999px;background:currentColor;box-shadow:-0.3125rem 0 currentColor,0.3125rem 0 currentColor"

///|
const BreadcrumbScreenReaderOnlyStyle : String = "position:absolute;width:1px;height:1px;margin:-1px;padding:0;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border:0"

///|
fn breadcrumb_part_attrs(attrs : @html.Attrs?, slot : String) -> @html.Attrs {
  ui_attrs(attrs).data_set("slot", slot)
}

///|
/// Render the semantic navigation root for a breadcrumb trail.
pub fn[C : @html.IsChildren] breadcrumb(
  aria_label? : String = "breadcrumb",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = breadcrumb_part_attrs(attrs, "breadcrumb").aria_label(
    aria_label,
  )
  @html.nav(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, BreadcrumbRootStyle],
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
/// Render the ordered list that contains breadcrumb items.
pub fn[C : @html.IsChildren] breadcrumb_list(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.ol(
    style=ui_styles([UiBoxSizing, BreadcrumbListStyle], style),
    id?,
    class?,
    title?,
    attrs=breadcrumb_part_attrs(attrs, "breadcrumb-list"),
    children,
  )
}

///|
/// Render one semantic list item in a breadcrumb trail.
pub fn[C : @html.IsChildren] breadcrumb_item(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.li(
    style=ui_styles([UiBoxSizing, BreadcrumbItemStyle], style),
    id?,
    class?,
    title?,
    attrs=breadcrumb_part_attrs(attrs, "breadcrumb-item"),
    children,
  )
}

///|
/// Render a native anchor for a navigable breadcrumb item.
pub fn[C : @html.IsChildren] breadcrumb_link(
  href~ : String,
  target? : @html.Target = Self,
  rel? : String,
  download? : String,
  escape? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.a(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTransition, BreadcrumbLinkStyle],
      style,
    ),
    id?,
    class?,
    title?,
    href~,
    target~,
    rel?,
    download?,
    attrs=breadcrumb_part_attrs(attrs, "breadcrumb-link"),
    children,
    escape~,
  )
}

///|
/// Render the non-navigable current page in a breadcrumb trail.
pub fn[C : @html.IsChildren] breadcrumb_page(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = breadcrumb_part_attrs(attrs, "breadcrumb-page")
    .role("link")
    .aria_disabled("true")
    .aria_current("page")
    .data_set("state", "current")
  @html.span(
    style=ui_styles([UiBoxSizing, BreadcrumbPageStyle], style),
    id?,
    class?,
    title?,
    attrs=element_attrs,
    children,
  )
}

///|
/// Render a presentational breadcrumb separator.
///
/// Without `children`, a dependency-free CSS chevron is rendered. Pass a
/// single `Html` value to replace it with a custom separator.
pub fn breadcrumb_separator(
  children? : @html.Html,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let content = children.unwrap_or(
    @html.span(
      style=[UiBoxSizing, BreadcrumbChevronBoxStyle],
      attrs=@html.Attrs::build().data_set("icon", "inline-end"),
      @html.span(style=[UiBoxSizing, BreadcrumbChevronStyle], @html.nothing),
    ),
  )
  let element_attrs = breadcrumb_part_attrs(attrs, "breadcrumb-separator")
    .role("presentation")
    .aria_hidden("true")
  @html.li(
    style=ui_styles([UiBoxSizing, BreadcrumbSeparatorStyle], style),
    id?,
    class?,
    title?,
    attrs=element_attrs,
    content,
  )
}

///|
/// Render the collapsed-range marker used by long breadcrumb trails.
pub fn breadcrumb_ellipsis(
  label? : String = "More",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = breadcrumb_part_attrs(attrs, "breadcrumb-ellipsis")
    .role("presentation")
    .aria_hidden("true")
  @html.span(
    style=ui_styles([UiBoxSizing, BreadcrumbEllipsisStyle], style),
    id?,
    class?,
    title?,
    attrs=element_attrs,
    [
      @html.span(
        style=[UiBoxSizing, BreadcrumbDotsStyle],
        attrs=@html.Attrs::build().data_set("icon", "ellipsis"),
        @html.nothing,
      ),
      @html.span(style=[BreadcrumbScreenReaderOnlyStyle], label),
    ],
  )
}
