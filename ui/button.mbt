///|
pub(all) enum ButtonVariant {
  Default
  Outline
  Secondary
  Ghost
  Destructive
  Link
} derive(Debug, Eq)

///|
pub(all) enum ButtonSize {
  Default
  Xs
  Sm
  Lg
  Icon
  IconXs
  IconSm
  IconLg
} derive(Debug, Eq)

///|
const ButtonBaseStyle : String = "display:inline-flex;flex-shrink:0;align-items:center;justify-content:center;gap:var(--rui-button-gap,0.5rem);--rui-button-base-bg:transparent;--rui-button-base-fg:currentColor;--rui-button-base-border:transparent;--rui-button-base-shadow:none;--rui-button-padding-inline:1rem;--rui-button-icon-size:1rem;border-style:solid;border-color:var(--rui-button-border,var(--rui-button-base-border,transparent));border-top-width:var(--rui-control-border-top-width,var(--rui-control-border-width,1px));border-right-width:var(--rui-control-border-right-width,var(--rui-control-border-width,1px));border-bottom-width:var(--rui-control-border-bottom-width,var(--rui-control-border-width,1px));border-left-width:var(--rui-control-border-left-width,var(--rui-control-border-width,1px));border-top-left-radius:var(--rui-control-radius-top-left,var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem)));border-top-right-radius:var(--rui-control-radius-top-right,var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem)));border-bottom-right-radius:var(--rui-control-radius-bottom-right,var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem)));border-bottom-left-radius:var(--rui-control-radius-bottom-left,var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem)));margin:0;padding-block:0;padding-inline:var(--rui-button-padding-inline);background:var(--rui-button-bg,var(--rui-button-base-bg,transparent));background-clip:padding-box;color:var(--rui-button-fg,var(--rui-button-base-fg,currentColor));box-shadow:var(--rui-button-shadow,var(--rui-button-base-shadow,none));font-size:0.875rem;line-height:1.25rem;font-weight:500;white-space:nowrap;cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline:none;vertical-align:middle"

///|
const ButtonDefaultStyle : String = "--rui-button-base-bg:var(--rui-primary,oklch(0.205 0 0));--rui-button-base-fg:var(--rui-primary-foreground,oklch(0.985 0 0));--rui-button-base-border:transparent;--rui-button-base-shadow:none"

///|
const ButtonOutlineStyle : String = "--rui-button-base-bg:var(--rui-outline-background,var(--rui-background,oklch(1 0 0)));--rui-button-base-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-button-base-border:var(--rui-outline-border,var(--rui-input,oklch(0.922 0 0)));--rui-button-base-shadow:0 1px 2px rgb(0 0 0 / 0.05)"

///|
const ButtonSecondaryStyle : String = "--rui-button-base-bg:var(--rui-secondary,oklch(0.97 0 0));--rui-button-base-fg:var(--rui-secondary-foreground,oklch(0.205 0 0));--rui-button-base-border:transparent;--rui-button-base-shadow:none"

///|
const ButtonGhostStyle : String = "--rui-button-base-bg:transparent;--rui-button-base-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-button-base-border:transparent;--rui-button-base-shadow:none"

///|
const ButtonDestructiveStyle : String = "--rui-button-base-bg:var(--rui-destructive-surface,var(--rui-destructive,oklch(0.577 0.245 27.325)));--rui-button-base-fg:white;--rui-button-base-border:transparent;--rui-button-base-shadow:none"

///|
const ButtonLinkStyle : String = "height:auto;--rui-button-base-bg:transparent;--rui-button-base-fg:var(--rui-primary,oklch(0.205 0 0));--rui-button-base-border:transparent;--rui-button-base-shadow:none;text-underline-offset:4px"

///|
const ButtonSizeDefaultStyle : String = "height:2.25rem;--rui-button-padding-inline:1rem;--rui-button-padding-inline-with-icon:0.75rem"

///|
const ButtonSizeXsStyle : String = "height:1.5rem;--rui-button-gap:0.25rem;--rui-button-padding-inline:0.5rem;--rui-button-padding-inline-with-icon:0.375rem;--rui-button-icon-size:0.75rem;font-size:0.75rem;line-height:1rem"

///|
const ButtonSizeSmStyle : String = "height:2rem;--rui-button-gap:0.375rem;--rui-button-padding-inline:0.75rem;--rui-button-padding-inline-with-icon:0.625rem"

///|
const ButtonSizeLgStyle : String = "height:2.5rem;--rui-button-padding-inline:1.5rem;--rui-button-padding-inline-with-icon:1rem"

///|
const ButtonSizeIconStyle : String = "width:2.25rem;height:2.25rem;--rui-button-padding-inline:0"

///|
const ButtonSizeIconXsStyle : String = "width:1.5rem;height:1.5rem;--rui-button-padding-inline:0;--rui-button-icon-size:0.75rem"

///|
const ButtonSizeIconSmStyle : String = "width:2rem;height:2rem;--rui-button-padding-inline:0"

///|
const ButtonSizeIconLgStyle : String = "width:2.5rem;height:2.5rem;--rui-button-padding-inline:0"

///|
fn button_variant_value(variant : ButtonVariant) -> String {
  match variant {
    Default => "default"
    Outline => "outline"
    Secondary => "secondary"
    Ghost => "ghost"
    Destructive => "destructive"
    Link => "link"
  }
}

///|
fn button_size_value(size : ButtonSize) -> String {
  match size {
    Default => "default"
    Xs => "xs"
    Sm => "sm"
    Lg => "lg"
    Icon => "icon"
    IconXs => "icon-xs"
    IconSm => "icon-sm"
    IconLg => "icon-lg"
  }
}

///|
fn button_variant_style(variant : ButtonVariant) -> String {
  match variant {
    Default => ButtonDefaultStyle
    Outline => ButtonOutlineStyle
    Secondary => ButtonSecondaryStyle
    Ghost => ButtonGhostStyle
    Destructive => ButtonDestructiveStyle
    Link => ButtonLinkStyle
  }
}

///|
fn button_size_style(size : ButtonSize) -> String {
  match size {
    Default => ButtonSizeDefaultStyle
    Xs => ButtonSizeXsStyle
    Sm => ButtonSizeSmStyle
    Lg => ButtonSizeLgStyle
    Icon => ButtonSizeIconStyle
    IconXs => ButtonSizeIconXsStyle
    IconSm => ButtonSizeIconSmStyle
    IconLg => ButtonSizeIconLgStyle
  }
}

///|
/// Render a native button with shadcn/ui Vega variants and sizes.
///
/// User styles are appended last and therefore override the built-in recipe.
pub fn[C : @html.IsChildren] button(
  variant? : ButtonVariant = Default,
  size? : ButtonSize = Default,
  disabled? : Bool = false,
  type_? : String = "button",
  id? : String,
  class? : String,
  title? : String,
  name? : String,
  value? : String,
  autofocus? : Bool,
  on_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  slot? : String = "button",
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", slot)
    .data_set("variant", button_variant_value(variant))
    .data_set("size", button_size_value(size))
  if disabled {
    ignore(element_attrs.aria_disabled("true").data_set("disabled", ""))
  }
  @html.button(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        ButtonBaseStyle,
        button_variant_style(variant),
        button_size_style(size),
        ui_disabled_style(disabled),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    type_~,
    disabled~,
    name?,
    value?,
    autofocus?,
    on_click?,
    attrs=element_attrs,
    children,
  )
}
