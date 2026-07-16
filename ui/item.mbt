///|
pub(all) enum ItemVariant {
  ItemDefault
  ItemOutline
  ItemMuted
} derive(Debug, Eq)

///|
pub(all) enum ItemSize {
  ItemDefaultSize
  ItemSm
} derive(Debug, Eq)

///|
pub(all) enum ItemMediaVariant {
  ItemMediaDefault
  ItemMediaIcon
  ItemMediaImage
} derive(Debug, Eq)

///|
const ItemGroupStyle : String = "display:flex;flex-direction:column"

///|
const ItemBaseStyle : String = "display:flex;flex-wrap:wrap;align-items:center;border:1px solid var(--rui-item-border,var(--rui-item-base-border,transparent));border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-item-bg,var(--rui-item-base-bg,transparent));color:var(--rui-item-fg,var(--rui-foreground,oklch(0.145 0 0)));box-shadow:var(--rui-item-shadow,none);font-size:0.875rem;line-height:1.25rem;text-align:start;outline:none"

///|
fn item_variant_value(variant : ItemVariant) -> String {
  match variant {
    ItemDefault => "default"
    ItemOutline => "outline"
    ItemMuted => "muted"
  }
}

///|
fn item_variant_style(variant : ItemVariant) -> String {
  match variant {
    ItemDefault =>
      "--rui-item-base-bg:transparent;--rui-item-base-border:transparent"
    ItemOutline =>
      "--rui-item-base-bg:transparent;--rui-item-base-border:var(--rui-border,oklch(0.922 0 0))"
    ItemMuted =>
      "--rui-item-base-bg:color-mix(in oklch,var(--rui-muted,oklch(0.97 0 0)) 50%,transparent);--rui-item-base-border:transparent"
  }
}

///|
fn item_size_value(size : ItemSize) -> String {
  match size {
    ItemDefaultSize => "default"
    ItemSm => "sm"
  }
}

///|
fn item_size_style(size : ItemSize) -> String {
  match size {
    ItemDefaultSize => "gap:1rem;padding:1rem"
    ItemSm => "gap:0.625rem;padding:0.75rem 1rem"
  }
}

///|
pub fn[C : @html.IsChildren] item_group(
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
    attrs=ui_attrs(attrs).role("list").data_set("slot", "item-group"),
    style=ui_styles([UiBoxSizing, ItemGroupStyle], style),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] item(
  variant? : ItemVariant = ItemDefault,
  size? : ItemSize = ItemDefaultSize,
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
      .data_set("slot", "item")
      .data_set("variant", item_variant_value(variant))
      .data_set("size", item_size_value(size)),
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTransition,
        ItemBaseStyle,
        item_variant_style(variant),
        item_size_style(size),
      ],
      style,
    ),
    children,
  )
}

///|
#cfg(target="js")
fn item_bind_disabled_link(attrs : @html.Attrs, disabled : Bool) -> Unit {
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
fn item_bind_disabled_link(attrs : @html.Attrs, disabled : Bool) -> Unit {
  ignore((attrs, disabled))
}

///|
/// Render the `asChild` anchor path from the Vega item recipe as a native link.
pub fn[C : @html.IsChildren] item_link(
  href~ : String,
  variant? : ItemVariant = ItemDefault,
  size? : ItemSize = ItemDefaultSize,
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
    .data_set("slot", "item")
    .data_set("variant", item_variant_value(variant))
    .data_set("size", item_size_value(size))
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
  item_bind_disabled_link(element_attrs, disabled)
  @html.a(
    id?,
    class?,
    title?,
    href~,
    target~,
    rel?,
    download?,
    attrs=element_attrs,
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTransition,
        ItemBaseStyle,
        item_variant_style(variant),
        item_size_style(size),
        "text-decoration:none;cursor:pointer",
        ui_disabled_style(disabled),
      ],
      style,
    ),
    children,
    escape~,
  )
}

///|
pub fn[C : @html.IsChildren] item_media(
  variant? : ItemMediaVariant = ItemMediaDefault,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let value = match variant {
    ItemMediaDefault => "default"
    ItemMediaIcon => "icon"
    ItemMediaImage => "image"
  }
  let variant_style = match variant {
    ItemMediaDefault => "background:transparent"
    ItemMediaIcon =>
      "width:2rem;height:2rem;border:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:0.25rem;background:var(--rui-muted,oklch(0.97 0 0));--rui-icon-size:1rem"
    ItemMediaImage =>
      "width:2.5rem;height:2.5rem;overflow:hidden;border-radius:0.25rem"
  }
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "item-media")
      .data_set("variant", value),
    style=ui_styles(
      [
        "display:flex;flex-shrink:0;align-items:center;justify-content:center;gap:0.5rem",
        variant_style,
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] item_content(
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
    attrs=ui_attrs(attrs).data_set("slot", "item-content"),
    style=ui_styles(
      ["display:flex;min-width:0;flex:1;flex-direction:column;gap:0.25rem"],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] item_title(
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
    attrs=ui_attrs(attrs).data_set("slot", "item-title"),
    style=ui_styles(
      [
        "display:flex;width:fit-content;max-width:100%;min-width:0;align-items:center;gap:0.5rem;font-size:0.875rem;line-height:1.375;font-weight:500;overflow-wrap:anywhere",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] item_description(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.p(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "item-description"),
    style=ui_styles(
      [
        "display:-webkit-box;overflow:hidden;margin:0;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem;line-height:1.5;font-weight:400;text-wrap:balance;overflow-wrap:anywhere;-webkit-box-orient:vertical;-webkit-line-clamp:2",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] item_actions(
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
    attrs=ui_attrs(attrs).data_set("slot", "item-actions"),
    style=ui_styles(["display:flex;align-items:center;gap:0.5rem"], style),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] item_header(
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
    attrs=ui_attrs(attrs).data_set("slot", "item-header"),
    style=ui_styles(
      [
        "display:flex;flex-basis:100%;align-items:center;justify-content:space-between;gap:0.5rem",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] item_footer(
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
    attrs=ui_attrs(attrs).data_set("slot", "item-footer"),
    style=ui_styles(
      [
        "display:flex;flex-basis:100%;align-items:center;justify-content:space-between;gap:0.5rem",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn item_separator(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  separator(
    slot="item-separator",
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "item-separator"),
    style~,
  )
}
