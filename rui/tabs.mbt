///|
pub(all) enum TabsOrientation {
  TabsHorizontal
  TabsVertical
} derive(Debug, Eq)

///|
/// Visual treatment for a tabs list.
///
/// `TabsDefault` uses the compact muted surface. `TabsLine` removes that
/// surface and marks the active trigger with the Vega edge indicator.
pub(all) enum TabsListVariant {
  TabsDefault
  TabsLine
} derive(Debug, Eq)

///|
/// One entry for the self-contained tabs component.
///
/// Use `icon` for a leading graphic. Use the compound `tabs_*` functions
/// directly when a trigger needs richer content than an icon and text label.
struct TabEntry {
  value : String
  label : String
  icon : @html.Html?
  content : @html.Html
  disabled : Bool
}

///|
const TabsRootStyle : String = "display:flex;width:100%;min-width:0;color:var(--rui-foreground,oklch(0.145 0 0))"

///|
const TabsRootHorizontalStyle : String = "flex-direction:column;gap:0.5rem"

///|
const TabsRootVerticalStyle : String = "flex-direction:row;flex-wrap:wrap;align-items:flex-start;gap:0.75rem"

///|
const TabsListStyle : String = "display:inline-flex;width:fit-content;max-width:100%;align-items:center;justify-content:flex-start;padding:0.1875rem;color:var(--rui-muted-foreground,oklch(0.556 0 0))"

///|
const TabsListDefaultStyle : String = "gap:0.125rem;border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-muted,oklch(0.97 0 0));overflow-x:auto"

///|
const TabsListLineStyle : String = "gap:0.25rem;border-radius:0;background:transparent;overflow:visible"

///|
const TabsListHorizontalStyle : String = "min-height:2.25rem;flex-direction:row"

///|
const TabsListVerticalStyle : String = "min-width:min(9rem,100%);flex:0 1 9rem;flex-direction:column;align-items:stretch;overflow-x:visible"

///|
const TabsTriggerStyle : String = "display:inline-flex;min-width:0;min-height:1.75rem;flex:1;align-items:center;justify-content:center;gap:0.375rem;--rui-tabs-base-bg:transparent;--rui-tabs-base-fg:inherit;--rui-tabs-base-border:transparent;--rui-tabs-base-shadow:none;--rui-control-base-shadow:var(--rui-tabs-base-shadow,none);border:1px solid transparent;border-color:var(--rui-control-border,var(--rui-tabs-border,var(--rui-tabs-base-border,transparent)));border-radius:calc(var(--rui-radius,0.625rem) - 0.25rem);margin:0;padding:0.25rem 0.625rem;background:var(--rui-tabs-bg,var(--rui-tabs-base-bg,transparent));color:var(--rui-tabs-fg,var(--rui-tabs-base-fg,inherit));box-shadow:var(--rui-control-shadow,var(--rui-tabs-shadow,var(--rui-tabs-base-shadow,none)));font-size:0.875rem;line-height:1.25rem;font-weight:500;text-align:center;white-space:nowrap;cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline-offset:2px"

///|
const TabsTriggerActiveStyle : String = "--rui-tabs-base-border:var(--rui-tabs-active-border,transparent);--rui-tabs-base-bg:var(--rui-tabs-active-bg,var(--rui-background,oklch(1 0 0)));--rui-tabs-base-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-tabs-base-shadow:var(--rui-tabs-active-shadow,0 1px 2px rgb(0 0 0 / 0.05))"

///|
const TabsTriggerInactiveStyle : String = "--rui-tabs-base-bg:transparent;--rui-tabs-base-fg:var(--rui-muted-foreground,oklch(0.556 0 0));--rui-tabs-base-border:transparent;--rui-tabs-base-shadow:none"

///|
const TabsContentStyle : String = "display:block;min-width:0;flex:1;border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);color:var(--rui-foreground,oklch(0.145 0 0));font-size:0.875rem;line-height:1.5;outline-offset:2px"

///|
fn tabs_orientation_value(orientation : TabsOrientation) -> String {
  match orientation {
    TabsHorizontal => "horizontal"
    TabsVertical => "vertical"
  }
}

///|
fn tabs_root_orientation_style(orientation : TabsOrientation) -> String {
  match orientation {
    TabsHorizontal => TabsRootHorizontalStyle
    TabsVertical => TabsRootVerticalStyle
  }
}

///|
fn tabs_list_orientation_style(orientation : TabsOrientation) -> String {
  match orientation {
    TabsHorizontal => TabsListHorizontalStyle
    TabsVertical => TabsListVerticalStyle
  }
}

///|
fn tabs_list_variant_value(variant : TabsListVariant) -> String {
  match variant {
    TabsDefault => "default"
    TabsLine => "line"
  }
}

///|
fn tabs_list_variant_style(variant : TabsListVariant) -> String {
  match variant {
    TabsDefault => TabsListDefaultStyle
    TabsLine => TabsListLineStyle
  }
}

///|
fn tabs_state(selected : Bool) -> String {
  if selected {
    "active"
  } else {
    "inactive"
  }
}

///|
fn tabs_state_attrs(
  attrs : @html.Attrs?,
  slot : String,
  selected : Bool,
) -> @html.Attrs {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", slot)
    .data_set("state", tabs_state(selected))
  if selected {
    ignore(element_attrs.data_set("active", ""))
  } else {
    ignore(element_attrs.data_set("inactive", ""))
  }
  element_attrs
}

///|
#cfg(target="js")
fn tabs_move_focus(event : @dom.KeyboardEvent, orientation : String) -> Bool {
  if event.alt_key() ||
    event.ctrl_key() ||
    event.meta_key() ||
    event.shift_key() {
    return false
  }
  guard event.target().to_element() is Some(target) else { return false }
  guard target.closest("[role=\"tab\"]") is Some(current) else { return false }
  guard current.closest("[role=\"tablist\"]") is Some(list) else {
    return false
  }
  let key = event.key()
  if key == "Enter" || key == " " {
    if ui_element_is_enabled(current) {
      ui_click_element(current)
    }
    return true
  }
  guard ui_roving_context(
      event, "[role=\"tab\"]", "[role=\"tablist\"]", "[role=\"tab\"]",
    )
    is Some(context) else {
    return false
  }
  guard ui_roving_target(context, key, orientation, ui_element_is_rtl(list))
    is Some(next) else {
    return false
  }
  ui_focus_element(next)
  if !next.is_same_node(current.as_node()) {
    ui_click_element(next)
  }
  true
}

///|
#cfg(target="js")
fn tabs_bind_keyboard(
  attrs : @html.Attrs,
  orientation : TabsOrientation,
) -> Unit {
  ignore(
    attrs.on_keydown(event => {
      if tabs_move_focus(event, tabs_orientation_value(orientation)) {
        event.prevent_default()
      }
      @cmd.none
    }),
  )
}

///|
#cfg(not(target="js"))
fn tabs_bind_keyboard(
  attrs : @html.Attrs,
  orientation : TabsOrientation,
) -> Unit {
  ignore((attrs, orientation))
}

///|
fn tab_entry_enabled(items : Array[TabEntry], value : String) -> Bool {
  for item in items {
    if item.value == value {
      return !item.disabled
    }
  }
  false
}

///|
fn tabs_initial_value(
  items : Array[TabEntry],
  default_value : String?,
) -> String? {
  if default_value is Some(value) && tab_entry_enabled(items, value) {
    return Some(value)
  }
  for item in items {
    if !item.disabled {
      return Some(item.value)
    }
  }
  None
}

///|
fn tabs_focus_value(items : Array[TabEntry], value : String?) -> String? {
  if value is Some(value) && tab_entry_enabled(items, value) {
    return Some(value)
  }
  for item in items {
    if !item.disabled {
      return Some(item.value)
    }
  }
  None
}

///|
/// Construct one black-box tab entry.
pub fn tab_entry(
  value~ : String,
  label~ : String,
  icon? : @html.Html,
  content~ : @html.Html,
  disabled? : Bool = false,
) -> TabEntry {
  { value, label, icon, content, disabled, }
}

///|
fn tab_entry_trigger_content(item : TabEntry) -> @html.Html {
  match item.icon {
    Some(icon) =>
      @html.fragment([
        @html.span(
          attrs=@html.Attrs::build()
            .aria_hidden("true")
            .data_set("slot", "tabs-trigger-icon"),
          style=[
            "display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;pointer-events:none",
          ],
          icon,
        ),
        @html.text(item.label),
      ])
    None => @html.text(item.label)
  }
}

///|
/// Render the root for a composed tabs interface.
pub fn[C : @html.IsChildren] tabs_root(
  value? : String,
  orientation? : TabsOrientation = TabsHorizontal,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "tabs")
    .data_set("orientation", tabs_orientation_value(orientation))
  if value is Some(value) {
    ignore(element_attrs.data_set("value", value))
  }
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        TabsRootStyle,
        tabs_root_orientation_style(orientation),
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
/// Render the ARIA `tablist` container.
pub fn[C : @html.IsChildren] tabs_list(
  orientation? : TabsOrientation = TabsHorizontal,
  variant? : TabsListVariant = TabsDefault,
  aria_label? : String,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "tabs-list")
    .data_set("orientation", tabs_orientation_value(orientation))
    .data_set("variant", tabs_list_variant_value(variant))
    .role("tablist")
    .aria_orientation(tabs_orientation_value(orientation))
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  }
  tabs_bind_keyboard(element_attrs, orientation)
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        TabsListStyle,
        tabs_list_variant_style(variant),
        tabs_list_orientation_style(orientation),
      ],
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
/// Render one native button with ARIA tab semantics.
///
/// The browser supplies native focus plus Enter and Space activation. The
/// component appends its value request after any caller click handler stored
/// in `attrs`.
pub fn[C : @html.IsChildren] tabs_trigger(
  value~ : String,
  selected? : Bool = false,
  disabled? : Bool = false,
  tab_stop? : Bool,
  controls? : String,
  on_value_change? : @cmd.Emit[String],
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let tab_stop = tab_stop.unwrap_or(selected && !disabled)
  let element_attrs = tabs_state_attrs(attrs, "tabs-trigger", selected)
    .data_set("value", value)
    .role("tab")
    .aria_selected(ui_bool(selected))
    .aria_disabled(ui_bool(disabled))
    .tabindex(if tab_stop && !disabled { 0 } else { -1 })
  if controls is Some(controls) {
    ignore(element_attrs.aria_controls(controls))
  }
  if disabled {
    ignore(element_attrs.data_set("disabled", ""))
  }
  if !disabled && on_value_change is Some(emit) {
    ignore(element_attrs.on_click(_ => emit(value)))
  }
  @html.button(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        TabsTriggerStyle,
        if selected {
          TabsTriggerActiveStyle
        } else {
          TabsTriggerInactiveStyle
        },
        ui_disabled_visual_style(disabled),
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
/// Render one ARIA tab panel.
pub fn[C : @html.IsChildren] tabs_content(
  value~ : String,
  selected? : Bool = false,
  force_mount? : Bool = false,
  labelledby? : String,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = tabs_state_attrs(attrs, "tabs-content", selected)
    .data_set("value", value)
    .data_set("force-mount", ui_bool(force_mount))
    .role("tabpanel")
    .tabindex(0)
    .aria_hidden(ui_bool(!selected))
  if labelledby is Some(labelledby) {
    ignore(element_attrs.aria_labelledby(labelledby))
  }
  @html.div(
    style=ui_styles([UiBoxSizing, TabsContentStyle], style),
    id?,
    class?,
    title?,
    hidden=!selected,
    attrs=element_attrs,
    children,
  )
}

///|
/// Render the current tabs state for the public incremental component.
fn render_tabs(
  items~ : Array[TabEntry],
  value? : String,
  orientation? : TabsOrientation = TabsHorizontal,
  list_variant? : TabsListVariant = TabsDefault,
  aria_label? : String,
  force_mount? : Bool = false,
  on_value_change? : @cmd.Emit[String],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  list_attrs? : @html.Attrs,
  style? : Array[String] = [],
  list_style? : Array[String] = [],
  trigger_style? : Array[String] = [],
  content_style? : Array[String] = [],
) -> @html.Html {
  let trigger_nodes : Array[@html.Html] = []
  let content_nodes : Array[@html.Html] = []
  let focus_value = tabs_focus_value(items, value)
  for index, item in items {
    let selected = !item.disabled && value == Some(item.value)
    let tab_stop = focus_value == Some(item.value)
    let trigger_id = id.map(id => "\{id}-trigger-\{index}")
    let content_id = id.map(id => "\{id}-content-\{index}")
    let trigger_html = {
      let controls = content_id
      let id = trigger_id
      tabs_trigger(
        value=item.value,
        selected~,
        disabled=item.disabled,
        tab_stop~,
        controls?,
        on_value_change?,
        id?,
        style=trigger_style,
        tab_entry_trigger_content(item),
      )
    }
    let content_html = {
      let labelledby = trigger_id
      let id = content_id
      tabs_content(
        value=item.value,
        selected~,
        force_mount~,
        labelledby?,
        id?,
        style=content_style,
        item.content,
      )
    }
    trigger_nodes.push(trigger_html)
    content_nodes.push(content_html)
  }
  let list = {
    let attrs = list_attrs
    tabs_list(
      orientation~,
      variant=list_variant,
      aria_label?,
      attrs?,
      style=list_style,
      trigger_nodes,
    )
  }
  tabs_root(
    value?,
    orientation~,
    id?,
    class?,
    title?,
    hidden?,
    attrs?,
    style~,
    [list, @html.fragment(content_nodes)],
  )
}

///|
/// Build a self-contained tabs interface with component-local incremental
/// state.
#cfg(target="js")
pub fn tabs(
  items~ : Array[TabEntry],
  default_value? : String,
  orientation? : TabsOrientation = TabsHorizontal,
  list_variant? : TabsListVariant = TabsDefault,
  aria_label? : String,
  force_mount? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  list_attrs? : @html.Attrs,
  style? : Array[String] = [],
  list_style? : Array[String] = [],
  trigger_style? : Array[String] = [],
  content_style? : Array[String] = [],
) -> @rabbita.Val[@html.Html] {
  let (value, set_value) = @rabbita.create_variable(
    tabs_initial_value(items, default_value),
  )
  let on_value_change = set_value.map(next => _ => Some(next))
  value.view(value => {
    render_tabs(
      items~,
      value?,
      orientation~,
      list_variant~,
      aria_label?,
      force_mount~,
      on_value_change~,
      id?,
      class?,
      title?,
      hidden?,
      attrs?,
      list_attrs?,
      style~,
      list_style~,
      trigger_style~,
      content_style~,
    )
  })
}

///|
/// Native/SSR fallback: render the requested initial selection as a constant
/// incremental value.
#cfg(not(target="js"))
pub fn tabs(
  items~ : Array[TabEntry],
  default_value? : String,
  orientation? : TabsOrientation = TabsHorizontal,
  list_variant? : TabsListVariant = TabsDefault,
  aria_label? : String,
  force_mount? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  list_attrs? : @html.Attrs,
  style? : Array[String] = [],
  list_style? : Array[String] = [],
  trigger_style? : Array[String] = [],
  content_style? : Array[String] = [],
) -> @rabbita.Val[@html.Html] {
  let value = tabs_initial_value(items, default_value)
  @rabbita.Val::constant(
    render_tabs(
      items~,
      value?,
      orientation~,
      list_variant~,
      aria_label?,
      force_mount~,
      id?,
      class?,
      title?,
      hidden?,
      attrs?,
      list_attrs?,
      style~,
      list_style~,
      trigger_style~,
      content_style~,
    ),
  )
}
