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
priv struct ScrollAreaDimensions {
  vertical : Bool
  viewport_size : Double
  content_size : Double
  max : Double
}

///|
#cfg(target="js")
priv struct ScrollAreaDrag {
  pointer_id : Int
  grab : Double
}

///|
#cfg(target="js")
priv struct ScrollAreaPointerBinding {
  root : @dom.Element
  viewport : @dom.Element
  track : @dom.Element
  thumb : @dom.Element
  mut vertical : Bool
  mut notify : (Double, Double, Double) -> Unit
  mut drag : ScrollAreaDrag?
}

///|
#cfg(target="js")
let scroll_area_pointer_bindings : Array[ScrollAreaPointerBinding] = []

///|
#cfg(target="js")
fn scroll_area_prune_pointer_bindings() -> Unit {
  let mut index = 0
  while index < scroll_area_pointer_bindings.length() {
    if scroll_area_pointer_bindings[index].root.get_is_connected() {
      index += 1
    } else {
      ignore(scroll_area_pointer_bindings.remove(index))
    }
  }
}

///|
#cfg(target="js")
fn scroll_area_pointer_binding(
  root : @dom.Element,
) -> ScrollAreaPointerBinding? {
  for binding in scroll_area_pointer_bindings {
    if binding.root.is_same_node(root.as_node()) {
      return Some(binding)
    }
  }
  None
}

///|
#cfg(target="js")
fn scroll_area_dimensions(
  binding : ScrollAreaPointerBinding,
) -> ScrollAreaDimensions {
  let viewport_size = if binding.vertical {
    binding.viewport.get_client_height()
  } else {
    binding.viewport.get_client_width()
  }
  let content_size = if binding.vertical {
    binding.viewport.get_scroll_height()
  } else {
    binding.viewport.get_scroll_width()
  }
  {
    vertical: binding.vertical,
    viewport_size,
    content_size,
    max: (content_size - viewport_size).max(0.0),
  }
}

///|
#cfg(target="js")
fn scroll_area_physical_offset(
  binding : ScrollAreaPointerBinding,
  dimensions : ScrollAreaDimensions,
) -> Double {
  if dimensions.vertical {
    binding.viewport.get_scroll_top().clamp(min=0.0, max=dimensions.max)
  } else {
    let raw = binding.viewport.get_scroll_left()
    (if ui_element_is_rtl(binding.viewport) {
      dimensions.max + raw
    } else {
      raw
    }).clamp(min=0.0, max=dimensions.max)
  }
}

///|
#cfg(target="js")
fn scroll_area_notify_position(binding : ScrollAreaPointerBinding) -> Unit {
  let dimensions = scroll_area_dimensions(binding)
  (binding.notify)(
    scroll_area_physical_offset(binding, dimensions),
    dimensions.viewport_size,
    dimensions.content_size,
  )
}

///|
#cfg(target="js")
fn scroll_area_set_physical_offset(
  binding : ScrollAreaPointerBinding,
  value : Double,
  dimensions : ScrollAreaDimensions,
) -> Unit {
  let next = value.clamp(min=0.0, max=dimensions.max)
  if dimensions.vertical {
    binding.viewport.set_scroll_top(next)
  } else if ui_element_is_rtl(binding.viewport) {
    binding.viewport.set_scroll_left(next - dimensions.max)
  } else {
    binding.viewport.set_scroll_left(next)
  }
  (binding.notify)(next, dimensions.viewport_size, dimensions.content_size)
}

///|
#cfg(target="js")
fn scroll_area_move_pointer(
  binding : ScrollAreaPointerBinding,
  pointer : @dom.PointerEvent,
) -> Unit {
  guard binding.drag is Some(drag) else { return }
  guard drag.pointer_id == pointer.get_pointer_id() else { return }
  let dimensions = scroll_area_dimensions(binding)
  let rect = binding.track.get_bounding_client_rect()
  let track_size = if dimensions.vertical {
    rect.get_height()
  } else {
    rect.get_width()
  }
  let thumb_size = if dimensions.content_size > 0.0 {
    (track_size * dimensions.viewport_size / dimensions.content_size).max(1.0)
  } else {
    track_size
  }
  let travel = (track_size - thumb_size).max(0.0)
  let pointer_position = if dimensions.vertical {
    pointer.get_client_y() - rect.get_top()
  } else {
    pointer.get_client_x() - rect.get_left()
  }
  let start = (pointer_position - drag.grab).clamp(min=0.0, max=travel)
  scroll_area_set_physical_offset(
    binding,
    if travel > 0.0 {
      start / travel * dimensions.max
    } else {
      0.0
    },
    dimensions,
  )
  pointer.prevent_default()
}

///|
#cfg(target="js")
fn scroll_area_finish_pointer(
  binding : ScrollAreaPointerBinding,
  pointer : @dom.PointerEvent,
) -> Unit {
  guard binding.drag is Some(drag) else { return }
  guard drag.pointer_id == pointer.get_pointer_id() else { return }
  binding.drag = None
  if binding.track.has_pointer_capture(drag.pointer_id) {
    binding.track.release_pointer_capture(drag.pointer_id)
  }
}

///|
#cfg(target="js")
fn scroll_area_bind_pointer_listeners(
  binding : ScrollAreaPointerBinding,
) -> Unit {
  binding.track.add_event_listener("pointerdown", event => {
    guard event.to_pointer_event() is Some(pointer) else { return }
    if pointer.get_button() != 0 || binding.drag is Some(_) {
      return
    }
    let dimensions = scroll_area_dimensions(binding)
    if dimensions.max <= 0.0 {
      return
    }
    let rect = binding.track.get_bounding_client_rect()
    let track_size = if dimensions.vertical {
      rect.get_height()
    } else {
      rect.get_width()
    }
    let thumb_size = (track_size *
    dimensions.viewport_size /
    dimensions.content_size).max(1.0)
    let travel = (track_size - thumb_size).max(0.0)
    let current_start = scroll_area_physical_offset(binding, dimensions) /
      dimensions.max *
      travel
    let pointer_position = if dimensions.vertical {
      pointer.get_client_y() - rect.get_top()
    } else {
      pointer.get_client_x() - rect.get_left()
    }
    let on_thumb = pointer.target().to_element() is Some(target) &&
      target.is_same_node(binding.thumb.as_node())
    binding.drag = Some({
      pointer_id: pointer.get_pointer_id(),
      grab: if on_thumb {
        pointer_position - current_start
      } else {
        thumb_size / 2.0
      },
    })
    binding.track.set_pointer_capture(pointer.get_pointer_id())
    scroll_area_move_pointer(binding, pointer)
  })
  binding.track.add_event_listener("pointermove", event => {
    if event.to_pointer_event() is Some(pointer) {
      scroll_area_move_pointer(binding, pointer)
    }
  })
  let finish : @dom.Listener = event => {
    if event.to_pointer_event() is Some(pointer) {
      scroll_area_finish_pointer(binding, pointer)
    }
  }
  binding.track.add_event_listener("pointerup", finish)
  binding.track.add_event_listener("pointercancel", finish)
  binding.track.add_event_listener("lostpointercapture", finish)
  binding.viewport.add_event_listener_with_options(
    "scroll",
    _ => scroll_area_notify_position(binding),
    passive=true,
  )
}

///|
#cfg(target="js")
fn bind_scroll_area_pointer(
  id : String,
  vertical : Bool,
  notify : (Double, Double, Double) -> Unit,
) -> Unit {
  guard ui_element_by_id(id) is Some(root) else { return }
  scroll_area_prune_pointer_bindings()
  guard root.query_selector("[data-slot=\"scroll-area-viewport\"]")
    is Some(viewport) else {
    return
  }
  guard root.query_selector("[data-slot=\"scroll-area-scrollbar\"]")
    is Some(track) else {
    return
  }
  guard root.query_selector("[data-slot=\"scroll-area-thumb\"]") is Some(thumb) else {
    return
  }
  if scroll_area_pointer_binding(root) is Some(binding) {
    binding.vertical = vertical
    binding.notify = notify
    scroll_area_notify_position(binding)
    return
  }
  let binding : ScrollAreaPointerBinding = {
    root,
    viewport,
    track,
    thumb,
    vertical,
    notify,
    drag: None,
  }
  scroll_area_pointer_bindings.push(binding)
  scroll_area_bind_pointer_listeners(binding)
  scroll_area_notify_position(binding)
}

///|
fn scroll_area_initial_metrics() -> ScrollAreaMetrics {
  { offset: 0.0, viewport: 0.0, content: 0.0, }
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
  @cmd.custom_cmd(kind=AfterRender, scheduler => {
    ui_after_mount(
      viewport_id,
      () => {
        bind_scroll_area_pointer(root_id, orientation is Vertical, (
          offset,
          viewport,
          content,
        ) => {
          scheduler.add(
            emit(ScrollAreaMeasured({ offset, viewport, content, })),
          )
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
