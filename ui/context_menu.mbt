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
extern "js" fn ffi_bind_context_menu_trigger(
  id : String,
  open_at : (Int, Int, Int, Int) -> Unit,
) -> Unit =
  #| (id, openAt) => {
  #|   const trigger = document.getElementById(id)
  #|   if (!trigger) return
  #|   trigger.__ruiContextOpenAt = openAt
  #|   if (trigger.__ruiContextBound) return
  #|   trigger.__ruiContextBound = true
  #|   const open = (clientX, clientY) => {
  #|     const rect = trigger.getBoundingClientRect()
  #|     const width = trigger.clientWidth || rect.width
  #|     const height = trigger.clientHeight || rect.height
  #|     const pointX = Math.min(
  #|       Math.max(0, clientX - rect.left - (trigger.clientLeft || 0)),
  #|       width,
  #|     )
  #|     const pointY = Math.min(
  #|       Math.max(0, clientY - rect.top - (trigger.clientTop || 0)),
  #|       height,
  #|     )
  #|     trigger.__ruiContextOpenAt?.(
  #|       Math.round(clientX),
  #|       Math.round(clientY),
  #|       Math.round(pointX),
  #|       Math.round(pointY),
  #|     )
  #|   }
  #|   trigger.addEventListener("contextmenu", event => {
  #|     if (event.defaultPrevented) return
  #|     event.preventDefault()
  #|     open(event.clientX, event.clientY)
  #|   })
  #|   trigger.addEventListener("keydown", event => {
  #|     if (event.defaultPrevented) return
  #|     if (event.key !== "ContextMenu" && !(event.shiftKey && event.key === "F10")) return
  #|     event.preventDefault()
  #|     const rect = trigger.getBoundingClientRect()
  #|     open(rect.left + 8, rect.top + 8)
  #|   })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_show_context_menu(
  id : String,
  x : Int,
  y : Int,
  point_x : Int,
  point_y : Int,
) -> Unit =
  #| (id, x, y, pointX, pointY) => {
  #|   const popup = document.getElementById(id)
  #|   if (!popup) return
  #|   if (popup.__ruiContextHideTimer) {
  #|     clearTimeout(popup.__ruiContextHideTimer)
  #|     popup.__ruiContextHideTimer = 0
  #|   }
  #|   if (popup.__ruiContextTransitionEnd) {
  #|     popup.removeEventListener("transitionend", popup.__ruiContextTransitionEnd)
  #|     popup.__ruiContextTransitionEnd = null
  #|   }
  #|   const triggerId = popup.dataset.triggerId || ""
  #|   const trigger = document.getElementById(triggerId)
  #|   const point = document.getElementById(`${triggerId}-point`)
  #|   if (trigger && point) {
  #|     point.style.left = `${pointX}px`
  #|     point.style.top = `${pointY}px`
  #|   }
  #|   const positionArea = popup.style.getPropertyValue("position-area")
  #|   const cssAnchored = Boolean(point)
  #|     && typeof CSS !== "undefined"
  #|     && typeof CSS.supports === "function"
  #|     && CSS.supports("anchor-name", "--rui-anchor")
  #|     && CSS.supports("position-anchor", "--rui-anchor")
  #|     && CSS.supports("position-area", positionArea)
  #|     && CSS.supports("position-try-fallbacks", "flip-inline")
  #|   if (cssAnchored) {
  #|     popup.style.removeProperty("--rui-floating-left")
  #|     popup.style.removeProperty("--rui-floating-top")
  #|     popup.dataset.positioning = "css-anchor"
  #|     popup.dataset.positioned = "true"
  #|   } else {
  #|     popup.style.setProperty("--rui-floating-left", `${Math.max(8, x)}px`)
  #|     popup.style.setProperty("--rui-floating-top", `${Math.max(8, y)}px`)
  #|     popup.dataset.positioning = "javascript-fallback"
  #|   }
  #|   popup.hidden = false
  #|   let alreadyOpen = false
  #|   try { alreadyOpen = popup.matches(":popover-open") }
  #|   catch (_) { alreadyOpen = Boolean(popup.__ruiFloatingOpen) }
  #|   if (!alreadyOpen && typeof getComputedStyle === "function") {
  #|     // Commit the inline closed state before entering the top layer. The
  #|     // incremental open render can then transition from it without moving
  #|     // or measuring the popup.
  #|     void getComputedStyle(popup).opacity
  #|   }
  #|   try {
  #|     if (typeof popup.showPopover === "function") {
  #|       if (!alreadyOpen) popup.showPopover()
  #|     } else if (popup.__ruiFloatingSync) {
  #|       popup.__ruiFloatingSync(true)
  #|     }
  #|   } catch (_) {
  #|   }
  #|   // The zero-size point inside the trigger is the primary anchor. It keeps
  #|   // the pointer-relative placement attached during every browser layout
  #|   // pass, including ancestor scroll, without a JavaScript scroll listener.
  #|   if (cssAnchored) return
  #|   // Older engines retain a synchronous, viewport-clamped fallback.
  #|   const rect = popup.getBoundingClientRect()
  #|   const viewport = typeof window !== "undefined" ? window.visualViewport : null
  #|   const viewportLeft = viewport?.offsetLeft || 0
  #|   const viewportTop = viewport?.offsetTop || 0
  #|   const width = viewport?.width || document.documentElement.clientWidth
  #|   const height = viewport?.height || document.documentElement.clientHeight
  #|   const clipLeft = viewportLeft + 8
  #|   const clipTop = viewportTop + 8
  #|   const clipRight = viewportLeft + width - 8
  #|   const clipBottom = viewportTop + height - 8
  #|   const left = Math.min(Math.max(clipLeft, x), Math.max(clipLeft, clipRight - rect.width))
  #|   const top = Math.min(Math.max(clipTop, y), Math.max(clipTop, clipBottom - rect.height))
  #|   popup.style.setProperty("--rui-floating-left", `${Math.round(left)}px`)
  #|   popup.style.setProperty("--rui-floating-top", `${Math.round(top)}px`)
  #|   popup.dataset.positioned = "true"
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_bind_context_menu_close(
  id : String,
  request_close : () -> Unit,
) -> Unit =
  #| (id, requestClose) => {
  #|   const popup = document.getElementById(id)
  #|   if (!popup) return
  #|   popup.__ruiFloatingRequestClose = requestClose
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_hide_context_menu_after_transition(id : String) -> Unit =
  #| id => {
  #|   const popup = document.getElementById(id)
  #|   if (!popup) return
  #|   if (popup.__ruiContextHideTimer) clearTimeout(popup.__ruiContextHideTimer)
  #|   if (popup.__ruiContextTransitionEnd) {
  #|     popup.removeEventListener("transitionend", popup.__ruiContextTransitionEnd)
  #|   }
  #|   const finish = () => {
  #|     if (popup.dataset.state === "open") return
  #|     if (popup.__ruiContextHideTimer) clearTimeout(popup.__ruiContextHideTimer)
  #|     popup.__ruiContextHideTimer = 0
  #|     if (popup.__ruiContextTransitionEnd) {
  #|       popup.removeEventListener("transitionend", popup.__ruiContextTransitionEnd)
  #|       popup.__ruiContextTransitionEnd = null
  #|     }
  #|     try {
  #|       if (typeof popup.hidePopover === "function"
  #|         && popup.matches(":popover-open")) popup.hidePopover()
  #|       else popup.__ruiFloatingNotify?.(false)
  #|     } catch (_) {
  #|       popup.__ruiFloatingNotify?.(false)
  #|     }
  #|   }
  #|   const style = typeof getComputedStyle === "function"
  #|     ? getComputedStyle(popup)
  #|     : null
  #|   const toMs = value => {
  #|     const text = String(value || "").trim()
  #|     const number = Number.parseFloat(text)
  #|     if (!Number.isFinite(number)) return 0
  #|     return text.endsWith("ms") ? number : number * 1000
  #|   }
  #|   const durations = String(style?.transitionDuration || "0s")
  #|     .split(",").map(toMs)
  #|   const delays = String(style?.transitionDelay || "0s")
  #|     .split(",").map(toMs)
  #|   let duration = 0
  #|   for (let index = 0; index < durations.length; index += 1) {
  #|     duration = Math.max(
  #|       duration,
  #|       durations[index] + (delays[index % Math.max(1, delays.length)] || 0),
  #|     )
  #|   }
  #|   if (typeof matchMedia === "function"
  #|     && matchMedia("(prefers-reduced-motion: reduce)").matches) duration = 0
  #|   if (duration <= 0) {
  #|     finish()
  #|     return
  #|   }
  #|   const onEnd = event => {
  #|     if (event.target !== popup) return
  #|     if (event.propertyName !== "opacity" && event.propertyName !== "transform") return
  #|     finish()
  #|   }
  #|   popup.__ruiContextTransitionEnd = onEnd
  #|   popup.addEventListener("transitionend", onEnd)
  #|   popup.__ruiContextHideTimer = setTimeout(finish, Math.ceil(duration) + 34)
  #| }

///|
#cfg(target="js")
fn context_bind_trigger_cmd(
  trigger_id : String,
  content_id : String,
  open_at : @cmd.Emit[(Int, Int, Int, Int)],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, scheduler => {
    ui_after_mount(
      trigger_id,
      () => {
        ffi_bind_context_menu_trigger(trigger_id, (x, y, point_x, point_y) => {
          ffi_show_context_menu(content_id, x, y, point_x, point_y)
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
  @cmd.custom_cmd(kind=@cmd.AfterRender, scheduler => {
    ui_after_mount(
      content_id,
      () => {
        ffi_bind_context_menu_close(content_id, () => {
          scheduler.add(request_close)
        })
      },
      purpose="context-menu-close-bind",
    )
  })
}

///|
#cfg(target="js")
fn context_hide_after_transition_cmd(id : String) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, _ => {
    ui_after_mount(
      id,
      () => ffi_hide_context_menu_after_transition(id),
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
  @cmd.custom_cmd(kind=@cmd.AfterRender, _ => {
    ui_after_mount(
      id,
      () => ffi_show_context_menu(id, x, y, point_x, point_y),
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
  set_active : @cmd.Emit[Int],
  toggle_checked : @cmd.Emit[String],
  set_radio : @cmd.Emit[(String, String)],
  set_submenu : @cmd.Emit[MenuSubmenuChange],
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
      open_command: set_open(true),
      close_command: set_open(false),
      toggle_command: set_open(!model.open),
      set_active,
      toggle_checked,
      set_radio,
      set_submenu,
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
    update=(emit, msg, current) => {
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
      emit.map(index => ContextSetActive(index)),
      emit.map(value => ContextToggleChecked(value)),
      emit.map(pair => ContextSetRadio(pair.0, pair.1)),
      emit.map(value => ContextSetSubmenu(value)),
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
