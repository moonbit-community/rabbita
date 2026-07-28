///|
/// One option consumed by the black-box [`select`] component.
struct SelectOption {
  value : String
  label : String
  disabled : Bool
}

///|
pub fn select_option(
  value~ : String,
  label~ : String,
  disabled? : Bool = false,
) -> SelectOption {
  { value, label, disabled }
}

///|
priv struct SelectModel {
  open : Bool
  value : String?
  active : Int
  search : String
  search_generation : Int
} derive(Eq)

///|
priv enum SelectMsg {
  SelectToggle
  SelectNativeChanged(Bool)
  SelectMove(Int)
  SelectHighlight(Int)
  SelectFirst
  SelectLast
  SelectChoose(Int)
  SelectClose
  SelectDismiss
  SelectTypeahead(String)
  SelectClearTypeahead(Int)
}

///|
/// Opaque state handle passed by [`select`] to its compound rendering helpers.
struct SelectScope {
  id : String
  options : Array[SelectOption]
  model : SelectModel
  placeholder : String
  disabled : Bool
  invalid : Bool
  required : Bool
  name : String?
  side : PopupSide
  align : PopupAlign
  side_offset : Int
  align_offset : Int
  emit : @cmd.Emit[SelectMsg]
  content_id : Ref[String]
  trigger_id : Ref[String]
}

///|
const SelectRootStyle : String = "position:relative;display:inline-flex;width:100%;min-width:0"

///|
const SelectTriggerStyle : String = "display:flex;width:100%;height:2.25rem;min-width:0;align-items:center;justify-content:space-between;gap:0.5rem;--rui-control-base-bg:var(--rui-input-background,transparent);--rui-control-base-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-control-base-border:var(--rui-input,oklch(0.922 0 0));--rui-control-base-shadow:0 1px 2px rgb(0 0 0 / 0.05);border:1px solid transparent;border-color:var(--rui-control-border,var(--rui-control-base-border,var(--rui-input,oklch(0.922 0 0))));border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-control-bg,var(--rui-control-base-bg,var(--rui-input-background,transparent)));padding:0.25rem 0.625rem;color:var(--rui-control-fg,var(--rui-control-base-fg,var(--rui-foreground,oklch(0.145 0 0))));font-size:0.875rem;line-height:1.25rem;text-align:start;white-space:nowrap;outline-offset:2px;box-shadow:var(--rui-control-shadow,var(--rui-control-base-shadow,0 1px 2px rgb(0 0 0 / 0.05)));cursor:pointer"

///|
const SelectContentStyle : String = "position:fixed;inset:auto;left:var(--rui-floating-left,auto);top:var(--rui-floating-top,auto);z-index:50;display:flex;width:var(--rui-floating-anchor-width,anchor-size(width));min-width:max(8rem,var(--rui-floating-anchor-width,anchor-size(width)));max-width:var(--rui-floating-available-width,calc(100vw - 1rem));max-height:var(--rui-floating-available-height,calc(100vh - 1rem));transform-origin:var(--rui-floating-transform-origin,center);flex-direction:column;overflow-x:hidden;overflow-y:auto;margin:0;border:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-popover,oklch(1 0 0));padding:0;color:var(--rui-popover-foreground,oklch(0.145 0 0));box-shadow:0 10px 15px -3px rgb(0 0 0 / 0.1),0 4px 6px -4px rgb(0 0 0 / 0.1);outline:none;transition:opacity 100ms ease,transform 100ms ease,visibility 100ms ease"

///|
const SelectItemStyle : String = "position:relative;display:flex;width:100%;min-height:2rem;align-items:center;gap:0.5rem;border:0;border-radius:calc(var(--rui-radius,0.625rem) - 0.25rem);background:var(--rui-menu-item-bg,var(--rui-menu-item-base-bg,transparent));padding-block:0.375rem;padding-inline:0.5rem 2rem;color:var(--rui-menu-item-fg,var(--rui-menu-item-base-fg,inherit));font:inherit;font-size:0.875rem;line-height:1.25rem;text-align:start;white-space:nowrap;outline:none;cursor:pointer"

///|
fn select_find_value(options : Array[SelectOption], value : String?) -> Int {
  if value is Some(value) {
    for index, option in options {
      if option.value == value && !option.disabled {
        return index
      }
    }
  }
  -1
}

///|
fn select_first_enabled(options : Array[SelectOption], reverse : Bool) -> Int {
  if reverse {
    let mut index = options.length() - 1
    while index >= 0 {
      if !options[index].disabled {
        return index
      }
      index -= 1
    }
  } else {
    for index, option in options {
      if !option.disabled {
        return index
      }
    }
  }
  -1
}

///|
fn select_next_enabled(
  options : Array[SelectOption],
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
    if !options[index].disabled {
      return index
    }
    remaining -= 1
  }
  -1
}

///|
fn select_typeahead_index(
  options : Array[SelectOption],
  current : Int,
  search : String,
) -> Int {
  if search == "" || options.length() == 0 {
    return -1
  }
  let needle = search.to_lower()
  let mut offset = 1
  while offset <= options.length() {
    let start = if current < 0 { -1 } else { current }
    let index = (start + offset) % options.length()
    let option = options[index]
    if !option.disabled && option.label.to_lower().has_prefix(needle) {
      return index
    }
    offset += 1
  }
  -1
}

///|
fn select_typeahead_search(current : String, key : String) -> String {
  let normalized_key = key.to_lower()
  if current == normalized_key {
    normalized_key
  } else {
    current + normalized_key
  }
}

///|
fn select_label_for(scope : SelectScope) -> String {
  let index = select_find_value(scope.options, scope.model.value)
  if index >= 0 {
    scope.options[index].label
  } else {
    scope.placeholder
  }
}

///|
fn select_item_id(scope : SelectScope, index : Int) -> String {
  "\{scope.id}-item-\{index}"
}

///|
fn ui_listbox_run_open_sequence(
  set_layer : () -> Unit,
  focus : (() -> Unit)?,
) -> Unit {
  set_layer()
  if focus is Some(focus) {
    focus()
  }
}

///|
#cfg(target="js")
fn find_listbox_content_id(root_id : String, slot : String) -> String {
  guard ui_element_by_id(root_id + "-root") is Some(root) else { return "" }
  guard ui_find_element(root.query_selector_all("[data-slot]"), element => {
      element.get_attribute("data-slot").unwrap_or("") == slot
    })
    is Some(content) else {
    return ""
  }
  content.get_attribute("id").unwrap_or("")
}

///|
#cfg(target="js")
fn sync_select_trigger_id(root_id : String, content_id : String) -> Unit {
  guard ui_element_by_id(root_id + "-root") is Some(root) else { return }
  guard ui_element_by_id(content_id) is Some(content) else { return }
  guard ui_find_element(root.query_selector_all("[data-slot]"), element => {
      element.get_attribute("data-slot").unwrap_or("") == "select-trigger"
    })
    is Some(trigger) else {
    return
  }
  let trigger_id = trigger.get_attribute("id").unwrap_or("")
  if trigger_id != "" {
    content.set_attribute("data-trigger-id", trigger_id)
  }
}

///|
#cfg(target="js")
fn ui_listbox_set_open_now(
  root_id : String,
  slot : String,
  open : Bool,
) -> Unit {
  let content_id = find_listbox_content_id(root_id, slot)
  if content_id != "" {
    ignore(set_floating_open(content_id, open))
    if open {
      position_floating(content_id)
    }
  }
}

///|
#cfg(not(target="js"))
fn ui_listbox_set_open_now(
  root_id : String,
  slot : String,
  open : Bool,
) -> Unit {
  ignore((root_id, slot, open))
}

///|
#cfg(target="js")
fn ui_listbox_bind_sync_cmd(
  root_id : String,
  slot : String,
  sync : @cmd.Emit[Bool],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, scheduler => {
    let content_id = find_listbox_content_id(root_id, slot)
    if content_id != "" {
      bind_floating_sync(content_id, open => scheduler.add(sync(open)))
    }
  })
}

///|
#cfg(not(target="js"))
fn ui_listbox_bind_sync_cmd(
  root_id : String,
  slot : String,
  sync : @cmd.Emit[Bool],
) -> @cmd.Cmd {
  ignore((root_id, slot, sync))
  @cmd.none
}

///|
#cfg(target="js")
fn focus_select_part(root_id : String, slot : String, value : String) -> Unit {
  // A click focuses its trigger as the browser's default action after the
  // handler returns. Move focus on the following frame so native activation
  // cannot overwrite the listbox focus target.
  ui_after_request_frame(() => {
    guard ui_element_by_id(root_id + "-root") is Some(root) else { return }
    let candidates = root
      .query_selector_all("[data-slot]")
      .filter(element => {
        element.get_attribute("data-slot").unwrap_or("") == slot
      })
    let target = if slot == "select-item" {
      ui_find_element(candidates, element => {
        element.get_attribute("data-value").unwrap_or("") == value
      })
    } else {
      candidates.get(0)
    }
    if target is Some(target) {
      ui_focus_element_without_scroll(target)
    }
  })
}

///|
#cfg(target="js")
fn select_popup_cmd(
  id : String,
  open : Bool?,
  focus_slot : String?,
  focus_value : String,
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, _ => {
    let content_id = find_listbox_content_id(id, "select-content")
    if content_id != "" {
      // Resolve the rendered trigger instead of assuming the default id. This
      // also works when compound parts are evaluated in a different order.
      sync_select_trigger_id(id, content_id)
    }
    let set_layer = () => {
      if open is Some(open) {
        ui_listbox_set_open_now(id, "select-content", open)
      }
    }
    let focus : (() -> Unit)? = if focus_slot is Some(slot) {
      Some(() => focus_select_part(id, slot, focus_value))
    } else {
      None
    }
    ui_listbox_run_open_sequence(set_layer, focus)
  })
}

///|
#cfg(not(target="js"))
fn select_popup_cmd(
  id : String,
  open : Bool?,
  focus_slot : String?,
  focus_value : String,
) -> @cmd.Cmd {
  ignore((id, open, focus_slot, focus_value))
  @cmd.none
}

///|
fn select_open_commands(scope : SelectScope, open : Bool) -> @cmd.Cmd {
  if open &&
    scope.model.active >= 0 &&
    scope.model.active < scope.options.length() {
    select_popup_cmd(
      scope.id,
      Some(true),
      Some("select-item"),
      scope.options[scope.model.active].value,
    )
  } else if open {
    select_popup_cmd(scope.id, Some(true), None, "")
  } else {
    select_popup_cmd(scope.id, Some(false), Some("select-trigger"), "")
  }
}

///|
#cfg(target="js")
fn select_root_keydown(
  scope : SelectScope,
  event : @dom.KeyboardEvent,
) -> @cmd.Cmd {
  if event.alt_key() ||
    event.ctrl_key() ||
    event.meta_key() ||
    event.is_composing() {
    return @cmd.none
  }
  guard event.current_target().to_option() is Some(current_target) &&
    current_target.to_element() is Some(root) else {
    return @cmd.none
  }
  guard event.target().to_element() is Some(event_target) else {
    return @cmd.none
  }
  guard event_target.closest(
      "[data-slot=\"select-trigger\"],[data-slot=\"select-item\"]",
    )
    is Some(target) &&
    target.closest("[data-slot=\"select\"]") is Some(owner) &&
    owner.is_same_node(root.as_node()) else {
    return @cmd.none
  }
  let key = event.key()
  let slot = target.get_attribute("data-slot").unwrap_or("")
  if key == "Tab" && scope.model.open {
    return (scope.emit)(SelectDismiss)
  }
  let message : SelectMsg? = match key {
    "ArrowDown" => Some(SelectMove(1))
    "ArrowUp" => Some(SelectMove(-1))
    "Home" => Some(SelectFirst)
    "End" => Some(SelectLast)
    "Escape" => Some(SelectClose)
    "Enter" if slot == "select-item" => Some(SelectChoose(-1))
    " " if slot == "select-item" && scope.model.search == "" =>
      Some(SelectChoose(-1))
    "Enter" | " " if slot == "select-trigger" => Some(SelectToggle)
    _ => if key.length() == 1 { Some(SelectTypeahead(key)) } else { None }
  }
  if message is Some(message) {
    event.prevent_default()
    (scope.emit)(message)
  } else {
    @cmd.none
  }
}

///|
#cfg(target="js")
fn select_bind_root_keyboard(attrs : @html.Attrs, scope : SelectScope) -> Unit {
  ignore(attrs.on_keydown(event => select_root_keydown(scope, event)))
}

///|
#cfg(not(target="js"))
fn select_bind_root_keyboard(attrs : @html.Attrs, scope : SelectScope) -> Unit {
  ignore((attrs, scope))
}

///|
fn select_notify_bool(notify : @cmd.Emit[Bool]?, value : Bool) -> @cmd.Cmd {
  if notify is Some(notify) {
    notify(value)
  } else {
    @cmd.none
  }
}

///|
fn select_notify_value(notify : @cmd.Emit[String]?, value : String) -> @cmd.Cmd {
  if notify is Some(notify) {
    notify(value)
  } else {
    @cmd.none
  }
}

///|
fn select_resolve_active(
  options : Array[SelectOption],
  model : SelectModel,
) -> Int {
  if model.active >= 0 &&
    model.active < options.length() &&
    !options[model.active].disabled {
    model.active
  } else {
    let selected = select_find_value(options, model.value)
    if selected >= 0 {
      selected
    } else {
      select_first_enabled(options, false)
    }
  }
}

///|
fn select_scope_root_attrs(
  scope : SelectScope,
  attrs : @html.Attrs?,
) -> @html.Attrs {
  let root_attrs = popup_state_attrs(attrs, "select", scope.model.open)
    .data_set("value", scope.model.value.unwrap_or(""))
    .data_set("searching", ui_bool(scope.model.search != ""))
  if scope.disabled {
    ignore(root_attrs.data_set("disabled", "").aria_disabled("true"))
  }
  if scope.invalid {
    ignore(root_attrs.data_set("invalid", "").aria_invalid("true"))
  }
  select_bind_root_keyboard(root_attrs, scope)
  root_attrs
}

///|
pub fn select_value(
  scope~ : SelectScope,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  prefix? : @html.Html,
) -> @html.Html {
  let empty = scope.model.value is None
  @html.span(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "select-value")
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
      if prefix is Some(prefix) {
        prefix
      } else {
        @html.nothing
      },
      @html.span(
        style=["min-width:0;overflow:hidden;text-overflow:ellipsis"],
        select_label_for(scope),
      ),
    ],
  )
}

///|
pub fn select_trigger(
  scope~ : SelectScope,
  aria_label? : String,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let resolved_id = id.unwrap_or("\{scope.id}-trigger")
  scope.trigger_id.val = resolved_id
  let trigger_attrs = popup_state_attrs(
      attrs,
      "select-trigger",
      scope.model.open,
    )
    .role("combobox")
    .aria_haspopup("listbox")
    .aria_expanded(ui_bool(scope.model.open))
    .aria_invalid(ui_bool(scope.invalid))
  if scope.model.open {
    ignore(trigger_attrs.aria_controls(scope.content_id.val))
  }
  if aria_label is Some(label) {
    ignore(trigger_attrs.aria_label(label))
  }
  if !scope.disabled {
    ignore(trigger_attrs.on_click(_ => (scope.emit)(SelectToggle)))
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
        UiTextRendering,
        UiTransition,
        SelectTriggerStyle,
        input_invalid_style(scope.invalid),
        ui_disabled_style(scope.disabled),
        popup_anchor_style(resolved_id),
      ],
      style,
    ),
    [
      select_value(scope~),
      @html.span(
        attrs=@html.Attrs::build().aria_hidden("true"),
        style=[
          "display:inline-flex;flex:none;align-items:center;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.75rem;line-height:1",
        ],
        ui_chevron_down_icon(),
      ),
    ],
  )
}

///|
pub fn[C : @html.IsChildren] select_group(
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
    .data_set("slot", "select-group")
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
pub fn[C : @html.IsChildren] select_label(
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
    attrs=ui_attrs(attrs).data_set("slot", "select-label"),
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
pub fn[C : @html.IsChildren] select_item(
  scope~ : SelectScope,
  value~ : String,
  disabled? : Bool,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let mut index = -1
  for option_index, option in scope.options {
    if option.value == value && index < 0 {
      index = option_index
    }
  }
  let option_disabled = if disabled is Some(disabled) {
    disabled
  } else if index >= 0 {
    scope.options[index].disabled
  } else {
    false
  }
  let selected = scope.model.value is Some(current) && current == value
  let active = scope.model.open && index >= 0 && scope.model.active == index
  let item_attrs = ui_attrs(attrs)
    .role("option")
    .aria_selected(ui_bool(selected))
    .aria_disabled(ui_bool(option_disabled))
    .data_set("slot", "select-item")
    .data_set("value", value)
    .data_set("state", if selected { "checked" } else { "unchecked" })
    .data_set("highlighted", ui_bool(active))
    .tabindex(if active { 0 } else { -1 })
  if option_disabled {
    ignore(item_attrs.data_set("disabled", ""))
  }
  if !option_disabled && index >= 0 {
    ignore(item_attrs.on_click(_ => (scope.emit)(SelectChoose(index))))
    ignore(item_attrs.on_mouseenter(_ => (scope.emit)(SelectHighlight(index))))
  }
  @html.button(
    id=id.unwrap_or(if index >= 0 { select_item_id(scope, index) } else { "" }),
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
        SelectItemStyle,
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
            .data_set("slot", "select-item-indicator"),
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
pub fn select_separator(
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
    attrs=ui_attrs(attrs).role("separator").data_set("slot", "select-separator"),
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
fn select_scroll_button(
  scope : SelectScope,
  direction : Int,
  slot : String,
  label : String,
  attrs : @html.Attrs?,
  style : Array[String],
) -> @html.Html {
  let button_attrs = ui_attrs(attrs)
    .aria_label(label)
    .data_set("slot", slot)
    .tabindex(-1)
    .on_click(_ => (scope.emit)(SelectMove(direction)))
  @html.button(
    type_="button",
    attrs=button_attrs,
    style=ui_styles(
      [
        "display:flex;width:100%;height:1.5rem;align-items:center;justify-content:center;border:0;background:var(--rui-popover,white);color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.75rem;cursor:default",
      ],
      style,
    ),
    if direction < 0 {
      ui_chevron_up_icon()
    } else {
      ui_chevron_down_icon()
    },
  )
}

///|
pub fn select_scroll_up_button(
  scope~ : SelectScope,
  label? : String = "Scroll up",
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  select_scroll_button(
    scope, -1, "select-scroll-up-button", label, attrs, style,
  )
}

///|
pub fn select_scroll_down_button(
  scope~ : SelectScope,
  label? : String = "Scroll down",
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  select_scroll_button(
    scope, 1, "select-scroll-down-button", label, attrs, style,
  )
}

///|
pub fn[C : @html.IsChildren] select_content(
  scope~ : SelectScope,
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
      "select-content",
      scope.model.open,
    )
    .popover("auto")
    .role("listbox")
    .tabindex(-1)
    .aria_required(ui_bool(scope.required))
    .aria_invalid(ui_bool(scope.invalid))
    .data_set("trigger-id", scope.trigger_id.val)
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
        SelectContentStyle,
        PopupTransition100Style,
        popup_floating_anchor_style(
          scope.trigger_id.val,
          scope.side,
          scope.align,
          scope.side_offset,
          scope.align_offset,
        ),
        popup_state_style(scope.model.open),
      ],
      style,
    ),
    @html.div(
      attrs=@html.Attrs::build().data_set("slot", "select-viewport"),
      style=["min-height:0;overflow-y:auto;padding:0.25rem"],
      children,
    ),
  )
}

///|
fn select_default_view(scope : SelectScope) -> @html.Html {
  let items : Array[@html.Html] = []
  for option in scope.options {
    items.push(select_item(scope~, value=option.value, option.label))
  }
  @html.fragment([select_trigger(scope~), select_content(scope~, items)])
}

///|
fn select_render(
  scope : SelectScope,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  render : ((SelectScope) -> @html.Html)?,
) -> @html.Html {
  let body = if render is Some(render) {
    // Compound renderers are pure. The discovery pass lets a custom Content
    // id participate in Trigger's aria-controls even when Trigger is declared
    // first, matching the two-pass Command catalog.
    ignore(render(scope))
    render(scope)
  } else {
    select_default_view(scope)
  }
  let hidden_control = if scope.name is Some(name) {
    @html.input(
      input_type=Hidden,
      name~,
      value=scope.model.value.unwrap_or(""),
      attrs=@html.Attrs::build()
        .disabled(scope.disabled)
        .data_set("slot", "select-hidden-input")
        .aria_hidden("true"),
    )
  } else {
    @html.nothing
  }
  @html.span(
    id="\{scope.id}-root",
    class?,
    title?,
    attrs=select_scope_root_attrs(scope, attrs),
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, SelectRootStyle],
      style,
    ),
    [hidden_control, body],
  )
}

///|
#cfg(target="js")
pub fn select(
  id~ : String,
  options~ : Array[SelectOption],
  default_value? : String,
  default_open? : Bool = false,
  placeholder? : String = "Select an option",
  disabled? : Bool = false,
  invalid? : Bool = false,
  required? : Bool = false,
  name? : String,
  side? : PopupSide = Bottom,
  align? : PopupAlign = Start,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  on_value_change? : @cmd.Emit[String],
  on_open_change? : @cmd.Emit[Bool],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  render? : (SelectScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  let selected = select_find_value(options, default_value)
  let initial_value = if selected >= 0 {
    Some(options[selected].value)
  } else {
    None
  }
  let initial_active = if selected >= 0 {
    selected
  } else {
    select_first_enabled(options, false)
  }
  let initial : SelectModel = {
    open: default_open && !disabled,
    value: initial_value,
    active: initial_active,
    search: "",
    search_generation: 0,
  }
  let (model, emit) = @rabbita.create_state_with_init(
    init=emit => {
      (
        initial,
        @cmd.batch([
          ui_listbox_bind_sync_cmd(
            id,
            "select-content",
            emit.map(value => SelectNativeChanged(value)),
          ),
          if initial.open {
            select_popup_cmd(id, Some(true), None, "")
          } else {
            @cmd.none
          },
        ]),
      )
    },
    update=(current, message, emit) => {
      let base_scope : SelectScope = {
        id,
        options,
        model: current,
        placeholder,
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
        trigger_id: Ref("\{id}-trigger"),
      }
      match message {
        SelectToggle =>
          if disabled {
            (current, @cmd.none)
          } else {
            let open = !current.open
            let active = select_resolve_active(options, current)
            let next = { ..current, open, active }
            let next_scope = { ..base_scope, model: next }
            (
              next,
              @cmd.batch([
                select_open_commands(next_scope, open),
                select_notify_bool(on_open_change, open),
              ]),
            )
          }
        SelectNativeChanged(open) =>
          if current.open == open {
            (current, @cmd.none)
          } else if open {
            let active = select_resolve_active(options, current)
            (
              { ..current, open: true, active },
              @cmd.batch([
                select_notify_bool(on_open_change, true),
                if active >= 0 && active < options.length() {
                  select_popup_cmd(
                    id,
                    None,
                    Some("select-item"),
                    options[active].value,
                  )
                } else {
                  @cmd.none
                },
              ]),
            )
          } else {
            (
              { ..current, open: false },
              select_notify_bool(on_open_change, false),
            )
          }
        SelectMove(direction) => {
          let active = if !current.open {
            let selected = select_find_value(options, current.value)
            if selected >= 0 {
              selected
            } else {
              select_first_enabled(options, direction < 0)
            }
          } else {
            select_next_enabled(options, current.active, direction)
          }
          let open = true
          let next = { ..current, open, active }
          (
            next,
            @cmd.batch([
              if active >= 0 && active < options.length() {
                select_popup_cmd(
                  id,
                  Some(true),
                  Some("select-item"),
                  options[active].value,
                )
              } else {
                select_popup_cmd(id, Some(true), None, "")
              },
              if current.open {
                @cmd.none
              } else {
                select_notify_bool(on_open_change, true)
              },
            ]),
          )
        }
        SelectHighlight(index) =>
          if !current.open ||
            index < 0 ||
            index >= options.length() ||
            options[index].disabled {
            (current, @cmd.none)
          } else if current.active == index {
            (current, @cmd.none)
          } else {
            ({ ..current, active: index }, @cmd.none)
          }
        SelectFirst => {
          let active = select_first_enabled(options, false)
          let opened = !current.open
          (
            { ..current, open: true, active },
            @cmd.batch([
              if active >= 0 && active < options.length() {
                select_popup_cmd(
                  id,
                  Some(true),
                  Some("select-item"),
                  options[active].value,
                )
              } else {
                select_popup_cmd(id, Some(true), None, "")
              },
              if opened {
                select_notify_bool(on_open_change, true)
              } else {
                @cmd.none
              },
            ]),
          )
        }
        SelectLast => {
          let active = select_first_enabled(options, true)
          let opened = !current.open
          (
            { ..current, open: true, active },
            @cmd.batch([
              if active >= 0 && active < options.length() {
                select_popup_cmd(
                  id,
                  Some(true),
                  Some("select-item"),
                  options[active].value,
                )
              } else {
                select_popup_cmd(id, Some(true), None, "")
              },
              if opened {
                select_notify_bool(on_open_change, true)
              } else {
                @cmd.none
              },
            ]),
          )
        }
        SelectChoose(requested) => {
          let index = if requested < 0 { current.active } else { requested }
          if index < 0 || index >= options.length() || options[index].disabled {
            (current, @cmd.none)
          } else {
            let option = options[index]
            let changed = current.value != Some(option.value)
            (
              {
                ..current,
                open: false,
                value: Some(option.value),
                active: index,
              },
              @cmd.batch([
                select_popup_cmd(id, Some(false), Some("select-trigger"), ""),
                select_notify_bool(on_open_change, false),
                if changed {
                  select_notify_value(on_value_change, option.value)
                } else {
                  @cmd.none
                },
              ]),
            )
          }
        }
        SelectClose =>
          if current.open {
            (
              { ..current, open: false },
              @cmd.batch([
                select_popup_cmd(id, Some(false), Some("select-trigger"), ""),
                select_notify_bool(on_open_change, false),
              ]),
            )
          } else {
            (current, @cmd.none)
          }
        SelectDismiss =>
          if current.open {
            (
              { ..current, open: false },
              @cmd.batch([
                select_popup_cmd(id, Some(false), None, ""),
                select_notify_bool(on_open_change, false),
              ]),
            )
          } else {
            (current, @cmd.none)
          }
        SelectTypeahead(key) => {
          let search = select_typeahead_search(current.search, key)
          let search_start = if current.open {
            current.active
          } else {
            select_find_value(options, current.value)
          }
          let matched = select_typeahead_index(options, search_start, search)
          let active = if matched >= 0 { matched } else { current.active }
          let generation = current.search_generation + 1
          if current.open {
            (
              { ..current, active, search, search_generation: generation },
              @cmd.batch([
                if matched >= 0 {
                  select_popup_cmd(
                    id,
                    Some(true),
                    Some("select-item"),
                    options[matched].value,
                  )
                } else {
                  @cmd.none
                },
                @cmd.delay(emit(SelectClearTypeahead(generation)), 700),
              ]),
            )
          } else if matched >= 0 {
            let option = options[matched]
            let changed = current.value != Some(option.value)
            (
              {
                ..current,
                value: Some(option.value),
                active: matched,
                search,
                search_generation: generation,
              },
              @cmd.batch([
                if changed {
                  select_notify_value(on_value_change, option.value)
                } else {
                  @cmd.none
                },
                @cmd.delay(emit(SelectClearTypeahead(generation)), 700),
              ]),
            )
          } else {
            (
              { ..current, search, search_generation: generation },
              @cmd.delay(emit(SelectClearTypeahead(generation)), 700),
            )
          }
        }
        SelectClearTypeahead(generation) =>
          if generation == current.search_generation {
            ({ ..current, search: "" }, @cmd.none)
          } else {
            (current, @cmd.none)
          }
      }
    },
  )
  model.view(model => {
    let scope : SelectScope = {
      id,
      options,
      model,
      placeholder,
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
      trigger_id: Ref("\{id}-trigger"),
    }
    select_render(scope, class, title, attrs, style, render)
  })
}

///|
#cfg(not(target="js"))
pub fn select(
  id~ : String,
  options~ : Array[SelectOption],
  default_value? : String,
  default_open? : Bool = false,
  placeholder? : String = "Select an option",
  disabled? : Bool = false,
  invalid? : Bool = false,
  required? : Bool = false,
  name? : String,
  side? : PopupSide = Bottom,
  align? : PopupAlign = Start,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  on_value_change? : @cmd.Emit[String],
  on_open_change? : @cmd.Emit[Bool],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  render? : (SelectScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  ignore((on_value_change, on_open_change))
  let selected = select_find_value(options, default_value)
  let model : SelectModel = {
    open: default_open && !disabled,
    value: if selected >= 0 {
      Some(options[selected].value)
    } else {
      None
    },
    active: if selected >= 0 {
      selected
    } else {
      select_first_enabled(options, false)
    },
    search: "",
    search_generation: 0,
  }
  let scope : SelectScope = {
    id,
    options,
    model,
    placeholder,
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
    trigger_id: Ref("\{id}-trigger"),
  }
  @rabbita.Val::constant(
    select_render(scope, class, title, attrs, style, render),
  )
}
