///|
#cfg(target="js")
extern "js" fn ffi_install_navigation_menu_fixture(rtl : Bool) -> Unit =
  #| rtl => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const listeners = {}
  #|   const fixture = globalThis.__ruiNavigationMenuFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     getComputedStyle: globalThis.getComputedStyle,
  #|     hadGetComputedStyle: own("getComputedStyle"),
  #|     requestAnimationFrame: globalThis.requestAnimationFrame,
  #|     hadRequestAnimationFrame: own("requestAnimationFrame"),
  #|     queueMicrotask: globalThis.queueMicrotask,
  #|     hadQueueMicrotask: own("queueMicrotask"),
  #|     listeners,
  #|     focused: -1,
  #|     contentFocused: false,
  #|     rafCount: 0,
  #|     prevented: false,
  #|   }
  #|   const root = {
  #|     dataset: { state: "open" },
  #|     isConnected: true,
  #|     __ruiNavigationBound: false,
  #|     addEventListener: (type, callback) => { listeners[type] = callback },
  #|     querySelectorAll: selector => selector === '[data-slot="navigation-menu-trigger"]'
  #|       ? fixture.triggers
  #|       : selector === '[data-slot="navigation-menu-content"]' ? [fixture.content] : [],
  #|     querySelector: () => null,
  #|     contains: node => fixture.triggers.includes(node),
  #|     matches: () => false,
  #|   }
  #|   const makeTrigger = (index, expanded, disabled = false) => ({
  #|     disabled,
  #|     tabIndex: index === 0 ? 0 : -1,
  #|     dataset: {
  #|       navigationIndex: String(index),
  #|       navigationValue: `value-${index}`,
  #|     },
  #|     getAttribute: name => name === "aria-disabled"
  #|       ? disabled ? "true" : "false"
  #|       : name === "aria-expanded" ? expanded ? "true" : "false" : null,
  #|     closest: selector => selector === '[data-slot="navigation-menu-trigger"]'
  #|       ? fixture.triggers[index]
  #|       : null,
  #|     focus: () => { fixture.focused = index },
  #|   })
  #|   fixture.root = root
  #|   fixture.triggers = [
  #|     makeTrigger(0, false),
  #|     makeTrigger(1, true),
  #|     makeTrigger(2, false, true),
  #|   ]
  #|   fixture.contentTarget = {
  #|     disabled: false,
  #|     hidden: false,
  #|     getAttribute: () => null,
  #|     closest: () => null,
  #|     getClientRects: () => fixture.rafCount >= 2 ? [{}] : [],
  #|     focus: () => { fixture.contentFocused = true },
  #|   }
  #|   fixture.content = {
  #|     dataset: { navigationIndex: "1", navigationValue: "value-1" },
  #|     disabled: false,
  #|     hidden: false,
  #|     addEventListener: () => {},
  #|     getAttribute: () => null,
  #|     closest: () => null,
  #|     getClientRects: () => fixture.rafCount >= 2 ? [{}] : [],
  #|     matches: () => false,
  #|     querySelectorAll: () => [fixture.contentTarget],
  #|     focus: () => { fixture.contentFocused = true },
  #|   }
  #|   globalThis.document = {
  #|     activeElement: null,
  #|     getElementById: id => id === "navigation-fixture" ? root : null,
  #|     addEventListener: (type, callback) => { listeners[`document:${type}`] = callback },
  #|     removeEventListener: () => {},
  #|   }
  #|   globalThis.getComputedStyle = node => ({
  #|     direction: node === root && rtl ? "rtl" : "ltr",
  #|     display: "block",
  #|     visibility: "visible",
  #|   })
  #|   globalThis.requestAnimationFrame = callback => {
  #|     fixture.rafCount += 1
  #|     callback()
  #|     return fixture.rafCount
  #|   }
  #|   globalThis.queueMicrotask = callback => callback()
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_navigation_menu_fixture_tab_index(index : Int) -> Int =
  #| index => globalThis.__ruiNavigationMenuFixture.triggers[index].tabIndex

///|
#cfg(target="js")
extern "js" fn ffi_fire_navigation_menu_key(index : Int, key : String) -> Bool =
  #| (index, key) => {
  #|   const fixture = globalThis.__ruiNavigationMenuFixture
  #|   fixture.prevented = false
  #|   fixture.listeners.keydown({
  #|     target: fixture.triggers[index],
  #|     key,
  #|     defaultPrevented: false,
  #|     preventDefault: () => { fixture.prevented = true },
  #|   })
  #|   return fixture.prevented
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_navigation_menu_fixture_focused() -> Int =
  #| () => globalThis.__ruiNavigationMenuFixture.focused

///|
#cfg(target="js")
extern "js" fn ffi_navigation_menu_fixture_content_focused() -> Bool =
  #| () => globalThis.__ruiNavigationMenuFixture.contentFocused

///|
#cfg(target="js")
extern "js" fn ffi_fire_navigation_menu_outside_press() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiNavigationMenuFixture
  #|   fixture.listeners["document:pointerdown"]({ target: {} })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_restore_navigation_menu_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiNavigationMenuFixture
  #|   if (!fixture) return
  #|   if (fixture.hadDocument) globalThis.document = fixture.document
  #|   else delete globalThis.document
  #|   if (fixture.hadGetComputedStyle) globalThis.getComputedStyle = fixture.getComputedStyle
  #|   else delete globalThis.getComputedStyle
  #|   if (fixture.hadRequestAnimationFrame) {
  #|     globalThis.requestAnimationFrame = fixture.requestAnimationFrame
  #|   } else delete globalThis.requestAnimationFrame
  #|   if (fixture.hadQueueMicrotask) globalThis.queueMicrotask = fixture.queueMicrotask
  #|   else delete globalThis.queueMicrotask
  #|   delete globalThis.__ruiNavigationMenuFixture
  #| }

///|
#cfg(target="js")
test "navigation menu normalizes one enabled tab stop and follows RTL arrows" {
  ffi_install_navigation_menu_fixture(true)
  let activated = Ref(-1)
  let closed = Ref(0)
  ffi_bind_navigation_menu(
    "navigation-fixture",
    (_, index) => activated.val = index,
    (_, _, _) => (),
    () => closed.val += 1,
    _ => (),
  )
  let first_tab_index = ffi_navigation_menu_fixture_tab_index(0)
  let active_tab_index = ffi_navigation_menu_fixture_tab_index(1)
  let disabled_tab_index = ffi_navigation_menu_fixture_tab_index(2)
  let prevented = ffi_fire_navigation_menu_key(1, "ArrowRight")
  let focused = ffi_navigation_menu_fixture_focused()
  ffi_fire_navigation_menu_outside_press()
  let close_count = closed.val
  ffi_restore_navigation_menu_fixture()
  assert_eq(first_tab_index, -1)
  assert_eq(active_tab_index, 0)
  assert_eq(disabled_tab_index, -1)
  assert_true(prevented)
  assert_eq(focused, 0)
  assert_eq(activated.val, 0)
  assert_eq(close_count, 1)
}

///|
#cfg(target="js")
test "navigation menu retries content focus across incremental frames" {
  ffi_install_navigation_menu_fixture(false)
  let activated = Ref(-1)
  ffi_bind_navigation_menu(
    "navigation-fixture",
    (_, index) => activated.val = index,
    (_, _, _) => (),
    () => (),
    _ => (),
  )
  let prevented = ffi_fire_navigation_menu_key(1, "ArrowDown")
  let focused = ffi_navigation_menu_fixture_content_focused()
  ffi_restore_navigation_menu_fixture()
  assert_true(prevented)
  assert_eq(activated.val, 1)
  assert_true(focused)
}
