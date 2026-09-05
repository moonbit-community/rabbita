///|
pub(all) enum RadioGroupOrientation {
  RadioVertical
  RadioHorizontal
} derive(Debug, Eq)

///|
const RadioGroupVerticalStyle : String = "display:grid;width:100%;gap:0.75rem"

///|
const RadioGroupHorizontalStyle : String = "display:flex;width:100%;flex-wrap:wrap;align-items:center;gap:0.75rem"

///|
const RadioGroupItemBaseStyle : String = "position:relative;display:inline-grid;width:1rem;height:1rem;flex-shrink:0;place-content:center;--rui-control-base-bg:var(--rui-input-background,transparent);--rui-control-base-fg:var(--rui-primary-foreground,oklch(0.985 0 0));--rui-control-base-border:var(--rui-input,oklch(0.922 0 0));--rui-control-base-shadow:0 1px 2px rgb(0 0 0 / 0.05);border:1px solid transparent;border-color:var(--rui-control-border,var(--rui-control-base-border,var(--rui-input,oklch(0.922 0 0))));border-radius:9999px;margin:0;padding:0;background:var(--rui-control-bg,var(--rui-control-base-bg,var(--rui-input-background,transparent)));color:var(--rui-control-fg,var(--rui-control-base-fg,var(--rui-primary-foreground,oklch(0.985 0 0))));box-shadow:var(--rui-control-shadow,var(--rui-control-base-shadow,0 1px 2px rgb(0 0 0 / 0.05)));cursor:pointer;appearance:none;-webkit-appearance:none;outline-offset:2px;vertical-align:middle"

///|
const RadioGroupItemCheckedStyle : String = "--rui-control-base-border:var(--rui-input,oklch(0.922 0 0));--rui-control-base-bg:radial-gradient(circle at center,var(--rui-primary,oklch(0.205 0 0)) 0 0.25rem,transparent 0.27rem),var(--rui-input-background,transparent);--rui-control-base-fg:var(--rui-primary,oklch(0.205 0 0))"

///|
const RadioGroupItemUncheckedStyle : String = "--rui-control-base-border:var(--rui-input,oklch(0.922 0 0));--rui-control-base-bg:var(--rui-input-background,transparent)"

///|
const RadioGroupItemInvalidStyle : String = "border-color:var(--rui-destructive-border,var(--rui-destructive,oklch(0.577 0.245 27.325)));box-shadow:0 0 0 3px var(--rui-destructive-ring,oklch(0.577 0.245 27.325 / 0.2))"

///|
fn radio_group_orientation_value(orientation : RadioGroupOrientation) -> String {
  match orientation {
    RadioVertical => "vertical"
    RadioHorizontal => "horizontal"
  }
}

///|
fn radio_group_orientation_style(orientation : RadioGroupOrientation) -> String {
  match orientation {
    RadioVertical => RadioGroupVerticalStyle
    RadioHorizontal => RadioGroupHorizontalStyle
  }
}

///|
fn radio_group_item_state_style(checked : Bool) -> String {
  if checked {
    RadioGroupItemCheckedStyle
  } else {
    RadioGroupItemUncheckedStyle
  }
}

///|
fn radio_group_item_invalid_style(invalid : Bool) -> String {
  if invalid {
    RadioGroupItemInvalidStyle
  } else {
    ""
  }
}

///|
#cfg(target="js")
fn radio_group_move_and_select(event : @dom.KeyboardEvent) -> Bool {
  if event.alt_key() ||
    event.ctrl_key() ||
    event.meta_key() ||
    event.shift_key() {
    return false
  }
  guard ui_roving_context(
      event, "[data-slot=\"radio-group-item\"]", "[data-slot=\"radio-group\"]", "[data-slot=\"radio-group-item\"]",
    )
    is Some(context) else {
    return false
  }
  guard ui_roving_target(
      context,
      event.key(),
      "both",
      ui_element_is_rtl(context.root),
    )
    is Some(target) else {
    return false
  }
  ui_focus_element_without_scroll(target)
  ui_click_element(target)
  true
}

///|
#cfg(target="js")
fn radio_group_bind_keyboard(attrs : @html.Attrs) -> Unit {
  ignore(
    attrs.on_keydown(event => {
      if radio_group_move_and_select(event) {
        event.prevent_default()
      }
      @cmd.none
    }),
  )
}

///|
#cfg(not(target="js"))
fn radio_group_bind_keyboard(attrs : @html.Attrs) -> Unit {
  ignore(attrs)
}

///|
/// Lay out native radio inputs as a Vega-style radio group.
///
/// Each item remains a real `<input type="radio">`, so same-name items retain
/// the browser's arrow-key navigation and form behavior.
pub fn[C : @html.IsChildren] radio_group_root(
  orientation? : RadioGroupOrientation = RadioVertical,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "radio-group")
    .data_set("orientation", radio_group_orientation_value(orientation))
    .role("radiogroup")
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  }
  @html.div(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, radio_group_orientation_style(orientation)],
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
/// Render one native radio item for the incremental group.
///
/// Pass the same `name` and `on_value_change` to sibling items. The callback
/// receives the activated item's `value`.
fn render_radio_group_item(
  value~ : String,
  name? : String,
  checked? : Bool = false,
  disabled? : Bool = false,
  required? : Bool,
  invalid? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  on_value_change? : @cmd.Emit[String],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let state = if checked { "checked" } else { "unchecked" }
  let control_attrs = ui_attrs(attrs)
    .data_set("slot", "radio-group-item")
    .data_set("state", state)
    .data_set(state, "")
  if disabled {
    ignore(control_attrs.disabled(true).data_set("disabled", ""))
  }
  if invalid {
    ignore(control_attrs.aria_invalid("true").data_set("invalid", ""))
  }
  if aria_label is Some(label) {
    ignore(control_attrs.aria_label(label))
  }
  radio_group_bind_keyboard(control_attrs)
  let on_change = on_value_change
  @html.input(
    input_type=Radio,
    name?,
    value~,
    checked~,
    style=ui_styles(
      [
        UiBoxSizing,
        UiTransition,
        RadioGroupItemBaseStyle,
        radio_group_item_state_style(checked),
        radio_group_item_invalid_style(invalid),
        ui_disabled_visual_style(disabled),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    required?,
    on_change?,
    attrs=control_attrs,
  )
}

///|
/// Opaque state shared by `radio_group` and its items.
struct RadioGroupScope {
  value : String
  name : String?
  disabled : Bool
  required : Bool
  invalid : Bool
  emit : @cmd.Emit[String]
}

///|
/// Render one compound group state for the incremental wrapper.
fn[C : @html.IsChildren] render_radio_group(
  value~ : String,
  name? : String,
  disabled? : Bool = false,
  required? : Bool = false,
  invalid? : Bool = false,
  orientation? : RadioGroupOrientation = RadioVertical,
  on_value_change? : @cmd.Emit[String],
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (RadioGroupScope) -> C,
) -> @html.Html {
  let emit = @cmd.Emit(next => {
    if on_value_change is Some(notify) {
      notify(next)
    } else {
      @cmd.none
    }
  })
  let scope = { value, name, disabled, required, invalid, emit, }
  let root_attrs = ui_attrs(attrs).data_set("value", value)
  if disabled {
    ignore(root_attrs.aria_disabled("true").data_set("disabled", ""))
  }
  if invalid {
    ignore(root_attrs.aria_invalid("true").data_set("invalid", ""))
  }
  radio_group_root(
    orientation~,
    id?,
    class?,
    title?,
    aria_label?,
    attrs=root_attrs,
    style~,
    children(scope),
  )
}

///|
/// Build a black-box radio group with component-local incremental selection.
#cfg(target="js")
pub fn[C : @html.IsChildren] radio_group(
  default_value? : String = "",
  name? : String,
  disabled? : Bool = false,
  required? : Bool = false,
  invalid? : Bool = false,
  orientation? : RadioGroupOrientation = RadioVertical,
  on_value_change? : @cmd.Emit[String],
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (RadioGroupScope) -> C,
) -> @rabbita.Val[@html.Html] {
  let (value, set_value) = @rabbita.create_variable(default_value)
  value.view(value => {
    render_radio_group(
      value~,
      name?,
      disabled~,
      required~,
      invalid~,
      orientation~,
      on_value_change=Emit(next => {
        let update = set_value(_ => next)
        if on_value_change is Some(notify) {
          @cmd.batch([update, notify(next)])
        } else {
          update
        }
      }),
      id?,
      class?,
      title?,
      aria_label?,
      attrs?,
      style~,
      children,
    )
  })
}

///|
#cfg(not(target="js"))
pub fn[C : @html.IsChildren] radio_group(
  default_value? : String = "",
  name? : String,
  disabled? : Bool = false,
  required? : Bool = false,
  invalid? : Bool = false,
  orientation? : RadioGroupOrientation = RadioVertical,
  on_value_change? : @cmd.Emit[String],
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (RadioGroupScope) -> C,
) -> @rabbita.Val[@html.Html] {
  ignore(on_value_change)
  @rabbita.Val::constant(
    render_radio_group(
      value=default_value,
      name?,
      disabled~,
      required~,
      invalid~,
      orientation~,
      id?,
      class?,
      title?,
      aria_label?,
      attrs?,
      style~,
      children,
    ),
  )
}

///|
/// Render one item bound to the local state owned by `radio_group`.
pub fn radio_group_item(
  scope~ : RadioGroupScope,
  value~ : String,
  disabled? : Bool = false,
  required? : Bool = false,
  invalid? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let disabled = scope.disabled || disabled
  let name = scope.name
  render_radio_group_item(
    value~,
    name?,
    checked=scope.value == value,
    disabled~,
    required=scope.required || required,
    invalid=scope.invalid || invalid,
    id?,
    class?,
    title?,
    aria_label?,
    on_value_change=Emit(_ => (scope.emit)(value)),
    attrs?,
    style~,
  )
}
