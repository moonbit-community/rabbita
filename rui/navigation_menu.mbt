///|
struct NavigationMenuModel {
  value : String?
  index : Int
  focus_index : Int
} derive(Eq)

///|
struct NavigationMenuScope {
  id : String
  model : NavigationMenuModel
  counter : Ref[Int]
  focus_claimed : Ref[Bool]
  viewport : Bool
  contents : Ref[Array[NavigationMenuContentEntry]]
  viewport_rendered : Ref[Bool]
  toggle : @cmd.Emit[(String, Int)]
}

///|
struct NavigationMenuItemScope {
  id : String
  value : String
  index : Int
  open : Bool
  focus_index : Int
  focus_claimed : Ref[Bool]
  active_value_set : Bool
  viewport : Bool
  contents : Ref[Array[NavigationMenuContentEntry]]
  toggle_command : @cmd.Cmd
}

///|
priv struct NavigationMenuContentEntry {
  value : String
  content : @html.Html
}

///|
#cfg(target="js")
priv enum NavigationMenuMsg {
  NavigationActivate(String, Int)
  NavigationToggle(String, Int)
  NavigationClose
  NavigationNative(String, Int, Bool)
  NavigationSetFocus(Int)
}

///|
const NavigationMenuRootStyle : String = "position:relative;display:flex;width:max-content;max-width:100%;min-width:0;align-items:center;justify-content:center"

///|
const NavigationMenuListStyle : String = "display:flex;max-width:100%;flex-wrap:wrap;list-style:none;align-items:center;justify-content:center;gap:0.25rem;margin:0;padding:0"

///|
const NavigationMenuItemStyle : String = "position:relative;display:flex;align-items:center"

///|
const NavigationMenuTriggerStyle : String = "display:inline-flex;height:2.25rem;max-width:100%;min-width:0;align-items:center;justify-content:center;gap:0.375rem;--rui-nav-base-bg:var(--rui-background,oklch(1 0 0));--rui-nav-base-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-nav-base-border:transparent;--rui-nav-base-shadow:none;border:1px solid transparent;border-color:var(--rui-nav-border,var(--rui-nav-base-border,transparent));border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-nav-bg,var(--rui-nav-base-bg,var(--rui-background,oklch(1 0 0))));padding-inline:0.75rem;color:var(--rui-nav-fg,var(--rui-nav-base-fg,var(--rui-foreground,oklch(0.145 0 0))));box-shadow:var(--rui-nav-shadow,var(--rui-nav-base-shadow,none));font-size:0.875rem;line-height:1.25rem;font-weight:500;white-space:nowrap;outline-offset:2px"

///|
const NavigationMenuTriggerOpenStyle : String = "--rui-nav-base-bg:color-mix(in oklab,var(--rui-accent,oklch(0.97 0 0)) 50%,transparent);--rui-nav-base-fg:var(--rui-accent-foreground,oklch(0.205 0 0))"

///|
const NavigationMenuContentStyle : String = "position:fixed;inset:auto;left:var(--rui-floating-left,auto);top:var(--rui-floating-top,auto);z-index:50;display:block;width:min(32rem,calc(100vw - 1rem));max-height:calc(100vh - 1rem);overflow:auto;margin:0;border:1px solid color-mix(in oklab,var(--rui-foreground,oklch(0.145 0 0)) 10%,transparent);border-radius:var(--rui-radius,0.625rem);background:var(--rui-popover,oklch(1 0 0));padding:1rem;color:var(--rui-popover-foreground,oklch(0.145 0 0));box-shadow:0 12px 32px rgb(0 0 0 / 0.14);outline:none;transition:opacity 150ms ease,transform 150ms ease,visibility 150ms ease"

///|
const NavigationMenuViewportContentStyle : String = "position:relative;display:block;width:min(32rem,calc(100vw - 1rem));max-height:calc(100dvh - 1rem);overflow:auto;padding:1rem;color:var(--rui-popover-foreground,var(--rui-foreground,oklch(0.145 0 0)));outline:none"

///|
const NavigationMenuViewportStyle : String = "position:fixed;inset:auto;top:0;left:50%;z-index:50;--rui-navigation-viewport-half:min(16rem,calc(50vw - 0.5rem));width:min(32rem,calc(100vw - 1rem));max-width:calc(100vw - 1rem);max-height:calc(100dvh - 1rem);overflow:hidden;transform:translateX(-50%);position-try-fallbacks:flip-block;border:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:var(--rui-radius,0.625rem);background:var(--rui-popover,oklch(1 0 0));box-shadow:0 12px 32px rgb(0 0 0 / 0.14);transition:opacity 150ms ease,visibility 150ms ease"

///|
const NavigationMenuLinkStyle : String = "display:block;min-width:0;--rui-nav-base-bg:transparent;--rui-nav-base-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-nav-base-border:transparent;--rui-nav-base-shadow:none;border:1px solid transparent;border-color:var(--rui-nav-border,var(--rui-nav-base-border,transparent));border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-nav-bg,var(--rui-nav-base-bg,transparent));padding:0.625rem 0.75rem;color:var(--rui-nav-fg,var(--rui-nav-base-fg,var(--rui-foreground,oklch(0.145 0 0))));box-shadow:var(--rui-nav-shadow,var(--rui-nav-base-shadow,none));text-decoration:none;outline-offset:2px;overflow-wrap:anywhere"

///|
const NavigationMenuLinkActiveStyle : String = "--rui-nav-base-bg:color-mix(in oklab,var(--rui-accent,oklch(0.97 0 0)) 50%,transparent);--rui-nav-base-fg:var(--rui-accent-foreground,oklch(0.205 0 0))"

///|
const NavigationMenuIndicatorStyle : String = "position:absolute;top:100%;inset-inline:0;z-index:1;display:flex;height:0.375rem;align-items:flex-end;justify-content:center;overflow:hidden;transition:opacity 150ms ease,visibility 150ms ease"

///|
const NavigationMenuIndicatorArrowStyle : String = "position:relative;top:60%;width:0.5rem;height:0.5rem;flex:none;transform:rotate(45deg);border-radius:2px 0 0;background:var(--rui-border,oklch(0.922 0 0));box-shadow:0 4px 6px -1px rgb(0 0 0 / 0.1),0 2px 4px -2px rgb(0 0 0 / 0.1)"

///|
const NavigationMenuChevronBoxStyle : String = "display:inline-flex;width:1rem;height:1rem;flex-shrink:0;align-items:center;justify-content:center;transition:transform 150ms ease"

///|
const NavigationMenuChevronStyle : String = "display:block;width:0.4375rem;height:0.4375rem;border-right:1.5px solid currentColor;border-bottom:1.5px solid currentColor;transform:translateY(-0.125rem) rotate(45deg)"

///|
fn navigation_content_id(id : String, index : Int) -> String {
  id + "-content-\{index}"
}

///|
fn navigation_trigger_id(id : String, index : Int) -> String {
  id + "-trigger-\{index}"
}

///|
fn navigation_viewport_anchor_id(id : String) -> String {
  id + "-viewport-anchor"
}

///|
fn navigation_viewport_position_style(id : String) -> String {
  let anchor = popup_anchor_name(navigation_viewport_anchor_id(id))
  "position-anchor:\{anchor};top:calc(anchor(bottom) + 0.375rem);left:clamp(calc(var(--rui-navigation-viewport-half) + 0.5rem),anchor(center),calc(100vw - var(--rui-navigation-viewport-half) - 0.5rem))"
}

///|
#cfg(target="js")
priv struct NavigationMenuBinding {
  id : String
  root : @dom.Element
  document : @dom.Document
  activate : Ref[(String, Int) -> Unit]
  native_change : Ref[(String, Int, Bool) -> Unit]
  close : Ref[() -> Unit]
  set_focus : Ref[(Int) -> Unit]
  toggle_contents : Array[@dom.Element]
  close_timer : Ref[Int]
  outside_press : Ref[@dom.Listener]
}

///|
#cfg(target="js")
let navigation_menu_bindings : Map[String, NavigationMenuBinding] = Map([])

///|
#cfg(target="js")
fn navigation_menu_all_triggers(
  binding : NavigationMenuBinding,
) -> Array[@dom.Element] {
  binding.root.query_selector_all("[data-slot=\"navigation-menu-trigger\"]")
}

///|
#cfg(target="js")
fn navigation_menu_triggers(
  binding : NavigationMenuBinding,
) -> Array[@dom.Element] {
  navigation_menu_all_triggers(binding).filter(ui_element_is_enabled)
}

///|
#cfg(target="js")
fn navigation_menu_normalize_tab_stop(binding : NavigationMenuBinding) -> Unit {
  let all = navigation_menu_all_triggers(binding)
  let enabled = all.filter(ui_element_is_enabled)
  let mut target = ui_find_element(enabled, item => {
    item.get_attribute("aria-expanded").unwrap_or("") == "true"
  })
  if target is None {
    target = ui_find_element(enabled, item => {
      item.to_html_element() is Some(html) && html.get_tab_index() == 0
    })
  }
  if target is None {
    target = enabled.get(0)
  }
  for item in all {
    ui_set_element_tab_index(
      item,
      if target is Some(target) && item.is_same_node(target.as_node()) {
        0
      } else {
        -1
      },
    )
  }
}

///|
#cfg(target="js")
fn navigation_menu_open_trigger(
  binding : NavigationMenuBinding,
  trigger : @dom.Element,
) -> Unit {
  (binding.activate.val)(
    trigger.get_attribute("data-navigation-value").unwrap_or(""),
    ui_parse_int_or(
      trigger.get_attribute("data-navigation-index").unwrap_or(""),
      -1,
    ),
  )
}

///|
#cfg(target="js")
fn navigation_menu_content_for_index(
  root : @dom.Element,
  index : Int,
) -> @dom.Element? {
  ui_find_element(
    root.query_selector_all("[data-slot=\"navigation-menu-content\"]"),
    content => {
      ui_parse_int_or(
        content.get_attribute("data-navigation-index").unwrap_or(""),
        -1,
      ) ==
      index &&
      menu_element_is_visible(content)
    },
  )
}

///|
#cfg(target="js")
fn navigation_menu_focus_content(
  binding : NavigationMenuBinding,
  index : Int,
  attempt : Int,
) -> Unit {
  menu_request_frame(() => {
    guard ui_element_by_id(binding.id) is Some(root) && root.get_is_connected() else {
      return
    }
    if navigation_menu_content_for_index(root, index) is Some(content) {
      let selector = "a[href],button:not([disabled]),input:not([disabled]),select:not([disabled]),textarea:not([disabled]),[tabindex]:not([tabindex=\"-1\"])"
      let target = ui_find_element(
        content.query_selector_all(selector),
        menu_element_is_visible,
      ).unwrap_or(content)
      ui_focus_element(target)
    } else if attempt < 3 {
      navigation_menu_focus_content(binding, index, attempt + 1)
    }
  })
}

///|
#cfg(target="js")
fn navigation_menu_clear_close_timer(binding : NavigationMenuBinding) -> Unit {
  if binding.close_timer.val != 0 {
    if ui_has_window() {
      @dom.window().clear_timeout(binding.close_timer.val)
    }
    binding.close_timer.val = 0
  }
}

///|
#cfg(target="js")
fn navigation_menu_schedule_close(binding : NavigationMenuBinding) -> Unit {
  navigation_menu_clear_close_timer(binding)
  let finish = () => {
    binding.close_timer.val = 0
    if binding.root.get_is_connected() && !binding.root.matches(":focus-within") {
      (binding.close.val)()
    }
  }
  if ui_has_window() {
    binding.close_timer.val = @dom.window().set_timeout(finish, 100)
  } else {
    finish()
  }
}

///|
#cfg(target="js")
fn navigation_menu_bind_content_toggles(
  binding : NavigationMenuBinding,
) -> Unit {
  for
    content in binding.root.query_selector_all(
      "[data-slot=\"navigation-menu-content\"]",
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
          content.get_attribute("data-navigation-value").unwrap_or(""),
          ui_parse_int_or(
            content.get_attribute("data-navigation-index").unwrap_or(""),
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
fn navigation_menu_handle_keydown(
  binding : NavigationMenuBinding,
  event : @dom.KeyboardEvent,
) -> Unit {
  if event.get_default_prevented() {
    return
  }
  guard event.target().to_element() is Some(target) else { return }
  let trigger = target.closest("[data-slot=\"navigation-menu-trigger\"]")
  let content = target.closest("[data-slot=\"navigation-menu-content\"]")
  let key = event.key()
  if trigger is None && content is Some(content) && key == "Escape" {
    event.prevent_default()
    let index = ui_parse_int_or(
      content.get_attribute("data-navigation-index").unwrap_or(""),
      -1,
    )
    (binding.close.val)()
    let destination = ui_find_element(navigation_menu_all_triggers(binding), item => {
      ui_parse_int_or(
        item.get_attribute("data-navigation-index").unwrap_or(""),
        -1,
      ) ==
      index
    })
    if destination is Some(destination) {
      ui_focus_element(destination)
    }
    return
  }
  guard trigger is Some(trigger) else { return }
  let items = navigation_menu_triggers(binding)
  if items.length() == 0 {
    return
  }
  let mut current = 0
  for item_index, item in items {
    if item.is_same_node(trigger.as_node()) {
      current = item_index
    }
  }
  let rtl = ui_element_is_rtl(binding.root)
  let forward_key = if rtl { "ArrowLeft" } else { "ArrowRight" }
  let backward_key = if rtl { "ArrowRight" } else { "ArrowLeft" }
  let mut next : @dom.Element? = None
  if key == forward_key {
    next = items.get((current + 1) % items.length())
  } else if key == backward_key {
    next = items.get(
      if current == 0 {
        items.length() - 1
      } else {
        current - 1
      },
    )
  } else if key == "Home" {
    next = items.get(0)
  } else if key == "End" {
    next = items.get(items.length() - 1)
  }
  if key == "ArrowDown" {
    event.prevent_default()
    navigation_menu_open_trigger(binding, trigger)
    navigation_menu_focus_content(
      binding,
      ui_parse_int_or(
        trigger.get_attribute("data-navigation-index").unwrap_or(""),
        -1,
      ),
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
      navigation_menu_open_trigger(binding, next)
    }
  }
}

///|
#cfg(target="js")
fn bind_navigation_menu(
  id : String,
  activate : (String, Int) -> Unit,
  native_change : (String, Int, Bool) -> Unit,
  close : () -> Unit,
  set_focus : (Int) -> Unit,
) -> Unit {
  guard ui_element_by_id(id) is Some(root) else { return }
  let document = @dom.document()
  if navigation_menu_bindings.get(id) is Some(existing) {
    if existing.root.is_same_node(root.as_node()) {
      existing.activate.val = activate
      existing.native_change.val = native_change
      existing.close.val = close
      existing.set_focus.val = set_focus
      navigation_menu_bind_content_toggles(existing)
      navigation_menu_normalize_tab_stop(existing)
      return
    }
    navigation_menu_clear_close_timer(existing)
    existing.document.remove_event_listener_with_options(
      "pointerdown",
      existing.outside_press.val,
      capture=true,
    )
  }
  let binding : NavigationMenuBinding = {
    id,
    root,
    document,
    activate: Ref(activate),
    native_change: Ref(native_change),
    close: Ref(close),
    set_focus: Ref(set_focus),
    toggle_contents: [],
    close_timer: Ref(0),
    outside_press: Ref(_ => ()),
  }
  navigation_menu_bindings[id] = binding
  navigation_menu_bind_content_toggles(binding)
  navigation_menu_normalize_tab_stop(binding)
  root.add_event_listener("focusin", event => {
    guard event.target().to_element() is Some(target) else { return }
    guard target.closest("[data-slot=\"navigation-menu-trigger\"]")
      is Some(trigger) &&
      ui_element_is_enabled(trigger) else {
      return
    }
    let index = ui_parse_int_or(
      trigger.get_attribute("data-navigation-index").unwrap_or(""),
      -1,
    )
    for item in navigation_menu_all_triggers(binding) {
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
  root.add_event_listener("focusout", _ => {
    let finish = () => {
      let active_inside = binding.document.get_active_element() is Some(active) &&
        binding.root.contains(active.as_node())
      if binding.root.get_attribute("data-state").unwrap_or("") == "open" &&
        !active_inside {
        (binding.close.val)()
      }
    }
    if ui_has_window() {
      @dom.window().queue_microtask(finish)
    } else {
      finish()
    }
  })
  root.add_event_listener("click", event => {
    guard event.target().to_element() is Some(target) else { return }
    if target.closest("[data-slot=\"navigation-menu-link\"]") is Some(link) &&
      binding.root.contains(link.as_node()) &&
      ui_element_is_enabled(link) {
      (binding.close.val)()
    }
  })
  let outside_press : @dom.Listener = event => {
    if !binding.root.get_is_connected() {
      binding.document.remove_event_listener_with_options(
        "pointerdown",
        binding.outside_press.val,
        capture=true,
      )
      return
    }
    let inside = event.target().to_element() is Some(target) &&
      binding.root.contains(target.as_node())
    if binding.root.get_attribute("data-state").unwrap_or("") == "open" &&
      !inside {
      (binding.close.val)()
    }
  }
  binding.outside_press.val = outside_press
  document.add_event_listener_with_options(
    "pointerdown",
    outside_press,
    capture=true,
  )
  root.add_event_listener_with_options(
    "pointerenter",
    event => {
      navigation_menu_clear_close_timer(binding)
      guard event.target().to_element() is Some(target) else { return }
      if target.closest("[data-slot=\"navigation-menu-trigger\"]")
        is Some(trigger) &&
        ui_element_is_enabled(trigger) {
        navigation_menu_open_trigger(binding, trigger)
      }
    },
    capture=true,
  )
  root.add_event_listener("pointerleave", _ => {
    navigation_menu_schedule_close(binding)
  })
  root.add_event_listener("keydown", event => {
    if event.to_keyboard_event() is Some(keyboard_event) {
      navigation_menu_handle_keydown(binding, keyboard_event)
    }
  })
}

///|
#cfg(target="js")
fn navigation_bind_cmd(
  id : String,
  activate : @cmd.Emit[(String, Int)],
  native_change : @cmd.Emit[(String, Int, Bool)],
  close_command : @cmd.Cmd,
  set_focus : @cmd.Emit[Int],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, scheduler => {
    ui_after_mount(
      id,
      () => {
        bind_navigation_menu(
          id,
          (value, index) => scheduler.add(activate((value, index))),
          (value, index, open) => {
            scheduler.add(native_change((value, index, open)))
          },
          () => scheduler.add(close_command),
          index => scheduler.add(set_focus(index)),
        )
      },
      purpose="navigation-menu-bind",
    )
  })
}

///|
fn navigation_change_cmd(
  id : String,
  current : NavigationMenuModel,
  value : String?,
  index : Int,
  viewport : Bool,
) -> @cmd.Cmd {
  @cmd.batch([
    if !viewport && current.index >= 0 && current.value != value {
      floating_set_open_cmd(navigation_content_id(id, current.index), false)
    } else {
      @cmd.none
    },
    if !viewport && value is Some(_) {
      floating_set_open_cmd(navigation_content_id(id, index), true)
    } else {
      @cmd.none
    },
  ])
}

///|
#cfg(target="js")
pub fn navigation_menu(
  id~ : String,
  default_value? : String,
  viewport? : Bool = true,
  on_value_change? : @cmd.Emit[String?],
  aria_label? : String = "Main navigation",
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (NavigationMenuScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  let initial : NavigationMenuModel = {
    value: default_value,
    index: if default_value is Some(_) {
      0
    } else {
      -1
    },
    focus_index: -1,
  }
  let (model, emit) = @rabbita.create_state_with_init(
    init=emit => {
      (
        initial,
        @cmd.batch([
          navigation_bind_cmd(
            id + "-root",
            emit.map(pair => NavigationActivate(pair.0, pair.1)),
            emit.map(tuple => NavigationNative(tuple.0, tuple.1, tuple.2)),
            emit(NavigationClose),
            emit.map(index => NavigationSetFocus(index)),
          ),
          if viewport {
            @cmd.none
          } else {
            match default_value {
              Some(value) =>
                menu_open_marked_cmd(
                  id + "-root",
                  "navigation-menu-content",
                  emit.map(index => NavigationNative(value, index, true)),
                )
              None => @cmd.none
            }
          },
        ]),
      )
    },
    update=(current, msg, _) => {
      match msg {
        NavigationActivate(value, index) =>
          if current.value == Some(value) {
            (current, @cmd.none)
          } else {
            let next : NavigationMenuModel = {
              value: Some(value),
              index,
              focus_index: index,
            }
            (
              next,
              @cmd.batch([
                navigation_change_cmd(id, current, Some(value), index, viewport),
                if on_value_change is Some(notify) {
                  notify(Some(value))
                } else {
                  @cmd.none
                },
              ]),
            )
          }
        NavigationToggle(value, index) =>
          if current.value == Some(value) {
            (
              { value: None, index: -1, focus_index: index },
              @cmd.batch([
                if viewport {
                  @cmd.none
                } else {
                  floating_set_open_cmd(navigation_content_id(id, index), false)
                },
                if on_value_change is Some(notify) {
                  notify(None)
                } else {
                  @cmd.none
                },
              ]),
            )
          } else {
            (
              { value: Some(value), index, focus_index: index },
              @cmd.batch([
                navigation_change_cmd(id, current, Some(value), index, viewport),
                if on_value_change is Some(notify) {
                  notify(Some(value))
                } else {
                  @cmd.none
                },
              ]),
            )
          }
        NavigationClose =>
          if current.value is Some(_) {
            (
              { value: None, index: -1, focus_index: current.index },
              @cmd.batch([
                if viewport {
                  @cmd.none
                } else {
                  floating_set_open_cmd(
                    navigation_content_id(id, current.index),
                    false,
                  )
                },
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
        NavigationNative(value, index, open) =>
          if open {
            ({ value: Some(value), index, focus_index: index }, @cmd.none)
          } else if current.value == Some(value) {
            (
              { value: None, index: -1, focus_index: index },
              if on_value_change is Some(notify) {
                notify(None)
              } else {
                @cmd.none
              },
            )
          } else {
            (current, @cmd.none)
          }
        NavigationSetFocus(index) =>
          ({ ..current, focus_index: index }, @cmd.none)
      }
    },
  )
  model.view(model => {
    let scope : NavigationMenuScope = {
      id,
      model,
      counter: Ref(0),
      focus_claimed: Ref(false),
      viewport,
      contents: Ref([]),
      viewport_rendered: Ref(false),
      toggle: emit.map(pair => NavigationToggle(pair.0, pair.1)),
    }
    let element_attrs = menu_state_attrs(
      attrs,
      "navigation-menu",
      model.value is Some(_),
    )
    ignore(element_attrs.aria_label(aria_label))
    if model.value is Some(value) {
      ignore(element_attrs.data_set("value", value))
    }
    let rendered_children = children(scope)
    let automatic_viewport = if viewport && !scope.viewport_rendered.val {
      render_navigation_menu_viewport(
        scope,
        None,
        None,
        None,
        [],
        @html.nothing,
      )
    } else {
      @html.nothing
    }
    @html.nav(
      style=ui_styles(
        [UiBoxSizing, UiFontSans, UiTextRendering, NavigationMenuRootStyle],
        style,
      ),
      id=id + "-root",
      class?,
      title?,
      attrs=element_attrs,
      [rendered_children, automatic_viewport],
    )
  })
}

///|
#cfg(not(target="js"))
pub fn navigation_menu(
  id~ : String,
  default_value? : String,
  viewport? : Bool = true,
  on_value_change? : @cmd.Emit[String?],
  aria_label? : String = "Main navigation",
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (NavigationMenuScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  ignore(on_value_change)
  let model : NavigationMenuModel = {
    value: default_value,
    index: if default_value is Some(_) {
      0
    } else {
      -1
    },
    focus_index: -1,
  }
  let scope : NavigationMenuScope = {
    id,
    model,
    counter: Ref(0),
    focus_claimed: Ref(false),
    viewport,
    contents: Ref([]),
    viewport_rendered: Ref(false),
    toggle: menu_noop_emit(),
  }
  let element_attrs = menu_state_attrs(
    attrs,
    "navigation-menu",
    default_value is Some(_),
  )
  ignore(element_attrs.aria_label(aria_label))
  if default_value is Some(value) {
    ignore(element_attrs.data_set("value", value))
  }
  let rendered_children = children(scope)
  let automatic_viewport = if viewport && !scope.viewport_rendered.val {
    render_navigation_menu_viewport(scope, None, None, None, [], @html.nothing)
  } else {
    @html.nothing
  }
  @rabbita.Val::constant(
    @html.nav(
      style=ui_styles(
        [UiBoxSizing, UiFontSans, UiTextRendering, NavigationMenuRootStyle],
        style,
      ),
      id=id + "-root",
      class?,
      title?,
      attrs=element_attrs,
      [rendered_children, automatic_viewport],
    ),
  )
}

///|
/// Explicit Root spelling matching the compound-component API.
pub fn navigation_menu_root(
  id~ : String,
  default_value? : String,
  viewport? : Bool = true,
  on_value_change? : @cmd.Emit[String?],
  aria_label? : String = "Main navigation",
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (NavigationMenuScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  navigation_menu(
    id~,
    default_value?,
    viewport~,
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
pub fn[C : @html.IsChildren] navigation_menu_list(
  scope : NavigationMenuScope,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  ignore(scope)
  @html.ul(
    style=ui_styles([UiBoxSizing, NavigationMenuListStyle], style),
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "navigation-menu-list"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] navigation_menu_item(
  scope : NavigationMenuScope,
  value~ : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (NavigationMenuItemScope) -> C,
) -> @html.Html {
  let index = scope.counter.val
  scope.counter.val += 1
  let open = scope.model.value == Some(value)
  let item_scope : NavigationMenuItemScope = {
    id: scope.id,
    value,
    index,
    open,
    focus_index: scope.model.focus_index,
    focus_claimed: scope.focus_claimed,
    active_value_set: scope.model.value is Some(_),
    viewport: scope.viewport,
    contents: scope.contents,
    toggle_command: (scope.toggle)((value, index)),
  }
  @html.li(
    style=ui_styles([UiBoxSizing, NavigationMenuItemStyle], style),
    class?,
    title?,
    attrs=menu_state_attrs(attrs, "navigation-menu-item", open)
      .data_set("value", value)
      .data_set("navigation-index", "\{index}"),
    children(item_scope),
  )
}

///|
pub fn[C : @html.IsChildren] navigation_menu_trigger(
  scope : NavigationMenuItemScope,
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
    scope.open
  } else if scope.focus_index >= 0 {
    scope.focus_index == scope.index
  } else {
    !scope.focus_claimed.val
  }
  let tab_stop = !disabled && preferred
  let element_attrs = menu_state_attrs(
      attrs,
      "navigation-menu-trigger",
      scope.open,
    )
    .data_set("navigation-value", scope.value)
    .data_set("navigation-index", "\{scope.index}")
    .aria_expanded(ui_bool(scope.open))
    .aria_controls(navigation_content_id(scope.id, scope.index))
  ignore(element_attrs.tabindex(if tab_stop { 0 } else { -1 }))
  if tab_stop {
    scope.focus_claimed.val = true
  }
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
        UiTransition,
        NavigationMenuTriggerStyle,
        if scope.viewport {
          if scope.open {
            popup_anchor_style(navigation_viewport_anchor_id(scope.id))
          } else {
            ""
          }
        } else {
          popup_anchor_style(navigation_trigger_id(scope.id, scope.index))
        },
        if scope.open {
          NavigationMenuTriggerOpenStyle
        } else {
          ""
        },
        ui_disabled_style(disabled),
      ],
      style,
    ),
    id=navigation_trigger_id(scope.id, scope.index),
    class?,
    title?,
    type_="button",
    disabled~,
    attrs=element_attrs,
    [
      @html.span(style=[UiBoxSizing, "display:contents"], children),
      @html.span(
        style=[
          UiBoxSizing,
          NavigationMenuChevronBoxStyle,
          if scope.open {
            "transform:rotate(180deg)"
          } else {
            ""
          },
        ],
        attrs=@html.Attrs::build()
          .aria_hidden("true")
          .data_set("icon", "chevron-down"),
        @html.span(
          style=[UiBoxSizing, NavigationMenuChevronStyle],
          @html.nothing,
        ),
      ),
    ],
  )
}

///|
pub fn[C : @html.IsChildren] navigation_menu_content(
  scope : NavigationMenuItemScope,
  side_offset? : Int = 8,
  align_offset? : Int = 0,
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let trigger_id = navigation_trigger_id(scope.id, scope.index)
  let element_attrs = menu_state_attrs(
      attrs,
      "navigation-menu-content",
      scope.open,
    )
    .role("region")
    .tabindex(-1)
    .aria_labelledby(trigger_id)
    .data_set("trigger-id", trigger_id)
    .data_set("requested-side", "bottom")
    .data_set("requested-align", "center")
    .data_set("side", "bottom")
    .data_set("align", "center")
    .data_set("side-offset", "\{side_offset}")
    .data_set("align-offset", "\{align_offset}")
    .data_set("navigation-value", scope.value)
    .data_set("navigation-index", "\{scope.index}")
  if !scope.viewport {
    ignore(element_attrs.popover("auto"))
  }
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  }
  let content = @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        if scope.viewport {
          NavigationMenuViewportContentStyle
        } else {
          NavigationMenuContentStyle
        },
        if scope.viewport {
          ""
        } else {
          PopupTransition150Style
        },
        if scope.viewport {
          ""
        } else {
          popup_floating_anchor_style(
            trigger_id,
            Bottom,
            Center,
            side_offset,
            align_offset,
          )
        },
        if scope.viewport {
          ""
        } else {
          popup_state_style(scope.open)
        },
      ],
      style,
    ),
    id=navigation_content_id(scope.id, scope.index),
    class?,
    title?,
    attrs=element_attrs,
    children,
  )
  if scope.viewport {
    scope.contents.val.push({ value: scope.value, content })
    @html.nothing
  } else {
    content
  }
}

///|
fn render_navigation_menu_viewport(
  scope : NavigationMenuScope,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  custom : @html.Html,
) -> @html.Html {
  let viewport_children : Array[@html.Html] = []
  let open = scope.model.value is Some(_)
  for entry in scope.contents.val {
    if scope.model.value == Some(entry.value) {
      viewport_children.push(entry.content)
    }
  }
  viewport_children.push(custom)
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        NavigationMenuViewportStyle,
        navigation_viewport_position_style(scope.id),
        if scope.model.value is Some(_) {
          "visibility:visible;opacity:1;pointer-events:auto"
        } else {
          "visibility:hidden;opacity:0;pointer-events:none"
        },
      ],
      style,
    ),
    class?,
    title?,
    attrs=menu_state_attrs(attrs, "navigation-menu-viewport", open)
      .aria_hidden(ui_bool(!open))
      .inert(!open),
    viewport_children,
  )
}

///|
/// Render the shared viewport. Content parts registered by the active menu
/// item are mounted here; optional children are appended for custom chrome.
pub fn[C : @html.IsChildren] navigation_menu_viewport(
  scope : NavigationMenuScope,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  scope.viewport_rendered.val = true
  render_navigation_menu_viewport(
    scope,
    class,
    title,
    attrs,
    style,
    @html.div(style=[UiBoxSizing, "display:contents"], children),
  )
}

///|
pub fn[C : @html.IsChildren] navigation_menu_link(
  href~ : String,
  active? : Bool = false,
  target? : @html.Target = Self,
  rel? : String,
  download? : String,
  escape? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "navigation-menu-link")
    .data_set("active", ui_bool(active))
  if active {
    ignore(element_attrs.aria_current("page").data_set("state", "active"))
  }
  @html.a(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTransition,
        NavigationMenuLinkStyle,
        if active {
          NavigationMenuLinkActiveStyle
        } else {
          ""
        },
      ],
      style,
    ),
    id?,
    class?,
    title?,
    href~,
    target~,
    rel?,
    download?,
    attrs=element_attrs,
    children,
    escape~,
  )
}

///|
pub fn navigation_menu_indicator(
  scope : NavigationMenuItemScope,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  @html.span(
    style=ui_styles(
      [
        UiBoxSizing,
        NavigationMenuIndicatorStyle,
        if scope.open {
          "visibility:visible;opacity:1;pointer-events:none"
        } else {
          "visibility:hidden;opacity:0;pointer-events:none"
        },
      ],
      style,
    ),
    class?,
    attrs=menu_state_attrs(attrs, "navigation-menu-indicator", scope.open).aria_hidden(
      "true",
    ),
    @html.span(
      style=[UiBoxSizing, NavigationMenuIndicatorArrowStyle],
      @html.nothing,
    ),
  )
}
