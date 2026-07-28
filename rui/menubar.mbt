///|
struct MenubarModel {
  active_value : String?
  active_index : Int
  focus_index : Int
  menu : MenuCoreModel
} derive(Eq)

///|
struct MenubarScope {
  id : String
  model : MenubarModel
  counter : Ref[Int]
  focus_claimed : Ref[Bool]
  toggle : @cmd.Emit[(String, Int)]
  close_command : @cmd.Cmd
  toggle_checked : @cmd.Emit[String]
  set_radio : @cmd.Emit[(String, String)]
}

///|
struct MenubarMenuScope {
  menu : MenuScope
  value : String
  index : Int
  focus_index : Int
  focus_claimed : Ref[Bool]
  active_value_set : Bool
}

///|
struct MenubarRadioGroupScope {
  menu : MenuScope
  group : String
}

///|
struct MenubarSubScope {
  menu : MenuScope
  key : String
}

///|
#cfg(target="js")
priv enum MenubarMsg {
  MenubarActivate(String, Int)
  MenubarSwitch(String, Int)
  MenubarToggle(String, Int)
  MenubarClose
  MenubarNative(String, Int, Bool)
  MenubarSetActive(Int)
  MenubarToggleChecked(String)
  MenubarSetRadio(String, String)
  MenubarSetSubmenu(MenuSubmenuChange)
  MenubarSetFocus(Int)
}

///|
const MenubarStyle : String = "display:inline-flex;max-width:100%;min-width:0;flex-wrap:wrap;align-items:center;gap:0.125rem;border:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-background,oklch(1 0 0));padding:0.25rem;color:var(--rui-foreground,oklch(0.145 0 0));box-shadow:0 1px 2px rgb(0 0 0 / 0.05)"

///|
const MenubarTriggerStyle : String = "height:1.75rem;border:0;background:var(--rui-menu-item-bg,var(--rui-menu-item-base-bg,transparent));padding-inline:0.625rem;color:var(--rui-menu-item-fg,var(--rui-menu-item-base-fg,inherit));box-shadow:none"

///|
const MenubarHoverClickWindowMs : Int = 250

///|
#cfg(target="js")
priv struct MenubarHoverSwitch {
  value : String
  index : Int
  at : Double
}

///|
#cfg(target="js")
priv struct MenubarBinding {
  id : String
  root : @dom.Element
  activate : Ref[(String, Int, Bool) -> Unit]
  native_change : Ref[(String, Int, Bool) -> Unit]
  close : Ref[() -> Unit]
  set_focus : Ref[(Int) -> Unit]
  toggle_contents : Array[@dom.Element]
}

///|
#cfg(target="js")
let menubar_bindings : Map[String, MenubarBinding] = Map([])

///|
#cfg(target="js")
let menubar_hover_switches : Map[String, MenubarHoverSwitch] = Map([])

///|
#cfg(target="js")
fn menubar_now() -> Double {
  if ui_has_window() {
    @dom.window().get_performance().now()
  } else {
    0.0
  }
}

///|
#cfg(target="js")
fn menubar_triggers(binding : MenubarBinding) -> Array[@dom.Element] {
  binding.root
  .query_selector_all("[data-slot=\"menubar-trigger\"]")
  .filter(ui_element_is_enabled)
}

///|
#cfg(target="js")
fn menubar_open_trigger(
  binding : MenubarBinding,
  trigger : @dom.Element,
  focus_content : Bool,
) -> Unit {
  (binding.activate.val)(
    trigger.get_attribute("data-menubar-value").unwrap_or(""),
    ui_parse_int_or(
      trigger.get_attribute("data-menubar-index").unwrap_or(""),
      -1,
    ),
    focus_content,
  )
}

///|
#cfg(target="js")
fn menubar_focus_menu_index(
  binding : MenubarBinding,
  index : Int,
  last : Bool,
  attempt : Int,
  stable_frames : Int,
) -> Unit {
  guard ui_element_by_id(binding.id) is Some(live_root) else { return }
  let content = ui_find_element(
    live_root.query_selector_all("[data-slot=\"menubar-content\"]"),
    node => {
      ui_parse_int_or(
        node.get_attribute("data-menubar-index").unwrap_or(""),
        -1,
      ) ==
      index &&
      menu_element_is_visible(node)
    },
  )
  let target = if content is Some(content) {
    let items = content
      .query_selector_all("[data-menu-index]")
      .filter(item => {
        menu_element_is_visible(item) &&
        item.closest("[role=\"menu\"]") is Some(owner) &&
        owner.is_same_node(content.as_node())
      })
    if last {
      items.get(items.length() - 1)
    } else {
      items.get(0)
    }
  } else {
    None
  }
  if target is Some(target) {
    ui_focus_element_without_scroll(target)
    let focused = @dom.document().get_active_element() is Some(active) &&
      active.is_same_node(target.as_node())
    let next_stable_frames = if focused { stable_frames + 1 } else { 0 }
    if next_stable_frames < 3 && attempt < 20 {
      menu_request_frame(() => {
        menubar_focus_menu_index(
          binding,
          index,
          last,
          attempt + 1,
          next_stable_frames,
        )
      })
    }
  } else if attempt < 20 {
    menu_request_frame(() => {
      menubar_focus_menu_index(binding, index, last, attempt + 1, 0)
    })
  }
}

///|
#cfg(target="js")
fn menubar_handle_keydown(
  binding : MenubarBinding,
  event : @dom.KeyboardEvent,
) -> Unit {
  if event.get_default_prevented() {
    return
  }
  guard event.target().to_element() is Some(target) else { return }
  let trigger = target.closest("[data-slot=\"menubar-trigger\"]")
  let content = target.closest("[data-slot=\"menubar-content\"]")
  let rtl = ui_element_is_rtl(binding.root)
  let forward_key = if rtl { "ArrowLeft" } else { "ArrowRight" }
  let backward_key = if rtl { "ArrowRight" } else { "ArrowLeft" }
  let key = event.key()
  if trigger is None &&
    content is Some(content) &&
    (key == "ArrowRight" || key == "ArrowLeft") {
    let menu_item = target.closest("[data-menu-index]")
    if key == forward_key &&
      menu_item is Some(menu_item) &&
      menu_item.get_attribute("data-submenu-key").unwrap_or("") != "" {
      return
    }
    if key == backward_key &&
      menu_item is Some(menu_item) &&
      menu_item.closest("[data-submenu-owner]") is Some(_) {
      return
    }
    let triggers = menubar_triggers(binding)
    if triggers.length() == 0 {
      return
    }
    let index = ui_parse_int_or(
      content.get_attribute("data-menubar-index").unwrap_or(""),
      0,
    )
    let mut current = 0
    for item_index, item in triggers {
      if ui_parse_int_or(
          item.get_attribute("data-menubar-index").unwrap_or(""),
          -1,
        ) ==
        index {
        current = item_index
      }
    }
    let next_position = if key == forward_key {
      (current + 1) % triggers.length()
    } else if current == 0 {
      triggers.length() - 1
    } else {
      current - 1
    }
    if triggers.get(next_position) is Some(next) {
      event.prevent_default()
      ui_focus_element_without_scroll(next)
      menubar_open_trigger(binding, next, true)
    }
    return
  }
  guard trigger is Some(trigger) else { return }
  menubar_hover_switches.remove(binding.id)
  let triggers = menubar_triggers(binding)
  if triggers.length() == 0 {
    return
  }
  let mut current = 0
  for item_index, item in triggers {
    if item.is_same_node(trigger.as_node()) {
      current = item_index
    }
  }
  let mut next : @dom.Element? = None
  if key == forward_key {
    next = triggers.get((current + 1) % triggers.length())
  } else if key == backward_key {
    next = triggers.get(
      if current == 0 {
        triggers.length() - 1
      } else {
        current - 1
      },
    )
  } else if key == "Home" {
    next = triggers.get(0)
  } else if key == "End" {
    next = triggers.get(triggers.length() - 1)
  }
  if key == "ArrowDown" || key == "ArrowUp" {
    event.prevent_default()
    menubar_open_trigger(binding, trigger, false)
    menubar_focus_menu_index(
      binding,
      ui_parse_int_or(
        trigger.get_attribute("data-menubar-index").unwrap_or(""),
        -1,
      ),
      key == "ArrowUp",
      0,
      0,
    )
    return
  }
  if key == "Escape" {
    event.prevent_default()
    (binding.close.val)()
    ui_focus_element(trigger)
    return
  }
  if next is Some(next) {
    event.prevent_default()
    ui_focus_element(next)
    if binding.root.get_attribute("data-state").unwrap_or("") == "open" {
      menubar_open_trigger(binding, next, false)
    }
  }
}

///|
#cfg(target="js")
fn menubar_bind_content_toggles(binding : MenubarBinding) -> Unit {
  for
    content in binding.root.query_selector_all(
      "[data-slot=\"menubar-content\"]",
    ) {
    let mut already_bound = false
    for current in binding.toggle_contents {
      if current.is_same_node(content.as_node()) {
        already_bound = true
      }
    }
    if !already_bound {
      binding.toggle_contents.push(content)
      content.add_event_listener("toggle", _ => {
        (binding.native_change.val)(
          content.get_attribute("data-menubar-value").unwrap_or(""),
          ui_parse_int_or(
            content.get_attribute("data-menubar-index").unwrap_or(""),
            -1,
          ),
          content.matches(":popover-open"),
        )
      })
    }
  }
}

///|
#cfg(target="js")
fn bind_menubar(
  id : String,
  activate : (String, Int, Bool) -> Unit,
  native_change : (String, Int, Bool) -> Unit,
  close : () -> Unit,
  set_focus : (Int) -> Unit,
) -> Unit {
  guard ui_element_by_id(id) is Some(root) else { return }
  if menubar_bindings.get(id) is Some(existing) &&
    existing.root.is_same_node(root.as_node()) {
    existing.activate.val = activate
    existing.native_change.val = native_change
    existing.close.val = close
    existing.set_focus.val = set_focus
    menubar_bind_content_toggles(existing)
    return
  }
  let binding : MenubarBinding = {
    id,
    root,
    activate: Ref(activate),
    native_change: Ref(native_change),
    close: Ref(close),
    set_focus: Ref(set_focus),
    toggle_contents: [],
  }
  menubar_bindings[id] = binding
  menubar_bind_content_toggles(binding)
  root.add_event_listener("focusin", event => {
    guard event.target().to_element() is Some(target) else { return }
    guard target.closest("[data-slot=\"menubar-trigger\"]") is Some(trigger) &&
      ui_element_is_enabled(trigger) else {
      return
    }
    let index = ui_parse_int_or(
      trigger.get_attribute("data-menubar-index").unwrap_or(""),
      -1,
    )
    for item in menubar_triggers(binding) {
      ui_set_element_tab_index(
        item,
        if item.is_same_node(trigger.as_node()) {
          0
        } else {
          -1
        },
      )
    }
    if index >= 0 {
      (binding.set_focus.val)(index)
    }
  })
  root.add_event_listener("pointermove", event => {
    if binding.root.get_attribute("data-state").unwrap_or("") != "open" {
      return
    }
    guard event.target().to_element() is Some(target) else { return }
    guard target.closest("[data-slot=\"menubar-trigger\"]") is Some(trigger) &&
      ui_element_is_enabled(trigger) else {
      return
    }
    if trigger.get_attribute("data-state").unwrap_or("") != "open" {
      menubar_hover_switches[id] = {
        value: trigger.get_attribute("data-menubar-value").unwrap_or(""),
        index: ui_parse_int_or(
          trigger.get_attribute("data-menubar-index").unwrap_or(""),
          -1,
        ),
        at: if event.get_time_stamp() > 0.0 {
          event.get_time_stamp()
        } else {
          menubar_now()
        },
      }
    }
    let needs_focus = @dom.document().get_active_element() is None ||
      !@dom.document()
      .get_active_element()
      .unwrap()
      .is_same_node(trigger.as_node())
    if needs_focus {
      ui_focus_element_without_scroll(trigger)
    }
    menubar_open_trigger(binding, trigger, false)
  })
  root.add_event_listener("keydown", event => {
    if event.to_keyboard_event() is Some(keyboard_event) {
      menubar_handle_keydown(binding, keyboard_event)
    }
  })
}

///|
#cfg(target="js")
fn consume_menubar_hover_switch(
  id : String,
  value : String,
  index : Int,
  max_age_ms : Int,
) -> Bool {
  let switched = menubar_hover_switches.get(id)
  menubar_hover_switches.remove(id)
  guard switched is Some(switched) else { return false }
  let age = menubar_now() - switched.at
  switched.value == value &&
  switched.index == index &&
  age >= 0.0 &&
  age <= max_age_ms.to_double()
}

///|
#cfg(target="js")
fn menubar_should_toggle(
  id : String,
  active_value : String?,
  value : String,
  index : Int,
) -> Bool {
  let hover_switched = consume_menubar_hover_switch(
    id,
    value,
    index,
    MenubarHoverClickWindowMs,
  )
  active_value != Some(value) || !hover_switched
}

///|
#cfg(target="js")
fn focus_menubar_content(id : String, index : Int) -> Bool {
  guard ui_element_by_id(id) is Some(root) else { return false }
  guard ui_find_element(
      root.query_selector_all("[data-slot=\"menubar-content\"]"),
      node => {
        ui_parse_int_or(
          node.get_attribute("data-menubar-index").unwrap_or(""),
          -1,
        ) ==
        index &&
        menu_element_is_visible(node)
      },
    )
    is Some(content) &&
    content.get_attribute("data-state").unwrap_or("") == "open" else {
    return false
  }
  let target = ui_find_element(
    content.query_selector_all("[data-menu-index]"),
    node => {
      if !menu_element_is_visible(node) {
        false
      } else if node.closest("[role=\"menu\"]") is Some(owner) {
        owner.is_same_node(content.as_node())
      } else {
        false
      }
    },
  )
  guard target is Some(target) else { return false }
  let document = @dom.document()
  if document.get_active_element() is None ||
    !document.get_active_element().unwrap().is_same_node(target.as_node()) {
    ui_focus_element_without_scroll(target)
  }
  document.get_active_element() is Some(active) &&
  active.is_same_node(target.as_node())
}

///|
#cfg(target="js")
fn menubar_focus_content_cmd(id : String, index : Int) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, _ => {
    ui_after_ready("menubar-focus-content:" + id, () => {
      focus_menubar_content(id, index)
    })
  })
}

///|
#cfg(target="js")
fn menubar_bind_cmd(
  id : String,
  activate : @cmd.Emit[(String, Int)],
  switch_activate : @cmd.Emit[(String, Int)],
  native_change : @cmd.Emit[(String, Int, Bool)],
  close_command : @cmd.Cmd,
  set_focus : @cmd.Emit[Int],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, scheduler => {
    ui_after_mount(
      id,
      () => {
        bind_menubar(
          id,
          (value, index, focus_content) => {
            scheduler.add(
              if focus_content {
                switch_activate((value, index))
              } else {
                activate((value, index))
              },
            )
          },
          (value, index, open) => {
            scheduler.add(native_change((value, index, open)))
          },
          () => scheduler.add(close_command),
          index => scheduler.add(set_focus(index)),
        )
      },
      purpose="menubar-bind",
    )
  })
}

///|
fn menubar_content_id(id : String, index : Int) -> String {
  id + "-content-\{index}"
}

///|
fn menubar_trigger_id(id : String, index : Int) -> String {
  id + "-trigger-\{index}"
}

///|
fn menubar_scope(
  id : String,
  model : MenubarModel,
  toggle : @cmd.Emit[(String, Int)],
  close_command : @cmd.Cmd,
  toggle_checked : @cmd.Emit[String],
  set_radio : @cmd.Emit[(String, String)],
) -> MenubarScope {
  {
    id,
    model,
    counter: Ref(0),
    focus_claimed: Ref(false),
    toggle,
    close_command,
    toggle_checked,
    set_radio,
  }
}

///|
fn menubar_change_command(
  id : String,
  current : MenubarModel,
  value : String?,
  index : Int,
) -> @cmd.Cmd {
  let hide_previous = if current.active_index >= 0 &&
    current.active_value != value {
    floating_set_open_cmd(menubar_content_id(id, current.active_index), false)
  } else {
    @cmd.none
  }
  @cmd.batch([
    hide_previous,
    if value is Some(_) {
      floating_set_open_cmd(menubar_content_id(id, index), true)
    } else {
      @cmd.none
    },
    menu_position_submenus_cmd(id + "-root"),
  ])
}

///|
#cfg(target="js")
pub fn menubar(
  id~ : String,
  default_value? : String,
  default_checked_values? : Array[String] = [],
  default_radio_values? : Array[(String, String)] = [],
  on_value_change? : @cmd.Emit[String?],
  aria_label? : String = "Application menu",
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (MenubarScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  let initial : MenubarModel = {
    active_value: default_value,
    active_index: if default_value is Some(_) {
      0
    } else {
      -1
    },
    focus_index: -1,
    menu: menu_core_model(
      default_value is Some(_),
      default_checked_values,
      default_radio_values,
    ),
  }
  let (model, emit) = @rabbita.create_state_with_init(
    init=emit => {
      let set_active = emit.map(index => MenubarSetActive(index))
      let set_submenu = emit.map(value => MenubarSetSubmenu(value))
      (
        initial,
        @cmd.batch([
          menubar_bind_cmd(
            id + "-root",
            emit.map(pair => MenubarActivate(pair.0, pair.1)),
            emit.map(pair => MenubarSwitch(pair.0, pair.1)),
            emit.map(tuple => MenubarNative(tuple.0, tuple.1, tuple.2)),
            emit(MenubarClose),
            emit.map(index => MenubarSetFocus(index)),
          ),
          menu_bind_surface_cmd(
            id + "-root",
            set_active,
            emit(MenubarClose),
            set_submenu,
          ),
          match default_value {
            Some(value) =>
              menu_open_marked_cmd(
                id + "-root",
                "menubar-content",
                emit.map(index => MenubarNative(value, index, true)),
              )
            None => @cmd.none
          },
        ]),
      )
    },
    update=(current, msg, emit) => {
      match msg {
        MenubarActivate(value, index) =>
          if current.active_value == Some(value) {
            (current, @cmd.none)
          } else {
            let next = {
              active_value: Some(value),
              active_index: index,
              focus_index: index,
              menu: { ..current.menu, open: true, active: -1, submenus: [] },
            }
            (
              next,
              @cmd.batch([
                menubar_change_command(id, current, Some(value), index),
                if on_value_change is Some(notify) {
                  notify(Some(value))
                } else {
                  @cmd.none
                },
              ]),
            )
          }
        MenubarSwitch(value, index) => {
          let next = {
            active_value: Some(value),
            active_index: index,
            focus_index: index,
            menu: { ..current.menu, open: true, active: -1, submenus: [] },
          }
          (
            next,
            @cmd.batch([
              menubar_change_command(id, current, Some(value), index),
              menubar_focus_content_cmd(id + "-root", index),
              if on_value_change is Some(notify) {
                notify(Some(value))
              } else {
                @cmd.none
              },
            ]),
          )
        }
        MenubarToggle(value, index) =>
          if !menubar_should_toggle(
              id + "-root",
              current.active_value,
              value,
              index,
            ) {
            (current, @cmd.none)
          } else if current.active_value == Some(value) {
            (
              {
                active_value: None,
                active_index: -1,
                focus_index: index,
                menu: { ..current.menu, open: false, submenus: [] },
              },
              @cmd.batch([
                floating_set_open_cmd(menubar_content_id(id, index), false),
                menu_position_submenus_cmd(id + "-root"),
                if on_value_change is Some(notify) {
                  notify(None)
                } else {
                  @cmd.none
                },
              ]),
            )
          } else {
            let next = {
              active_value: Some(value),
              active_index: index,
              focus_index: index,
              menu: { ..current.menu, open: true, active: -1, submenus: [] },
            }
            (
              next,
              @cmd.batch([
                menubar_change_command(id, current, Some(value), index),
                menu_focus_first_cmd(
                  id + "-root",
                  emit.map(active => MenubarSetActive(active)),
                ),
                if on_value_change is Some(notify) {
                  notify(Some(value))
                } else {
                  @cmd.none
                },
              ]),
            )
          }
        MenubarClose =>
          if current.active_value is Some(_) {
            (
              {
                active_value: None,
                active_index: -1,
                focus_index: current.active_index,
                menu: { ..current.menu, open: false, submenus: [] },
              },
              @cmd.batch([
                floating_set_open_cmd(
                  menubar_content_id(id, current.active_index),
                  false,
                ),
                menu_position_submenus_cmd(id + "-root"),
                ui_focus_id(menubar_trigger_id(id, current.active_index)),
                if on_value_change is Some(notify) {
                  notify(None)
                } else {
                  @cmd.none
                },
              ]),
            )
          } else {
            (current, @cmd.none)
          }
        MenubarNative(value, index, open) =>
          if open {
            if current.active_value == Some(value) &&
              current.active_index == index {
              (current, @cmd.none)
            } else {
              (
                {
                  active_value: Some(value),
                  active_index: index,
                  focus_index: index,
                  menu: { ..current.menu, open: true },
                },
                @cmd.none,
              )
            }
          } else if current.active_value == Some(value) {
            (
              {
                active_value: None,
                active_index: -1,
                focus_index: index,
                menu: { ..current.menu, open: false, submenus: [] },
              },
              @cmd.batch([
                menu_position_submenus_cmd(id + "-root"),
                if on_value_change is Some(notify) {
                  notify(None)
                } else {
                  @cmd.none
                },
              ]),
            )
          } else {
            (current, @cmd.none)
          }
        MenubarSetActive(index) =>
          if current.menu.active == index {
            (current, @cmd.none)
          } else {
            (
              { ..current, menu: { ..current.menu, active: index } },
              menu_focus_item_cmd(
                id + "-root",
                index,
                content_id=menubar_content_id(id, current.active_index),
              ),
            )
          }
        MenubarToggleChecked(value) =>
          (
            {
              ..current,
              menu: {
                ..current.menu,
                checked: menu_toggle_value(current.menu.checked, value),
              },
            },
            @cmd.none,
          )
        MenubarSetRadio(group, value) =>
          (
            {
              ..current,
              menu: {
                ..current.menu,
                radios: menu_set_radio_value(current.menu.radios, group, value),
              },
            },
            @cmd.none,
          )
        MenubarSetSubmenu(change) => {
          let submenus = menu_update_submenus(current.menu.submenus, change)
          if submenus == current.menu.submenus {
            (current, @cmd.none)
          } else {
            (
              { ..current, menu: { ..current.menu, submenus, } },
              menu_position_submenus_cmd(id + "-root"),
            )
          }
        }
        MenubarSetFocus(index) => ({ ..current, focus_index: index }, @cmd.none)
      }
    },
  )
  model.view(model => {
    let scope = menubar_scope(
      id,
      model,
      emit.map(pair => MenubarToggle(pair.0, pair.1)),
      emit(MenubarClose),
      emit.map(value => MenubarToggleChecked(value)),
      emit.map(pair => MenubarSetRadio(pair.0, pair.1)),
    )
    let element_attrs = menu_state_attrs(
        attrs,
        "menubar",
        model.active_value is Some(_),
      )
      .role("menubar")
      .aria_orientation("horizontal")
    ignore(element_attrs.aria_label(aria_label))
    if model.active_value is Some(value) {
      ignore(element_attrs.data_set("value", value))
    }
    @html.div(
      style=ui_styles(
        [UiBoxSizing, UiFontSans, UiTextRendering, MenubarStyle],
        style,
      ),
      id=id + "-root",
      class?,
      title?,
      attrs=element_attrs,
      children(scope),
    )
  })
}

///|
#cfg(not(target="js"))
pub fn menubar(
  id~ : String,
  default_value? : String,
  default_checked_values? : Array[String] = [],
  default_radio_values? : Array[(String, String)] = [],
  on_value_change? : @cmd.Emit[String?],
  aria_label? : String = "Application menu",
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (MenubarScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  ignore(on_value_change)
  let model : MenubarModel = {
    active_value: default_value,
    active_index: if default_value is Some(_) {
      0
    } else {
      -1
    },
    focus_index: -1,
    menu: menu_core_model(
      default_value is Some(_),
      default_checked_values,
      default_radio_values,
    ),
  }
  let scope = menubar_scope(
    id,
    model,
    menu_noop_emit(),
    @cmd.none,
    menu_noop_emit(),
    menu_noop_emit(),
  )
  let element_attrs = menu_state_attrs(
      attrs,
      "menubar",
      default_value is Some(_),
    )
    .role("menubar")
    .aria_orientation("horizontal")
  ignore(element_attrs.aria_label(aria_label))
  @rabbita.Val::constant(
    @html.div(
      style=ui_styles(
        [UiBoxSizing, UiFontSans, UiTextRendering, MenubarStyle],
        style,
      ),
      id=id + "-root",
      class?,
      title?,
      attrs=element_attrs,
      children(scope),
    ),
  )
}

///|
/// Explicit Root spelling matching the compound-component API.
pub fn menubar_root(
  id~ : String,
  default_value? : String,
  default_checked_values? : Array[String] = [],
  default_radio_values? : Array[(String, String)] = [],
  on_value_change? : @cmd.Emit[String?],
  aria_label? : String = "Application menu",
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (MenubarScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  menubar(
    id~,
    default_value?,
    default_checked_values~,
    default_radio_values~,
    on_value_change?,
    aria_label~,
    class?,
    title?,
    attrs?,
    style~,
    children,
  )
}

///|
/// Zero-DOM Portal adapter for shadcn-compatible compound composition.
/// Menubar Content is promoted by native Popover, so children remain directly
/// composable without an extra element or a portal registration phase.
pub fn menubar_portal(children : Array[@html.Html]) -> @html.Html {
  @html.fragment(children)
}

///|
pub fn[C : @html.IsChildren] menubar_menu(
  scope : MenubarScope,
  value~ : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (MenubarMenuScope) -> C,
) -> @html.Html {
  let index = scope.counter.val
  scope.counter.val += 1
  let open = scope.model.active_value == Some(value)
  let menu_model = { ..scope.model.menu, open, }
  let menu : MenuScope = {
    id: scope.id,
    content_id: menubar_content_id(scope.id, index),
    trigger_id: menubar_trigger_id(scope.id, index),
    model: menu_model,
    counter: Ref(0),
    close_command: scope.close_command,
    toggle_command: (scope.toggle)((value, index)),
    toggle_checked: scope.toggle_checked,
    set_radio: scope.set_radio,
  }
  @html.div(
    style=ui_styles([UiBoxSizing, "display:contents"], style),
    attrs=menu_state_attrs(attrs, "menubar-menu", open)
      .data_set("value", value)
      .data_set("menubar-index", "\{index}"),
    children({
      menu,
      value,
      index,
      focus_index: scope.model.focus_index,
      focus_claimed: scope.focus_claimed,
      active_value_set: scope.model.active_value is Some(_),
    }),
  )
}

///|
pub fn[C : @html.IsChildren] menubar_trigger(
  scope : MenubarMenuScope,
  disabled? : Bool = false,
  aria_label? : String,
  on_click? : @cmd.Cmd,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let preferred = if scope.active_value_set {
    scope.menu.model.open
  } else if scope.focus_index >= 0 {
    scope.focus_index == scope.index
  } else {
    !scope.focus_claimed.val
  }
  let tab_stop = !disabled && preferred
  if tab_stop {
    scope.focus_claimed.val = true
  }
  let trigger_attrs = ui_attrs(attrs)
    .data_set("menubar-value", scope.value)
    .data_set("menubar-index", "\{scope.index}")
    .role("menuitem")
    .tabindex(if tab_stop { 0 } else { -1 })
  menu_trigger_button(
    "menubar-trigger",
    scope.menu,
    Ghost,
    Sm,
    disabled,
    aria_label,
    on_click,
    class,
    title,
    Some(trigger_attrs),
    [
      MenubarTriggerStyle,
      if scope.menu.model.open {
        "--rui-menu-item-base-bg:var(--rui-accent,oklch(0.97 0 0));--rui-menu-item-base-fg:var(--rui-accent-foreground,oklch(0.205 0 0))"
      } else {
        ""
      },
    ] +
    style,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] menubar_content(
  scope : MenubarMenuScope,
  side_offset? : Int = 8,
  align_offset? : Int = 0,
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let content_attrs = ui_attrs(attrs)
    .data_set("menubar-value", scope.value)
    .data_set("menubar-index", "\{scope.index}")
    .data_set("restore-focus", "false")
  menu_content_surface(
    "menubar-content",
    scope.menu,
    Bottom,
    Start,
    side_offset,
    align_offset,
    aria_label,
    class,
    title,
    Some(content_attrs),
    style,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] menubar_group(
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_group_surface(
    "menubar-group", aria_label, class, title, attrs, style, children,
  )
}

///|
pub fn[C : @html.IsChildren] menubar_item(
  scope : MenubarMenuScope,
  disabled? : Bool = false,
  inset? : Bool = false,
  destructive? : Bool = false,
  close_on_select? : Bool = true,
  on_select? : @cmd.Cmd,
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_item_surface(
    "menubar-item",
    scope.menu,
    "menuitem",
    None,
    MenuIndicatorInlineStart,
    disabled,
    inset,
    destructive,
    None,
    close_on_select,
    None,
    on_select,
    aria_label,
    class,
    title,
    attrs,
    style,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] menubar_checkbox_item(
  scope : MenubarMenuScope,
  value~ : String,
  disabled? : Bool = false,
  close_on_select? : Bool = false,
  on_checked_change? : @cmd.Emit[Bool],
  on_select? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let checked = menu_contains(scope.menu.model.checked, value)
  let notify = if on_checked_change is Some(notify) {
    notify(!checked)
  } else {
    @cmd.none
  }
  menu_item_surface(
    "menubar-checkbox-item",
    scope.menu,
    "menuitemcheckbox",
    Some(checked),
    MenuIndicatorInlineEnd,
    disabled,
    false,
    false,
    None,
    close_on_select,
    Some(@cmd.batch([notify, (scope.menu.toggle_checked)(value)])),
    on_select,
    None,
    None,
    None,
    attrs,
    style,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] menubar_radio_group(
  scope : MenubarMenuScope,
  value~ : String,
  aria_label? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (MenubarRadioGroupScope) -> C,
) -> @html.Html {
  menu_group_surface(
    "menubar-radio-group",
    aria_label,
    None,
    None,
    attrs,
    style,
    children({ menu: scope.menu, group: value }),
  )
}

///|
pub fn[C : @html.IsChildren] menubar_radio_item(
  scope : MenubarRadioGroupScope,
  value~ : String,
  disabled? : Bool = false,
  close_on_select? : Bool = false,
  on_value_change? : @cmd.Emit[String],
  on_select? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let checked = menu_radio_value(scope.menu.model.radios, scope.group) ==
    Some(value)
  let notify = if on_value_change is Some(notify) {
    notify(value)
  } else {
    @cmd.none
  }
  menu_item_surface(
    "menubar-radio-item",
    scope.menu,
    "menuitemradio",
    Some(checked),
    MenuIndicatorInlineEnd,
    disabled,
    false,
    false,
    None,
    close_on_select,
    Some(@cmd.batch([notify, (scope.menu.set_radio)((scope.group, value))])),
    on_select,
    None,
    None,
    None,
    attrs,
    style,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] menubar_label(
  inset? : Bool = false,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_label_surface("menubar-label", inset, None, None, attrs, style, children)
}

///|
pub fn menubar_separator(
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  menu_separator_surface("menubar-separator", None, attrs, style)
}

///|
pub fn[C : @html.IsChildren] menubar_shortcut(
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_shortcut_surface("menubar-shortcut", None, None, attrs, style, children)
}

///|
pub fn[C : @html.IsChildren] menubar_sub(
  scope : MenubarMenuScope,
  value~ : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (MenubarSubScope) -> C,
) -> @html.Html {
  let key = menu_submenu_key(scope.menu, value)
  let open = menu_submenu_open(scope.menu.model.submenus, key)
  menu_sub_root_surface(
    "menubar-sub",
    open,
    attrs,
    style,
    children({ menu: scope.menu, key }),
  )
}

///|
pub fn[C : @html.IsChildren] menubar_sub_trigger(
  scope : MenubarSubScope,
  disabled? : Bool = false,
  inset? : Bool = false,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_item_surface(
    "menubar-sub-trigger",
    scope.menu,
    "menuitem",
    None,
    MenuIndicatorInlineStart,
    disabled,
    inset,
    false,
    Some(scope.key),
    false,
    None,
    None,
    None,
    None,
    None,
    attrs,
    style,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] menubar_sub_content(
  scope : MenubarSubScope,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_sub_content_surface(
    "menubar-sub-content",
    scope.key,
    menu_submenu_open(scope.menu.model.submenus, scope.key),
    None,
    None,
    attrs,
    style,
    children,
  )
}
