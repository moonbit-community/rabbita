///|
pub(all) enum SwitchSize {
  Default
  Sm
} derive(Debug, Eq)

///|
const SwitchBaseStyle : String = "display:inline-flex;flex-shrink:0;align-items:center;--rui-control-base-bg:var(--rui-switch-unchecked,var(--rui-input,oklch(0.922 0 0)));--rui-control-base-fg:currentColor;--rui-control-base-border:transparent;--rui-control-base-shadow:0 1px 2px rgb(0 0 0 / 0.05);border:1px solid transparent;border-color:var(--rui-control-border,var(--rui-control-base-border,transparent));border-radius:9999px;margin:0;background:var(--rui-control-bg,var(--rui-control-base-bg,var(--rui-switch-unchecked,var(--rui-input,oklch(0.922 0 0)))));color:var(--rui-control-fg,var(--rui-control-base-fg,currentColor));box-shadow:var(--rui-control-shadow,var(--rui-control-base-shadow,0 1px 2px rgb(0 0 0 / 0.05)));cursor:pointer;appearance:none;-webkit-appearance:none;outline-offset:2px;vertical-align:middle"

///|
const SwitchCheckedStyle : String = "--rui-control-base-bg:var(--rui-primary,oklch(0.205 0 0))"

///|
const SwitchUncheckedStyle : String = "--rui-control-base-bg:var(--rui-switch-unchecked,var(--rui-input,oklch(0.922 0 0)))"

///|
const SwitchInvalidStyle : String = "border-color:var(--rui-destructive-border,var(--rui-destructive,oklch(0.577 0.245 27.325)));box-shadow:0 0 0 3px var(--rui-destructive-ring,oklch(0.577 0.245 27.325 / 0.2))"

///|
const SwitchSizeDefaultStyle : String = "width:2rem;height:1.15rem;padding:0"

///|
const SwitchSizeSmStyle : String = "width:1.5rem;height:0.875rem;padding:0"

///|
const SwitchThumbStyle : String = "display:block;flex-shrink:0;border-radius:9999px;pointer-events:none;transition:transform 150ms ease"

///|
const SwitchThumbSizeDefaultStyle : String = "width:1rem;height:1rem"

///|
const SwitchThumbSizeSmStyle : String = "width:0.75rem;height:0.75rem"

///|
const SwitchThumbCheckedDefaultStyle : String = "transform:translateX(calc(100% - 2px))"

///|
const SwitchThumbCheckedSmStyle : String = "transform:translateX(calc(100% - 2px))"

///|
const SwitchThumbUncheckedStyle : String = "transform:translateX(0)"

///|
const SwitchReadOnlyStyle : String = "cursor:default"

///|
const SwitchRtlCss : String =
  #|[data-slot="switch-thumb"][data-state="checked"]:dir(rtl) {
  #|  transform:translateX(calc(-100% + 2px)) !important;
  #|}
  #|

///|
#warnings("-alert_xss_vulnerable")
fn switch_rtl_stylesheet() -> @html.Html {
  // `:dir()` follows the nearest inherited direction without runtime script.
  let attrs = @html.Attrs::build()
    .data_set("rui-style", "switch-rtl")
    .inner_html(SwitchRtlCss)
  @html.style_tag(attrs~, ([] : Array[@html.Html]))
}

///|
fn switch_size_style(size : SwitchSize) -> String {
  match size {
    Default => SwitchSizeDefaultStyle
    Sm => SwitchSizeSmStyle
  }
}

///|
fn switch_size_value(size : SwitchSize) -> String {
  match size {
    Default => "default"
    Sm => "sm"
  }
}

///|
fn switch_thumb_size_style(size : SwitchSize) -> String {
  match size {
    Default => SwitchThumbSizeDefaultStyle
    Sm => SwitchThumbSizeSmStyle
  }
}

///|
fn switch_state_style(checked : Bool) -> String {
  if checked {
    SwitchCheckedStyle
  } else {
    SwitchUncheckedStyle
  }
}

///|
fn switch_thumb_state_style(checked : Bool, size : SwitchSize) -> String {
  if !checked {
    "background:var(--rui-switch-thumb-unchecked,var(--rui-background,oklch(1 0 0)));\{SwitchThumbUncheckedStyle}"
  } else {
    let position = match size {
      Default => SwitchThumbCheckedDefaultStyle
      Sm => SwitchThumbCheckedSmStyle
    }
    "background:var(--rui-switch-thumb-checked,var(--rui-background,oklch(1 0 0)));\{position}"
  }
}

///|
fn switch_invalid_style(invalid : Bool) -> String {
  if invalid {
    SwitchInvalidStyle
  } else {
    ""
  }
}

///|
fn switch_read_only_style(read_only : Bool) -> String {
  if read_only {
    SwitchReadOnlyStyle
  } else {
    ""
  }
}

///|
/// Render one switch state for the incremental wrapper.
///
/// As a native button with `role="switch"`, mouse, Space, and Enter all request
/// the next value. No hidden form input is created.
fn render_switch(
  checked? : Bool = false,
  size? : SwitchSize = Default,
  disabled? : Bool = false,
  read_only? : Bool = false,
  invalid? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  on_checked_change? : @cmd.Emit[Bool],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let state = if checked { "checked" } else { "unchecked" }
  let control_attrs = ui_attrs(attrs)
    .data_set("slot", "switch")
    .data_set("size", switch_size_value(size))
    .data_set("state", state)
  ignore(control_attrs.role("switch"))
  ignore(control_attrs.aria_checked(ui_bool(checked)))
  ignore(control_attrs.aria_disabled(ui_bool(disabled)))
  ignore(control_attrs.aria_readonly(ui_bool(read_only)))
  ignore(control_attrs.data_set(state, ""))
  if disabled {
    ignore(control_attrs.data_set("disabled", ""))
  }
  if read_only {
    ignore(control_attrs.data_set("readonly", ""))
  }
  if invalid {
    ignore(control_attrs.aria_invalid("true").data_set("invalid", ""))
  }
  if aria_label is Some(label) {
    ignore(control_attrs.aria_label(label))
  }
  if !disabled && !read_only && on_checked_change is Some(emit) {
    ignore(control_attrs.on_click_after(_ => emit(!checked)))
  }
  let thumb_attrs = @html.Attrs::build()
    .data_set("slot", "switch-thumb")
    .data_set("state", state)
    .data_set(state, "")
  if disabled {
    ignore(thumb_attrs.data_set("disabled", ""))
  }
  if read_only {
    ignore(thumb_attrs.data_set("readonly", ""))
  }
  ignore(thumb_attrs.aria_hidden("true"))
  let thumb = @html.span(
    style=[
      UiBoxSizing,
      SwitchThumbStyle,
      switch_thumb_size_style(size),
      switch_thumb_state_style(checked, size),
    ],
    attrs=thumb_attrs,
    "",
  )
  let control = @html.button(
    style=ui_styles(
      [
        UiBoxSizing,
        UiTransition,
        SwitchBaseStyle,
        switch_size_style(size),
        switch_state_style(checked),
        switch_read_only_style(read_only),
        switch_invalid_style(invalid),
        ui_disabled_visual_style(disabled),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    type_="button",
    disabled~,
    attrs=control_attrs,
    thumb,
  )
  @html.fragment([switch_rtl_stylesheet(), control])
}

///|
/// Build a black-box switch with component-local incremental state.
#cfg(target="js")
pub fn switch(
  default_checked? : Bool = false,
  size? : SwitchSize = Default,
  disabled? : Bool = false,
  read_only? : Bool = false,
  invalid? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  on_checked_change? : @cmd.Emit[Bool],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @rabbita.Val[@html.Html] {
  let (checked, set_checked) = @rabbita.create_variable(default_checked)
  checked.view(checked => {
    render_switch(
      checked~,
      size~,
      disabled~,
      read_only~,
      invalid~,
      id?,
      class?,
      title?,
      aria_label?,
      on_checked_change=@cmd.Emit(next => {
        let update = set_checked(_ => next)
        if on_checked_change is Some(notify) {
          @cmd.batch([update, notify(next)])
        } else {
          update
        }
      }),
      attrs?,
      style~,
    )
  })
}

///|
#cfg(not(target="js"))
pub fn switch(
  default_checked? : Bool = false,
  size? : SwitchSize = Default,
  disabled? : Bool = false,
  read_only? : Bool = false,
  invalid? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  on_checked_change? : @cmd.Emit[Bool],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @rabbita.Val[@html.Html] {
  ignore(on_checked_change)
  @rabbita.Val::constant(
    render_switch(
      checked=default_checked,
      size~,
      disabled~,
      read_only~,
      invalid~,
      id?,
      class?,
      title?,
      aria_label?,
      attrs?,
      style~,
    ),
  )
}
