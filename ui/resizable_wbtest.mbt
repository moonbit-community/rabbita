///|
test "resizable keyboard follows the panel group axis" {
  assert_eq(resizable_key_size(47, 10, 90, Horizontal, "ArrowRight"), Some(48))
  assert_eq(resizable_key_size(47, 10, 90, Horizontal, "ArrowLeft"), Some(46))
  assert_eq(resizable_key_size(47, 10, 90, Horizontal, "ArrowUp"), None)
  assert_eq(resizable_key_size(47, 10, 90, Vertical, "ArrowDown"), Some(48))
  assert_eq(resizable_key_size(47, 10, 90, Vertical, "ArrowUp"), Some(46))
  assert_eq(resizable_key_size(47, 10, 90, Vertical, "ArrowRight"), None)
}

///|
test "resizable keyboard clamps arrows and supports Home and End" {
  assert_eq(resizable_key_size(10, 10, 90, Horizontal, "ArrowLeft"), Some(10))
  assert_eq(resizable_key_size(90, 10, 90, Vertical, "ArrowDown"), Some(90))
  assert_eq(resizable_key_size(47, 10, 90, Horizontal, "Home"), Some(10))
  assert_eq(resizable_key_size(47, 10, 90, Vertical, "End"), Some(90))
}

///|
test "resizable horizontal keyboard mirrors left and right in RTL" {
  assert_eq(
    resizable_key_for_direction(Horizontal, "ArrowLeft", true),
    "ArrowRight",
  )
  assert_eq(
    resizable_key_for_direction(Horizontal, "ArrowRight", true),
    "ArrowLeft",
  )
  assert_eq(
    resizable_key_for_direction(Vertical, "ArrowLeft", true),
    "ArrowLeft",
  )
  assert_eq(resizable_key_for_direction(Horizontal, "Home", true), "Home")
}

///|
test "three panel resize changes only the selected adjacent pair" {
  let sizes = [20, 30, 50]
  let minimums = [10, 20, 25]
  let maximums = [50, 60, 70]
  let first = resizable_resize_between(sizes, minimums, maximums, 0, 45)
  assert_eq(first, [30, 20, 50])
  assert_eq(resizable_sum(first), 100)
  let second = resizable_resize_between(sizes, minimums, maximums, 1, 60)
  assert_eq(second, [20, 55, 25])
  assert_eq(resizable_sum(second), 100)
  assert_eq(sizes, [20, 30, 50])
}

///|
test "three panel handles clamp per-panel bounds and reject invalid gaps" {
  let sizes = [20, 30, 50]
  let minimums = [10, 20, 25]
  let maximums = [50, 60, 70]
  assert_eq(resizable_resize_between(sizes, minimums, maximums, 0, -100), [
    10, 40, 50,
  ])
  assert_eq(resizable_resize_between(sizes, minimums, maximums, 1, 100), [
    20, 55, 25,
  ])
  assert_eq(resizable_resize_between(sizes, minimums, maximums, 2, 10), sizes)
}

///|
test "three panel keyboard updates the matching handle and axis" {
  let sizes = [20, 30, 50]
  let minimums = [10, 20, 25]
  let maximums = [50, 60, 70]
  assert_eq(
    resizable_key_sizes(sizes, minimums, maximums, 0, Horizontal, "ArrowRight"),
    Some([21, 29, 50]),
  )
  assert_eq(
    resizable_key_sizes(sizes, minimums, maximums, 1, Horizontal, "ArrowUp"),
    None,
  )
  assert_eq(
    resizable_key_sizes(sizes, minimums, maximums, 1, Vertical, "ArrowDown"),
    Some([20, 31, 49]),
  )
  assert_eq(
    resizable_key_sizes(sizes, minimums, maximums, 1, Vertical, "ArrowRight"),
    None,
  )
}

///|
test "pointer geometry follows horizontal and vertical group axes" {
  assert_eq(
    resizable_pointer_percent(Horizontal, 260, 999, 100, 40, 400, 800),
    Some(40),
  )
  assert_eq(
    resizable_pointer_percent(Vertical, 999, 240, 100, 40, 400, 800),
    Some(25),
  )
  assert_eq(
    resizable_pointer_percent(Horizontal, -20, 0, 100, 40, 400, 800),
    Some(0),
  )
  assert_eq(
    resizable_pointer_percent(Vertical, 0, 1000, 100, 40, 400, 800),
    Some(100),
  )
  assert_eq(
    resizable_pointer_percent(Horizontal, 100, 100, 100, 40, 0, 800),
    None,
  )
}

///|
test "absolute pointer percent targets only its adjacent pair" {
  let sizes = [20, 30, 50]
  let minimums = [10, 20, 25]
  let maximums = [50, 60, 70]
  assert_eq(resizable_resize_at_percent(sizes, minimums, maximums, 0, 35), [
    30, 20, 50,
  ])
  assert_eq(resizable_resize_at_percent(sizes, minimums, maximums, 1, 65), [
    20, 45, 35,
  ])
}

///|
test "layout preparation fills defaults to a bounded total of one hundred" {
  let (sizes, minimums, maximums) = resizable_prepare_layout(
    [15, 25, 40],
    [10, 20, 25],
    [50, 60, 70],
  )
  assert_eq(sizes, [35, 25, 40])
  assert_eq(minimums, [10, 20, 25])
  assert_eq(maximums, [50, 60, 70])
  assert_eq(resizable_sum(sizes), 100)
}

///|
#cfg(target="js")
extern "js" fn ffi_install_resizable_pointer_fixture(id : String) -> Unit =
  #| id => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const listeners = {}
  #|   const fixture = globalThis.__ruiResizablePointerFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     getComputedStyle: globalThis.getComputedStyle,
  #|     hadGetComputedStyle: own("getComputedStyle"),
  #|     direction: "ltr",
  #|     listeners,
  #|     captures: 0,
  #|     releases: 0,
  #|     prevented: 0,
  #|     focuses: [0, 0],
  #|   }
  #|   const controls = [0, 1].map(index => ({
  #|     disabled: false,
  #|     focus: () => { fixture.focuses[index] += 1 },
  #|   }))
  #|   const handles = [0, 1].map(index => {
  #|     const handle = {
  #|       dataset: { between: String(index) },
  #|       querySelector: () => controls[index],
  #|       closest: selector => selector.includes("panel-group")
  #|         ? fixture.root
  #|         : handle,
  #|       removeAttribute: name => {
  #|         if (name === "data-resizing") delete handle.dataset.resizing
  #|       },
  #|     }
  #|     return handle
  #|   })
  #|   const root = {
  #|     dataset: { orientation: "horizontal" },
  #|     contains: node => handles.includes(node),
  #|     addEventListener: (type, callback) => { listeners[type] = callback },
  #|     getBoundingClientRect: () => ({
  #|       left: 100, top: 40, width: 400, height: 800,
  #|     }),
  #|     setPointerCapture: () => { fixture.captures += 1 },
  #|     releasePointerCapture: () => { fixture.releases += 1 },
  #|   }
  #|   fixture.root = root
  #|   fixture.handles = handles
  #|   globalThis.document = { getElementById: value => value === id ? root : null }
  #|   globalThis.getComputedStyle = () => ({ direction: fixture.direction })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_set_resizable_pointer_direction(direction : String) -> Unit =
  #| direction => {
  #|   globalThis.__ruiResizablePointerFixture.direction = direction
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_fire_resizable_pointer_fixture(
  between : Int,
  pointer_id : Int,
  client_x : Int,
  client_y : Int,
) -> Unit =
  #| (between, pointerId, clientX, clientY) => {
  #|   const fixture = globalThis.__ruiResizablePointerFixture
  #|   const event = {
  #|     button: 0,
  #|     pointerId,
  #|     clientX,
  #|     clientY,
  #|     target: fixture.handles[between],
  #|     preventDefault: () => { fixture.prevented += 1 },
  #|   }
  #|   fixture.listeners.pointerdown(event)
  #|   fixture.listeners.pointermove({ ...event, clientX: clientX + 20 })
  #|   fixture.listeners.pointerup(event)
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_resizable_pointer_fixture_count(kind : Int) -> Int =
  #| kind => {
  #|   const fixture = globalThis.__ruiResizablePointerFixture
  #|   if (kind === 0) return fixture.captures
  #|   if (kind === 1) return fixture.releases
  #|   if (kind === 2) return fixture.prevented
  #|   return fixture.focuses[0] + fixture.focuses[1]
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_restore_resizable_pointer_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiResizablePointerFixture
  #|   if (!fixture) return
  #|   if (fixture.hadDocument) globalThis.document = fixture.document
  #|   else delete globalThis.document
  #|   if (fixture.hadGetComputedStyle) globalThis.getComputedStyle = fixture.getComputedStyle
  #|   else delete globalThis.getComputedStyle
  #|   delete globalThis.__ruiResizablePointerFixture
  #| }

///|
#cfg(target="js")
test "pointer binding captures and independently dispatches multiple handles" {
  let calls = Ref(0)
  let last_between = Ref(-1)
  let last_client_x = Ref(-1)
  let last_width = Ref(-1)
  ffi_install_resizable_pointer_fixture("pointer-layout")
  ffi_bind_resizable_pointer("pointer-layout", (
    between,
    client_x,
    _,
    _,
    _,
    width,
    _,
  ) => {
    calls.val += 1
    last_between.val = between
    last_client_x.val = client_x
    last_width.val = width
  })
  ffi_fire_resizable_pointer_fixture(0, 7, 180, 200)
  ffi_fire_resizable_pointer_fixture(1, 8, 320, 300)
  let captures = ffi_resizable_pointer_fixture_count(0)
  let releases = ffi_resizable_pointer_fixture_count(1)
  let prevented = ffi_resizable_pointer_fixture_count(2)
  let focuses = ffi_resizable_pointer_fixture_count(3)
  ffi_restore_resizable_pointer_fixture()
  assert_eq(calls.val, 4)
  assert_eq(last_between.val, 1)
  assert_eq(last_client_x.val, 340)
  assert_eq(last_width.val, 400)
  assert_eq(captures, 2)
  assert_eq(releases, 2)
  assert_eq(prevented, 4)
  assert_eq(focuses, 2)
}

///|
#cfg(target="js")
test "horizontal pointer geometry mirrors in RTL" {
  let last_client_x = Ref(-1)
  ffi_install_resizable_pointer_fixture("rtl-pointer-layout")
  ffi_set_resizable_pointer_direction("rtl")
  ffi_bind_resizable_pointer("rtl-pointer-layout", (_, client_x, _, _, _, _, _) => {
    last_client_x.val = client_x
  })
  ffi_fire_resizable_pointer_fixture(0, 7, 180, 200)
  ffi_restore_resizable_pointer_fixture()
  assert_eq(last_client_x.val, 400)
}
