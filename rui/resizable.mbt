///|
pub(all) enum ResizablePanelSide {
  FirstPanel
  SecondPanel
} derive(Debug, Eq)

///|
priv enum ResizableGroupMsg {
  SetResizableGroupSizes(Array[Int])
  ResizeResizableGroupAt(Int, Int)
}

///|
/// Opaque render scope owned by [`resizable_group`].
struct ResizableGroupScope {
  id : String
  sizes : Array[Int]
  min_sizes : Array[Int]
  max_sizes : Array[Int]
  orientation : SeparatorOrientation
  aria_label : String
  emit : @cmd.Emit[ResizableGroupMsg]
}

///|
/// Opaque compatibility scope owned by [`resizable_panel_group`].
struct ResizableScope {
  group : ResizableGroupScope
  control_id : String
}

///|
priv struct ResizableHandleBounds {
  valid : Bool
  value : Int
  min : Int
  max : Int
}

///|
fn resizable_int_min(left : Int, right : Int) -> Int {
  if left < right {
    left
  } else {
    right
  }
}

///|
fn resizable_int_max(left : Int, right : Int) -> Int {
  if left > right {
    left
  } else {
    right
  }
}

///|
fn resizable_clamp(value : Int, min : Int, max : Int) -> Int {
  if value < min {
    min
  } else if value > max {
    max
  } else {
    value
  }
}

///|
fn resizable_parse(value : String, fallback : Int) -> Int {
  @string.parse_int(value) catch {
    _ => fallback
  }
}

///|
fn resizable_value_at(values : Array[Int], index : Int, fallback : Int) -> Int {
  values.get(index).unwrap_or(fallback)
}

///|
fn resizable_sum(values : Array[Int]) -> Int {
  let mut total = 0
  for value in values {
    total += value
  }
  total
}

///|
fn resizable_prefix_size(values : Array[Int], end : Int) -> Int {
  let mut total = 0
  for index, value in values {
    if index < end {
      total += value
    }
  }
  total
}

///|
fn resizable_pointer_percent(
  orientation : SeparatorOrientation,
  client_x : Int,
  client_y : Int,
  group_left : Int,
  group_top : Int,
  group_width : Int,
  group_height : Int,
) -> Int? {
  let (position, start, length) = if orientation is Vertical {
    (client_y, group_top, group_height)
  } else {
    (client_x, group_left, group_width)
  }
  if length <= 0 {
    return None
  }
  let offset = resizable_clamp(position - start, 0, length)
  Some((offset * 100 + length / 2) / length)
}

///|
fn resizable_normalize_sizes(
  values : Array[Int],
  min_sizes : Array[Int],
  max_sizes : Array[Int],
) -> Array[Int] {
  if values.length() == 0 {
    return [100]
  }
  let sizes : Array[Int] = []
  for index, value in values {
    sizes.push(resizable_clamp(value, min_sizes[index], max_sizes[index]))
  }
  let total = resizable_sum(sizes)
  if total < 100 {
    let mut remaining = 100 - total
    for index, size in sizes {
      if remaining > 0 {
        let capacity = max_sizes[index] - size
        let delta = resizable_int_min(capacity, remaining)
        sizes[index] = size + delta
        remaining -= delta
      }
    }
    // Infeasible max constraints cannot satisfy both policies. Preserve the
    // layout invariant (sum 100) and leave the impossible bound visible in the
    // handle range instead of producing a broken flex layout.
    if remaining > 0 {
      let last = sizes.length() - 1
      sizes[last] += remaining
    }
  } else if total > 100 {
    let mut remaining = total - 100
    for index, size in sizes {
      if remaining > 0 {
        let capacity = size - min_sizes[index]
        let delta = resizable_int_min(capacity, remaining)
        sizes[index] = size - delta
        remaining -= delta
      }
    }
    if remaining > 0 {
      let last = sizes.length() - 1
      sizes[last] -= remaining
    }
  }
  sizes
}

///|
fn resizable_prepare_layout(
  default_sizes : Array[Int],
  min_sizes : Array[Int],
  max_sizes : Array[Int],
) -> (Array[Int], Array[Int], Array[Int]) {
  let defaults = if default_sizes.length() == 0 {
    [100]
  } else {
    default_sizes.copy()
  }
  let minimums : Array[Int] = []
  let maximums : Array[Int] = []
  for index, _ in defaults {
    let minimum = resizable_clamp(
      resizable_value_at(min_sizes, index, 0),
      0,
      100,
    )
    let maximum = resizable_clamp(
      resizable_value_at(max_sizes, index, 100),
      minimum,
      100,
    )
    minimums.push(minimum)
    maximums.push(maximum)
  }
  (resizable_normalize_sizes(defaults, minimums, maximums), minimums, maximums)
}

///|
fn resizable_handle_bounds(
  sizes : Array[Int],
  min_sizes : Array[Int],
  max_sizes : Array[Int],
  between : Int,
) -> ResizableHandleBounds {
  if between < 0 || between + 1 >= sizes.length() {
    return { valid: false, value: 0, min: 0, max: 0 }
  }
  let left = sizes[between]
  let right = sizes[between + 1]
  let pair_total = left + right
  let minimum = resizable_int_max(
    min_sizes[between],
    pair_total - max_sizes[between + 1],
  )
  let maximum = resizable_int_min(
    max_sizes[between],
    pair_total - min_sizes[between + 1],
  )
  if minimum > maximum {
    { valid: false, value: left, min: left, max: left }
  } else {
    { valid: true, value: left, min: minimum, max: maximum }
  }
}

///|
fn resizable_resize_between(
  sizes : Array[Int],
  min_sizes : Array[Int],
  max_sizes : Array[Int],
  between : Int,
  requested : Int,
) -> Array[Int] {
  let next = sizes.copy()
  let bounds = resizable_handle_bounds(sizes, min_sizes, max_sizes, between)
  if !bounds.valid {
    return next
  }
  let pair_total = sizes[between] + sizes[between + 1]
  let left = resizable_clamp(requested, bounds.min, bounds.max)
  next[between] = left
  next[between + 1] = pair_total - left
  next
}

///|
fn resizable_resize_at_percent(
  sizes : Array[Int],
  min_sizes : Array[Int],
  max_sizes : Array[Int],
  between : Int,
  percent : Int,
) -> Array[Int] {
  resizable_resize_between(
    sizes,
    min_sizes,
    max_sizes,
    between,
    percent - resizable_prefix_size(sizes, between),
  )
}

///|
fn resizable_key_size(
  size : Int,
  min : Int,
  max : Int,
  orientation : SeparatorOrientation,
  key : String,
) -> Int? {
  let requested = match (orientation, key) {
    (_, "Home") => Some(min)
    (_, "End") => Some(max)
    (Horizontal, "ArrowLeft") => Some(size - 1)
    (Horizontal, "ArrowRight") => Some(size + 1)
    (Vertical, "ArrowUp") => Some(size - 1)
    (Vertical, "ArrowDown") => Some(size + 1)
    _ => None
  }
  requested.map(next => resizable_clamp(next, min, max))
}

///|
fn resizable_key_for_direction(
  orientation : SeparatorOrientation,
  key : String,
  rtl : Bool,
) -> String {
  if orientation is Horizontal && rtl {
    match key {
      "ArrowLeft" => "ArrowRight"
      "ArrowRight" => "ArrowLeft"
      _ => key
    }
  } else {
    key
  }
}

///|
fn resizable_key_sizes(
  sizes : Array[Int],
  min_sizes : Array[Int],
  max_sizes : Array[Int],
  between : Int,
  orientation : SeparatorOrientation,
  key : String,
) -> Array[Int]? {
  let bounds = resizable_handle_bounds(sizes, min_sizes, max_sizes, between)
  if !bounds.valid {
    return None
  }
  resizable_key_size(bounds.value, bounds.min, bounds.max, orientation, key).map(requested => {
      resizable_resize_between(sizes, min_sizes, max_sizes, between, requested)
    },
  )
}

///|
fn resizable_is_arrow_key(key : String) -> Bool {
  key == "ArrowLeft" ||
  key == "ArrowRight" ||
  key == "ArrowUp" ||
  key == "ArrowDown"
}

///|
#cfg(target="js")
priv struct ResizablePointerActive {
  pointer_id : Int
  between : Int
  handle : @dom.Element
}

///|
#cfg(target="js")
priv struct ResizablePointerBinding {
  root : @dom.Element
  mut resize : (Int, Int, Int, Int, Int, Int, Int) -> Unit
  mut active : ResizablePointerActive?
}

///|
#cfg(target="js")
let resizable_pointer_bindings : Array[ResizablePointerBinding] = []

///|
#cfg(target="js")
fn resizable_prune_pointer_bindings() -> Unit {
  let mut index = 0
  while index < resizable_pointer_bindings.length() {
    if resizable_pointer_bindings[index].root.get_is_connected() {
      index += 1
    } else {
      ignore(resizable_pointer_bindings.remove(index))
    }
  }
}

///|
#cfg(target="js")
fn resizable_pointer_binding(root : @dom.Element) -> ResizablePointerBinding? {
  for binding in resizable_pointer_bindings {
    if binding.root.is_same_node(root.as_node()) {
      return Some(binding)
    }
  }
  None
}

///|
#cfg(target="js")
fn resizable_update_pointer(
  binding : ResizablePointerBinding,
  pointer : @dom.PointerEvent,
) -> Unit {
  guard binding.active is Some(active) else { return }
  guard active.pointer_id == pointer.get_pointer_id() else { return }
  let rect = binding.root.get_bounding_client_rect()
  let client_x = if binding.root.get_attribute("data-orientation").unwrap_or("") ==
    "horizontal" &&
    ui_element_is_rtl(binding.root) {
    rect.get_left() +
    rect.get_width() -
    (pointer.get_client_x().to_double() - rect.get_left())
  } else {
    pointer.get_client_x().to_double()
  }
  (binding.resize)(
    active.between,
    client_x.round().to_int(),
    pointer.get_client_y(),
    rect.get_left().round().to_int(),
    rect.get_top().round().to_int(),
    rect.get_width().round().to_int(),
    rect.get_height().round().to_int(),
  )
}

///|
#cfg(target="js")
fn resizable_finish_pointer(
  binding : ResizablePointerBinding,
  pointer : @dom.PointerEvent,
) -> Unit {
  guard binding.active is Some(active) else { return }
  guard active.pointer_id == pointer.get_pointer_id() else { return }
  active.handle.remove_attribute("data-resizing")
  binding.active = None
  if binding.root.has_pointer_capture(active.pointer_id) {
    binding.root.release_pointer_capture(active.pointer_id)
  }
}

///|
#cfg(target="js")
fn resizable_bind_pointer_listeners(binding : ResizablePointerBinding) -> Unit {
  binding.root.add_event_listener("pointerdown", event => {
    guard event.to_pointer_event() is Some(pointer) else { return }
    if pointer.get_button() != 0 || binding.active is Some(_) {
      return
    }
    guard pointer.target().to_element() is Some(target) else { return }
    guard target.closest("[data-slot=\"resizable-handle\"][data-between]")
      is Some(handle) else {
      return
    }
    guard binding.root.contains(handle.as_node()) else { return }
    guard handle.closest("[data-slot=\"resizable-panel-group\"]") is Some(owner) &&
      owner.is_same_node(binding.root.as_node()) else {
      return
    }
    guard handle.query_selector("[data-slot=\"resizable-control\"]")
      is Some(control) else {
      return
    }
    if !ui_element_is_enabled(control) {
      return
    }
    let between = ui_parse_int_or(
      handle.get_attribute("data-between").unwrap_or(""),
      -1,
    )
    if between < 0 {
      return
    }
    binding.active = Some({
      pointer_id: pointer.get_pointer_id(),
      between,
      handle,
    })
    handle.set_attribute("data-resizing", "true")
    ui_focus_element_without_scroll(control)
    pointer.prevent_default()
    binding.root.set_pointer_capture(pointer.get_pointer_id())
    resizable_update_pointer(binding, pointer)
  })
  binding.root.add_event_listener("pointermove", event => {
    guard event.to_pointer_event() is Some(pointer) else { return }
    if binding.active is Some(_) {
      pointer.prevent_default()
      resizable_update_pointer(binding, pointer)
    }
  })
  let finish : @dom.Listener = event => {
    if event.to_pointer_event() is Some(pointer) {
      resizable_finish_pointer(binding, pointer)
    }
  }
  binding.root.add_event_listener("pointerup", finish)
  binding.root.add_event_listener("pointercancel", finish)
  binding.root.add_event_listener("lostpointercapture", finish)
}

///|
#cfg(target="js")
fn bind_resizable_pointer(
  id : String,
  resize : (Int, Int, Int, Int, Int, Int, Int) -> Unit,
) -> Unit {
  guard ui_element_by_id(id) is Some(root) else { return }
  resizable_prune_pointer_bindings()
  if resizable_pointer_binding(root) is Some(binding) {
    binding.resize = resize
    return
  }
  let binding : ResizablePointerBinding = { root, resize, active: None }
  resizable_pointer_bindings.push(binding)
  resizable_bind_pointer_listeners(binding)
}

///|
#cfg(target="js")
fn resizable_event_is_rtl(event : @dom.KeyboardEvent) -> Bool {
  event.current_target().to_option() is Some(current_target) &&
  current_target.to_element() is Some(target) &&
  target.closest("[data-slot=\"resizable-panel-group\"]") is Some(group) &&
  ui_element_is_rtl(group)
}

///|
#cfg(target="js")
fn resizable_bind_pointer_cmd(
  id : String,
  orientation : SeparatorOrientation,
  emit : @cmd.Emit[ResizableGroupMsg],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, scheduler => {
    ui_after_mount(
      id,
      () => {
        bind_resizable_pointer(id, (
          between,
          client_x,
          client_y,
          left,
          top,
          width,
          height,
        ) => {
          if resizable_pointer_percent(
              orientation, client_x, client_y, left, top, width, height,
            )
            is Some(percent) {
            scheduler.add(emit(ResizeResizableGroupAt(between, percent)))
          }
        })
      },
      purpose="resizable-pointer-bind",
    )
  })
}

///|
#cfg(target="js")
fn resizable_group_input_attrs(
  scope : ResizableGroupScope,
  between : Int,
  label : String,
) -> @html.Attrs {
  let attrs = @html.Attrs::build()
    .data_set("slot", "resizable-control")
    .aria_label(label)
    .aria_orientation(separator_orientation_value(scope.orientation))
  ignore(
    attrs.on_keydown(event => {
      let key = resizable_key_for_direction(
        scope.orientation,
        event.key(),
        resizable_event_is_rtl(event),
      )
      let next = resizable_key_sizes(
        scope.sizes,
        scope.min_sizes,
        scope.max_sizes,
        between,
        scope.orientation,
        key,
      )
      if next is Some(next) {
        event.prevent_default()
        if next == scope.sizes {
          @cmd.none
        } else {
          (scope.emit)(SetResizableGroupSizes(next))
        }
      } else if resizable_is_arrow_key(key) {
        // A native range also handles orthogonal arrow keys. Suppress them so
        // its keyboard axis remains identical to the visible panel-group axis.
        event.prevent_default()
        @cmd.none
      } else {
        @cmd.none
      }
    }),
  )
  attrs
}

///|
#cfg(not(target="js"))
fn resizable_group_input_attrs(
  scope : ResizableGroupScope,
  between : Int,
  label : String,
) -> @html.Attrs {
  ignore(between)
  @html.Attrs::build()
  .data_set("slot", "resizable-control")
  .aria_label(label)
  .aria_orientation(separator_orientation_value(scope.orientation))
}

///|
fn[C : @html.IsChildren] render_resizable_group(
  scope : ResizableGroupScope,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : (ResizableGroupScope) -> C,
) -> @html.Html {
  let orientation_value = separator_orientation_value(scope.orientation)
  let first_size = resizable_value_at(scope.sizes, 0, 100)
  @html.div(
    id=scope.id,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "resizable-panel-group")
      .data_set("orientation", orientation_value)
      .data_set("size", "\{first_size}")
      .data_set("sizes", scope.sizes.map(size => "\{size}").join(","))
      .data_set("panel-count", "\{scope.sizes.length()}"),
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        "display:flex;width:100%;height:100%;min-width:0;min-height:0;overflow:hidden",
        if scope.orientation is Vertical {
          "flex-direction:column"
        } else {
          "flex-direction:row"
        },
      ],
      style,
    ),
    children(scope),
  )
}

///|
#cfg(target="js")
pub fn[C : @html.IsChildren] resizable_group(
  id~ : String,
  default_sizes~ : Array[Int],
  min_sizes? : Array[Int] = [],
  max_sizes? : Array[Int] = [],
  orientation? : SeparatorOrientation = Horizontal,
  aria_label? : String = "Resize panels",
  on_resize? : @cmd.Emit[Array[Int]],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (ResizableGroupScope) -> C,
) -> @rabbita.Val[@html.Html] {
  let (initial, minimums, maximums) = resizable_prepare_layout(
    default_sizes, min_sizes, max_sizes,
  )
  let (sizes, emit) = @rabbita.create_state_with_init(
    init=emit => (initial, resizable_bind_pointer_cmd(id, orientation, emit)),
    update=fn(current, msg, _) {
      let next = match msg {
        SetResizableGroupSizes(sizes) => sizes
        ResizeResizableGroupAt(between, percent) =>
          resizable_resize_at_percent(
            current, minimums, maximums, between, percent,
          )
      }
      let command = if next != current && on_resize is Some(notify) {
        notify(next.copy())
      } else {
        @cmd.none
      }
      (next, command)
    },
  )
  sizes.view(sizes => {
    render_resizable_group(
      {
        id,
        sizes,
        min_sizes: minimums,
        max_sizes: maximums,
        orientation,
        aria_label,
        emit,
      },
      class,
      title,
      attrs,
      style,
      children,
    )
  })
}

///|
#cfg(not(target="js"))
pub fn[C : @html.IsChildren] resizable_group(
  id~ : String,
  default_sizes~ : Array[Int],
  min_sizes? : Array[Int] = [],
  max_sizes? : Array[Int] = [],
  orientation? : SeparatorOrientation = Horizontal,
  aria_label? : String = "Resize panels",
  on_resize? : @cmd.Emit[Array[Int]],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (ResizableGroupScope) -> C,
) -> @rabbita.Val[@html.Html] {
  ignore(on_resize)
  let (sizes, minimums, maximums) = resizable_prepare_layout(
    default_sizes, min_sizes, max_sizes,
  )
  let emit = @cmd.Emit(_ => @cmd.none)
  @rabbita.Val::constant(
    render_resizable_group(
      {
        id,
        sizes,
        min_sizes: minimums,
        max_sizes: maximums,
        orientation,
        aria_label,
        emit,
      },
      class,
      title,
      attrs,
      style,
      children,
    ),
  )
}

///|
pub fn[C : @html.IsChildren] resizable_group_panel(
  scope~ : ResizableGroupScope,
  index~ : Int,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let size = resizable_value_at(scope.sizes, index, 0)
  let panel_id = id.unwrap_or("\{scope.id}-panel-\{index}")
  @html.div(
    id=panel_id,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "resizable-panel")
      .data_set("index", "\{index}")
      .data_set("size", "\{size}"),
    style=ui_styles(
      [UiBoxSizing, "min-width:0;min-height:0;overflow:auto;flex:0 0 \{size}%"],
      style,
    ),
    children,
  )
}

///|
fn render_resizable_handle(
  scope : ResizableGroupScope,
  between : Int,
  outer_id : String?,
  control_id : String,
  with_handle : Bool,
  aria_label : String?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
) -> @html.Html {
  let vertical = scope.orientation is Vertical
  let bounds = resizable_handle_bounds(
    scope.sizes,
    scope.min_sizes,
    scope.max_sizes,
    between,
  )
  let label = aria_label.unwrap_or(scope.aria_label)
  let input_attrs = resizable_group_input_attrs(scope, between, label)
  if !bounds.valid {
    ignore(input_attrs.disabled(true))
  }
  let id = outer_id
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .role("separator")
      .aria_orientation(if vertical { "horizontal" } else { "vertical" })
      .aria_valuemin("\{bounds.min}")
      .aria_valuemax("\{bounds.max}")
      .aria_valuenow("\{bounds.value}")
      .data_set("slot", "resizable-handle")
      .data_set("orientation", if vertical { "horizontal" } else { "vertical" })
      .data_set("between", "\{between}"),
    style=ui_styles(
      [
        "position:relative;z-index:1;display:flex;flex-shrink:0;align-items:center;justify-content:center;outline:none",
        "touch-action:none;user-select:none",
        if vertical {
          "width:100%;height:0;cursor:row-resize"
        } else {
          "width:0;height:100%;cursor:col-resize"
        },
      ],
      style,
    ),
    [
      @html.span(
        attrs=@html.Attrs::build()
          .data_set("slot", "resizable-handle-line")
          .aria_hidden("true"),
        style=[
          "position:absolute;z-index:0;display:block;background:var(--rui-border,oklch(0.922 0 0));pointer-events:none",
          if vertical {
            "left:0;top:-0.5px;width:100%;height:1px"
          } else {
            "left:-0.5px;top:0;width:1px;height:100%"
          },
        ],
        "",
      ),
      @html.span(
        attrs=@html.Attrs::build()
          .data_set("slot", "resizable-handle-hit-area")
          .aria_hidden("true"),
        style=[
          "position:absolute;z-index:2;display:block",
          if vertical {
            "left:0;top:-2px;width:100%;height:4px;cursor:row-resize"
          } else {
            "left:-2px;top:0;width:4px;height:100%;cursor:col-resize"
          },
        ],
        "",
      ),
      if with_handle {
        @html.span(
          attrs=@html.Attrs::build()
            .data_set("slot", "resizable-handle-grip")
            .aria_hidden("true"),
          style=[
            "position:relative;z-index:1;display:block;width:0.25rem;height:1.5rem;flex-shrink:0;border-radius:9999px;background:var(--rui-border,oklch(0.922 0 0));pointer-events:none",
            if vertical {
              "transform:rotate(90deg)"
            } else {
              ""
            },
          ],
          "",
        )
      } else {
        @html.nothing
      },
      @html.input(
        input_type=Range,
        value="\{bounds.value}",
        min=bounds.min,
        max=bounds.max,
        step=1,
        id=control_id,
        on_input=scope.emit.map(text => {
          SetResizableGroupSizes(
            resizable_resize_between(
              scope.sizes,
              scope.min_sizes,
              scope.max_sizes,
              between,
              resizable_parse(text, bounds.value),
            ),
          )
        }),
        attrs=input_attrs,
        style=[
          "position:absolute;z-index:2;margin:0;opacity:0;pointer-events:none",
          if vertical {
            "left:0;top:-2px;width:100%;height:4px;writing-mode:vertical-lr;cursor:row-resize"
          } else {
            "left:-2px;top:0;width:4px;height:100%;writing-mode:horizontal-tb;cursor:col-resize"
          },
        ],
      ),
    ],
  )
}

///|
pub fn resizable_group_handle(
  scope~ : ResizableGroupScope,
  between~ : Int,
  with_handle? : Bool = false,
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let handle_id = "\{scope.id}-handle-\{between}"
  render_resizable_handle(
    scope,
    between,
    Some(handle_id),
    handle_id + "-input",
    with_handle,
    aria_label,
    class,
    title,
    attrs,
    style,
  )
}

///|
pub fn[C : @html.IsChildren] resizable_panel_group(
  id~ : String,
  default_size? : Int = 50,
  min? : Int = 10,
  max? : Int = 90,
  orientation? : SeparatorOrientation = Horizontal,
  aria_label? : String = "Resize panels",
  on_resize? : @cmd.Emit[Int],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (ResizableScope) -> C,
) -> @rabbita.Val[@html.Html] {
  let min = resizable_clamp(min, 0, 100)
  let max = resizable_clamp(max, min, 100)
  let initial = resizable_clamp(default_size, min, max)
  let on_resize = if on_resize is Some(notify) {
    Some(notify.map(sizes => resizable_value_at(sizes, 0, initial)))
  } else {
    None
  }
  resizable_group(
    id~,
    default_sizes=[initial, 100 - initial],
    min_sizes=[min, 100 - max],
    max_sizes=[max, 100 - min],
    orientation~,
    aria_label~,
    on_resize?,
    class?,
    title?,
    attrs?,
    style~,
    group => children({ group, control_id: "\{id}-handle" }),
  )
}

///|
pub fn[C : @html.IsChildren] resizable_panel(
  scope~ : ResizableScope,
  side~ : ResizablePanelSide,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let side_value = if side is FirstPanel { "first" } else { "second" }
  let index = if side is FirstPanel { 0 } else { 1 }
  let size = resizable_value_at(scope.group.sizes, index, 0)
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "resizable-panel")
      .data_set("side", side_value)
      .data_set("size", "\{size}"),
    style=ui_styles(
      [UiBoxSizing, "min-width:0;min-height:0;overflow:auto;flex:0 0 \{size}%"],
      style,
    ),
    children,
  )
}

///|
pub fn resizable_handle(
  scope~ : ResizableScope,
  with_handle? : Bool = false,
  aria_label? : String,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  render_resizable_handle(
    scope.group,
    0,
    id,
    scope.control_id,
    with_handle,
    aria_label,
    class,
    title,
    attrs,
    style,
  )
}
