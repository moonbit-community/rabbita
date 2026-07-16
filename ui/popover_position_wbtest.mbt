///|
#cfg(target="js")
extern "js" fn ffi_install_floating_position_fixture(id : String) -> Unit =
  #| id => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const styles = new Map()
  #|   const frames = []
  #|   const windowListeners = {}
  #|   const viewportListeners = {}
  #|   let anchorTop = 100
  #|   let arrowEnabled = false
  #|   let popupRect = {
  #|     left: 40,
  #|     right: 160,
  #|     top: 130,
  #|     bottom: 178,
  #|     width: 120,
  #|     height: 48,
  #|   }
  #|   let removed = 0
  #|   let measurements = 0
  #|   let observer = null
  #|   let open = true
  #|   const trigger = {
  #|     isConnected: true,
  #|     getBoundingClientRect: () => {
  #|       measurements += 1
  #|       return {
  #|         left: 40,
  #|         right: 120,
  #|         top: anchorTop,
  #|         bottom: anchorTop + 24,
  #|         width: 80,
  #|         height: 24,
  #|       }
  #|     },
  #|   }
  #|   const popup = {
  #|     isConnected: true,
  #|     __ruiFloatingOpen: true,
  #|     dataset: {
  #|       triggerId: id + "-trigger",
  #|       side: "bottom",
  #|       align: "start",
  #|       sideOffset: "6",
  #|       alignOffset: "3",
  #|     },
  #|     matches: selector => selector === ":popover-open" && open,
  #|     getBoundingClientRect: () => {
  #|       measurements += 1
  #|       return popupRect
  #|     },
  #|     querySelector: selector => selector === '[data-slot="tooltip-arrow"]'
  #|       && arrowEnabled ? {} : null,
  #|     showPopover: () => { open = true },
  #|     hidePopover: () => { open = false },
  #|     style: {
  #|       setProperty: (key, value) => styles.set(key, value),
  #|       getPropertyValue: key => styles.get(key) || "",
  #|       removeProperty: key => styles.delete(key),
  #|     },
  #|   }
  #|   const visualViewport = {
  #|     offsetLeft: 0,
  #|     offsetTop: 0,
  #|     width: 800,
  #|     height: 600,
  #|     addEventListener: (type, callback) => {
  #|       viewportListeners[type] = callback
  #|     },
  #|     removeEventListener: type => {
  #|       delete viewportListeners[type]
  #|       removed += 1
  #|     },
  #|   }
  #|   const fixture = globalThis.__ruiFloatingPositionFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     window: globalThis.window,
  #|     hadWindow: own("window"),
  #|     requestAnimationFrame: globalThis.requestAnimationFrame,
  #|     hadRequestAnimationFrame: own("requestAnimationFrame"),
  #|     cancelAnimationFrame: globalThis.cancelAnimationFrame,
  #|     hadCancelAnimationFrame: own("cancelAnimationFrame"),
  #|     ResizeObserver: globalThis.ResizeObserver,
  #|     hadResizeObserver: own("ResizeObserver"),
  #|     CSS: globalThis.CSS,
  #|     hadCSS: own("CSS"),
  #|     floatingStack: globalThis.__ruiFloatingStack,
  #|     hadFloatingStack: own("__ruiFloatingStack"),
  #|     styles,
  #|     frames,
  #|     windowListeners,
  #|     viewportListeners,
  #|     popup,
  #|     trigger,
  #|     setAnchorTop: value => { anchorTop = value },
  #|     enableArrow: () => { arrowEnabled = true },
  #|     setPopupRect: value => { popupRect = value },
  #|     removed: () => removed,
  #|     measurements: () => measurements,
  #|     getObserver: () => observer,
  #|   }
  #|   globalThis.__ruiFloatingStack = []
  #|   globalThis.document = {
  #|     activeElement: null,
  #|     body: {},
  #|     documentElement: { clientWidth: 800, clientHeight: 600 },
  #|     getElementById: value => {
  #|       if (value === id) return popup
  #|       if (value === id + "-trigger") return trigger
  #|       return null
  #|     },
  #|   }
  #|   globalThis.window = {
  #|     visualViewport,
  #|     addEventListener: (type, callback) => {
  #|       windowListeners[type] = callback
  #|     },
  #|     removeEventListener: type => {
  #|       delete windowListeners[type]
  #|       removed += 1
  #|     },
  #|   }
  #|   globalThis.requestAnimationFrame = callback => {
  #|     frames.push(callback)
  #|     return frames.length
  #|   }
  #|   globalThis.cancelAnimationFrame = () => {}
  #|   globalThis.ResizeObserver = class {
  #|     constructor(callback) {
  #|       this.callback = callback
  #|       this.disconnected = false
  #|       observer = this
  #|     }
  #|     observe() {}
  #|     disconnect() { this.disconnected = true }
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_enable_css_anchor_position_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiFloatingPositionFixture
  #|   fixture.styles.set("position-area", "bottom span-x-end")
  #|   fixture.styles.set(
  #|     "position-try-fallbacks",
  #|     "flip-inline,flip-block,flip-inline flip-block",
  #|   )
  #|   globalThis.CSS = { supports: () => true }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_enable_flipped_tooltip_arrow_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiFloatingPositionFixture
  #|   fixture.enableArrow()
  #|   fixture.popup.dataset.requestedSide = "top"
  #|   fixture.popup.dataset.side = "top"
  #|   fixture.setPopupRect({
  #|     left: 40,
  #|     right: 160,
  #|     top: 130,
  #|     bottom: 178,
  #|     width: 120,
  #|     height: 48,
  #|   })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_floating_position_fixture_style(key : String) -> String =
  #| key => globalThis.__ruiFloatingPositionFixture.styles.get(key) || ""

///|
#cfg(target="js")
extern "js" fn ffi_floating_position_fixture_frames() -> Int =
  #| () => globalThis.__ruiFloatingPositionFixture.frames.length

///|
#cfg(target="js")
extern "js" fn ffi_floating_position_fixture_measurements() -> Int =
  #| () => globalThis.__ruiFloatingPositionFixture.measurements()

///|
#cfg(target="js")
extern "js" fn ffi_floating_position_fixture_listener_count() -> Int =
  #| () => {
  #|   const fixture = globalThis.__ruiFloatingPositionFixture
  #|   return Object.keys(fixture.windowListeners).length
  #|     + Object.keys(fixture.viewportListeners).length
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_floating_position_fixture_mode() -> String =
  #| () => globalThis.__ruiFloatingPositionFixture.popup.dataset.positioning || ""

///|
#cfg(target="js")
extern "js" fn ffi_floating_position_fixture_side() -> String =
  #| () => globalThis.__ruiFloatingPositionFixture.popup.dataset.side || ""

///|
#cfg(target="js")
extern "js" fn ffi_floating_position_fixture_anchor_hidden() -> Bool =
  #| () => globalThis.__ruiFloatingPositionFixture.popup.dataset.anchorHidden !== undefined

///|
#cfg(target="js")
extern "js" fn ffi_scroll_floating_position_fixture(top : Int) -> Unit =
  #| top => {
  #|   const fixture = globalThis.__ruiFloatingPositionFixture
  #|   fixture.setAnchorTop(top)
  #|   fixture.windowListeners.scroll?.()
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_flush_floating_position_fixture_frame() -> Unit =
  #| () => globalThis.__ruiFloatingPositionFixture.frames.shift()?.()

///|
#cfg(target="js")
extern "js" fn ffi_clear_floating_position_fixture_styles() -> Unit =
  #| () => globalThis.__ruiFloatingPositionFixture.styles.clear()

///|
#cfg(target="js")
extern "js" fn ffi_floating_position_fixture_stopped() -> Bool =
  #| () => {
  #|   const fixture = globalThis.__ruiFloatingPositionFixture
  #|   return fixture.removed() >= 4
  #|     && Boolean(fixture.getObserver()?.disconnected)
  #|     && fixture.popup.dataset.positioned === undefined
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_restore_floating_position_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiFloatingPositionFixture
  #|   if (!fixture) return
  #|   fixture.popup.__ruiFloatingStopPositioning?.()
  #|   const restore = (key, had, value) => {
  #|     if (had) globalThis[key] = value
  #|     else delete globalThis[key]
  #|   }
  #|   restore("document", fixture.hadDocument, fixture.document)
  #|   restore("window", fixture.hadWindow, fixture.window)
  #|   restore(
  #|     "requestAnimationFrame",
  #|     fixture.hadRequestAnimationFrame,
  #|     fixture.requestAnimationFrame,
  #|   )
  #|   restore(
  #|     "cancelAnimationFrame",
  #|     fixture.hadCancelAnimationFrame,
  #|     fixture.cancelAnimationFrame,
  #|   )
  #|   restore(
  #|     "ResizeObserver",
  #|     fixture.hadResizeObserver,
  #|     fixture.ResizeObserver,
  #|   )
  #|   restore("CSS", fixture.hadCSS, fixture.CSS)
  #|   restore(
  #|     "__ruiFloatingStack",
  #|     fixture.hadFloatingStack,
  #|     fixture.floatingStack,
  #|   )
  #|   delete globalThis.__ruiFloatingPositionFixture
  #| }

///|
#cfg(target="js")
test "CSS anchored floating layers do not measure or subscribe to scrolling" {
  ffi_install_floating_position_fixture("css-anchored-layer")
  ffi_enable_css_anchor_position_fixture()
  ffi_position_floating("css-anchored-layer")
  let mode = ffi_floating_position_fixture_mode()
  let measurements = ffi_floating_position_fixture_measurements()
  let listeners = ffi_floating_position_fixture_listener_count()
  let frames = ffi_floating_position_fixture_frames()
  let left = ffi_floating_position_fixture_style("--rui-floating-left")
  let top = ffi_floating_position_fixture_style("--rui-floating-top")
  ffi_restore_floating_position_fixture()
  assert_eq(mode, "css-anchor")
  assert_eq(measurements, 0)
  assert_eq(listeners, 0)
  assert_eq(frames, 0)
  assert_eq(left, "")
  assert_eq(top, "")
}

///|
#cfg(target="js")
test "CSS anchor collision updates the tooltip arrow to the rendered side" {
  ffi_install_floating_position_fixture("flipped-tooltip")
  ffi_enable_css_anchor_position_fixture()
  ffi_enable_flipped_tooltip_arrow_fixture()
  ffi_position_floating("flipped-tooltip")
  let side = ffi_floating_position_fixture_side()
  let arrow_top = ffi_floating_position_fixture_style("--rui-tooltip-arrow-top")
  let arrow_bottom = ffi_floating_position_fixture_style(
    "--rui-tooltip-arrow-bottom",
  )
  ffi_restore_floating_position_fixture()
  assert_eq(side, "bottom")
  assert_eq(arrow_top, "-0.25rem")
  assert_eq(arrow_bottom, "auto")
}

///|
#cfg(target="js")
test "floating layer positions in the current frame and follows scrolling" {
  ffi_install_floating_position_fixture("anchored-layer")
  ffi_position_floating("anchored-layer")
  let initial_left = ffi_floating_position_fixture_style("--rui-floating-left")
  let initial_top = ffi_floating_position_fixture_style("--rui-floating-top")
  let initial_frames = ffi_floating_position_fixture_frames()
  ffi_scroll_floating_position_fixture(160)
  let queued_frames = ffi_floating_position_fixture_frames()
  ffi_flush_floating_position_fixture_frame()
  let scrolled_top = ffi_floating_position_fixture_style("--rui-floating-top")
  ffi_restore_floating_position_fixture()
  assert_eq(initial_left, "43px")
  assert_eq(initial_top, "130px")
  assert_eq(initial_frames, 0)
  assert_eq(queued_frames, 1)
  assert_eq(scrolled_top, "190px")
}

///|
#cfg(target="js")
test "fallback marks a detached anchor without freezing its coordinates" {
  ffi_install_floating_position_fixture("detached-layer")
  ffi_position_floating("detached-layer")
  ffi_scroll_floating_position_fixture(700)
  ffi_flush_floating_position_fixture_frame()
  let detached = ffi_floating_position_fixture_anchor_hidden()
  ffi_scroll_floating_position_fixture(180)
  ffi_flush_floating_position_fixture_frame()
  let restored = ffi_floating_position_fixture_anchor_hidden()
  ffi_restore_floating_position_fixture()
  assert_true(detached)
  assert_false(restored)
}

///|
#cfg(target="js")
test "floating layer restores runtime coordinates after a style rerender" {
  ffi_install_floating_position_fixture("rerendered-layer")
  ffi_position_floating("rerendered-layer")
  ffi_clear_floating_position_fixture_styles()
  ffi_position_floating("rerendered-layer")
  let left = ffi_floating_position_fixture_style("--rui-floating-left")
  let top = ffi_floating_position_fixture_style("--rui-floating-top")
  ignore(ffi_set_floating_open("rerendered-layer", false))
  let stopped = ffi_floating_position_fixture_stopped()
  ffi_restore_floating_position_fixture()
  assert_eq(left, "43px")
  assert_eq(top, "130px")
  assert_true(stopped)
}
