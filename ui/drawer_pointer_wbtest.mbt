///|
#cfg(target="js")
extern "js" fn ffi_install_drawer_pointer_fixture() -> Unit =
  #| () => {
  #|   const props = {
  #|     "--rui-drawer-transform": "translate3d(0,0,0)",
  #|     transition: "opacity 200ms ease,transform 200ms ease",
  #|   }
  #|   const overlayProps = { "--rui-dialog-overlay-opacity": "1" }
  #|   const handle = {
  #|     closest: selector => selector === '[data-slot="drawer-handle"]' ? handle : null,
  #|   }
  #|   const outside = { closest: () => null }
  #|   const style = values => ({
  #|     getPropertyValue: key => values[key] || "",
  #|     setProperty: (key, value) => { values[key] = value },
  #|     removeProperty: key => { delete values[key] },
  #|   })
  #|   const overlay = { style: style(overlayProps) }
  #|   const dialog = {
  #|     querySelector: selector => selector === '[data-slot="drawer-overlay"]' ? overlay : null,
  #|   }
  #|   const surface = {
  #|     clientWidth: 240,
  #|     clientHeight: 400,
  #|     dataset: {},
  #|     style: style(props),
  #|     contains: node => node === handle,
  #|     closest: selector => selector === "dialog" ? dialog : null,
  #|     captures: 0,
  #|     releases: 0,
  #|     setPointerCapture() { this.captures += 1 },
  #|     releasePointerCapture() { this.releases += 1 },
  #|   }
  #|   globalThis.__ruiDrawerPointerFixture = {
  #|     props,
  #|     overlayProps,
  #|     handle,
  #|     outside,
  #|     surface,
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_drawer_pointer_fixture_event(
  x : Int,
  y : Int,
  time : Int,
  outside : Bool,
) -> @dom.MouseEvent =
  #| (x, y, time, outside) => {
  #|   const fixture = globalThis.__ruiDrawerPointerFixture
  #|   return {
  #|     currentTarget: fixture.surface,
  #|     target: outside ? fixture.outside : fixture.handle,
  #|     pointerId: 9,
  #|     pointerType: "touch",
  #|     isPrimary: true,
  #|     button: 0,
  #|     clientX: x,
  #|     clientY: y,
  #|     timeStamp: time,
  #|     defaultPrevented: false,
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_drawer_fixture_value(key : String) -> String =
  #| key => globalThis.__ruiDrawerPointerFixture?.props?.[key] || ""

///|
#cfg(target="js")
extern "js" fn ffi_drawer_fixture_overlay_opacity() -> String =
  #| () => globalThis.__ruiDrawerPointerFixture?.overlayProps?.["--rui-dialog-overlay-opacity"] || ""

///|
#cfg(target="js")
extern "js" fn ffi_drawer_fixture_dragging() -> Bool =
  #| () => globalThis.__ruiDrawerPointerFixture?.surface?.dataset?.dragging === "true"

///|
#cfg(target="js")
extern "js" fn ffi_drawer_fixture_releases() -> Int =
  #| () => globalThis.__ruiDrawerPointerFixture?.surface?.releases ?? 0

///|
#cfg(target="js")
extern "js" fn ffi_restore_drawer_pointer_fixture() -> Unit =
  #| () => { delete globalThis.__ruiDrawerPointerFixture }

///|
#cfg(target="js")
test "drawer handle drag dismisses in bottom and left directions" {
  ffi_install_drawer_pointer_fixture()
  let bottom_start = ffi_drawer_pointer_fixture_event(100, 50, 0, false)
  let bottom_move = ffi_drawer_pointer_fixture_event(102, 180, 150, false)
  let bottom_end = ffi_drawer_pointer_fixture_event(102, 180, 300, false)
  assert_true(ffi_drawer_pointer_start(bottom_start, "bottom"))
  assert_true(ffi_drawer_pointer_move(bottom_move))
  assert_true(ffi_drawer_fixture_dragging())
  assert_eq(
    ffi_drawer_fixture_value("--rui-drawer-transform"),
    "translate3d(0,130px,0)",
  )
  assert_eq(ffi_drawer_fixture_overlay_opacity(), "0.675")
  assert_true(ffi_drawer_pointer_end(bottom_end))
  assert_eq(
    ffi_drawer_fixture_value("--rui-drawer-transform"),
    "translate3d(0,130px,0)",
  )
  assert_eq(ffi_drawer_fixture_overlay_opacity(), "0.675")
  assert_eq(
    ffi_drawer_fixture_value("transition"),
    "opacity 200ms ease,transform 200ms ease",
  )
  assert_eq(ffi_drawer_fixture_releases(), 1)
  ffi_restore_drawer_pointer_fixture()

  ffi_install_drawer_pointer_fixture()
  let left_start = ffi_drawer_pointer_fixture_event(200, 100, 0, false)
  let left_move = ffi_drawer_pointer_fixture_event(120, 102, 100, false)
  let left_end = ffi_drawer_pointer_fixture_event(120, 102, 300, false)
  assert_true(ffi_drawer_pointer_start(left_start, "left"))
  assert_true(ffi_drawer_pointer_move(left_move))
  assert_eq(
    ffi_drawer_fixture_value("--rui-drawer-transform"),
    "translate3d(-80px,0,0)",
  )
  assert_true(ffi_drawer_pointer_end(left_end))
  ffi_restore_drawer_pointer_fixture()
}

///|
#cfg(target="js")
test "drawer drag resists the wrong direction and snaps back" {
  ffi_install_drawer_pointer_fixture()
  let start = ffi_drawer_pointer_fixture_event(100, 100, 0, false)
  let drag_move = ffi_drawer_pointer_fixture_event(100, 40, 100, false)
  let finish = ffi_drawer_pointer_fixture_event(100, 40, 300, false)
  assert_true(ffi_drawer_pointer_start(start, "bottom"))
  assert_true(ffi_drawer_pointer_move(drag_move))
  assert_eq(
    ffi_drawer_fixture_value("--rui-drawer-transform"),
    "translate3d(0,-12px,0)",
  )
  assert_true(!ffi_drawer_pointer_end(finish))
  assert_eq(
    ffi_drawer_fixture_value("--rui-drawer-transform"),
    "translate3d(0,0,0)",
  )
  ffi_restore_drawer_pointer_fixture()
}

///|
#cfg(target="js")
test "drawer drag starts only from its handle and cancel restores state" {
  ffi_install_drawer_pointer_fixture()
  let outside = ffi_drawer_pointer_fixture_event(100, 100, 0, true)
  assert_true(!ffi_drawer_pointer_start(outside, "bottom"))
  let start = ffi_drawer_pointer_fixture_event(100, 100, 0, false)
  let drag_move = ffi_drawer_pointer_fixture_event(100, 180, 100, false)
  assert_true(ffi_drawer_pointer_start(start, "bottom"))
  assert_true(ffi_drawer_pointer_move(drag_move))
  ffi_drawer_pointer_cancel(drag_move)
  assert_true(!ffi_drawer_fixture_dragging())
  assert_eq(
    ffi_drawer_fixture_value("--rui-drawer-transform"),
    "translate3d(0,0,0)",
  )
  assert_eq(ffi_drawer_fixture_releases(), 1)
  ffi_restore_drawer_pointer_fixture()
}
