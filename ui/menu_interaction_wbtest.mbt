///|
test "submenu state keeps ancestors open and closes only the requested branch" {
  let parent = "parent::submenu-0"
  let child = "child::submenu-1"
  let opened_parent = menu_update_submenus([], MenuOpenSubmenu(parent))
  let opened_child = menu_update_submenus(opened_parent, MenuOpenSubmenu(child))
  assert_eq(opened_child, [parent, child])
  assert_eq(menu_update_submenus(opened_child, MenuCloseSubmenu(child)), [
    parent,
  ])
  assert_eq(menu_update_submenus(opened_child, MenuCloseSubmenu(parent)), [])
}

///|
test "submenu state ignores duplicate opens and can close the whole tree" {
  let key = "share::submenu-2"
  let opened = menu_update_submenus([key], MenuOpenSubmenu(key))
  assert_eq(opened, [key])
  assert_true(menu_submenu_open(opened, key))
  assert_eq(menu_update_submenus(opened, MenuCloseAllSubmenus), [])
}

///|
test "submenu switching replaces only the active sibling branch" {
  let parent = "parent::submenu-0"
  let child_a = "child-a::submenu-1"
  let grandchild = "grandchild::submenu-2"
  let child_b = "child-b::submenu-3"
  assert_eq(
    menu_update_submenus(
      [parent, child_a, grandchild],
      MenuSwitchSubmenu(parent, child_b),
    ),
    [parent, child_b],
  )
  assert_eq(
    menu_update_submenus(
      [parent, child_a, grandchild],
      MenuCloseSubmenusUnder(parent),
    ),
    [parent],
  )
}

///|
test "root submenu switching is atomic during rapid pointer movement" {
  let first = "first::submenu-0"
  let second = "second::submenu-1"
  assert_eq(menu_update_submenus([first], MenuSwitchSubmenu("", second)), [
    second,
  ])
  assert_eq(menu_update_submenus([second], MenuCloseSubmenusUnder("")), [])
}

///|
#cfg(target="js")
extern "js" fn ffi_install_manual_light_dismiss_fixture(id : String) -> Unit =
  #| id => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const documentListeners = {}
  #|   const popupListeners = {}
  #|   const triggerListeners = {}
  #|   const style = {}
  #|   const inside = {}
  #|   let open = false
  #|   let hides = 0
  #|   const trigger = {
  #|     isConnected: true,
  #|     addEventListener: (type, callback) => { triggerListeners[type] = callback },
  #|     clientWidth: 80,
  #|     clientHeight: 32,
  #|     getBoundingClientRect: () => ({
  #|       left: 40,
  #|       top: 40,
  #|       right: 120,
  #|       bottom: 72,
  #|       width: 80,
  #|       height: 32,
  #|     }),
  #|   }
  #|   const popup = {
  #|     isConnected: true,
  #|     dataset: { lightDismiss: "true", restoreFocus: "false" },
  #|     matches: selector => selector === ":popover-open" && open,
  #|     addEventListener: (type, callback) => { popupListeners[type] = callback },
  #|     removeEventListener: (type, callback) => {
  #|       if (popupListeners[type] === callback) delete popupListeners[type]
  #|     },
  #|     contains: target => target === inside,
  #|     closest: () => null,
  #|     offsetWidth: 120,
  #|     offsetHeight: 100,
  #|     getBoundingClientRect: () => ({ width: 120, height: 100 }),
  #|     style: {
  #|       setProperty: (key, value) => { style[key] = value },
  #|       getPropertyValue: key => style[key] || "",
  #|     },
  #|     showPopover() {
  #|       if (open) return
  #|       open = true
  #|       popupListeners.toggle?.({ newState: "open" })
  #|     },
  #|     hidePopover() {
  #|       if (!open) return
  #|       open = false
  #|       hides += 1
  #|       popupListeners.toggle?.({ newState: "closed" })
  #|     },
  #|   }
  #|   const fixture = globalThis.__ruiManualLightDismissFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     floatingStack: globalThis.__ruiFloatingStack,
  #|     hadFloatingStack: own("__ruiFloatingStack"),
  #|     computedStyle: globalThis.getComputedStyle,
  #|     hadComputedStyle: own("getComputedStyle"),
  #|     documentListeners,
  #|     popupListeners,
  #|     popup,
  #|     trigger,
  #|     inside,
  #|     style,
  #|     triggerListeners,
  #|     point: { x: -1, y: -1 },
  #|     hides: () => hides,
  #|     open: () => open,
  #|     closes: 0,
  #|     closeRequests: 0,
  #|   }
  #|   globalThis.__ruiFloatingStack = []
  #|   globalThis.document = {
  #|     activeElement: null,
  #|     body: {},
  #|     documentElement: { clientWidth: 320, clientHeight: 240 },
  #|     getElementById: value => value === id
  #|       ? popup
  #|       : value === `${id}-trigger` ? trigger : null,
  #|     addEventListener: (type, callback) => { documentListeners[type] = callback },
  #|   }
  #|   globalThis.getComputedStyle = () => ({
  #|     opacity: "0",
  #|     transitionDuration: "0.1s",
  #|     transitionDelay: "0s",
  #|   })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_fire_manual_light_dismiss_fixture(inside : Bool) -> Unit =
  #| inside => {
  #|   const fixture = globalThis.__ruiManualLightDismissFixture
  #|   const target = inside ? fixture.inside : {}
  #|   fixture.documentListeners.pointerdown?.({
  #|     target,
  #|     composedPath: () => [target],
  #|   })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_fire_context_press_open_release_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiManualLightDismissFixture
  #|   fixture.documentListeners.pointerdown?.({
  #|     target: fixture.trigger,
  #|     composedPath: () => [fixture.trigger],
  #|   })
  #|   fixture.triggerListeners.contextmenu?.({
  #|     defaultPrevented: false,
  #|     preventDefault() {},
  #|     clientX: 300,
  #|     clientY: 200,
  #|   })
  #|   fixture.documentListeners.pointerup?.({
  #|     target: fixture.trigger,
  #|     composedPath: () => [fixture.trigger],
  #|   })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_manual_light_dismiss_fixture_open() -> Bool =
  #| () => Boolean(globalThis.__ruiManualLightDismissFixture?.open())

///|
#cfg(target="js")
extern "js" fn ffi_manual_light_dismiss_position(key : String) -> String =
  #| key => globalThis.__ruiManualLightDismissFixture?.style?.[key] || ""

///|
#cfg(target="js")
extern "js" fn ffi_manual_context_point(axis : String) -> Int =
  #| axis => globalThis.__ruiManualLightDismissFixture?.point?.[axis] ?? -1

///|
#cfg(target="js")
extern "js" fn ffi_manual_context_record_point(x : Int, y : Int) -> Unit =
  #| (x, y) => { globalThis.__ruiManualLightDismissFixture.point = { x, y } }

///|
#cfg(target="js")
extern "js" fn ffi_manual_light_dismiss_fixture_closed() -> Int =
  #| () => globalThis.__ruiManualLightDismissFixture?.closes ?? 0

///|
#cfg(target="js")
extern "js" fn ffi_mark_manual_light_dismiss_fixture_closed() -> Unit =
  #| () => { globalThis.__ruiManualLightDismissFixture.closes += 1 }

///|
#cfg(target="js")
extern "js" fn ffi_manual_light_dismiss_fixture_hides() -> Int =
  #| () => globalThis.__ruiManualLightDismissFixture?.hides() ?? 0

///|
#cfg(target="js")
extern "js" fn ffi_mark_manual_context_close_requested() -> Unit =
  #| () => { globalThis.__ruiManualLightDismissFixture.closeRequests += 1 }

///|
#cfg(target="js")
extern "js" fn ffi_manual_context_close_requests() -> Int =
  #| () => globalThis.__ruiManualLightDismissFixture?.closeRequests ?? 0

///|
#cfg(target="js")
extern "js" fn ffi_mark_manual_context_closed_state() -> Unit =
  #| () => { globalThis.__ruiManualLightDismissFixture.popup.dataset.state = "closed" }

///|
#cfg(target="js")
extern "js" fn ffi_fire_manual_context_transition_end() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiManualLightDismissFixture
  #|   fixture.popupListeners.transitionend?.({
  #|     target: fixture.popup,
  #|     propertyName: "opacity",
  #|   })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_restore_manual_light_dismiss_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiManualLightDismissFixture
  #|   if (!fixture) return
  #|   const restore = (key, had, value) => {
  #|     if (had) globalThis[key] = value
  #|     else delete globalThis[key]
  #|   }
  #|   restore("document", fixture.hadDocument, fixture.document)
  #|   restore(
  #|     "__ruiFloatingStack",
  #|     fixture.hadFloatingStack,
  #|     fixture.floatingStack,
  #|   )
  #|   restore(
  #|     "getComputedStyle",
  #|     fixture.hadComputedStyle,
  #|     fixture.computedStyle,
  #|   )
  #|   delete globalThis.__ruiManualLightDismissFixture
  #| }

///|
#cfg(target="js")
test "right-button press contextmenu and release keeps manual menu open" {
  ffi_install_manual_light_dismiss_fixture("manual-context-menu")
  ffi_bind_floating_sync("manual-context-menu", open => {
    if !open {
      ffi_mark_manual_light_dismiss_fixture_closed()
    }
  })
  ffi_bind_context_menu_close(
    "manual-context-menu", ffi_mark_manual_context_close_requested,
  )
  ffi_bind_context_menu_trigger("manual-context-menu-trigger", (
    x,
    y,
    point_x,
    point_y,
  ) => {
    ffi_manual_context_record_point(point_x, point_y)
    ffi_show_context_menu("manual-context-menu", x, y, point_x, point_y)
  })
  ffi_fire_context_press_open_release_fixture()
  let open_after_release = ffi_manual_light_dismiss_fixture_open()
  let release_hides = ffi_manual_light_dismiss_fixture_hides()
  let left = ffi_manual_light_dismiss_position("--rui-floating-left")
  let top = ffi_manual_light_dismiss_position("--rui-floating-top")
  let point_x = ffi_manual_context_point("x")
  let point_y = ffi_manual_context_point("y")
  ffi_fire_manual_light_dismiss_fixture(true)
  let inside_hides = ffi_manual_light_dismiss_fixture_hides()
  ffi_fire_manual_light_dismiss_fixture(false)
  let outside_hides = ffi_manual_light_dismiss_fixture_hides()
  let close_requests = ffi_manual_context_close_requests()
  let open_before_exit = ffi_manual_light_dismiss_fixture_open()
  ffi_mark_manual_context_closed_state()
  ffi_hide_context_menu_after_transition("manual-context-menu")
  let hides_before_transition_end = ffi_manual_light_dismiss_fixture_hides()
  let open_before_transition_end = ffi_manual_light_dismiss_fixture_open()
  ffi_fire_manual_context_transition_end()
  let hides_after_transition_end = ffi_manual_light_dismiss_fixture_hides()
  let open_after_transition_end = ffi_manual_light_dismiss_fixture_open()
  let closes = ffi_manual_light_dismiss_fixture_closed()
  ffi_restore_manual_light_dismiss_fixture()
  assert_true(open_after_release)
  assert_eq(release_hides, 0)
  assert_eq(left, "192px")
  assert_eq(top, "132px")
  assert_eq(point_x, 80)
  assert_eq(point_y, 32)
  assert_eq(inside_hides, 0)
  assert_eq(outside_hides, 0)
  assert_eq(close_requests, 1)
  assert_true(open_before_exit)
  assert_eq(hides_before_transition_end, 0)
  assert_true(open_before_transition_end)
  assert_eq(hides_after_transition_end, 1)
  assert_false(open_after_transition_end)
  assert_eq(closes, 1)
}

///|
#cfg(target="js")
extern "js" fn ffi_install_submenu_position_fixture(id : String) -> Unit =
  #| id => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const props = {}
  #|   const listeners = {}
  #|   const viewportListeners = {}
  #|   const fixture = globalThis.__ruiSubmenuPositionFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     window: globalThis.window,
  #|     hadWindow: own("window"),
  #|     css: globalThis.CSS,
  #|     hadCss: own("CSS"),
  #|     computed: globalThis.getComputedStyle,
  #|     hadComputed: own("getComputedStyle"),
  #|     raf: globalThis.requestAnimationFrame,
  #|     hadRaf: own("requestAnimationFrame"),
  #|     roots: globalThis.__ruiMenuSubmenuRoots,
  #|     hadRoots: own("__ruiMenuSubmenuRoots"),
  #|     props,
  #|     listeners,
  #|     viewportListeners,
  #|     pendingFrame: null,
  #|     submenuOpen: false,
  #|     triggerRect: { left: 280, right: 312, top: 180, bottom: 212 },
  #|   }
  #|   const wrapper = {
  #|     isConnected: true,
  #|     dataset: { submenuKey: "submenu-key" },
  #|     getBoundingClientRect: () => ({
  #|       left: 0,
  #|       right: 0,
  #|       top: 0,
  #|       bottom: 0,
  #|     }),
  #|   }
  #|   const trigger = {
  #|     isConnected: true,
  #|     dataset: { menuIndex: "3", submenuKey: "submenu-key" },
  #|     getBoundingClientRect: () => fixture.triggerRect,
  #|   }
  #|   const content = {
  #|     isConnected: true,
  #|     dataset: { state: "open", submenuOwner: "submenu-key" },
  #|     offsetWidth: 120,
  #|     offsetHeight: 100,
  #|     getBoundingClientRect: () => ({ width: 120, height: 100 }),
  #|     matches: selector => selector === ":popover-open" && fixture.submenuOpen,
  #|     showPopover: () => { fixture.submenuOpen = true },
  #|     hidePopover: () => { fixture.submenuOpen = false },
  #|     style: {
  #|       setProperty: (key, value) => { props[key] = value },
  #|       removeProperty: key => { delete props[key] },
  #|     },
  #|   }
  #|   const root = {
  #|     isConnected: true,
  #|     querySelectorAll: selector => selector === "[data-submenu-owner]"
  #|       ? [content]
  #|       : selector === "[data-submenu-key]" ? [wrapper, trigger]
  #|       : selector === "[data-menu-index][data-submenu-key]" ? [trigger] : [],
  #|   }
  #|   globalThis.document = {
  #|     documentElement: { clientWidth: 320, clientHeight: 240 },
  #|     getElementById: value => value === id ? root : null,
  #|   }
  #|   globalThis.window = {
  #|     addEventListener: (type, callback) => { listeners[type] = callback },
  #|     visualViewport: {
  #|       offsetLeft: 0,
  #|       offsetTop: 0,
  #|       width: 320,
  #|       height: 240,
  #|       addEventListener: (type, callback) => { viewportListeners[type] = callback },
  #|     },
  #|   }
  #|   globalThis.CSS = { supports: () => false }
  #|   globalThis.getComputedStyle = () => ({ direction: "ltr" })
  #|   globalThis.requestAnimationFrame = callback => {
  #|     fixture.pendingFrame = callback
  #|     return 1
  #|   }
  #|   globalThis.__ruiMenuSubmenuRoots = new Set()
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_submenu_position_value(key : String) -> String =
  #| key => globalThis.__ruiSubmenuPositionFixture?.props?.[key] || ""

///|
#cfg(target="js")
extern "js" fn ffi_submenu_position_side() -> String =
  #| () => {
  #|   const fixture = globalThis.__ruiSubmenuPositionFixture
  #|   const root = globalThis.document?.getElementById?.("submenu-root")
  #|   const content = root?.querySelectorAll?.("[data-submenu-owner]")?.[0]
  #|   return content?.dataset?.side || ""
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_submenu_fixture_open() -> Bool =
  #| () => Boolean(globalThis.__ruiSubmenuPositionFixture?.submenuOpen)

///|
#cfg(target="js")
extern "js" fn ffi_mark_submenu_fixture_closed() -> Unit =
  #| () => {
  #|   const root = globalThis.document?.getElementById?.("submenu-root")
  #|   const content = root?.querySelectorAll?.("[data-submenu-owner]")?.[0]
  #|   if (content) content.dataset.state = "closed"
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_move_and_scroll_submenu_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiSubmenuPositionFixture
  #|   fixture.triggerRect = { left: 20, right: 52, top: 40, bottom: 72 }
  #|   fixture.listeners.scroll?.()
  #|   const frame = fixture.pendingFrame
  #|   fixture.pendingFrame = null
  #|   frame?.()
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_restore_submenu_position_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiSubmenuPositionFixture
  #|   if (!fixture) return
  #|   const restore = (key, had, value) => {
  #|     if (had) globalThis[key] = value
  #|     else delete globalThis[key]
  #|   }
  #|   restore("document", fixture.hadDocument, fixture.document)
  #|   restore("window", fixture.hadWindow, fixture.window)
  #|   restore("CSS", fixture.hadCss, fixture.css)
  #|   restore("getComputedStyle", fixture.hadComputed, fixture.computed)
  #|   restore("requestAnimationFrame", fixture.hadRaf, fixture.raf)
  #|   restore("__ruiMenuSubmenuRoots", fixture.hadRoots, fixture.roots)
  #|   delete globalThis.__ruiSubmenuPositionFixture
  #| }

///|
#cfg(target="js")
test "submenu fallback flips at viewport edges and follows scroll" {
  ffi_install_submenu_position_fixture("submenu-root")
  ffi_position_menu_submenus("submenu-root")
  let opened = ffi_submenu_fixture_open()
  let first_side = ffi_submenu_position_side()
  let first_left = ffi_submenu_position_value("--rui-submenu-left")
  let first_top = ffi_submenu_position_value("--rui-submenu-top")
  ffi_move_and_scroll_submenu_fixture()
  let moved_side = ffi_submenu_position_side()
  let moved_left = ffi_submenu_position_value("--rui-submenu-left")
  let moved_top = ffi_submenu_position_value("--rui-submenu-top")
  ffi_mark_submenu_fixture_closed()
  ffi_position_menu_submenus("submenu-root")
  let closed = !ffi_submenu_fixture_open()
  ffi_restore_submenu_position_fixture()
  assert_true(opened)
  assert_eq(first_side, "left")
  assert_eq(first_left, "156px")
  assert_eq(first_top, "132px")
  assert_eq(moved_side, "right")
  assert_eq(moved_left, "56px")
  assert_eq(moved_top, "40px")
  assert_true(closed)
}

///|
#cfg(target="js")
extern "js" fn ffi_install_menu_focus_fixture(
  id : String,
  delayed : Bool,
  edge : String,
) -> Unit =
  #| (id, delayed, edge) => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   globalThis.__ruiMenuFocusFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     requestAnimationFrame: globalThis.requestAnimationFrame,
  #|     hadRequestAnimationFrame: own("requestAnimationFrame"),
  #|     getComputedStyle: globalThis.getComputedStyle,
  #|     hadGetComputedStyle: own("getComputedStyle"),
  #|     visible: !delayed,
  #|     focusedIndex: -1,
  #|   }
  #|   const fixture = globalThis.__ruiMenuFocusFixture
  #|   const makeItem = index => ({
  #|     disabled: false,
  #|     hidden: false,
  #|     dataset: { menuIndex: String(index) },
  #|     getAttribute: () => null,
  #|     closest: () => null,
  #|     getClientRects: () => fixture.visible ? [{}] : [],
  #|     focus: () => { fixture.focusedIndex = index },
  #|   })
  #|   const items = [makeItem(7), makeItem(9)]
  #|   const root = {
  #|     dataset: { state: "open" },
  #|     querySelectorAll: () => items,
  #|   }
  #|   globalThis.document = { getElementById: value => value === id ? root : null }
  #|   globalThis.getComputedStyle = () => ({ display: "block", visibility: "visible" })
  #|   globalThis.requestAnimationFrame = callback => {
  #|     fixture.visible = true
  #|     callback()
  #|     return 1
  #|   }
  #|   const pending = globalThis.__ruiMenuPendingEdges ||= new Map()
  #|   if (edge) pending.set(id, edge)
  #|   else pending.delete(id)
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_menu_focus_fixture_index() -> Int =
  #| () => globalThis.__ruiMenuFocusFixture?.focusedIndex ?? -1

///|
#cfg(target="js")
extern "js" fn ffi_restore_menu_focus_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiMenuFocusFixture
  #|   if (!fixture) return
  #|   const restore = (key, had, value) => {
  #|     if (had) globalThis[key] = value
  #|     else delete globalThis[key]
  #|   }
  #|   restore("document", fixture.hadDocument, fixture.document)
  #|   restore(
  #|     "requestAnimationFrame",
  #|     fixture.hadRequestAnimationFrame,
  #|     fixture.requestAnimationFrame,
  #|   )
  #|   restore("getComputedStyle", fixture.hadGetComputedStyle, fixture.getComputedStyle)
  #|   delete globalThis.__ruiMenuFocusFixture
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_install_menu_trigger_focus_fixture(id : String) -> Unit =
  #| id => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const listeners = {}
  #|   const fixture = globalThis.__ruiMenuFocusFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     requestAnimationFrame: globalThis.requestAnimationFrame,
  #|     hadRequestAnimationFrame: own("requestAnimationFrame"),
  #|     getComputedStyle: globalThis.getComputedStyle,
  #|     hadGetComputedStyle: own("getComputedStyle"),
  #|     focusedIndex: -1,
  #|     invalidated: false,
  #|     listeners,
  #|   }
  #|   const contentId = `${id}-content`
  #|   const content = {
  #|     querySelectorAll: () => [item],
  #|   }
  #|   const item = {
  #|     disabled: false,
  #|     hidden: false,
  #|     textContent: "New tab",
  #|     dataset: { menuIndex: "7" },
  #|     getAttribute: () => null,
  #|     getClientRects: () => [{}],
  #|     closest: selector => selector === '[role="menu"]' ? content : null,
  #|     focus: () => {
  #|       if (!fixture.invalidated) fixture.focusedIndex = 7
  #|     },
  #|   }
  #|   const trigger = {
  #|     disabled: false,
  #|     getAttribute: name => name === "aria-controls" ? contentId : null,
  #|     closest: selector => selector === '[data-slot="dropdown-menu-trigger"]'
  #|       ? trigger
  #|       : null,
  #|     click: () => { root.dataset.state = "open" },
  #|   }
  #|   const root = {
  #|     dataset: { state: "closed" },
  #|     querySelectorAll: () => [],
  #|     addEventListener: (type, callback) => { listeners[type] = callback },
  #|   }
  #|   globalThis.document = {
  #|     getElementById: value => value === id ? root : value === contentId ? content : null,
  #|   }
  #|   globalThis.getComputedStyle = () => ({ display: "block", visibility: "visible" })
  #|   globalThis.requestAnimationFrame = callback => {
  #|     callback()
  #|     return 1
  #|   }
  #|   fixture.trigger = trigger
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_invalidate_menu_focus_fixture_item() -> Unit =
  #| () => { globalThis.__ruiMenuFocusFixture.invalidated = true }

///|
#cfg(target="js")
extern "js" fn ffi_fire_menu_trigger_arrow_down() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiMenuFocusFixture
  #|   fixture.listeners.keydown({
  #|     key: "ArrowDown",
  #|     target: fixture.trigger,
  #|     defaultPrevented: false,
  #|     preventDefault() { this.defaultPrevented = true },
  #|   })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_install_menubar_switch_focus_fixture(id : String) -> Unit =
  #| id => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const fixture = globalThis.__ruiMenubarSwitchFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     requestAnimationFrame: globalThis.requestAnimationFrame,
  #|     hadRequestAnimationFrame: own("requestAnimationFrame"),
  #|     getComputedStyle: globalThis.getComputedStyle,
  #|     hadGetComputedStyle: own("getComputedStyle"),
  #|     listeners: {},
  #|     frames: 0,
  #|     liveFocuses: 0,
  #|   }
  #|   const trigger = index => ({
  #|     disabled: false,
  #|     dataset: { menubarIndex: String(index), menubarValue: `menu-${index}` },
  #|     closest(selector) {
  #|       return selector === '[data-slot="menubar-trigger"]' ? this : null
  #|     },
  #|     focus() { globalThis.document.activeElement = this },
  #|   })
  #|   const oldTrigger = trigger(0)
  #|   const nextTrigger = trigger(1)
  #|   const oldContent = {
  #|     dataset: { menubarIndex: "0", menubarValue: "menu-0" },
  #|     addEventListener() {},
  #|     matches: () => true,
  #|   }
  #|   const liveContent = {
  #|     dataset: { menubarIndex: "1", menubarValue: "menu-1", state: "open" },
  #|     disabled: false,
  #|     hidden: false,
  #|     getAttribute: () => null,
  #|     getClientRects: () => [{}],
  #|     closest: () => null,
  #|   }
  #|   const liveItem = {
  #|     dataset: { menuIndex: "4" },
  #|     disabled: false,
  #|     hidden: false,
  #|     getAttribute: () => null,
  #|     getClientRects: () => [{}],
  #|     closest: selector => selector === '[role="menu"]' ? liveContent : null,
  #|     focus() {
  #|       fixture.liveFocuses += 1
  #|       globalThis.document.activeElement = fixture.liveFocuses === 1
  #|         ? fixture.oldTrigger
  #|         : this
  #|     },
  #|   }
  #|   liveContent.querySelectorAll = selector => selector === "[data-menu-index]"
  #|     ? [liveItem]
  #|     : []
  #|   const oldItem = {
  #|     dataset: { menuIndex: "0" },
  #|     closest: selector => {
  #|       if (selector === '[data-slot="menubar-content"]') return oldContent
  #|       if (selector === "[data-menu-index]") return oldItem
  #|       return null
  #|     },
  #|   }
  #|   const oldRoot = {
  #|     dataset: { state: "open" },
  #|     querySelectorAll(selector) {
  #|       if (selector === '[data-slot="menubar-trigger"]') return [oldTrigger, nextTrigger]
  #|       if (selector === '[data-slot="menubar-content"]') return [oldContent]
  #|       return []
  #|     },
  #|     addEventListener(type, callback) { fixture.listeners[type] = callback },
  #|   }
  #|   const liveRoot = {
  #|     querySelectorAll: selector => selector === '[data-slot="menubar-content"]'
  #|       ? [liveContent]
  #|       : [],
  #|   }
  #|   fixture.oldRoot = oldRoot
  #|   fixture.liveRoot = oldRoot
  #|   fixture.nextRoot = liveRoot
  #|   fixture.oldTrigger = oldTrigger
  #|   fixture.nextTrigger = nextTrigger
  #|   fixture.liveItem = liveItem
  #|   globalThis.document = {
  #|     activeElement: null,
  #|     getElementById: value => value === id ? fixture.liveRoot : null,
  #|   }
  #|   globalThis.getComputedStyle = () => ({ display: "block", visibility: "visible" })
  #|   globalThis.requestAnimationFrame = callback => {
  #|     fixture.frames += 1
  #|     if (fixture.frames === 1) globalThis.document.activeElement = oldTrigger
  #|     callback()
  #|     return fixture.frames
  #|   }
  #|   fixture.event = {
  #|     key: "ArrowRight",
  #|     target: oldItem,
  #|     defaultPrevented: false,
  #|     preventDefault() { this.defaultPrevented = true },
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_menubar_switch_mount_next() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiMenubarSwitchFixture
  #|   fixture.liveRoot = fixture.nextRoot
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_fire_menubar_switch_right() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiMenubarSwitchFixture
  #|   fixture.listeners.keydown(fixture.event)
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_fire_menubar_switch_hover() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiMenubarSwitchFixture
  #|   globalThis.document.activeElement = fixture.oldTrigger
  #|   fixture.listeners.pointermove({ target: fixture.nextTrigger })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_make_menubar_switch_rtl() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiMenubarSwitchFixture
  #|   fixture.event.key = "ArrowLeft"
  #|   globalThis.getComputedStyle = () => ({
  #|     direction: "rtl",
  #|     display: "block",
  #|     visibility: "visible",
  #|   })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_menubar_switch_has_live_focus() -> Bool =
  #| () => {
  #|   const fixture = globalThis.__ruiMenubarSwitchFixture
  #|   return globalThis.document.activeElement === fixture.liveItem
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_menubar_switch_has_next_trigger_focus() -> Bool =
  #| () => {
  #|   const fixture = globalThis.__ruiMenubarSwitchFixture
  #|   return globalThis.document.activeElement === fixture.nextTrigger
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_menubar_switch_live_focuses() -> Int =
  #| () => globalThis.__ruiMenubarSwitchFixture.liveFocuses

///|
#cfg(target="js")
extern "js" fn ffi_restore_menubar_switch_focus_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiMenubarSwitchFixture
  #|   if (!fixture) return
  #|   const restore = (key, had, value) => {
  #|     if (had) globalThis[key] = value
  #|     else delete globalThis[key]
  #|   }
  #|   restore("document", fixture.hadDocument, fixture.document)
  #|   restore(
  #|     "requestAnimationFrame",
  #|     fixture.hadRequestAnimationFrame,
  #|     fixture.requestAnimationFrame,
  #|   )
  #|   restore("getComputedStyle", fixture.hadGetComputedStyle, fixture.getComputedStyle)
  #|   delete globalThis.__ruiMenubarSwitchFixture
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_install_menu_item_replacement_fixture(id : String) -> Unit =
  #| id => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const fixture = globalThis.__ruiMenuItemReplacementFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     requestAnimationFrame: globalThis.requestAnimationFrame,
  #|     hadRequestAnimationFrame: own("requestAnimationFrame"),
  #|     getComputedStyle: globalThis.getComputedStyle,
  #|     hadGetComputedStyle: own("getComputedStyle"),
  #|     generation: 0,
  #|     focuses: 0,
  #|   }
  #|   const body = {}
  #|   const oldContent = { dataset: { state: "closed" } }
  #|   const content = { dataset: { state: "open" } }
  #|   const makeItem = generation => ({
  #|     disabled: false,
  #|     hidden: false,
  #|     isConnected: true,
  #|     getAttribute: () => null,
  #|     getClientRects: () => [{}],
  #|     closest: selector => selector === '[role="menu"]' ? content : null,
  #|     focus() {
  #|       fixture.focuses += 1
  #|       globalThis.document.activeElement = this
  #|       if (generation === 0) {
  #|         fixture.generation = 1
  #|         this.isConnected = false
  #|         globalThis.document.activeElement = body
  #|       }
  #|     },
  #|   })
  #|   fixture.items = [makeItem(0), makeItem(1)]
  #|   const oldItem = {
  #|     disabled: false,
  #|     hidden: false,
  #|     isConnected: true,
  #|     getAttribute: () => null,
  #|     getClientRects: () => [{}],
  #|     closest: selector => selector === '[role="menu"]' ? oldContent : null,
  #|     focus() { globalThis.document.activeElement = this },
  #|   }
  #|   content.querySelectorAll = () => [fixture.items[fixture.generation]]
  #|   const root = {
  #|     querySelectorAll: () => [oldItem, fixture.items[fixture.generation]],
  #|   }
  #|   globalThis.document = {
  #|     body,
  #|     activeElement: body,
  #|     getElementById: value => value === id
  #|       ? root
  #|       : value === `${id}-content` ? content : null,
  #|   }
  #|   globalThis.getComputedStyle = () => ({ display: "block", visibility: "visible" })
  #|   globalThis.requestAnimationFrame = callback => {
  #|     callback()
  #|     return 1
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_menu_item_replacement_is_focused() -> Bool =
  #| () => {
  #|   const fixture = globalThis.__ruiMenuItemReplacementFixture
  #|   return fixture.generation === 1
  #|     && globalThis.document.activeElement === fixture.items[1]
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_menu_item_replacement_focuses() -> Int =
  #| () => globalThis.__ruiMenuItemReplacementFixture.focuses

///|
#cfg(target="js")
extern "js" fn ffi_restore_menu_item_replacement_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiMenuItemReplacementFixture
  #|   if (!fixture) return
  #|   const restore = (key, had, value) => {
  #|     if (had) globalThis[key] = value
  #|     else delete globalThis[key]
  #|   }
  #|   restore("document", fixture.hadDocument, fixture.document)
  #|   restore(
  #|     "requestAnimationFrame",
  #|     fixture.hadRequestAnimationFrame,
  #|     fixture.requestAnimationFrame,
  #|   )
  #|   restore("getComputedStyle", fixture.hadGetComputedStyle, fixture.getComputedStyle)
  #|   delete globalThis.__ruiMenuItemReplacementFixture
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_install_menubar_nested_focus_fixture(
  id : String,
  active_content_id : String,
  inactive_content_id : String,
  index : Int,
) -> Unit =
  #| (id, activeContentId, inactiveContentId, index) => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const fixture = globalThis.__ruiMenubarNestedFocusFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     requestAnimationFrame: globalThis.requestAnimationFrame,
  #|     hadRequestAnimationFrame: own("requestAnimationFrame"),
  #|     getComputedStyle: globalThis.getComputedStyle,
  #|     hadGetComputedStyle: own("getComputedStyle"),
  #|     activeFocuses: 0,
  #|     inactiveFocuses: 0,
  #|   }
  #|   const activeContent = {}
  #|   const inactiveContent = {}
  #|   const nestedMenu = {}
  #|   const makeItem = (owner, focus) => ({
  #|     disabled: false,
  #|     hidden: false,
  #|     isConnected: true,
  #|     dataset: { menuIndex: String(index) },
  #|     getAttribute: () => null,
  #|     getClientRects: () => [{}],
  #|     closest: selector => selector === '[role="menu"]' ? owner : null,
  #|     focus,
  #|   })
  #|   const inactiveItem = makeItem(inactiveContent, function() {
  #|     fixture.inactiveFocuses += 1
  #|     globalThis.document.activeElement = this
  #|   })
  #|   const activeItem = makeItem(nestedMenu, function() {
  #|     fixture.activeFocuses += 1
  #|     globalThis.document.activeElement = this
  #|   })
  #|   activeContent.querySelectorAll = () => [activeItem]
  #|   activeContent.contains = node => node === nestedMenu || node === activeItem
  #|   inactiveContent.querySelectorAll = () => [inactiveItem]
  #|   inactiveContent.contains = node => node === inactiveItem
  #|   const root = {
  #|     querySelectorAll: () => [inactiveItem, activeItem],
  #|   }
  #|   fixture.activeItem = activeItem
  #|   fixture.inactiveItem = inactiveItem
  #|   globalThis.document = {
  #|     activeElement: null,
  #|     getElementById: value => value === id
  #|       ? root
  #|       : value === activeContentId
  #|         ? activeContent
  #|         : value === inactiveContentId ? inactiveContent : null,
  #|   }
  #|   globalThis.getComputedStyle = () => ({ display: "block", visibility: "visible" })
  #|   globalThis.requestAnimationFrame = callback => {
  #|     callback()
  #|     return 1
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_menubar_nested_item_is_focused() -> Bool =
  #| () => {
  #|   const fixture = globalThis.__ruiMenubarNestedFocusFixture
  #|   return globalThis.document.activeElement === fixture.activeItem
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_menubar_nested_active_focuses() -> Int =
  #| () => globalThis.__ruiMenubarNestedFocusFixture.activeFocuses

///|
#cfg(target="js")
extern "js" fn ffi_menubar_nested_inactive_focuses() -> Int =
  #| () => globalThis.__ruiMenubarNestedFocusFixture.inactiveFocuses

///|
#cfg(target="js")
extern "js" fn ffi_restore_menubar_nested_focus_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiMenubarNestedFocusFixture
  #|   if (!fixture) return
  #|   const restore = (key, had, value) => {
  #|     if (had) globalThis[key] = value
  #|     else delete globalThis[key]
  #|   }
  #|   restore("document", fixture.hadDocument, fixture.document)
  #|   restore(
  #|     "requestAnimationFrame",
  #|     fixture.hadRequestAnimationFrame,
  #|     fixture.requestAnimationFrame,
  #|   )
  #|   restore("getComputedStyle", fixture.hadGetComputedStyle, fixture.getComputedStyle)
  #|   delete globalThis.__ruiMenubarNestedFocusFixture
  #| }

///|
#cfg(target="js")
test "focus-first retries after the popover becomes visible" {
  let found = Ref(-1)
  ffi_install_menu_focus_fixture("delayed-menu", true, "")
  ffi_focus_first_menu_item("delayed-menu", index => found.val = index)
  let focused = ffi_menu_focus_fixture_index()
  ffi_restore_menu_focus_fixture()
  assert_eq(found.val, 7)
  assert_eq(focused, 7)
}

///|
#cfg(target="js")
test "focus-first preserves the pending ArrowUp edge" {
  let found = Ref(-1)
  ffi_install_menu_focus_fixture("last-edge-menu", false, "last")
  ffi_focus_first_menu_item("last-edge-menu", index => found.val = index)
  let focused = ffi_menu_focus_fixture_index()
  ffi_restore_menu_focus_fixture()
  assert_eq(found.val, 9)
  assert_eq(focused, 9)
}

///|
#cfg(target="js")
test "trigger edge focuses before an active-state render can replace the item" {
  ffi_install_menu_trigger_focus_fixture("trigger-edge-menu")
  ffi_bind_menu_surface("trigger-edge-menu", (kind, _, _, _) => {
    if kind == 0 {
      ffi_invalidate_menu_focus_fixture_item()
    }
  })
  ffi_fire_menu_trigger_arrow_down()
  let focused = ffi_menu_focus_fixture_index()
  ffi_restore_menu_focus_fixture()
  assert_eq(focused, 7)
}

///|
#cfg(target="js")
test "menubar horizontal switch resolves live content and survives focus restore" {
  ffi_install_menubar_switch_focus_fixture("switching-menubar")
  ffi_bind_menubar(
    "switching-menubar",
    (_, _, focus_content) => {
      ffi_menubar_switch_mount_next()
      if focus_content {
        ui_after_ready("test-menubar-focus", () => {
          ffi_focus_menubar_content("switching-menubar", 1)
        })
      }
    },
    (_, _, _) => (),
    () => (),
    _ => (),
  )
  ffi_fire_menubar_switch_right()
  let focused = ffi_menubar_switch_has_live_focus()
  let focus_count = ffi_menubar_switch_live_focuses()
  ffi_restore_menubar_switch_focus_fixture()
  assert_true(focused)
  assert_true(focus_count >= 2)
}

///|
#cfg(target="js")
test "menubar horizontal switch follows RTL inline direction" {
  ffi_install_menubar_switch_focus_fixture("rtl-switching-menubar")
  ffi_make_menubar_switch_rtl()
  ffi_bind_menubar(
    "rtl-switching-menubar",
    (_, _, focus_content) => {
      ffi_menubar_switch_mount_next()
      if focus_content {
        ui_after_ready("test-rtl-menubar-focus", () => {
          ffi_focus_menubar_content("rtl-switching-menubar", 1)
        })
      }
    },
    (_, _, _) => (),
    () => (),
    _ => (),
  )
  ffi_fire_menubar_switch_right()
  let focused = ffi_menubar_switch_has_live_focus()
  ffi_restore_menubar_switch_focus_fixture()
  assert_true(focused)
}

///|
#cfg(target="js")
test "menubar hover switch transfers focus to the newly active trigger" {
  ffi_install_menubar_switch_focus_fixture("hover-switching-menubar")
  let activated = Ref("")
  ffi_bind_menubar(
    "hover-switching-menubar",
    (value, _, _) => activated.val = value,
    (_, _, _) => (),
    () => (),
    _ => (),
  )
  ffi_fire_menubar_switch_hover()
  let focused = ffi_menubar_switch_has_next_trigger_focus()
  ffi_restore_menubar_switch_focus_fixture()
  assert_true(focused)
  assert_eq(activated.val, "menu-1")
}

///|
#cfg(target="js")
test "menu item focus stays in active content after its focused node is replaced" {
  ffi_install_menu_item_replacement_fixture("replacing-menu")
  ui_after_ready("test-replacing-menu-item", () => {
    ffi_focus_menu_item("replacing-menu", "replacing-menu-content", 0)
  })
  let focused = ffi_menu_item_replacement_is_focused()
  let focus_count = ffi_menu_item_replacement_focuses()
  ffi_restore_menu_item_replacement_fixture()
  assert_true(focused)
  assert_eq(focus_count, 2)
}

///|
#cfg(target="js")
test "menubar item focus includes nested menus but stays in active content" {
  let id = "scoped-menubar"
  let active_content_id = id + "-content-1"
  let inactive_content_id = id + "-content-0"
  let shared_index = 3
  ffi_install_menubar_nested_focus_fixture(
    id, active_content_id, inactive_content_id, shared_index,
  )
  ui_after_ready("test-menubar-nested-focus", () => {
    ffi_focus_menu_item(id, active_content_id, shared_index)
  })
  let focused = ffi_menubar_nested_item_is_focused()
  let active_focuses = ffi_menubar_nested_active_focuses()
  let inactive_focuses = ffi_menubar_nested_inactive_focuses()
  ffi_restore_menubar_nested_focus_fixture()
  assert_true(focused)
  assert_eq(active_focuses, 1)
  assert_eq(inactive_focuses, 0)
}

///|
#cfg(target="js")
extern "js" fn ffi_install_rtl_menu_keyboard_fixture(id : String) -> Unit =
  #| id => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const fixture = globalThis.__ruiRtlMenuKeyboardFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     computed: globalThis.getComputedStyle,
  #|     hadComputed: own("getComputedStyle"),
  #|     raf: globalThis.requestAnimationFrame,
  #|     hadRaf: own("requestAnimationFrame"),
  #|     listeners: {},
  #|     dispatched: [],
  #|     frames: [],
  #|     submenuReady: false,
  #|   }
  #|   const visible = () => ({
  #|     disabled: false,
  #|     hidden: false,
  #|     getAttribute: name => name === "aria-expanded" ? "false" : null,
  #|     getClientRects: () => [{}],
  #|     focus() { globalThis.document.activeElement = this },
  #|   })
  #|   const menu = {
  #|     querySelectorAll(selector) {
  #|       if (selector === "[data-menu-index]") return [item]
  #|       if (selector === "[data-menu-index][data-submenu-key]") return [item]
  #|       return []
  #|     },
  #|   }
  #|   const submenu = Object.assign(visible(), {
  #|     dataset: { submenuOwner: "rtl-submenu" },
  #|     querySelectorAll: () => [child],
  #|     getClientRects: () => fixture.submenuReady ? [{}] : [],
  #|   })
  #|   const item = Object.assign({
  #|     dataset: { menuIndex: "3", submenuKey: "rtl-submenu" },
  #|     closest(selector) {
  #|       if (selector === "[data-menu-index]") return item
  #|       if (selector === '[role="menu"]') return menu
  #|       if (selector === "[data-submenu-owner]") return null
  #|       return null
  #|     },
  #|   }, visible())
  #|   const child = Object.assign({
  #|     dataset: { menuIndex: "4" },
  #|     closest(selector) {
  #|       if (selector === "[data-menu-index]") return child
  #|       if (selector === '[role="menu"]') return submenu
  #|       if (selector === "[data-submenu-owner]") return submenu
  #|       return null
  #|     },
  #|   }, visible())
  #|   const root = {
  #|     querySelectorAll(selector) {
  #|       if (selector === "[data-submenu-owner]") return [submenu]
  #|       if (selector === "[data-menu-index][data-submenu-key]") return [item]
  #|       return []
  #|     },
  #|     addEventListener(type, callback) { fixture.listeners[type] = callback },
  #|   }
  #|   fixture.item = item
  #|   fixture.child = child
  #|   globalThis.document = {
  #|     activeElement: null,
  #|     getElementById: value => value === id ? root : null,
  #|   }
  #|   globalThis.getComputedStyle = node => ({
  #|     direction: node === menu || node === submenu ? "rtl" : "rtl",
  #|     display: "block",
  #|     visibility: "visible",
  #|   })
  #|   globalThis.requestAnimationFrame = callback => {
  #|     fixture.frames.push(callback)
  #|     return fixture.frames.length
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_fire_rtl_menu_key(target : Int, key : String) -> Bool =
  #| (target, key) => {
  #|   const fixture = globalThis.__ruiRtlMenuKeyboardFixture
  #|   const event = {
  #|     key,
  #|     target: target === 0 ? fixture.item : fixture.child,
  #|     defaultPrevented: false,
  #|     metaKey: false,
  #|     ctrlKey: false,
  #|     altKey: false,
  #|     preventDefault() { this.defaultPrevented = true },
  #|     stopPropagation() {},
  #|   }
  #|   fixture.listeners.keydown(event)
  #|   return event.defaultPrevented
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_rtl_menu_dispatch_at(index : Int) -> Int =
  #| index => globalThis.__ruiRtlMenuKeyboardFixture?.dispatched?.[index] ?? -1

///|
#cfg(target="js")
extern "js" fn ffi_run_rtl_menu_frame(ready : Bool) -> Unit =
  #| ready => {
  #|   const fixture = globalThis.__ruiRtlMenuKeyboardFixture
  #|   fixture.submenuReady = ready
  #|   fixture.frames.shift()?.()
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_rtl_menu_focused(target : Int) -> Bool =
  #| target => {
  #|   const fixture = globalThis.__ruiRtlMenuKeyboardFixture
  #|   const expected = target === 0 ? fixture.item : fixture.child
  #|   return globalThis.document.activeElement === expected
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_restore_rtl_menu_keyboard_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiRtlMenuKeyboardFixture
  #|   if (!fixture) return
  #|   const restore = (key, had, value) => {
  #|     if (had) globalThis[key] = value
  #|     else delete globalThis[key]
  #|   }
  #|   restore("document", fixture.hadDocument, fixture.document)
  #|   restore("getComputedStyle", fixture.hadComputed, fixture.computed)
  #|   restore("requestAnimationFrame", fixture.hadRaf, fixture.raf)
  #|   delete globalThis.__ruiRtlMenuKeyboardFixture
  #| }

///|
#cfg(target="js")
test "submenu horizontal keys follow RTL inline direction" {
  ffi_install_rtl_menu_keyboard_fixture("rtl-menu")
  ffi_bind_menu_surface("rtl-menu", (kind, _, _, _) => {
    ffi_rtl_menu_record_dispatch(kind)
  })
  let opened = ffi_fire_rtl_menu_key(0, "ArrowLeft")
  let closed = ffi_fire_rtl_menu_key(1, "ArrowRight")
  let first = ffi_rtl_menu_dispatch_at(0)
  let second = ffi_rtl_menu_dispatch_at(1)
  ffi_restore_rtl_menu_keyboard_fixture()
  assert_true(opened)
  assert_true(closed)
  assert_eq(first, 4)
  assert_eq(second, 3)
}

///|
#cfg(target="js")
test "submenu focus waits for its own content instead of falling back to root" {
  ffi_install_rtl_menu_keyboard_fixture("delayed-rtl-submenu")
  ffi_bind_menu_surface("delayed-rtl-submenu", (kind, _, _, _) => {
    ffi_rtl_menu_record_dispatch(kind)
  })
  ignore(ffi_fire_rtl_menu_key(0, "ArrowLeft"))
  ffi_run_rtl_menu_frame(false)
  let root_focused_while_missing = ffi_rtl_menu_focused(0)
  ffi_run_rtl_menu_frame(true)
  let child_focused = ffi_rtl_menu_focused(1)
  ffi_restore_rtl_menu_keyboard_fixture()
  assert_false(root_focused_while_missing)
  assert_true(child_focused)
}

///|
#cfg(target="js")
extern "js" fn ffi_rtl_menu_record_dispatch(kind : Int) -> Unit =
  #| kind => globalThis.__ruiRtlMenuKeyboardFixture?.dispatched?.push(kind)
