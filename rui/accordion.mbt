///|
pub(all) enum AccordionType {
  Single
  Multiple
} derive(Debug, Eq)

///|
/// One entry for the self-contained accordion component.
///
/// Use the compound `accordion_*` functions directly when the trigger needs
/// richer content than this entry's text label.
struct AccordionEntry {
  value : String
  label : String
  content : @html.Html
  disabled : Bool
}

///|
const AccordionRootStyle : String = "display:block;width:100%;min-width:0;color:var(--rui-foreground,oklch(0.145 0 0))"

///|
const AccordionItemStyle : String = "display:block;width:100%;min-width:0;border-bottom:1px solid var(--rui-border,oklch(0.922 0 0))"

///|
const AccordionTriggerStyle : String = "display:flex;width:100%;min-height:3rem;align-items:center;justify-content:space-between;gap:0.75rem;border:1px solid var(--rui-accordion-border,var(--rui-accordion-base-border,transparent));border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);margin:0;padding:0.75rem 0;background:var(--rui-accordion-bg,var(--rui-accordion-base-bg,transparent));color:var(--rui-accordion-fg,var(--rui-accordion-base-fg,inherit));box-shadow:var(--rui-accordion-shadow,var(--rui-accordion-base-shadow,none));font-size:0.875rem;line-height:1.25rem;font-weight:500;text-align:start;list-style:none;cursor:pointer;user-select:none;outline-offset:2px"

///|
const AccordionTriggerOpenStyle : String = "--rui-accordion-base-fg:var(--rui-foreground,oklch(0.145 0 0))"

///|
const AccordionTriggerLabelStyle : String = "display:block;min-width:0;flex:1"

///|
const AccordionIndicatorBoxStyle : String = "display:inline-flex;width:1rem;height:1rem;flex-shrink:0;align-items:center;justify-content:center;color:var(--rui-muted-foreground,oklch(0.556 0 0));pointer-events:none"

///|
const AccordionIndicatorStyle : String = "display:block;width:0.4375rem;height:0.4375rem;border-right:1.5px solid currentColor;border-bottom:1.5px solid currentColor;transform-origin:center;transition:transform 150ms ease"

///|
const AccordionIndicatorClosedStyle : String = "transform:translateY(-0.125rem) rotate(45deg)"

///|
const AccordionIndicatorOpenStyle : String = "transform:translateY(0.125rem) rotate(225deg)"

///|
const AccordionContentOuterStyle : String = "display:grid;min-width:0;grid-template-rows:var(--rui-accordion-content-rows,0fr);opacity:var(--rui-accordion-content-opacity,0);visibility:var(--rui-accordion-content-visibility,hidden);transition:grid-template-rows 200ms cubic-bezier(0.22,1,0.36,1),opacity 150ms ease,visibility 0s linear var(--rui-accordion-content-visibility-delay,200ms)"

///|
const AccordionContentOpenStyle : String = "--rui-accordion-content-rows:1fr;--rui-accordion-content-opacity:1;--rui-accordion-content-visibility:visible;--rui-accordion-content-visibility-delay:0s"

///|
const AccordionContentClosedStyle : String = "--rui-accordion-content-rows:0fr;--rui-accordion-content-opacity:0;--rui-accordion-content-visibility:hidden;--rui-accordion-content-visibility-delay:200ms"

///|
const AccordionContentClipStyle : String = "min-width:0;min-height:0;overflow:hidden"

///|
const AccordionContentStyle : String = "min-width:0;padding:0 0 1rem;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem;line-height:1.5;overflow-wrap:anywhere"

///|
fn accordion_type_value(type_ : AccordionType) -> String {
  match type_ {
    Single => "single"
    Multiple => "multiple"
  }
}

///|
fn accordion_state(open : Bool) -> String {
  if open {
    "open"
  } else {
    "closed"
  }
}

///|
fn accordion_state_attrs(
  attrs : @html.Attrs?,
  slot : String,
  open : Bool,
) -> @html.Attrs {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", slot)
    .data_set("state", accordion_state(open))
  if open {
    ignore(element_attrs.data_set("open", ""))
  } else {
    ignore(element_attrs.data_set("closed", ""))
  }
  element_attrs
}

///|
#cfg(target="js")
fn accordion_bind_value_change(
  attrs : @html.Attrs,
  value : String,
  emit : @cmd.Emit[String],
) -> Unit {
  ignore(
    attrs.on_click(event => {
      event.prevent_default()
      emit(value)
    }),
  )
}

///|
#cfg(not(target="js"))
fn accordion_bind_value_change(
  attrs : @html.Attrs,
  value : String,
  emit : @cmd.Emit[String],
) -> Unit {
  ignore((attrs, value, emit))
}

///|
#cfg(target="js")
fn accordion_move_focus(event : @dom.KeyboardEvent) -> Bool {
  if event.alt_key() ||
    event.ctrl_key() ||
    event.meta_key() ||
    event.shift_key() {
    return false
  }
  guard ui_roving_context(
      event, "[data-slot=\"accordion-trigger\"]", "[data-slot=\"accordion\"]", "[data-slot=\"accordion-trigger\"]",
    )
    is Some(context) else {
    return false
  }
  if context.root.get_attribute("aria-disabled").unwrap_or("") == "true" {
    return false
  }
  guard ui_roving_target(context, event.key(), "vertical", false)
    is Some(target) else {
    return false
  }
  ui_focus_element(target)
  true
}

///|
#cfg(target="js")
fn accordion_bind_keyboard(attrs : @html.Attrs) -> Unit {
  ignore(
    attrs.on_keydown(event => {
      if accordion_move_focus(event) {
        event.prevent_default()
      }
      @cmd.none
    }),
  )
}

///|
#cfg(not(target="js"))
fn accordion_bind_keyboard(attrs : @html.Attrs) -> Unit {
  ignore(attrs)
}

///|
fn accordion_indicator(open : Bool) -> @html.Html {
  let state = accordion_state(open)
  @html.span(
    style=[UiBoxSizing, AccordionIndicatorBoxStyle],
    attrs=@html.Attrs::build()
      .aria_hidden("true")
      .data_set("slot", "accordion-indicator")
      .data_set("state", state),
    @html.span(
      style=[
        UiBoxSizing,
        AccordionIndicatorStyle,
        if open {
          AccordionIndicatorOpenStyle
        } else {
          AccordionIndicatorClosedStyle
        },
      ],
      attrs=@html.Attrs::build().data_set("state", state),
      @html.nothing,
    ),
  )
}

///|
fn accordion_entry_enabled(
  items : Array[AccordionEntry],
  value : String,
) -> Bool {
  for item in items {
    if item.value == value {
      return !item.disabled
    }
  }
  false
}

///|
fn accordion_initial_values(
  items : Array[AccordionEntry],
  type_ : AccordionType,
  default_value : String?,
  default_values : Array[String],
) -> Array[String] {
  match type_ {
    Single =>
      if default_value is Some(value) && accordion_entry_enabled(items, value) {
        [value]
      } else {
        []
      }
    Multiple => {
      let values : Array[String] = []
      for value in default_values {
        if accordion_entry_enabled(items, value) && !values.contains(value) {
          values.push(value)
        }
      }
      values
    }
  }
}

///|
#cfg(target="js")
fn accordion_next_values(
  current : Array[String],
  value : String,
  type_ : AccordionType,
  collapsible : Bool,
) -> Array[String] {
  match type_ {
    Single =>
      if current.contains(value) {
        if collapsible {
          []
        } else {
          current
        }
      } else {
        [value]
      }
    Multiple =>
      if current.contains(value) {
        current.filter(item => item != value)
      } else {
        let next = current.copy()
        next.push(value)
        next
      }
  }
}

///|
/// Construct one black-box accordion entry.
pub fn accordion_entry(
  value~ : String,
  label~ : String,
  content~ : @html.Html,
  disabled? : Bool = false,
) -> AccordionEntry {
  { value, label, content, disabled, }
}

///|
/// Render the root for a composed accordion.
pub fn[C : @html.IsChildren] accordion_root(
  type_? : AccordionType = Single,
  disabled? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "accordion")
    .data_set("type", accordion_type_value(type_))
    .data_set("orientation", "vertical")
    .aria_disabled(ui_bool(disabled))
  if disabled {
    ignore(element_attrs.data_set("disabled", ""))
  }
  accordion_bind_keyboard(element_attrs)
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        AccordionRootStyle,
        ui_disabled_visual_style(disabled),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=element_attrs,
    children,
  )
}

///|
/// Render one accordion item container.
pub fn[C : @html.IsChildren] accordion_item(
  value~ : String,
  open? : Bool = false,
  disabled? : Bool = false,
  name? : String,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = accordion_state_attrs(attrs, "accordion-item", open)
    .data_set("value", value)
    .aria_disabled(ui_bool(disabled))
  if name is Some(name) {
    ignore(element_attrs.data_set("group", name))
  }
  if disabled {
    ignore(element_attrs.data_set("disabled", ""))
  }
  @html.div(
    style=ui_styles(
      [UiBoxSizing, AccordionItemStyle, ui_disabled_visual_style(disabled)],
      style,
    ),
    id?,
    class?,
    title?,
    attrs=element_attrs,
    children,
  )
}

///|
/// Render one native button accordion trigger.
pub fn[C : @html.IsChildren] accordion_trigger(
  value~ : String,
  open? : Bool = false,
  disabled? : Bool = false,
  controls? : String,
  show_indicator? : Bool = true,
  on_value_change? : @cmd.Emit[String],
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = accordion_state_attrs(attrs, "accordion-trigger", open)
    .data_set("value", value)
    .aria_expanded(ui_bool(open))
    .aria_disabled(ui_bool(disabled))
  if controls is Some(controls) {
    ignore(element_attrs.aria_controls(controls))
  }
  if disabled {
    ignore(element_attrs.data_set("disabled", "").tabindex(-1))
  }
  if !disabled && on_value_change is Some(emit) {
    accordion_bind_value_change(element_attrs, value, emit)
  }
  @html.button(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        AccordionTriggerStyle,
        if open {
          AccordionTriggerOpenStyle
        } else {
          ""
        },
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
    [
      @html.span(
        style=[UiBoxSizing, AccordionTriggerLabelStyle],
        attrs=@html.Attrs::build().data_set("slot", "accordion-trigger-label"),
        children,
      ),
      if show_indicator {
        accordion_indicator(open)
      } else {
        @html.nothing
      },
    ],
  )
}

///|
/// Render one accordion panel.
pub fn[C : @html.IsChildren] accordion_content(
  value~ : String,
  open? : Bool = false,
  force_mount? : Bool = false,
  labelledby? : String,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = accordion_state_attrs(attrs, "accordion-content", open)
    .data_set("value", value)
    .data_set("force-mount", ui_bool(force_mount))
    .role("region")
    .aria_hidden(ui_bool(!open))
    .inert(!open)
  if labelledby is Some(labelledby) {
    ignore(element_attrs.aria_labelledby(labelledby))
  }
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        AccordionContentOuterStyle,
        if open {
          AccordionContentOpenStyle
        } else {
          AccordionContentClosedStyle
        },
      ],
      style,
    ),
    id?,
    class?,
    title?,
    attrs=element_attrs,
    @html.div(
      style=[UiBoxSizing, AccordionContentClipStyle],
      attrs=@html.Attrs::build().data_set("slot", "accordion-content-clip"),
      @html.div(
        style=[UiBoxSizing, AccordionContentStyle],
        attrs=@html.Attrs::build().data_set("slot", "accordion-content-body"),
        children,
      ),
    ),
  )
}

///|
/// Render the current accordion state for the public incremental component.
fn render_accordion(
  items~ : Array[AccordionEntry],
  values~ : Array[String],
  type_? : AccordionType = Single,
  collapsible? : Bool = true,
  disabled? : Bool = false,
  show_indicator? : Bool = true,
  force_mount? : Bool = false,
  on_value_change? : @cmd.Emit[String],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  item_style? : Array[String] = [],
  trigger_style? : Array[String] = [],
  content_style? : Array[String] = [],
) -> @html.Html {
  let item_nodes : Array[@html.Html] = []
  for index, item in items {
    let open = values.contains(item.value)
    let item_disabled = disabled || item.disabled
    let trigger_id = id.map(id => "\{id}-trigger-\{index}")
    let content_id = id.map(id => "\{id}-content-\{index}")
    let group_name = if type_ is Single {
      id.map(id => "\{id}-group")
    } else {
      None
    }
    let trigger_html = {
      let controls = content_id
      let id = trigger_id
      accordion_trigger(
        value=item.value,
        open~,
        disabled=item_disabled,
        controls?,
        show_indicator~,
        on_value_change?,
        id?,
        style=trigger_style,
        item.label,
      )
    }
    let content_html = {
      let labelledby = trigger_id
      let id = content_id
      accordion_content(
        value=item.value,
        open~,
        force_mount~,
        labelledby?,
        id?,
        style=content_style,
        item.content,
      )
    }
    let item_html = {
      let name = group_name
      accordion_item(
        value=item.value,
        open~,
        disabled=item_disabled,
        name?,
        style=item_style,
        [trigger_html, content_html],
      )
    }
    item_nodes.push(item_html)
  }
  let root_attrs = ui_attrs(attrs).data_set("collapsible", ui_bool(collapsible))
  accordion_root(
    type_~,
    disabled~,
    id?,
    class?,
    title?,
    hidden?,
    attrs=root_attrs,
    style~,
    item_nodes,
  )
}

///|
/// Build a self-contained accordion with component-local incremental state.
#cfg(target="js")
pub fn accordion(
  items~ : Array[AccordionEntry],
  type_? : AccordionType = Single,
  collapsible? : Bool = true,
  disabled? : Bool = false,
  default_value? : String,
  default_values? : Array[String] = [],
  show_indicator? : Bool = true,
  force_mount? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  item_style? : Array[String] = [],
  trigger_style? : Array[String] = [],
  content_style? : Array[String] = [],
) -> @rabbita.Val[@html.Html] {
  let initial = accordion_initial_values(
    items, type_, default_value, default_values,
  )
  let (values, set_values) = @rabbita.create_variable(initial)
  let on_value_change = set_values.map(value => {
    current => accordion_next_values(current, value, type_, collapsible)
  })
  values.view(values => {
    render_accordion(
      items~,
      values~,
      type_~,
      collapsible~,
      disabled~,
      show_indicator~,
      force_mount~,
      on_value_change~,
      id?,
      class?,
      title?,
      hidden?,
      attrs?,
      style~,
      item_style~,
      trigger_style~,
      content_style~,
    )
  })
}

///|
/// Native/SSR fallback: render the requested initial selection as a constant
/// incremental value.
#cfg(not(target="js"))
pub fn accordion(
  items~ : Array[AccordionEntry],
  type_? : AccordionType = Single,
  collapsible? : Bool = true,
  disabled? : Bool = false,
  default_value? : String,
  default_values? : Array[String] = [],
  show_indicator? : Bool = true,
  force_mount? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  item_style? : Array[String] = [],
  trigger_style? : Array[String] = [],
  content_style? : Array[String] = [],
) -> @rabbita.Val[@html.Html] {
  let values = accordion_initial_values(
    items, type_, default_value, default_values,
  )
  @rabbita.Val::constant(
    render_accordion(
      items~,
      values~,
      type_~,
      collapsible~,
      disabled~,
      show_indicator~,
      force_mount~,
      id?,
      class?,
      title?,
      hidden?,
      attrs?,
      style~,
      item_style~,
      trigger_style~,
      content_style~,
    ),
  )
}
