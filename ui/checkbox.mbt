///|
const CheckboxBaseStyle : String = "display:inline-flex;width:1rem;height:1rem;flex-shrink:0;align-items:center;justify-content:center;--rui-control-base-bg:var(--rui-input-background,transparent);--rui-control-base-fg:var(--rui-primary-foreground,oklch(0.985 0 0));--rui-control-base-border:var(--rui-input,oklch(0.922 0 0));--rui-control-base-shadow:0 1px 2px rgb(0 0 0 / 0.05);border:1px solid transparent;border-color:var(--rui-control-border,var(--rui-control-base-border,var(--rui-input,oklch(0.922 0 0))));border-radius:calc(var(--rui-radius,0.625rem) - 0.375rem);margin:0;padding:0;background:var(--rui-control-bg,var(--rui-control-base-bg,var(--rui-input-background,transparent)));color:var(--rui-control-fg,var(--rui-control-base-fg,var(--rui-primary-foreground,oklch(0.985 0 0))));box-shadow:var(--rui-control-shadow,var(--rui-control-base-shadow,0 1px 2px rgb(0 0 0 / 0.05)));cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;vertical-align:middle;outline-offset:2px"

///|
const CheckboxCheckedStyle : String = "--rui-control-base-border:var(--rui-primary,oklch(0.205 0 0));--rui-control-base-bg:var(--rui-primary,oklch(0.205 0 0))"

///|
const CheckboxUncheckedStyle : String = "--rui-control-base-border:var(--rui-input,oklch(0.922 0 0));--rui-control-base-bg:var(--rui-input-background,transparent)"

///|
const CheckboxInvalidStyle : String = "border-color:var(--rui-destructive-border,var(--rui-destructive,oklch(0.577 0.245 27.325)));box-shadow:0 0 0 3px var(--rui-destructive-ring,oklch(0.577 0.245 27.325 / 0.2))"

///|
const CheckboxReadOnlyStyle : String = "cursor:default"

///|
const CheckboxIndicatorStyle : String = "display:block;box-sizing:border-box;flex-shrink:0;pointer-events:none;transition:opacity 100ms ease,transform 100ms ease"

///|
fn checkbox_state(checked : Bool, indeterminate : Bool) -> (String, String) {
  if indeterminate {
    ("mixed", "indeterminate")
  } else if checked {
    ("true", "checked")
  } else {
    ("false", "unchecked")
  }
}

///|
fn checkbox_state_style(checked : Bool, indeterminate : Bool) -> String {
  if checked || indeterminate {
    CheckboxCheckedStyle
  } else {
    CheckboxUncheckedStyle
  }
}

///|
fn checkbox_read_only_style(read_only : Bool) -> String {
  if read_only {
    CheckboxReadOnlyStyle
  } else {
    ""
  }
}

///|
fn checkbox_invalid_style(invalid : Bool) -> String {
  if invalid {
    CheckboxInvalidStyle
  } else {
    ""
  }
}

///|
fn checkbox_indicator_state_style(
  checked : Bool,
  indeterminate : Bool,
) -> String {
  if indeterminate {
    "width:0.5rem;height:0.125rem;border-radius:9999px;background:currentColor;opacity:1;transform:scale(1)"
  } else if checked {
    "width:0.375rem;height:0.625rem;border-right:0.125rem solid currentColor;border-bottom:0.125rem solid currentColor;opacity:1;transform:translateY(-0.0625rem) rotate(45deg)"
  } else {
    "width:0.375rem;height:0.625rem;opacity:0;transform:scale(0.75)"
  }
}

///|
/// Render one checkbox state for the incremental wrapper.
///
/// Mouse activation and Space request the next value through
/// `on_checked_change`. Enter's native button activation is cancelled so it
/// intentionally does not change this checkbox.
/// The component is not a form control and does not create a hidden input.
fn render_checkbox(
  checked? : Bool = false,
  indeterminate? : Bool = false,
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
  let (aria_checked, data_state) = checkbox_state(checked, indeterminate)
  let next_checked = !checked
  let control_attrs = ui_attrs(attrs).data_set("slot", "checkbox")
  ignore(control_attrs.role("checkbox"))
  ignore(control_attrs.aria_checked(aria_checked))
  ignore(control_attrs.aria_disabled(ui_bool(disabled)))
  ignore(control_attrs.aria_readonly(ui_bool(read_only)))
  ignore(control_attrs.data_set("state", data_state))
  if indeterminate {
    ignore(control_attrs.data_set("indeterminate", ""))
  } else if checked {
    ignore(control_attrs.data_set("checked", ""))
  } else {
    ignore(control_attrs.data_set("unchecked", ""))
  }
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
  ignore(control_attrs.prevent_keydown_default("Enter"))
  if !disabled && !read_only && on_checked_change is Some(emit) {
    ignore(control_attrs.on_click_after(_ => emit(next_checked)))
  }
  let indicator_attrs = @html.Attrs::build()
    .data_set("slot", "checkbox-indicator")
    .data_set("state", data_state)
  if indeterminate {
    ignore(indicator_attrs.data_set("indeterminate", ""))
  } else if checked {
    ignore(indicator_attrs.data_set("checked", ""))
  } else {
    ignore(indicator_attrs.data_set("unchecked", ""))
  }
  ignore(indicator_attrs.aria_hidden("true"))
  let indicator = @html.span(
    style=[
      UiBoxSizing,
      CheckboxIndicatorStyle,
      checkbox_indicator_state_style(checked, indeterminate),
    ],
    attrs=indicator_attrs,
    "",
  )
  @html.button(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        CheckboxBaseStyle,
        checkbox_state_style(checked, indeterminate),
        checkbox_read_only_style(read_only),
        checkbox_invalid_style(invalid),
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
    indicator,
  )
}

///|
priv struct CheckboxModel {
  checked : Bool
  indeterminate : Bool
} derive(Eq)

///|
priv enum CheckboxMsg {
  CheckboxChange(Bool)
}

///|
/// Build a black-box checkbox with component-local incremental state.
#cfg(target="js")
pub fn checkbox(
  default_checked? : Bool = false,
  default_indeterminate? : Bool = false,
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
  let initial = {
    checked: default_checked,
    indeterminate: default_indeterminate,
  }
  let (model, emit) = @rabbita.create_state(initial, update=fn(_, msg, _) {
    let next = match msg {
      CheckboxChange(checked) => { checked, indeterminate: false }
    }
    let command = if on_checked_change is Some(notify) {
      notify(next.checked)
    } else {
      @cmd.none
    }
    (next, command)
  })
  model.view(model => {
    render_checkbox(
      checked=model.checked,
      indeterminate=model.indeterminate,
      disabled~,
      read_only~,
      invalid~,
      id?,
      class?,
      title?,
      aria_label?,
      on_checked_change=@cmd.Emit(checked => emit(CheckboxChange(checked))),
      attrs?,
      style~,
    )
  })
}

///|
/// Native/SSR fallback for `checkbox`: render the initial state as a constant
/// incremental value.
#cfg(not(target="js"))
pub fn checkbox(
  default_checked? : Bool = false,
  default_indeterminate? : Bool = false,
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
    render_checkbox(
      checked=default_checked,
      indeterminate=default_indeterminate,
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
