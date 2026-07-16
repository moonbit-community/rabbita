///|
pub(all) enum BadgeVariant {
  Default
  Secondary
  Destructive
  Outline
  Ghost
  Link
} derive(Debug, Eq)

///|
const BadgeBaseStyle : String = "display:inline-flex;width:fit-content;height:1.25rem;flex-shrink:0;align-items:center;justify-content:center;gap:0.25rem;overflow:hidden;border:1px solid var(--rui-badge-border,var(--rui-badge-base-border,transparent));border-radius:9999px;padding:0.125rem 0.5rem;background:var(--rui-badge-bg,var(--rui-badge-base-bg,transparent));color:var(--rui-badge-fg,var(--rui-badge-base-fg,currentColor));box-shadow:var(--rui-badge-shadow,none);font-size:0.75rem;line-height:1rem;font-weight:500;white-space:nowrap;vertical-align:middle;outline:none;--rui-icon-size:0.75rem"

///|
const BadgeDefaultStyle : String = "--rui-badge-base-bg:var(--rui-primary,oklch(0.205 0 0));--rui-badge-base-fg:var(--rui-primary-foreground,oklch(0.985 0 0));--rui-badge-base-border:transparent"

///|
const BadgeSecondaryStyle : String = "--rui-badge-base-bg:var(--rui-secondary,oklch(0.97 0 0));--rui-badge-base-fg:var(--rui-secondary-foreground,oklch(0.205 0 0));--rui-badge-base-border:transparent"

///|
const BadgeDestructiveStyle : String = "--rui-badge-base-bg:var(--rui-destructive-surface,var(--rui-destructive,oklch(0.577 0.245 27.325)));--rui-badge-base-fg:white;--rui-badge-base-border:transparent"

///|
const BadgeOutlineStyle : String = "--rui-badge-base-bg:transparent;--rui-badge-base-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-badge-base-border:var(--rui-border,oklch(0.922 0 0))"

///|
const BadgeGhostStyle : String = "--rui-badge-base-bg:transparent;--rui-badge-base-fg:var(--rui-muted-foreground,oklch(0.556 0 0));--rui-badge-base-border:transparent"

///|
const BadgeLinkStyle : String = "--rui-badge-base-bg:transparent;--rui-badge-base-fg:var(--rui-primary,oklch(0.205 0 0));--rui-badge-base-border:transparent;text-underline-offset:4px"

///|
fn badge_variant_style(variant : BadgeVariant) -> String {
  match variant {
    Default => BadgeDefaultStyle
    Secondary => BadgeSecondaryStyle
    Destructive => BadgeDestructiveStyle
    Outline => BadgeOutlineStyle
    Ghost => BadgeGhostStyle
    Link => BadgeLinkStyle
  }
}

///|
fn badge_variant_value(variant : BadgeVariant) -> String {
  match variant {
    Default => "default"
    Secondary => "secondary"
    Destructive => "destructive"
    Outline => "outline"
    Ghost => "ghost"
    Link => "link"
  }
}

///|
pub fn[C : @html.IsChildren] badge(
  variant? : BadgeVariant = Default,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "badge")
    .data_set("variant", badge_variant_value(variant))
  @html.span(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        BadgeBaseStyle,
        badge_variant_style(variant),
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
#cfg(target="js")
fn badge_bind_disabled_link(attrs : @html.Attrs, disabled : Bool) -> Unit {
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
fn badge_bind_disabled_link(attrs : @html.Attrs, disabled : Bool) -> Unit {
  ignore((attrs, disabled))
}

///|
/// Render the `asChild` anchor path from the Vega badge recipe as a native link.
pub fn[C : @html.IsChildren] badge_link(
  href~ : String,
  variant? : BadgeVariant = Default,
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
    .data_set("slot", "badge")
    .data_set("variant", badge_variant_value(variant))
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
  badge_bind_disabled_link(element_attrs, disabled)
  @html.a(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        BadgeBaseStyle,
        badge_variant_style(variant),
        "text-decoration:none;cursor:pointer",
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
