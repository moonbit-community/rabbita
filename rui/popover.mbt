///|
pub(all) enum PopupSide {
  Top
  Right
  Bottom
  Left
} derive(Debug, Eq)

///|
pub(all) enum PopupAlign {
  Start
  Center
  End
} derive(Debug, Eq)

///|
const PopoverRootStyle : String = "display:contents"

///|
const PopoverAnchorStyle : String = "position:relative;display:inline-flex;max-width:100%"

///|
const PopoverContentStyle : String = "position:fixed;inset:auto;left:var(--rui-floating-left,auto);top:var(--rui-floating-top,auto);z-index:50;display:flex;width:18rem;max-width:calc(100vw - 1rem);transform-origin:var(--rui-floating-transform-origin,center);flex-direction:column;gap:1rem;margin:0;border:0;border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-popover,oklch(1 0 0));padding:1rem;color:var(--rui-popover-foreground,oklch(0.145 0 0));font-size:0.875rem;line-height:1.25rem;box-shadow:0 10px 15px -3px rgb(0 0 0 / 0.1),0 4px 6px -4px rgb(0 0 0 / 0.1),0 0 0 1px color-mix(in oklab,var(--rui-foreground,oklch(0.145 0 0)) 10%,transparent);outline:none;transition:opacity 100ms ease,transform 100ms ease,visibility 100ms ease"

///|
const PopoverHeaderStyle : String = "display:flex;flex-direction:column;gap:0.25rem;font-size:0.875rem;line-height:1.25rem"

///|
const PopoverTitleStyle : String = "margin:0;font-size:0.875rem;line-height:1.25rem;font-weight:500"

///|
const PopoverDescriptionStyle : String = "margin:0;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem;line-height:1.25rem"

///|
const PopupOpenStyle : String = "visibility:visible;opacity:1;pointer-events:auto;transform:scale(1)"

///|
const PopupClosedStyle : String = "visibility:hidden;opacity:0;pointer-events:none;transform:scale(0.95)"

///|
/// Keep a native popover or dialog in the top layer while its visual exit
/// finishes. `@starting-style` in the internal theme supplies the matching
/// closed first frame for entry, so consumers do not need lifecycle scripts or
/// an external animation stylesheet.
const PopupTransition100Style : String = "transition:opacity 100ms ease,transform 100ms ease,visibility 100ms ease,display 100ms allow-discrete,overlay 100ms allow-discrete;transition-behavior:allow-discrete"

///|
const PopupTransition150Style : String = "transition:opacity 150ms ease,transform 150ms ease,visibility 150ms ease,display 150ms allow-discrete,overlay 150ms allow-discrete;transition-behavior:allow-discrete"

///|
fn popup_side_value(side : PopupSide) -> String {
  match side {
    Top => "top"
    Right => "right"
    Bottom => "bottom"
    Left => "left"
  }
}

///|
fn popup_align_value(align : PopupAlign) -> String {
  match align {
    Start => "start"
    Center => "center"
    End => "end"
  }
}

///|
/// Encode an arbitrary HTML id as a valid, collision-free CSS dashed-ident.
/// Keeping this deterministic lets both compound and standalone parts render
/// their anchor relationship directly, without a post-render setup pass.
fn popup_anchor_name(id : String) -> String {
  let name = StringBuilder::new()
  name.write_string("--rui-anchor")
  for character in id.iter() {
    name.write_char('_')
    name.write_object(character.to_int())
  }
  name.to_string()
}

///|
fn popup_anchor_style(id : String) -> String {
  "anchor-name:\{popup_anchor_name(id)}"
}

///|
fn popup_position_area(side : PopupSide, align : PopupAlign) -> String {
  let side_value = popup_side_value(side)
  match (side, align) {
    (Top | Bottom, Start) => side_value + " span-x-end"
    (Top | Bottom, Center) => side_value
    (Top | Bottom, End) => side_value + " span-x-start"
    (Left | Right, Start) => side_value + " span-y-end"
    (Left | Right, Center) => side_value
    (Left | Right, End) => side_value + " span-y-start"
  }
}

///|
fn popup_side_offset_style(side : PopupSide, offset : Int) -> String {
  match side {
    Top => "margin-bottom:\{offset}px"
    Right => "margin-left:\{offset}px"
    Bottom => "margin-top:\{offset}px"
    Left => "margin-right:\{offset}px"
  }
}

///|
fn popup_align_offset_style(side : PopupSide, offset : Int) -> String {
  match side {
    Top | Bottom => "translate:\{offset}px 0"
    Right | Left => "translate:0 \{offset}px"
  }
}

///|
fn popup_transform_origin(side : PopupSide, align : PopupAlign) -> String {
  let cross_axis = match align {
    Start => "0%"
    Center => "50%"
    End => "100%"
  }
  match side {
    Top => cross_axis + " 100%"
    Right => "0% " + cross_axis
    Bottom => cross_axis + " 0%"
    Left => "100% " + cross_axis
  }
}

///|
/// Native CSS Anchor Positioning is the primary path. The browser performs
/// scroll tracking, viewport fitting, and opposite-side fallbacks during its
/// own layout pass; the runtime positioning pass is retained only for older
/// engines and for synchronizing a tooltip arrow with the rendered side.
fn popup_floating_anchor_style(
  trigger_id : String,
  side : PopupSide,
  align : PopupAlign,
  side_offset : Int,
  align_offset : Int,
) -> String {
  let fallbacks = match side {
    Top | Bottom => "flip-inline,flip-block,flip-inline flip-block"
    Right | Left => "flip-block,flip-inline,flip-block flip-inline"
  }
  "position-anchor:\{popup_anchor_name(trigger_id)};position-area:\{popup_position_area(side, align)};position-try-fallbacks:\{fallbacks};position-visibility:always;\{popup_side_offset_style(side, side_offset)};\{popup_align_offset_style(side, align_offset)};--rui-floating-transform-origin:\{popup_transform_origin(side, align)}"
}

///|
fn popup_state_style(open : Bool) -> String {
  if open {
    PopupOpenStyle
  } else {
    PopupClosedStyle
  }
}

///|
fn popup_state_attrs(
  attrs : @html.Attrs?,
  slot : String,
  open : Bool,
) -> @html.Attrs {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", slot)
    .data_set("state", if open { "open" } else { "closed" })
  if open {
    ignore(element_attrs.data_set("open", ""))
  } else {
    ignore(element_attrs.data_set("closed", ""))
  }
  element_attrs
}

///|
#cfg(target="js")
fn floating_dialog_open(open : Bool) -> Bool? {
  ignore(open)
  None
}

///|
#cfg(not(target="js"))
fn floating_dialog_open(open : Bool) -> Bool? {
  Some(open)
}

///|
#cfg(target="js")
priv struct FloatingLayerBinding {
  id : String
  element : @dom.Element
  html : @dom.HTMLElement
  sync : Ref[(Bool) -> Unit]
  open : Ref[Bool]
  return_focus : Ref[@dom.HTMLElement?]
  had_nested_pointer : Ref[Bool]
}

///|
#cfg(target="js")
priv struct TooltipProviderClose {
  element : @dom.Element
  closed_at : Ref[Double]
}

///|
#cfg(target="js")
let floating_layers : Map[String, FloatingLayerBinding] = Map([])

///|
#cfg(target="js")
let floating_stack : Ref[Array[String]] = Ref([])

///|
#cfg(target="js")
let floating_request_close : Map[String, () -> Unit] = Map([])

///|
#cfg(target="js")
let floating_stop_positioning : Map[String, () -> Unit] = Map([])

///|
#cfg(target="js")
let floating_bound_document : Ref[@dom.Document?] = Ref(None)

///|
#cfg(target="js")
let tooltip_provider_closes : Array[TooltipProviderClose] = []

///|
#cfg(target="js")
fn floating_same_element(left : @dom.Element, right : @dom.Element) -> Bool {
  left.is_same_node(right.as_node())
}

///|
#cfg(target="js")
fn floating_set_request_close(id : String, request : () -> Unit) -> Unit {
  floating_request_close[id] = request
}

///|
#cfg(target="js")
fn floating_set_stop_positioning(id : String, stop : () -> Unit) -> Unit {
  floating_stop_positioning[id] = stop
}

///|
#cfg(target="js")
fn floating_stop(id : String) -> Unit {
  if floating_stop_positioning.get(id) is Some(stop) {
    stop()
  }
}

///|
#cfg(target="js")
fn floating_update_stack(id : String, open : Bool) -> Unit {
  let next : Array[String] = []
  for current in floating_stack.val {
    if current != id {
      next.push(current)
    }
  }
  if open {
    next.push(id)
  }
  floating_stack.val = next
}

///|
#cfg(target="js")
fn floating_live_layer(id : String) -> FloatingLayerBinding? {
  guard floating_layers.get(id) is Some(layer) else { return None }
  guard ui_element_by_id(id) is Some(element) else {
    floating_update_stack(id, false)
    return None
  }
  if !element.get_is_connected() {
    floating_update_stack(id, false)
    return None
  }
  if !floating_same_element(layer.element, element) {
    // Incremental rendering may replace a physical node while preserving the
    // component id. Rebind the native listeners to that live node instead of
    // permanently dropping the layer from the dismissal stack.
    let sync = layer.sync.val
    let return_focus = layer.return_focus.val
    floating_stop(id)
    bind_floating_sync(id, sync)
    guard floating_layers.get(id) is Some(rebound) &&
      floating_same_element(rebound.element, element) else {
      floating_update_stack(id, false)
      return None
    }
    rebound.return_focus.val = return_focus
    return Some(rebound)
  }
  Some(layer)
}

///|
#cfg(target="js")
fn floating_layer_is_open(layer : FloatingLayerBinding) -> Bool {
  if layer.html.to_html_dialog_element() is Some(dialog) {
    dialog.open()
  } else {
    layer.open.val
  }
}

///|
#cfg(target="js")
fn floating_top_layer() -> FloatingLayerBinding? {
  let stack = floating_stack.val
  for index = stack.length() - 1; index >= 0; index = index - 1 {
    let id = stack[index]
    if floating_live_layer(id) is Some(layer) && floating_layer_is_open(layer) {
      return Some(layer)
    }
    floating_update_stack(id, false)
  }
  None
}

///|
#cfg(target="js")
fn floating_event_inside(event : @dom.Event, element : @dom.Element) -> Bool {
  if ui_element_contains_target(element, event.target()) {
    return true
  }
  for target in event.composed_path() {
    if target.to_node() is Some(node) && element.contains(node) {
      return true
    }
  }
  false
}

///|
#cfg(target="js")
fn tooltip_provider_mark_closed(provider : @dom.Element) -> Unit {
  let now = if ui_has_window() {
    @dom.window().get_performance().now()
  } else {
    0.0
  }
  for entry in tooltip_provider_closes {
    if floating_same_element(entry.element, provider) {
      entry.closed_at.val = now
      return
    }
  }
  tooltip_provider_closes.push({ element: provider, closed_at: Ref(now) })
}

///|
#cfg(target="js")
fn tooltip_provider_last_close(provider : @dom.Element) -> Double? {
  for entry in tooltip_provider_closes {
    if floating_same_element(entry.element, provider) {
      return Some(entry.closed_at.val)
    }
  }
  None
}

///|
#cfg(target="js")
fn floating_restore_focus(layer : FloatingLayerBinding) -> Unit {
  if layer.element.get_attribute("data-restore-focus").unwrap_or("") == "false" {
    return
  }
  let document = @dom.document()
  let final_id = layer.element
    .get_attribute("data-final-focus-id")
    .unwrap_or("")
  if ui_element_by_id(final_id) is Some(final_element) &&
    final_element.get_is_connected() &&
    final_element.to_html_element() is Some(final_target) {
    final_target.focus_with_options(prevent_scroll=true)
    return
  }
  if document.get_active_element() is Some(active) {
    let active_is_body = if document.get_body() is Some(body) {
      active.is_same_node(body.as_node())
    } else {
      false
    }
    if !active_is_body && !layer.element.contains(active.as_node()) {
      return
    }
  }
  let target = if layer.return_focus.val is Some(element) &&
    element.get_is_connected() {
    Some(element)
  } else {
    let trigger_id = layer.element
      .get_attribute("data-trigger-id")
      .unwrap_or("")
    if ui_element_by_id(trigger_id) is Some(element) {
      element.to_html_element()
    } else {
      None
    }
  }
  if target is Some(element) && element.get_is_connected() {
    element.focus_with_options(prevent_scroll=true)
  }
}

///|
#cfg(target="js")
fn floating_notify(layer : FloatingLayerBinding, open : Bool) -> Unit {
  // A replaced node can deliver a delayed toggle/close event after a new node
  // with the same component id has mounted. Adopt the live node first, then
  // ignore notifications originating from the detached binding.
  guard floating_live_layer(layer.id) is Some(current) &&
    floating_same_element(current.element, layer.element) else {
    return
  }
  let changed = layer.open.val != open
  layer.open.val = open
  floating_update_stack(layer.id, open)
  if !changed {
    return
  }
  if !open {
    floating_stop(layer.id)
    if layer.element.get_attribute("data-slot").unwrap_or("") ==
      "tooltip-content" &&
      layer.element.closest("[data-slot=\"tooltip-provider\"]")
      is Some(provider) {
      tooltip_provider_mark_closed(provider)
    }
    if ui_has_window() {
      @dom.window().queue_microtask(() => floating_restore_focus(layer))
    } else {
      floating_restore_focus(layer)
    }
  }
  (layer.sync.val)(open)
}

///|
#cfg(target="js")
fn floating_request_layer_close(layer : FloatingLayerBinding) -> Unit {
  if floating_request_close.get(layer.id) is Some(request) {
    request()
  } else if layer.html.to_html_dialog_element() is Some(dialog) {
    if dialog.open() {
      dialog.close()
    }
    floating_notify(layer, false)
  } else if layer.html.get_popover() is Some(_) {
    if layer.open.val {
      layer.html.hide_popover()
    }
    floating_notify(layer, false)
  } else {
    floating_notify(layer, false)
  }
}

///|
#cfg(target="js")
fn floating_has_nested(layer : FloatingLayerBinding) -> Bool {
  let stack = floating_stack.val
  let mut found_current = false
  for id in stack {
    if id == layer.id {
      found_current = true
    } else if found_current &&
      floating_live_layer(id) is Some(nested) &&
      floating_layer_is_open(nested) &&
      !floating_same_element(layer.element, nested.element) {
      return true
    }
  }
  false
}

///|
#cfg(target="js")
fn floating_bind_document_events() -> Unit {
  let document = @dom.document()
  if floating_bound_document.val is Some(bound) &&
    bound.to_node().is_same_node(document.to_node()) {
    return
  }
  floating_bound_document.val = Some(document)
  document.add_event_listener("keydown", event => {
    guard event.to_keyboard_event() is Some(keyboard) else { return }
    if keyboard.key() != "Escape" || event.get_default_prevented() {
      return
    }
    guard floating_top_layer() is Some(layer) else { return }
    event.prevent_default()
    event.stop_propagation()
    floating_request_layer_close(layer)
  })
  document.add_event_listener_with_options(
    "pointerdown",
    event => {
      guard floating_top_layer() is Some(layer) else { return }
      if layer.element.get_attribute("data-light-dismiss").unwrap_or("") ==
        "true" &&
        !floating_event_inside(event, layer.element) {
        floating_request_layer_close(layer)
      }
    },
    capture=true,
  )
}

///|
#cfg(target="js")
fn bind_floating_sync(id : String, sync : (Bool) -> Unit) -> Unit {
  guard ui_element_by_id(id) is Some(element) else { return }
  guard element.to_html_element() is Some(html) else { return }
  if floating_layers.get(id) is Some(layer) &&
    floating_same_element(layer.element, element) {
    layer.sync.val = sync
    return
  }
  let initially_open = if html.to_html_dialog_element() is Some(dialog) {
    dialog.open()
  } else if html.get_popover() is Some(_) {
    element.matches(":popover-open")
  } else {
    false
  }
  let layer : FloatingLayerBinding = {
    id,
    element,
    html,
    sync: Ref(sync),
    open: Ref(initially_open),
    return_focus: Ref(None),
    had_nested_pointer: Ref(false),
  }
  floating_layers[id] = layer
  floating_update_stack(id, initially_open)
  floating_bind_document_events()
  if html.to_html_dialog_element() is Some(dialog) {
    dialog.add_event_listener("close", _ => floating_notify(layer, false))
    dialog.add_event_listener("pointerdown", event => {
      if event.target().to_node() is Some(target) &&
        layer.element.is_same_node(target) {
        layer.had_nested_pointer.val = floating_has_nested(layer)
      }
    })
    dialog.add_event_listener("click", event => {
      guard event.target().to_node() is Some(target) else { return }
      if !layer.element.is_same_node(target) {
        return
      }
      let had_nested = layer.had_nested_pointer.val ||
        floating_has_nested(layer)
      layer.had_nested_pointer.val = false
      if had_nested {
        return
      }
      guard event.to_mouse_event() is Some(mouse) else { return }
      let rect = layer.element.get_bounding_client_rect()
      let x = mouse.get_client_x().to_double()
      let y = mouse.get_client_y().to_double()
      let outside = x < rect.get_left() ||
        x > rect.get_right() ||
        y < rect.get_top() ||
        y > rect.get_bottom()
      if outside && dialog.open() {
        dialog.close()
      }
    })
  } else {
    html.add_event_listener("toggle", _ => {
      // The element's top-layer state is the source of truth. Some browser
      // and test environments deliver a plain Event for native light-dismiss,
      // so requiring a ToggleEvent cast can leave Rabbita's open state stale.
      floating_notify(layer, element.matches(":popover-open"))
    })
  }
}

///|
#cfg(target="js")
fn floating_focus_initial(layer : FloatingLayerBinding) -> Unit {
  if layer.element.get_attribute("data-initial-focus").unwrap_or("") != "true" {
    return
  }
  let requested_id = layer.element
    .get_attribute("data-initial-focus-id")
    .unwrap_or("")
  let requested = ui_element_by_id(requested_id)
  let selector = "button:not([disabled]),a[href],input:not([disabled]),select:not([disabled]),textarea:not([disabled]),[tabindex]:not([tabindex=\"-1\"])"
  let target = if requested is Some(element) &&
    layer.element.contains(element.as_node()) {
    Some(element)
  } else {
    match layer.element.query_selector(selector) {
      Some(element) => Some(element)
      None => Some(layer.element)
    }
  }
  if target is Some(element) {
    ui_focus_element_without_scroll(element)
  }
}

///|
#cfg(target="js")
fn floating_capture_return_focus(layer : FloatingLayerBinding) -> Unit {
  if @dom.document().get_active_element() is Some(active) &&
    !layer.element.contains(active.as_node()) &&
    active.to_html_element() is Some(html) {
    layer.return_focus.val = Some(html)
  }
}

///|
#cfg(target="js")
fn floating_close_other_tooltips(layer : FloatingLayerBinding) -> Unit {
  if layer.element.get_attribute("data-slot").unwrap_or("") != "tooltip-content" ||
    layer.element.closest("[data-slot=\"tooltip-provider\"]") is None {
    return
  }
  guard layer.element.closest("[data-slot=\"tooltip-provider\"]")
    is Some(provider) else {
    return
  }
  for other in provider.query_selector_all("[data-slot=\"tooltip-content\"]") {
    if !floating_same_element(other, layer.element) {
      let other_id = other.get_attribute("id").unwrap_or("")
      if floating_live_layer(other_id) is Some(other_layer) &&
        floating_layer_is_open(other_layer) {
        floating_request_layer_close(other_layer)
      }
    }
  }
}

///|
#cfg(target="js")
fn set_floating_open(id : String, open : Bool) -> Bool {
  guard ui_has_document() else { return false }
  guard ui_element_by_id(id) is Some(element) && element.get_is_connected() else {
    return false
  }
  if floating_live_layer(id) is None {
    bind_floating_sync(id, _ => ())
  }
  guard floating_live_layer(id) is Some(layer) else { return false }
  if open {
    floating_capture_return_focus(layer)
    floating_close_other_tooltips(layer)
    if layer.html.to_html_dialog_element() is Some(dialog) {
      if !dialog.open() {
        dialog.show_modal()
      }
      floating_notify(layer, true)
    } else if layer.html.get_popover() is Some(_) {
      if !layer.open.val {
        layer.html.show_popover()
      }
      floating_notify(layer, true)
    } else {
      floating_notify(layer, true)
    }
    if ui_has_window() {
      ignore(
        @dom.window().request_animation_frame(_ => floating_focus_initial(layer)),
      )
    } else {
      floating_focus_initial(layer)
    }
  } else {
    if layer.html.to_html_dialog_element() is Some(dialog) {
      if dialog.open() {
        dialog.close()
      }
    } else if layer.html.get_popover() is Some(_) {
      if layer.open.val {
        layer.html.hide_popover()
      }
    }
    floating_notify(layer, false)
  }
  true
}

///|
#cfg(target="js")
fn toggle_floating(id : String) -> Unit {
  if floating_live_layer(id) is None {
    bind_floating_sync(id, _ => ())
  }
  if floating_live_layer(id) is Some(layer) {
    ignore(set_floating_open(id, !floating_layer_is_open(layer)))
  }
}

///|
#cfg(target="js")
priv struct FloatingPositioningBinding {
  element : @dom.Element
  html : @dom.HTMLElement
  mode : String
  frame : Ref[Double?]
  observing : Ref[Bool]
  listener : Ref[@dom.Listener?]
  resize_observer : Ref[@dom.ResizeObserver?]
  mutation_observer : Ref[@dom.MutationObserver?]
  intersection_observer : Ref[@dom.IntersectionObserver?]
}

///|
#cfg(target="js")
priv struct FloatingCoordinates {
  side : String
  left : Double
  top : Double
}

///|
#cfg(target="js")
let floating_positionings : Map[String, FloatingPositioningBinding] = Map([])

///|
#cfg(target="js")
fn floating_normalize_side(side : String) -> String {
  match side {
    "top" | "right" | "bottom" | "left" => side
    _ => "bottom"
  }
}

///|
#cfg(target="js")
fn floating_normalize_align(align : String) -> String {
  match align {
    "start" | "center" | "end" => align
    _ => "center"
  }
}

///|
#cfg(target="js")
fn floating_opposite_side(side : String) -> String {
  match side {
    "top" => "bottom"
    "bottom" => "top"
    "left" => "right"
    "right" => "left"
    _ => "top"
  }
}

///|
#cfg(target="js")
fn floating_has_tooltip_arrow(element : @dom.Element) -> Bool {
  element.query_selector("[data-slot=\"tooltip-arrow\"]") is Some(_)
}

///|
#cfg(target="js")
fn floating_set_tooltip_arrow_side(
  element : @dom.Element,
  html : @dom.HTMLElement,
  side : String,
) -> Unit {
  if !floating_has_tooltip_arrow(element) {
    return
  }
  let names = [
    "--rui-tooltip-arrow-top", "--rui-tooltip-arrow-right", "--rui-tooltip-arrow-bottom",
    "--rui-tooltip-arrow-left", "--rui-tooltip-arrow-margin-top", "--rui-tooltip-arrow-margin-left",
  ]
  let values = match side {
    "right" => ["50%", "auto", "auto", "-0.25rem", "-0.3125rem", "0"]
    "bottom" => ["-0.25rem", "auto", "auto", "50%", "0", "-0.3125rem"]
    "left" => ["50%", "-0.25rem", "auto", "auto", "-0.3125rem", "0"]
    _ => ["auto", "auto", "-0.25rem", "50%", "0", "-0.3125rem"]
  }
  let style = html.get_style()
  for index, name in names {
    if style.get_property_value(name) != values[index] {
      style.set_property(name, values[index])
    }
  }
}

///|
#cfg(target="js")
fn floating_infer_tooltip_side(
  popup : @dom.Element,
  reference : @dom.Element,
) -> String {
  let anchor = reference.get_bounding_client_rect()
  let floating = popup.get_bounding_client_rect()
  if floating.get_bottom() <= anchor.get_top() + 1.0 {
    "top"
  } else if floating.get_top() >= anchor.get_bottom() - 1.0 {
    "bottom"
  } else if floating.get_right() <= anchor.get_left() + 1.0 {
    "left"
  } else if floating.get_left() >= anchor.get_right() - 1.0 {
    "right"
  } else {
    let dx = (
        floating.get_left() +
        floating.get_right() -
        anchor.get_left() -
        anchor.get_right()
      ) /
      2.0
    let dy = (
        floating.get_top() +
        floating.get_bottom() -
        anchor.get_top() -
        anchor.get_bottom()
      ) /
      2.0
    if dx.abs() > dy.abs() {
      if dx < 0.0 {
        "left"
      } else {
        "right"
      }
    } else if dy < 0.0 {
      "top"
    } else {
      "bottom"
    }
  }
}

///|
#cfg(target="js")
fn floating_positioning_stop(binding : FloatingPositioningBinding) -> Unit {
  if !binding.observing.val {
    return
  }
  binding.observing.val = false
  if binding.frame.val is Some(frame) && ui_has_window() {
    @dom.window().cancel_animation_frame(frame)
  }
  binding.frame.val = None
  if binding.listener.val is Some(listener) && ui_has_window() {
    let window = @dom.window()
    window.remove_event_listener_with_options("scroll", listener, capture=true)
    window.remove_event_listener("resize", listener)
    if window.get_visual_viewport() is Some(viewport) {
      viewport.remove_event_listener("scroll", listener)
      viewport.remove_event_listener("resize", listener)
    }
  }
  binding.listener.val = None
  if binding.resize_observer.val is Some(observer) {
    observer.disconnect()
  }
  binding.resize_observer.val = None
  if binding.mutation_observer.val is Some(observer) {
    observer.disconnect()
  }
  binding.mutation_observer.val = None
  if binding.intersection_observer.val is Some(observer) {
    observer.disconnect()
  }
  binding.intersection_observer.val = None
  binding.element.remove_attribute("data-positioned")
  binding.element.remove_attribute("data-anchor-hidden")
}

///|
#cfg(target="js")
fn floating_sync_css_arrow(binding : FloatingPositioningBinding) -> Unit {
  if !binding.observing.val || !binding.element.get_is_connected() {
    floating_positioning_stop(binding)
    return
  }
  guard ui_element_by_id(
      binding.element.get_attribute("data-trigger-id").unwrap_or(""),
    )
    is Some(reference) &&
    reference.get_is_connected() else {
    return
  }
  let side = floating_infer_tooltip_side(binding.element, reference)
  if binding.element.get_attribute("data-side").unwrap_or("") != side {
    binding.element.set_attribute("data-side", side)
  }
  floating_set_tooltip_arrow_side(binding.element, binding.html, side)
}

///|
#cfg(target="js")
fn floating_coordinates(
  side : String,
  align : String,
  anchor : @dom.DOMRect,
  floating_width : Double,
  floating_height : Double,
  side_offset : Double,
  align_offset : Double,
  rtl : Bool,
) -> FloatingCoordinates {
  let mut left = anchor.get_left()
  let mut top = anchor.get_bottom() + side_offset
  if side == "top" {
    top = anchor.get_top() - floating_height - side_offset
  } else if side == "left" {
    left = anchor.get_left() - floating_width - side_offset
  } else if side == "right" {
    left = anchor.get_right() + side_offset
  }
  if side == "top" || side == "bottom" {
    let start = if rtl {
      anchor.get_right() - floating_width
    } else {
      anchor.get_left()
    }
    let end = if rtl {
      anchor.get_left()
    } else {
      anchor.get_right() - floating_width
    }
    if align == "start" {
      left = start + align_offset
    } else if align == "center" {
      left = anchor.get_left() +
        (anchor.get_width() - floating_width) / 2.0 +
        align_offset
    } else {
      left = end + align_offset
    }
  } else if align == "start" {
    top = anchor.get_top() + align_offset
  } else if align == "center" {
    top = anchor.get_top() +
      (anchor.get_height() - floating_height) / 2.0 +
      align_offset
  } else {
    top = anchor.get_bottom() - floating_height + align_offset
  }
  { side, left, top }
}

///|
#cfg(target="js")
fn floating_overflow_total(
  candidate : FloatingCoordinates,
  floating_width : Double,
  floating_height : Double,
  clip_left : Double,
  clip_top : Double,
  clip_right : Double,
  clip_bottom : Double,
) -> Double {
  (clip_left - candidate.left).max(0.0) +
  (clip_top - candidate.top).max(0.0) +
  (candidate.left + floating_width - clip_right).max(0.0) +
  (candidate.top + floating_height - clip_bottom).max(0.0)
}

///|
#cfg(target="js")
fn floating_position_fallback(binding : FloatingPositioningBinding) -> Unit {
  if !binding.element.get_is_connected() {
    floating_positioning_stop(binding)
    return
  }
  guard ui_element_by_id(
      binding.element.get_attribute("data-trigger-id").unwrap_or(""),
    )
    is Some(trigger) &&
    trigger.get_is_connected() else {
    return
  }
  let anchor = trigger.get_bounding_client_rect()
  let measured = binding.element.get_bounding_client_rect()
  let offset_width = binding.html.get_offset_width()
  let offset_height = binding.html.get_offset_height()
  let floating_width = if offset_width > 0.0 {
    offset_width
  } else {
    measured.get_width()
  }
  let floating_height = if offset_height > 0.0 {
    offset_height
  } else {
    measured.get_height()
  }
  let side = floating_normalize_side(
    match binding.element.get_attribute("data-requested-side").unwrap_or("") {
      "" => binding.element.get_attribute("data-side").unwrap_or("")
      value => value
    },
  )
  let align = floating_normalize_align(
    match binding.element.get_attribute("data-requested-align").unwrap_or("") {
      "" => binding.element.get_attribute("data-align").unwrap_or("")
      value => value
    },
  )
  let side_offset = ui_parse_double_or(
    binding.element.get_attribute("data-side-offset").unwrap_or(""),
    0.0,
  )
  let align_offset = ui_parse_double_or(
    binding.element.get_attribute("data-align-offset").unwrap_or(""),
    0.0,
  )
  let (viewport_left, viewport_top, viewport_width, viewport_height) = if ui_has_window() &&
    @dom.window().get_visual_viewport() is Some(viewport) {
    (
      viewport.get_offset_left(),
      viewport.get_offset_top(),
      viewport.get_width(),
      viewport.get_height(),
    )
  } else if @dom.document().get_document_element() is Some(root) {
    (0.0, 0.0, root.get_client_width(), root.get_client_height())
  } else {
    (0.0, 0.0, 0.0, 0.0)
  }
  let padding = ui_parse_double_or(
    binding.element.get_attribute("data-collision-padding").unwrap_or(""),
    0.0,
  ).max(0.0)
  let clip_left = viewport_left + padding
  let clip_top = viewport_top + padding
  let clip_right = viewport_left + viewport_width - padding
  let clip_bottom = viewport_top + viewport_height - padding
  let rtl = ui_element_is_rtl(trigger)
  let preferred = floating_coordinates(
    side, align, anchor, floating_width, floating_height, side_offset, align_offset,
    rtl,
  )
  let opposite = floating_coordinates(
    floating_opposite_side(side),
    align,
    anchor,
    floating_width,
    floating_height,
    side_offset,
    align_offset,
    rtl,
  )
  let preferred_overflow = floating_overflow_total(
    preferred, floating_width, floating_height, clip_left, clip_top, clip_right,
    clip_bottom,
  )
  let opposite_overflow = floating_overflow_total(
    opposite, floating_width, floating_height, clip_left, clip_top, clip_right, clip_bottom,
  )
  let placed = if preferred_overflow <= 0.0 {
    preferred
  } else if opposite_overflow <= 0.0 || opposite_overflow < preferred_overflow {
    opposite
  } else {
    preferred
  }
  let mut left = placed.left
  let mut top = placed.top
  let sticky = match
    binding.element.get_attribute("data-sticky").unwrap_or("") {
    "" => "partial"
    value => value
  }
  if placed.side == "top" || placed.side == "bottom" {
    left = left.max(clip_left).min((clip_right - floating_width).max(clip_left))
    if sticky == "partial" {
      left = left
        .max(anchor.get_left() - floating_width)
        .min(anchor.get_right())
    }
  } else {
    top = top.max(clip_top).min((clip_bottom - floating_height).max(clip_top))
    if sticky == "partial" {
      top = top.max(anchor.get_top() - floating_height).min(anchor.get_bottom())
    }
  }
  let anchor_hidden = anchor.get_right() <= viewport_left ||
    anchor.get_left() >= viewport_left + viewport_width ||
    anchor.get_bottom() <= viewport_top ||
    anchor.get_top() >= viewport_top + viewport_height
  binding.element.set_attribute("data-side", placed.side)
  binding.element.set_attribute("data-align", align)
  floating_set_tooltip_arrow_side(binding.element, binding.html, placed.side)
  if anchor_hidden {
    binding.element.set_attribute("data-anchor-hidden", "")
  } else {
    binding.element.remove_attribute("data-anchor-hidden")
  }
  let style = binding.html.get_style()
  style.set_property("--rui-floating-left", "\{left.round().to_int()}px")
  style.set_property("--rui-floating-top", "\{top.round().to_int()}px")
  style.set_property(
    "--rui-floating-anchor-width",
    "\{anchor.get_width().round().to_int()}px",
  )
  style.set_property(
    "--rui-floating-anchor-height",
    "\{anchor.get_height().round().to_int()}px",
  )
  style.set_property(
    "--rui-floating-available-width",
    "\{(clip_right - clip_left).max(0.0).round().to_int()}px",
  )
  style.set_property(
    "--rui-floating-available-height",
    "\{(clip_bottom - clip_top).max(0.0).round().to_int()}px",
  )
  let origin_align = match align {
    "start" => "0%"
    "end" => "100%"
    _ => "50%"
  }
  let origin = match placed.side {
    "bottom" => origin_align + " 0%"
    "top" => origin_align + " 100%"
    "right" => "0% " + origin_align
    _ => "100% " + origin_align
  }
  style.set_property("--rui-floating-transform-origin", origin)
  binding.element.set_attribute("data-positioned", "true")
}

///|
#cfg(target="js")
fn floating_positioning_run(binding : FloatingPositioningBinding) -> Unit {
  if binding.mode == "css-arrow" {
    floating_sync_css_arrow(binding)
  } else {
    floating_position_fallback(binding)
  }
}

///|
#cfg(target="js")
fn floating_positioning_schedule(binding : FloatingPositioningBinding) -> Unit {
  if binding.frame.val is Some(_) {
    return
  }
  if ui_has_window() {
    binding.frame.val = Some(
      @dom.window().request_animation_frame(_ => {
        binding.frame.val = None
        floating_positioning_run(binding)
      }),
    )
  } else {
    floating_positioning_run(binding)
  }
}

///|
#cfg(target="js")
fn floating_positioning_start(binding : FloatingPositioningBinding) -> Unit {
  if binding.observing.val {
    return
  }
  binding.observing.val = true
  let listener : @dom.Listener = _ => floating_positioning_schedule(binding)
  binding.listener.val = Some(listener)
  if ui_has_window() {
    let window = @dom.window()
    window.add_event_listener_with_options(
      "scroll",
      listener,
      capture=true,
      passive=true,
    )
    window.add_event_listener_with_options("resize", listener, passive=true)
    if window.get_visual_viewport() is Some(viewport) {
      viewport.add_event_listener_with_options("scroll", listener, passive=true)
      viewport.add_event_listener_with_options("resize", listener, passive=true)
    }
  }
  let trigger = ui_element_by_id(
    binding.element.get_attribute("data-trigger-id").unwrap_or(""),
  )
  let resize_observer = @dom.ResizeObserver::new((_entries, _observer) => {
    floating_positioning_schedule(binding)
  })
  if trigger is Some(element) {
    resize_observer.observe(element)
  }
  resize_observer.observe(binding.element)
  binding.resize_observer.val = Some(resize_observer)
  if binding.mode == "css-arrow" {
    let mutation_observer = @dom.MutationObserver::new((_records, _observer) => {
      floating_positioning_schedule(binding)
    })
    mutation_observer.observe(
      binding.element.as_node(),
      attributes=true,
      child_list=true,
      attribute_filter=["style", "data-requested-side"],
    )
    binding.mutation_observer.val = Some(mutation_observer)
  } else {
    let intersection_observer = @dom.IntersectionObserver::new(
      (_entries, _observer) => floating_positioning_schedule(binding),
      threshold=[0.0, 1.0],
    )
    if trigger is Some(element) {
      intersection_observer.observe(element)
    }
    binding.intersection_observer.val = Some(intersection_observer)
    let mutation_observer = @dom.MutationObserver::new((records, _observer) => {
      let mut input_changed = false
      for record in records {
        if record.get_attribute_name() is Some(name) && name != "style" {
          input_changed = true
        }
      }
      let style = binding.html.get_style()
      let coordinates_reset = style.get_property_value("--rui-floating-left") ==
        "" ||
        style.get_property_value("--rui-floating-top") == ""
      if input_changed || coordinates_reset {
        floating_position_fallback(binding)
      }
    })
    mutation_observer.observe(binding.element.as_node(), attributes=true, attribute_filter=[
      "style", "data-requested-side", "data-requested-align", "data-side-offset",
      "data-align-offset",
    ])
    binding.mutation_observer.val = Some(mutation_observer)
  }
}

///|
#cfg(target="js")
fn floating_new_positioning(
  element : @dom.Element,
  html : @dom.HTMLElement,
  mode : String,
) -> FloatingPositioningBinding {
  {
    element,
    html,
    mode,
    frame: Ref(None),
    observing: Ref(false),
    listener: Ref(None),
    resize_observer: Ref(None),
    mutation_observer: Ref(None),
    intersection_observer: Ref(None),
  }
}

///|
#cfg(target="js")
fn floating_use_positioning(
  id : String,
  element : @dom.Element,
  html : @dom.HTMLElement,
  mode : String,
) -> FloatingPositioningBinding {
  if floating_positionings.get(id) is Some(current) &&
    floating_same_element(current.element, element) &&
    current.mode == mode {
    return current
  }
  if floating_positionings.get(id) is Some(current) {
    floating_positioning_stop(current)
  }
  let binding = floating_new_positioning(element, html, mode)
  floating_positionings[id] = binding
  floating_set_stop_positioning(id, () => floating_positioning_stop(binding))
  binding
}

///|
#cfg(target="js")
fn position_floating(id : String) -> Unit {
  guard ui_has_document() else { return }
  guard ui_element_by_id(id) is Some(element) && element.get_is_connected() else {
    return
  }
  guard element.to_html_element() is Some(html) else { return }
  let trigger = ui_element_by_id(
    element.get_attribute("data-trigger-id").unwrap_or(""),
  )
  let style = html.get_style()
  let position_area = style.get_property_value("position-area")
  let position_fallbacks = style.get_property_value("position-try-fallbacks")
  let css_anchored = trigger is Some(_) &&
    @dom.CSS::supports("anchor-name", "--rui-anchor") &&
    @dom.CSS::supports("position-anchor", "--rui-anchor") &&
    @dom.CSS::supports("position-area", position_area) &&
    @dom.CSS::supports("position-try-fallbacks", position_fallbacks)
  if css_anchored {
    if floating_positionings.get(id) is Some(current) {
      floating_positioning_stop(current)
      ignore(floating_positionings.remove(id))
      ignore(floating_stop_positioning.remove(id))
    }
    ignore(style.remove_property("--rui-floating-left"))
    ignore(style.remove_property("--rui-floating-top"))
    ignore(style.remove_property("--rui-floating-anchor-width"))
    ignore(style.remove_property("--rui-floating-anchor-height"))
    ignore(style.remove_property("--rui-floating-available-width"))
    ignore(style.remove_property("--rui-floating-available-height"))
    element.set_attribute("data-positioning", "css-anchor")
    element.set_attribute("data-positioned", "true")
    element.remove_attribute("data-anchor-hidden")
    if floating_has_tooltip_arrow(element) {
      let binding = floating_use_positioning(id, element, html, "css-arrow")
      floating_positioning_start(binding)
      floating_sync_css_arrow(binding)
    }
  } else {
    element.set_attribute("data-positioning", "javascript-fallback")
    let binding = floating_use_positioning(id, element, html, "fallback")
    floating_positioning_start(binding)
    // AfterRender already runs inside Rabbita's frame flush. Measuring and
    // writing here keeps the first visible frame anchored to its trigger.
    floating_position_fallback(binding)
  }
}

///|
#cfg(target="js")
fn floating_bind_sync_cmd(id : String, sync : @cmd.Emit[Bool]) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, scheduler => {
    ui_after_mount(
      id,
      () => bind_floating_sync(id, open => scheduler.add(sync(open))),
      purpose="floating-sync-bind",
    )
  })
}

///|
#cfg(target="js")
fn floating_set_open_when_ready(id : String, open : Bool) -> Unit {
  ui_after_ready("floating-set-open:" + id, () => {
    let ready = set_floating_open(id, open)
    if ready && open {
      position_floating(id)
    }
    ready
  })
}

///|
#cfg(target="js")
fn floating_set_open_cmd(id : String, open : Bool) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, _ => floating_set_open_when_ready(id, open))
}

///|
#cfg(not(target="js"))
fn floating_set_open_cmd(id : String, open : Bool) -> @cmd.Cmd {
  ignore((id, open))
  @cmd.none
}

///|
#cfg(target="js")
fn floating_toggle_cmd(id : String) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, _ => {
    toggle_floating(id)
    position_floating(id)
  })
}

///|
#cfg(not(target="js"))
fn floating_toggle_cmd(id : String) -> @cmd.Cmd {
  ignore(id)
  @cmd.none
}

///|
/// Imperatively open a mounted popover. Its incremental component synchronizes
/// through the native `toggle` event.
pub fn popover_open(id : String) -> @cmd.Cmd {
  floating_set_open_cmd(id, true)
}

///|
pub fn popover_close(id : String) -> @cmd.Cmd {
  floating_set_open_cmd(id, false)
}

///|
pub fn popover_toggle(id : String) -> @cmd.Cmd {
  floating_toggle_cmd(id)
}

///|
/// Render a measurable custom anchor for controlled popover composition.
///
/// Pass this element's `id` as `popover_content(trigger_id=...)`. The anchor
/// may wrap any trigger or visual target; positioning then uses the anchor's
/// bounding box instead of requiring the trigger itself to be the reference.
pub fn[C : @html.IsChildren] popover_anchor(
  id~ : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.span(
    style=ui_styles(
      [UiBoxSizing, PopoverAnchorStyle, popup_anchor_style(id)],
      style,
    ),
    id~,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "popover-anchor"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] popover_trigger(
  target_id~ : String,
  open? : Bool = false,
  disabled? : Bool = false,
  variant? : ButtonVariant = Outline,
  size? : ButtonSize = Default,
  on_click? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let resolved_id = id.unwrap_or(target_id + "-trigger")
  let element_attrs = popup_state_attrs(attrs, "popover-trigger", open)
    .data_set("variant", button_variant_value(variant))
    .data_set("size", button_size_value(size))
    .aria_haspopup("dialog")
    .aria_expanded(ui_bool(open))
    .aria_controls(target_id)
  if disabled {
    ignore(element_attrs.aria_disabled("true").data_set("disabled", ""))
  }
  if !disabled && on_click is Some(command) {
    ignore(element_attrs.on_click(_ => command))
  }
  @html.button(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        ButtonBaseStyle,
        button_variant_style(variant),
        button_size_style(size),
        ui_disabled_style(disabled),
        popup_anchor_style(resolved_id),
      ],
      style,
    ),
    id=resolved_id,
    class?,
    title?,
    type_="button",
    disabled~,
    attrs=element_attrs,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] popover_content(
  id~ : String,
  trigger_id~ : String,
  open? : Bool = false,
  modal? : Bool = false,
  initial_focus? : Bool = true,
  initial_focus_id? : String,
  restore_focus? : Bool = true,
  final_focus_id? : String,
  side? : PopupSide = Bottom,
  align? : PopupAlign = Center,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  title_id? : String,
  description_id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = popup_state_attrs(attrs, "popover-content", open)
    .role("dialog")
    .tabindex(-1)
    .data_set("modal", ui_bool(modal))
    .data_set("initial-focus", ui_bool(initial_focus))
    .data_set("restore-focus", ui_bool(restore_focus))
    .data_set("trigger-id", trigger_id)
    .data_set("requested-side", popup_side_value(side))
    .data_set("requested-align", popup_align_value(align))
    .data_set("side", popup_side_value(side))
    .data_set("align", popup_align_value(align))
    .data_set("side-offset", "\{side_offset}")
    .data_set("align-offset", "\{align_offset}")
    .data_set("collision-padding", "0")
    .data_set("sticky", "partial")
  if modal {
    ignore(element_attrs.aria_modal("true"))
  } else {
    ignore(element_attrs.popover("auto"))
  }
  if initial_focus_id is Some(initial_focus_id) {
    ignore(element_attrs.data_set("initial-focus-id", initial_focus_id))
  }
  if final_focus_id is Some(final_focus_id) {
    ignore(element_attrs.data_set("final-focus-id", final_focus_id))
  }
  if title_id is Some(title_id) {
    ignore(element_attrs.aria_labelledby(title_id))
  }
  if description_id is Some(description_id) {
    ignore(element_attrs.aria_describedby(description_id))
  }
  let content_style = ui_styles(
    [
      UiBoxSizing,
      UiFontSans,
      UiTextRendering,
      PopoverContentStyle,
      PopupTransition100Style,
      popup_floating_anchor_style(
        trigger_id, side, align, side_offset, align_offset,
      ),
      popup_state_style(open),
    ],
    style,
  )
  if modal {
    let native_open = floating_dialog_open(open)
    @html.dialog(
      style=content_style,
      id~,
      class?,
      title?,
      open?=native_open,
      closedby="any",
      attrs=element_attrs,
      children,
    )
  } else {
    @html.div(
      style=content_style,
      id~,
      class?,
      title?,
      attrs=element_attrs,
      children,
    )
  }
}

///|
pub fn[C : @html.IsChildren] popover_header(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, PopoverHeaderStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "popover-header"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] popover_title(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.h2(
    style=ui_styles([UiBoxSizing, PopoverTitleStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "popover-title"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] popover_description(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.p(
    style=ui_styles([UiBoxSizing, PopoverDescriptionStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "popover-description"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] popover_close_button(
  target_id~ : String,
  disabled? : Bool = false,
  variant? : ButtonVariant = Ghost,
  size? : ButtonSize = Sm,
  aria_label? : String = "Close",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "popover-close")
    .data_set("variant", button_variant_value(variant))
    .data_set("size", button_size_value(size))
  ignore(element_attrs.aria_label(aria_label))
  if disabled {
    ignore(element_attrs.aria_disabled("true").data_set("disabled", ""))
  }
  if !disabled {
    ignore(element_attrs.on_click(_ => popover_close(target_id)))
  }
  @html.button(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        ButtonBaseStyle,
        button_variant_style(variant),
        button_size_style(size),
        ui_disabled_style(disabled),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    type_="button",
    disabled~,
    attrs=element_attrs,
    children,
  )
}

///|
#cfg(target="js")
priv enum PopoverMsg {
  PopoverToggleRequested
  PopoverNativeChanged(Bool)
}

///|
#cfg(target="js")
fn popover_notify_cmd(
  on_open_change : @cmd.Emit[Bool]?,
  open : Bool,
) -> @cmd.Cmd {
  if on_open_change is Some(notify) {
    notify(open)
  } else {
    @cmd.none
  }
}

///|
fn[T : @html.IsChildren, C : @html.IsChildren] render_popover(
  id : String,
  open : Bool,
  disabled : Bool,
  modal : Bool,
  initial_focus : Bool,
  initial_focus_id : String?,
  restore_focus : Bool,
  final_focus_id : String?,
  side : PopupSide,
  align : PopupAlign,
  side_offset : Int,
  align_offset : Int,
  trigger_variant : ButtonVariant,
  trigger_size : ButtonSize,
  title_id : String?,
  description_id : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  trigger_attrs : @html.Attrs?,
  trigger_style : Array[String],
  content_attrs : @html.Attrs?,
  content_style : Array[String],
  on_trigger_click : @cmd.Cmd?,
  trigger : T,
  content : C,
) -> @html.Html {
  let trigger_id = id + "-trigger"
  let root_attrs = popup_state_attrs(attrs, "popover", open)
  let on_click = on_trigger_click
  let attrs = trigger_attrs
  let popup_attrs = content_attrs
  @html.span(
    style=ui_styles([UiBoxSizing, PopoverRootStyle], style),
    attrs=root_attrs,
    [
      popover_trigger(
        target_id=id,
        open~,
        disabled~,
        variant=trigger_variant,
        size=trigger_size,
        on_click?,
        id=trigger_id,
        attrs?,
        style=trigger_style,
        trigger,
      ),
      popover_content(
        id~,
        trigger_id~,
        open~,
        modal~,
        initial_focus~,
        initial_focus_id?,
        restore_focus~,
        final_focus_id?,
        side~,
        align~,
        side_offset~,
        align_offset~,
        title_id?,
        description_id?,
        attrs?=popup_attrs,
        style=content_style,
        content,
      ),
    ],
  )
}

///|
/// Build a stateful Rabbita popover backed by native browser primitives.
///
/// The default non-modal mode uses the HTML Popover API for light-dismiss and
/// Escape. `modal=true` uses `<dialog>` for inert background and Tab
/// containment. Initial and final focus IDs configure focus entry and
/// restoration. `id` is also used by `popover_open`, `popover_close`, and
/// `popover_toggle`.
#cfg(target="js")
pub fn[T : @html.IsChildren, C : @html.IsChildren] popover(
  id~ : String,
  default_open? : Bool = false,
  disabled? : Bool = false,
  modal? : Bool = false,
  initial_focus? : Bool = true,
  initial_focus_id? : String,
  restore_focus? : Bool = true,
  final_focus_id? : String,
  side? : PopupSide = Bottom,
  align? : PopupAlign = Center,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  trigger_variant? : ButtonVariant = Outline,
  trigger_size? : ButtonSize = Default,
  title_id? : String,
  description_id? : String,
  on_open_change? : @cmd.Emit[Bool],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  trigger_attrs? : @html.Attrs,
  trigger_style? : Array[String] = [],
  content_attrs? : @html.Attrs,
  content_style? : Array[String] = [],
  trigger : T,
  content : C,
) -> @rabbita.Val[@html.Html] {
  let initial_open = default_open && !disabled
  let (open, emit) = @rabbita.create_state_with_init(
    init=emit => {
      let sync = emit.map(value => PopoverNativeChanged(value))
      (
        initial_open,
        @cmd.batch([
          floating_bind_sync_cmd(id, sync),
          if initial_open {
            floating_set_open_cmd(id, true)
          } else {
            @cmd.none
          },
        ]),
      )
    },
    update=(current, msg, _) => {
      match msg {
        PopoverToggleRequested =>
          if disabled {
            (current, @cmd.none)
          } else {
            let next = !current
            (
              next,
              @cmd.batch([
                floating_set_open_cmd(id, next),
                popover_notify_cmd(on_open_change, next),
              ]),
            )
          }
        PopoverNativeChanged(next) =>
          if next == current {
            (current, @cmd.none)
          } else {
            (next, popover_notify_cmd(on_open_change, next))
          }
      }
    },
  )
  open.view(open => {
    render_popover(
      id,
      open,
      disabled,
      modal,
      initial_focus,
      initial_focus_id,
      restore_focus,
      final_focus_id,
      side,
      align,
      side_offset,
      align_offset,
      trigger_variant,
      trigger_size,
      title_id,
      description_id,
      attrs,
      style,
      trigger_attrs,
      trigger_style,
      content_attrs,
      content_style,
      Some(emit(PopoverToggleRequested)),
      trigger,
      content,
    )
  })
}

///|
/// Native/SSR fallback: renders the initial state as a constant incremental
/// value. Browser interaction is available on the JavaScript target.
#cfg(not(target="js"))
pub fn[T : @html.IsChildren, C : @html.IsChildren] popover(
  id~ : String,
  default_open? : Bool = false,
  disabled? : Bool = false,
  modal? : Bool = false,
  initial_focus? : Bool = true,
  initial_focus_id? : String,
  restore_focus? : Bool = true,
  final_focus_id? : String,
  side? : PopupSide = Bottom,
  align? : PopupAlign = Center,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  trigger_variant? : ButtonVariant = Outline,
  trigger_size? : ButtonSize = Default,
  title_id? : String,
  description_id? : String,
  on_open_change? : @cmd.Emit[Bool],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  trigger_attrs? : @html.Attrs,
  trigger_style? : Array[String] = [],
  content_attrs? : @html.Attrs,
  content_style? : Array[String] = [],
  trigger : T,
  content : C,
) -> @rabbita.Val[@html.Html] {
  ignore(on_open_change)
  @rabbita.Val::constant(
    render_popover(
      id,
      default_open && !disabled,
      disabled,
      modal,
      initial_focus,
      initial_focus_id,
      restore_focus,
      final_focus_id,
      side,
      align,
      side_offset,
      align_offset,
      trigger_variant,
      trigger_size,
      title_id,
      description_id,
      attrs,
      style,
      trigger_attrs,
      trigger_style,
      content_attrs,
      content_style,
      None,
      trigger,
      content,
    ),
  )
}
