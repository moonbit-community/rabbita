///|
#cfg(target="js")
extern "js" fn ffi_install_late_mount_fixture(id : String) -> Unit =
  #| id => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const triggerListeners = {}
  #|   const popupListeners = {}
  #|   const frameQueue = []
  #|   const root = {
  #|     dataset: {
  #|       delay: "17",
  #|       closeDelay: "7",
  #|       closeOnClick: "true",
  #|       hoverable: "true",
  #|       openDelay: "23",
  #|     },
  #|     closest: () => null,
  #|     hasAttribute: () => false,
  #|   }
  #|   const trigger = {
  #|     isConnected: true,
  #|     disabled: false,
  #|     dataset: { delay: "23", closeDelay: "11" },
  #|     addEventListener: (type, callback) => {
  #|       triggerListeners[type] = callback
  #|     },
  #|     matches: () => true,
  #|     getBoundingClientRect: () => ({
  #|       left: 20, right: 100, top: 20, bottom: 44, width: 80, height: 24,
  #|     }),
  #|   }
  #|   const popup = {
  #|     isConnected: true,
  #|     dataset: {
  #|       slot: "tooltip-content",
  #|       restoreFocus: "false",
  #|       triggerId: id + "-trigger",
  #|     },
  #|     addEventListener: (type, callback) => {
  #|       popupListeners[type] = callback
  #|     },
  #|     closest: () => null,
  #|     contains: () => false,
  #|     matches: selector => selector === ":popover-open" ? false : false,
  #|     getBoundingClientRect: () => ({ width: 120, height: 48 }),
  #|     style: { setProperty: () => {} },
  #|   }
  #|   const fixture = globalThis.__ruiLateMountFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     requestAnimationFrame: globalThis.requestAnimationFrame,
  #|     hadRequestAnimationFrame: own("requestAnimationFrame"),
  #|     HTMLElement: globalThis.HTMLElement,
  #|     hadHTMLElement: own("HTMLElement"),
  #|     floatingStack: globalThis.__ruiFloatingStack,
  #|     hadFloatingStack: own("__ruiFloatingStack"),
  #|     phase: 0,
  #|     root,
  #|     trigger,
  #|     popup,
  #|     triggerListeners,
  #|     frameQueue,
  #|   }
  #|   globalThis.HTMLElement = class HTMLElement {}
  #|   globalThis.__ruiFloatingStack = []
  #|   globalThis.document = {
  #|     activeElement: null,
  #|     body: {},
  #|     documentElement: { clientWidth: 1024, clientHeight: 768 },
  #|     getElementById: value => {
  #|       if (value === id + "-root") return fixture.phase >= 1 ? root : null
  #|       if (value === id + "-trigger") return fixture.phase >= 2 ? trigger : null
  #|       if (value === id) return fixture.phase >= 2 ? popup : null
  #|       return null
  #|     },
  #|     addEventListener: () => {},
  #|   }
  #|   globalThis.requestAnimationFrame = callback => {
  #|     frameQueue.push(callback)
  #|     return frameQueue.length
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_mount_late_root_and_advance_frame() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiLateMountFixture
  #|   fixture.phase = 1
  #|   fixture.frameQueue.shift()?.()
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_flush_late_mount_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiLateMountFixture
  #|   fixture.phase = 2
  #|   while (fixture.frameQueue.length) fixture.frameQueue.shift()()
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_late_mount_fixture_bound(tooltip : Bool) -> Bool =
  #| tooltip => {
  #|   const root = globalThis.__ruiLateMountFixture?.root
  #|   return tooltip
  #|     ? Boolean(root?.__ruiTooltipBound && root?.__ruiTooltipDispatch)
  #|     : Boolean(root?.__ruiHoverCardBound && root?.__ruiHoverCardDispatch)
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_late_mount_fixture_floating_bound() -> Bool =
  #| () => {
  #|   const popup = globalThis.__ruiLateMountFixture?.popup
  #|   return Boolean(popup?.__ruiFloatingSyncBound && popup?.__ruiFloatingSync)
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_late_mount_fixture_open() -> Bool =
  #| () => Boolean(globalThis.__ruiLateMountFixture?.popup.__ruiFloatingOpen)

///|
#cfg(target="js")
extern "js" fn ffi_fire_late_mount_mouseenter() -> Unit =
  #| () => globalThis.__ruiLateMountFixture.triggerListeners.mouseenter?.()

///|
#cfg(target="js")
extern "js" fn ffi_restore_late_mount_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiLateMountFixture
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
  #|   restore("HTMLElement", fixture.hadHTMLElement, fixture.HTMLElement)
  #|   restore(
  #|     "__ruiFloatingStack",
  #|     fixture.hadFloatingStack,
  #|     fixture.floatingStack,
  #|   )
  #|   delete globalThis.__ruiLateMountFixture
  #| }

///|
#cfg(target="js")
test "tooltip events and native sync bind after delayed mount" {
  let kind = Ref(-1)
  let wait = Ref(-1)
  ffi_install_late_mount_fixture("late-tooltip")
  ui_after_ready("tooltip-events:late-tooltip", () => {
    ffi_bind_tooltip_events("late-tooltip", (next_kind, next_wait) => {
      kind.val = next_kind
      wait.val = next_wait
    })
  })
  ui_after_mount("late-tooltip", () => {
    ffi_bind_floating_sync("late-tooltip", _ => ())
  })
  let bound_before_mount = ffi_late_mount_fixture_bound(true)
  ffi_mount_late_root_and_advance_frame()
  let bound_with_only_root = ffi_late_mount_fixture_bound(true)
  ffi_flush_late_mount_fixture()
  ffi_fire_late_mount_mouseenter()
  let bound = ffi_late_mount_fixture_bound(true)
  let floating_bound = ffi_late_mount_fixture_floating_bound()
  ffi_restore_late_mount_fixture()
  assert_true(!bound_before_mount)
  assert_true(!bound_with_only_root)
  assert_true(bound)
  assert_true(floating_bound)
  assert_eq(kind.val, 0)
  assert_eq(wait.val, 17)
}

///|
#cfg(target="js")
test "hover card events bind after delayed mount" {
  let kind = Ref(-1)
  let wait = Ref(-1)
  ffi_install_late_mount_fixture("late-hover-card")
  ui_after_ready("hover-card-events:late-hover-card", () => {
    ffi_bind_hover_card_events("late-hover-card", (next_kind, next_wait) => {
      kind.val = next_kind
      wait.val = next_wait
    })
  })
  let bound_before_mount = ffi_late_mount_fixture_bound(false)
  ffi_mount_late_root_and_advance_frame()
  let bound_with_only_root = ffi_late_mount_fixture_bound(false)
  ffi_flush_late_mount_fixture()
  ffi_fire_late_mount_mouseenter()
  let bound = ffi_late_mount_fixture_bound(false)
  ffi_restore_late_mount_fixture()
  assert_true(!bound_before_mount)
  assert_true(!bound_with_only_root)
  assert_true(bound)
  assert_eq(kind.val, 0)
  assert_eq(wait.val, 23)
}

///|
#cfg(target="js")
test "floating default-open waits for its delayed popup mount" {
  ffi_install_late_mount_fixture("late-default-open")
  floating_set_open_when_ready("late-default-open", true)
  let open_before_mount = ffi_late_mount_fixture_open()
  ffi_mount_late_root_and_advance_frame()
  let open_with_only_root = ffi_late_mount_fixture_open()
  ffi_flush_late_mount_fixture()
  let open = ffi_late_mount_fixture_open()
  ffi_restore_late_mount_fixture()
  assert_true(!open_before_mount)
  assert_true(!open_with_only_root)
  assert_true(open)
}
