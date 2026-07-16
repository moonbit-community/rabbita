///|
#warnings("-alert_unstable")
fn render_scroll_area_html(html : @html.Html) -> String {
  @rabbita.render_to_string(() => @rabbita.Val::constant(html))
}

///|
#cfg(target="js")
extern "js" fn install_scroll_area_test_window() =
  #| () => {
  #|   if (typeof globalThis.window === "undefined") {
  #|     globalThis.window = { requestAnimationFrame: () => 0 };
  #|   }
  #| }

///|
#warnings("-alert_unstable")
#cfg(target="js")
fn render_scroll_area_incremental(
  builder : () -> @rabbita.Val[@html.Html],
) -> String {
  install_scroll_area_test_window()
  ignore(@rabbita.new(builder))
  @rabbita.render_to_string(builder)
}

///|
#warnings("-alert_unstable")
#cfg(not(target="js"))
fn render_scroll_area_incremental(
  builder : () -> @rabbita.Val[@html.Html],
) -> String {
  @rabbita.render_to_string(builder)
}

///|
fn scroll_area_assert_contains(
  actual : String,
  expected : String,
) -> Unit raise {
  if !actual.contains(expected) {
    fail("expected rendered HTML to contain `\{expected}`; got `\{actual}`")
  }
}

///|
fn scroll_area_assert_not_contains(
  actual : String,
  unexpected : String,
) -> Unit raise {
  if actual.contains(unexpected) {
    fail(
      "expected rendered HTML not to contain `\{unexpected}`; got `\{actual}`",
    )
  }
}

///|
#cfg(target="js")
extern "js" fn install_scroll_area_pointer_fixture(
  id : String,
  direction : String,
) -> Unit =
  #| (id, direction) => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const listeners = {}
  #|   const thumb = {}
  #|   const viewport = {
  #|     clientHeight: 100,
  #|     clientWidth: 100,
  #|     scrollHeight: 1000,
  #|     scrollWidth: 1000,
  #|     scrollTop: 0,
  #|     scrollLeft: 0,
  #|     addEventListener: (type, callback) => { listeners[`viewport:${type}`] = callback },
  #|   }
  #|   const track = {
  #|     addEventListener: (type, callback) => { listeners[`track:${type}`] = callback },
  #|     getBoundingClientRect: () => ({ left: 0, top: 0, width: 100, height: 100 }),
  #|     setPointerCapture: () => { fixture.captures += 1 },
  #|     releasePointerCapture: () => { fixture.releases += 1 },
  #|   }
  #|   const root = {
  #|     querySelector: selector => selector.includes('viewport')
  #|       ? viewport
  #|       : selector.includes('scrollbar') ? track : thumb,
  #|   }
  #|   const fixture = globalThis.__ruiScrollAreaPointerFixture = {
  #|     document: globalThis.document,
  #|     getComputedStyle: globalThis.getComputedStyle,
  #|     hadDocument: own('document'),
  #|     hadGetComputedStyle: own('getComputedStyle'),
  #|     direction,
  #|     listeners,
  #|     root,
  #|     track,
  #|     thumb,
  #|     viewport,
  #|     captures: 0,
  #|     releases: 0,
  #|   }
  #|   globalThis.document = { getElementById: value => value === id ? root : null }
  #|   globalThis.getComputedStyle = () => ({ direction: fixture.direction })
  #| }

///|
#cfg(target="js")
extern "js" fn fire_scroll_area_pointer_fixture(
  horizontal : Bool,
  target_thumb : Bool,
) -> Unit =
  #| (horizontal, targetThumb) => {
  #|   const fixture = globalThis.__ruiScrollAreaPointerFixture
  #|   const base = {
  #|     button: 0,
  #|     pointerId: 7,
  #|     clientX: targetThumb ? 95 : 0,
  #|     clientY: targetThumb ? 5 : 0,
  #|     target: targetThumb ? fixture.thumb : fixture.track,
  #|     preventDefault: () => {},
  #|   }
  #|   fixture.listeners['track:pointerdown'](base)
  #|   fixture.listeners['track:pointermove']({
  #|     ...base,
  #|     clientX: horizontal ? 50 : base.clientX,
  #|     clientY: horizontal ? base.clientY : 50,
  #|   })
  #|   fixture.listeners['track:pointerup'](base)
  #| }

///|
#cfg(target="js")
extern "js" fn scroll_area_pointer_fixture_value(kind : Int) -> Double =
  #| kind => {
  #|   const fixture = globalThis.__ruiScrollAreaPointerFixture
  #|   if (kind === 0) return fixture.viewport.scrollTop
  #|   if (kind === 1) return fixture.viewport.scrollLeft
  #|   if (kind === 2) return fixture.captures
  #|   return fixture.releases
  #| }

///|
#cfg(target="js")
extern "js" fn restore_scroll_area_pointer_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiScrollAreaPointerFixture
  #|   if (!fixture) return
  #|   if (fixture.hadDocument) globalThis.document = fixture.document
  #|   else delete globalThis.document
  #|   if (fixture.hadGetComputedStyle) globalThis.getComputedStyle = fixture.getComputedStyle
  #|   else delete globalThis.getComputedStyle
  #|   delete globalThis.__ruiScrollAreaPointerFixture
  #| }

///|
#cfg(target="js")
test "managed scrollbar thumb drags vertically with pointer capture" {
  let offset = Ref(0.0)
  install_scroll_area_pointer_fixture("drag-scroll", "ltr")
  ffi_bind_scroll_area_pointer("drag-scroll", true, (next, _, _) => {
    offset.val = next
  })
  fire_scroll_area_pointer_fixture(false, true)
  let scroll_top = scroll_area_pointer_fixture_value(0)
  let captures = scroll_area_pointer_fixture_value(2)
  let releases = scroll_area_pointer_fixture_value(3)
  restore_scroll_area_pointer_fixture()
  assert_eq(offset.val, 450.0)
  assert_eq(scroll_top, 450.0)
  assert_eq(captures, 1.0)
  assert_eq(releases, 1.0)
}

///|
#cfg(target="js")
test "managed horizontal scrollbar normalizes RTL scrollLeft" {
  let offset = Ref(0.0)
  install_scroll_area_pointer_fixture("rtl-scroll", "rtl")
  ffi_bind_scroll_area_pointer("rtl-scroll", false, (next, _, _) => {
    offset.val = next
  })
  fire_scroll_area_pointer_fixture(true, false)
  let scroll_left = scroll_area_pointer_fixture_value(1)
  restore_scroll_area_pointer_fixture()
  assert_eq(offset.val, 450.0)
  assert_eq(scroll_left, -450.0)
}

///|
test "scroll area metrics produce a proportional bounded thumb" {
  let middle : ScrollAreaMetrics = {
    offset: 450.0,
    viewport: 100.0,
    content: 1000.0,
  }
  assert_eq(scroll_area_thumb_size_hundredths(middle), 1000)
  assert_eq(scroll_area_thumb_offset_hundredths(middle), 4500)
  assert_eq(scroll_area_percent(1000), "10%")
  assert_eq(scroll_area_percent(5), "0.05%")
  let past_end : ScrollAreaMetrics = {
    offset: 5000.0,
    viewport: 100.0,
    content: 1000.0,
  }
  assert_eq(scroll_area_thumb_offset_hundredths(past_end), 9000)
  let idle : ScrollAreaMetrics = {
    offset: 0.0,
    viewport: 200.0,
    content: 100.0,
  }
  assert_eq(scroll_area_thumb_size_hundredths(idle), 10000)
  assert_eq(scroll_area_thumb_offset_hundredths(idle), 0)
}

///|
test "managed vertical scroll area renders its black-box structure" {
  let attrs = @html.Attrs::build().data_set("owner", "caller")
  let html = render_scroll_area_incremental(() => {
    scroll_area_with_scrollbar(
      id="managed-scroll",
      attrs~,
      style=["height:12rem", "--rui-scrollbar-size:0.75rem"],
      @html.p("Scrollable content"),
    )
  })
  scroll_area_assert_contains(html, "id=\"managed-scroll\"")
  scroll_area_assert_contains(html, "data-slot=\"scroll-area\"")
  scroll_area_assert_contains(html, "data-managed=\"\"")
  scroll_area_assert_contains(html, "data-orientation=\"vertical\"")
  scroll_area_assert_contains(html, "data-state=\"idle\"")
  scroll_area_assert_contains(html, "data-scrollable=\"false\"")
  scroll_area_assert_contains(html, "id=\"managed-scroll-viewport\"")
  scroll_area_assert_contains(html, "data-slot=\"scroll-area-viewport\"")
  scroll_area_assert_contains(html, "tabindex=\"0\"")
  scroll_area_assert_contains(html, "outline-offset:2px")
  scroll_area_assert_contains(html, "overflow-y:auto;overflow-x:hidden")
  scroll_area_assert_contains(html, "id=\"managed-scroll-scrollbar\"")
  scroll_area_assert_contains(html, "data-slot=\"scroll-area-scrollbar\"")
  scroll_area_assert_contains(html, "data-thumb-size=\"100%\"")
  scroll_area_assert_contains(html, "data-thumb-offset=\"0%\"")
  scroll_area_assert_contains(html, "aria-hidden=\"true\"")
  scroll_area_assert_contains(html, "id=\"managed-scroll-thumb\"")
  scroll_area_assert_contains(html, "data-slot=\"scroll-area-thumb\"")
  scroll_area_assert_contains(
    html, "top:0%;inset-inline-start:1px;width:calc(100% - 2px);height:100%",
  )
  scroll_area_assert_contains(html, "opacity:0;pointer-events:none")
  scroll_area_assert_contains(html, "height:12rem;--rui-scrollbar-size:0.75rem")
  scroll_area_assert_contains(html, ">Scrollable content</p>")

  let original = render_scroll_area_html(@html.div(attrs~, @html.nothing))
  scroll_area_assert_contains(original, "data-owner=\"caller\"")
  scroll_area_assert_not_contains(original, "data-slot")
}

///|
test "managed horizontal scroll area switches its native axis and thumb" {
  let html = render_scroll_area_incremental(() => {
    scroll_area_with_scrollbar(
      orientation=Horizontal,
      id="horizontal-scroll",
      style=["width:20rem"],
      @html.div("Wide content"),
    )
  })
  scroll_area_assert_contains(html, "data-orientation=\"horizontal\"")
  scroll_area_assert_contains(html, "overflow-x:auto;overflow-y:hidden")
  scroll_area_assert_contains(
    html, "inset-inline-start:0;bottom:0;width:100%;height:var(--rui-scrollbar-size,0.625rem)",
  )
  scroll_area_assert_contains(
    html, "top:1px;left:0%;width:100%;height:calc(100% - 2px)",
  )
}

///|
test "pure scroll area and decorative bar remain unchanged alternatives" {
  let html = render_scroll_area_html(
    scroll_area(
      orientation=Horizontal,
      id="pure-scroll",
      style=["width:10rem"],
      [@html.span("Pure content"), scroll_bar(orientation=Horizontal)],
    ),
  )
  scroll_area_assert_contains(html, "id=\"pure-scroll\"")
  scroll_area_assert_contains(html, "data-slot=\"scroll-area\"")
  scroll_area_assert_contains(html, "tabindex=\"0\"")
  scroll_area_assert_contains(html, "outline-offset:2px")
  scroll_area_assert_contains(html, "overflow-x:auto;overflow-y:hidden")
  scroll_area_assert_contains(html, "data-slot=\"scroll-area-scrollbar\"")
  scroll_area_assert_contains(html, "pointer-events:none")
  scroll_area_assert_not_contains(html, "data-managed")
  scroll_area_assert_not_contains(html, "scroll-area-viewport")
}
