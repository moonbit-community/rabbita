///|
#cfg(target="js")
extern "js" fn ffi_install_sidebar_focus_fixture(
  mode : Int,
) -> @dom.KeyboardEvent =
  #| mode => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const fixture = globalThis.__ruiSidebarFocusFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     getComputedStyle: globalThis.getComputedStyle,
  #|     hadGetComputedStyle: own("getComputedStyle"),
  #|     focused: -1,
  #|   }
  #|   const makeItem = index => ({
  #|     closest: () => null,
  #|     getClientRects: () => [{}],
  #|     focus: () => { fixture.focused = index },
  #|   })
  #|   const items = mode === 3 ? [] : [makeItem(0), makeItem(1)]
  #|   const root = {
  #|     getAttribute: name => name === "aria-hidden" && mode === 4 ? "true" : null,
  #|     querySelectorAll: () => items,
  #|     contains: node => items.includes(node),
  #|     focus: () => { fixture.focused = 2 },
  #|   }
  #|   fixture.root = root
  #|   fixture.items = items
  #|   globalThis.document = {
  #|     activeElement: mode === 0 ? items[1] : mode === 1 || mode === 2 ? items[0] : null,
  #|   }
  #|   globalThis.getComputedStyle = () => ({ visibility: "visible" })
  #|   return {
  #|     key: mode === 5 ? "Escape" : "Tab",
  #|     shiftKey: mode === 1,
  #|     altKey: false,
  #|     ctrlKey: false,
  #|     metaKey: false,
  #|     currentTarget: root,
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_sidebar_focus_fixture_focused() -> Int =
  #| () => globalThis.__ruiSidebarFocusFixture?.focused ?? -1

///|
#cfg(target="js")
extern "js" fn ffi_restore_sidebar_focus_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiSidebarFocusFixture
  #|   if (!fixture) return
  #|   if (fixture.hadDocument) globalThis.document = fixture.document
  #|   else delete globalThis.document
  #|   if (fixture.hadGetComputedStyle) globalThis.getComputedStyle = fixture.getComputedStyle
  #|   else delete globalThis.getComputedStyle
  #|   delete globalThis.__ruiSidebarFocusFixture
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_install_sidebar_restore_fixture(
  blocked : Bool,
) -> @dom.MouseEvent =
  #| blocked => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const fixture = globalThis.__ruiSidebarRestoreFixture = {
  #|     previous: globalThis.__ruiSidebarRestoreTrigger,
  #|     hadPrevious: own("__ruiSidebarRestoreTrigger"),
  #|     focused: 0,
  #|   }
  #|   const trigger = {
  #|     isConnected: true,
  #|     disabled: false,
  #|     getAttribute: () => null,
  #|     closest: () => blocked ? {} : null,
  #|     focus: () => { fixture.focused += 1 },
  #|   }
  #|   fixture.trigger = trigger
  #|   return { currentTarget: trigger }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_sidebar_restore_fixture_focused() -> Int =
  #| () => globalThis.__ruiSidebarRestoreFixture?.focused ?? 0

///|
#cfg(target="js")
extern "js" fn ffi_restore_sidebar_restore_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiSidebarRestoreFixture
  #|   if (!fixture) return
  #|   if (fixture.hadPrevious) globalThis.__ruiSidebarRestoreTrigger = fixture.previous
  #|   else delete globalThis.__ruiSidebarRestoreTrigger
  #|   delete globalThis.__ruiSidebarRestoreFixture
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_install_sidebar_open_focus_fixture() -> Unit =
  #| () => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const listeners = {}
  #|   const outside = {}
  #|   const fixture = globalThis.__ruiSidebarOpenFocusFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     computed: globalThis.getComputedStyle,
  #|     hadComputed: own("getComputedStyle"),
  #|     listeners,
  #|     focused: -1,
  #|     outside,
  #|   }
  #|   const makeItem = index => ({
  #|     closest: () => null,
  #|     getClientRects: () => [{}],
  #|     focus: () => {
  #|       fixture.focused = index
  #|       globalThis.document.activeElement = items[index]
  #|     },
  #|   })
  #|   const items = [makeItem(0), makeItem(1)]
  #|   const root = {
  #|     hidden: false,
  #|     getAttribute: () => null,
  #|     querySelectorAll: () => items,
  #|     contains: node => node === root || items.includes(node),
  #|     focus: () => {
  #|       fixture.focused = 2
  #|       globalThis.document.activeElement = root
  #|     },
  #|     dispatchEvent: () => true,
  #|   }
  #|   fixture.root = root
  #|   fixture.items = items
  #|   globalThis.document = {
  #|     activeElement: outside,
  #|     querySelectorAll: () => [root],
  #|     addEventListener: (type, callback) => { listeners[type] = callback },
  #|   }
  #|   globalThis.getComputedStyle = () => ({ display: "block", visibility: "visible" })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_sidebar_open_focus_fixture_focused() -> Int =
  #| () => globalThis.__ruiSidebarOpenFocusFixture?.focused ?? -1

///|
#cfg(target="js")
extern "js" fn ffi_fire_sidebar_outside_focus_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiSidebarOpenFocusFixture
  #|   globalThis.document.activeElement = fixture.outside
  #|   fixture.listeners.focusin?.({ target: fixture.outside })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_fire_sidebar_outside_tab_fixture(shift : Bool) -> Bool =
  #| shift => {
  #|   const fixture = globalThis.__ruiSidebarOpenFocusFixture
  #|   globalThis.document.activeElement = fixture.outside
  #|   const event = {
  #|     key: "Tab",
  #|     shiftKey: shift,
  #|     defaultPrevented: false,
  #|     preventDefault() { this.defaultPrevented = true },
  #|   }
  #|   fixture.listeners.keydown?.(event)
  #|   return event.defaultPrevented
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_restore_sidebar_open_focus_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiSidebarOpenFocusFixture
  #|   if (!fixture) return
  #|   if (fixture.hadDocument) globalThis.document = fixture.document
  #|   else delete globalThis.document
  #|   if (fixture.hadComputed) globalThis.getComputedStyle = fixture.computed
  #|   else delete globalThis.getComputedStyle
  #|   delete globalThis.__ruiSidebarOpenFocusFixture
  #| }

///|
#cfg(target="js")
test "mobile sidebar focus trap wraps both directions and ignores inactive paths" {
  let forward_event = ffi_install_sidebar_focus_fixture(0)
  let forward_handled = ffi_sidebar_trap_focus(forward_event)
  let forward_focus = ffi_sidebar_focus_fixture_focused()
  ffi_restore_sidebar_focus_fixture()
  assert_true(forward_handled)
  assert_eq(forward_focus, 0)

  let backward_event = ffi_install_sidebar_focus_fixture(1)
  let backward_handled = ffi_sidebar_trap_focus(backward_event)
  let backward_focus = ffi_sidebar_focus_fixture_focused()
  ffi_restore_sidebar_focus_fixture()
  assert_true(backward_handled)
  assert_eq(backward_focus, 1)

  let middle_event = ffi_install_sidebar_focus_fixture(2)
  let middle_handled = ffi_sidebar_trap_focus(middle_event)
  let middle_focus = ffi_sidebar_focus_fixture_focused()
  ffi_restore_sidebar_focus_fixture()
  assert_true(!middle_handled)
  assert_eq(middle_focus, -1)

  let empty_event = ffi_install_sidebar_focus_fixture(3)
  let empty_handled = ffi_sidebar_trap_focus(empty_event)
  let empty_focus = ffi_sidebar_focus_fixture_focused()
  ffi_restore_sidebar_focus_fixture()
  assert_true(empty_handled)
  assert_eq(empty_focus, 2)

  let hidden_event = ffi_install_sidebar_focus_fixture(4)
  let hidden_handled = ffi_sidebar_trap_focus(hidden_event)
  ffi_restore_sidebar_focus_fixture()
  assert_true(!hidden_handled)

  let escape_event = ffi_install_sidebar_focus_fixture(5)
  let escape_handled = ffi_sidebar_trap_focus(escape_event)
  ffi_restore_sidebar_focus_fixture()
  assert_true(!escape_handled)
}

///|
#cfg(target="js")
test "mobile sidebar restores only a connected visible opener" {
  let visible_event = ffi_install_sidebar_restore_fixture(false)
  ffi_sidebar_capture_restore_trigger(visible_event)
  ffi_sidebar_restore_trigger()
  let visible_focus = ffi_sidebar_restore_fixture_focused()
  ffi_restore_sidebar_restore_fixture()
  assert_eq(visible_focus, 1)

  let blocked_event = ffi_install_sidebar_restore_fixture(true)
  ffi_sidebar_capture_restore_trigger(blocked_event)
  ffi_sidebar_restore_trigger()
  let blocked_focus = ffi_sidebar_restore_fixture_focused()
  ffi_restore_sidebar_restore_fixture()
  assert_eq(blocked_focus, 0)
}

///|
#cfg(target="js")
test "opening mobile sidebar moves focus in and contains outside focus" {
  ffi_install_sidebar_open_focus_fixture()
  assert_true(ffi_sidebar_focus_open())
  assert_eq(ffi_sidebar_open_focus_fixture_focused(), 0)
  ffi_fire_sidebar_outside_focus_fixture()
  assert_eq(ffi_sidebar_open_focus_fixture_focused(), 0)
  assert_true(ffi_fire_sidebar_outside_tab_fixture(true))
  assert_eq(ffi_sidebar_open_focus_fixture_focused(), 1)
  ffi_restore_sidebar_open_focus_fixture()
}
