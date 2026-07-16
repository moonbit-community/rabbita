///|
struct ComboboxOption {
  value : String
  label : String
  disabled : Bool
}

///|
pub fn combobox_option(
  value~ : String,
  label~ : String,
  disabled? : Bool = false,
) -> ComboboxOption {
  { value, label, disabled }
}

///|
priv struct ComboboxModel {
  open : Bool
  query : String
  values : Array[String]
  active : Int
} derive(Eq)

///|
priv enum ComboboxMsg {
  ComboboxOpen
  ComboboxToggle
  ComboboxNativeChanged(Bool)
  ComboboxSetQuery(String)
  ComboboxMove(Int)
  ComboboxFirst
  ComboboxLast
  ComboboxHighlight(Int)
  ComboboxChoose(Int)
  ComboboxRemove(String)
  ComboboxClear
  ComboboxClose
  ComboboxDismiss
}

///|
/// Opaque component-local state supplied to the combobox compound API.
struct ComboboxScope {
  id : String
  options : Array[ComboboxOption]
  model : ComboboxModel
  multiple : Bool
  placeholder : String
  empty_text : String
  disabled : Bool
  invalid : Bool
  required : Bool
  name : String?
  side : PopupSide
  align : PopupAlign
  side_offset : Int
  align_offset : Int
  emit : @cmd.Emit[ComboboxMsg]
  content_id : Ref[String]
  anchor_id : Ref[String]
  has_input : Ref[Bool]
}

///|
const ComboboxRootStyle : String = "position:relative;display:flex;width:100%;min-width:0;flex-direction:column"

///|
const ComboboxControlStyle : String = "display:flex;width:100%;min-height:2.25rem;min-width:0;align-items:center;gap:0.375rem;--rui-control-base-bg:var(--rui-input-background,transparent);--rui-control-base-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-control-base-border:var(--rui-input,oklch(0.922 0 0));--rui-control-base-shadow:0 1px 2px rgb(0 0 0 / 0.05);border:1px solid transparent;border-color:var(--rui-control-border,var(--rui-control-base-border,var(--rui-input,oklch(0.922 0 0))));border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-control-bg,var(--rui-control-base-bg,var(--rui-input-background,transparent)));color:var(--rui-control-fg,var(--rui-control-base-fg,var(--rui-foreground,oklch(0.145 0 0))));padding:0.25rem 0.375rem;box-shadow:var(--rui-control-shadow,var(--rui-control-base-shadow,0 1px 2px rgb(0 0 0 / 0.05)));outline-offset:2px"

///|
const ComboboxControlLayoutStyle : String = "display:flex;width:100%;min-width:0"

///|
const ComboboxChipsStyle : String = "display:flex;width:100%;min-width:0;min-height:2.25rem;flex:1;flex-wrap:wrap;align-items:center;gap:0.375rem;--rui-control-base-bg:var(--rui-input-background,transparent);--rui-control-base-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-control-base-border:var(--rui-input,oklch(0.922 0 0));--rui-control-base-shadow:0 1px 2px rgb(0 0 0 / 0.05);border:1px solid transparent;border-color:var(--rui-control-border,var(--rui-control-base-border,var(--rui-input,oklch(0.922 0 0))));border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-control-bg,var(--rui-control-base-bg,var(--rui-input-background,transparent)));background-clip:padding-box;padding:0.375rem 0.625rem;color:var(--rui-control-fg,var(--rui-control-base-fg,var(--rui-foreground,oklch(0.145 0 0))));box-shadow:var(--rui-control-shadow,var(--rui-control-base-shadow,0 1px 2px rgb(0 0 0 / 0.05)));font-size:0.875rem;line-height:1.25rem;outline:none"

///|
const ComboboxContentStyle : String = "position:fixed;inset:auto;left:var(--rui-floating-left,auto);top:var(--rui-floating-top,auto);z-index:50;display:flex;width:var(--rui-floating-anchor-width,anchor-size(width));min-width:min(calc(var(--rui-floating-anchor-width,anchor-size(width)) + 1.75rem),calc(100vw - 1rem));max-width:var(--rui-floating-available-width,calc(100vw - 1rem));max-height:min(24rem,var(--rui-floating-available-height,calc(100vh - 1rem)));transform-origin:var(--rui-floating-transform-origin,center);flex-direction:column;overflow:hidden;margin:0;border:1px solid color-mix(in oklab,var(--rui-foreground,oklch(0.145 0 0)) 10%,transparent);border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-popover,oklch(1 0 0));padding:0;color:var(--rui-popover-foreground,oklch(0.145 0 0));box-shadow:0 10px 15px -3px rgb(0 0 0 / 0.1),0 4px 6px -4px rgb(0 0 0 / 0.1);outline:none;transition:opacity 100ms ease,transform 100ms ease,visibility 100ms ease"

///|
const ComboboxItemStyle : String = "position:relative;display:flex;width:100%;min-height:2rem;align-items:center;gap:0.5rem;border:0;border-radius:calc(var(--rui-radius,0.625rem) - 0.25rem);background:var(--rui-menu-item-bg,var(--rui-menu-item-base-bg,transparent));padding-block:0.375rem;padding-inline:0.5rem 2rem;color:var(--rui-menu-item-fg,var(--rui-menu-item-base-fg,inherit));font:inherit;font-size:0.875rem;line-height:1.25rem;text-align:start;white-space:nowrap;outline:none;cursor:pointer"

///|
const ComboboxInputBaseStyle : String = "border:0;background:transparent;padding:0.125rem 0.25rem;color:var(--rui-foreground,oklch(0.145 0 0));font-size:0.875rem;line-height:1.25rem;outline:none"

///|
const ComboboxInputLayoutStyle : String = "width:100%;min-width:3rem;flex:1"

///|
const ComboboxChipsInputLayoutStyle : String = "width:auto;min-width:4rem;flex:1"

///|
const ComboboxTriggerIconStyle : String = "display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;line-height:0;color:var(--rui-muted-foreground,oklch(0.556 0 0));pointer-events:none"

///|
fn combobox_trigger_icon() -> @html.Html {
  @html.span(
    attrs=@html.Attrs::build()
      .aria_hidden("true")
      .data_set("slot", "combobox-trigger-icon"),
    style=[ComboboxTriggerIconStyle],
    ui_chevron_down_icon(),
  )
}

///|
fn combobox_contains(values : Array[String], value : String) -> Bool {
  for current in values {
    if current == value {
      return true
    }
  }
  false
}

///|
fn combobox_option_index(
  options : Array[ComboboxOption],
  value : String,
) -> Int {
  for index, option in options {
    if option.value == value {
      return index
    }
  }
  -1
}

///|
fn combobox_selected_label(scope : ComboboxScope) -> String {
  if scope.model.values.length() == 0 {
    return scope.placeholder
  }
  let labels : Array[String] = []
  for value in scope.model.values {
    let index = combobox_option_index(scope.options, value)
    if index >= 0 {
      labels.push(scope.options[index].label)
    }
  }
  labels.join(", ")
}

///|
fn combobox_selected_input_value(
  options : Array[ComboboxOption],
  values : Array[String],
  multiple : Bool,
) -> String {
  if multiple || values.length() == 0 {
    return ""
  }
  let index = combobox_option_index(options, values[0])
  if index >= 0 {
    options[index].label
  } else {
    ""
  }
}

///|
fn combobox_filter_query(
  options : Array[ComboboxOption],
  values : Array[String],
  multiple : Bool,
  query : String,
) -> String {
  let selected_input = combobox_selected_input_value(options, values, multiple)
  if !multiple && selected_input != "" && query == selected_input {
    ""
  } else {
    query
  }
}

///|
fn combobox_matches(option : ComboboxOption, query : String) -> Bool {
  query == "" ||
  option.label.to_lower().contains(query.to_lower()) ||
  option.value.to_lower().contains(query.to_lower())
}

///|
fn combobox_first_match(
  options : Array[ComboboxOption],
  query : String,
  reverse : Bool,
) -> Int {
  if reverse {
    let mut index = options.length() - 1
    while index >= 0 {
      if !options[index].disabled && combobox_matches(options[index], query) {
        return index
      }
      index -= 1
    }
  } else {
    for index, option in options {
      if !option.disabled && combobox_matches(option, query) {
        return index
      }
    }
  }
  -1
}

///|
fn combobox_next_match(
  options : Array[ComboboxOption],
  query : String,
  current : Int,
  direction : Int,
) -> Int {
  let length = options.length()
  if length == 0 {
    return -1
  }
  let mut index = current
  let mut remaining = length
  while remaining > 0 {
    index = if direction < 0 {
      if index <= 0 {
        length - 1
      } else {
        index - 1
      }
    } else if index < 0 || index >= length - 1 {
      0
    } else {
      index + 1
    }
    if !options[index].disabled && combobox_matches(options[index], query) {
      return index
    }
    remaining -= 1
  }
  -1
}

///|
fn combobox_normalize_values(
  options : Array[ComboboxOption],
  values : Array[String],
  multiple : Bool,
) -> Array[String] {
  let result : Array[String] = []
  for value in values {
    let index = combobox_option_index(options, value)
    if index >= 0 &&
      !options[index].disabled &&
      !combobox_contains(result, value) &&
      (multiple || result.length() == 0) {
      result.push(value)
    }
  }
  result
}

///|
fn combobox_remove_value(
  values : Array[String],
  value : String,
) -> Array[String] {
  let result : Array[String] = []
  for current in values {
    if current != value {
      result.push(current)
    }
  }
  result
}

///|
fn combobox_toggle_value(
  values : Array[String],
  value : String,
  multiple : Bool,
) -> Array[String] {
  if !multiple {
    [value]
  } else if combobox_contains(values, value) {
    combobox_remove_value(values, value)
  } else {
    let next = values.copy()
    next.push(value)
    next
  }
}

///|
fn combobox_item_id(scope : ComboboxScope, index : Int) -> String {
  "\{scope.id}-item-\{index}"
}

///|
fn combobox_notify_open(notify : @cmd.Emit[Bool]?, value : Bool) -> @cmd.Cmd {
  if notify is Some(notify) {
    notify(value)
  } else {
    @cmd.none
  }
}

///|
fn combobox_notify_query(
  notify : @cmd.Emit[String]?,
  value : String,
) -> @cmd.Cmd {
  if notify is Some(notify) {
    notify(value)
  } else {
    @cmd.none
  }
}

///|
fn combobox_notify_values(
  on_value_change : @cmd.Emit[String]?,
  on_values_change : @cmd.Emit[Array[String]]?,
  values : Array[String],
) -> @cmd.Cmd {
  let commands : Array[@cmd.Cmd] = []
  if on_values_change is Some(notify) {
    commands.push(notify(values))
  }
  if on_value_change is Some(notify) {
    commands.push(notify(if values.length() > 0 { values[0] } else { "" }))
  }
  @cmd.batch(commands)
}

///|
#cfg(target="js")
extern "js" fn ffi_focus_combobox_control(id : String) -> Unit =
  #| id => {
  #|   const root = document.getElementById(id + "-root")
  #|   root?.querySelector?.('[data-slot="combobox-input"],[data-slot="combobox-chip-input"],[data-slot="combobox-trigger"]')?.focus?.()
  #| }

///|
#cfg(target="js")
fn combobox_popup_cmd(
  id : String,
  open : Bool?,
  focus_control : Bool,
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.after_render, _ => {
    let set_layer = () => {
      if open is Some(open) {
        ui_listbox_set_open_now(id, "combobox-content", open)
      }
    }
    let focus : (() -> Unit)? = if focus_control {
      Some(() => ffi_focus_combobox_control(id))
    } else {
      None
    }
    ui_listbox_run_open_sequence(set_layer, focus)
  })
}

///|
#cfg(not(target="js"))
fn combobox_popup_cmd(
  id : String,
  open : Bool?,
  focus_control : Bool,
) -> @cmd.Cmd {
  ignore((id, open, focus_control))
  @cmd.none
}

///|
#cfg(target="js")
extern "js" fn ffi_bind_combobox_events(
  id : String,
  dispatch : (Int) -> Unit,
) -> Unit =
  #| (id, dispatch) => {
  #|   const root = document.getElementById(id + "-root")
  #|   if (!root) return
  #|   root.__ruiComboboxDispatch = dispatch
  #|   if (root.__ruiComboboxBound) return
  #|   root.__ruiComboboxBound = true
  #|   root.addEventListener("mousedown", event => {
  #|     const item = event.target?.closest?.('[data-slot="combobox-item"]')
  #|     if (item && root.contains(item)) event.preventDefault()
  #|     const action = event.target?.closest?.('[data-slot="combobox-trigger"],[data-slot="combobox-clear"]')
  #|     if (!action || !root.contains(action)) return
  #|     const input = root.querySelector?.('[data-slot="combobox-input"],[data-slot="combobox-chip-input"]')
  #|     if (!input) return
  #|     event.preventDefault()
  #|     input.focus?.({ preventScroll: true })
  #|   })
  #|   root.addEventListener("click", event => {
  #|     const target = event.target?.closest?.('[data-slot="combobox-input"],[data-slot="combobox-chip-input"]')
  #|     if (!target || !root.contains(target)) return
  #|     root.__ruiComboboxDispatch?.(0)
  #|   })
  #|   root.addEventListener("focusout", event => {
  #|     if (root.dataset.state === "open" && !root.contains(event.relatedTarget)) {
  #|       root.__ruiComboboxDispatch?.(7)
  #|     }
  #|   })
  #|   root.addEventListener("keydown", event => {
  #|     if (event.altKey || event.ctrlKey || event.metaKey || event.isComposing) return
  #|     const target = event.target?.closest?.('[data-slot="combobox-input"],[data-slot="combobox-chip-input"],[data-slot="combobox-item"],[data-slot="combobox-trigger"]')
  #|     if (!target || !root.contains(target)) return
  #|     const send = kind => {
  #|       event.preventDefault()
  #|       root.__ruiComboboxDispatch?.(kind)
  #|     }
  #|     if (event.key === "Tab" && root.dataset.state === "open") {
  #|       root.__ruiComboboxDispatch?.(7)
  #|       return
  #|     }
  #|     if (event.key === "ArrowDown") return send(1)
  #|     if (event.key === "ArrowUp") return send(2)
  #|     const input = target.dataset.slot === "combobox-input" || target.dataset.slot === "combobox-chip-input"
  #|     if (event.key === "Home" && !input) return send(3)
  #|     if (event.key === "End" && !input) return send(4)
  #|     if (event.key === "Enter") {
  #|       if (target.dataset.slot === "combobox-item" || (root.dataset.state === "open" && target.hasAttribute("aria-activedescendant"))) return send(5)
  #|       return
  #|     }
  #|     if (event.key === "Escape" && root.dataset.state === "open") return send(6)
  #|   })
  #| }

///|
#cfg(target="js")
fn combobox_bind_events_cmd(
  id : String,
  emit : @cmd.Emit[ComboboxMsg],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, scheduler => {
    ffi_bind_combobox_events(id, kind => {
      let message = match kind {
        0 => ComboboxOpen
        1 => ComboboxMove(1)
        2 => ComboboxMove(-1)
        3 => ComboboxFirst
        4 => ComboboxLast
        5 => ComboboxChoose(-1)
        7 => ComboboxDismiss
        _ => ComboboxClose
      }
      scheduler.add(emit(message))
    })
  })
}

///|
fn combobox_root_attrs(
  scope : ComboboxScope,
  attrs : @html.Attrs?,
) -> @html.Attrs {
  let root_attrs = popup_state_attrs(attrs, "combobox", scope.model.open)
    .data_set("multiple", ui_bool(scope.multiple))
    .data_set("active-index", "\{scope.model.active}")
  if scope.disabled {
    ignore(root_attrs.data_set("disabled", "").aria_disabled("true"))
  }
  if scope.invalid {
    ignore(root_attrs.data_set("invalid", "").aria_invalid("true"))
  }
  root_attrs
}

///|
pub fn combobox_value(
  scope~ : ComboboxScope,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  prefix? : @html.Html,
) -> @html.Html {
  let empty = scope.model.values.length() == 0
  let prefix_html = prefix.unwrap_or(@html.nothing)
  @html.span(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "combobox-value")
      .data_set("placeholder", ui_bool(empty)),
    style=ui_styles(
      [
        "display:flex;min-width:0;flex:1;align-items:center;gap:0.375rem;overflow:hidden;text-overflow:ellipsis",
        if empty {
          "color:var(--rui-muted-foreground,oklch(0.556 0 0))"
        } else {
          ""
        },
      ],
      style,
    ),
    [
      prefix_html,
      @html.span(
        style=["min-width:0;overflow:hidden;text-overflow:ellipsis"],
        combobox_selected_label(scope),
      ),
    ],
  )
}

///|
pub fn combobox_trigger(
  scope~ : ComboboxScope,
  aria_label? : String,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let resolved_id = id.unwrap_or("\{scope.id}-trigger")
  if !scope.has_input.val {
    scope.anchor_id.val = resolved_id
  }
  let trigger_attrs = popup_state_attrs(
      attrs,
      "combobox-trigger",
      scope.model.open,
    )
    .aria_haspopup("listbox")
    .aria_expanded(ui_bool(scope.model.open))
  if scope.has_input.val {
    ignore(trigger_attrs.tabindex(-1))
  } else {
    ignore(trigger_attrs.role("combobox"))
  }
  if scope.model.open {
    ignore(trigger_attrs.aria_controls(scope.content_id.val))
  }
  if !scope.has_input.val && scope.model.open && scope.model.active >= 0 {
    ignore(
      trigger_attrs.aria_activedescendant(
        combobox_item_id(scope, scope.model.active),
      ),
    )
  }
  if aria_label is Some(label) {
    ignore(trigger_attrs.aria_label(label))
  }
  if !scope.disabled {
    ignore(trigger_attrs.on_click_after(_ => (scope.emit)(ComboboxToggle)))
  }
  @html.button(
    id=resolved_id,
    class?,
    title?,
    type_="button",
    disabled=scope.disabled,
    attrs=trigger_attrs,
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTransition,
        SelectTriggerStyle,
        input_invalid_style(scope.invalid),
        ui_disabled_style(scope.disabled),
        popup_anchor_style(resolved_id),
      ],
      style,
    ),
    [combobox_value(scope~), combobox_trigger_icon()],
  )
}

///|
fn combobox_input_surface(
  scope : ComboboxScope,
  slot : String,
  layout_style : String,
  aria_label : String,
  auto_complete : @html.AutoComplete,
  id : String?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
) -> @html.Html {
  let resolved_id = id.unwrap_or("\{scope.id}-input")
  scope.has_input.val = true
  scope.anchor_id.val = resolved_id
  let display_value = scope.model.query
  let input_attrs = popup_state_attrs(attrs, slot, scope.model.open)
    .role("combobox")
    .aria_label(aria_label)
    .aria_autocomplete("list")
    .aria_expanded(ui_bool(scope.model.open))
    .aria_haspopup("listbox")
    .aria_invalid(ui_bool(scope.invalid))
    .aria_required(ui_bool(scope.required))
  if scope.model.open {
    ignore(input_attrs.aria_controls(scope.content_id.val))
  }
  if scope.model.open && scope.model.active >= 0 {
    ignore(
      input_attrs.aria_activedescendant(
        combobox_item_id(scope, scope.model.active),
      ),
    )
  }
  if scope.disabled {
    ignore(input_attrs.disabled(true))
  }
  @html.input(
    input_type=@html.Text,
    value=display_value,
    placeholder=scope.placeholder,
    auto_complete~,
    id=resolved_id,
    class?,
    title?,
    on_input=scope.emit.map(value => ComboboxSetQuery(value)),
    attrs=input_attrs,
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        layout_style,
        ComboboxInputBaseStyle,
        ui_disabled_style(scope.disabled),
        popup_anchor_style(resolved_id),
      ],
      style,
    ),
  )
}

///|
pub fn combobox_input(
  scope~ : ComboboxScope,
  aria_label? : String = "Search options",
  auto_complete? : @html.AutoComplete = @html.Off,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  combobox_input_surface(
    scope,
    "combobox-input",
    ComboboxInputLayoutStyle,
    aria_label,
    auto_complete,
    id,
    class,
    title,
    attrs,
    style,
  )
}

///|
/// Render the query input inside a multi-select chips surface.
///
/// It shares the regular combobox input's value, ARIA active-descendant, query
/// updates, focus opening, and keyboard navigation while exposing shadcn's
/// singular `combobox-chip-input` data slot.
pub fn combobox_chips_input(
  scope~ : ComboboxScope,
  aria_label? : String = "Search options",
  auto_complete? : @html.AutoComplete = @html.Off,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  combobox_input_surface(
    scope,
    "combobox-chip-input",
    ComboboxChipsInputLayoutStyle,
    aria_label,
    auto_complete,
    id,
    class,
    title,
    attrs,
    style,
  )
}

///|
pub fn combobox_clear(
  scope~ : ComboboxScope,
  label? : String = "Clear selection",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let hidden = scope.model.values.length() == 0 && scope.model.query == ""
  let clear_attrs = ui_attrs(attrs)
    .aria_label(label)
    .data_set("slot", "combobox-clear")
    .data_set("variant", button_variant_value(Ghost))
    .data_set("size", button_size_value(IconXs))
    .tabindex(-1)
  if !scope.disabled {
    ignore(clear_attrs.on_click_after(_ => (scope.emit)(ComboboxClear)))
  }
  @html.button(
    id?,
    class?,
    title?,
    hidden~,
    type_="button",
    disabled=scope.disabled,
    attrs=clear_attrs,
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        ButtonBaseStyle,
        button_variant_style(Ghost),
        button_size_style(IconXs),
        "flex:none;--rui-button-base-fg:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:1rem",
        ui_disabled_style(scope.disabled),
      ],
      style,
    ),
    ui_x_icon(),
  )
}

///|
fn combobox_default_trigger(scope : ComboboxScope) -> @html.Html {
  let trigger_attrs = popup_state_attrs(
      None,
      "combobox-trigger",
      scope.model.open,
    )
    .data_set("variant", button_variant_value(Ghost))
    .data_set("size", button_size_value(IconXs))
    .aria_label("Toggle options")
    .aria_haspopup("listbox")
    .aria_expanded(ui_bool(scope.model.open))
    .tabindex(-1)
  if scope.model.open {
    ignore(trigger_attrs.aria_controls(scope.content_id.val))
  }
  if !scope.disabled {
    ignore(trigger_attrs.on_click_after(_ => (scope.emit)(ComboboxToggle)))
  }
  @html.button(
    type_="button",
    disabled=scope.disabled,
    attrs=trigger_attrs,
    style=[
      UiBoxSizing,
      UiFontSans,
      UiTextRendering,
      UiTransition,
      ButtonBaseStyle,
      button_variant_style(Ghost),
      button_size_style(IconXs),
      "flex:none;--rui-button-base-fg:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:1rem",
      ui_disabled_style(scope.disabled),
    ],
    combobox_trigger_icon(),
  )
}

///|
pub fn[C : @html.IsChildren] combobox_list(
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
    attrs=ui_attrs(attrs).role("presentation").data_set("slot", "combobox-list"),
    style=ui_styles(["min-height:0;overflow-y:auto;padding:0.25rem"], style),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] combobox_item(
  scope~ : ComboboxScope,
  value~ : String,
  disabled? : Bool,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let index = combobox_option_index(scope.options, value)
  let option_disabled = if disabled is Some(disabled) {
    disabled
  } else if index >= 0 {
    scope.options[index].disabled
  } else {
    false
  }
  let selected = combobox_contains(scope.model.values, value)
  let active = scope.model.open && index >= 0 && scope.model.active == index
  let item_attrs = ui_attrs(attrs)
    .role("option")
    .aria_selected(ui_bool(selected))
    .aria_disabled(ui_bool(option_disabled))
    .data_set("slot", "combobox-item")
    .data_set("value", value)
    .data_set("state", if selected { "checked" } else { "unchecked" })
    .data_set("highlighted", ui_bool(active))
    .tabindex(-1)
  if option_disabled {
    ignore(item_attrs.data_set("disabled", ""))
  } else if index >= 0 {
    ignore(item_attrs.on_click_after(_ => (scope.emit)(ComboboxChoose(index))))
    ignore(
      item_attrs.on_mouseenter(_ => (scope.emit)(ComboboxHighlight(index))),
    )
  }
  @html.button(
    id=id.unwrap_or(
      if index >= 0 {
        combobox_item_id(scope, index)
      } else {
        ""
      },
    ),
    class?,
    title?,
    type_="button",
    disabled=option_disabled,
    attrs=item_attrs,
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTransition,
        ComboboxItemStyle,
        if active {
          "--rui-menu-item-base-bg:var(--rui-accent,oklch(0.97 0 0));--rui-menu-item-base-fg:var(--rui-accent-foreground,oklch(0.205 0 0))"
        } else {
          ""
        },
        ui_disabled_visual_style(option_disabled),
      ],
      style,
    ),
    [
      @html.span(
        style=["min-width:0;flex:1;overflow:hidden;text-overflow:ellipsis"],
        children,
      ),
      if selected {
        @html.span(
          attrs=@html.Attrs::build()
            .aria_hidden("true")
            .data_set("slot", "combobox-item-indicator"),
          style=[
            "position:absolute;inset-inline-end:0.5rem;display:inline-flex;width:1rem;height:1rem;align-items:center;justify-content:center",
          ],
          ui_check_icon(),
        )
      } else {
        @html.nothing
      },
    ],
  )
}

///|
pub fn[C : @html.IsChildren] combobox_group(
  label_id? : String,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let group_attrs = ui_attrs(attrs)
    .role("group")
    .data_set("slot", "combobox-group")
  if label_id is Some(label_id) {
    ignore(group_attrs.aria_labelledby(label_id))
  }
  @html.div(
    id?,
    class?,
    title?,
    attrs=group_attrs,
    style=ui_styles(["padding:0.125rem 0"], style),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] combobox_label(
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
    attrs=ui_attrs(attrs).data_set("slot", "combobox-label"),
    style=ui_styles(
      [
        "padding:0.375rem 0.5rem;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.75rem;line-height:1rem;font-weight:500",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] combobox_collection(
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
    attrs=ui_attrs(attrs).data_set("slot", "combobox-collection"),
    style=ui_styles(["display:contents"], style),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] combobox_empty(
  visible? : Bool = true,
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
    hidden=!visible,
    attrs=ui_attrs(attrs).role("status").data_set("slot", "combobox-empty"),
    style=ui_styles(
      [
        "padding:1.5rem 0.75rem;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem;text-align:center",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn combobox_separator(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .role("separator")
      .data_set("slot", "combobox-separator"),
    style=ui_styles(
      [
        "height:1px;margin:0.25rem -0.25rem;background:var(--rui-border,oklch(0.922 0 0));pointer-events:none",
      ],
      style,
    ),
    "",
  )
}

///|
pub fn[C : @html.IsChildren] combobox_chips(
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
    attrs=ui_attrs(attrs).data_set("slot", "combobox-chips"),
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTransition, ComboboxChipsStyle],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] combobox_chip(
  scope~ : ComboboxScope,
  value~ : String,
  removable? : Bool = true,
  remove_label? : String = "Remove",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.span(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "combobox-chip")
      .data_set("value", value),
    style=ui_styles(
      [
        "display:inline-flex;max-width:100%;height:1.5rem;align-items:center;gap:0.25rem;border:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:calc(var(--rui-radius,0.625rem) - 0.25rem);background:var(--rui-secondary,oklch(0.97 0 0));padding:0 0.375rem;color:var(--rui-secondary-foreground,oklch(0.205 0 0));font-size:0.75rem;line-height:1rem",
      ],
      style,
    ),
    [
      @html.span(
        style=["min-width:0;overflow:hidden;text-overflow:ellipsis"],
        children,
      ),
      if removable {
        @html.button(
          type_="button",
          disabled=scope.disabled,
          attrs=@html.Attrs::build()
            .aria_label("\{remove_label}: \{value}")
            .data_set("slot", "combobox-chip-remove")
            .data_set("variant", button_variant_value(Ghost))
            .data_set("size", button_size_value(IconXs))
            .on_click_after(_ => (scope.emit)(ComboboxRemove(value))),
          style=ui_styles(
            [
              UiBoxSizing,
              UiFontSans,
              UiTransition,
              ButtonBaseStyle,
              button_variant_style(Ghost),
              button_size_style(IconXs),
              "margin-inline-start:-0.25rem;--rui-button-base-fg:inherit;opacity:var(--rui-chip-remove-opacity,0.5);font-size:0.875rem",
              ui_disabled_style(scope.disabled),
            ],
            [],
          ),
          ui_x_icon(),
        )
      } else {
        @html.nothing
      },
    ],
  )
}

///|
pub fn[C : @html.IsChildren] combobox_content(
  scope~ : ComboboxScope,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let resolved_id = id.unwrap_or("\{scope.id}-content")
  scope.content_id.val = resolved_id
  let content_attrs = popup_state_attrs(
      attrs,
      "combobox-content",
      scope.model.open,
    )
    .popover("auto")
    .role("listbox")
    .aria_multiselectable(ui_bool(scope.multiple))
    .aria_required(ui_bool(scope.required))
    .aria_invalid(ui_bool(scope.invalid))
    .data_set("trigger-id", scope.anchor_id.val)
    .data_set("requested-side", popup_side_value(scope.side))
    .data_set("requested-align", popup_align_value(scope.align))
    .data_set("side", popup_side_value(scope.side))
    .data_set("align", popup_align_value(scope.align))
    .data_set("side-offset", "\{scope.side_offset}")
    .data_set("align-offset", "\{scope.align_offset}")
  @html.div(
    id=resolved_id,
    class?,
    title?,
    attrs=content_attrs,
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        ComboboxContentStyle,
        PopupTransition100Style,
        popup_floating_anchor_style(
          scope.anchor_id.val,
          scope.side,
          scope.align,
          scope.side_offset,
          scope.align_offset,
        ),
        popup_state_style(scope.model.open),
      ],
      style,
    ),
    children,
  )
}

///|
fn combobox_default_items(scope : ComboboxScope) -> @html.Html {
  let items : Array[@html.Html] = []
  let filter_query = combobox_filter_query(
    scope.options,
    scope.model.values,
    scope.multiple,
    scope.model.query,
  )
  for option in scope.options {
    if combobox_matches(option, filter_query) {
      items.push(combobox_item(scope~, value=option.value, option.label))
    }
  }
  combobox_list([
    combobox_empty(visible=items.length() == 0, scope.empty_text),
    @html.fragment(items),
  ])
}

///|
fn combobox_default_view(scope : ComboboxScope) -> @html.Html {
  let chips : Array[@html.Html] = []
  if scope.multiple {
    for value in scope.model.values {
      let index = combobox_option_index(scope.options, value)
      if index >= 0 {
        chips.push(combobox_chip(scope~, value~, scope.options[index].label))
      }
    }
  }
  let action = if scope.model.values.length() > 0 || scope.model.query != "" {
    combobox_clear(scope~)
  } else {
    combobox_default_trigger(scope)
  }
  let control_children : Array[@html.Html] = if scope.multiple {
    [
      combobox_chips(style=[input_invalid_style(scope.invalid)], [
        @html.fragment(chips),
        combobox_chips_input(scope~),
        action,
      ]),
    ]
  } else {
    [combobox_input(scope~), action]
  }
  let control_id = "\{scope.id}-control"
  scope.anchor_id.val = control_id
  let control = @html.div(
    id=control_id,
    attrs=@html.Attrs::build().data_set("slot", "combobox-control"),
    style=[
      UiBoxSizing,
      if scope.multiple {
        ComboboxControlLayoutStyle
      } else {
        ComboboxControlStyle
      },
      if scope.multiple {
        ""
      } else {
        input_invalid_style(scope.invalid)
      },
      popup_anchor_style(control_id),
    ],
    control_children,
  )
  @html.fragment([
    control,
    combobox_content(scope~, combobox_default_items(scope)),
  ])
}

///|
fn combobox_hidden_inputs(scope : ComboboxScope) -> @html.Html {
  if scope.name is Some(name) {
    let controls : Array[@html.Html] = []
    if scope.model.values.length() == 0 {
      controls.push(
        @html.input(
          input_type=@html.Hidden,
          name~,
          value="",
          attrs=@html.Attrs::build().disabled(scope.disabled),
        ),
      )
    } else {
      for value in scope.model.values {
        controls.push(
          @html.input(
            input_type=@html.Hidden,
            name~,
            value~,
            attrs=@html.Attrs::build().disabled(scope.disabled),
          ),
        )
      }
    }
    @html.fragment(controls)
  } else {
    @html.nothing
  }
}

///|
fn combobox_render(
  scope : ComboboxScope,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  render : ((ComboboxScope) -> @html.Html)?,
) -> @html.Html {
  @html.div(
    id="\{scope.id}-root",
    class?,
    title?,
    attrs=combobox_root_attrs(scope, attrs),
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        ComboboxRootStyle,
        ui_disabled_visual_style(scope.disabled),
      ],
      style,
    ),
    [
      combobox_hidden_inputs(scope),
      if render is Some(render) {
        // Discover a custom popup id before rendering an earlier input or
        // trigger so their aria-controls references the actual listbox.
        ignore(render(scope))
        render(scope)
      } else {
        combobox_default_view(scope)
      },
    ],
  )
}

///|
#cfg(target="js")
pub fn combobox(
  id~ : String,
  options~ : Array[ComboboxOption],
  default_value? : String,
  default_values? : Array[String] = [],
  multiple? : Bool = false,
  default_open? : Bool = false,
  placeholder? : String = "Select an option",
  empty_text? : String = "No results found.",
  disabled? : Bool = false,
  invalid? : Bool = false,
  required? : Bool = false,
  name? : String,
  side? : PopupSide = Bottom,
  align? : PopupAlign = Start,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  on_value_change? : @cmd.Emit[String],
  on_values_change? : @cmd.Emit[Array[String]],
  on_query_change? : @cmd.Emit[String],
  on_open_change? : @cmd.Emit[Bool],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  render? : (ComboboxScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  let requested = default_values.copy()
  if default_value is Some(value) && !combobox_contains(requested, value) {
    requested.push(value)
  }
  let values = combobox_normalize_values(options, requested, multiple)
  let initial_query = combobox_selected_input_value(options, values, multiple)
  let initial : ComboboxModel = {
    open: default_open && !disabled,
    query: initial_query,
    values,
    active: -1,
  }
  let (model, emit) = @rabbita.create_state_with_init(
    init=emit => {
      (
        initial,
        @cmd.batch([
          ui_listbox_bind_sync_cmd(
            id,
            "combobox-content",
            emit.map(value => ComboboxNativeChanged(value)),
          ),
          combobox_bind_events_cmd(id, emit),
          if initial.open {
            combobox_popup_cmd(id, Some(true), false)
          } else {
            @cmd.none
          },
        ]),
      )
    },
    update=(_, message, current) => {
      match message {
        ComboboxOpen =>
          if disabled || current.open {
            (current, @cmd.none)
          } else {
            (
              { ..current, open: true, active: -1 },
              @cmd.batch([
                combobox_popup_cmd(id, Some(true), false),
                combobox_notify_open(on_open_change, true),
              ]),
            )
          }
        ComboboxToggle =>
          if disabled {
            (current, @cmd.none)
          } else {
            let open = !current.open
            let query = if open {
              current.query
            } else {
              combobox_selected_input_value(options, current.values, multiple)
            }
            (
              { ..current, open, query, active: -1 },
              @cmd.batch([
                combobox_popup_cmd(id, Some(open), true),
                if query != current.query {
                  combobox_notify_query(on_query_change, query)
                } else {
                  @cmd.none
                },
                combobox_notify_open(on_open_change, open),
              ]),
            )
          }
        ComboboxNativeChanged(open) =>
          if current.open == open {
            (current, @cmd.none)
          } else if open {
            (
              { ..current, open: true, active: -1 },
              combobox_notify_open(on_open_change, true),
            )
          } else {
            let query = combobox_selected_input_value(
              options,
              current.values,
              multiple,
            )
            (
              { ..current, open: false, query, active: -1 },
              @cmd.batch([
                combobox_notify_open(on_open_change, false),
                if query != current.query {
                  combobox_notify_query(on_query_change, query)
                } else {
                  @cmd.none
                },
              ]),
            )
          }
        ComboboxSetQuery(query) => {
          let clearing_selection = !multiple &&
            query == "" &&
            current.values.length() > 0
          let values = if clearing_selection { [] } else { current.values }
          (
            { open: true, query, values, active: -1 },
            @cmd.batch([
              combobox_popup_cmd(id, Some(true), false),
              if current.open {
                @cmd.none
              } else {
                combobox_notify_open(on_open_change, true)
              },
              if clearing_selection {
                combobox_notify_values(
                  on_value_change, on_values_change, values,
                )
              } else {
                @cmd.none
              },
              combobox_notify_query(on_query_change, query),
            ]),
          )
        }
        ComboboxMove(direction) => {
          let filter_query = combobox_filter_query(
            options,
            current.values,
            multiple,
            current.query,
          )
          let active = combobox_next_match(
            options,
            filter_query,
            current.active,
            direction,
          )
          (
            { ..current, open: true, active },
            @cmd.batch([
              combobox_popup_cmd(id, Some(true), false),
              if current.open {
                @cmd.none
              } else {
                combobox_notify_open(on_open_change, true)
              },
            ]),
          )
        }
        ComboboxFirst => {
          let filter_query = combobox_filter_query(
            options,
            current.values,
            multiple,
            current.query,
          )
          let active = combobox_first_match(options, filter_query, false)
          ({ ..current, active, }, @cmd.none)
        }
        ComboboxLast => {
          let filter_query = combobox_filter_query(
            options,
            current.values,
            multiple,
            current.query,
          )
          let active = combobox_first_match(options, filter_query, true)
          ({ ..current, active, }, @cmd.none)
        }
        ComboboxHighlight(index) => ({ ..current, active: index }, @cmd.none)
        ComboboxChoose(requested_index) => {
          let index = if requested_index < 0 {
            current.active
          } else {
            requested_index
          }
          if index < 0 ||
            index >= options.length() ||
            options[index].disabled ||
            !combobox_matches(
              options[index],
              combobox_filter_query(
                options,
                current.values,
                multiple,
                current.query,
              ),
            ) {
            (current, @cmd.none)
          } else {
            let values = combobox_toggle_value(
              current.values,
              options[index].value,
              multiple,
            )
            let open = multiple
            let query = combobox_selected_input_value(options, values, multiple)
            (
              { values, open, query, active: if multiple { index } else { -1 } },
              @cmd.batch([
                combobox_notify_values(
                  on_value_change, on_values_change, values,
                ),
                combobox_notify_query(on_query_change, query),
                combobox_popup_cmd(
                  id,
                  if multiple {
                    None
                  } else {
                    Some(false)
                  },
                  true,
                ),
                if multiple {
                  @cmd.none
                } else {
                  combobox_notify_open(on_open_change, false)
                },
              ]),
            )
          }
        }
        ComboboxRemove(value) => {
          let values = combobox_remove_value(current.values, value)
          (
            { ..current, values, },
            combobox_notify_values(on_value_change, on_values_change, values),
          )
        }
        ComboboxClear =>
          (
            { ..current, values: [], query: "", active: -1 },
            @cmd.batch([
              combobox_notify_values(on_value_change, on_values_change, []),
              combobox_notify_query(on_query_change, ""),
              combobox_popup_cmd(id, None, true),
            ]),
          )
        ComboboxClose =>
          if current.open {
            let query = combobox_selected_input_value(
              options,
              current.values,
              multiple,
            )
            (
              { ..current, open: false, query, active: -1 },
              @cmd.batch([
                combobox_popup_cmd(id, Some(false), false),
                combobox_notify_open(on_open_change, false),
                if query != current.query {
                  combobox_notify_query(on_query_change, query)
                } else {
                  @cmd.none
                },
              ]),
            )
          } else {
            (current, @cmd.none)
          }
        ComboboxDismiss =>
          if current.open {
            let query = combobox_selected_input_value(
              options,
              current.values,
              multiple,
            )
            (
              { ..current, open: false, query, active: -1 },
              @cmd.batch([
                combobox_popup_cmd(id, Some(false), false),
                combobox_notify_open(on_open_change, false),
                if query != current.query {
                  combobox_notify_query(on_query_change, query)
                } else {
                  @cmd.none
                },
              ]),
            )
          } else {
            (current, @cmd.none)
          }
      }
    },
  )
  model.view(model => {
    combobox_render(
      {
        id,
        options,
        model,
        multiple,
        placeholder,
        empty_text,
        disabled,
        invalid,
        required,
        name,
        side,
        align,
        side_offset,
        align_offset,
        emit,
        content_id: Ref("\{id}-content"),
        anchor_id: Ref("\{id}-input"),
        has_input: Ref(false),
      },
      class,
      title,
      attrs,
      style,
      render,
    )
  })
}

///|
#cfg(not(target="js"))
pub fn combobox(
  id~ : String,
  options~ : Array[ComboboxOption],
  default_value? : String,
  default_values? : Array[String] = [],
  multiple? : Bool = false,
  default_open? : Bool = false,
  placeholder? : String = "Select an option",
  empty_text? : String = "No results found.",
  disabled? : Bool = false,
  invalid? : Bool = false,
  required? : Bool = false,
  name? : String,
  side? : PopupSide = Bottom,
  align? : PopupAlign = Start,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  on_value_change? : @cmd.Emit[String],
  on_values_change? : @cmd.Emit[Array[String]],
  on_query_change? : @cmd.Emit[String],
  on_open_change? : @cmd.Emit[Bool],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  render? : (ComboboxScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  ignore((on_value_change, on_values_change, on_query_change, on_open_change))
  let requested = default_values.copy()
  if default_value is Some(value) && !combobox_contains(requested, value) {
    requested.push(value)
  }
  let model : ComboboxModel = {
    open: default_open && !disabled,
    query: combobox_selected_input_value(
      options,
      combobox_normalize_values(options, requested, multiple),
      multiple,
    ),
    values: combobox_normalize_values(options, requested, multiple),
    active: -1,
  }
  @rabbita.Val::constant(
    combobox_render(
      {
        id,
        options,
        model,
        multiple,
        placeholder,
        empty_text,
        disabled,
        invalid,
        required,
        name,
        side,
        align,
        side_offset,
        align_offset,
        emit: @cmd.Emit(_ => @cmd.none),
        content_id: Ref("\{id}-content"),
        anchor_id: Ref("\{id}-input"),
        has_input: Ref(false),
      },
      class,
      title,
      attrs,
      style,
      render,
    ),
  )
}
