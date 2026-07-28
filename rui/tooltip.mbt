///|
const TooltipProviderStyle : String = "display:contents"

///|
const TooltipRootStyle : String = "display:contents"

///|
const TooltipContentStyle : String = "position:fixed;inset:auto;left:var(--rui-floating-left,auto);top:var(--rui-floating-top,auto);z-index:50;display:flex;width:max-content;max-width:calc(100vw - 1rem);transform-origin:var(--rui-floating-transform-origin,center);align-items:center;margin:0;border:0;border-radius:calc(var(--rui-radius,0.625rem) - 0.25rem);background:var(--rui-primary,oklch(0.205 0 0));padding:0.375rem 0.75rem;color:var(--rui-primary-foreground,oklch(0.985 0 0));font-size:0.75rem;line-height:1rem;font-weight:400;text-wrap:balance;box-shadow:0 4px 6px -1px rgb(0 0 0 / 0.1),0 2px 4px -2px rgb(0 0 0 / 0.1);outline:none;transition:opacity 100ms ease,transform 100ms ease,visibility 100ms ease"

///|
const TooltipArrowBaseStyle : String = "position:absolute;z-index:-1;top:var(--rui-tooltip-arrow-top,auto);right:var(--rui-tooltip-arrow-right,auto);bottom:var(--rui-tooltip-arrow-bottom,auto);left:var(--rui-tooltip-arrow-left,auto);width:0.625rem;height:0.625rem;margin-top:var(--rui-tooltip-arrow-margin-top,0);margin-left:var(--rui-tooltip-arrow-margin-left,0);border-radius:2px;background:var(--rui-primary,oklch(0.205 0 0));transform:rotate(45deg)"

///|
fn tooltip_delay(value : Int) -> Int {
  if value < 0 {
    0
  } else {
    value
  }
}

///|
fn tooltip_arrow_side_style(side : PopupSide) -> String {
  match side {
    Top =>
      "--rui-tooltip-arrow-top:auto;--rui-tooltip-arrow-right:auto;--rui-tooltip-arrow-bottom:-0.25rem;--rui-tooltip-arrow-left:50%;--rui-tooltip-arrow-margin-top:0;--rui-tooltip-arrow-margin-left:-0.3125rem"
    Right =>
      "--rui-tooltip-arrow-top:50%;--rui-tooltip-arrow-right:auto;--rui-tooltip-arrow-bottom:auto;--rui-tooltip-arrow-left:-0.25rem;--rui-tooltip-arrow-margin-top:-0.3125rem;--rui-tooltip-arrow-margin-left:0"
    Bottom =>
      "--rui-tooltip-arrow-top:-0.25rem;--rui-tooltip-arrow-right:auto;--rui-tooltip-arrow-bottom:auto;--rui-tooltip-arrow-left:50%;--rui-tooltip-arrow-margin-top:0;--rui-tooltip-arrow-margin-left:-0.3125rem"
    Left =>
      "--rui-tooltip-arrow-top:50%;--rui-tooltip-arrow-right:-0.25rem;--rui-tooltip-arrow-bottom:auto;--rui-tooltip-arrow-left:auto;--rui-tooltip-arrow-margin-top:-0.3125rem;--rui-tooltip-arrow-margin-left:0"
  }
}

///|
/// Supply shared open and close delays to descendant tooltips.
///
/// shadcn's Vega preset opens without a wait, so `delay` defaults to zero.
/// `timeout` is the instant-phase window: moving between tooltips within
/// that period bypasses a non-zero opening delay. An individual `tooltip` can
/// override the opening or closing delay.
pub fn[C : @html.IsChildren] tooltip_provider(
  delay? : Int = 0,
  close_delay? : Int = 0,
  timeout? : Int = 400,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let actual_delay = tooltip_delay(delay)
  let actual_close_delay = tooltip_delay(close_delay)
  let actual_timeout = tooltip_delay(timeout)
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "tooltip-provider")
    .data_set("delay", "\{actual_delay}")
    .data_set("close-delay", "\{actual_close_delay}")
    .data_set("timeout", "\{actual_timeout}")
  @html.span(
    style=ui_styles([UiBoxSizing, TooltipProviderStyle], style),
    id?,
    class?,
    title?,
    attrs=element_attrs,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] tooltip_trigger(
  content_id~ : String,
  open? : Bool = false,
  disabled? : Bool = false,
  variant? : ButtonVariant = Ghost,
  size? : ButtonSize = Default,
  on_click? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let resolved_id = id.unwrap_or(content_id + "-trigger")
  let element_attrs = popup_state_attrs(attrs, "tooltip-trigger", open)
    .data_set("variant", button_variant_value(variant))
    .data_set("size", button_size_value(size))
  if open {
    ignore(element_attrs.aria_describedby(content_id))
  }
  if disabled {
    ignore(element_attrs.aria_disabled("true").data_set("disabled", ""))
  }
  if on_click is Some(command) {
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
pub fn tooltip_arrow(
  side? : PopupSide = Top,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  @html.span(
    style=ui_styles(
      [UiBoxSizing, TooltipArrowBaseStyle, tooltip_arrow_side_style(side)],
      style,
    ),
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "tooltip-arrow").aria_hidden("true"),
    @html.nothing,
  )
}

///|
pub fn[C : @html.IsChildren] tooltip_content(
  id~ : String,
  trigger_id~ : String,
  open? : Bool = false,
  side? : PopupSide = Top,
  align? : PopupAlign = Center,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  show_arrow? : Bool = true,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  arrow_attrs? : @html.Attrs,
  style? : Array[String] = [],
  arrow_style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = popup_state_attrs(attrs, "tooltip-content", open)
    .popover("manual")
    .role("tooltip")
    .data_set("initial-focus", "false")
    .data_set("restore-focus", "false")
    .data_set("trigger-id", trigger_id)
    .data_set("requested-side", popup_side_value(side))
    .data_set("requested-align", popup_align_value(align))
    .data_set("side", popup_side_value(side))
    .data_set("align", popup_align_value(align))
    .data_set("side-offset", "\{side_offset}")
    .data_set("align-offset", "\{align_offset}")
    .data_set("collision-padding", "0")
    .data_set("sticky", "partial")
  let body = @html.span(
    style=[UiBoxSizing, "display:contents"],
    attrs=@html.Attrs::build().data_set("slot", "tooltip-content-body"),
    children,
  )
  let content_children = if show_arrow {
    [
      body,
      @html.span(
        style=ui_styles([UiBoxSizing, TooltipArrowBaseStyle], arrow_style),
        attrs=ui_attrs(arrow_attrs)
          .data_set("slot", "tooltip-arrow")
          .aria_hidden("true"),
        @html.nothing,
      ),
    ]
  } else {
    [body]
  }
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        TooltipContentStyle,
        PopupTransition100Style,
        popup_floating_anchor_style(
          trigger_id, side, align, side_offset, align_offset,
        ),
        tooltip_arrow_side_style(side),
        popup_state_style(open),
      ],
      style,
    ),
    id~,
    class?,
    title?,
    attrs=element_attrs,
    content_children,
  )
}

///|
#cfg(target="js")
priv struct TooltipEventBinding {
  popup : @dom.Element
  trigger : @dom.Element
  root : @dom.Element
  sidebar : @dom.Element?
  dispatch : Ref[(Int, Int) -> Unit]
  sidebar_observer : Ref[@dom.MutationObserver?]
}

///|
#cfg(target="js")
let tooltip_event_bindings : Map[String, TooltipEventBinding] = Map([])

///|
#cfg(target="js")
let tooltip_bound_document : Ref[@dom.Document?] = Ref(None)

///|
#cfg(target="js")
fn tooltip_live_binding(id : String) -> TooltipEventBinding? {
  guard tooltip_event_bindings.get(id) is Some(binding) else { return None }
  guard binding.popup.get_is_connected() &&
    binding.trigger.get_is_connected() &&
    binding.root.get_is_connected() else {
    ignore(tooltip_event_bindings.remove(id))
    return None
  }
  guard ui_element_by_id(id) is Some(popup) &&
    floating_same_element(binding.popup, popup) else {
    ignore(tooltip_event_bindings.remove(id))
    return None
  }
  Some(binding)
}

///|
#cfg(target="js")
fn tooltip_binding_provider(binding : TooltipEventBinding) -> @dom.Element? {
  binding.root.closest("[data-slot=\"tooltip-provider\"]")
}

///|
#cfg(target="js")
fn tooltip_number_config(
  binding : TooltipEventBinding,
  name : String,
  fallback : Int,
) -> Int {
  let attribute = "data-" + name
  let value = if binding.root.has_attribute(attribute) {
    binding.root.get_attribute(attribute).unwrap_or("")
  } else if tooltip_binding_provider(binding) is Some(provider) &&
    provider.has_attribute(attribute) {
    provider.get_attribute(attribute).unwrap_or("")
  } else {
    ""
  }
  ui_parse_int_or(value, fallback).max(0)
}

///|
#cfg(target="js")
fn tooltip_content_is_open(element : @dom.Element) -> Bool {
  let id = element.get_attribute("id").unwrap_or("")
  if floating_live_layer(id) is Some(layer) {
    floating_layer_is_open(layer)
  } else {
    element.get_attribute("data-state").unwrap_or("") == "open"
  }
}

///|
#cfg(target="js")
fn tooltip_open_delay(binding : TooltipEventBinding) -> Int {
  let configured = tooltip_number_config(binding, "delay", 0)
  guard tooltip_binding_provider(binding) is Some(provider) else {
    return configured
  }
  if configured <= 0 {
    return configured
  }
  let timeout = ui_parse_int_or(
    provider.get_attribute("data-timeout").unwrap_or(""),
    400,
  ).max(0)
  let mut has_open = false
  for content in provider.query_selector_all("[data-slot=\"tooltip-content\"]") {
    if tooltip_content_is_open(content) {
      has_open = true
    }
  }
  let instant = if tooltip_provider_last_close(provider) is Some(closed_at) &&
    ui_has_window() {
    @dom.window().get_performance().now() - closed_at <= timeout.to_double()
  } else {
    false
  }
  if has_open || instant {
    0
  } else {
    configured
  }
}

///|
#cfg(target="js")
fn tooltip_can_open(binding : TooltipEventBinding) -> Bool {
  if binding.root.get_attribute("data-sidebar-collapsed-only").unwrap_or("") !=
    "true" {
    return true
  }
  if binding.sidebar is Some(sidebar) {
    sidebar.get_attribute("data-collapsible").unwrap_or("") == "icon" &&
    sidebar.get_attribute("data-state").unwrap_or("") == "collapsed" &&
    sidebar.get_attribute("data-mobile").unwrap_or("") != "true"
  } else {
    false
  }
}

///|
#cfg(target="js")
fn tooltip_send(binding : TooltipEventBinding, kind : Int, wait : Int) -> Unit {
  let opening = kind == 0 || kind == 2 || kind == 5
  if opening &&
    (!ui_element_is_enabled(binding.trigger) || !tooltip_can_open(binding)) {
    return
  }
  (binding.dispatch.val)(kind, wait)
}

///|
#cfg(target="js")
fn tooltip_top_binding() -> TooltipEventBinding? {
  guard floating_top_layer() is Some(layer) else { return None }
  if layer.element.get_attribute("data-slot").unwrap_or("") != "tooltip-content" {
    return None
  }
  tooltip_live_binding(layer.id)
}

///|
#cfg(target="js")
fn tooltip_bind_document_events() -> Unit {
  let document = @dom.document()
  if tooltip_bound_document.val is Some(bound) &&
    bound.to_node().is_same_node(document.to_node()) {
    return
  }
  tooltip_bound_document.val = Some(document)
  document.add_event_listener("keydown", event => {
    guard event.to_keyboard_event() is Some(keyboard) else { return }
    if keyboard.key() != "Escape" || event.get_default_prevented() {
      return
    }
    guard tooltip_top_binding() is Some(binding) else { return }
    event.prevent_default()
    event.stop_propagation()
    tooltip_send(binding, 7, 0)
  })
  document.add_event_listener("pointerdown", event => {
    if event.get_default_prevented() {
      return
    }
    guard tooltip_top_binding() is Some(binding) else { return }
    if floating_event_inside(event, binding.popup) ||
      floating_event_inside(event, binding.trigger) {
      return
    }
    tooltip_send(binding, 8, 0)
  })
}

///|
#cfg(target="js")
fn bind_tooltip_events_for_trigger(
  id : String,
  trigger_id : String,
  root_id : String,
  dispatch : (Int, Int) -> Unit,
) -> Bool {
  guard ui_has_document() else { return false }
  guard ui_element_by_id(id) is Some(popup) else { return false }
  guard ui_element_by_id(trigger_id) is Some(trigger) else { return false }
  guard ui_element_by_id(root_id) is Some(root) else { return false }
  if !popup.get_is_connected() ||
    !trigger.get_is_connected() ||
    !root.get_is_connected() {
    return false
  }
  if tooltip_event_bindings.get(id) is Some(binding) &&
    floating_same_element(binding.popup, popup) &&
    floating_same_element(binding.trigger, trigger) &&
    floating_same_element(binding.root, root) {
    binding.dispatch.val = dispatch
    return true
  }
  if tooltip_event_bindings.get(id) is Some(previous) &&
    previous.sidebar_observer.val is Some(observer) {
    observer.disconnect()
  }
  let sidebar = if root
    .get_attribute("data-sidebar-collapsed-only")
    .unwrap_or("") ==
    "true" {
    trigger.closest("[data-slot=\"sidebar\"]")
  } else {
    None
  }
  let binding : TooltipEventBinding = {
    popup,
    trigger,
    root,
    sidebar,
    dispatch: Ref(dispatch),
    sidebar_observer: Ref(None),
  }
  tooltip_event_bindings[id] = binding
  trigger.add_event_listener("mouseenter", _ => {
    tooltip_send(binding, 0, tooltip_open_delay(binding))
  })
  trigger.add_event_listener("mouseleave", _ => {
    let hover_grace = if root.get_attribute("data-hoverable").unwrap_or("") ==
      "true" {
      80
    } else {
      0
    }
    tooltip_send(
      binding,
      1,
      tooltip_number_config(binding, "close-delay", 0).max(hover_grace),
    )
  })
  trigger.add_event_listener("focus", _ => {
    if trigger.matches(":focus-visible") {
      tooltip_send(binding, 2, 0)
    }
  })
  trigger.add_event_listener("blur", _ => {
    tooltip_send(binding, 3, tooltip_number_config(binding, "close-delay", 0))
  })
  trigger.add_event_listener("click", _ => {
    if root.get_attribute("data-close-on-click").unwrap_or("") == "true" {
      tooltip_send(binding, 4, 0)
    }
  })
  popup.add_event_listener("mouseenter", _ => {
    if root.get_attribute("data-hoverable").unwrap_or("") == "true" {
      tooltip_send(binding, 5, 0)
    }
  })
  popup.add_event_listener("mouseleave", _ => {
    if root.get_attribute("data-hoverable").unwrap_or("") == "true" {
      tooltip_send(binding, 6, tooltip_number_config(binding, "close-delay", 0))
    }
  })
  if sidebar is Some(sidebar_element) {
    let observer = @dom.MutationObserver::new((_records, _observer) => {
      if !tooltip_can_open(binding) {
        tooltip_send(binding, 9, 0)
      }
    })
    observer.observe(sidebar_element.as_node(), attributes=true, attribute_filter=[
      "data-collapsible", "data-state", "data-mobile",
    ])
    binding.sidebar_observer.val = Some(observer)
  }
  if !tooltip_can_open(binding) {
    tooltip_send(binding, 9, 0)
  }
  tooltip_bind_document_events()
  true
}

///|
#cfg(target="js")
fn bind_tooltip_events(id : String, dispatch : (Int, Int) -> Unit) -> Bool {
  bind_tooltip_events_for_trigger(id, id + "-trigger", id + "-root", dispatch)
}

///|
#cfg(target="js")
priv struct TooltipModel {
  open : Bool
  trigger_hovered : Bool
  trigger_focused : Bool
  content_hovered : Bool
  generation : Int
} derive(Eq)

///|
#cfg(target="js")
priv enum TooltipMsg {
  TooltipDomEvent(Int, Int)
  TooltipOpenAfter(Int)
  TooltipCloseAfter(Int)
  TooltipNativeChanged(Bool)
}

///|
#cfg(target="js")
fn tooltip_is_active(model : TooltipModel) -> Bool {
  model.trigger_hovered || model.trigger_focused || model.content_hovered
}

///|
#cfg(target="js")
fn tooltip_notify_cmd(
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
#cfg(target="js")
fn tooltip_commit_open(
  id : String,
  on_open_change : @cmd.Emit[Bool]?,
  model : TooltipModel,
  open : Bool,
) -> (TooltipModel, @cmd.Cmd) {
  if model.open == open {
    (model, @cmd.none)
  } else {
    (
      { ..model, open, },
      @cmd.batch([
        floating_set_open_cmd(id, open),
        tooltip_notify_cmd(on_open_change, open),
      ]),
    )
  }
}

///|
#cfg(target="js")
fn tooltip_commit_native(
  on_open_change : @cmd.Emit[Bool]?,
  model : TooltipModel,
  open : Bool,
) -> (TooltipModel, @cmd.Cmd) {
  if open {
    if model.open {
      (model, @cmd.none)
    } else {
      ({ ..model, open: true }, tooltip_notify_cmd(on_open_change, true))
    }
  } else {
    let next : TooltipModel = {
      open: false,
      trigger_hovered: false,
      trigger_focused: false,
      content_hovered: false,
      generation: model.generation + 1,
    }
    if model.open {
      (next, tooltip_notify_cmd(on_open_change, false))
    } else {
      (next, @cmd.none)
    }
  }
}

///|
#cfg(target="js")
fn tooltip_bind_events_cmd(
  id : String,
  emit : @cmd.Emit[TooltipMsg],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, scheduler => {
    ui_after_ready("tooltip-events:" + id, () => {
      bind_tooltip_events(id, (kind, wait) => {
        scheduler.add(emit(TooltipDomEvent(kind, wait)))
      })
    })
  })
}

///|
#cfg(target="js")
fn tooltip_bind_trigger_events_cmd(
  id : String,
  trigger_id : String,
  root_id : String,
  emit : @cmd.Emit[TooltipMsg],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, scheduler => {
    ui_after_ready("tooltip-events:" + id, () => {
      bind_tooltip_events_for_trigger(id, trigger_id, root_id, (kind, wait) => {
        scheduler.add(emit(TooltipDomEvent(kind, wait)))
      })
    })
  })
}

///|
#cfg(target="js")
fn tooltip_update(
  id : String,
  close_on_click : Bool,
  on_open_change : @cmd.Emit[Bool]?,
  emit : @cmd.Emit[TooltipMsg],
  msg : TooltipMsg,
  current : TooltipModel,
) -> (TooltipModel, @cmd.Cmd) {
  match msg {
    TooltipDomEvent(kind, wait) =>
      match kind {
        // Trigger hover starts after the configured provider/root delay.
        0 => {
          let generation = current.generation + 1
          let next = { ..current, trigger_hovered: true, generation }
          if current.open {
            (next, @cmd.none)
          } else if wait <= 0 {
            tooltip_commit_open(id, on_open_change, next, true)
          } else {
            (next, @cmd.delay(emit(TooltipOpenAfter(generation)), wait))
          }
        }
        // Trigger hover ends; popup hover can cancel this delayed close.
        1 => {
          let generation = current.generation + 1
          let next = { ..current, trigger_hovered: false, generation }
          if tooltip_is_active(next) || !next.open {
            (next, @cmd.none)
          } else if wait <= 0 {
            tooltip_commit_open(id, on_open_change, next, false)
          } else {
            (next, @cmd.delay(emit(TooltipCloseAfter(generation)), wait))
          }
        }
        // Keyboard/programmatic focus opens immediately.
        2 => {
          let next = {
            ..current,
            trigger_focused: true,
            generation: current.generation + 1,
          }
          tooltip_commit_open(id, on_open_change, next, true)
        }
        3 => {
          let generation = current.generation + 1
          let next = { ..current, trigger_focused: false, generation }
          if tooltip_is_active(next) || !next.open {
            (next, @cmd.none)
          } else if wait <= 0 {
            tooltip_commit_open(id, on_open_change, next, false)
          } else {
            (next, @cmd.delay(emit(TooltipCloseAfter(generation)), wait))
          }
        }
        // Click-to-dismiss remains configurable.
        4 =>
          if close_on_click {
            tooltip_commit_open(
              id,
              on_open_change,
              {
                ..current,
                trigger_hovered: false,
                trigger_focused: false,
                content_hovered: false,
                generation: current.generation + 1,
              },
              false,
            )
          } else {
            (current, @cmd.none)
          }
        5 =>
          (
            {
              ..current,
              content_hovered: true,
              generation: current.generation + 1,
            },
            @cmd.none,
          )
        6 => {
          let generation = current.generation + 1
          let next = { ..current, content_hovered: false, generation }
          if tooltip_is_active(next) || !next.open {
            (next, @cmd.none)
          } else if wait <= 0 {
            tooltip_commit_open(id, on_open_change, next, false)
          } else {
            (next, @cmd.delay(emit(TooltipCloseAfter(generation)), wait))
          }
        }
        // Only the top floating layer dispatches Escape/outside dismissal.
        _ =>
          tooltip_commit_open(
            id,
            on_open_change,
            {
              ..current,
              trigger_hovered: false,
              trigger_focused: false,
              content_hovered: false,
              generation: current.generation + 1,
            },
            false,
          )
      }
    TooltipOpenAfter(generation) =>
      if generation == current.generation && tooltip_is_active(current) {
        tooltip_commit_open(id, on_open_change, current, true)
      } else {
        (current, @cmd.none)
      }
    TooltipCloseAfter(generation) =>
      if generation == current.generation && !tooltip_is_active(current) {
        tooltip_commit_open(id, on_open_change, current, false)
      } else {
        (current, @cmd.none)
      }
    TooltipNativeChanged(open) =>
      tooltip_commit_native(on_open_change, current, open)
  }
}

///|
fn[T : @html.IsChildren, C : @html.IsChildren] render_tooltip(
  id : String,
  open : Bool,
  disabled : Bool,
  delay : Int?,
  close_delay : Int?,
  close_on_click : Bool,
  hoverable : Bool,
  side : PopupSide,
  align : PopupAlign,
  side_offset : Int,
  align_offset : Int,
  show_arrow : Bool,
  trigger_variant : ButtonVariant,
  trigger_size : ButtonSize,
  attrs : @html.Attrs?,
  style : Array[String],
  trigger_attrs : @html.Attrs?,
  trigger_style : Array[String],
  content_attrs : @html.Attrs?,
  content_style : Array[String],
  arrow_attrs : @html.Attrs?,
  arrow_style : Array[String],
  on_trigger_click : @cmd.Cmd?,
  trigger : T,
  content : C,
) -> @html.Html {
  let root_id = id + "-root"
  let trigger_id = id + "-trigger"
  let root_attrs = popup_state_attrs(attrs, "tooltip", open)
    .data_set("close-on-click", ui_bool(close_on_click))
    .data_set("hoverable", ui_bool(hoverable))
  if delay is Some(delay) {
    ignore(root_attrs.data_set("delay", "\{delay}"))
  }
  if close_delay is Some(close_delay) {
    ignore(root_attrs.data_set("close-delay", "\{close_delay}"))
  }
  let on_click = on_trigger_click
  let trigger_element_attrs = trigger_attrs
  let popup_attrs = content_attrs
  @html.span(
    style=ui_styles([UiBoxSizing, TooltipRootStyle], style),
    id=root_id,
    attrs=root_attrs,
    [
      tooltip_trigger(
        content_id=id,
        open~,
        disabled~,
        variant=trigger_variant,
        size=trigger_size,
        on_click?,
        id=trigger_id,
        attrs?=trigger_element_attrs,
        style=trigger_style,
        trigger,
      ),
      tooltip_content(
        id~,
        trigger_id~,
        open~,
        side~,
        align~,
        side_offset~,
        align_offset~,
        show_arrow~,
        attrs?=popup_attrs,
        arrow_attrs?,
        style=content_style,
        arrow_style~,
        content,
      ),
    ],
  )
}

///|
/// Imperatively open a mounted tooltip. The owning incremental component
/// receives the resulting native `toggle` event and synchronizes its state.
pub fn tooltip_open(id : String) -> @cmd.Cmd {
  floating_set_open_cmd(id, true)
}

///|
pub fn tooltip_close(id : String) -> @cmd.Cmd {
  floating_set_open_cmd(id, false)
}

///|
pub fn tooltip_toggle(id : String) -> @cmd.Cmd {
  floating_toggle_cmd(id)
}

///|
/// Build a black-box tooltip with Rabbita-owned incremental interaction state.
///
/// Hover, keyboard focus, click dismissal, Escape, hoverable content, provider
/// delays, and native Popover top-layer synchronization are handled internally.
#cfg(target="js")
pub fn[T : @html.IsChildren, C : @html.IsChildren] tooltip(
  id~ : String,
  default_open? : Bool = false,
  disabled? : Bool = false,
  delay? : Int,
  close_delay? : Int,
  close_on_click? : Bool = true,
  hoverable? : Bool = true,
  side? : PopupSide = Top,
  align? : PopupAlign = Center,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  show_arrow? : Bool = true,
  trigger_variant? : ButtonVariant = Ghost,
  trigger_size? : ButtonSize = Default,
  on_open_change? : @cmd.Emit[Bool],
  on_trigger_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  trigger_attrs? : @html.Attrs,
  trigger_style? : Array[String] = [],
  content_attrs? : @html.Attrs,
  content_style? : Array[String] = [],
  arrow_attrs? : @html.Attrs,
  arrow_style? : Array[String] = [],
  trigger : T,
  content : C,
) -> @rabbita.Val[@html.Html] {
  let initial_open = default_open && !disabled
  let initial_model : TooltipModel = {
    open: initial_open,
    trigger_hovered: false,
    trigger_focused: false,
    content_hovered: false,
    generation: 0,
  }
  let (model, _) = @rabbita.create_state_with_init(
    init=emit => {
      let sync = emit.map(value => TooltipNativeChanged(value))
      (
        initial_model,
        @cmd.batch([
          floating_bind_sync_cmd(id, sync),
          tooltip_bind_events_cmd(id, emit),
          if initial_open {
            floating_set_open_cmd(id, true)
          } else {
            @cmd.none
          },
        ]),
      )
    },
    update=(current, msg, emit) => {
      tooltip_update(id, close_on_click, on_open_change, emit, msg, current)
    },
  )
  model.view(model => {
    render_tooltip(
      id,
      model.open,
      disabled,
      delay,
      close_delay,
      close_on_click,
      hoverable,
      side,
      align,
      side_offset,
      align_offset,
      show_arrow,
      trigger_variant,
      trigger_size,
      attrs,
      style,
      trigger_attrs,
      trigger_style,
      content_attrs,
      content_style,
      arrow_attrs,
      arrow_style,
      on_trigger_click,
      trigger,
      content,
    )
  })
}

///|
/// Native/SSR fallback: render the requested initial state. Browser event and
/// top-layer behavior is enabled by the JavaScript target.
#cfg(not(target="js"))
pub fn[T : @html.IsChildren, C : @html.IsChildren] tooltip(
  id~ : String,
  default_open? : Bool = false,
  disabled? : Bool = false,
  delay? : Int,
  close_delay? : Int,
  close_on_click? : Bool = true,
  hoverable? : Bool = true,
  side? : PopupSide = Top,
  align? : PopupAlign = Center,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  show_arrow? : Bool = true,
  trigger_variant? : ButtonVariant = Ghost,
  trigger_size? : ButtonSize = Default,
  on_open_change? : @cmd.Emit[Bool],
  on_trigger_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  trigger_attrs? : @html.Attrs,
  trigger_style? : Array[String] = [],
  content_attrs? : @html.Attrs,
  content_style? : Array[String] = [],
  arrow_attrs? : @html.Attrs,
  arrow_style? : Array[String] = [],
  trigger : T,
  content : C,
) -> @rabbita.Val[@html.Html] {
  ignore(on_open_change)
  @rabbita.Val::constant(
    render_tooltip(
      id,
      default_open && !disabled,
      disabled,
      delay,
      close_delay,
      close_on_click,
      hoverable,
      side,
      align,
      side_offset,
      align_offset,
      show_arrow,
      trigger_variant,
      trigger_size,
      attrs,
      style,
      trigger_attrs,
      trigger_style,
      content_attrs,
      content_style,
      arrow_attrs,
      arrow_style,
      on_trigger_click,
      trigger,
      content,
    ),
  )
}
