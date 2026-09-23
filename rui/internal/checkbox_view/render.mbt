///|
const CheckboxBaseStyle : String = "display:inline-flex;width:1rem;height:1rem;flex-shrink:0;align-items:center;justify-content:center;--rui-control-base-bg:var(--rui-input-background,transparent);--rui-control-base-fg:var(--rui-primary-foreground,oklch(0.985 0 0));--rui-control-base-border:var(--rui-input,oklch(0.922 0 0));--rui-control-base-shadow:0 0 #0000;border:1px solid transparent;border-color:var(--rui-control-border,var(--rui-control-base-border,var(--rui-input,oklch(0.922 0 0))));border-radius:4px;margin:0;padding:0;background:var(--rui-control-bg,var(--rui-control-base-bg,var(--rui-input-background,transparent)));color:var(--rui-control-fg,var(--rui-control-base-fg,var(--rui-primary-foreground,oklch(0.985 0 0))));box-shadow:var(--rui-control-shadow,var(--rui-control-base-shadow,0 0 #0000));cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;vertical-align:middle;outline-offset:2px"

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
#cfg(target="js")
fn checkbox_bind_keyboard_attrs(attrs : @html.Attrs) -> Unit {
  ignore(
    attrs.on_keydown(event => {
      if event.key() == "Enter" {
        event.prevent_default()
      }
      @cmd.none
    }),
  )
}

///|
#cfg(not(target="js"))
fn checkbox_bind_keyboard_attrs(attrs : @html.Attrs) -> Unit {
  ignore(attrs)
}

///|
/// Render one checkbox state for the incremental wrapper.
///
/// Mouse activation and Space request the next value through
/// `on_checked_change`. Enter's native button activation is cancelled so it
/// intentionally does not change this checkbox.
/// The component is not a form control and does not create a hidden input.
pub fn render(
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
  let control_attrs = attrs
    .map(a => a.copy())
    .unwrap_or_else(@html.Attrs::build)
  ignore(control_attrs.data_set("slot", "checkbox"))
  ignore(control_attrs.role("checkbox"))
  ignore(control_attrs.aria_checked(aria_checked))
  ignore(control_attrs.aria_disabled(disabled.to_string()))
  ignore(control_attrs.aria_readonly(read_only.to_string()))
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
  checkbox_bind_keyboard_attrs(control_attrs)
  if !disabled && !read_only && on_checked_change is Some(emit) {
    ignore(control_attrs.on_click(_ => emit(next_checked)))
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
      CheckboxIndicatorStyle,
      "display:flex;align-items:center;justify-content:center;width:0.875rem;height:0.875rem",
    ],
    attrs=indicator_attrs,
    if indeterminate {
      @html.span(
        style=[
          "width:0.5rem;height:0.125rem;border-radius:9999px;background:currentColor",
        ],
        "",
      )
    } else if checked {
      @svg.svg(width=14, height=14, view_box="0 0 24 24", [
        @svg.path(
          d="m20 6-11 11-5-5",
          fill="none",
          stroke="currentColor",
          stroke_width=2,
          attrs=@svg.Attrs::build()
            .stroke_linecap("round")
            .stroke_linejoin("round"),
        ),
      ])
    } else {
      @html.nothing
    },
  )
  @html.button(
    style=[
        "box-sizing:border-box",
        "font-family:Inter,ui-sans-serif,system-ui,-apple-system,BlinkMacSystemFont,\"Segoe UI\",sans-serif",
        "-webkit-font-smoothing:antialiased;text-rendering:optimizeLegibility",
        "transition:color 150ms ease,background-color 150ms ease,border-color 150ms ease,box-shadow 150ms ease,opacity 150ms ease,transform 150ms ease",
        CheckboxBaseStyle,
        checkbox_state_style(checked, indeterminate),
        checkbox_read_only_style(read_only),
        checkbox_invalid_style(invalid),
        if disabled {
          "cursor:not-allowed;opacity:0.5"
        } else {
          ""
        },
      ] +
      style,
    id?,
    class?,
    title?,
    type_="button",
    disabled~,
    attrs=control_attrs,
    indicator,
  )
}
