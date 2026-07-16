///|
#cfg(target="js")
extern "js" fn ffi_install_sidebar_pointer_fixture(
  side : String,
  collapsed : Bool,
  start_width : Int,
  preferred_width : Int,
  root_width : Int,
) -> Unit =
  #| (side, collapsed, startWidth, preferredWidth, rootWidth) => {
  #|   const style = entries => {
  #|     const values = new Map(entries)
  #|     return {
  #|       getPropertyValue: name => values.get(name) || "",
  #|       setProperty: (name, value) => { values.set(name, String(value)) },
  #|       removeProperty: name => { values.delete(name) },
  #|     }
  #|   }
  #|   const fixture = globalThis.__ruiSidebarPointerFixture = {
  #|     captures: 0,
  #|     releases: 0,
  #|     prevented: 0,
  #|     stopped: 0,
  #|     listeners: {},
  #|   }
  #|   const root = {
  #|     dataset: { slot: "sidebar-wrapper" },
  #|     style: style([]),
  #|     getBoundingClientRect: () => ({ width: rootWidth }),
  #|   }
  #|   const sidebarStyle = style([[
  #|     "width",
  #|     collapsed
  #|       ? "var(--rui-sidebar-width-icon,3rem)"
  #|       : "var(--rui-sidebar-current-width,var(--rui-sidebar-width,16rem))",
  #|   ], ["transition", "width 200ms ease,transform 200ms ease"]])
  #|   const sidebar = {
  #|     dataset: { state: collapsed ? "collapsed" : "expanded", mobile: "false" },
  #|     style: sidebarStyle,
  #|     getBoundingClientRect: () => {
  #|       const width = sidebarStyle.getPropertyValue("width")
  #|       if (/^-?\d+(?:\.\d+)?px$/.test(width)) return { width: Number.parseFloat(width) }
  #|       if (width.includes("--rui-sidebar-current-width")) return { width: preferredWidth }
  #|       return { width: startWidth }
  #|     },
  #|   }
  #|   const rail = {
  #|     dataset: { side },
  #|     closest: selector => selector.includes("sidebar-wrapper")
  #|       ? root
  #|       : selector.includes('data-slot="sidebar"') ? sidebar : null,
  #|     addEventListener: (type, callback) => { fixture.listeners[type] = callback },
  #|     removeEventListener: (type, callback) => {
  #|       if (fixture.listeners[type] === callback) delete fixture.listeners[type]
  #|     },
  #|     setPointerCapture: () => { fixture.captures += 1 },
  #|     releasePointerCapture: () => { fixture.releases += 1 },
  #|   }
  #|   fixture.root = root
  #|   fixture.sidebar = sidebar
  #|   fixture.rail = rail
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_sidebar_pointer_fixture_event(
  client_x : Int,
  pointer_id : Int,
) -> @dom.MouseEvent =
  #| (clientX, pointerId) => {
  #|   const fixture = globalThis.__ruiSidebarPointerFixture
  #|   return {
  #|     currentTarget: fixture.rail,
  #|     target: fixture.rail,
  #|     clientX,
  #|     clientY: 100,
  #|     pointerId,
  #|     pointerType: "mouse",
  #|     button: 0,
  #|     isPrimary: true,
  #|     defaultPrevented: false,
  #|     preventDefault() {
  #|       this.defaultPrevented = true
  #|       fixture.prevented += 1
  #|     },
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_sidebar_pointer_fixture_property(kind : Int) -> String =
  #| kind => {
  #|   const fixture = globalThis.__ruiSidebarPointerFixture
  #|   if (kind === 0) return fixture.root.style.getPropertyValue("--rui-sidebar-current-width")
  #|   if (kind === 1) return fixture.sidebar.style.getPropertyValue("width")
  #|   if (kind === 2) return fixture.sidebar.style.getPropertyValue("transition")
  #|   return fixture.root.style.getPropertyValue("user-select")
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_sidebar_pointer_fixture_count(kind : Int) -> Int =
  #| kind => {
  #|   const fixture = globalThis.__ruiSidebarPointerFixture
  #|   if (kind === 0) return fixture.captures
  #|   if (kind === 1) return fixture.releases
  #|   if (kind === 2) return fixture.prevented
  #|   return fixture.stopped
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_sidebar_pointer_fixture_click() -> Bool =
  #| () => {
  #|   const fixture = globalThis.__ruiSidebarPointerFixture
  #|   const listener = fixture.listeners.click
  #|   if (!listener) return false
  #|   const event = {
  #|     defaultPrevented: false,
  #|     preventDefault() { this.defaultPrevented = true },
  #|     stopImmediatePropagation() { fixture.stopped += 1 },
  #|     stopPropagation() { fixture.stopped += 1 },
  #|   }
  #|   listener(event)
  #|   return event.defaultPrevented
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_sidebar_pointer_fixture_lost(pointer_id : Int) -> Unit =
  #| pointerId => {
  #|   const fixture = globalThis.__ruiSidebarPointerFixture
  #|   fixture.listeners.lostpointercapture?.({ pointerId })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_restore_sidebar_pointer_fixture() -> Unit =
  #| () => { delete globalThis.__ruiSidebarPointerFixture }

///|
#cfg(target="js")
test "sidebar rail resizes left and suppresses the synthetic toggle click" {
  ffi_install_sidebar_pointer_fixture("left", false, 240, 240, 640)
  let down = ffi_sidebar_pointer_fixture_event(100, 7)
  let move_event = ffi_sidebar_pointer_fixture_event(160, 7)
  let up = ffi_sidebar_pointer_fixture_event(160, 7)
  assert_true(ffi_sidebar_pointer_start(down, 160, 512))
  assert_true(ffi_sidebar_pointer_move(move_event))
  assert_eq(ffi_sidebar_pointer_fixture_property(0), "300px")
  assert_eq(ffi_sidebar_pointer_fixture_property(1), "300px")
  assert_eq(ffi_sidebar_pointer_end(up), 300)
  assert_eq(ffi_sidebar_pointer_fixture_count(0), 1)
  assert_eq(ffi_sidebar_pointer_fixture_count(1), 1)
  assert_true(ffi_sidebar_pointer_fixture_click())
  assert_eq(ffi_sidebar_pointer_fixture_count(3), 2)
  ffi_restore_sidebar_pointer_fixture()
}

///|
#cfg(target="js")
test "sidebar rail reverses right-side delta and clamps both bounds" {
  ffi_install_sidebar_pointer_fixture("right", false, 240, 240, 640)
  let down = ffi_sidebar_pointer_fixture_event(300, 11)
  assert_true(ffi_sidebar_pointer_start(down, 160, 400))
  assert_true(
    ffi_sidebar_pointer_move(ffi_sidebar_pointer_fixture_event(360, 11)),
  )
  assert_eq(
    ffi_sidebar_pointer_end(ffi_sidebar_pointer_fixture_event(360, 11)),
    180,
  )
  ffi_restore_sidebar_pointer_fixture()
  ffi_install_sidebar_pointer_fixture("left", false, 240, 240, 640)
  assert_true(
    ffi_sidebar_pointer_start(
      ffi_sidebar_pointer_fixture_event(100, 12),
      160,
      400,
    ),
  )
  assert_true(
    ffi_sidebar_pointer_move(ffi_sidebar_pointer_fixture_event(700, 12)),
  )
  assert_eq(
    ffi_sidebar_pointer_end(ffi_sidebar_pointer_fixture_event(700, 12)),
    400,
  )
  ffi_restore_sidebar_pointer_fixture()
}

///|
#cfg(target="js")
test "sidebar rail preserves clicks below threshold and restores cancellation" {
  ffi_install_sidebar_pointer_fixture("left", false, 240, 240, 640)
  assert_true(
    ffi_sidebar_pointer_start(
      ffi_sidebar_pointer_fixture_event(100, 20),
      160,
      512,
    ),
  )
  assert_false(
    ffi_sidebar_pointer_move(ffi_sidebar_pointer_fixture_event(103, 20)),
  )
  assert_eq(
    ffi_sidebar_pointer_end(ffi_sidebar_pointer_fixture_event(103, 20)),
    0,
  )
  assert_false(ffi_sidebar_pointer_fixture_click())
  ffi_restore_sidebar_pointer_fixture()
  ffi_install_sidebar_pointer_fixture("left", true, 48, 240, 640)
  assert_true(
    ffi_sidebar_pointer_start(
      ffi_sidebar_pointer_fixture_event(100, 21),
      160,
      512,
    ),
  )
  assert_true(
    ffi_sidebar_pointer_move(ffi_sidebar_pointer_fixture_event(140, 21)),
  )
  assert_eq(ffi_sidebar_pointer_fixture_property(0), "280px")
  ffi_sidebar_pointer_cancel(ffi_sidebar_pointer_fixture_event(140, 21))
  assert_eq(ffi_sidebar_pointer_fixture_property(0), "")
  assert_eq(
    ffi_sidebar_pointer_fixture_property(1),
    "var(--rui-sidebar-width-icon,3rem)",
  )
  ffi_restore_sidebar_pointer_fixture()
}

///|
#cfg(target="js")
test "sidebar rail lost pointer capture cancels an in-flight preview" {
  ffi_install_sidebar_pointer_fixture("left", false, 240, 240, 640)
  assert_true(
    ffi_sidebar_pointer_start(
      ffi_sidebar_pointer_fixture_event(100, 31),
      160,
      512,
    ),
  )
  assert_true(
    ffi_sidebar_pointer_move(ffi_sidebar_pointer_fixture_event(180, 31)),
  )
  ffi_sidebar_pointer_fixture_lost(31)
  assert_eq(ffi_sidebar_pointer_fixture_property(0), "")
  assert_eq(
    ffi_sidebar_pointer_fixture_property(1),
    "var(--rui-sidebar-current-width,var(--rui-sidebar-width,16rem))",
  )
  assert_eq(ffi_sidebar_pointer_fixture_count(1), 1)
  ffi_restore_sidebar_pointer_fixture()
}
