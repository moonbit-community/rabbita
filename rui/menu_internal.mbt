///|
struct MenuCoreModel {
  open : Bool
  active : Int
  checked : Array[String]
  radios : Array[(String, String)]
  submenus : Array[String]
} derive(Eq)

///|
enum MenuSubmenuChange {
  MenuOpenSubmenu(String)
  MenuSwitchSubmenu(String, String)
  MenuCloseSubmenu(String)
  MenuCloseSubmenusUnder(String)
  MenuCloseAllSubmenus
} derive(Eq)

///|
priv struct MenuScope {
  id : String
  content_id : String
  trigger_id : String
  model : MenuCoreModel
  counter : Ref[Int]
  close_command : @cmd.Cmd
  toggle_command : @cmd.Cmd
  toggle_checked : @cmd.Emit[String]
  set_radio : @cmd.Emit[(String, String)]
}

///|
enum MenuIndicatorPlacement {
  MenuIndicatorInlineStart
  MenuIndicatorInlineEnd
} derive(Eq)

///|
const MenuRootStyle : String = "display:contents"

///|
const MenuContentStyle : String = "position:fixed;inset:auto;left:var(--rui-floating-left,auto);top:var(--rui-floating-top,auto);z-index:50;display:flex;width:max-content;min-width:min(var(--rui-menu-min-width,12rem),calc(100vw - 1rem));max-width:calc(100vw - 1rem);max-height:var(--rui-menu-available-height,calc(100vh - 1rem));transform-origin:var(--rui-floating-transform-origin,center);flex-direction:column;gap:0.125rem;overflow-x:hidden;overflow-y:auto;margin:0;border:1px solid color-mix(in oklab,var(--rui-foreground,oklch(0.145 0 0)) 10%,transparent);border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-popover,oklch(1 0 0));padding:0.25rem;color:var(--rui-popover-foreground,oklch(0.145 0 0));font-size:0.875rem;line-height:1.25rem;box-shadow:0 10px 15px -3px rgb(0 0 0 / 0.1),0 4px 6px -4px rgb(0 0 0 / 0.1);outline:none;transition:opacity 100ms ease,transform 100ms ease,visibility 100ms ease"

///|
const MenuSubContentStyle : String = "position:fixed;inset:auto;left:var(--rui-submenu-left,auto);top:var(--rui-submenu-top,auto);z-index:51;display:flex;width:max-content;min-width:min(var(--rui-menu-min-width,12rem),calc(100vw - 1rem));max-width:min(18rem,calc(100vw - 1rem));max-height:calc(100vh - 1rem);transform-origin:var(--rui-floating-transform-origin,0% 0%);flex-direction:column;gap:0.125rem;overflow-x:hidden;overflow-y:auto;border:1px solid color-mix(in oklab,var(--rui-foreground,oklch(0.145 0 0)) 10%,transparent);border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-popover,oklch(1 0 0));padding:0.25rem;color:var(--rui-popover-foreground,oklch(0.145 0 0));box-shadow:0 10px 15px -3px rgb(0 0 0 / 0.1),0 4px 6px -4px rgb(0 0 0 / 0.1);outline:none;transition:opacity 100ms ease,transform 100ms ease,visibility 100ms ease"

///|
const MenuItemStyle : String = "position:relative;display:flex;width:100%;min-height:2rem;cursor:default;align-items:center;gap:0.5rem;border:0;border-radius:calc(var(--rui-radius,0.625rem) - 0.25rem);background:var(--rui-menu-item-bg,var(--rui-menu-item-base-bg,transparent));padding:0.375rem 0.5rem;color:var(--rui-menu-item-fg,var(--rui-menu-item-base-fg,inherit));font:inherit;line-height:1.25rem;text-align:start;white-space:nowrap;outline:none;user-select:none"

///|
const MenuItemInsetStyle : String = "padding-inline-start:2rem"

///|
const MenuItemDestructiveStyle : String = "--rui-menu-item-base-fg:var(--rui-destructive,oklch(0.577 0.245 27.325))"

///|
const MenuItemHighlightedStyle : String = "--rui-menu-item-base-bg:var(--rui-accent,oklch(0.97 0 0));--rui-menu-item-base-fg:var(--rui-accent-foreground,oklch(0.205 0 0))"

///|
const MenuLabelStyle : String = "padding:0.375rem 0.5rem;font-size:0.75rem;line-height:1rem;font-weight:500;color:var(--rui-muted-foreground,oklch(0.556 0 0))"

///|
const MenuSeparatorStyle : String = "height:1px;margin:0.25rem -0.25rem;background:var(--rui-border,oklch(0.922 0 0));pointer-events:none"

///|
const MenuShortcutStyle : String = "margin-inline-start:auto;flex:none;padding-inline-start:1.5rem;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.75rem;line-height:1rem;letter-spacing:0.08em"

///|
const MenuItemEndIndicatorStyle : String = "padding-inline-end:2rem"

///|
const MenuIndicatorStartStyle : String = "display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;font-size:0.75rem;line-height:1"

///|
const MenuIndicatorEndStyle : String = "position:absolute;inset-inline-end:0.5rem;display:inline-flex;width:1rem;height:1rem;align-items:center;justify-content:center;font-size:0.75rem;line-height:1;pointer-events:none"

///|
fn menu_core_model(
  open : Bool,
  checked : Array[String],
  radios : Array[(String, String)],
) -> MenuCoreModel {
  { open, active: -1, checked, radios, submenus: [], }
}

///|
fn menu_contains(values : Array[String], value : String) -> Bool {
  for current in values {
    if current == value {
      return true
    }
  }
  false
}

///|
fn menu_toggle_value(values : Array[String], value : String) -> Array[String] {
  let next : Array[String] = []
  let mut found = false
  for current in values {
    if current == value {
      found = true
    } else {
      next.push(current)
    }
  }
  if !found {
    next.push(value)
  }
  next
}

///|
fn menu_submenu_open(values : Array[String], value : String) -> Bool {
  menu_contains(values, value)
}

///|
fn menu_update_submenus(
  values : Array[String],
  change : MenuSubmenuChange,
) -> Array[String] {
  match change {
    MenuOpenSubmenu(value) =>
      if menu_contains(values, value) {
        values
      } else {
        let next = values.copy()
        next.push(value)
        next
      }
    MenuSwitchSubmenu(parent, value) =>
      if parent == "" {
        if values == [value] {
          values
        } else {
          [value]
        }
      } else {
        let next : Array[String] = []
        for current in values {
          next.push(current)
          if current == parent {
            next.push(value)
            return if next == values { values } else { next }
          }
        }
        values
      }
    MenuCloseSubmenu(value) => {
      let next : Array[String] = []
      for current in values {
        if current == value {
          return next
        }
        next.push(current)
      }
      values
    }
    MenuCloseSubmenusUnder(parent) =>
      if parent == "" {
        []
      } else {
        let next : Array[String] = []
        for current in values {
          next.push(current)
          if current == parent {
            return if next == values { values } else { next }
          }
        }
        values
      }
    MenuCloseAllSubmenus => []
  }
}

///|
fn menu_submenu_key(scope : MenuScope, value : String) -> String {
  scope.id + "::" + value + "::submenu-\{scope.counter.val}"
}

///|
fn menu_submenu_anchor_style(key : String) -> String {
  "position-anchor:\{popup_anchor_name(key)};position-area:inline-end span-block-end;position-try-fallbacks:flip-inline,flip-block,flip-inline flip-block;position-visibility:always;margin-inline-start:0.25rem;--rui-floating-transform-origin:0% 0%"
}

///|
fn menu_submenu_trigger_id(key : String) -> String {
  popup_anchor_name(key) + "-trigger"
}

///|
fn menu_submenu_content_id(key : String) -> String {
  popup_anchor_name(key) + "-content"
}

///|
fn menu_radio_value(
  radios : Array[(String, String)],
  group : String,
) -> String? {
  for entry in radios {
    if entry.0 == group {
      return Some(entry.1)
    }
  }
  None
}

///|
fn menu_set_radio_value(
  radios : Array[(String, String)],
  group : String,
  value : String,
) -> Array[(String, String)] {
  let next : Array[(String, String)] = []
  let mut replaced = false
  for entry in radios {
    if entry.0 == group {
      if !replaced {
        next.push((group, value))
        replaced = true
      }
    } else {
      next.push(entry)
    }
  }
  if !replaced {
    next.push((group, value))
  }
  next
}

///|
fn menu_scope_next_index(scope : MenuScope) -> Int {
  let index = scope.counter.val
  scope.counter.val += 1
  index
}

///|
#cfg(not(target="js"))
fn[A] menu_noop_emit() -> @cmd.Emit[A] {
  @cmd.Emit(_ => @cmd.none)
}

///|
fn menu_state_attrs(
  attrs : @html.Attrs?,
  slot : String,
  open : Bool,
) -> @html.Attrs {
  popup_state_attrs(attrs, slot, open)
}

///|
#cfg(target="js")
priv struct MenuSurfaceBinding {
  id : String
  root : @dom.Element
  dispatch : Ref[(Int, Int, String, String) -> Unit]
  typeahead : Ref[String]
  typeahead_at : Ref[Double]
  typeahead_timer : Ref[Int]
}

///|
#cfg(target="js")
let menu_surface_bindings : Map[String, MenuSurfaceBinding] = Map([])

///|
#cfg(target="js")
let menu_pending_edges : Map[String, String] = Map([])

///|
#cfg(target="js")
fn menu_request_frame(callback : () -> Unit) -> Unit {
  ui_after_request_frame(callback)
}

///|
#cfg(target="js")
fn menu_element_is_visible(element : @dom.Element) -> Bool {
  if !ui_element_is_enabled(element) ||
    element.closest("[hidden]") is Some(_) ||
    element.closest("[inert]") is Some(_) ||
    element.closest("[aria-hidden=\"true\"]") is Some(_) ||
    element.get_client_rects().length() == 0 {
    return false
  }
  if ui_has_window() {
    let style = @dom.window().get_computed_style(element)
    style.get_property_value("display") != "none" &&
    style.get_property_value("visibility") != "hidden"
  } else {
    true
  }
}

///|
#cfg(target="js")
fn menu_enabled_items(
  binding : MenuSurfaceBinding,
  container : @dom.Element?,
) -> Array[@dom.Element] {
  let scope = container.unwrap_or(binding.root)
  scope
  .query_selector_all("[data-menu-index]")
  .iter()
  .filter(item => {
    if !menu_element_is_visible(item) {
      false
    } else if container is Some(container) {
      item.closest("[role=\"menu\"]") is Some(owner) &&
      owner.is_same_node(container.as_node())
    } else {
      true
    }
  })
  .collect()
}

///|
#cfg(target="js")
fn menu_send_active(binding : MenuSurfaceBinding, item : @dom.Element?) -> Unit {
  if item is Some(item) && ui_element_is_enabled(item) {
    let index = ui_parse_int_or(
      item.get_attribute("data-menu-index").unwrap_or(""),
      -1,
    )
    if index >= 0 {
      (binding.dispatch.val)(0, index, "", "")
    }
  }
}

///|
#cfg(target="js")
fn menu_submenu_parent(item : @dom.Element) -> String {
  if item.closest("[role=\"menu\"]") is Some(owner) {
    owner.get_attribute("data-submenu-owner").unwrap_or("")
  } else {
    ""
  }
}

///|
#cfg(target="js")
fn menu_focus_submenu_trigger(
  binding : MenuSurfaceBinding,
  key : String,
) -> Unit {
  menu_request_frame(() => {
    let target = ui_find_node_list_element(
      binding.root.query_selector_all("[data-menu-index][data-submenu-key]"),
      node => {
        node.get_attribute("data-submenu-key").unwrap_or("") == key &&
        menu_element_is_visible(node)
      },
    )
    if target is Some(target) {
      ui_focus_element(target)
      menu_send_active(binding, Some(target))
    }
  })
}

///|
#cfg(target="js")
fn menu_focus_submenu_first(
  binding : MenuSurfaceBinding,
  key : String,
  attempt : Int,
) -> Unit {
  menu_request_frame(() => {
    let owner = ui_find_node_list_element(
      binding.root.query_selector_all("[data-submenu-owner]"),
      node => {
        node.get_attribute("data-submenu-owner").unwrap_or("") == key &&
        menu_element_is_visible(node)
      },
    )
    if owner is Some(owner) {
      if menu_enabled_items(binding, Some(owner)).get(0) is Some(target) {
        ui_focus_element(target)
        menu_send_active(binding, Some(target))
      } else if attempt < 20 {
        menu_focus_submenu_first(binding, key, attempt + 1)
      }
    } else if attempt < 20 {
      menu_focus_submenu_first(binding, key, attempt + 1)
    }
  })
}

///|
#cfg(target="js")
fn menu_switch_submenu(
  binding : MenuSurfaceBinding,
  item : @dom.Element?,
  focus_first : Bool,
) -> Bool {
  guard item is Some(item) else { return false }
  let key = item.get_attribute("data-submenu-key").unwrap_or("")
  if key == "" || !ui_element_is_enabled(item) {
    return false
  }
  let index = ui_parse_int_or(
    item.get_attribute("data-menu-index").unwrap_or(""),
    -1,
  )
  (binding.dispatch.val)(4, index, key, menu_submenu_parent(item))
  if focus_first {
    menu_focus_submenu_first(binding, key, 0)
  }
  true
}

///|
#cfg(target="js")
fn menu_focus_dropdown_edge(
  binding : MenuSurfaceBinding,
  content_id : String,
  edge : String,
  attempt : Int,
) -> Unit {
  menu_request_frame(() => {
    guard ui_element_by_id(binding.id) is Some(live_root) else { return }
    let content = ui_element_by_id(content_id)
    let items = menu_enabled_items(binding, content)
    if live_root.get_attribute("data-state").unwrap_or("") != "open" ||
      items.length() == 0 {
      if attempt < 20 {
        menu_focus_dropdown_edge(binding, content_id, edge, attempt + 1)
      }
      return
    }
    let requested_edge = menu_pending_edges.get(binding.id).unwrap_or(edge)
    let target = if requested_edge == "last" {
      items.get(items.length() - 1)
    } else {
      items.get(0)
    }
    if target is Some(target) {
      ui_focus_element(target)
      menu_send_active(binding, Some(target))
      if ui_has_window() {
        ignore(
          @dom.window().set_timeout(
            () => {
              if menu_pending_edges.get(binding.id) == Some(edge) {
                menu_pending_edges.remove(binding.id)
              }
            },
            250,
          ),
        )
      }
    }
  })
}

///|
#cfg(target="js")
fn menu_typeahead_query(buffer : String) -> String {
  guard buffer.get_char(0) is Some(first) else { return "" }
  let mut repeated = true
  for character in buffer {
    if character != first {
      repeated = false
    }
  }
  if repeated {
    "\{first}"
  } else {
    buffer
  }
}

///|
#cfg(target="js")
fn menu_typeahead_label(item : @dom.Element) -> String {
  let labelled = item.get_attribute("data-menu-label").unwrap_or("")
  if labelled != "" {
    labelled
  } else {
    item.get_property("textContent").to_option().unwrap_or("")
  }
}

///|
#cfg(target="js")
fn menu_handle_keydown(
  binding : MenuSurfaceBinding,
  event : @dom.KeyboardEvent,
) -> Unit {
  if event.get_default_prevented() {
    return
  }
  guard event.target().to_element() is Some(event_target) else { return }
  let key = event.key()
  let dropdown_trigger = event_target.closest(
    "[data-slot=\"dropdown-menu-trigger\"]",
  )
  if dropdown_trigger is Some(dropdown_trigger) &&
    (key == "ArrowDown" || key == "ArrowUp") {
    event.prevent_default()
    let edge = if key == "ArrowUp" { "last" } else { "first" }
    let content_id = dropdown_trigger
      .get_attribute("aria-controls")
      .unwrap_or("")
    menu_pending_edges[binding.id] = edge
    if ui_has_window() {
      ignore(
        @dom.window().set_timeout(
          () => {
            if menu_pending_edges.get(binding.id) == Some(edge) {
              menu_pending_edges.remove(binding.id)
            }
          },
          1000,
        ),
      )
    }
    if binding.root.get_attribute("data-state").unwrap_or("") != "open" {
      ui_click_element(dropdown_trigger)
    }
    menu_focus_dropdown_edge(binding, content_id, edge, 0)
    return
  }
  let current = event_target.closest("[data-menu-index]")
  let container = if current is Some(current) {
    current.closest("[role=\"menu\"]").unwrap_or(binding.root)
  } else {
    binding.root
  }
  let items = menu_enabled_items(binding, Some(container))
  let active_submenu = event_target.closest("[data-submenu-owner]")
  let rtl = ui_element_is_rtl(container)
  let open_submenu_key = if rtl { "ArrowLeft" } else { "ArrowRight" }
  let close_submenu_key = if rtl { "ArrowRight" } else { "ArrowLeft" }
  if key == "Escape" && active_submenu is Some(active_submenu) {
    event.prevent_default()
    event.stop_propagation()
    let submenu_key = active_submenu
      .get_attribute("data-submenu-owner")
      .unwrap_or("")
    (binding.dispatch.val)(3, -1, submenu_key, "")
    menu_focus_submenu_trigger(binding, submenu_key)
    return
  }
  if key == "Escape" {
    event.prevent_default()
    (binding.dispatch.val)(1, -1, "", "")
    return
  }
  if items.length() == 0 {
    return
  }
  let mut position = -1
  if current is Some(current) {
    for item_index, item in items {
      if item.is_same_node(current.as_node()) {
        position = item_index
      }
    }
  }
  let mut target : @dom.Element? = None
  if key == "ArrowDown" {
    target = items.get(
      if position < 0 {
        0
      } else {
        (position + 1) % items.length()
      },
    )
  } else if key == "ArrowUp" {
    target = items.get(
      if position < 0 {
        items.length() - 1
      } else if position == 0 {
        items.length() - 1
      } else {
        position - 1
      },
    )
  } else if key == "Home" {
    target = items.get(0)
  } else if key == "End" {
    target = items.get(items.length() - 1)
  }
  if current is Some(current) &&
    current.get_attribute("data-submenu-key").unwrap_or("") != "" &&
    (key == open_submenu_key || key == "Enter" || key == " ") {
    event.prevent_default()
    ignore(menu_switch_submenu(binding, Some(current), true))
    return
  }
  if key == close_submenu_key && active_submenu is Some(active_submenu) {
    event.prevent_default()
    event.stop_propagation()
    let submenu_key = active_submenu
      .get_attribute("data-submenu-owner")
      .unwrap_or("")
    (binding.dispatch.val)(3, -1, submenu_key, "")
    menu_focus_submenu_trigger(binding, submenu_key)
    return
  }
  if target is None &&
    key.char_length_eq(1) &&
    !event.meta_key() &&
    !event.ctrl_key() &&
    !event.alt_key() {
    if key == " " && binding.typeahead.val == "" {
      return
    }
    let now = event.get_time_stamp()
    if binding.typeahead_at.val <= 0.0 ||
      now - binding.typeahead_at.val > 1000.0 {
      binding.typeahead.val = ""
    }
    binding.typeahead_at.val = now
    binding.typeahead.val = binding.typeahead.val + key.to_lower()
    if ui_has_window() {
      if binding.typeahead_timer.val != 0 {
        @dom.window().clear_timeout(binding.typeahead_timer.val)
      }
      binding.typeahead_timer.val = @dom.window().set_timeout(
        () => {
          binding.typeahead.val = ""
          binding.typeahead_at.val = 0.0
          binding.typeahead_timer.val = 0
        },
        1000,
      )
    }
    let query = menu_typeahead_query(binding.typeahead.val)
    let ordered : Array[@dom.Element] = []
    if position < 0 {
      for item in items {
        ordered.push(item)
      }
    } else {
      for offset in 1..<=items.length() {
        if items.get((position + offset) % items.length()) is Some(item) {
          ordered.push(item)
        }
      }
    }
    target = ui_find_element(ordered, item => {
      menu_typeahead_label(item).trim().to_owned().to_lower().has_prefix(query)
    })
    event.prevent_default()
  }
  if target is Some(target) {
    event.prevent_default()
    ui_focus_element(target)
    menu_send_active(binding, Some(target))
  }
}

///|
#cfg(target="js")
fn bind_menu_surface(
  id : String,
  dispatch : (Int, Int, String, String) -> Unit,
) -> Unit {
  guard ui_element_by_id(id) is Some(root) else { return }
  if menu_surface_bindings.get(id) is Some(existing) &&
    existing.root.is_same_node(root.as_node()) {
    existing.dispatch.val = dispatch
    return
  }
  let binding : MenuSurfaceBinding = {
    id,
    root,
    dispatch: Ref(dispatch),
    typeahead: Ref(""),
    typeahead_at: Ref(0.0),
    typeahead_timer: Ref(0),
  }
  menu_surface_bindings[id] = binding
  root.add_event_listener("focusin", event => {
    if event.target().to_element() is Some(target) {
      menu_send_active(binding, target.closest("[data-menu-index]"))
    }
  })
  root.add_event_listener("pointermove", event => {
    guard event.target().to_element() is Some(target) else { return }
    let item = target.closest("[data-menu-index]")
    menu_send_active(binding, item)
    if item is Some(item) {
      if item.get_attribute("data-submenu-key").unwrap_or("") != "" &&
        ui_element_is_enabled(item) {
        ignore(menu_switch_submenu(binding, Some(item), false))
      } else {
        (binding.dispatch.val)(
          5,
          ui_parse_int_or(
            item.get_attribute("data-menu-index").unwrap_or(""),
            -1,
          ),
          "",
          menu_submenu_parent(item),
        )
      }
    }
  })
  root.add_event_listener_with_options(
    "click",
    event => {
      if event.target().to_element() is Some(target) {
        ignore(
          menu_switch_submenu(
            binding,
            target.closest("[data-menu-index][data-submenu-key]"),
            false,
          ),
        )
      }
    },
    capture=true,
  )
  root.add_event_listener("keydown", event => {
    if event.to_keyboard_event() is Some(keyboard_event) {
      menu_handle_keydown(binding, keyboard_event)
    }
  })
}

///|
#cfg(target="js")
priv struct MenuFocusStability {
  item : @dom.Element?
  frames : Int
}

///|
#cfg(target="js")
let menu_focus_stability : Map[String, MenuFocusStability] = Map([])

///|
#cfg(target="js")
fn menu_resolve_focus_item(
  id : String,
  content_id : String,
  index : Int,
) -> @dom.Element? {
  guard ui_element_by_id(id) is Some(root) else { return None }
  let content = if content_id == "" {
    None
  } else {
    ui_element_by_id(content_id)
  }
  if content_id != "" && content is None {
    return None
  }
  let scope = content.unwrap_or(root)
  let candidates = scope
    .query_selector_all("[data-menu-index=\"\{index}\"]")
    .iter()
    .filter(menu_element_is_visible)
    .collect()
  if content is Some(content) {
    ui_find_element(candidates, item => {
      if item.closest("[role=\"menu\"]") is Some(owner) {
        owner.is_same_node(content.as_node()) ||
        content.contains(owner.as_node())
      } else {
        false
      }
    })
  } else {
    let open_item = ui_find_element(candidates, item => {
      if item.closest("[role=\"menu\"]") is Some(owner) {
        owner.get_attribute("data-state").unwrap_or("") == "open"
      } else {
        false
      }
    })
    if open_item is Some(_) {
      open_item
    } else {
      candidates.get(0)
    }
  }
}

///|
#cfg(target="js")
fn focus_menu_item(id : String, content_id : String, index : Int) -> Bool {
  let stability_key = id + ":" + content_id + ":\{index}"
  guard menu_resolve_focus_item(id, content_id, index) is Some(item) &&
    item.get_is_connected() else {
    menu_focus_stability.remove(stability_key)
    return false
  }
  let document = @dom.document()
  if document.get_active_element() is None ||
    !document.get_active_element().unwrap().is_same_node(item.as_node()) {
    ui_focus_element_without_scroll(item)
  }
  let live_item = menu_resolve_focus_item(id, content_id, index)
  let stable = live_item is Some(live_item) &&
    live_item.is_same_node(item.as_node()) &&
    item.get_is_connected() &&
    document.get_active_element() is Some(active) &&
    active.is_same_node(item.as_node())
  if !stable {
    menu_focus_stability[stability_key] = { item: live_item, frames: 0, }
    return false
  }
  let frames = if menu_focus_stability.get(stability_key) is Some(previous) &&
    previous.item is Some(previous_item) &&
    previous_item.is_same_node(item.as_node()) {
    previous.frames + 1
  } else {
    1
  }
  if frames < 3 {
    menu_focus_stability[stability_key] = { item: Some(item), frames, }
    false
  } else {
    menu_focus_stability.remove(stability_key)
    true
  }
}

///|
#cfg(target="js")
fn focus_first_menu_item(id : String, found : (Int) -> Unit) -> Unit {
  fn focus_when_visible(attempt : Int) -> Unit {
    guard ui_element_by_id(id) is Some(root) else { return }
    let binding = if menu_surface_bindings.get(id) is Some(binding) &&
      binding.root.is_same_node(root.as_node()) {
      binding
    } else {
      {
        id,
        root,
        dispatch: Ref((_, _, _, _) => ()),
        typeahead: Ref(""),
        typeahead_at: Ref(0.0),
        typeahead_timer: Ref(0),
      }
    }
    let items = menu_enabled_items(binding, None)
    if root.get_attribute("data-state").unwrap_or("") == "open" &&
      items.length() > 0 {
      let item = if menu_pending_edges.get(id) == Some("last") {
        items.get(items.length() - 1)
      } else {
        items.get(0)
      }
      menu_pending_edges.remove(id)
      if item is Some(item) {
        let index = ui_parse_int_or(
          item.get_attribute("data-menu-index").unwrap_or(""),
          -1,
        )
        ui_focus_element(item)
        if index >= 0 {
          found(index)
        }
      }
    } else if attempt < 20 {
      menu_request_frame(() => focus_when_visible(attempt + 1))
    }
  }

  menu_request_frame(() => focus_when_visible(0))
}

///|
#cfg(target="js")
fn find_open_menu_content(
  id : String,
  slot : String,
  found : (String, Int) -> Unit,
) -> Unit {
  guard ui_element_by_id(id) is Some(root) else { return }
  guard ui_find_descendant(root, element => {
      element.get_attribute("data-slot").unwrap_or("") == slot &&
      element.get_attribute("data-state").unwrap_or("") == "open"
    })
    is Some(content) else {
    return
  }
  let content_id = content.get_attribute("id").unwrap_or("")
  if content_id == "" {
    return
  }
  let menubar_index = content.get_attribute("data-menubar-index").unwrap_or("")
  let navigation_index = content
    .get_attribute("data-navigation-index")
    .unwrap_or("")
  let index = if menubar_index != "" {
    ui_parse_int_or(menubar_index, -1)
  } else {
    ui_parse_int_or(navigation_index, -1)
  }
  found(content_id, index)
}

///|
#cfg(target="js")
let menu_submenu_roots : Map[String, @dom.Element] = Map([])

///|
#cfg(target="js")
let menu_submenu_events_bound : Ref[Bool] = Ref(false)

///|
#cfg(target="js")
let menu_submenu_frame : Ref[Double] = Ref(0.0)

///|
#cfg(target="js")
fn menu_position_submenu_root(root : @dom.Element) -> Unit {
  if !root.get_is_connected() {
    return
  }
  let position_area = "inline-end span-block-end"
  let css_anchored = @dom.CSS::supports("anchor-name", "--rui-anchor") &&
    @dom.CSS::supports("position-anchor", "--rui-anchor") &&
    @dom.CSS::supports("position-area", position_area) &&
    @dom.CSS::supports("position-try-fallbacks", "flip-inline")
  let triggers = root.query_selector_all("[data-menu-index][data-submenu-key]")
  for content in root.query_selector_all("[data-submenu-owner]") {
    let key = content.get_attribute("data-submenu-owner").unwrap_or("")
    let requested_open = content.get_attribute("data-state").unwrap_or("") ==
      "open"
    // The browser owns the top-layer state. A parent popover can implicitly
    // close a submenu without a Rabbita render, so a cached open bit must not
    // override the actual :popover-open state on a later reopen.
    let native_open = content.matches(":popover-open")
    if !requested_open && !native_open {
      content.set_attribute("data-positioned", "false")
      continue
    }
    let trigger = ui_find_node_list_element(triggers, item => {
      item.get_attribute("data-submenu-key").unwrap_or("") == key
    })
    if trigger is None || !trigger.unwrap().get_is_connected() {
      if native_open && content.to_html_element() is Some(html) {
        html.hide_popover()
      }
      content.set_attribute("data-positioned", "false")
      continue
    }
    let trigger = trigger.unwrap()
    guard content.to_html_element() is Some(content_html) else { continue }
    let style = content_html.get_style()
    if css_anchored {
      ignore(style.remove_property("--rui-submenu-left"))
      ignore(style.remove_property("--rui-submenu-top"))
      ignore(style.remove_property("margin"))
      content.set_attribute("data-positioning", "css-anchor")
      content.set_attribute("data-positioned", "true")
    } else {
      let anchor = trigger.get_bounding_client_rect()
      let measured = content.get_bounding_client_rect()
      let measured_width = content_html.get_offset_width()
      let measured_height = content_html.get_offset_height()
      let floating_width = if measured_width > 0.0 {
        measured_width
      } else {
        measured.get_width()
      }
      let floating_height = if measured_height > 0.0 {
        measured_height
      } else {
        measured.get_height()
      }
      let viewport = if ui_has_window() {
        @dom.window().get_visual_viewport()
      } else {
        None
      }
      let viewport_left = viewport
        .map(viewport => viewport.get_offset_left())
        .unwrap_or(0.0)
      let viewport_top = viewport
        .map(viewport => viewport.get_offset_top())
        .unwrap_or(0.0)
      let document_root = @dom.document().get_document_element()
      let viewport_width = viewport
        .map(viewport => viewport.get_width())
        .unwrap_or_else(() => {
          document_root.map(root => root.get_client_width()).unwrap_or(0.0)
        })
      let viewport_height = viewport
        .map(viewport => viewport.get_height())
        .unwrap_or_else(() => {
          document_root.map(root => root.get_client_height()).unwrap_or(0.0)
        })
      let clip_left = viewport_left + 8.0
      let clip_top = viewport_top + 8.0
      let clip_right = viewport_left + viewport_width - 8.0
      let clip_bottom = viewport_top + viewport_height - 8.0
      let rtl = ui_element_is_rtl(trigger)
      let inline_end_side = if rtl { "left" } else { "right" }
      let inline_end_left = if rtl {
        anchor.get_left() - floating_width - 4.0
      } else {
        anchor.get_right() + 4.0
      }
      let inline_start_side = if rtl { "right" } else { "left" }
      let inline_start_left = if rtl {
        anchor.get_right() + 4.0
      } else {
        anchor.get_left() - floating_width - 4.0
      }
      fn overflow(left : Double) -> Double {
        (clip_left - left).max(0.0) +
        (left + floating_width - clip_right).max(0.0)
      }

      let use_inline_end = overflow(inline_end_left) <= 0.0 ||
        overflow(inline_end_left) <= overflow(inline_start_left)
      let placed_side = if use_inline_end {
        inline_end_side
      } else {
        inline_start_side
      }
      let placed_left = if use_inline_end {
        inline_end_left
      } else {
        inline_start_left
      }
      let left = placed_left
        .max(clip_left)
        .min((clip_right - floating_width).max(clip_left))
      let top = anchor
        .get_top()
        .max(clip_top)
        .min((clip_bottom - floating_height).max(clip_top))
      style.set_property("margin", "0")
      style.set_property("--rui-submenu-left", "\{left.round().to_int()}px")
      style.set_property("--rui-submenu-top", "\{top.round().to_int()}px")
      style.set_property(
        "--rui-floating-transform-origin",
        if placed_side == "right" {
          "0% 0%"
        } else {
          "100% 0%"
        },
      )
      content.set_attribute("data-side", placed_side)
      content.set_attribute("data-positioning", "javascript-fallback")
      content.set_attribute("data-positioned", "true")
    }
    // Coordinates are established before the top-layer state changes so no
    // frame can expose the submenu at an unpositioned fixed origin.
    if requested_open && !native_open {
      content_html.show_popover()
      if !content.matches(":popover-open") {
        content.set_attribute("data-positioned", "false")
      }
    } else if !requested_open && native_open {
      content_html.hide_popover()
    }
    if !requested_open {
      content.set_attribute("data-positioned", "false")
    }
  }
}

///|
#cfg(target="js")
fn menu_run_submenu_positions() -> Unit {
  menu_submenu_frame.val = 0.0
  let stale : Array[String] = []
  for id, registered_root in menu_submenu_roots {
    if ui_element_by_id(id) is Some(root) &&
      root.is_same_node(registered_root.as_node()) &&
      root.get_is_connected() {
      menu_position_submenu_root(root)
    } else {
      stale.push(id)
    }
  }
  for id in stale {
    menu_submenu_roots.remove(id)
  }
}

///|
#cfg(target="js")
fn menu_schedule_submenu_positions() -> Unit {
  if menu_submenu_frame.val != 0.0 {
    return
  }
  if ui_has_window() {
    menu_submenu_frame.val = @dom.window().request_animation_frame(_ => {
      menu_run_submenu_positions()
    })
  } else {
    menu_run_submenu_positions()
  }
}

///|
#cfg(target="js")
fn menu_bind_submenu_position_events() -> Unit {
  if menu_submenu_events_bound.val || !ui_has_window() {
    return
  }
  menu_submenu_events_bound.val = true
  let window = @dom.window()
  window.add_event_listener_with_options(
    "scroll",
    _ => menu_schedule_submenu_positions(),
    capture=true,
    passive=true,
  )
  window.add_event_listener_with_options(
    "resize",
    _ => menu_schedule_submenu_positions(),
    passive=true,
  )
  if window.get_visual_viewport() is Some(viewport) {
    viewport.add_event_listener_with_options(
      "scroll",
      _ => menu_schedule_submenu_positions(),
      passive=true,
    )
    viewport.add_event_listener_with_options(
      "resize",
      _ => menu_schedule_submenu_positions(),
      passive=true,
    )
  }
}

///|
#cfg(target="js")
fn position_menu_submenus(id : String) -> Unit {
  guard ui_element_by_id(id) is Some(root) else {
    menu_submenu_roots.remove(id)
    return
  }
  menu_submenu_roots[id] = root
  menu_bind_submenu_position_events()
  menu_position_submenu_root(root)
}

///|
#cfg(target="js")
fn menu_position_submenus_cmd(id : String) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, _ => position_menu_submenus(id))
}

///|
#cfg(not(target="js"))
fn menu_position_submenus_cmd(id : String) -> @cmd.Cmd {
  ignore(id)
  @cmd.none
}

///|
#cfg(target="js")
fn menu_bind_surface_cmd(
  id : String,
  set_active : @cmd.Emit[Int],
  close_command : @cmd.Cmd,
  set_submenu : @cmd.Emit[MenuSubmenuChange],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, scheduler => {
    ui_after_mount(
      id,
      () => {
        bind_menu_surface(id, (kind, index, key, parent) => {
          let command = match kind {
            0 => set_active(index)
            1 => close_command
            2 => set_submenu(MenuOpenSubmenu(key))
            3 => set_submenu(MenuCloseSubmenu(key))
            4 => set_submenu(MenuSwitchSubmenu(parent, key))
            5 => set_submenu(MenuCloseSubmenusUnder(parent))
            _ => set_submenu(MenuCloseAllSubmenus)
          }
          scheduler.add(command)
        })
      },
      purpose="menu-surface-bind",
    )
  })
}

///|
#cfg(not(target="js"))
fn menu_bind_surface_cmd(
  id : String,
  set_active : @cmd.Emit[Int],
  close_command : @cmd.Cmd,
  set_submenu : @cmd.Emit[MenuSubmenuChange],
) -> @cmd.Cmd {
  ignore((id, set_active, close_command, set_submenu))
  @cmd.none
}

///|
#cfg(target="js")
fn menu_focus_item_cmd(
  id : String,
  index : Int,
  content_id? : String = "",
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, _ => {
    ui_after_ready("menu-focus-item:" + id, () => {
      focus_menu_item(id, content_id, index)
    })
  })
}

///|
#cfg(not(target="js"))
fn menu_focus_item_cmd(
  id : String,
  index : Int,
  content_id? : String = "",
) -> @cmd.Cmd {
  ignore((id, index, content_id))
  @cmd.none
}

///|
#cfg(target="js")
fn menu_focus_first_cmd(id : String, set_active : @cmd.Emit[Int]) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, scheduler => {
    focus_first_menu_item(id, index => scheduler.add(set_active(index)))
  })
}

///|
#cfg(target="js")
fn menu_open_marked_cmd(
  id : String,
  slot : String,
  set_index : @cmd.Emit[Int],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, scheduler => {
    ui_after_mount(
      id,
      () => {
        find_open_menu_content(id, slot, (content_id, index) => {
          ignore(set_floating_open(content_id, true))
          position_floating(content_id)
          if index >= 0 {
            scheduler.add(set_index(index))
          }
        })
      },
      purpose="menu-open-marked",
    )
  })
}

///|
#cfg(not(target="js"))
fn menu_open_marked_cmd(
  id : String,
  slot : String,
  set_index : @cmd.Emit[Int],
) -> @cmd.Cmd {
  ignore((id, slot, set_index))
  @cmd.none
}

///|
#cfg(not(target="js"))
fn menu_focus_first_cmd(id : String, set_active : @cmd.Emit[Int]) -> @cmd.Cmd {
  ignore((id, set_active))
  @cmd.none
}

///|
fn[C : @html.IsChildren] menu_root_surface(
  slot : String,
  id : String,
  open : Bool,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  @html.span(
    style=ui_styles([UiBoxSizing, MenuRootStyle], style),
    id~,
    attrs=menu_state_attrs(attrs, slot, open),
    children,
  )
}

///|
fn[C : @html.IsChildren] menu_trigger_button(
  slot : String,
  scope : MenuScope,
  variant : ButtonVariant,
  size : ButtonSize,
  disabled : Bool,
  aria_label : String?,
  on_click : @cmd.Cmd?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  let element_attrs = menu_state_attrs(attrs, slot, scope.model.open)
    .aria_haspopup("menu")
    .aria_expanded(ui_bool(scope.model.open))
    .aria_controls(scope.content_id)
    .data_set("variant", button_variant_value(variant))
    .data_set("size", button_size_value(size))
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  }
  if disabled {
    ignore(element_attrs.aria_disabled("true").data_set("disabled", ""))
  } else {
    if on_click is Some(on_click) {
      ignore(element_attrs.on_click(_ => on_click))
    }
    ignore(element_attrs.on_click(_ => scope.toggle_command))
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
        popup_anchor_style(scope.trigger_id),
      ],
      style,
    ),
    id=scope.trigger_id,
    class?,
    title?,
    type_="button",
    disabled~,
    attrs=element_attrs,
    children,
  )
}

///|
fn[C : @html.IsChildren] menu_content_surface(
  slot : String,
  scope : MenuScope,
  side : PopupSide,
  align : PopupAlign,
  side_offset : Int,
  align_offset : Int,
  aria_label : String?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  let is_context_menu = slot == "context-menu-content"
  let element_attrs = menu_state_attrs(attrs, slot, scope.model.open)
    .popover(if is_context_menu { "manual" } else { "auto" })
    .data_set("light-dismiss", "true")
    .role("menu")
    .tabindex(-1)
    .aria_orientation("vertical")
    .data_set("trigger-id", scope.trigger_id)
    .data_set("requested-side", popup_side_value(side))
    .data_set("requested-align", popup_align_value(align))
    .data_set("side", popup_side_value(side))
    .data_set("align", popup_align_value(align))
    .data_set("side-offset", "\{side_offset}")
    .data_set("align-offset", "\{align_offset}")
    .data_set("active-index", "\{scope.model.active}")
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  } else {
    ignore(element_attrs.aria_labelledby(scope.trigger_id))
  }
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        MenuContentStyle,
        PopupTransition100Style,
        if is_context_menu {
          popup_floating_anchor_style(
            context_menu_point_id(scope.trigger_id),
            Bottom,
            Start,
            0,
            0,
          )
        } else {
          popup_floating_anchor_style(
            scope.trigger_id,
            side,
            align,
            side_offset,
            align_offset,
          )
        },
        popup_state_style(scope.model.open),
      ],
      style,
    ),
    id=scope.content_id,
    class?,
    title?,
    attrs=element_attrs,
    children,
  )
}

///|
fn[C : @html.IsChildren] menu_group_surface(
  slot : String,
  aria_label : String?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs).data_set("slot", slot).role("group")
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  }
  @html.div(
    style=ui_styles([UiBoxSizing, "display:flex;flex-direction:column"], style),
    class?,
    title?,
    attrs=element_attrs,
    children,
  )
}

///|
fn[C : @html.IsChildren] menu_label_surface(
  slot : String,
  inset : Bool,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles(
      [UiBoxSizing, MenuLabelStyle, if inset { MenuItemInsetStyle } else { "" }],
      style,
    ),
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", slot),
    children,
  )
}

///|
fn menu_separator_surface(
  slot : String,
  class : String?,
  attrs : @html.Attrs?,
  style : Array[String],
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, MenuSeparatorStyle], style),
    class?,
    attrs=ui_attrs(attrs)
      .data_set("slot", slot)
      .role("separator")
      .aria_orientation("horizontal"),
    @html.nothing,
  )
}

///|
fn[C : @html.IsChildren] menu_shortcut_surface(
  slot : String,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  @html.span(
    style=ui_styles([UiBoxSizing, MenuShortcutStyle], style),
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", slot).aria_hidden("true"),
    children,
  )
}

///|
fn[C : @html.IsChildren] menu_item_surface(
  slot : String,
  scope : MenuScope,
  role : String,
  checked : Bool?,
  indicator_placement : MenuIndicatorPlacement,
  disabled : Bool,
  inset : Bool,
  destructive : Bool,
  submenu_key : String?,
  close_on_select : Bool,
  action : @cmd.Cmd?,
  on_select : @cmd.Cmd?,
  aria_label : String?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  let index = menu_scope_next_index(scope)
  let highlighted = scope.model.active == index
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", slot)
    .data_set("variant", if destructive { "destructive" } else { "default" })
    .data_set("menu-index", "\{index}")
    .data_set("highlighted", ui_bool(highlighted))
    .role(role)
    .tabindex(if highlighted { 0 } else { -1 })
  if highlighted {
    ignore(element_attrs.data_set("active", ""))
  }
  if checked is Some(checked) {
    ignore(
      element_attrs
      .aria_checked(ui_bool(checked))
      .data_set("state", if checked { "checked" } else { "unchecked" }),
    )
  }
  if submenu_key is Some(key) {
    let open = menu_submenu_open(scope.model.submenus, key)
    ignore(
      element_attrs
      .id(menu_submenu_trigger_id(key))
      .data_set("submenu-key", key)
      .data_set("state", if open { "open" } else { "closed" })
      .aria_haspopup("menu")
      .aria_expanded(ui_bool(open))
      .aria_controls(menu_submenu_content_id(key)),
    )
  }
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label).data_set("menu-label", label))
  }
  if disabled {
    ignore(element_attrs.aria_disabled("true").data_set("disabled", ""))
  } else {
    if on_select is Some(on_select) {
      ignore(element_attrs.on_click(_ => on_select))
    }
    if action is Some(action) {
      ignore(element_attrs.on_click(_ => action))
    }
    if close_on_select {
      ignore(element_attrs.on_click(_ => scope.close_command))
    }
  }
  let body = @html.span(
    style=[UiBoxSizing, "display:contents"],
    attrs=@html.Attrs::build().data_set("slot", slot + "-body"),
    children,
  )
  let row = if checked is Some(checked) {
    [
      @html.span(
        style=[
          UiBoxSizing,
          match indicator_placement {
            MenuIndicatorInlineStart => MenuIndicatorStartStyle
            MenuIndicatorInlineEnd => MenuIndicatorEndStyle
          },
        ],
        attrs=@html.Attrs::build()
          .data_set("slot", slot + "-indicator")
          .aria_hidden("true"),
        if checked {
          ui_check_icon()
        } else {
          @html.nothing
        },
      ),
      body,
    ]
  } else if submenu_key is Some(_) {
    [
      body,
      @html.span(
        style=[UiBoxSizing, MenuIndicatorEndStyle],
        attrs=@html.Attrs::build()
          .aria_hidden("true")
          .data_set("icon", "inline-end"),
        ui_chevron_right_icon(),
      ),
    ]
  } else {
    [body]
  }
  @html.button(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        MenuItemStyle,
        if (checked is Some(_) && indicator_placement == MenuIndicatorInlineEnd) ||
          submenu_key is Some(_) {
          MenuItemEndIndicatorStyle
        } else {
          ""
        },
        if inset {
          MenuItemInsetStyle
        } else {
          ""
        },
        if destructive {
          MenuItemDestructiveStyle
        } else {
          ""
        },
        if highlighted {
          MenuItemHighlightedStyle
        } else {
          ""
        },
        match submenu_key {
          Some(key) => popup_anchor_style(key)
          None => ""
        },
        ui_disabled_style(disabled),
      ],
      style,
    ),
    class?,
    title?,
    type_="button",
    disabled~,
    attrs=element_attrs,
    row,
  )
}

///|
fn[C : @html.IsChildren] menu_sub_root_surface(
  slot : String,
  open : Bool,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, "position:relative;display:contents"], style),
    attrs=menu_state_attrs(attrs, slot, open),
    children,
  )
}

///|
fn[C : @html.IsChildren] menu_sub_content_surface(
  slot : String,
  key : String,
  open : Bool,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        MenuSubContentStyle,
        PopupTransition100Style,
        menu_submenu_anchor_style(key),
        popup_state_style(open),
      ],
      style,
    ),
    class?,
    title?,
    attrs=menu_state_attrs(attrs, slot, open)
      .id(menu_submenu_content_id(key))
      .popover("manual")
      .data_set("restore-focus", "false")
      .data_set("submenu-owner", key)
      .data_set("requested-side", "inline-end")
      .data_set("requested-align", "start")
      .data_set("positioned", if open { "pending" } else { "false" })
      .role("menu")
      .aria_orientation("vertical")
      .aria_labelledby(menu_submenu_trigger_id(key))
      .tabindex(-1),
    children,
  )
}
