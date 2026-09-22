///|
/// Edge from which a [`drawer_content`] surface is presented.
pub(all) enum DrawerDirection {
  DrawerTop
  DrawerRight
  DrawerBottom
  DrawerLeft
} derive(Debug, Eq)

///|
pub extend DrawerDirection with Debug::{to_repr}

///|
pub extend DrawerDirection with Eq::{equal, not_equal}

///|
/// Explicit compound-component scope created by [`drawer`].
struct DrawerScope(DialogController)

///|
const DrawerPositionerStyle : String = "position:fixed;inset:0;z-index:51;display:flex;overflow:hidden;pointer-events:none"

///|
const DrawerSurfaceStyle : String = "position:relative;display:flex;min-width:0;min-height:0;flex-direction:column;overflow:auto;background:var(--rui-popover,var(--rui-background,oklch(1 0 0)));color:var(--rui-popover-foreground,var(--rui-foreground,oklch(0.145 0 0)));box-shadow:0 16px 48px rgb(0 0 0 / 0.2);opacity:var(--rui-drawer-opacity,1);transform:var(--rui-drawer-transform,translate3d(0,0,0));will-change:opacity,transform;pointer-events:auto;transition:opacity 200ms cubic-bezier(0.22,1,0.36,1),transform 200ms cubic-bezier(0.22,1,0.36,1)"

///|
const DrawerHeaderStyle : String = "display:flex;min-width:0;flex-direction:column;gap:0.375rem;padding:1rem 1.5rem;text-align:center"

///|
const DrawerFooterStyle : String = "display:flex;flex-direction:column-reverse;gap:0.5rem;padding:1rem 1.5rem"

///|
const DrawerCloseButtonStyle : String = "position:absolute;top:1rem;inset-inline-end:1rem;z-index:1;opacity:var(--rui-close-opacity,var(--rui-close-base-opacity,0.7))"

///|
const DrawerHandleInteractionStyle : String = "cursor:grab;touch-action:none;user-select:none;-webkit-user-select:none"

///|
fn drawer_direction_value(direction : DrawerDirection) -> String {
  match direction {
    DrawerTop => "top"
    DrawerRight => "right"
    DrawerBottom => "bottom"
    DrawerLeft => "left"
  }
}

///|
fn drawer_positioner_direction_style(direction : DrawerDirection) -> String {
  match direction {
    DrawerTop => "align-items:flex-start"
    DrawerRight => "justify-content:flex-end"
    DrawerBottom => "align-items:flex-end"
    DrawerLeft => "justify-content:flex-start"
  }
}

///|
fn drawer_surface_direction_style(direction : DrawerDirection) -> String {
  match direction {
    DrawerTop =>
      "width:100%;max-height:96vh;border-bottom:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:0 0 var(--rui-radius,0.625rem) var(--rui-radius,0.625rem)"
    DrawerRight =>
      "width:min(90vw,24rem);height:100%;border-left:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:var(--rui-radius,0.625rem) 0 0 var(--rui-radius,0.625rem)"
    DrawerBottom =>
      "width:100%;max-height:96vh;border-top:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:var(--rui-radius,0.625rem) var(--rui-radius,0.625rem) 0 0"
    DrawerLeft =>
      "width:min(90vw,24rem);height:100%;border-right:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:0 var(--rui-radius,0.625rem) var(--rui-radius,0.625rem) 0"
  }
}

///|
fn drawer_closed_transform(direction : DrawerDirection) -> String {
  match direction {
    DrawerTop => "translate3d(0,calc(-100% - 2px),0)"
    DrawerRight => "translate3d(calc(100% + 2px),0,0)"
    DrawerBottom => "translate3d(0,calc(100% + 2px),0)"
    DrawerLeft => "translate3d(calc(-100% - 2px),0,0)"
  }
}

///|
fn drawer_motion_style(direction : DrawerDirection, open : Bool) -> String {
  let closed_transform = drawer_closed_transform(direction)
  if open {
    "--rui-drawer-closed-transform:\{closed_transform};--rui-drawer-opacity:1;--rui-drawer-transform:translate3d(0,0,0);animation:rui-drawer-enter 200ms cubic-bezier(0.22,1,0.36,1)"
  } else {
    "--rui-drawer-closed-transform:\{closed_transform};--rui-drawer-opacity:0;--rui-drawer-transform:\{closed_transform};animation:rui-drawer-exit 200ms cubic-bezier(0.22,1,0.36,1);pointer-events:none"
  }
}

///|
#cfg(target="js")
priv struct DrawerPointerState {
  surface : @dom.Element
  pointer_id : Int
  horizontal : Bool
  sign : Int
  start_x : Double
  start_y : Double
  start_time : Double
  size : Double
  mut active : Bool
  overlay : @dom.Element?
  original_transform : String
  original_transition : String
  original_overlay_opacity : String
}

///|
#cfg(target="js")
let drawer_pointer_states : Array[DrawerPointerState] = []

///|
#cfg(target="js")
fn drawer_pointer_state(surface : @dom.Element) -> DrawerPointerState? {
  for state in drawer_pointer_states {
    if state.surface.is_same_node(surface.as_node()) {
      return Some(state)
    }
  }
  None
}

///|
#cfg(target="js")
fn drawer_remove_pointer_state(surface : @dom.Element) -> Unit {
  for index, state in drawer_pointer_states {
    if state.surface.is_same_node(surface.as_node()) {
      ignore(drawer_pointer_states.remove(index))
      return
    }
  }
}

///|
#cfg(target="js")
fn drawer_restore_style_property(
  style : @dom.CSSStyleDeclaration,
  name : String,
  value : String,
) -> Unit {
  if value == "" {
    ignore(style.remove_property(name))
  } else {
    style.set_property(name, value)
  }
}

///|
#cfg(target="js")
fn drawer_release_pointer_state(
  state : DrawerPointerState,
  restore_drag_values : Bool,
) -> Unit {
  if state.surface.to_html_element() is Some(surface) {
    let style = surface.get_style()
    if restore_drag_values {
      drawer_restore_style_property(
        style,
        "--rui-drawer-transform",
        state.original_transform,
      )
    }
    drawer_restore_style_property(
      style,
      "transition",
      state.original_transition,
    )
  }
  if restore_drag_values &&
    state.overlay is Some(overlay) &&
    overlay.to_html_element() is Some(overlay_html) {
    drawer_restore_style_property(
      overlay_html.get_style(),
      "--rui-dialog-overlay-opacity",
      state.original_overlay_opacity,
    )
  }
  state.surface.remove_attribute("data-dragging")
  if state.surface.has_pointer_capture(state.pointer_id) {
    state.surface.release_pointer_capture(state.pointer_id)
  }
  drawer_remove_pointer_state(state.surface)
}

///|
#cfg(target="js")
fn drawer_pointer_start(event : @dom.MouseEvent, direction : String) -> Bool {
  guard event.to_pointer_event() is Some(pointer) else { return false }
  if pointer.get_default_prevented() ||
    !pointer.get_is_primary() ||
    (pointer.get_pointer_type() == "mouse" && pointer.get_button() != 0) {
    return false
  }
  guard pointer.current_target().to_option() is Some(current_target) else {
    return false
  }
  guard current_target.to_element() is Some(surface) else { return false }
  guard surface.to_html_element() is Some(surface_html) else { return false }
  guard pointer.target().to_element() is Some(target) else { return false }
  guard target.closest("[data-slot=\"drawer-handle\"]") is Some(handle) else {
    return false
  }
  guard surface.contains(handle.as_node()) else { return false }
  if drawer_pointer_state(surface) is Some(previous) {
    drawer_release_pointer_state(previous, true)
  }
  for animation in surface.get_animations() {
    animation.finish()
  }
  let horizontal = direction == "left" || direction == "right"
  let overlay = if surface.closest("dialog") is Some(dialog) {
    dialog.query_selector("[data-slot=\"drawer-overlay\"]")
  } else {
    None
  }
  let style = surface_html.get_style()
  let original_overlay_opacity = if overlay is Some(overlay) &&
    overlay.to_html_element() is Some(overlay_html) {
    overlay_html.get_style().get_property_value("--rui-dialog-overlay-opacity")
  } else {
    ""
  }
  let state : DrawerPointerState = {
    surface,
    pointer_id: pointer.get_pointer_id(),
    horizontal,
    sign: if direction == "left" || direction == "top" {
      -1
    } else {
      1
    },
    start_x: pointer.get_client_x(),
    start_y: pointer.get_client_y(),
    start_time: pointer.get_time_stamp(),
    size: if horizontal {
      surface.get_client_width()
    } else {
      surface.get_client_height()
    },
    active: false,
    overlay,
    original_transform: style.get_property_value("--rui-drawer-transform"),
    original_transition: style.get_property_value("transition"),
    original_overlay_opacity,
  }
  drawer_pointer_states.push(state)
  surface.set_pointer_capture(state.pointer_id)
  true
}

///|
#cfg(target="js")
fn drawer_pointer_move(event : @dom.MouseEvent) -> Bool {
  guard event.to_pointer_event() is Some(pointer) else { return false }
  guard pointer.current_target().to_option() is Some(current_target) else {
    return false
  }
  guard current_target.to_element() is Some(surface) else { return false }
  guard drawer_pointer_state(surface) is Some(state) else { return false }
  guard state.pointer_id == pointer.get_pointer_id() else { return false }
  guard surface.to_html_element() is Some(surface_html) else { return false }
  let delta = if state.horizontal {
    pointer.get_client_x() - state.start_x
  } else {
    pointer.get_client_y() - state.start_y
  }
  let cross = if state.horizontal {
    pointer.get_client_y() - state.start_y
  } else {
    pointer.get_client_x() - state.start_x
  }
  let progress = delta * state.sign.to_double()
  if !state.active {
    if delta.abs() < 6 || delta.abs() <= cross.abs() {
      return false
    }
    state.active = true
    surface.set_attribute("data-dragging", "true")
  }
  let visual = if progress < 0 { delta * 0.2 } else { delta }
  let style = surface_html.get_style()
  style.set_property("transition", "none")
  style.set_property(
    "--rui-drawer-transform",
    if state.horizontal {
      "translate3d(\{visual}px,0,0)"
    } else {
      "translate3d(0,\{visual}px,0)"
    },
  )
  if state.overlay is Some(overlay) &&
    overlay.to_html_element() is Some(overlay_html) {
    let ratio = (progress / state.size.max(1.0)).clamp(min=0.0, max=1.0)
    overlay_html
    .get_style()
    .set_property("--rui-dialog-overlay-opacity", "\{1.0 - ratio}")
  }
  true
}

///|
#cfg(target="js")
fn drawer_pointer_end(event : @dom.MouseEvent) -> Bool {
  guard event.to_pointer_event() is Some(pointer) else { return false }
  guard pointer.current_target().to_option() is Some(current_target) else {
    return false
  }
  guard current_target.to_element() is Some(surface) else { return false }
  guard drawer_pointer_state(surface) is Some(state) else { return false }
  guard state.pointer_id == pointer.get_pointer_id() else { return false }
  let delta = if state.horizontal {
    pointer.get_client_x() - state.start_x
  } else {
    pointer.get_client_y() - state.start_y
  }
  let progress = delta * state.sign.to_double()
  let elapsed = (pointer.get_time_stamp() - state.start_time).max(1.0)
  let threshold = (state.size * 0.25).max(48.0).min(160.0)
  let dismiss = state.active &&
    progress > 0 &&
    (progress >= threshold || (progress >= 16.0 && progress / elapsed >= 0.5))
  drawer_release_pointer_state(state, !dismiss)
  dismiss
}

///|
#cfg(target="js")
fn drawer_pointer_cancel(event : @dom.MouseEvent) -> Unit {
  guard event.to_pointer_event() is Some(pointer) else { return }
  guard pointer.current_target().to_option() is Some(current_target) else {
    return
  }
  guard current_target.to_element() is Some(surface) else { return }
  guard drawer_pointer_state(surface) is Some(state) else { return }
  guard state.pointer_id == pointer.get_pointer_id() else { return }
  drawer_release_pointer_state(state, true)
}

///|
#cfg(target="js")
fn drawer_bind_pointer_attrs(
  attrs : @html.Attrs,
  direction : DrawerDirection,
  close_command : @cmd.Cmd,
) -> Unit {
  ignore(
    attrs
    .on_pointerdown(event => {
      ignore(drawer_pointer_start(event, drawer_direction_value(direction)))
      @cmd.none
    })
    .on_pointermove(event => {
      if drawer_pointer_move(event) {
        event.prevent_default()
      }
      @cmd.none
    })
    .on_pointerup(event => {
      if drawer_pointer_end(event) {
        event.prevent_default()
        close_command
      } else {
        @cmd.none
      }
    })
    .on_pointercancel(event => {
      drawer_pointer_cancel(event)
      @cmd.none
    }),
  )
}

///|
#cfg(not(target="js"))
fn drawer_bind_pointer_attrs(
  attrs : @html.Attrs,
  direction : DrawerDirection,
  close_command : @cmd.Cmd,
) -> Unit {
  ignore((attrs, direction, close_command))
}

///|
fn drawer_handle_style(direction : DrawerDirection) -> String {
  match direction {
    DrawerTop =>
      "width:3rem;height:0.25rem;margin:0.5rem auto 0;border-radius:999px;background:var(--rui-muted,oklch(0.97 0 0))"
    DrawerBottom =>
      "width:3rem;height:0.25rem;margin:0.5rem auto 0;border-radius:999px;background:var(--rui-muted,oklch(0.97 0 0))"
    DrawerRight =>
      "position:absolute;inset-inline-start:0.5rem;top:50%;z-index:1;width:0.25rem;height:3rem;transform:translateY(-50%);border-radius:999px;background:var(--rui-muted,oklch(0.97 0 0))"
    DrawerLeft =>
      "position:absolute;inset-inline-end:0.5rem;top:50%;z-index:1;width:0.25rem;height:3rem;transform:translateY(-50%);border-radius:999px;background:var(--rui-muted,oklch(0.97 0 0))"
  }
}

///|
fn drawer_close_icon(scope : DialogController, label : String) -> @html.Html {
  dialog_control_button(
    slot="drawer-close",
    command=scope.close_command,
    variant=Ghost,
    size=IconSm,
    disabled=false,
    id=None,
    class=None,
    title=None,
    aria_label=Some(label),
    on_click=None,
    attrs=Some(
      @html.Attrs::build()
      .data_set("rui-close-icon", "")
      .data_set("state", dialog_state_value(scope.open)),
    ),
    style=[DrawerCloseButtonStyle],
    ui_x_icon(),
  )
}

///|
/// Create a stateful native-dialog drawer. Modal drawers use native focus
/// containment, restoration, Escape handling, and top-layer stacking;
/// `modal=false` intentionally leaves background controls available.
pub fn drawer(
  id~ : String,
  default_open? : Bool = false,
  modal? : Bool = true,
  close_on_escape? : Bool = true,
  on_open_change? : @cmd.Emit[Bool],
  on_close? : @cmd.Emit[String],
  children : (DrawerScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  stateful_dialog(
    id~,
    default_open~,
    modal~,
    close_on_escape~,
    on_open_change?,
    on_close?,
    scope => children(DrawerScope(scope)),
  )
}

///|
pub fn[C : @html.IsChildren] drawer_trigger(
  scope : DrawerScope,
  variant? : ButtonVariant = Outline,
  size? : ButtonSize = Default,
  disabled? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  on_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let dialog_scope = scope.0
  let trigger_attrs = dialog_state_attrs(
      attrs,
      "drawer-trigger",
      dialog_scope.open,
    )
    .aria_haspopup("dialog")
    .aria_controls(dialog_scope.id)
    .aria_expanded(ui_bool(dialog_scope.open))
  dialog_control_button(
    slot="drawer-trigger",
    command=dialog_scope.open_command,
    variant~,
    size~,
    disabled~,
    id~,
    class~,
    title~,
    aria_label~,
    on_click~,
    attrs=Some(trigger_attrs),
    style~,
    children,
  )
}

///|
/// Pass native drawer content through without adding a DOM node.
pub fn drawer_portal(children : Array[@html.Html]) -> @html.Html {
  @html.fragment(children)
}

///|
/// Render the drawer backdrop associated with a compound drawer scope.
pub fn drawer_overlay(
  scope : DrawerScope,
  close_on_overlay? : Bool = true,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  dialog_overlay_part(
    scope.0,
    slot="drawer-overlay",
    close_on_overlay~,
    id~,
    class~,
    title~,
    hidden~,
    attrs~,
    style~,
  )
}

///|
/// Render an edge drawer. `show_handle` adds the familiar shadcn/Vaul visual
/// affordance; it is decorative, while all dismissal remains available through
/// native Escape, backdrop, and explicit close controls.
pub fn[C : @html.IsChildren] drawer_content(
  scope : DrawerScope,
  direction? : DrawerDirection = DrawerBottom,
  close_on_overlay? : Bool = true,
  show_handle? : Bool = true,
  show_close? : Bool = false,
  close_label? : String = "Close",
  described? : Bool = true,
  aria_label? : String,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  overlay_attrs? : @html.Attrs,
  overlay_style? : Array[String] = [],
  native_attrs? : @html.Attrs,
  native_style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let dialog_scope = scope.0
  let native_element_attrs = dialog_state_attrs(
      native_attrs,
      "drawer-native",
      dialog_scope.open,
    )
    .data_set("modal", ui_bool(dialog_scope.modal))
    .data_set("close-on-outside", ui_bool(close_on_overlay))
    .data_set("close-on-escape", ui_bool(dialog_scope.close_on_escape))
  if dialog_scope.modal {
    ignore(native_element_attrs.aria_modal("true"))
  }
  if aria_label is Some(label) {
    ignore(native_element_attrs.aria_label(label))
  } else {
    ignore(native_element_attrs.aria_labelledby(dialog_scope.title_id()))
  }
  if described {
    ignore(native_element_attrs.aria_describedby(dialog_scope.description_id()))
  }
  let content_attrs = dialog_state_attrs(
    attrs,
    "drawer-content",
    dialog_scope.open,
  ).data_set("direction", drawer_direction_value(direction))
  drawer_bind_pointer_attrs(
    content_attrs,
    direction,
    dialog_scope.close_command,
  )
  let positioner_attrs = dialog_state_attrs(
    None,
    "drawer-positioner",
    dialog_scope.open,
  ).data_set("direction", drawer_direction_value(direction))
  let content = @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        DrawerSurfaceStyle,
        drawer_surface_direction_style(direction),
        drawer_motion_style(direction, dialog_scope.open),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=content_attrs,
    [
      if show_handle {
        drawer_handle(direction~)
      } else {
        @html.nothing
      },
      @html.div(style=[UiBoxSizing, "display:contents"], children),
      if show_close {
        drawer_close_icon(dialog_scope, close_label)
      } else {
        @html.nothing
      },
    ],
  )
  let open = dialog_scope.native_open
  let on_close = dialog_scope.on_close
  let on_cancel = dialog_scope.on_cancel
  let closedby = if !dialog_scope.modal {
    "none"
  } else if close_on_overlay {
    "any"
  } else if dialog_scope.close_on_escape {
    "closerequest"
  } else {
    "none"
  }
  drawer_portal([
    @html.dialog(
      style=ui_styles([UiBoxSizing, DialogNativeStyle], native_style),
      id=dialog_scope.id,
      open?,
      closedby~,
      on_close?,
      on_cancel?,
      attrs=native_element_attrs,
      [
        if dialog_scope.modal {
          drawer_overlay(
            scope,
            close_on_overlay~,
            attrs=ui_attrs(overlay_attrs),
            style=overlay_style,
          )
        } else {
          @html.nothing
        },
        @html.div(
          style=[
            UiBoxSizing,
            DrawerPositionerStyle,
            drawer_positioner_direction_style(direction),
          ],
          attrs=positioner_attrs,
          content,
        ),
      ],
    ),
  ])
}

///|
/// Render the drawer's visual grab handle. It is intentionally presentation
/// only; keyboard and assistive-technology users use the regular controls.
pub fn drawer_handle(
  direction? : DrawerDirection = DrawerBottom,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        drawer_handle_style(direction),
        DrawerHandleInteractionStyle,
      ],
      style,
    ),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "drawer-handle")
      .data_set("direction", drawer_direction_value(direction))
      .aria_hidden("true"),
    @html.nothing,
  )
}

///|
pub fn[C : @html.IsChildren] drawer_header(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, DrawerHeaderStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "drawer-header"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] drawer_footer(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, DrawerFooterStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "drawer-footer"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] drawer_title(
  scope : DrawerScope,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_id = id.unwrap_or(scope.0.title_id())
  @html.h2(
    style=ui_styles([UiBoxSizing, DialogTitleStyle], style),
    id=element_id,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "drawer-title"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] drawer_description(
  scope : DrawerScope,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_id = id.unwrap_or(scope.0.description_id())
  @html.p(
    style=ui_styles([UiBoxSizing, DialogDescriptionStyle], style),
    id=element_id,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "drawer-description"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] drawer_close(
  scope : DrawerScope,
  variant? : ButtonVariant = Outline,
  size? : ButtonSize = Default,
  disabled? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  on_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  dialog_control_button(
    slot="drawer-close",
    command=scope.0.close_command,
    variant~,
    size~,
    disabled~,
    id~,
    class~,
    title~,
    aria_label~,
    on_click~,
    attrs~,
    style~,
    children,
  )
}
