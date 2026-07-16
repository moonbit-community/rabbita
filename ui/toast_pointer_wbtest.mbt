///|
#cfg(target="js")
extern "js" fn ffi_install_toast_pointer_fixture(rtl : Bool) -> Unit =
  #| rtl => {
  #|   const props = {
  #|     transition: "opacity 150ms ease,transform 150ms ease",
  #|   }
  #|   const style = {
  #|     getPropertyValue: key => props[key] || "",
  #|     setProperty: (key, value) => { props[key] = value },
  #|     removeProperty: key => { delete props[key] },
  #|   }
  #|   const plain = { closest: () => null }
  #|   const interactive = {
  #|     closest: selector => selector.includes("button") ? interactive : null,
  #|   }
  #|   const surface = {
  #|     clientWidth: 300,
  #|     style,
  #|     dataset: {},
  #|     __direction: rtl ? "rtl" : "ltr",
  #|     captures: 0,
  #|     releases: 0,
  #|     setPointerCapture() { this.captures += 1 },
  #|     releasePointerCapture() { this.releases += 1 },
  #|   }
  #|   const previousGetComputedStyle = globalThis.getComputedStyle
  #|   globalThis.getComputedStyle = element => ({ direction: element.__direction || "ltr" })
  #|   globalThis.__ruiToastPointerFixture = {
  #|     props,
  #|     plain,
  #|     interactive,
  #|     surface,
  #|     previousGetComputedStyle,
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_toast_pointer_fixture_event(
  x : Int,
  y : Int,
  time : Int,
  interactive : Bool,
) -> @dom.MouseEvent =
  #| (x, y, time, interactive) => {
  #|   const fixture = globalThis.__ruiToastPointerFixture
  #|   return {
  #|     currentTarget: fixture.surface,
  #|     target: interactive ? fixture.interactive : fixture.plain,
  #|     pointerId: 5,
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
extern "js" fn ffi_toast_fixture_value(key : String) -> String =
  #| key => globalThis.__ruiToastPointerFixture?.props?.[key] || ""

///|
#cfg(target="js")
extern "js" fn ffi_toast_fixture_swiping() -> Bool =
  #| () => globalThis.__ruiToastPointerFixture?.surface?.dataset?.swipe === "move"

///|
#cfg(target="js")
extern "js" fn ffi_toast_fixture_releases() -> Int =
  #| () => globalThis.__ruiToastPointerFixture?.surface?.releases ?? 0

///|
#cfg(target="js")
extern "js" fn ffi_restore_toast_pointer_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiToastPointerFixture
  #|   if (fixture?.previousGetComputedStyle) {
  #|     globalThis.getComputedStyle = fixture.previousGetComputedStyle
  #|   } else {
  #|     delete globalThis.getComputedStyle
  #|   }
  #|   delete globalThis.__ruiToastPointerFixture
  #| }

///|
#cfg(target="js")
test "toast swipe dismisses toward logical inline end in LTR and RTL" {
  ffi_install_toast_pointer_fixture(false)
  let start = ffi_toast_pointer_fixture_event(20, 20, 0, false)
  let drag_move = ffi_toast_pointer_fixture_event(145, 22, 200, false)
  let finish = ffi_toast_pointer_fixture_event(145, 22, 350, false)
  assert_true(ffi_toast_pointer_start(start))
  assert_true(ffi_toast_pointer_move(drag_move))
  assert_true(ffi_toast_fixture_swiping())
  assert_eq(ffi_toast_fixture_value("--rui-toast-swipe-x"), "125px")
  assert_eq(ffi_toast_pointer_end(finish), 2)
  assert_eq(ffi_toast_fixture_value("--rui-toast-swipe-x"), "")
  assert_eq(
    ffi_toast_fixture_value("transition"),
    "opacity 150ms ease,transform 150ms ease",
  )
  assert_eq(ffi_toast_fixture_releases(), 1)
  ffi_restore_toast_pointer_fixture()

  ffi_install_toast_pointer_fixture(true)
  let rtl_start = ffi_toast_pointer_fixture_event(260, 20, 0, false)
  let rtl_drag = ffi_toast_pointer_fixture_event(130, 20, 200, false)
  let rtl_finish = ffi_toast_pointer_fixture_event(130, 20, 350, false)
  assert_true(ffi_toast_pointer_start(rtl_start))
  assert_true(ffi_toast_pointer_move(rtl_drag))
  assert_eq(ffi_toast_fixture_value("--rui-toast-swipe-x"), "-130px")
  assert_eq(ffi_toast_pointer_end(rtl_finish), -2)
  ffi_restore_toast_pointer_fixture()
}

///|
#cfg(target="js")
test "toast swipe preserves vertical scrolling and interactive controls" {
  ffi_install_toast_pointer_fixture(false)
  let interactive = ffi_toast_pointer_fixture_event(20, 20, 0, true)
  assert_true(!ffi_toast_pointer_start(interactive))
  let start = ffi_toast_pointer_fixture_event(20, 20, 0, false)
  let vertical = ffi_toast_pointer_fixture_event(24, 90, 100, false)
  assert_true(ffi_toast_pointer_start(start))
  assert_true(!ffi_toast_pointer_move(vertical))
  assert_true(!ffi_toast_fixture_swiping())
  assert_eq(ffi_toast_fixture_releases(), 1)
  ffi_restore_toast_pointer_fixture()
}
