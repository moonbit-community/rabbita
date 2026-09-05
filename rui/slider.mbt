///|
priv enum SliderMsg {
  SetSliderValue(Int, Int)
  SetSliderKeyboardValue(Int, Int)
  CommitSliderValue(Int, Int)
}

///|
const SliderThumbStyle : String = "position:absolute;z-index:2;display:block;width:1rem;height:1rem;border:1px solid var(--rui-primary,oklch(0.205 0 0));border-radius:9999px;background:var(--rui-slider-thumb,var(--rui-background,oklch(1 0 0)));--rui-slider-thumb-base-shadow:0 1px 2px rgb(0 0 0 / 0.1);box-shadow:var(--rui-slider-thumb-shadow,var(--rui-slider-thumb-base-shadow,0 1px 2px rgb(0 0 0 / 0.1)));pointer-events:none"

///|
fn slider_parse(value : String, fallback : Int) -> Int {
  @string.parse_int(value) catch {
    _ => fallback
  }
}

///|
fn slider_clamp(value : Int, min : Int, max : Int) -> Int {
  if value < min {
    min
  } else if value > max {
    max
  } else {
    value
  }
}

///|
fn slider_step_amount(step : Int) -> Int {
  if step > 0 {
    step
  } else {
    1
  }
}

///|
fn slider_align_to_step(value : Int, min : Int, max : Int, step : Int) -> Int {
  let value = slider_clamp(value, min, max)
  let amount = slider_step_amount(step)
  let offset = value - min
  let aligned = min + (offset + amount / 2) / amount * amount
  slider_clamp(aligned, min, max)
}

///|
fn slider_percent(value : Int, min : Int, max : Int) -> Int {
  if max <= min {
    0
  } else {
    (slider_clamp(value, min, max) - min) * 100 / (max - min)
  }
}

///|
fn slider_minimum_gap(
  count : Int,
  min : Int,
  max : Int,
  step : Int,
  min_steps_between_values : Int,
) -> Int {
  if count <= 1 || min_steps_between_values <= 0 || max <= min {
    0
  } else {
    let amount = slider_step_amount(step)
    let available_steps = (max - min) / amount
    let possible_steps = available_steps / (count - 1)
    slider_clamp(min_steps_between_values, 0, possible_steps) * amount
  }
}

///|
fn slider_normalize_values(
  values : Array[Int],
  min : Int,
  max : Int,
  step : Int,
  min_steps_between_values : Int,
) -> Array[Int] {
  let requested = if values.length() == 0 { [min] } else { values }
  let normalized = requested.map(value => {
    slider_align_to_step(value, min, max, step)
  })
  normalized.sort()
  let count = normalized.length()
  if count > 1 {
    let gap = slider_minimum_gap(
      count, min, max, step, min_steps_between_values,
    )
    for index in 0..<count {
      let lower = if index == 0 { min } else { normalized[index - 1] + gap }
      let upper = max - (count - index - 1) * gap
      normalized[index] = slider_clamp(normalized[index], lower, upper)
    }
  }
  normalized
}

///|
fn slider_set_thumb_value(
  values : Array[Int],
  index : Int,
  value : Int,
  min : Int,
  max : Int,
  step : Int,
  min_steps_between_values : Int,
) -> Array[Int] {
  slider_constrain_thumb_value(
    values,
    index,
    slider_align_to_step(value, min, max, step),
    min,
    max,
    step,
    min_steps_between_values,
  )
}

///|
fn slider_constrain_thumb_value(
  values : Array[Int],
  index : Int,
  value : Int,
  min : Int,
  max : Int,
  step : Int,
  min_steps_between_values : Int,
) -> Array[Int] {
  let next = values.copy()
  if index < 0 || index >= next.length() {
    return next
  }
  let gap = slider_minimum_gap(
    next.length(),
    min,
    max,
    step,
    min_steps_between_values,
  )
  let lower = if index == 0 { min } else { next[index - 1] + gap }
  let upper = if index + 1 >= next.length() {
    max
  } else {
    next[index + 1] - gap
  }
  next[index] = slider_clamp(value, lower, upper)
  next
}

///|
fn slider_round_to_step(value : Int, min : Int, step : Int) -> Int {
  let amount = slider_step_amount(step)
  let offset = value - min
  min + (offset + amount / 2) / amount * amount
}

///|
fn slider_key_value(
  value : Int,
  min : Int,
  max : Int,
  step : Int,
  large_step : Int,
  shift : Bool,
  rtl : Bool,
  key : String,
) -> Int? {
  let amount = if shift { large_step } else { slider_step_amount(step) }
  let rounded = slider_round_to_step(value, min, step)
  let requested = match key {
    "Home" => Some(min)
    "End" => Some(max)
    "ArrowUp" => Some(rounded + amount)
    "ArrowRight" => Some(rounded + (if rtl { -amount } else { amount }))
    "ArrowDown" => Some(rounded - amount)
    "ArrowLeft" => Some(rounded + (if rtl { amount } else { -amount }))
    "PageUp" => Some(rounded + large_step)
    "PageDown" => Some(rounded - large_step)
    _ => None
  }
  requested.map(next => slider_clamp(next, min, max))
}

///|
fn slider_thumb_key_value(
  values : Array[Int],
  index : Int,
  min : Int,
  max : Int,
  step : Int,
  min_steps_between_values : Int,
  large_step : Int,
  shift : Bool,
  rtl : Bool,
  key : String,
) -> Int? {
  if index < 0 || index >= values.length() {
    return None
  }
  let current = values[index]
  let gap = slider_minimum_gap(
    values.length(),
    min,
    max,
    step,
    min_steps_between_values,
  )
  let lower = if index == 0 { min } else { values[index - 1] }
  let upper = if index + 1 >= values.length() { max } else { values[index + 1] }
  let requested = match key {
    "Home" => Some(if index == 0 { min } else { lower + gap })
    "End" => Some(if index + 1 >= values.length() { max } else { upper - gap })
    _ => slider_key_value(current, min, max, step, large_step, shift, rtl, key)
  }
  match requested {
    Some(requested) => {
      let next = slider_clamp(requested, lower, upper)
      if (index > 0 && next - lower < gap) ||
        (index + 1 < values.length() && upper - next < gap) {
        Some(current)
      } else {
        Some(next)
      }
    }
    None => None
  }
}

///|
#cfg(target="js")
priv struct SliderPointerConfig {
  min : Int
  max : Int
  step : Int
  gap : Int
}

///|
#cfg(target="js")
priv struct SliderPointerBinding {
  root : @dom.Element
  mut active_index : Int
  mut active_pointer_id : Int?
  mut last_used_index : Int
}

///|
#cfg(target="js")
let slider_pointer_bindings : Array[SliderPointerBinding] = []

///|
#cfg(target="js")
fn slider_prune_pointer_bindings() -> Unit {
  let mut index = 0
  while index < slider_pointer_bindings.length() {
    if slider_pointer_bindings[index].root.get_is_connected() {
      index += 1
    } else {
      ignore(slider_pointer_bindings.remove(index))
    }
  }
}

///|
#cfg(target="js")
fn slider_pointer_binding(root : @dom.Element) -> SliderPointerBinding? {
  for binding in slider_pointer_bindings {
    if binding.root.is_same_node(root.as_node()) {
      return Some(binding)
    }
  }
  None
}

///|
#cfg(target="js")
fn slider_pointer_controls(
  binding : SliderPointerBinding,
) -> Array[@dom.HTMLInputElement] {
  let controls : Array[@dom.HTMLInputElement] = []
  for
    element in binding.root.query_selector_all("[data-slot=\"slider-control\"]") {
    if ui_element_is_enabled(element) &&
      element.to_html_input_element() is Some(input) {
      controls.push(input)
    }
  }
  controls
}

///|
#cfg(target="js")
fn slider_pointer_config(
  binding : SliderPointerBinding,
  count : Int,
) -> SliderPointerConfig {
  let min = ui_parse_int_or(
    binding.root.get_attribute("data-min").unwrap_or(""),
    0,
  )
  let max = ui_parse_int_or(
    binding.root.get_attribute("data-max").unwrap_or(""),
    100,
  )
  let step = ui_parse_int_or(
    binding.root.get_attribute("data-step").unwrap_or(""),
    1,
  ).max(1)
  let min_steps = ui_parse_int_or(
    binding.root.get_attribute("data-min-steps-between-values").unwrap_or(""),
    0,
  ).max(0)
  let available_steps = (max - min).max(0) / step
  let possible_steps = if count > 1 { available_steps / (count - 1) } else { 0 }
  let effective_steps = if count > 1 {
    min_steps.min(possible_steps.max(0))
  } else {
    0
  }
  { min, max, step, gap: step * effective_steps, }
}

///|
#cfg(target="js")
fn slider_pointer_value_at(
  binding : SliderPointerBinding,
  pointer : @dom.PointerEvent,
) -> Int? {
  let rect = binding.root.get_bounding_client_rect()
  let vertical = binding.root.get_attribute("data-orientation").unwrap_or("") ==
    "vertical"
  let size = if vertical { rect.get_height() } else { rect.get_width() }
  if size <= 0.0 {
    return None
  }
  let rtl = !vertical &&
    (
      binding.root.get_attribute("data-direction").unwrap_or("") == "rtl" ||
      binding.root.get_attribute("dir").unwrap_or("") == "rtl" ||
      ui_element_is_rtl(binding.root)
    )
  let offset = if vertical {
    rect.get_bottom() - pointer.get_client_y()
  } else if rtl {
    rect.get_right() - pointer.get_client_x()
  } else {
    pointer.get_client_x() - rect.get_left()
  }
  let percent = (offset / size).clamp(min=0.0, max=1.0)
  let config = slider_pointer_config(binding, 1)
  let raw = config.min.to_double() +
    percent * (config.max - config.min).to_double()
  let aligned = config.min +
    ((raw - config.min.to_double()) / config.step.to_double()).round().to_int() *
    config.step
  Some(slider_clamp(aligned, config.min, config.max))
}

///|
#cfg(target="js")
fn slider_pointer_closest_index(
  binding : SliderPointerBinding,
  requested : Int,
  controls : Array[@dom.HTMLInputElement],
) -> Int {
  let mut best = -1
  let mut distance = 0
  for index, input in controls {
    let next_distance = (ui_parse_int_or(input.value(), requested) - requested).abs()
    if best < 0 ||
      next_distance < distance ||
      (
        next_distance == distance &&
        (
          index == binding.last_used_index ||
          (best != binding.last_used_index && index < best)
        )
      ) {
      best = index
      distance = next_distance
    }
  }
  best
}

///|
#cfg(target="js")
fn slider_pointer_activate(
  binding : SliderPointerBinding,
  index : Int,
  controls : Array[@dom.HTMLInputElement],
) -> Bool {
  if index < 0 || index >= controls.length() {
    return false
  }
  binding.active_index = index
  binding.last_used_index = index
  for current, input in controls {
    input
    .get_style()
    .set_property(
      "z-index",
      (if current == index { controls.length() + 4 } else { current + 3 }).to_string(),
    )
  }
  controls[index].focus_with_options(prevent_scroll=true)
  true
}

///|
#cfg(target="js")
fn slider_pointer_update(
  binding : SliderPointerBinding,
  pointer : @dom.PointerEvent,
  commit : Bool,
) -> Unit {
  let controls = slider_pointer_controls(binding)
  let index = binding.active_index
  if index < 0 || index >= controls.length() {
    return
  }
  guard slider_pointer_value_at(binding, pointer) is Some(requested) else {
    return
  }
  let config = slider_pointer_config(binding, controls.length())
  let lower = if index == 0 {
    config.min
  } else {
    ui_parse_int_or(controls[index - 1].value(), config.min) + config.gap
  }
  let upper = if index + 1 >= controls.length() {
    config.max
  } else {
    ui_parse_int_or(controls[index + 1].value(), config.max) - config.gap
  }
  let next = requested.clamp(min=lower, max=upper)
  let input = controls[index]
  if ui_parse_int_or(input.value(), next) != next {
    input.set_value(next.to_string())
    input.dispatch_event(@dom.Event::new("input", bubbles=true))
  }
  if commit {
    input.dispatch_event(@dom.Event::new("change", bubbles=true))
  }
}

///|
#cfg(target="js")
fn slider_pointer_finish(
  binding : SliderPointerBinding,
  pointer : @dom.PointerEvent,
  commit : Bool,
) -> Unit {
  guard binding.active_pointer_id is Some(pointer_id) else { return }
  guard pointer_id == pointer.get_pointer_id() else { return }
  if commit {
    slider_pointer_update(binding, pointer, true)
  }
  if binding.root.has_pointer_capture(pointer_id) {
    binding.root.release_pointer_capture(pointer_id)
  }
  binding.active_index = -1
  binding.active_pointer_id = None
}

///|
#cfg(target="js")
fn slider_bind_pointer_listeners(binding : SliderPointerBinding) -> Unit {
  binding.root.add_event_listener("pointerdown", event => {
    guard event.to_pointer_event() is Some(pointer) else { return }
    if binding.root.get_attribute("data-disabled").unwrap_or("") == "true" ||
      pointer.get_button() != 0 ||
      binding.active_pointer_id is Some(_) {
      return
    }
    guard slider_pointer_value_at(binding, pointer) is Some(requested) else {
      return
    }
    let controls = slider_pointer_controls(binding)
    if controls.length() == 0 {
      return
    }
    let index = slider_pointer_closest_index(binding, requested, controls)
    if !slider_pointer_activate(binding, index, controls) {
      return
    }
    binding.active_pointer_id = Some(pointer.get_pointer_id())
    pointer.prevent_default()
    binding.root.set_pointer_capture(pointer.get_pointer_id())
    slider_pointer_update(binding, pointer, false)
  })
  binding.root.add_event_listener("pointermove", event => {
    guard event.to_pointer_event() is Some(pointer) else { return }
    guard binding.active_pointer_id is Some(pointer_id) else { return }
    if pointer_id != pointer.get_pointer_id() {
      return
    }
    pointer.prevent_default()
    slider_pointer_update(binding, pointer, false)
  })
  binding.root.add_event_listener("pointerup", event => {
    if event.to_pointer_event() is Some(pointer) {
      slider_pointer_finish(binding, pointer, true)
    }
  })
  binding.root.add_event_listener("pointercancel", event => {
    if event.to_pointer_event() is Some(pointer) {
      slider_pointer_finish(binding, pointer, false)
    }
  })
  binding.root.add_event_listener("lostpointercapture", event => {
    guard event.to_pointer_event() is Some(pointer) else { return }
    guard binding.active_pointer_id is Some(pointer_id) else { return }
    if pointer_id == pointer.get_pointer_id() {
      binding.active_index = -1
      binding.active_pointer_id = None
    }
  })
}

///|
#cfg(target="js")
fn bind_slider_pointer(id : String) -> Unit {
  guard ui_element_by_id(id + "-root") is Some(root) else { return }
  slider_prune_pointer_bindings()
  if slider_pointer_binding(root) is Some(_) {
    return
  }
  let binding : SliderPointerBinding = {
    root,
    active_index: -1,
    active_pointer_id: None,
    last_used_index: -1,
  }
  slider_pointer_bindings.push(binding)
  slider_bind_pointer_listeners(binding)
}

///|
#cfg(target="js")
fn slider_bind_pointer_cmd(id : String) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, _ => {
    ui_after_mount(
      id + "-root",
      () => bind_slider_pointer(id),
      purpose="slider-pointer-bind",
    )
  })
}

///|
#cfg(target="js")
fn slider_input_pointer_style() -> String {
  "pointer-events:none"
}

///|
#cfg(not(target="js"))
fn slider_input_pointer_style() -> String {
  ""
}

///|
#cfg(target="js")
fn slider_event_is_rtl(event : @dom.KeyboardEvent) -> Bool {
  let target = match event.current_target().to_option() {
    Some(target) => target
    None => event.target()
  }
  guard target.to_element() is Some(element) else { return false }
  let root = element.closest("[data-slot=\"slider\"]").unwrap_or(element)
  root.get_attribute("data-direction").unwrap_or("") == "rtl" ||
  root.get_attribute("dir").unwrap_or("") == "rtl" ||
  ui_element_is_rtl(root)
}

///|
fn slider_key_stops_propagation(key : String) -> Bool {
  key == "ArrowUp" ||
  key == "ArrowRight" ||
  key == "ArrowDown" ||
  key == "ArrowLeft" ||
  key == "Home" ||
  key == "End"
}

///|
#cfg(target="js")
fn slider_control_attrs(
  input_attrs : @html.Attrs?,
  values : Array[Int],
  index : Int,
  emit : @cmd.Emit[SliderMsg],
  min : Int,
  max : Int,
  step : Int,
  min_steps_between_values : Int,
  large_step : Int,
  orientation : SeparatorOrientation,
  disabled : Bool,
) -> @html.Attrs {
  let value = values[index]
  let attrs = ui_attrs(input_attrs)
    .data_set("slot", "slider-control")
    .data_set("index", index.to_string())
    .aria_orientation(separator_orientation_value(orientation))
  if disabled {
    ignore(attrs.disabled(true))
  } else {
    ignore(
      attrs.on_keydown(event => {
        if event.get_default_prevented() {
          return @cmd.none
        }
        let key = event.key()
        match
          slider_thumb_key_value(
            values,
            index,
            min,
            max,
            step,
            min_steps_between_values,
            large_step,
            event.shift_key(),
            slider_event_is_rtl(event),
            key,
          ) {
          Some(next) => {
            if slider_key_stops_propagation(key) {
              event.stop_propagation()
            }
            event.prevent_default()
            if next == value {
              @cmd.none
            } else {
              emit(SetSliderKeyboardValue(index, next))
            }
          }
          None => @cmd.none
        }
      }),
    )
  }
  attrs
}

///|
#cfg(not(target="js"))
fn slider_control_attrs(
  input_attrs : @html.Attrs?,
  values : Array[Int],
  index : Int,
  emit : @cmd.Emit[SliderMsg],
  min : Int,
  max : Int,
  step : Int,
  min_steps_between_values : Int,
  large_step : Int,
  orientation : SeparatorOrientation,
  disabled : Bool,
) -> @html.Attrs {
  ignore((values, emit, min, max, step, min_steps_between_values, large_step))
  let attrs = ui_attrs(input_attrs)
    .data_set("slot", "slider-control")
    .data_set("index", index.to_string())
    .aria_orientation(separator_orientation_value(orientation))
  if disabled {
    ignore(attrs.disabled(true))
  }
  attrs
}

///|
fn slider_serialized_values(values : Array[Int]) -> String {
  values.map(value => value.to_string()).join(",")
}

///|
fn slider_thumb_label(aria_label : String, index : Int, count : Int) -> String {
  if count <= 1 {
    aria_label
  } else {
    "\{aria_label} \{index + 1}"
  }
}

///|
fn render_slider_values(
  values : Array[Int],
  emit : @cmd.Emit[SliderMsg],
  min : Int,
  max : Int,
  step : Int,
  min_steps_between_values : Int,
  large_step : Int,
  orientation : SeparatorOrientation,
  disabled : Bool,
  aria_label : String,
  id : String,
  legacy_single_id : Bool,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  input_attrs : @html.Attrs?,
  style : Array[String],
) -> @html.Html {
  let count = values.length()
  let orientation_value = separator_orientation_value(orientation)
  let serialized_values = slider_serialized_values(values)
  let first_value = if count == 0 { min } else { values[0] }
  let last_value = if count == 0 { min } else { values[count - 1] }
  let range_start = if count <= 1 { min } else { first_value }
  let start_percent = slider_percent(range_start, min, max)
  let end_percent = slider_percent(last_value, min, max)
  let range_percent = end_percent - start_percent
  let track = @html.div(
    attrs=@html.Attrs::build()
      .data_set("slot", "slider-track")
      .aria_hidden("true"),
    style=[
      "position:absolute;overflow:hidden;border-radius:9999px;background:var(--rui-muted,oklch(0.97 0 0))",
      if orientation is Vertical {
        "left:50%;top:0;width:0.375rem;height:100%;transform:translateX(-50%)"
      } else {
        "inset-inline-start:0;top:50%;width:100%;height:0.375rem;transform:translateY(-50%)"
      },
    ],
    @html.div(
      attrs=@html.Attrs::build()
        .data_set("slot", "slider-range")
        .data_set("start", first_value.to_string())
        .data_set("end", last_value.to_string()),
      style=[
        "position:absolute;background:var(--rui-primary,oklch(0.205 0 0))",
        if orientation is Vertical {
          "left:0;right:0;bottom:\{start_percent}%;height:\{range_percent}%"
        } else {
          "inset-inline-start:\{start_percent}%;top:0;bottom:0;width:\{range_percent}%"
        },
      ],
      "",
    ),
  )
  let children : Array[@html.Html] = [track]
  for index in 0..<count {
    let value = values[index]
    let percent = slider_percent(value, min, max)
    let thumb_id = "\{id}-thumb-\{index}"
    let input_id = if legacy_single_id && count == 1 {
      id
    } else {
      "\{id}-input-\{index}"
    }
    let control_attrs = slider_control_attrs(
      input_attrs, values, index, emit, min, max, step, min_steps_between_values,
      large_step, orientation, disabled,
    )
    children.push(
      @html.span(
        id=thumb_id,
        attrs=@html.Attrs::build()
          .data_set("slot", "slider-thumb")
          .data_set("index", index.to_string())
          .data_set("value", value.to_string())
          .data_set("orientation", orientation_value)
          .data_set("disabled", ui_bool(disabled))
          .aria_hidden("true"),
        style=[
          UiBoxSizing,
          UiTransition,
          SliderThumbStyle,
          if orientation is Vertical {
            "left:50%;bottom:\{percent}%;transform:translate(-50%,50%)"
          } else {
            "top:50%;inset-inline-start:calc(\{percent}% - 0.5rem);transform:translateY(-50%)"
          },
        ],
        "",
      ),
    )
    children.push(
      @html.input(
        input_type=Range,
        value=value.to_string(),
        min~,
        max~,
        step~,
        id=input_id,
        on_input=emit.map(text => {
          SetSliderValue(index, slider_parse(text, value))
        }),
        on_change=emit.map(text => {
          CommitSliderValue(index, slider_parse(text, value))
        }),
        attrs=control_attrs.aria_label(
          slider_thumb_label(aria_label, index, count),
        ),
        style=[
          "position:absolute;inset:0;z-index:\{3 + index};width:100%;height:100%;margin:0;background:transparent;cursor:pointer;appearance:none;-webkit-appearance:none",
          slider_input_pointer_style(),
          if orientation is Vertical {
            "writing-mode:vertical-lr;direction:rtl"
          } else {
            ""
          },
        ],
      ),
    )
  }
  @html.div(
    id="\{id}-root",
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "slider")
      .data_set("orientation", orientation_value)
      .data_set("disabled", ui_bool(disabled))
      .data_set("min", min.to_string())
      .data_set("max", max.to_string())
      .data_set("step", step.to_string())
      .data_set("large-step", large_step.to_string())
      .data_set("value", serialized_values)
      .data_set("values", serialized_values)
      .data_set("thumb-count", count.to_string())
      .data_set(
        "min-steps-between-values",
        min_steps_between_values.to_string(),
      ),
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        "position:relative;display:flex;touch-action:none;align-items:center;user-select:none",
        if orientation is Vertical {
          "width:1rem;height:11rem;min-height:11rem;flex-direction:column"
        } else {
          "width:100%;height:1rem"
        },
        ui_disabled_visual_style(disabled),
      ],
      style,
    ),
    children,
  )
}

///|
fn slider_values_notify(
  notify : @cmd.Emit[Array[Int]]?,
  values : Array[Int],
) -> @cmd.Cmd {
  if notify is Some(notify) {
    notify(values.copy())
  } else {
    @cmd.none
  }
}

///|
#cfg(target="js")
fn slider_values_impl(
  default_values : Array[Int],
  min : Int,
  max : Int,
  step : Int,
  large_step : Int,
  min_steps_between_values : Int,
  orientation : SeparatorOrientation,
  disabled : Bool,
  aria_label : String,
  on_value_change : @cmd.Emit[Array[Int]]?,
  on_value_commit : @cmd.Emit[Array[Int]]?,
  id : String,
  legacy_single_id : Bool,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  input_attrs : @html.Attrs?,
  style : Array[String],
) -> @rabbita.Val[@html.Html] {
  let max = if max < min { min } else { max }
  let step = slider_step_amount(step)
  let large_step = if large_step > 0 { large_step } else { 10 }
  let min_steps_between_values = if min_steps_between_values > 0 {
    min_steps_between_values
  } else {
    0
  }
  let initial = slider_normalize_values(
    default_values, min, max, step, min_steps_between_values,
  )
  let (values, emit) = @rabbita.create_state_with_init(
    init=_ => (initial, slider_bind_pointer_cmd(id)),
    update=fn(current, msg, _) {
      match msg {
        SetSliderValue(index, value) => {
          let next = slider_set_thumb_value(
            current, index, value, min, max, step, min_steps_between_values,
          )
          let command = if next == current {
            @cmd.none
          } else {
            slider_values_notify(on_value_change, next)
          }
          (next, command)
        }
        SetSliderKeyboardValue(index, value) => {
          let next = slider_constrain_thumb_value(
            current, index, value, min, max, step, min_steps_between_values,
          )
          let command = if next == current {
            @cmd.none
          } else {
            @cmd.batch([
              slider_values_notify(on_value_change, next),
              slider_values_notify(on_value_commit, next),
            ])
          }
          (next, command)
        }
        CommitSliderValue(index, value) => {
          let next = slider_set_thumb_value(
            current, index, value, min, max, step, min_steps_between_values,
          )
          (next, slider_values_notify(on_value_commit, next))
        }
      }
    },
  )
  values.view(values => {
    render_slider_values(
      values, emit, min, max, step, min_steps_between_values, large_step, orientation,
      disabled, aria_label, id, legacy_single_id, class, title, attrs, input_attrs,
      style,
    )
  })
}

///|
#cfg(not(target="js"))
fn slider_values_impl(
  default_values : Array[Int],
  min : Int,
  max : Int,
  step : Int,
  large_step : Int,
  min_steps_between_values : Int,
  orientation : SeparatorOrientation,
  disabled : Bool,
  aria_label : String,
  on_value_change : @cmd.Emit[Array[Int]]?,
  on_value_commit : @cmd.Emit[Array[Int]]?,
  id : String,
  legacy_single_id : Bool,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  input_attrs : @html.Attrs?,
  style : Array[String],
) -> @rabbita.Val[@html.Html] {
  ignore((on_value_change, on_value_commit))
  let max = if max < min { min } else { max }
  let step = slider_step_amount(step)
  let large_step = if large_step > 0 { large_step } else { 10 }
  let min_steps_between_values = if min_steps_between_values > 0 {
    min_steps_between_values
  } else {
    0
  }
  let values = slider_normalize_values(
    default_values, min, max, step, min_steps_between_values,
  )
  let emit : @cmd.Emit[SliderMsg] = @cmd.Emit(_ => @cmd.none)
  @rabbita.Val::constant(
    render_slider_values(
      values, emit, min, max, step, min_steps_between_values, large_step, orientation,
      disabled, aria_label, id, legacy_single_id, class, title, attrs, input_attrs,
      style,
    ),
  )
}

///|
/// Stateful multi-thumb slider with sorted, non-crossing values.
///
/// Every thumb is backed by its own native range input. Initial and pointer
/// values align to `step`; keyboard page/shift movement uses the exact
/// `large_step`. Values stay sorted and at least
/// `min_steps_between_values` steps apart.
pub fn slider_values(
  id~ : String,
  default_values~ : Array[Int],
  min? : Int = 0,
  max? : Int = 100,
  step? : Int = 1,
  large_step? : Int = 10,
  min_steps_between_values? : Int = 0,
  orientation? : SeparatorOrientation = Horizontal,
  disabled? : Bool = false,
  aria_label? : String = "Value",
  on_value_change? : @cmd.Emit[Array[Int]],
  on_value_commit? : @cmd.Emit[Array[Int]],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  input_attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @rabbita.Val[@html.Html] {
  slider_values_impl(
    default_values, min, max, step, large_step, min_steps_between_values, orientation,
    disabled, aria_label, on_value_change, on_value_commit, id, false, class, title,
    attrs, input_attrs, style,
  )
}

///|
fn slider_single_notify(
  notify : @cmd.Emit[Int]?,
  fallback : Int,
) -> @cmd.Emit[Array[Int]]? {
  match notify {
    Some(notify) =>
      Some(
        Emit(values => {
          notify(if values.length() == 0 { fallback } else { values[0] })
        }),
      )
    None => None
  }
}

///|
pub fn slider(
  id~ : String,
  default_value? : Int = 0,
  min? : Int = 0,
  max? : Int = 100,
  step? : Int = 1,
  large_step? : Int = 10,
  orientation? : SeparatorOrientation = Horizontal,
  disabled? : Bool = false,
  aria_label? : String = "Value",
  on_value_change? : @cmd.Emit[Int],
  on_value_commit? : @cmd.Emit[Int],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  input_attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @rabbita.Val[@html.Html] {
  let fallback = slider_clamp(default_value, min, max)
  slider_values_impl(
    [default_value],
    min,
    max,
    step,
    large_step,
    0,
    orientation,
    disabled,
    aria_label,
    slider_single_notify(on_value_change, fallback),
    slider_single_notify(on_value_commit, fallback),
    id,
    true,
    class,
    title,
    attrs,
    input_attrs,
    style,
  )
}
