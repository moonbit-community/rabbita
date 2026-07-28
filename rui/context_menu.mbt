///|
struct ContextMenuScope {
  menu : MenuScope
  point_x : Int
  point_y : Int
}

///|
struct ContextMenuRadioGroupScope {
  menu : MenuScope
  group : String
}

///|
struct ContextMenuSubScope {
  menu : MenuScope
  key : String
}

///|
#cfg(target="js")
priv struct ContextMenuModel {
  menu : MenuCoreModel
  x : Int
  y : Int
  point_x : Int
  point_y : Int
} derive(Eq)

///|
#cfg(target="js")
priv enum ContextMenuMsg {
  ContextOpenAt(Int, Int, Int, Int)
  ContextSetOpen(Bool)
  ContextNativeOpen(Bool)
  ContextSetActive(Int)
  ContextToggleChecked(String)
  ContextSetRadio(String, String)
  ContextSetSubmenu(MenuSubmenuChange)
}

///|
fn context_menu_point_id(trigger_id : String) -> String {
  trigger_id + "-point"
}

///|
const ContextMenuPointStyle : String = "position:absolute;width:0;height:0;pointer-events:none"

///|
#cfg(target="js")
priv struct ContextMenuTriggerBinding {
  element : @dom.Element
  open_at : Ref[(Int, Int, Int, Int) -> Unit]
}

///|
#cfg(target="js")
let context_menu_trigger_bindings : Map[String, ContextMenuTriggerBinding] = Map([],
)

///|
#cfg(target="js")
fn context_menu_open_from_point(
  binding : ContextMenuTriggerBinding,
  client_x : Double,
  client_y : Double,
) -> Unit {
  let trigger = binding.element
  let rect = trigger.get_bounding_client_rect()
  let width = if trigger.get_client_width() > 0.0 {
    trigger.get_client_width()
  } else {
    rect.get_width()
  }
  let height = if trigger.get_client_height() > 0.0 {
    trigger.get_client_height()
  } else {
    rect.get_height()
  }
  let point_x = (client_x - rect.get_left() - trigger.get_client_left())
    .max(0.0)
    .min(width)
  let point_y = (client_y - rect.get_top() - trigger.get_client_top())
    .max(0.0)
    .min(height)
  (binding.open_at.val)(
    client_x.round().to_int(),
    client_y.round().to_int(),
    point_x.round().to_int(),
    point_y.round().to_int(),
  )
}

///|
#cfg(target="js")
fn bind_context_menu_trigger(
  id : String,
  open_at : (Int, Int, Int, Int) -> Unit,
) -> Unit {
  guard ui_element_by_id(id) is Some(trigger) else { return }
  if context_menu_trigger_bindings.get(id) is Some(binding) &&
    binding.element.is_same_node(trigger.as_node()) {
    binding.open_at.val = open_at
    return
  }
  let binding : ContextMenuTriggerBinding = {
    element: trigger,
    open_at: Ref(open_at),
  }
  context_menu_trigger_bindings[id] = binding
  trigger.add_event_listener("contextmenu", event => {
    if event.get_default_prevented() {
      return
    }
    guard event.to_mouse_event() is Some(mouse) else { return }
    event.prevent_default()
    context_menu_open_from_point(
      binding,
      mouse.get_client_x().to_double(),
      mouse.get_client_y().to_double(),
    )
  })
  trigger.add_event_listener("keydown", event => {
    if event.get_default_prevented() {
      return
    }
    guard event.to_keyboard_event() is Some(keyboard) else { return }
    let key = keyboard.key()
    if key != "ContextMenu" && !(keyboard.shift_key() && key == "F10") {
      return
    }
    event.prevent_default()
    let rect = trigger.get_bounding_client_rect()
    context_menu_open_from_point(
      binding,
      rect.get_left() + 8.0,
      rect.get_top() + 8.0,
    )
  })
}

///|
#cfg(target="js")
fn show_context_menu(
  id : String,
  x : Int,
  y : Int,
  point_x : Int,
  point_y : Int,
) -> Unit {
  guard ui_element_by_id(id) is Some(popup) else { return }
  guard popup.to_html_element() is Some(html) else { return }
  context_menu_cancel_exit(id)
  let trigger_id = popup.get_attribute("data-trigger-id").unwrap_or("")
  let point = ui_element_by_id(context_menu_point_id(trigger_id))
  if point is Some(point_element) &&
    point_element.to_html_element() is Some(point_html) {
    point_html.get_style().set_property("left", "\{point_x}px")
    point_html.get_style().set_property("top", "\{point_y}px")
  }
  let style = html.get_style()
  let position_area = style.get_property_value("position-area")
  let css_anchored = point is Some(_) &&
    @dom.CSS::supports("anchor-name", "--rui-anchor") &&
    @dom.CSS::supports("position-anchor", "--rui-anchor") &&
    @dom.CSS::supports("position-area", position_area) &&
    @dom.CSS::supports("position-try-fallbacks", "flip-inline")
  if css_anchored {
    ignore(style.remove_property("--rui-floating-left"))
    ignore(style.remove_property("--rui-floating-top"))
    popup.set_attribute("data-positioning", "css-anchor")
    popup.set_attribute("data-positioned", "true")
  } else {
    style.set_property("--rui-floating-left", "\{x.max(8)}px")
    style.set_property("--rui-floating-top", "\{y.max(8)}px")
    popup.set_attribute("data-positioning", "javascript-fallback")
  }
  popup.remove_attribute("hidden")
  if floating_live_layer(id) is None {
    bind_floating_sync(id, _ => ())
  }
  let already_open = if floating_live_layer(id) is Some(layer) {
    floating_layer_is_open(layer)
  } else {
    false
  }
  if !already_open && ui_has_window() {
    ignore(
      @dom.window().get_computed_style(popup).get_property_value("opacity"),
    )
  }
  ignore(set_floating_open(id, true))
  // The zero-size point inside the trigger is the primary anchor. It keeps the
  // pointer-relative placement attached during ancestor scrolling.
  if css_anchored {
    return
  }
  let rect = popup.get_bounding_client_rect()
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
  let clip_left = viewport_left + 8.0
  let clip_top = viewport_top + 8.0
  let clip_right = viewport_left + viewport_width - 8.0
  let clip_bottom = viewport_top + viewport_height - 8.0
  let left = x
    .to_double()
    .max(clip_left)
    .min((clip_right - rect.get_width()).max(clip_left))
  let top = y
    .to_double()
    .max(clip_top)
    .min((clip_bottom - rect.get_height()).max(clip_top))
  style.set_property("--rui-floating-left", "\{left.round().to_int()}px")
  style.set_property("--rui-floating-top", "\{top.round().to_int()}px")
  popup.set_attribute("data-positioned", "true")
}

///|
#cfg(target="js")
fn bind_context_menu_close(id : String, request_close : () -> Unit) -> Unit {
  if ui_element_by_id(id) is Some(_) {
    floating_set_request_close(id, request_close)
  }
}

///|
#cfg(target="js")
priv struct ContextMenuExitBinding {
  element : @dom.Element
  listener : Ref[@dom.Listener?]
  timeout : Ref[Int?]
}

///|
#cfg(target="js")
let context_menu_exit_bindings : Map[String, ContextMenuExitBinding] = Map([])

///|
#cfg(target="js")
fn context_menu_cancel_exit(id : String) -> Unit {
  guard context_menu_exit_bindings.get(id) is Some(binding) else { return }
  if binding.listener.val is Some(listener) {
    binding.element.remove_event_listener("transitionend", listener)
    binding.listener.val = None
  }
  if binding.timeout.val is Some(timeout) && ui_has_window() {
    @dom.window().clear_timeout(timeout)
    binding.timeout.val = None
  }
}

///|
#cfg(target="js")
fn context_menu_css_time_ms(value : String) -> Double {
  let text = "\{value.trim()}"
  let milliseconds = text.has_suffix("ms")
  let number_text = if milliseconds {
    text.replace(old="ms", new="")
  } else {
    text.replace(old="s", new="")
  }
  let parsed = ui_parse_double_or(number_text, 0.0)
  if milliseconds {
    parsed
  } else {
    parsed * 1000.0
  }
}

///|
#cfg(target="js")
fn context_menu_transition_duration(element : @dom.Element) -> Double {
  guard ui_has_window() else { return 0.0 }
  if @dom.window().match_media("(prefers-reduced-motion: reduce)").get_matches() {
    return 0.0
  }
  let style = @dom.window().get_computed_style(element)
  let durations : Array[Double] = []
  let delays : Array[Double] = []
  for duration in style.get_property_value("transition-duration").split(",") {
    durations.push(context_menu_css_time_ms("\{duration}"))
  }
  for delay in style.get_property_value("transition-delay").split(",") {
    delays.push(context_menu_css_time_ms("\{delay}"))
  }
  let mut total = 0.0
  for index, duration in durations {
    let delay = if delays.length() == 0 {
      0.0
    } else {
      delays[index % delays.length()]
    }
    total = total.max(duration + delay)
  }
  total
}

///|
#cfg(target="js")
fn hide_context_menu_after_transition(id : String) -> Unit {
  guard ui_element_by_id(id) is Some(popup) else { return }
  context_menu_cancel_exit(id)
  let binding : ContextMenuExitBinding = {
    element: popup,
    listener: Ref(None),
    timeout: Ref(None),
  }
  context_menu_exit_bindings[id] = binding
  fn finish() -> Unit {
    if popup.get_attribute("data-state").unwrap_or("") == "open" {
      return
    }
    context_menu_cancel_exit(id)
    ignore(set_floating_open(id, false))
  }

  let duration = context_menu_transition_duration(popup)
  if duration <= 0.0 || !ui_has_window() {
    finish()
    return
  }
  let listener : @dom.Listener = event => {
    guard event.target().to_node() is Some(target) else { return }
    if !popup.is_same_node(target) {
      return
    }
    guard ui_transition_event(event) is Some(transition) else { return }
    let property = transition.get_property_name()
    if property == "opacity" || property == "transform" {
      finish()
    }
  }
  binding.listener.val = Some(listener)
  popup.add_event_listener("transitionend", listener)
  binding.timeout.val = Some(
    @dom.window().set_timeout(finish, duration.ceil().to_int() + 34),
  )
}

///|
#cfg(target="js")
fn context_bind_trigger_cmd(
  trigger_id : String,
  content_id : String,
  open_at : @cmd.Emit[(Int, Int, Int, Int)],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, scheduler => {
    ui_after_mount(
      trigger_id,
      () => {
        bind_context_menu_trigger(trigger_id, (x, y, point_x, point_y) => {
          show_context_menu(content_id, x, y, point_x, point_y)
          scheduler.add(open_at((x, y, point_x, point_y)))
        })
      },
      purpose="context-menu-trigger-bind",
    )
  })
}

///|
#cfg(target="js")
fn context_bind_close_cmd(
  content_id : String,
  request_close : @cmd.Cmd,
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, scheduler => {
    ui_after_mount(
      content_id,
      () => {
        bind_context_menu_close(content_id, () => scheduler.add(request_close))
      },
      purpose="context-menu-close-bind",
    )
  })
}

///|
#cfg(target="js")
fn context_hide_after_transition_cmd(id : String) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, _ => {
    ui_after_mount(
      id,
      () => hide_context_menu_after_transition(id),
      purpose="context-menu-exit-transition",
    )
  })
}

///|
#cfg(not(target="js"))
fn context_bind_close_cmd(
  content_id : String,
  request_close : @cmd.Cmd,
) -> @cmd.Cmd {
  ignore((content_id, request_close))
  @cmd.none
}

///|
#cfg(not(target="js"))
fn context_hide_after_transition_cmd(id : String) -> @cmd.Cmd {
  ignore(id)
  @cmd.none
}

///|
#cfg(target="js")
fn context_show_cmd(
  id : String,
  x : Int,
  y : Int,
  point_x : Int,
  point_y : Int,
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, _ => {
    ui_after_mount(
      id,
      () => show_context_menu(id, x, y, point_x, point_y),
      purpose="context-menu-show",
    )
  })
}

///|
#cfg(not(target="js"))
fn context_show_cmd(
  id : String,
  x : Int,
  y : Int,
  point_x : Int,
  point_y : Int,
) -> @cmd.Cmd {
  ignore((id, x, y, point_x, point_y))
  @cmd.none
}

///|
fn context_scope(
  id : String,
  model : MenuCoreModel,
  point_x : Int,
  point_y : Int,
  set_open : @cmd.Emit[Bool],
  toggle_checked : @cmd.Emit[String],
  set_radio : @cmd.Emit[(String, String)],
) -> ContextMenuScope {
  {
    point_x,
    point_y,
    menu: {
      id,
      content_id: id + "-content",
      trigger_id: id + "-trigger",
      model,
      counter: Ref(0),
      close_command: set_open(false),
      toggle_command: set_open(!model.open),
      toggle_checked,
      set_radio,
    },
  }
}

///|
/// Stateful context menu opened at the native `contextmenu` pointer position.
#cfg(target="js")
pub fn context_menu(
  id~ : String,
  default_open? : Bool = false,
  default_checked_values? : Array[String] = [],
  default_radio_values? : Array[(String, String)] = [],
  on_open_change? : @cmd.Emit[Bool],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (ContextMenuScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  let initial : ContextMenuModel = {
    menu: menu_core_model(
      default_open, default_checked_values, default_radio_values,
    ),
    x: 8,
    y: 8,
    point_x: 0,
    point_y: 0,
  }
  let (model, emit) = @rabbita.create_state_with_init(
    init=emit => {
      let set_active = emit.map(index => ContextSetActive(index))
      let set_submenu = emit.map(value => ContextSetSubmenu(value))
      (
        initial,
        @cmd.batch([
          floating_bind_sync_cmd(
            id + "-content",
            emit.map(open => ContextNativeOpen(open)),
          ),
          context_bind_close_cmd(id + "-content", emit(ContextSetOpen(false))),
          context_bind_trigger_cmd(
            id + "-trigger",
            id + "-content",
            emit.map(pair => ContextOpenAt(pair.0, pair.1, pair.2, pair.3)),
          ),
          menu_bind_surface_cmd(
            id + "-root",
            set_active,
            emit(ContextSetOpen(false)),
            set_submenu,
          ),
          if default_open {
            context_show_cmd(id + "-content", 8, 8, 0, 0)
          } else {
            @cmd.none
          },
        ]),
      )
    },
    update=(current, msg, emit) => {
      match msg {
        ContextOpenAt(x, y, point_x, point_y) => {
          let next = {
            menu: { ..current.menu, open: true, active: -1, submenus: [] },
            x,
            y,
            point_x,
            point_y,
          }
          (
            next,
            @cmd.batch([
              menu_position_submenus_cmd(id + "-root"),
              menu_focus_first_cmd(
                id + "-root",
                emit.map(index => ContextSetActive(index)),
              ),
              if current.menu.open {
                @cmd.none
              } else {
                dropdown_notify(on_open_change, true)
              },
            ]),
          )
        }
        ContextSetOpen(open) =>
          if open == current.menu.open {
            (current, @cmd.none)
          } else {
            (
              { ..current, menu: { ..current.menu, open, submenus: [] } },
              @cmd.batch([
                if open {
                  context_show_cmd(
                    id + "-content",
                    current.x,
                    current.y,
                    current.point_x,
                    current.point_y,
                  )
                } else {
                  @cmd.batch([
                    context_hide_after_transition_cmd(id + "-content"),
                    ui_focus_id(id + "-trigger"),
                  ])
                },
                if open {
                  @cmd.none
                } else {
                  menu_position_submenus_cmd(id + "-root")
                },
                dropdown_notify(on_open_change, open),
              ]),
            )
          }
        ContextNativeOpen(open) =>
          if open == current.menu.open {
            (current, @cmd.none)
          } else {
            (
              { ..current, menu: { ..current.menu, open, submenus: [] } },
              @cmd.batch([
                if open {
                  @cmd.none
                } else {
                  menu_position_submenus_cmd(id + "-root")
                },
                dropdown_notify(on_open_change, open),
              ]),
            )
          }
        ContextSetActive(index) =>
          if current.menu.active == index {
            (current, @cmd.none)
          } else {
            (
              { ..current, menu: { ..current.menu, active: index } },
              menu_focus_item_cmd(id + "-root", index),
            )
          }
        ContextToggleChecked(value) =>
          (
            {
              ..current,
              menu: {
                ..current.menu,
                checked: menu_toggle_value(current.menu.checked, value),
              },
            },
            @cmd.none,
          )
        ContextSetRadio(group, value) =>
          (
            {
              ..current,
              menu: {
                ..current.menu,
                radios: menu_set_radio_value(current.menu.radios, group, value),
              },
            },
            @cmd.none,
          )
        ContextSetSubmenu(change) => {
          let submenus = menu_update_submenus(current.menu.submenus, change)
          if submenus == current.menu.submenus {
            (current, @cmd.none)
          } else {
            (
              { ..current, menu: { ..current.menu, submenus, } },
              menu_position_submenus_cmd(id + "-root"),
            )
          }
        }
      }
    },
  )
  model.view(model => {
    let scope = context_scope(
      id,
      model.menu,
      model.point_x,
      model.point_y,
      emit.map(open => ContextSetOpen(open)),
      emit.map(value => ContextToggleChecked(value)),
      emit.map(pair => ContextSetRadio(pair.0, pair.1)),
    )
    menu_root_surface(
      "context-menu",
      id + "-root",
      model.menu.open,
      attrs,
      style,
      children(scope),
    )
  })
}

///|
#cfg(not(target="js"))
pub fn context_menu(
  id~ : String,
  default_open? : Bool = false,
  default_checked_values? : Array[String] = [],
  default_radio_values? : Array[(String, String)] = [],
  on_open_change? : @cmd.Emit[Bool],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (ContextMenuScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  ignore(on_open_change)
  let scope = context_scope(
    id,
    menu_core_model(default_open, default_checked_values, default_radio_values),
    0,
    0,
    menu_noop_emit(),
    menu_noop_emit(),
    menu_noop_emit(),
  )
  @rabbita.Val::constant(
    menu_root_surface(
      "context-menu",
      id + "-root",
      default_open,
      attrs,
      style,
      children(scope),
    ),
  )
}

///|
/// Explicit Root spelling matching the compound-component API.
pub fn context_menu_root(
  id~ : String,
  default_open? : Bool = false,
  default_checked_values? : Array[String] = [],
  default_radio_values? : Array[(String, String)] = [],
  on_open_change? : @cmd.Emit[Bool],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (ContextMenuScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  context_menu(
    id~,
    default_open~,
    default_checked_values~,
    default_radio_values~,
    on_open_change?,
    attrs?,
    style~,
    children,
  )
}

///|
/// Zero-DOM Portal adapter for shadcn-compatible compound composition.
/// Content already uses the native Popover top layer, so this adapter adds no
/// wrapper element and requires no registration or portal runtime.
pub fn context_menu_portal(children : Array[@html.Html]) -> @html.Html {
  @html.fragment(children)
}

///|
pub fn[C : @html.IsChildren] context_menu_trigger(
  scope : ContextMenuScope,
  tabindex? : Int = 0,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, "position:relative"], style),
    id=scope.menu.trigger_id,
    class?,
    title?,
    attrs=menu_state_attrs(attrs, "context-menu-trigger", scope.menu.model.open)
      .tabindex(tabindex)
      .aria_haspopup("menu")
      .aria_expanded(ui_bool(scope.menu.model.open))
      .aria_controls(scope.menu.content_id),
    [
      @html.div(style=[UiBoxSizing, "display:contents"], children),
      @html.span(
        style=[
          UiBoxSizing,
          ContextMenuPointStyle,
          "left:\{scope.point_x}px;top:\{scope.point_y}px",
          popup_anchor_style(context_menu_point_id(scope.menu.trigger_id)),
        ],
        id=context_menu_point_id(scope.menu.trigger_id),
        attrs=@html.Attrs::build()
          .data_set("slot", "context-menu-anchor")
          .aria_hidden("true"),
        @html.nothing,
      ),
    ],
  )
}

///|
pub fn[C : @html.IsChildren] context_menu_content(
  scope : ContextMenuScope,
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_content_surface(
    "context-menu-content",
    scope.menu,
    Bottom,
    Start,
    0,
    0,
    aria_label,
    class,
    title,
    attrs,
    style,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] context_menu_group(
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_group_surface(
    "context-menu-group", aria_label, class, title, attrs, style, children,
  )
}

///|
pub fn[C : @html.IsChildren] context_menu_item(
  scope : ContextMenuScope,
  disabled? : Bool = false,
  inset? : Bool = false,
  destructive? : Bool = false,
  close_on_select? : Bool = true,
  on_select? : @cmd.Cmd,
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_item_surface(
    "context-menu-item",
    scope.menu,
    "menuitem",
    None,
    MenuIndicatorInlineStart,
    disabled,
    inset,
    destructive,
    None,
    close_on_select,
    None,
    on_select,
    aria_label,
    class,
    title,
    attrs,
    style,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] context_menu_checkbox_item(
  scope : ContextMenuScope,
  value~ : String,
  disabled? : Bool = false,
  close_on_select? : Bool = false,
  on_checked_change? : @cmd.Emit[Bool],
  on_select? : @cmd.Cmd,
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let checked = menu_contains(scope.menu.model.checked, value)
  let notify = if on_checked_change is Some(notify) {
    notify(!checked)
  } else {
    @cmd.none
  }
  menu_item_surface(
    "context-menu-checkbox-item",
    scope.menu,
    "menuitemcheckbox",
    Some(checked),
    MenuIndicatorInlineEnd,
    disabled,
    false,
    false,
    None,
    close_on_select,
    Some(@cmd.batch([notify, (scope.menu.toggle_checked)(value)])),
    on_select,
    aria_label,
    class,
    title,
    attrs,
    style,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] context_menu_radio_group(
  scope : ContextMenuScope,
  value~ : String,
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (ContextMenuRadioGroupScope) -> C,
) -> @html.Html {
  menu_group_surface(
    "context-menu-radio-group",
    aria_label,
    class,
    title,
    attrs,
    style,
    children({ menu: scope.menu, group: value }),
  )
}

///|
pub fn[C : @html.IsChildren] context_menu_radio_item(
  scope : ContextMenuRadioGroupScope,
  value~ : String,
  disabled? : Bool = false,
  close_on_select? : Bool = false,
  on_value_change? : @cmd.Emit[String],
  on_select? : @cmd.Cmd,
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let checked = menu_radio_value(scope.menu.model.radios, scope.group) ==
    Some(value)
  let notify = if on_value_change is Some(notify) {
    notify(value)
  } else {
    @cmd.none
  }
  menu_item_surface(
    "context-menu-radio-item",
    scope.menu,
    "menuitemradio",
    Some(checked),
    MenuIndicatorInlineEnd,
    disabled,
    false,
    false,
    None,
    close_on_select,
    Some(@cmd.batch([notify, (scope.menu.set_radio)((scope.group, value))])),
    on_select,
    aria_label,
    class,
    title,
    attrs,
    style,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] context_menu_label(
  inset? : Bool = false,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_label_surface(
    "context-menu-label", inset, class, title, attrs, style, children,
  )
}

///|
pub fn context_menu_separator(
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  menu_separator_surface("context-menu-separator", class, attrs, style)
}

///|
pub fn[C : @html.IsChildren] context_menu_shortcut(
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_shortcut_surface(
    "context-menu-shortcut", class, title, attrs, style, children,
  )
}

///|
pub fn[C : @html.IsChildren] context_menu_sub(
  scope : ContextMenuScope,
  value~ : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (ContextMenuSubScope) -> C,
) -> @html.Html {
  let key = menu_submenu_key(scope.menu, value)
  let open = menu_submenu_open(scope.menu.model.submenus, key)
  menu_sub_root_surface(
    "context-menu-sub",
    open,
    attrs,
    style,
    children({ menu: scope.menu, key }),
  )
}

///|
pub fn[C : @html.IsChildren] context_menu_sub_trigger(
  scope : ContextMenuSubScope,
  disabled? : Bool = false,
  inset? : Bool = false,
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_item_surface(
    "context-menu-sub-trigger",
    scope.menu,
    "menuitem",
    None,
    MenuIndicatorInlineStart,
    disabled,
    inset,
    false,
    Some(scope.key),
    false,
    None,
    None,
    aria_label,
    class,
    title,
    attrs,
    style,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] context_menu_sub_content(
  scope : ContextMenuSubScope,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_sub_content_surface(
    "context-menu-sub-content",
    scope.key,
    menu_submenu_open(scope.menu.model.submenus, scope.key),
    class,
    title,
    attrs,
    style,
    children,
  )
}
