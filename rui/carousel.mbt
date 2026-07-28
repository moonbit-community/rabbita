///|
pub(all) enum CarouselOrientation {
  CarouselHorizontal
  CarouselVertical
} derive(Debug, Eq)

///|
/// Opaque state passed from `carousel` to its compound content, item, and
/// previous/next controls.
struct CarouselScope {
  index : Int
  count : Int
  max_index : Int
  loop_ : Bool
  orientation : CarouselOrientation
  emit : @cmd.Emit[Int]
}

///|
#cfg(target="js")
priv struct CarouselModel {
  index : Int
  max_index : Int
} derive(Eq)

///|
#cfg(target="js")
priv enum CarouselMsg {
  CarouselSetIndex(Int)
  CarouselMeasured(Int)
}

///|
const CarouselRootStyle : String = "position:relative;display:block;width:100%;min-width:0;color:var(--rui-foreground,oklch(0.145 0 0))"

///|
const CarouselScopeStyle : String = "display:contents"

///|
const CarouselViewportStyle : String = "position:relative;width:100%;min-width:0;overflow:hidden;touch-action:var(--rui-carousel-touch-action,pan-y pinch-zoom);cursor:var(--rui-carousel-cursor,grab);user-select:var(--rui-carousel-user-select,auto);-webkit-user-select:var(--rui-carousel-user-select,auto)"

///|
const CarouselViewportVerticalStyle : String = "height:var(--rui-carousel-height,12rem);--rui-carousel-touch-action:pan-x pinch-zoom"

///|
const CarouselTrackStyle : String = "display:flex;min-width:0;will-change:transform;transition:var(--rui-carousel-track-transition,transform 300ms cubic-bezier(0.22,1,0.36,1))"

///|
const CarouselTrackHorizontalStyle : String = "flex-direction:row;margin-inline-start:-1rem"

///|
const CarouselTrackVerticalStyle : String = "height:100%;flex-direction:column;margin-top:-1rem"

///|
const CarouselItemStyle : String = "position:relative;min-width:0;flex-grow:0;flex-shrink:0;flex-basis:100%"

///|
const CarouselItemHorizontalStyle : String = "padding-inline-start:1rem"

///|
const CarouselItemVerticalStyle : String = "min-height:100%;padding-top:1rem"

///|
const CarouselControlStyle : String = "position:absolute;z-index:2;border-radius:9999px"

///|
const CarouselPreviousHorizontalStyle : String = "top:50%;inset-inline-start:var(--rui-carousel-control-inline-offset,-3rem);transform:translateY(-50%)"

///|
const CarouselNextHorizontalStyle : String = "top:50%;inset-inline-end:var(--rui-carousel-control-inline-offset,-3rem);transform:translateY(-50%)"

///|
const CarouselPreviousVerticalStyle : String = "top:var(--rui-carousel-control-block-offset,-3rem);left:50%;transform:translateX(-50%)"

///|
const CarouselNextVerticalStyle : String = "bottom:var(--rui-carousel-control-block-offset,-3rem);left:50%;transform:translateX(-50%)"

///|
const CarouselChevronBoxStyle : String = "display:inline-flex;width:1rem;height:1rem;flex-shrink:0;align-items:center;justify-content:center"

///|
const CarouselChevronStyle : String = "display:block;width:0.5rem;height:0.5rem;border-right:1.5px solid currentColor;border-bottom:1.5px solid currentColor;transform-origin:center"

///|
const CarouselChevronLeftStyle : String = "transform:rotate(135deg)"

///|
const CarouselChevronRightStyle : String = "transform:rotate(-45deg)"

///|
const CarouselChevronUpStyle : String = "transform:rotate(225deg)"

///|
const CarouselChevronDownStyle : String = "transform:rotate(45deg)"

///|
const CarouselScreenReaderStyle : String = "position:absolute;width:1px;height:1px;margin:-1px;padding:0;border:0;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap"

///|
fn carousel_orientation_value(orientation : CarouselOrientation) -> String {
  match orientation {
    CarouselHorizontal => "horizontal"
    CarouselVertical => "vertical"
  }
}

///|
fn carousel_count(count : Int) -> Int {
  if count < 0 {
    0
  } else {
    count
  }
}

///|
fn carousel_index(index : Int, count : Int) -> Int {
  if count <= 0 || index < 0 {
    0
  } else if index >= count {
    count - 1
  } else {
    index
  }
}

///|
fn carousel_previous_index(scope : CarouselScope) -> Int {
  if scope.max_index <= 0 {
    scope.index
  } else if scope.index > 0 {
    scope.index - 1
  } else if scope.loop_ {
    scope.max_index
  } else {
    scope.index
  }
}

///|
fn carousel_next_index(scope : CarouselScope) -> Int {
  if scope.max_index <= 0 {
    scope.index
  } else if scope.index < scope.max_index {
    scope.index + 1
  } else if scope.loop_ {
    0
  } else {
    scope.index
  }
}

///|
/// Return the active zero-based index from a compound carousel scope.
pub fn carousel_active_index(scope : CarouselScope) -> Int {
  scope.index
}

///|
/// Return the normalized number of slides from a compound carousel scope.
pub fn carousel_slide_count(scope : CarouselScope) -> Int {
  scope.count
}

///|
pub fn carousel_can_previous(scope : CarouselScope) -> Bool {
  scope.max_index > 0 && (scope.loop_ || scope.index > 0)
}

///|
pub fn carousel_can_next(scope : CarouselScope) -> Bool {
  scope.max_index > 0 && (scope.loop_ || scope.index < scope.max_index)
}

///|
fn carousel_track_transform(scope : CarouselScope) -> String {
  let offset = scope.index * 100
  match scope.orientation {
    CarouselHorizontal =>
      "--rui-carousel-ltr-offset:-\{offset}%;--rui-carousel-rtl-offset:\{offset}%;transform:translate3d(var(--rui-carousel-offset,var(--rui-carousel-ltr-offset)),0,0)"
    CarouselVertical =>
      "--rui-carousel-block-offset:-\{offset}%;transform:translate3d(0,var(--rui-carousel-offset,var(--rui-carousel-block-offset)),0)"
  }
}

///|
fn carousel_track_orientation_style(
  orientation : CarouselOrientation,
) -> String {
  match orientation {
    CarouselHorizontal => CarouselTrackHorizontalStyle
    CarouselVertical => CarouselTrackVerticalStyle
  }
}

///|
fn carousel_viewport_orientation_style(
  orientation : CarouselOrientation,
) -> String {
  match orientation {
    CarouselHorizontal => ""
    CarouselVertical => CarouselViewportVerticalStyle
  }
}

///|
fn carousel_item_orientation_style(orientation : CarouselOrientation) -> String {
  match orientation {
    CarouselHorizontal => CarouselItemHorizontalStyle
    CarouselVertical => CarouselItemVerticalStyle
  }
}

///|
fn carousel_control_position_style(
  orientation : CarouselOrientation,
  previous : Bool,
) -> String {
  match (orientation, previous) {
    (CarouselHorizontal, true) => CarouselPreviousHorizontalStyle
    (CarouselHorizontal, false) => CarouselNextHorizontalStyle
    (CarouselVertical, true) => CarouselPreviousVerticalStyle
    (CarouselVertical, false) => CarouselNextVerticalStyle
  }
}

///|
fn carousel_control_chevron_style(
  orientation : CarouselOrientation,
  previous : Bool,
) -> String {
  match (orientation, previous) {
    (CarouselHorizontal, true) => CarouselChevronLeftStyle
    (CarouselHorizontal, false) => CarouselChevronRightStyle
    (CarouselVertical, true) => CarouselChevronUpStyle
    (CarouselVertical, false) => CarouselChevronDownStyle
  }
}

///|
#cfg(target="js")
fn carousel_key_step(event : @dom.KeyboardEvent, orientation : String) -> Int {
  if event.alt_key() ||
    event.ctrl_key() ||
    event.meta_key() ||
    event.shift_key() {
    return 0
  }
  if event.target().to_element() is Some(target) &&
    target.closest("input,textarea,select,[contenteditable=\"true\"]")
    is Some(_) {
    return 0
  }
  if orientation == "vertical" {
    if event.key() == "ArrowUp" {
      -1
    } else if event.key() == "ArrowDown" {
      1
    } else {
      0
    }
  } else {
    let rtl = if event.current_target().to_option() is Some(current_target) &&
      current_target.to_element() is Some(element) {
      ui_element_is_rtl(element)
    } else {
      false
    }
    if event.key() == "ArrowLeft" {
      if rtl {
        1
      } else {
        -1
      }
    } else if event.key() == "ArrowRight" {
      if rtl {
        -1
      } else {
        1
      }
    } else {
      0
    }
  }
}

///|
#cfg(target="js")
let carousel_id_counter : Ref[Int] = Ref(0)

///|
#cfg(target="js")
fn carousel_next_id() -> String {
  carousel_id_counter.val += 1
  "rui-carousel-\{carousel_id_counter.val}"
}

///|
#cfg(target="js")
priv struct CarouselLayoutState {
  root : @dom.Element
  mut viewport : @dom.Element
  mut track : @dom.Element
  mut items : Array[@dom.Element]
  mut notify : (Int) -> Unit
  mut previous_index : Int?
  mut offset : Double?
  mut reported_max : Int?
  mut observer : @dom.ResizeObserver?
  mut transition_generation : Int
}

///|
#cfg(target="js")
let carousel_layout_states : Array[CarouselLayoutState] = []

///|
#cfg(target="js")
fn carousel_element_owned_by(
  root : @dom.Element,
  element : @dom.Element,
) -> Bool {
  element.closest("[data-slot=\"carousel\"]") is Some(owner) &&
  owner.is_same_node(root.as_node())
}

///|
#cfg(target="js")
fn carousel_owned_elements(
  root : @dom.Element,
  selector : String,
) -> Array[@dom.Element] {
  root
  .query_selector_all(selector)
  .filter(element => carousel_element_owned_by(root, element))
}

///|
#cfg(target="js")
fn carousel_owned_element(
  root : @dom.Element,
  selector : String,
) -> @dom.Element? {
  carousel_owned_elements(root, selector).get(0)
}

///|
#cfg(target="js")
fn carousel_layout_state(root : @dom.Element) -> CarouselLayoutState? {
  for state in carousel_layout_states {
    if state.root.is_same_node(root.as_node()) {
      return Some(state)
    }
  }
  None
}

///|
#cfg(target="js")
fn carousel_remove_layout_state(root : @dom.Element) -> Unit {
  for index, state in carousel_layout_states {
    if state.root.is_same_node(root.as_node()) {
      if state.observer is Some(observer) {
        observer.disconnect()
      }
      ignore(carousel_layout_states.remove(index))
      return
    }
  }
}

///|
#cfg(target="js")
fn carousel_item_dimension(item : @dom.Element, vertical : Bool) -> Double {
  let offset = if item.to_html_element() is Some(html) {
    if vertical {
      html.get_offset_height()
    } else {
      html.get_offset_width()
    }
  } else {
    0.0
  }
  if offset > 0.0 {
    offset
  } else {
    let rect = item.get_bounding_client_rect()
    (if vertical { rect.get_height() } else { rect.get_width() }).max(0.0)
  }
}

///|
#cfg(target="js")
fn carousel_item_offset(item : @dom.Element, vertical : Bool) -> Double {
  if item.to_html_element() is Some(html) {
    if vertical {
      html.get_offset_top()
    } else {
      html.get_offset_left()
    }
  } else {
    0.0
  }
}

///|
#cfg(target="js")
fn carousel_restore_transition(
  state : CarouselLayoutState,
  generation : Int,
  transition : String,
) -> Unit {
  if state.transition_generation != generation ||
    state.track.to_html_element() is None {
    return
  }
  guard state.track.to_html_element() is Some(track) else { return }
  let style = track.get_style()
  if transition == "" {
    ignore(style.remove_property("transition"))
  } else {
    style.set_property("transition", transition)
  }
}

///|
#cfg(target="js")
fn carousel_set_control_state(control : @dom.Element, enabled : Bool) -> Unit {
  control.set_attribute("aria-disabled", ui_bool(!enabled))
  control.set_attribute(
    "data-state",
    if enabled {
      "enabled"
    } else {
      "disabled"
    },
  )
  if enabled {
    control.remove_attribute("disabled")
    control.remove_attribute("data-disabled")
  } else {
    control.set_attribute("disabled", "")
    control.set_attribute("data-disabled", "")
  }
}

///|
#cfg(target="js")
fn carousel_sync_layout_state(
  state : CarouselLayoutState,
  suppress_initial : Bool,
) -> Int {
  if state.items.length() == 0 || state.track.to_html_element() is None {
    return 0
  }
  guard state.track.to_html_element() is Some(track_html) else { return 0 }
  let vertical = state.root.get_attribute("data-orientation").unwrap_or("") ==
    "vertical"
  let rtl = !vertical && ui_element_is_rtl(state.viewport)
  let first = state.items[0]
  let first_offset = carousel_item_offset(first, vertical)
  let first_right = carousel_item_offset(first, false) +
    carousel_item_dimension(first, false)
  let starts : Array[Double] = []
  let sizes : Array[Double] = []
  for item in state.items {
    let start = if vertical {
      (carousel_item_offset(item, true) - first_offset).max(0.0)
    } else if rtl {
      (first_right -
      (carousel_item_offset(item, false) + carousel_item_dimension(item, false))).max(
        0.0,
      )
    } else {
      (carousel_item_offset(item, false) - carousel_item_offset(first, false)).max(
        0.0,
      )
    }
    starts.push(start)
    sizes.push(carousel_item_dimension(item, vertical))
  }
  let mut content_span = 0.0
  for index, start in starts {
    content_span = content_span.max(start + sizes[index])
  }
  let viewport_size = (if vertical {
    state.viewport.get_client_height()
  } else {
    state.viewport.get_client_width()
  }).max(0.0)
  let max_travel = (content_span - viewport_size).max(0.0)
  let mut max_index = 0
  if max_travel > 0.5 {
    max_index = state.items.length() - 1
    for index, start in starts {
      if start >= max_travel - 0.5 {
        max_index = index
        break
      }
    }
  }
  let requested = ui_parse_int_or(
    state.root.get_attribute("data-active-index").unwrap_or(""),
    0,
  ).clamp(min=0, max=state.items.length() - 1)
  let index = requested.min(max_index)
  let travel = starts[index].clamp(min=0.0, max=max_travel)
  let offset = if travel == 0.0 { 0.0 } else if rtl { travel } else { -travel }
  let loop_ = state.root.get_attribute("data-loop").unwrap_or("") == "true"
  let wrapped = if state.previous_index is Some(previous) {
    loop_ &&
    max_index > 0 &&
    (
      (previous == 0 && index == max_index) ||
      (previous == max_index && index == 0)
    )
  } else {
    false
  }
  if (suppress_initial && state.previous_index is None) || wrapped {
    let style = track_html.get_style()
    let transition = style.get_property_value("transition")
    state.transition_generation += 1
    let generation = state.transition_generation
    style.set_property("transition", "none")
    ignore(
      @dom.window().request_animation_frame(_ => {
        carousel_restore_transition(state, generation, transition)
      }),
    )
  }
  track_html.get_style().set_property("--rui-carousel-offset", "\{offset}px")
  state.offset = Some(offset)
  state.previous_index = Some(index)
  state.root.set_attribute("data-max-snap-index", "\{max_index}")
  for item_index, item in state.items {
    let visible = sizes[item_index] > 0.0 &&
      starts[item_index] + sizes[item_index] > travel + 0.5 &&
      starts[item_index] < travel + viewport_size - 0.5
    item.set_attribute("data-visible", ui_bool(visible))
    if visible {
      item.remove_attribute("aria-hidden")
      item.remove_attribute("inert")
    } else {
      item.set_attribute("aria-hidden", "true")
      item.set_attribute("inert", "")
    }
  }
  if carousel_owned_element(state.root, "[data-slot=\"carousel-previous\"]")
    is Some(previous) {
    carousel_set_control_state(previous, max_index > 0 && (loop_ || index > 0))
  }
  if carousel_owned_element(state.root, "[data-slot=\"carousel-next\"]")
    is Some(next) {
    carousel_set_control_state(
      next,
      max_index > 0 && (loop_ || index < max_index),
    )
  }
  max_index
}

///|
#cfg(target="js")
fn carousel_report_layout(state : CarouselLayoutState, max_index : Int) -> Unit {
  if state.reported_max != Some(max_index) {
    state.reported_max = Some(max_index)
    (state.notify)(max_index)
  }
}

///|
#cfg(target="js")
fn carousel_layout_targets_changed(
  state : CarouselLayoutState,
  viewport : @dom.Element,
  track : @dom.Element,
  items : Array[@dom.Element],
) -> Bool {
  if !state.viewport.is_same_node(viewport.as_node()) ||
    !state.track.is_same_node(track.as_node()) ||
    state.items.length() != items.length() {
    return true
  }
  for index, item in items {
    if !state.items[index].is_same_node(item.as_node()) {
      return true
    }
  }
  false
}

///|
#cfg(target="js")
fn carousel_observe_layout(state : CarouselLayoutState) -> Unit {
  if state.observer is None {
    state.observer = Some(
      @dom.ResizeObserver::new((_, _) => {
        if !state.root.get_is_connected() {
          carousel_remove_layout_state(state.root)
        } else {
          carousel_report_layout(
            state,
            carousel_sync_layout_state(state, false),
          )
        }
      }),
    )
  }
  if state.observer is Some(observer) {
    observer.observe(state.viewport)
    observer.observe(state.track)
    for item in state.items {
      observer.observe(item)
    }
  }
}

///|
#cfg(target="js")
fn carousel_layout_offset(track : @dom.Element) -> Double? {
  for state in carousel_layout_states {
    if state.track.is_same_node(track.as_node()) {
      return state.offset
    }
  }
  None
}

///|
#cfg(target="js")
fn carousel_sync_layout(id : String, notify : (Int) -> Unit) -> Unit {
  guard ui_element_by_id(id) is Some(root) else { return }
  guard root.get_attribute("data-slot").unwrap_or("") == "carousel" else {
    return
  }
  guard carousel_owned_element(root, "[data-slot=\"carousel-content\"]")
    is Some(viewport) else {
    return
  }
  guard carousel_owned_element(root, "[data-slot=\"carousel-track\"]")
    is Some(track) else {
    return
  }
  let items = carousel_owned_elements(root, "[data-slot=\"carousel-item\"]")
  if items.length() == 0 {
    return
  }
  let state = if carousel_layout_state(root) is Some(state) {
    if carousel_layout_targets_changed(state, viewport, track, items) &&
      state.observer is Some(observer) {
      observer.disconnect()
      state.observer = None
    }
    state.viewport = viewport
    state.track = track
    state.items = items
    state.notify = notify
    state
  } else {
    let state : CarouselLayoutState = {
      root,
      viewport,
      track,
      items,
      notify,
      previous_index: None,
      offset: None,
      reported_max: None,
      observer: None,
      transition_generation: 0,
    }
    carousel_layout_states.push(state)
    state
  }
  carousel_report_layout(state, carousel_sync_layout_state(state, true))
  carousel_observe_layout(state)
}

///|
#cfg(target="js")
fn carousel_sync_layout_cmd(
  id : String,
  emit : @cmd.Emit[CarouselMsg],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, scheduler => {
    ui_after_mount(
      id,
      () => {
        carousel_sync_layout(id, max_index => {
          scheduler.add(emit(CarouselMeasured(max_index)))
        })
      },
      purpose="carousel-layout",
    )
  })
}

///|
#cfg(target="js")
priv struct CarouselPointerState {
  viewport : @dom.Element
  track : @dom.Element
  pointer_id : Int
  horizontal : Bool
  rtl : Bool
  can_previous : Bool
  can_next : Bool
  resist_previous : Bool
  resist_next : Bool
  start_x : Int
  start_y : Int
  start_time : Double
  size : Double
  base_offset : Double?
  base_percent : Double
  mut active : Bool
  original_transform : String
  original_transition : String
  original_cursor : String
  original_user_select : String
  mut suppress_click : @dom.Listener?
}

///|
#cfg(target="js")
let carousel_pointer_states : Array[CarouselPointerState] = []

///|
#cfg(target="js")
fn carousel_pointer_state(viewport : @dom.Element) -> CarouselPointerState? {
  for state in carousel_pointer_states {
    if state.viewport.is_same_node(viewport.as_node()) {
      return Some(state)
    }
  }
  None
}

///|
#cfg(target="js")
fn carousel_remove_pointer_state(viewport : @dom.Element) -> Unit {
  for index, state in carousel_pointer_states {
    if state.viewport.is_same_node(viewport.as_node()) {
      ignore(carousel_pointer_states.remove(index))
      return
    }
  }
}

///|
#cfg(target="js")
fn carousel_restore_style_property(
  style : @dom.CSSStyleDeclaration,
  name : String,
  value : String,
) -> Unit {
  if value == "" {
    ignore(style.remove_property(name))
  } else {
    style.set_property(name, value)
  }
}

///|
#cfg(target="js")
fn carousel_remove_click_suppression(state : CarouselPointerState) -> Unit {
  if state.suppress_click is Some(listener) {
    state.viewport.remove_event_listener_with_options(
      "click",
      listener,
      capture=true,
    )
    state.suppress_click = None
  }
}

///|
#cfg(target="js")
fn carousel_install_click_suppression(state : CarouselPointerState) -> Unit {
  if state.suppress_click is Some(_) {
    return
  }
  let listener : @dom.Listener = click => {
    click.prevent_default()
    click.stop_propagation()
    carousel_remove_click_suppression(state)
  }
  state.suppress_click = Some(listener)
  state.viewport.add_event_listener_with_options(
    "click",
    listener,
    capture=true,
  )
}

///|
#cfg(target="js")
fn carousel_release_pointer_state(
  state : CarouselPointerState,
  keep_click_suppression : Bool,
) -> Unit {
  if state.track.to_html_element() is Some(track) {
    let style = track.get_style()
    carousel_restore_style_property(
      style,
      "transform",
      state.original_transform,
    )
    carousel_restore_style_property(
      style,
      "transition",
      state.original_transition,
    )
  }
  if state.viewport.to_html_element() is Some(viewport) {
    let style = viewport.get_style()
    carousel_restore_style_property(
      style,
      "--rui-carousel-cursor",
      state.original_cursor,
    )
    carousel_restore_style_property(
      style,
      "--rui-carousel-user-select",
      state.original_user_select,
    )
  }
  state.viewport.remove_attribute("data-dragging")
  if state.viewport.has_pointer_capture(state.pointer_id) {
    state.viewport.release_pointer_capture(state.pointer_id)
  }
  carousel_remove_pointer_state(state.viewport)
  if keep_click_suppression && state.suppress_click is Some(_) {
    ignore(
      @dom.window().set_timeout(
        () => carousel_remove_click_suppression(state),
        0,
      ),
    )
  } else {
    carousel_remove_click_suppression(state)
  }
}

///|
#cfg(target="js")
fn carousel_pointer_start(
  event : @dom.MouseEvent,
  orientation : String,
  index : Int,
  can_previous : Bool,
  can_next : Bool,
) -> Bool {
  guard event.to_pointer_event() is Some(pointer) else { return false }
  if pointer.get_default_prevented() ||
    !pointer.get_is_primary() ||
    (pointer.get_pointer_type() == "mouse" && pointer.get_button() != 0) ||
    (!can_previous && !can_next) {
    return false
  }
  guard pointer.current_target().to_option() is Some(current_target) else {
    return false
  }
  guard current_target.to_element() is Some(viewport) else { return false }
  guard viewport.to_html_element() is Some(viewport_html) else { return false }
  guard viewport.query_selector("[data-slot=\"carousel-track\"]") is Some(track) else {
    return false
  }
  guard track.to_html_element() is Some(track_html) else { return false }
  if pointer.target().to_element() is Some(target) &&
    target.closest("input,textarea,select,[contenteditable=\"true\"]")
    is Some(_) {
    return false
  }
  if carousel_pointer_state(viewport) is Some(previous) {
    carousel_release_pointer_state(previous, false)
  }
  let horizontal = orientation == "horizontal"
  let rtl = horizontal && ui_element_is_rtl(viewport)
  let root = viewport.closest("[data-slot=\"carousel\"]")
  let max_index = if root is Some(root) {
    ui_parse_int_or(
      root.get_attribute("data-max-snap-index").unwrap_or(""),
      (ui_parse_int_or(root.get_attribute("data-count").unwrap_or(""), 1) - 1).max(
        0,
      ),
    )
  } else {
    0
  }
  let loop_ = root is Some(root) &&
    root.get_attribute("data-loop").unwrap_or("") == "true"
  let track_style = track_html.get_style()
  let viewport_style = viewport_html.get_style()
  let state : CarouselPointerState = {
    viewport,
    track,
    pointer_id: pointer.get_pointer_id(),
    horizontal,
    rtl,
    can_previous,
    can_next,
    resist_previous: loop_ && index <= 0,
    resist_next: loop_ && index >= max_index,
    start_x: pointer.get_client_x(),
    start_y: pointer.get_client_y(),
    start_time: pointer.get_time_stamp(),
    size: if horizontal {
      viewport.get_client_width()
    } else {
      viewport.get_client_height()
    },
    base_offset: carousel_layout_offset(track),
    base_percent: (index * 100 * (if horizontal && rtl { 1 } else { -1 })).to_double(),
    active: false,
    original_transform: track_style.get_property_value("transform"),
    original_transition: track_style.get_property_value("transition"),
    original_cursor: viewport_style.get_property_value("--rui-carousel-cursor"),
    original_user_select: viewport_style.get_property_value(
      "--rui-carousel-user-select",
    ),
    suppress_click: None,
  }
  carousel_pointer_states.push(state)
  viewport.set_pointer_capture(state.pointer_id)
  true
}

///|
#cfg(target="js")
fn carousel_pointer_move(event : @dom.MouseEvent) -> Bool {
  guard event.to_pointer_event() is Some(pointer) else { return false }
  guard pointer.current_target().to_option() is Some(current_target) else {
    return false
  }
  guard current_target.to_element() is Some(viewport) else { return false }
  guard carousel_pointer_state(viewport) is Some(state) else { return false }
  guard state.pointer_id == pointer.get_pointer_id() else { return false }
  guard viewport.to_html_element() is Some(viewport_html) else { return false }
  guard state.track.to_html_element() is Some(track_html) else {
    carousel_release_pointer_state(state, false)
    return false
  }
  let primary = if state.horizontal {
    pointer.get_client_x() - state.start_x
  } else {
    pointer.get_client_y() - state.start_y
  }
  let cross = if state.horizontal {
    pointer.get_client_y() - state.start_y
  } else {
    pointer.get_client_x() - state.start_x
  }
  if !state.active {
    if primary.abs() < 6 || primary.abs() <= cross.abs() {
      return false
    }
    state.active = true
    carousel_install_click_suppression(state)
    viewport.set_attribute("data-dragging", "true")
    viewport_html.get_style().set_property("--rui-carousel-cursor", "grabbing")
    viewport_html.get_style().set_property("--rui-carousel-user-select", "none")
  }
  let toward_next = if state.horizontal {
    if state.rtl {
      primary > 0
    } else {
      primary < 0
    }
  } else {
    primary < 0
  }
  let blocked = if toward_next {
    !state.can_next || state.resist_next
  } else {
    !state.can_previous || state.resist_previous
  }
  let visual = if blocked {
    primary.to_double() * 0.35
  } else {
    primary.to_double()
  }
  let base = if state.base_offset is Some(offset) {
    "\{offset}px"
  } else {
    "\{state.base_percent}%"
  }
  let transform = if state.horizontal {
    "translate3d(calc(\{base} + \{visual}px),0,0)"
  } else {
    "translate3d(0,calc(\{base} + \{visual}px),0)"
  }
  let track_style = track_html.get_style()
  track_style.set_property("transition", "none")
  track_style.set_property("transform", transform)
  true
}

///|
#cfg(target="js")
fn carousel_pointer_end(event : @dom.MouseEvent) -> Int {
  guard event.to_pointer_event() is Some(pointer) else { return 0 }
  guard pointer.current_target().to_option() is Some(current_target) else {
    return 0
  }
  guard current_target.to_element() is Some(viewport) else { return 0 }
  guard carousel_pointer_state(viewport) is Some(state) else { return 0 }
  guard state.pointer_id == pointer.get_pointer_id() else { return 0 }
  let primary = if state.horizontal {
    pointer.get_client_x() - state.start_x
  } else {
    pointer.get_client_y() - state.start_y
  }
  let elapsed = (pointer.get_time_stamp() - state.start_time).max(1.0)
  let threshold = (state.size * 0.12).max(24.0).min(64.0)
  let qualifies = state.active &&
    (
      primary.abs().to_double() >= threshold ||
      (primary.abs() >= 12 && primary.abs().to_double() / elapsed >= 0.45)
    )
  let toward_next = if state.horizontal {
    if state.rtl {
      primary > 0
    } else {
      primary < 0
    }
  } else {
    primary < 0
  }
  let mut step = if qualifies { if toward_next { 1 } else { -1 } } else { 0 }
  if (step > 0 && !state.can_next) || (step < 0 && !state.can_previous) {
    step = 0
  }
  let dragged = state.active
  carousel_release_pointer_state(state, dragged)
  if step != 0 {
    step
  } else if dragged {
    2
  } else {
    0
  }
}

///|
#cfg(target="js")
fn carousel_pointer_cancel(event : @dom.MouseEvent) -> Unit {
  guard event.to_pointer_event() is Some(pointer) else { return }
  guard pointer.current_target().to_option() is Some(current_target) else {
    return
  }
  guard current_target.to_element() is Some(viewport) else { return }
  guard carousel_pointer_state(viewport) is Some(state) else { return }
  guard state.pointer_id == pointer.get_pointer_id() else { return }
  carousel_release_pointer_state(state, false)
}

///|
#cfg(target="js")
fn carousel_bind_pointer_attrs(
  attrs : @html.Attrs,
  scope : CarouselScope,
) -> Unit {
  ignore(
    attrs
    .on_pointerdown(event => {
      ignore(
        carousel_pointer_start(
          event,
          carousel_orientation_value(scope.orientation),
          scope.index,
          carousel_can_previous(scope),
          carousel_can_next(scope),
        ),
      )
      @cmd.none
    })
    .on_pointermove(event => {
      if carousel_pointer_move(event) {
        event.prevent_default()
      }
      @cmd.none
    })
    .on_pointerup(event => {
      let result = carousel_pointer_end(event)
      if result != 0 {
        event.prevent_default()
      }
      if result == -1 {
        (scope.emit)(carousel_previous_index(scope))
      } else if result == 1 {
        (scope.emit)(carousel_next_index(scope))
      } else {
        @cmd.none
      }
    })
    .on_pointercancel(event => {
      carousel_pointer_cancel(event)
      @cmd.none
    }),
  )
}

///|
#cfg(not(target="js"))
fn carousel_bind_pointer_attrs(
  attrs : @html.Attrs,
  scope : CarouselScope,
) -> Unit {
  ignore((attrs, scope))
}

///|
#cfg(target="js")
fn carousel_keyboard_attrs(scope : CarouselScope) -> @html.Attrs {
  let attrs = @html.Attrs::build().data_set("slot", "carousel-scope")
  ignore(
    attrs.on_keydown(event => {
      let step = carousel_key_step(
        event,
        carousel_orientation_value(scope.orientation),
      )
      if step < 0 && carousel_can_previous(scope) {
        event.prevent_default()
        (scope.emit)(carousel_previous_index(scope))
      } else if step > 0 && carousel_can_next(scope) {
        event.prevent_default()
        (scope.emit)(carousel_next_index(scope))
      } else {
        @cmd.none
      }
    }),
  )
  attrs
}

///|
#cfg(not(target="js"))
fn carousel_keyboard_attrs(scope : CarouselScope) -> @html.Attrs {
  ignore(scope)
  @html.Attrs::build().data_set("slot", "carousel-scope")
}

///|
fn carousel_status(scope : CarouselScope) -> @html.Html {
  let text = if scope.count == 0 {
    "No slides"
  } else {
    "Slide \{scope.index + 1} of \{scope.count}"
  }
  @html.span(
    style=[UiBoxSizing, CarouselScreenReaderStyle],
    attrs=@html.Attrs::build()
      .data_set("slot", "carousel-status")
      .aria_live("polite")
      .aria_atomic("true"),
    text,
  )
}

///|
fn[C : @html.IsChildren] render_carousel(
  scope : CarouselScope,
  aria_label : String?,
  id : String?,
  class : String?,
  title : String?,
  hidden : Bool?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : (CarouselScope) -> C,
) -> @html.Html {
  let root_attrs = ui_attrs(attrs)
    .data_set("slot", "carousel")
    .data_set("orientation", carousel_orientation_value(scope.orientation))
    .data_set("active-index", scope.index.to_string())
    .data_set("count", scope.count.to_string())
    .data_set("max-snap-index", scope.max_index.to_string())
    .data_set("loop", ui_bool(scope.loop_))
    .role("region")
    .aria_roledescription("carousel")
    .aria_orientation(carousel_orientation_value(scope.orientation))
  if aria_label is Some(label) {
    ignore(root_attrs.aria_label(label))
  }
  @html.div(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, CarouselRootStyle],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=root_attrs,
    [
      @html.div(
        style=[UiBoxSizing, CarouselScopeStyle],
        attrs=carousel_keyboard_attrs(scope),
        children(scope),
      ),
      carousel_status(scope),
    ],
  )
}

///|
/// Render the clipping viewport and translated slide track for a scope.
///
/// Component props style the viewport; `track_attrs` and `track_style` target
/// the moving flex track. All caller attribute values are cloned.
pub fn[C : @html.IsChildren] carousel_content(
  scope~ : CarouselScope,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  track_attrs? : @html.Attrs,
  style? : Array[String] = [],
  track_style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let orientation = carousel_orientation_value(scope.orientation)
  let viewport_attrs = ui_attrs(attrs)
    .data_set("slot", "carousel-content")
    .data_set("orientation", orientation)
    .data_set("swipe", "true")
  carousel_bind_pointer_attrs(viewport_attrs, scope)
  let moving_attrs = ui_attrs(track_attrs)
    .data_set("slot", "carousel-track")
    .data_set("orientation", orientation)
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        CarouselViewportStyle,
        carousel_viewport_orientation_style(scope.orientation),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=viewport_attrs,
    @html.div(
      style=ui_styles(
        [
          UiBoxSizing,
          CarouselTrackStyle,
          carousel_track_orientation_style(scope.orientation),
          carousel_track_transform(scope),
        ],
        track_style,
      ),
      attrs=moving_attrs,
      children,
    ),
  )
}

///|
/// Render one semantic carousel slide.
///
/// Mounted stateful carousels measure the viewport and make only truly clipped
/// slides inert. Static/controlled markup stays conservative because active
/// index alone cannot determine visibility when callers customize item sizes.
pub fn[C : @html.IsChildren] carousel_item(
  scope~ : CarouselScope,
  index~ : Int,
  aria_label? : String,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let active = index == scope.index && index >= 0 && index < scope.count
  let label = aria_label.unwrap_or("Slide \{index + 1} of \{scope.count}")
  let item_attrs = ui_attrs(attrs)
    .data_set("slot", "carousel-item")
    .data_set("orientation", carousel_orientation_value(scope.orientation))
    .data_set("index", index.to_string())
    .data_set("state", if active { "active" } else { "inactive" })
    .data_set("active", ui_bool(active))
    .role("group")
    .aria_roledescription("slide")
    .aria_label(label)
    .aria_posinset((index + 1).to_string())
    .aria_setsize(scope.count.to_string())
  if active {
    ignore(item_attrs.aria_current("true"))
  }
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        CarouselItemStyle,
        carousel_item_orientation_style(scope.orientation),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=item_attrs,
    children,
  )
}

///|
/// Convenience composition for an array of already-built slide bodies.
pub fn carousel_items(
  scope~ : CarouselScope,
  items~ : Array[@html.Html],
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  track_attrs? : @html.Attrs,
  style? : Array[String] = [],
  track_style? : Array[String] = [],
  item_style? : Array[String] = [],
) -> @html.Html {
  let slides : Array[@html.Html] = []
  for index, item in items {
    slides.push(carousel_item(scope~, index~, style=item_style, item))
  }
  carousel_content(
    scope~,
    id?,
    class?,
    title?,
    attrs?,
    track_attrs?,
    style~,
    track_style~,
    slides,
  )
}

///|
fn carousel_control(
  scope : CarouselScope,
  previous : Bool,
  disabled : Bool,
  aria_label : String,
  id : String?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
) -> @html.Html {
  let can_move = if previous {
    carousel_can_previous(scope)
  } else {
    carousel_can_next(scope)
  }
  let disabled = disabled || !can_move
  let direction = if previous { "previous" } else { "next" }
  let target = if previous {
    carousel_previous_index(scope)
  } else {
    carousel_next_index(scope)
  }
  let control_attrs = ui_attrs(attrs)
    .data_set("slot", "carousel-\{direction}")
    .data_set("direction", direction)
    .data_set("state", if disabled { "disabled" } else { "enabled" })
    .data_set("variant", button_variant_value(Outline))
    .data_set("size", button_size_value(IconSm))
    .aria_label(aria_label)
    .aria_disabled(ui_bool(disabled))
  if disabled {
    ignore(control_attrs.data_set("disabled", ""))
  } else {
    ignore(control_attrs.on_click(_ => (scope.emit)(target)))
  }
  @html.button(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        ButtonBaseStyle,
        ButtonOutlineStyle,
        ButtonSizeIconSmStyle,
        CarouselControlStyle,
        carousel_control_position_style(scope.orientation, previous),
        ui_disabled_style(disabled),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    type_="button",
    disabled~,
    attrs=control_attrs,
    @html.span(
      style=[UiBoxSizing, CarouselChevronBoxStyle],
      attrs=@html.Attrs::build()
        .aria_hidden("true")
        .data_set("icon", if previous { "previous" } else { "next" }),
      @html.span(
        style=[
          UiBoxSizing,
          CarouselChevronStyle,
          carousel_control_chevron_style(scope.orientation, previous),
        ],
        @html.nothing,
      ),
    ),
  )
}

///|
/// Render the previous control bound to a carousel scope.
pub fn carousel_previous(
  scope~ : CarouselScope,
  disabled? : Bool = false,
  aria_label? : String = "Previous slide",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  carousel_control(
    scope, true, disabled, aria_label, id, class, title, attrs, style,
  )
}

///|
/// Render the next control bound to a carousel scope.
pub fn carousel_next(
  scope~ : CarouselScope,
  disabled? : Bool = false,
  aria_label? : String = "Next slide",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  carousel_control(
    scope, false, disabled, aria_label, id, class, title, attrs, style,
  )
}

///|
/// Render one indexed Carousel state for the native incremental fallback.
///
/// This synchronous primitive uses the 100% slide fallback encoded in the
/// track. Use stateful `carousel` for automatic measured snapping when public
/// `track_style`/item styles introduce gaps or non-default flex bases; callers
/// that own DOM measurement may also set `--rui-carousel-offset` themselves.
#cfg(not(target="js"))
fn[C : @html.IsChildren] render_carousel_index(
  index~ : Int,
  count~ : Int,
  loop_? : Bool = false,
  orientation? : CarouselOrientation = CarouselHorizontal,
  aria_label? : String,
  on_index_change? : @cmd.Emit[Int],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (CarouselScope) -> C,
) -> @html.Html {
  let count = carousel_count(count)
  let index = carousel_index(index, count)
  let max_index = carousel_index(count - 1, count)
  let emit = on_index_change.unwrap_or(Emit(_ => @cmd.none))
  render_carousel(
    { index, count, max_index, loop_, orientation, emit },
    aria_label,
    id,
    class,
    title,
    hidden,
    attrs,
    style,
    children,
  )
}

///|
/// Stateful carousel root. The active slide is component-local; the scope
/// binds content, items, previous/next buttons, and orientation-aware arrow
/// keys without Embla or another runtime dependency.
#cfg(target="js")
pub fn[C : @html.IsChildren] carousel(
  count~ : Int,
  default_index? : Int = 0,
  loop_? : Bool = false,
  orientation? : CarouselOrientation = CarouselHorizontal,
  aria_label? : String,
  on_index_change? : @cmd.Emit[Int],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (CarouselScope) -> C,
) -> @rabbita.Val[@html.Html] {
  let count = carousel_count(count)
  let initial = carousel_index(default_index, count)
  let root_id = id.unwrap_or(carousel_next_id())
  let initial_max = carousel_index(count - 1, count)
  let (model, emit) = @rabbita.create_state_with_init(
    init=fn(emit) {
      (
        { index: initial, max_index: initial_max },
        carousel_sync_layout_cmd(root_id, emit),
      )
    },
    update=fn(current, message, emit) {
      match message {
        CarouselSetIndex(requested) => {
          let next = carousel_index(requested, count).clamp(
            min=0,
            max=current.max_index,
          )
          let notify = if on_index_change is Some(callback) {
            callback(next)
          } else {
            @cmd.none
          }
          (
            { ..current, index: next },
            @cmd.batch([notify, carousel_sync_layout_cmd(root_id, emit)]),
          )
        }
        CarouselMeasured(measured) => {
          let max_index = carousel_index(measured, count)
          let index = current.index.clamp(min=0, max=max_index)
          if max_index == current.max_index && index == current.index {
            (current, @cmd.none)
          } else {
            let notify = if index != current.index &&
              on_index_change is Some(callback) {
              callback(index)
            } else {
              @cmd.none
            }
            (
              { index, max_index },
              @cmd.batch([notify, carousel_sync_layout_cmd(root_id, emit)]),
            )
          }
        }
      }
    },
  )
  model.view(model => {
    let set_index = emit.map(index => CarouselSetIndex(index))
    render_carousel(
      {
        index: model.index,
        count,
        max_index: model.max_index,
        loop_,
        orientation,
        emit: set_index,
      },
      aria_label,
      Some(root_id),
      class,
      title,
      hidden,
      attrs,
      style,
      children,
    )
  })
}

///|
/// Native/SSR fallback for `carousel`; renders the requested initial scope as
/// a constant incremental value.
#cfg(not(target="js"))
pub fn[C : @html.IsChildren] carousel(
  count~ : Int,
  default_index? : Int = 0,
  loop_? : Bool = false,
  orientation? : CarouselOrientation = CarouselHorizontal,
  aria_label? : String,
  on_index_change? : @cmd.Emit[Int],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (CarouselScope) -> C,
) -> @rabbita.Val[@html.Html] {
  ignore(on_index_change)
  let count = carousel_count(count)
  let index = carousel_index(default_index, count)
  let emit = @cmd.Emit(_ => @cmd.none)
  @rabbita.Val::constant(
    render_carousel_index(
      index~,
      count~,
      loop_~,
      orientation~,
      aria_label?,
      on_index_change=emit,
      id?,
      class?,
      title?,
      hidden?,
      attrs?,
      style~,
      children,
    ),
  )
}
