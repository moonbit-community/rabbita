///|
const PaginationRootStyle : String = "display:flex;width:100%;min-width:0;justify-content:center;margin-inline:auto"

///|
const PaginationContentStyle : String = "display:flex;max-width:100%;flex-wrap:nowrap;align-items:center;justify-content:center;gap:0.25rem;margin:0;padding:0;list-style:none"

///|
const PaginationItemStyle : String = "display:block"

///|
const PaginationLinkResetStyle : String = "text-decoration:none"

///|
const PaginationPreviousStyle : String = "padding-inline-start:0.5rem"

///|
const PaginationNextStyle : String = "padding-inline-end:0.5rem"

///|
const PaginationChevronBoxStyle : String = "display:inline-flex;width:1rem;height:1rem;flex-shrink:0;align-items:center;justify-content:center"

///|
const PaginationChevronStyle : String = "display:block;width:0.4375rem;height:0.4375rem;border-right:1.5px solid currentColor;border-bottom:1.5px solid currentColor;transform-origin:center"

///|
const PaginationChevronPreviousStyle : String = "transform:rotate(135deg)"

///|
const PaginationChevronNextStyle : String = "transform:rotate(-45deg)"

///|
const PaginationEllipsisStyle : String = "display:inline-flex;width:2.25rem;height:2.25rem;align-items:center;justify-content:center;color:var(--rui-muted-foreground,oklch(0.556 0 0))"

///|
const PaginationDotsStyle : String = "display:block;width:0.1875rem;height:0.1875rem;border-radius:9999px;background:currentColor;box-shadow:-0.3125rem 0 currentColor,0.3125rem 0 currentColor"

///|
const PaginationScreenReaderOnlyStyle : String = "position:absolute;width:1px;height:1px;margin:-1px;padding:0;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border:0"

///|
fn pagination_part_attrs(attrs : @html.Attrs?, slot : String) -> @html.Attrs {
  ui_attrs(attrs).data_set("slot", slot)
}

///|
fn pagination_state(is_active : Bool) -> String {
  if is_active {
    "active"
  } else {
    "inactive"
  }
}

///|
#cfg(target="js")
fn pagination_bind_disabled(attrs : @html.Attrs, disabled : Bool) -> Unit {
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
fn pagination_bind_disabled(attrs : @html.Attrs, disabled : Bool) -> Unit {
  ignore((attrs, disabled))
}

///|
/// Render the semantic navigation root for a pagination control.
pub fn[C : @html.IsChildren] pagination(
  aria_label? : String = "pagination",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = pagination_part_attrs(attrs, "pagination")
    .role("navigation")
    .aria_label(aria_label)
  @html.nav(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, PaginationRootStyle],
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
/// Render the list that contains pagination items.
pub fn[C : @html.IsChildren] pagination_content(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.ul(
    style=ui_styles([UiBoxSizing, PaginationContentStyle], style),
    id?,
    class?,
    title?,
    attrs=pagination_part_attrs(attrs, "pagination-content"),
    children,
  )
}

///|
/// Render one semantic list item in a pagination control.
pub fn[C : @html.IsChildren] pagination_item(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.li(
    style=ui_styles([UiBoxSizing, PaginationItemStyle], style),
    id?,
    class?,
    title?,
    attrs=pagination_part_attrs(attrs, "pagination-item"),
    children,
  )
}

///|
/// Render a native page anchor using the Vega button recipe.
///
/// Active links expose both `aria-current="page"` and stable data state.
pub fn[C : @html.IsChildren] pagination_link(
  href~ : String,
  is_active? : Bool = false,
  disabled? : Bool = false,
  size? : ButtonSize = Icon,
  aria_label? : String,
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
  let variant : ButtonVariant = if is_active { Outline } else { Ghost }
  let element_attrs = pagination_part_attrs(attrs, "pagination-link")
    .data_set("active", ui_bool(is_active))
    .data_set("state", pagination_state(is_active))
    .data_set("variant", button_variant_value(variant))
    .data_set("size", button_size_value(size))
  if is_active {
    ignore(element_attrs.aria_current("page"))
  }
  if disabled {
    ignore(
      element_attrs.aria_disabled("true").data_set("disabled", "").tabindex(-1),
    )
  }
  pagination_bind_disabled(element_attrs, disabled)
  if aria_label is Some(aria_label) {
    ignore(element_attrs.aria_label(aria_label))
  }
  @html.a(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        ButtonBaseStyle,
        PaginationLinkResetStyle,
        button_variant_style(variant),
        button_size_style(size),
        ui_disabled_style(disabled),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    href~,
    target~,
    rel?,
    download?,
    attrs=element_attrs,
    children,
    escape~,
  )
}

///|
/// Render a previous-page anchor with a dependency-free CSS chevron.
pub fn pagination_previous(
  href~ : String,
  disabled? : Bool = false,
  text? : String = "Previous",
  aria_label? : String = "Go to previous page",
  target? : @html.Target = Self,
  rel? : String,
  download? : String,
  escape? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = ui_attrs(attrs).data_set("direction", "previous")
  pagination_link(
    href~,
    disabled~,
    size=Default,
    aria_label~,
    target~,
    rel?,
    download?,
    escape~,
    id?,
    class?,
    title?,
    attrs=element_attrs,
    style=ui_styles([PaginationPreviousStyle], style),
    [
      @html.span(
        style=[UiBoxSizing, PaginationChevronBoxStyle],
        attrs=@html.Attrs::build()
          .aria_hidden("true")
          .data_set("icon", "inline-start"),
        @html.span(
          style=[
            UiBoxSizing,
            PaginationChevronStyle,
            PaginationChevronPreviousStyle,
          ],
          @html.nothing,
        ),
      ),
      @html.span(text),
    ],
  )
}

///|
/// Render a next-page anchor with a dependency-free CSS chevron.
pub fn pagination_next(
  href~ : String,
  disabled? : Bool = false,
  text? : String = "Next",
  aria_label? : String = "Go to next page",
  target? : @html.Target = Self,
  rel? : String,
  download? : String,
  escape? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = ui_attrs(attrs).data_set("direction", "next")
  pagination_link(
    href~,
    disabled~,
    size=Default,
    aria_label~,
    target~,
    rel?,
    download?,
    escape~,
    id?,
    class?,
    title?,
    attrs=element_attrs,
    style=ui_styles([PaginationNextStyle], style),
    [
      @html.span(text),
      @html.span(
        style=[UiBoxSizing, PaginationChevronBoxStyle],
        attrs=@html.Attrs::build()
          .aria_hidden("true")
          .data_set("icon", "inline-end"),
        @html.span(
          style=[
            UiBoxSizing,
            PaginationChevronStyle,
            PaginationChevronNextStyle,
          ],
          @html.nothing,
        ),
      ),
    ],
  )
}

///|
/// Render the collapsed-range marker used by long pagination controls.
pub fn pagination_ellipsis(
  label? : String = "More pages",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = pagination_part_attrs(attrs, "pagination-ellipsis")
    .role("presentation")
    .aria_hidden("true")
  @html.span(
    style=ui_styles([UiBoxSizing, PaginationEllipsisStyle], style),
    id?,
    class?,
    title?,
    attrs=element_attrs,
    [
      @html.span(
        style=[UiBoxSizing, PaginationDotsStyle],
        attrs=@html.Attrs::build().data_set("icon", "ellipsis"),
        @html.nothing,
      ),
      @html.span(style=[PaginationScreenReaderOnlyStyle], label),
    ],
  )
}
