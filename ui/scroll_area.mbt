///|
pub fn[C : @html.IsChildren] scroll_area(
  orientation? : SeparatorOrientation = Vertical,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let value = separator_orientation_value(orientation)
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "scroll-area")
      .data_set("orientation", value)
      .tabindex(0),
    style=ui_styles(
      [
        UiBoxSizing,
        "position:relative;width:100%;height:100%;border-radius:inherit;outline-offset:2px;overscroll-behavior:contain;scrollbar-color:var(--rui-border,oklch(0.922 0 0)) transparent;scrollbar-width:thin",
        if orientation is Vertical {
          "overflow-y:auto;overflow-x:hidden"
        } else {
          "overflow-x:auto;overflow-y:hidden"
        },
      ],
      style,
    ),
    children,
  )
}

///|
/// Optional visual scrollbar track for layouts that want shadcn's composition.
/// Native scrolling remains on `scroll_area`; this element is decorative.
pub fn scroll_bar(
  orientation? : SeparatorOrientation = Vertical,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let value = separator_orientation_value(orientation)
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "scroll-area-scrollbar")
      .data_set("orientation", value)
      .aria_hidden("true"),
    style=ui_styles(
      [
        "display:flex;pointer-events:none;user-select:none;padding:1px",
        if orientation is Vertical {
          "position:absolute;top:0;inset-inline-end:0;width:0.625rem;height:100%"
        } else {
          "position:absolute;inset-inline-start:0;bottom:0;width:100%;height:0.625rem;flex-direction:column"
        },
      ],
      style,
    ),
    @html.div(
      attrs=@html.Attrs::build().data_set("slot", "scroll-area-thumb"),
      style=[
        "position:relative;flex:1;border-radius:9999px;background:var(--rui-border,oklch(0.922 0 0));opacity:0.7",
      ],
      "",
    ),
  )
}

///|
priv struct ScrollAreaMetrics {
  offset : Double
  viewport : Double
  content : Double
}

///|
#cfg(target="js")
impl Eq for ScrollAreaMetrics with fn equal(a, b) {
  a.offset == b.offset && a.viewport == b.viewport && a.content == b.content
}

///|
#cfg(target="js")
priv enum ScrollAreaMsg {
  ScrollAreaMeasured(ScrollAreaMetrics)
}

///|
const ScrollAreaManagedRootStyle : String = "position:relative;width:100%;height:100%;min-width:0;min-height:0;overflow:hidden;border-radius:inherit"

///|
const ScrollAreaManagedViewportStyle : String = "width:100%;height:100%;min-width:0;min-height:0;overscroll-behavior:contain;scrollbar-color:transparent transparent;scrollbar-width:none;-ms-overflow-style:none;outline-offset:2px"

///|
const ScrollAreaManagedTrackStyle : String = "position:absolute;z-index:1;display:block;user-select:none;transition:opacity 150ms ease"

///|
const ScrollAreaManagedThumbStyle : String = "position:absolute;display:block;border-radius:9999px;background:var(--rui-border,oklch(0.922 0 0));opacity:0.8;pointer-events:auto;touch-action:none"

///|
#cfg(target="js")
extern "js" fn ffi_bind_scroll_area_pointer(
  id : String,
  vertical : Bool,
  notify : (Double, Double, Double) -> Unit,
) -> Unit =
  #| (id, vertical, notify) => {
  #|   const root = document.getElementById(id)
  #|   if (!root) return
  #|   const viewport = root.querySelector('[data-slot="scroll-area-viewport"]')
  #|   const track = root.querySelector('[data-slot="scroll-area-scrollbar"]')
  #|   const thumb = root.querySelector('[data-slot="scroll-area-thumb"]')
  #|   if (!viewport || !track || !thumb) return
  #|   root.__ruiScrollAreaNotify = notify
  #|   root.__ruiScrollAreaVertical = vertical
  #|   if (root.__ruiScrollAreaPointerBound) {
  #|     root.__ruiScrollAreaMeasure?.()
  #|     return
  #|   }
  #|   root.__ruiScrollAreaPointerBound = true
  #|   root.__ruiScrollAreaDrag = null
  #|   const dimensions = () => {
  #|     const isVertical = root.__ruiScrollAreaVertical
  #|     const viewportSize = isVertical ? viewport.clientHeight : viewport.clientWidth
  #|     const contentSize = isVertical ? viewport.scrollHeight : viewport.scrollWidth
  #|     return {
  #|       isVertical,
  #|       viewportSize,
  #|       contentSize,
  #|       max: Math.max(0, contentSize - viewportSize),
  #|     }
  #|   }
  #|   const physicalOffset = values => {
  #|     if (values.isVertical) {
  #|       return Math.max(0, Math.min(values.max, viewport.scrollTop))
  #|     }
  #|     const raw = viewport.scrollLeft
  #|     if (getComputedStyle(viewport).direction === 'rtl') {
  #|       return Math.max(0, Math.min(values.max, values.max + raw))
  #|     }
  #|     return Math.max(0, Math.min(values.max, raw))
  #|   }
  #|   const notifyPosition = () => {
  #|     const values = dimensions()
  #|     root.__ruiScrollAreaNotify?.(
  #|       physicalOffset(values),
  #|       values.viewportSize,
  #|       values.contentSize,
  #|     )
  #|   }
  #|   root.__ruiScrollAreaMeasure = notifyPosition
  #|   const setPhysicalOffset = (value, values) => {
  #|     const next = Math.max(0, Math.min(values.max, value))
  #|     if (values.isVertical) viewport.scrollTop = next
  #|     else if (getComputedStyle(viewport).direction === 'rtl') {
  #|       viewport.scrollLeft = next - values.max
  #|     } else viewport.scrollLeft = next
  #|     root.__ruiScrollAreaNotify?.(next, values.viewportSize, values.contentSize)
  #|   }
  #|   const move = event => {
  #|     const drag = root.__ruiScrollAreaDrag
  #|     if (!drag || drag.pointerId !== event.pointerId) return
  #|     const values = dimensions()
  #|     const rect = track.getBoundingClientRect()
  #|     const trackSize = values.isVertical ? rect.height : rect.width
  #|     const thumbSize = values.contentSize > 0
  #|       ? Math.max(1, trackSize * values.viewportSize / values.contentSize)
  #|       : trackSize
  #|     const travel = Math.max(0, trackSize - thumbSize)
  #|     const pointer = values.isVertical
  #|       ? event.clientY - rect.top
  #|       : event.clientX - rect.left
  #|     const start = Math.max(0, Math.min(travel, pointer - drag.grab))
  #|     setPhysicalOffset(travel > 0 ? start / travel * values.max : 0, values)
  #|     event.preventDefault()
  #|   }
  #|   track.addEventListener('pointerdown', event => {
  #|     if (event.button !== 0 || root.__ruiScrollAreaDrag) return
  #|     const values = dimensions()
  #|     if (values.max <= 0) return
  #|     const rect = track.getBoundingClientRect()
  #|     const trackSize = values.isVertical ? rect.height : rect.width
  #|     const thumbSize = Math.max(1, trackSize * values.viewportSize / values.contentSize)
  #|     const travel = Math.max(0, trackSize - thumbSize)
  #|     const currentStart = physicalOffset(values) / values.max * travel
  #|     const pointer = values.isVertical
  #|       ? event.clientY - rect.top
  #|       : event.clientX - rect.left
  #|     root.__ruiScrollAreaDrag = {
  #|       pointerId: event.pointerId,
  #|       grab: event.target === thumb ? pointer - currentStart : thumbSize / 2,
  #|     }
  #|     try { track.setPointerCapture?.(event.pointerId) } catch (_) { }
  #|     move(event)
  #|   })
  #|   track.addEventListener('pointermove', move)
  #|   const finish = event => {
  #|     const drag = root.__ruiScrollAreaDrag
  #|     if (!drag || drag.pointerId !== event.pointerId) return
  #|     root.__ruiScrollAreaDrag = null
  #|     try { track.releasePointerCapture?.(event.pointerId) } catch (_) { }
  #|   }
  #|   track.addEventListener('pointerup', finish)
  #|   track.addEventListener('pointercancel', finish)
  #|   track.addEventListener('lostpointercapture', finish)
  #|   viewport.addEventListener('scroll', notifyPosition, { passive: true })
  #|   notifyPosition()
  #| }

///|
fn scroll_area_initial_metrics() -> ScrollAreaMetrics {
  { offset: 0.0, viewport: 0.0, content: 0.0 }
}

///|
fn scroll_area_max_offset(metrics : ScrollAreaMetrics) -> Double {
  if metrics.content > metrics.viewport {
    metrics.content - metrics.viewport
  } else {
    0.0
  }
}

///|
fn scroll_area_is_scrollable(metrics : ScrollAreaMetrics) -> Bool {
  scroll_area_max_offset(metrics) > 1.0
}

///|
fn scroll_area_thumb_size_hundredths(metrics : ScrollAreaMetrics) -> Int {
  if !scroll_area_is_scrollable(metrics) || metrics.content <= 0.0 {
    10000
  } else {
    (metrics.viewport / metrics.content * 10000.0)
    .to_int()
    .clamp(min=100, max=10000)
  }
}

///|
fn scroll_area_thumb_offset_hundredths(metrics : ScrollAreaMetrics) -> Int {
  let max_offset = scroll_area_max_offset(metrics)
  if max_offset <= 0.0 {
    0
  } else {
    let available = 10000 - scroll_area_thumb_size_hundredths(metrics)
    (metrics.offset.clamp(min=0.0, max=max_offset) /
    max_offset *
    available.to_double())
    .to_int()
    .clamp(min=0, max=available)
  }
}

///|
fn scroll_area_percent(value : Int) -> String {
  let clamped = value.clamp(min=0, max=10000)
  let whole = clamped / 100
  let fraction = clamped % 100
  if fraction == 0 {
    "\{whole}%"
  } else if fraction < 10 {
    "\{whole}.0\{fraction}%"
  } else {
    "\{whole}.\{fraction}%"
  }
}

///|
#cfg(target="js")
fn scroll_area_initialize_cmd(
  root_id : String,
  viewport_id : String,
  orientation : SeparatorOrientation,
  emit : @cmd.Emit[ScrollAreaMsg],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, scheduler => {
    ui_after_mount(
      viewport_id,
      () => {
        ffi_bind_scroll_area_pointer(root_id, orientation is Vertical, (
          offset,
          viewport,
          content,
        ) => {
          scheduler.add(emit(ScrollAreaMeasured({ offset, viewport, content })))
        })
      },
      purpose="scroll-area-initialize",
    )
  })
}

///|
#cfg(target="js")
fn scroll_area_viewport_attrs(
  orientation : SeparatorOrientation,
  emit : @cmd.Emit[ScrollAreaMsg],
) -> @html.Attrs {
  ignore(orientation)
  ignore(emit)
  @html.Attrs::build()
}

///|
#cfg(target="js")
fn scroll_area_track_attrs(
  viewport_id : String,
  orientation : SeparatorOrientation,
  emit : @cmd.Emit[ScrollAreaMsg],
) -> @html.Attrs {
  ignore(viewport_id)
  ignore(orientation)
  ignore(emit)
  @html.Attrs::build()
}

///|
fn[C : @html.IsChildren] render_scroll_area_with_scrollbar(
  metrics : ScrollAreaMetrics,
  orientation : SeparatorOrientation,
  id : String,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  viewport_attrs : @html.Attrs,
  track_attrs : @html.Attrs,
  children : C,
) -> @html.Html {
  let value = separator_orientation_value(orientation)
  let scrollable = scroll_area_is_scrollable(metrics)
  let state = if scrollable { "scrollable" } else { "idle" }
  let size = scroll_area_percent(scroll_area_thumb_size_hundredths(metrics))
  let offset = scroll_area_percent(scroll_area_thumb_offset_hundredths(metrics))
  let viewport_id = "\{id}-viewport"
  @html.div(
    id~,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "scroll-area")
      .data_set("managed", "")
      .data_set("orientation", value)
      .data_set("state", state)
      .data_set("scrollable", ui_bool(scrollable)),
    style=ui_styles([UiBoxSizing, ScrollAreaManagedRootStyle], style),
    [
      @html.div(
        id=viewport_id,
        attrs=viewport_attrs
          .data_set("slot", "scroll-area-viewport")
          .data_set("orientation", value)
          .data_set("state", state)
          .data_set("scroll-offset", "\{metrics.offset}")
          .data_set("viewport-size", "\{metrics.viewport}")
          .data_set("content-size", "\{metrics.content}")
          .tabindex(0),
        style=[
          UiBoxSizing,
          ScrollAreaManagedViewportStyle,
          if orientation is Vertical {
            "overflow-y:auto;overflow-x:hidden"
          } else {
            "overflow-x:auto;overflow-y:hidden"
          },
        ],
        children,
      ),
      @html.div(
        id="\{id}-scrollbar",
        attrs=track_attrs
          .data_set("slot", "scroll-area-scrollbar")
          .data_set("orientation", value)
          .data_set("state", state)
          .data_set("thumb-size", size)
          .data_set("thumb-offset", offset)
          .aria_hidden("true"),
        style=[
          UiBoxSizing,
          ScrollAreaManagedTrackStyle,
          if orientation is Vertical {
            "top:0;inset-inline-end:0;width:var(--rui-scrollbar-size,0.625rem);height:100%"
          } else {
            "inset-inline-start:0;bottom:0;width:100%;height:var(--rui-scrollbar-size,0.625rem)"
          },
          if scrollable {
            "opacity:1;pointer-events:auto;cursor:pointer"
          } else {
            "opacity:0;pointer-events:none"
          },
        ],
        @html.div(
          id="\{id}-thumb",
          attrs=@html.Attrs::build()
            .data_set("slot", "scroll-area-thumb")
            .data_set("orientation", value)
            .data_set("state", state),
          style=[
            UiBoxSizing,
            ScrollAreaManagedThumbStyle,
            if orientation is Vertical {
              "top:\{offset};inset-inline-start:1px;width:calc(100% - 2px);height:\{size}"
            } else {
              "top:1px;left:\{offset};width:\{size};height:calc(100% - 2px)"
            },
          ],
          "",
        ),
      ),
    ],
  )
}

///|
/// A black-box incremental Scroll Area with a proportional custom scrollbar.
///
/// The component measures its viewport after the first render, owns the latest
/// offset/viewport/content metrics in Rabbita state, and refreshes them on each
/// native scroll event. Wheel, touch, and keyboard scrolling remain native.
/// Pointer presses on the track jump the thumb to that position; pressing the
/// thumb preserves its grab offset and drags with pointer capture until release
/// or cancellation. Horizontal RTL scrolling is normalized before it enters
/// component state, so the thumb geometry stays logical across browser modes.
#cfg(target="js")
pub fn[C : @html.IsChildren] scroll_area_with_scrollbar(
  orientation? : SeparatorOrientation = Vertical,
  id~ : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @rabbita.Val[@html.Html] {
  let viewport_id = "\{id}-viewport"
  let (metrics, emit) = @rabbita.create_state_with_init(
    init=emit => {
      (
        scroll_area_initial_metrics(),
        scroll_area_initialize_cmd(id, viewport_id, orientation, emit),
      )
    },
    update=(_, message, _) => {
      (
        match message {
          ScrollAreaMeasured(metrics) => metrics
        },
        @cmd.none,
      )
    },
  )
  metrics.view(metrics => {
    render_scroll_area_with_scrollbar(
      metrics,
      orientation,
      id,
      class,
      title,
      attrs,
      style,
      scroll_area_viewport_attrs(orientation, emit),
      scroll_area_track_attrs(viewport_id, orientation, emit),
      children,
    )
  })
}

///|
#cfg(not(target="js"))
pub fn[C : @html.IsChildren] scroll_area_with_scrollbar(
  orientation? : SeparatorOrientation = Vertical,
  id~ : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @rabbita.Val[@html.Html] {
  @rabbita.Val::constant(
    render_scroll_area_with_scrollbar(
      scroll_area_initial_metrics(),
      orientation,
      id,
      class,
      title,
      attrs,
      style,
      @html.Attrs::build(),
      @html.Attrs::build(),
      children,
    ),
  )
}
