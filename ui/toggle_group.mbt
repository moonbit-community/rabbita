///|
priv enum ToggleGroupMsg {
  ToggleGroupValue(String)
} derive(Debug)

///|
/// Opaque render scope owned by `toggle_group`.
struct ToggleGroupScope {
  values : Array[String]
  multiple : Bool
  variant : ToggleVariant
  size : ToggleSize
  spacing : Int
  emit : @cmd.Emit[ToggleGroupMsg]
  tab_claimed : Ref[Bool]
}

///|
#cfg(target="js")
extern "js" fn ffi_toggle_group_move_focus(event : @dom.KeyboardEvent) -> Bool =
  #| event => {
  #|   if (event.altKey || event.ctrlKey || event.metaKey || event.shiftKey) return false
  #|   const current = event.target?.closest?.('[data-slot="toggle-group-item"]')
  #|   const group = current?.closest?.('[data-slot="toggle-group"]')
  #|   if (!current || !group) return false
  #|   const items = Array.from(group.querySelectorAll('[data-slot="toggle-group-item"]'))
  #|     .filter(item => item.closest('[data-slot="toggle-group"]') === group
  #|       && !item.disabled
  #|       && item.getAttribute('aria-disabled') !== 'true')
  #|   if (!items.length) return false
  #|   const index = items.indexOf(current)
  #|   if (index < 0) return false
  #|   const vertical = group.dataset.orientation === 'vertical'
  #|   const rtl = getComputedStyle(group).direction === 'rtl'
  #|   let target = null
  #|   if (event.key === 'Home') target = items[0]
  #|   if (event.key === 'End') target = items[items.length - 1]
  #|   if (vertical) {
  #|     if (event.key === 'ArrowUp') target = items[(index - 1 + items.length) % items.length]
  #|     if (event.key === 'ArrowDown') target = items[(index + 1) % items.length]
  #|   } else {
  #|     if (event.key === (rtl ? 'ArrowRight' : 'ArrowLeft')) {
  #|       target = items[(index - 1 + items.length) % items.length]
  #|     }
  #|     if (event.key === (rtl ? 'ArrowLeft' : 'ArrowRight')) {
  #|       target = items[(index + 1) % items.length]
  #|     }
  #|   }
  #|   if (!target) return false
  #|   items.forEach(item => { item.tabIndex = item === target ? 0 : -1 })
  #|   target.focus({ preventScroll: true })
  #|   return true
  #| }

///|
#cfg(target="js")
fn toggle_group_bind_keyboard(attrs : @html.Attrs) -> Unit {
  ignore(
    attrs.on_keydown_after(event => {
      if ffi_toggle_group_move_focus(event) {
        event.prevent_default()
      }
      @cmd.none
    }),
  )
}

///|
#cfg(not(target="js"))
fn toggle_group_bind_keyboard(attrs : @html.Attrs) -> Unit {
  ignore(attrs)
}

///|
fn toggle_group_contains(values : Array[String], value : String) -> Bool {
  for item in values {
    if item == value {
      return true
    }
  }
  false
}

///|
fn toggle_group_next_values(
  values : Array[String],
  value : String,
  multiple : Bool,
) -> Array[String] {
  let selected = toggle_group_contains(values, value)
  if !multiple {
    if selected {
      []
    } else {
      [value]
    }
  } else {
    let next : Array[String] = []
    for item in values {
      if item != value {
        next.push(item)
      }
    }
    if !selected {
      next.push(value)
    }
    next
  }
}

///|
fn[C : @html.IsChildren] render_toggle_group(
  scope : ToggleGroupScope,
  orientation : SeparatorOrientation,
  variant : ToggleVariant,
  size : ToggleSize,
  spacing : Int,
  aria_label : String?,
  id : String?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : (ToggleGroupScope) -> C,
) -> @html.Html {
  let orientation_value = separator_orientation_value(orientation)
  let gap = spacing.to_double() / 4.0
  let group_attrs = ui_attrs(attrs)
    .role("group")
    .aria_orientation(orientation_value)
    .data_set("slot", "toggle-group")
    .data_set("orientation", orientation_value)
    .data_set("variant", toggle_variant_value(variant))
    .data_set("size", toggle_size_value(size))
    .data_set("spacing", "\{spacing}")
    .data_set("multiple", ui_bool(scope.multiple))
  if aria_label is Some(label) {
    ignore(group_attrs.aria_label(label))
  }
  @html.div(
    id?,
    class?,
    title?,
    attrs=group_attrs,
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        "--rui-toggle-group-gap:\{gap}rem;display:inline-flex;width:fit-content;align-items:center;gap:var(--rui-toggle-group-gap);border-radius:var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem))",
        if spacing == 0 && variant is Outline {
          UiShadowXs
        } else {
          ""
        },
        if orientation is Vertical {
          "flex-direction:column;align-items:stretch"
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
/// Stateful shadcn-style toggle group. Selection is component-local and the
/// optional callback observes each committed value set.
#cfg(target="js")
pub fn[C : @html.IsChildren] toggle_group(
  default_values? : Array[String] = [],
  multiple? : Bool = false,
  orientation? : SeparatorOrientation = Horizontal,
  variant? : ToggleVariant = Default,
  size? : ToggleSize = Default,
  spacing? : Int = 0,
  aria_label? : String,
  on_value_change? : @cmd.Emit[Array[String]],
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (ToggleGroupScope) -> C,
) -> @rabbita.Val[@html.Html] {
  let (values, emit) = @rabbita.create_state(default_values, update=fn(
    _,
    msg,
    values,
  ) {
    let next = match msg {
      ToggleGroupValue(value) =>
        toggle_group_next_values(values, value, multiple)
    }
    let command = if on_value_change is Some(notify) {
      notify(next)
    } else {
      @cmd.none
    }
    (next, command)
  })
  values.view(values => {
    render_toggle_group(
      {
        values,
        multiple,
        variant,
        size,
        spacing,
        emit,
        tab_claimed: Ref(false),
      },
      orientation,
      variant,
      size,
      spacing,
      aria_label,
      id,
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
pub fn[C : @html.IsChildren] toggle_group(
  default_values? : Array[String] = [],
  multiple? : Bool = false,
  orientation? : SeparatorOrientation = Horizontal,
  variant? : ToggleVariant = Default,
  size? : ToggleSize = Default,
  spacing? : Int = 0,
  aria_label? : String,
  on_value_change? : @cmd.Emit[Array[String]],
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (ToggleGroupScope) -> C,
) -> @rabbita.Val[@html.Html] {
  ignore(on_value_change)
  let emit = @cmd.Emit(_ => @cmd.none)
  @rabbita.Val::constant(
    render_toggle_group(
      {
        values: default_values,
        multiple,
        variant,
        size,
        spacing,
        emit,
        tab_claimed: Ref(false),
      },
      orientation,
      variant,
      size,
      spacing,
      aria_label,
      id,
      class,
      title,
      attrs,
      style,
      children,
    ),
  )
}

///|
pub fn[C : @html.IsChildren] toggle_group_item(
  scope~ : ToggleGroupScope,
  value~ : String,
  disabled? : Bool = false,
  aria_label? : String,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let pressed = toggle_group_contains(scope.values, value)
  let item_attrs = ui_attrs(attrs)
    .data_set("slot", "toggle-group-item")
    .data_set("variant", toggle_variant_value(scope.variant))
    .data_set("size", toggle_size_value(scope.size))
    .data_set("spacing", "\{scope.spacing}")
    .data_set("value", value)
    .data_set("state", if pressed { "on" } else { "off" })
  let tab_stop = !disabled &&
    !scope.tab_claimed.val &&
    (scope.values.length() == 0 || pressed)
  if tab_stop {
    scope.tab_claimed.val = true
  }
  ignore(item_attrs.tabindex(if tab_stop { 0 } else { -1 }))
  toggle_group_bind_keyboard(item_attrs)
  if aria_label is Some(label) {
    ignore(item_attrs.aria_label(label))
  }
  render_toggle(
    pressed~,
    variant=scope.variant,
    size=scope.size,
    disabled~,
    slot="toggle-group-item",
    id?,
    class?,
    title?,
    on_pressed_change=@cmd.Emit(_ => (scope.emit)(ToggleGroupValue(value))),
    attrs=item_attrs,
    style=ui_styles(
      [
        "width:auto;min-width:0;flex-shrink:0;--rui-toggle-padding-inline:0.75rem",
        if scope.spacing == 0 {
          "--rui-toggle-base-radius:0;--rui-toggle-base-shadow:none"
        } else {
          ""
        },
      ],
      style,
    ),
    children,
  )
}
