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
  activate : @cmd.Emit[(String, Int)]
  toggle : @cmd.Emit[(String, Int)]
  close_command : @cmd.Cmd
  set_active : @cmd.Emit[Int]
  toggle_checked : @cmd.Emit[String]
  set_radio : @cmd.Emit[(String, String)]
  set_submenu : @cmd.Emit[MenuSubmenuChange]
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
#cfg(target="js")
extern "js" fn ffi_bind_menubar(
  id : String,
  activate : (String, Int, Bool) -> Unit,
  native_change : (String, Int, Bool) -> Unit,
  close : () -> Unit,
  set_focus : (Int) -> Unit,
) -> Unit =
  #| (id, activate, nativeChange, close, setFocus) => {
  #|   const root = document.getElementById(id)
  #|   if (!root) return
  #|   root.__ruiMenubarActivate = activate
  #|   root.__ruiMenubarNative = nativeChange
  #|   root.__ruiMenubarClose = close
  #|   root.__ruiMenubarFocus = setFocus
  #|   root.querySelectorAll('[data-slot="menubar-content"]').forEach(content => {
  #|     if (content.__ruiMenubarToggleBound) return
  #|     content.__ruiMenubarToggleBound = true
  #|     content.addEventListener("toggle", event => {
  #|       const open = event.newState
  #|         ? event.newState === "open"
  #|         : content.matches(":popover-open")
  #|       root.__ruiMenubarNative?.(
  #|         content.dataset.menubarValue || "",
  #|         Number(content.dataset.menubarIndex || -1),
  #|         open,
  #|       )
  #|     })
  #|   })
  #|   if (root.__ruiMenubarBound) return
  #|   root.__ruiMenubarBound = true
  #|   const triggers = () => Array.from(
  #|     root.querySelectorAll('[data-slot="menubar-trigger"]')
  #|   ).filter(item => !item.disabled)
  #|   const openTrigger = (trigger, focusContent = false) => {
  #|     if (!trigger) return
  #|     root.__ruiMenubarActivate?.(
  #|       trigger.dataset.menubarValue || "",
  #|       Number(trigger.dataset.menubarIndex || -1),
  #|       focusContent,
  #|     )
  #|   }
  #|   const isVisible = node => {
  #|     if (!node || node.disabled || node.getAttribute("aria-disabled") === "true") return false
  #|     if (node.hidden || node.closest?.("[inert]") || node.getClientRects().length === 0) return false
  #|     const style = getComputedStyle(node)
  #|     return style.display !== "none" && style.visibility !== "hidden"
  #|   }
  #|   const nextFrame = callback => {
  #|     if (typeof requestAnimationFrame === "function") requestAnimationFrame(callback)
  #|     else setTimeout(callback, 0)
  #|   }
  #|   const focusMenuIndex = (index, last, attempt = 0, stableFrames = 0) => {
  #|     // A menu change patches the content before the browser finishes closing
  #|     // the previous popover. Always resolve the current root and item so a
  #|     // detached node cannot receive focus.
  #|     const liveRoot = document.getElementById(id)
  #|     const content = Array.from(liveRoot?.querySelectorAll('[data-slot="menubar-content"]') || [])
  #|       .find(node => Number(node.dataset.menubarIndex || -1) === index && isVisible(node))
  #|     const items = Array.from(content?.querySelectorAll('[data-menu-index]') || [])
  #|       .filter(node => isVisible(node) && node.closest('[role="menu"]') === content)
  #|     const target = last ? items[items.length - 1] : items[0]
  #|     if (target) {
  #|       target.focus({ preventScroll: true })
  #|       const focused = document.activeElement === target
  #|       const nextStableFrames = focused ? stableFrames + 1 : 0
  #|       // Native popover focus restoration can run after the first focus.
  #|       // Keep the keyboard destination stable for two subsequent frames.
  #|       if (nextStableFrames >= 3 || attempt >= 20) return
  #|       nextFrame(() => focusMenuIndex(index, last, attempt + 1, nextStableFrames))
  #|       return
  #|     }
  #|     if (attempt < 20) {
  #|       nextFrame(() => focusMenuIndex(index, last, attempt + 1, 0))
  #|     }
  #|   }
  #|   const focusMenuEdge = (trigger, last) => {
  #|     const index = Number(trigger.dataset.menubarIndex || -1)
  #|     focusMenuIndex(index, last)
  #|   }
  #|   root.addEventListener("focusin", event => {
  #|     const trigger = event.target.closest?.('[data-slot="menubar-trigger"]')
  #|     if (!trigger || trigger.disabled) return
  #|     const index = Number(trigger.dataset.menubarIndex || -1)
  #|     triggers().forEach(item => item.tabIndex = item === trigger ? 0 : -1)
  #|     if (Number.isInteger(index)) root.__ruiMenubarFocus?.(index)
  #|   })
  #|   root.addEventListener("pointermove", event => {
  #|     if (root.dataset.state !== "open") return
  #|     const trigger = event.target.closest?.('[data-slot="menubar-trigger"]')
  #|     if (!trigger || trigger.disabled) return
  #|     // Pointer switching must also move focus off the trigger that opened
  #|     // the menubar. Otherwise its :focus highlight survives beside the
  #|     // newly opened trigger's data-state highlight.
  #|     if (document.activeElement !== trigger) {
  #|       trigger.focus({ preventScroll: true })
  #|     }
  #|     openTrigger(trigger)
  #|   })
  #|   root.addEventListener("keydown", event => {
  #|     if (event.defaultPrevented) return
  #|     const trigger = event.target.closest?.('[data-slot="menubar-trigger"]')
  #|     const content = event.target.closest?.('[data-slot="menubar-content"]')
  #|     const rtl = typeof getComputedStyle === "function"
  #|       && getComputedStyle(root).direction === "rtl"
  #|     const forwardKey = rtl ? "ArrowLeft" : "ArrowRight"
  #|     const backwardKey = rtl ? "ArrowRight" : "ArrowLeft"
  #|     if (!trigger && content && (event.key === "ArrowRight" || event.key === "ArrowLeft")) {
  #|       const menuItem = event.target.closest?.('[data-menu-index]')
  #|       if (event.key === forwardKey && menuItem?.dataset.submenuKey) return
  #|       if (event.key === backwardKey && menuItem?.closest?.('[data-submenu-owner]')) return
  #|       const items = triggers()
  #|       if (!items.length) return
  #|       const index = Number(content.dataset.menubarIndex || 0)
  #|       const current = Math.max(0, items.findIndex(item => Number(item.dataset.menubarIndex || -1) === index))
  #|       const nextPosition = event.key === forwardKey
  #|         ? (current + 1) % items.length
  #|         : (current - 1 + items.length) % items.length
  #|       const next = items[nextPosition]
  #|       const nextIndex = Number(next.dataset.menubarIndex || -1)
  #|       event.preventDefault()
  #|       next.focus({ preventScroll: true })
  #|       openTrigger(next, true)
  #|       return
  #|     }
  #|     if (!trigger) return
  #|     const items = triggers()
  #|     if (!items.length) return
  #|     const current = Math.max(0, items.indexOf(trigger))
  #|     let next = null
  #|     if (event.key === forwardKey) next = items[(current + 1) % items.length]
  #|     if (event.key === backwardKey) next = items[(current - 1 + items.length) % items.length]
  #|     if (event.key === "Home") next = items[0]
  #|     if (event.key === "End") next = items[items.length - 1]
  #|     if (event.key === "ArrowDown" || event.key === "ArrowUp") {
  #|       event.preventDefault()
  #|       openTrigger(trigger)
  #|       focusMenuEdge(trigger, event.key === "ArrowUp")
  #|       return
  #|     }
  #|     if (event.key === "Escape") {
  #|       event.preventDefault()
  #|       root.__ruiMenubarClose?.()
  #|       trigger.focus()
  #|       return
  #|     }
  #|     if (next) {
  #|       event.preventDefault()
  #|       next.focus()
  #|       if (root.dataset.state === "open") openTrigger(next)
  #|     }
  #|   })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_focus_menubar_content(id : String, index : Int) -> Bool =
  #| (id, index) => {
  #|   const root = document.getElementById(id)
  #|   if (!root) return false
  #|   const isVisible = node => {
  #|     if (!node || node.disabled || node.getAttribute("aria-disabled") === "true") return false
  #|     if (node.hidden || node.closest?.("[inert]") || node.getClientRects().length === 0) return false
  #|     const style = getComputedStyle(node)
  #|     return style.display !== "none" && style.visibility !== "hidden"
  #|   }
  #|   const content = Array.from(root.querySelectorAll('[data-slot="menubar-content"]'))
  #|     .find(node => Number(node.dataset.menubarIndex || -1) === index && isVisible(node))
  #|   if (!content || content.dataset.state !== "open") return false
  #|   const target = Array.from(content.querySelectorAll("[data-menu-index]"))
  #|     .find(node => isVisible(node) && node.closest('[role="menu"]') === content)
  #|   if (!target) return false
  #|   if (document.activeElement !== target) target.focus({ preventScroll: true })
  #|   return document.activeElement === target
  #| }

///|
#cfg(target="js")
fn menubar_focus_content_cmd(id : String, index : Int) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, _ => {
    ui_after_ready("menubar-focus-content:" + id, () => {
      ffi_focus_menubar_content(id, index)
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
  @cmd.custom_cmd(kind=@cmd.AfterRender, scheduler => {
    ui_after_mount(
      id,
      () => {
        ffi_bind_menubar(
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
  activate : @cmd.Emit[(String, Int)],
  toggle : @cmd.Emit[(String, Int)],
  close_command : @cmd.Cmd,
  set_active : @cmd.Emit[Int],
  toggle_checked : @cmd.Emit[String],
  set_radio : @cmd.Emit[(String, String)],
  set_submenu : @cmd.Emit[MenuSubmenuChange],
) -> MenubarScope {
  {
    id,
    model,
    counter: Ref(0),
    focus_claimed: Ref(false),
    activate,
    toggle,
    close_command,
    set_active,
    toggle_checked,
    set_radio,
    set_submenu,
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
    update=(emit, msg, current) => {
      match msg {
        MenubarActivate(value, index) =>
          if current.active_value == Some(value) {
            (current, @cmd.none)
          } else {
            let next = {
              ..current,
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
            ..current,
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
          if current.active_value == Some(value) {
            (
              {
                ..current,
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
              ..current,
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
                ..current,
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
                  ..current,
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
                ..current,
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
      emit.map(pair => MenubarActivate(pair.0, pair.1)),
      emit.map(pair => MenubarToggle(pair.0, pair.1)),
      emit(MenubarClose),
      emit.map(index => MenubarSetActive(index)),
      emit.map(value => MenubarToggleChecked(value)),
      emit.map(pair => MenubarSetRadio(pair.0, pair.1)),
      emit.map(value => MenubarSetSubmenu(value)),
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
    menu_noop_emit(),
    @cmd.none,
    menu_noop_emit(),
    menu_noop_emit(),
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
    open_command: (scope.activate)((value, index)),
    close_command: scope.close_command,
    toggle_command: (scope.toggle)((value, index)),
    set_active: scope.set_active,
    toggle_checked: scope.toggle_checked,
    set_radio: scope.set_radio,
    set_submenu: scope.set_submenu,
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
    MenuIndicatorInlineStart,
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
    MenuIndicatorInlineStart,
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
