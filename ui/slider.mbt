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
extern "js" fn ffi_bind_slider_pointer(id : String) -> Unit =
  #| id => {
  #|   const root = document.getElementById(id + "-root")
  #|   if (!root || root.__ruiSliderPointerBound) return
  #|   root.__ruiSliderPointerBound = true
  #|   root.__ruiSliderActiveIndex = -1
  #|   root.__ruiSliderLastUsedIndex = -1
  #|   const inputs = () => Array.from(
  #|     root.querySelectorAll('[data-slot="slider-control"]'),
  #|   ).filter(input => !input.disabled)
  #|   const config = count => {
  #|     const min = Number(root.dataset.min || 0)
  #|     const max = Number(root.dataset.max || 100)
  #|     const step = Math.max(1, Number(root.dataset.step || 1))
  #|     const minSteps = Math.max(0, Number(root.dataset.minStepsBetweenValues || 0))
  #|     const availableSteps = Math.floor((max - min) / step)
  #|     const possibleSteps = count > 1
  #|       ? Math.floor(availableSteps / (count - 1))
  #|       : 0
  #|     const effectiveSteps = count > 1
  #|       ? Math.min(minSteps, Math.max(0, possibleSteps))
  #|       : 0
  #|     return { min, max, step, gap: step * effectiveSteps }
  #|   }
  #|   const valueAt = event => {
  #|     const rect = root.getBoundingClientRect()
  #|     const vertical = root.dataset.orientation === "vertical"
  #|     const size = vertical ? rect.height : rect.width
  #|     if (!(size > 0)) return null
  #|     const rtl = !vertical && (
  #|       root.dataset.direction === "rtl"
  #|       || (typeof getComputedStyle === "function"
  #|         && getComputedStyle(root).direction === "rtl")
  #|     )
  #|     const offset = vertical
  #|       ? rect.bottom - event.clientY
  #|       : rtl
  #|         ? rect.right - event.clientX
  #|         : event.clientX - rect.left
  #|     const percent = Math.min(1, Math.max(0, offset / size))
  #|     const { min, max, step } = config(1)
  #|     const raw = min + percent * (max - min)
  #|     const aligned = Math.round((raw - min) / step) * step + min
  #|     return Math.min(max, Math.max(min, aligned))
  #|   }
  #|   const closestIndex = (value, controls) => {
  #|     let best = -1
  #|     let distance = Infinity
  #|     const last = root.__ruiSliderLastUsedIndex
  #|     controls.forEach((input, index) => {
  #|       const nextDistance = Math.abs(Number(input.value) - value)
  #|       if (nextDistance < distance) {
  #|         best = index
  #|         distance = nextDistance
  #|       } else if (nextDistance === distance) {
  #|         if (index === last || (best !== last && index < best)) best = index
  #|       }
  #|     })
  #|     return best
  #|   }
  #|   const activate = (index, controls) => {
  #|     if (index < 0 || index >= controls.length) return null
  #|     root.__ruiSliderActiveIndex = index
  #|     root.__ruiSliderLastUsedIndex = index
  #|     controls.forEach((input, current) => {
  #|       input.style.zIndex = current === index
  #|         ? String(controls.length + 4)
  #|         : String(3 + current)
  #|     })
  #|     const input = controls[index]
  #|     input.focus({ preventScroll: true })
  #|     return input
  #|   }
  #|   const update = (event, commit) => {
  #|     const controls = inputs()
  #|     const index = root.__ruiSliderActiveIndex
  #|     if (index < 0 || index >= controls.length) return
  #|     const requested = valueAt(event)
  #|     if (requested === null) return
  #|     const { min, max, gap } = config(controls.length)
  #|     const lower = index === 0
  #|       ? min
  #|       : Number(controls[index - 1].value) + gap
  #|     const upper = index + 1 >= controls.length
  #|       ? max
  #|       : Number(controls[index + 1].value) - gap
  #|     const next = Math.min(upper, Math.max(lower, requested))
  #|     const input = controls[index]
  #|     if (Number(input.value) !== next) {
  #|       input.value = String(next)
  #|       input.dispatchEvent(new Event("input", { bubbles: true }))
  #|     }
  #|     if (commit) input.dispatchEvent(new Event("change", { bubbles: true }))
  #|   }
  #|   root.addEventListener("pointerdown", event => {
  #|     if (root.dataset.disabled === "true" || event.button !== 0) return
  #|     const requested = valueAt(event)
  #|     const controls = inputs()
  #|     if (requested === null || controls.length === 0) return
  #|     const index = closestIndex(requested, controls)
  #|     if (!activate(index, controls)) return
  #|     event.preventDefault()
  #|     root.setPointerCapture?.(event.pointerId)
  #|     update(event, false)
  #|   })
  #|   root.addEventListener("pointermove", event => {
  #|     if (root.__ruiSliderActiveIndex < 0) return
  #|     event.preventDefault()
  #|     update(event, false)
  #|   })
  #|   const finish = (event, commit) => {
  #|     if (root.__ruiSliderActiveIndex < 0) return
  #|     if (commit) update(event, true)
  #|     root.releasePointerCapture?.(event.pointerId)
  #|     root.__ruiSliderActiveIndex = -1
  #|   }
  #|   root.addEventListener("pointerup", event => finish(event, true))
  #|   root.addEventListener("pointercancel", event => finish(event, false))
  #|   root.addEventListener("lostpointercapture", () => {
  #|     root.__ruiSliderActiveIndex = -1
  #|   })
  #| }

///|
#cfg(target="js")
fn slider_bind_pointer_cmd(id : String) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, _ => {
    ui_after_mount(
      id + "-root",
      () => ffi_bind_slider_pointer(id),
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
extern "js" fn ffi_slider_event_default_prevented(
  event : @dom.KeyboardEvent,
) -> Bool = "event => event.defaultPrevented"

///|
#cfg(target="js")
extern "js" fn ffi_slider_event_is_rtl(event : @dom.KeyboardEvent) -> Bool =
  #| event => {
  #|   const target = event.currentTarget || event.target
  #|   const root = target?.closest?.('[data-slot="slider"]') || target
  #|   if (!root) return false
  #|   if (root.dataset?.direction === "rtl" || root.dir === "rtl") return true
  #|   return typeof getComputedStyle === "function"
  #|     && getComputedStyle(root).direction === "rtl"
  #| }

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
      attrs.on_keydown_after(event => {
        if ffi_slider_event_default_prevented(event) {
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
            ffi_slider_event_is_rtl(event),
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
        input_type=@html.Range,
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
    update=fn(_, msg, current) {
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
        @cmd.Emit(values => {
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
