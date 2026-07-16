///|
pub(all) enum ToggleVariant {
  Default
  Outline
} derive(Debug, Eq)

///|
pub(all) enum ToggleSize {
  Default
  Sm
  Lg
} derive(Debug, Eq)

///|
const ToggleBaseStyle : String = "display:inline-flex;flex-shrink:0;align-items:center;justify-content:center;gap:0.5rem;--rui-toggle-base-bg:transparent;--rui-toggle-base-fg:currentColor;--rui-toggle-base-border:transparent;--rui-toggle-base-shadow:none;--rui-toggle-base-radius:var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem));--rui-toggle-padding-inline:0.5rem;--rui-toggle-icon-size:1rem;border:var(--rui-control-border-width,1px) solid transparent;border-block-start-width:var(--rui-toggle-border-block-start-width,var(--rui-control-border-width,1px));border-inline-start-width:var(--rui-toggle-border-inline-start-width,var(--rui-control-border-width,1px));border-color:var(--rui-toggle-border,var(--rui-toggle-base-border,transparent));border-radius:var(--rui-toggle-radius,var(--rui-toggle-base-radius,var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem))));margin:0;padding-block:0;padding-inline:var(--rui-toggle-padding-inline);background:var(--rui-toggle-bg,var(--rui-toggle-base-bg,transparent));background-clip:padding-box;color:var(--rui-toggle-fg,var(--rui-toggle-base-fg,currentColor));box-shadow:var(--rui-toggle-shadow,var(--rui-toggle-base-shadow,none));font-size:0.875rem;line-height:1.25rem;font-weight:500;white-space:nowrap;cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline:none;vertical-align:middle"

///|
const ToggleDefaultStyle : String = "--rui-toggle-base-bg:transparent;--rui-toggle-base-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-toggle-base-border:transparent;--rui-toggle-base-shadow:none"

///|
const ToggleOutlineStyle : String = "--rui-toggle-base-bg:transparent;--rui-toggle-base-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-toggle-base-border:var(--rui-outline-border,var(--rui-input,oklch(0.922 0 0)));--rui-toggle-base-shadow:0 1px 2px rgb(0 0 0 / 0.05)"

///|
const TogglePressedStyle : String = "--rui-toggle-base-bg:var(--rui-accent,oklch(0.97 0 0));--rui-toggle-base-fg:var(--rui-accent-foreground,oklch(0.205 0 0))"

///|
const ToggleInvalidStyle : String = "border-color:var(--rui-destructive,oklch(0.577 0.245 27.325));box-shadow:0 0 0 3px var(--rui-destructive-ring,oklch(0.577 0.245 27.325 / 0.2))"

///|
const ToggleSizeDefaultStyle : String = "min-width:2.25rem;height:2.25rem;--rui-toggle-padding-inline:0.5rem"

///|
const ToggleSizeSmStyle : String = "min-width:2rem;height:2rem;--rui-toggle-padding-inline:0.375rem"

///|
const ToggleSizeLgStyle : String = "min-width:2.5rem;height:2.5rem;--rui-toggle-padding-inline:0.625rem"

///|
fn toggle_variant_style(variant : ToggleVariant) -> String {
  match variant {
    Default => ToggleDefaultStyle
    Outline => ToggleOutlineStyle
  }
}

///|
fn toggle_variant_value(variant : ToggleVariant) -> String {
  match variant {
    Default => "default"
    Outline => "outline"
  }
}

///|
fn toggle_size_style(size : ToggleSize) -> String {
  match size {
    Default => ToggleSizeDefaultStyle
    Sm => ToggleSizeSmStyle
    Lg => ToggleSizeLgStyle
  }
}

///|
fn toggle_size_value(size : ToggleSize) -> String {
  match size {
    Default => "default"
    Sm => "sm"
    Lg => "lg"
  }
}

///|
fn toggle_pressed_style(pressed : Bool) -> String {
  if pressed {
    TogglePressedStyle
  } else {
    ""
  }
}

///|
fn toggle_invalid_style(invalid : Bool) -> String {
  if invalid {
    ToggleInvalidStyle
  } else {
    ""
  }
}

///|
/// Render one toggle state for the incremental wrapper and Toggle Group.
///
/// User styles are appended last and therefore override the built-in recipe.
fn[C : @html.IsChildren] render_toggle(
  pressed? : Bool = false,
  variant? : ToggleVariant = Default,
  size? : ToggleSize = Default,
  disabled? : Bool = false,
  invalid? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  on_pressed_change? : @cmd.Emit[Bool],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  slot? : String = "toggle",
  children : C,
) -> @html.Html {
  let control_attrs = ui_attrs(attrs)
    .data_set("slot", slot)
    .data_set("variant", toggle_variant_value(variant))
    .data_set("size", toggle_size_value(size))
  ignore(control_attrs.aria_pressed(ui_bool(pressed)))
  ignore(control_attrs.aria_disabled(ui_bool(disabled)))
  ignore(control_attrs.data_set("state", if pressed { "on" } else { "off" }))
  if pressed {
    ignore(control_attrs.data_set("pressed", ""))
  }
  if disabled {
    ignore(control_attrs.data_set("disabled", ""))
  }
  if invalid {
    ignore(control_attrs.aria_invalid("true").data_set("invalid", ""))
  }
  if aria_label is Some(label) {
    ignore(control_attrs.aria_label(label))
  }
  if !disabled && on_pressed_change is Some(emit) {
    ignore(control_attrs.on_click_after(_ => emit(!pressed)))
  }
  @html.button(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        ToggleBaseStyle,
        toggle_variant_style(variant),
        toggle_pressed_style(pressed),
        toggle_size_style(size),
        toggle_invalid_style(invalid),
        ui_disabled_style(disabled),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    type_="button",
    disabled~,
    attrs=control_attrs,
    children,
  )
}

///|
/// Build a black-box toggle with component-local incremental state.
#cfg(target="js")
pub fn[C : @html.IsChildren] toggle(
  default_pressed? : Bool = false,
  variant? : ToggleVariant = Default,
  size? : ToggleSize = Default,
  disabled? : Bool = false,
  invalid? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  on_pressed_change? : @cmd.Emit[Bool],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  slot? : String = "toggle",
  children : C,
) -> @rabbita.Val[@html.Html] {
  let (pressed, set_pressed) = @rabbita.create_variable(default_pressed)
  pressed.view(pressed => {
    render_toggle(
      pressed~,
      variant~,
      size~,
      disabled~,
      invalid~,
      id?,
      class?,
      title?,
      aria_label?,
      on_pressed_change=@cmd.Emit(next => {
        let update = set_pressed(_ => next)
        if on_pressed_change is Some(notify) {
          @cmd.batch([update, notify(next)])
        } else {
          update
        }
      }),
      attrs?,
      style~,
      slot~,
      children,
    )
  })
}

///|
#cfg(not(target="js"))
pub fn[C : @html.IsChildren] toggle(
  default_pressed? : Bool = false,
  variant? : ToggleVariant = Default,
  size? : ToggleSize = Default,
  disabled? : Bool = false,
  invalid? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  on_pressed_change? : @cmd.Emit[Bool],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  slot? : String = "toggle",
  children : C,
) -> @rabbita.Val[@html.Html] {
  ignore(on_pressed_change)
  @rabbita.Val::constant(
    render_toggle(
      pressed=default_pressed,
      variant~,
      size~,
      disabled~,
      invalid~,
      id?,
      class?,
      title?,
      aria_label?,
      attrs?,
      style~,
      slot~,
      children,
    ),
  )
}
