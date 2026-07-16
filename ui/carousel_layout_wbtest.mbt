///|
#cfg(target="js")
extern "js" fn ffi_install_carousel_layout_fixture(
  orientation : String,
  rtl : Bool,
  active : Int,
  loop_ : Bool,
  viewport_size : Int,
) -> Unit =
  #| (orientation, rtl, active, loop, viewportSize) => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const saved = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     getComputedStyle: globalThis.getComputedStyle,
  #|     hadGetComputedStyle: own("getComputedStyle"),
  #|     requestAnimationFrame: globalThis.requestAnimationFrame,
  #|     hadRequestAnimationFrame: own("requestAnimationFrame"),
  #|     ResizeObserver: globalThis.ResizeObserver,
  #|     hadResizeObserver: own("ResizeObserver"),
  #|   }
  #|   const values = new Map([
  #|     ["transition", "var(--rui-carousel-track-transition)"],
  #|   ])
  #|   const style = {
  #|     getPropertyValue: key => values.get(key) || "",
  #|     setProperty: (key, value) => values.set(key, String(value)),
  #|     removeProperty: key => values.delete(key),
  #|   }
  #|   const root = {
  #|     dataset: {
  #|       slot: "carousel",
  #|       orientation,
  #|       activeIndex: String(active),
  #|       count: "3",
  #|       loop: String(loop),
  #|     },
  #|     isConnected: true,
  #|   }
  #|   const closest = selector => selector === '[data-slot="carousel"]' ? root : null
  #|   const item = index => {
  #|     const attributes = new Map()
  #|     return {
  #|       dataset: { slot: "carousel-item", index: String(index) },
  #|       offsetLeft: 0,
  #|       offsetTop: 0,
  #|       offsetWidth: 100,
  #|       offsetHeight: 100,
  #|       inert: false,
  #|       attributes,
  #|       closest,
  #|       setAttribute: (name, value) => attributes.set(name, String(value)),
  #|       removeAttribute: name => attributes.delete(name),
  #|       getAttribute: name => attributes.get(name) || null,
  #|     }
  #|   }
  #|   const items = [item(0), item(1), item(2)]
  #|   const place = (size, itemSize, step) => {
  #|     viewport.clientWidth = size
  #|     viewport.clientHeight = size
  #|     items.forEach((entry, index) => {
  #|       entry.offsetWidth = itemSize
  #|       entry.offsetHeight = itemSize
  #|       entry.offsetTop = index * step
  #|       entry.offsetLeft = rtl ? (items.length - 1 - index) * step : index * step
  #|     })
  #|   }
  #|   const track = { dataset: { slot: "carousel-track" }, style, closest }
  #|   const viewport = {
  #|     dataset: { slot: "carousel-content" },
  #|     clientWidth: viewportSize,
  #|     clientHeight: viewportSize,
  #|     closest,
  #|   }
  #|   const control = slot => ({
  #|     dataset: { slot },
  #|     disabled: false,
  #|     attributes: new Map(),
  #|     closest,
  #|     setAttribute(name, value) { this.attributes.set(name, String(value)) },
  #|   })
  #|   const previous = control("carousel-previous")
  #|   const next = control("carousel-next")
  #|   const bySelector = selector => {
  #|     if (selector === '[data-slot="carousel-content"]') return [viewport]
  #|     if (selector === '[data-slot="carousel-track"]') return [track]
  #|     if (selector === '[data-slot="carousel-item"]') return items
  #|     if (selector === '[data-slot="carousel-previous"]') return [previous]
  #|     if (selector === '[data-slot="carousel-next"]') return [next]
  #|     return []
  #|   }
  #|   root.querySelectorAll = bySelector
  #|   place(viewportSize, 100, 105)
  #|   const fixture = globalThis.__ruiCarouselLayoutFixture = {
  #|     saved,
  #|     root,
  #|     viewport,
  #|     track,
  #|     items,
  #|     previous,
  #|     next,
  #|     values,
  #|     raf: [],
  #|     resize: null,
  #|     place,
  #|   }
  #|   globalThis.document = {
  #|     getElementById: id => id === "layout-carousel" ? root : null,
  #|   }
  #|   globalThis.getComputedStyle = () => ({ direction: rtl ? "rtl" : "ltr" })
  #|   globalThis.requestAnimationFrame = callback => {
  #|     fixture.raf.push(callback)
  #|     return fixture.raf.length
  #|   }
  #|   globalThis.ResizeObserver = class {
  #|     constructor(callback) { fixture.resize = callback }
  #|     observe() { }
  #|     disconnect() { }
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_carousel_layout_offset() -> String =
  #| () => globalThis.__ruiCarouselLayoutFixture.values.get("--rui-carousel-offset") || ""

///|
#cfg(target="js")
extern "js" fn ffi_carousel_layout_transition() -> String =
  #| () => globalThis.__ruiCarouselLayoutFixture.values.get("transition") || ""

///|
#cfg(target="js")
extern "js" fn ffi_carousel_layout_visible(index : Int) -> Bool =
  #| index => globalThis.__ruiCarouselLayoutFixture.items[index]?.dataset.visible === "true"

///|
#cfg(target="js")
extern "js" fn ffi_carousel_layout_hidden(index : Int) -> Bool =
  #| index => globalThis.__ruiCarouselLayoutFixture.items[index]?.getAttribute("aria-hidden") === "true"

///|
#cfg(target="js")
extern "js" fn ffi_carousel_layout_inert(index : Int) -> Bool =
  #| index => Boolean(globalThis.__ruiCarouselLayoutFixture.items[index]?.inert)

///|
#cfg(target="js")
extern "js" fn ffi_carousel_layout_next_disabled() -> Bool =
  #| () => globalThis.__ruiCarouselLayoutFixture.next.disabled

///|
#cfg(target="js")
extern "js" fn ffi_carousel_layout_set_active(index : Int) -> Unit =
  #| index => { globalThis.__ruiCarouselLayoutFixture.root.dataset.activeIndex = String(index) }

///|
#cfg(target="js")
extern "js" fn ffi_carousel_layout_resize(
  viewport_size : Int,
  item_size : Int,
  step : Int,
) -> Unit =
  #| (viewportSize, itemSize, step) => {
  #|   const fixture = globalThis.__ruiCarouselLayoutFixture
  #|   fixture.place(viewportSize, itemSize, step)
  #|   fixture.resize?.()
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_carousel_layout_flush_frame() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiCarouselLayoutFixture
  #|   const callbacks = fixture.raf.splice(0)
  #|   callbacks.forEach(callback => callback())
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_restore_carousel_layout_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiCarouselLayoutFixture
  #|   if (!fixture) return
  #|   const restore = (key, had, value) => {
  #|     if (had) globalThis[key] = value
  #|     else delete globalThis[key]
  #|   }
  #|   restore("document", fixture.saved.hadDocument, fixture.saved.document)
  #|   restore(
  #|     "getComputedStyle",
  #|     fixture.saved.hadGetComputedStyle,
  #|     fixture.saved.getComputedStyle,
  #|   )
  #|   restore(
  #|     "requestAnimationFrame",
  #|     fixture.saved.hadRequestAnimationFrame,
  #|     fixture.saved.requestAnimationFrame,
  #|   )
  #|   restore("ResizeObserver", fixture.saved.hadResizeObserver, fixture.saved.ResizeObserver)
  #|   delete globalThis.__ruiCarouselLayoutFixture
  #| }

///|
#cfg(target="js")
test "carousel layout measures gap and basis exposes every visible slide and resizes" {
  ffi_install_carousel_layout_fixture("horizontal", false, 1, false, 205)
  let max_index = Ref(-1)
  ffi_carousel_sync_layout("layout-carousel", measured => {
    max_index.val = measured
  })
  assert_eq(max_index.val, 1)
  assert_eq(ffi_carousel_layout_offset(), "-105px")
  assert_true(!ffi_carousel_layout_visible(0))
  assert_true(ffi_carousel_layout_hidden(0))
  assert_true(ffi_carousel_layout_inert(0))
  assert_true(ffi_carousel_layout_visible(1))
  assert_true(ffi_carousel_layout_visible(2))
  assert_true(!ffi_carousel_layout_hidden(2))
  assert_true(!ffi_carousel_layout_inert(2))
  assert_true(ffi_carousel_layout_next_disabled())
  assert_eq(ffi_carousel_layout_transition(), "none")
  ffi_carousel_layout_flush_frame()
  assert_eq(
    ffi_carousel_layout_transition(),
    "var(--rui-carousel-track-transition)",
  )
  ffi_carousel_layout_resize(150, 75, 80)
  assert_eq(max_index.val, 2)
  assert_eq(ffi_carousel_layout_offset(), "-80px")
  ffi_restore_carousel_layout_fixture()
}

///|
#cfg(target="js")
test "carousel measured offsets preserve RTL and vertical directions" {
  ffi_install_carousel_layout_fixture("horizontal", true, 2, false, 100)
  ffi_carousel_sync_layout("layout-carousel", _ => ())
  assert_eq(ffi_carousel_layout_offset(), "210px")
  ffi_restore_carousel_layout_fixture()

  ffi_install_carousel_layout_fixture("vertical", false, 2, false, 100)
  ffi_carousel_sync_layout("layout-carousel", _ => ())
  assert_eq(ffi_carousel_layout_offset(), "-210px")
  ffi_restore_carousel_layout_fixture()
}

///|
#cfg(target="js")
test "carousel loop wrap installs the target offset without a long transition" {
  ffi_install_carousel_layout_fixture("horizontal", false, 2, true, 100)
  ffi_carousel_sync_layout("layout-carousel", _ => ())
  assert_eq(ffi_carousel_layout_offset(), "-210px")
  ffi_carousel_layout_flush_frame()
  assert_eq(
    ffi_carousel_layout_transition(),
    "var(--rui-carousel-track-transition)",
  )
  ffi_carousel_layout_set_active(0)
  ffi_carousel_sync_layout("layout-carousel", _ => ())
  assert_eq(ffi_carousel_layout_offset(), "0px")
  assert_eq(ffi_carousel_layout_transition(), "none")
  ffi_carousel_layout_flush_frame()
  assert_eq(
    ffi_carousel_layout_transition(),
    "var(--rui-carousel-track-transition)",
  )
  ffi_carousel_layout_set_active(2)
  ffi_carousel_sync_layout("layout-carousel", _ => ())
  assert_eq(ffi_carousel_layout_offset(), "-210px")
  assert_eq(ffi_carousel_layout_transition(), "none")
  ffi_restore_carousel_layout_fixture()
}
