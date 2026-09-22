///|
/// Edge from which a [`drawer`] enters the viewport.
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
const DrawerStyle : String = "position:fixed;min-width:0;min-height:0;max-width:none;margin:var(--rui-drawer-inset,0.5rem);border:1px solid light-dark(var(--rui-popover,oklch(1 0 0)),var(--rui-border,oklch(1 0 0 / 0.1)));border-radius:var(--rui-radius,0.625rem);padding:0;overflow:visible;box-shadow:0 20px 25px -5px rgb(0 0 0 / 0.1),0 8px 10px -6px rgb(0 0 0 / 0.1);background:var(--rui-popover,var(--rui-background,oklch(1 0 0)));color:var(--rui-popover-foreground,var(--rui-foreground,oklch(0.145 0 0)));font-size:0.875rem;line-height:1.25rem;outline:none"

///|
const DrawerContentStyle : String = "display:flex;min-width:0;min-height:0;flex:1;flex-direction:column;padding:1rem;overflow:auto;overscroll-behavior:contain;border-radius:inherit"

///|
const DrawerHeaderStyle : String = "display:flex;min-width:0;flex-shrink:0;flex-direction:column;gap:var(--rui-drawer-header-gap,0.125rem);padding:0 0 1rem;text-align:var(--rui-drawer-header-align,left)"

///|
const DrawerFooterStyle : String = "display:flex;flex-shrink:0;flex-direction:column;gap:0.5rem;margin-block-start:auto;padding:1rem 0 0"

///|
const DrawerTitleStyle : String = "margin:0;font-size:1rem;line-height:1.5rem;font-weight:500;color:var(--rui-foreground,oklch(0.145 0 0))"

///|
const DrawerDescriptionStyle : String = "margin:0;font-size:0.875rem;line-height:1.25rem;text-wrap:balance;color:var(--rui-muted-foreground,oklch(0.556 0 0))"

///|
const DrawerSwipeAreaStyle : String = "position:absolute;cursor:grab;touch-action:none;user-select:none;-webkit-user-select:none"

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
fn drawer_direction_style(direction : DrawerDirection) -> String {
  match direction {
    DrawerTop =>
      "inset:0 0 auto;width:calc(100% - 2 * var(--rui-drawer-inset,0.5rem));max-height:calc(100dvh - 6rem);flex-direction:column;--rui-drawer-closed-transform:translateY(calc(-100% - var(--rui-drawer-inset,0.5rem) - 2px))"
    DrawerRight =>
      "inset:0 0 0 auto;width:var(--rui-drawer-side-width,75vw);height:calc(100dvh - 2 * var(--rui-drawer-inset,0.5rem));max-height:calc(100dvh - 2 * var(--rui-drawer-inset,0.5rem));flex-direction:row;--rui-drawer-closed-transform:translateX(calc(100% + var(--rui-drawer-inset,0.5rem) + 2px))"
    DrawerBottom =>
      "inset:auto 0 0;width:calc(100% - 2 * var(--rui-drawer-inset,0.5rem));max-height:calc(100dvh - 6rem);flex-direction:column;--rui-drawer-closed-transform:translateY(calc(100% + var(--rui-drawer-inset,0.5rem) + 2px))"
    DrawerLeft =>
      "inset:0 auto 0 0;width:var(--rui-drawer-side-width,75vw);height:calc(100dvh - 2 * var(--rui-drawer-inset,0.5rem));max-height:calc(100dvh - 2 * var(--rui-drawer-inset,0.5rem));flex-direction:row;--rui-drawer-closed-transform:translateX(calc(-100% - var(--rui-drawer-inset,0.5rem) - 2px))"
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
// Gesture data lives only for this pointer capture; native HTML owns open/close.
#cfg(target="js")
fn drawer_pointer_start(
  event : @dom.MouseEvent,
  direction : DrawerDirection,
) -> Unit {
  guard event.to_pointer_event() is Some(pointer) else { return }
  if pointer.get_default_prevented() ||
    !pointer.get_is_primary() ||
    (pointer.get_pointer_type() == "mouse" && pointer.get_button() != 0) {
    return
  }
  guard pointer.current_target().to_option() is Some(current_target) else {
    return
  }
  guard current_target.to_element() is Some(surface) else { return }
  guard surface.to_html_element() is Some(surface_html) else { return }
  guard surface.to_html_dialog_element() is Some(dialog) else { return }
  guard pointer.target().to_element() is Some(target) else { return }
  guard target.closest("[data-slot=\"drawer-swipe-area\"]") is Some(swipe_area) else {
    return
  }
  guard swipe_area.closest("dialog") is Some(owner) &&
    owner.is_same_node(surface.as_node()) else {
    return
  }
  let pointer_id = pointer.get_pointer_id()
  if swipe_area.has_pointer_capture(pointer_id) {
    return
  }
  for animation in surface.get_animations() {
    animation.finish()
  }
  let horizontal = direction == DrawerLeft || direction == DrawerRight
  let sign = if direction == DrawerLeft || direction == DrawerTop {
    -1.0
  } else {
    1.0
  }
  let start_x = pointer.get_client_x()
  let start_y = pointer.get_client_y()
  let start_time = pointer.get_time_stamp()
  let size = if horizontal {
    surface.get_client_width()
  } else {
    surface.get_client_height()
  }
  let active = Ref(false)
  let style = surface_html.get_style()
  let original_transform = style.get_property_value(
    "--rui-drawer-drag-transform",
  )
  let original_opacity = style.get_property_value(
    "--rui-drawer-backdrop-opacity",
  )
  let listeners : Array[(String, @dom.Listener)] = []
  fn cleanup(_event : @dom.Event) -> Unit {
    for (name, listener) in listeners {
      surface.remove_event_listener(name, listener)
    }
    surface.remove_attribute("data-dragging")
    drawer_restore_style_property(
      style, "--rui-drawer-drag-transform", original_transform,
    )
    drawer_restore_style_property(
      style, "--rui-drawer-backdrop-opacity", original_opacity,
    )
    if swipe_area.has_pointer_capture(pointer_id) {
      swipe_area.release_pointer_capture(pointer_id)
    }
  }
  fn on_move(event : @dom.Event) -> Unit {
    guard event.to_pointer_event() is Some(pointer) else { return }
    guard pointer.get_pointer_id() == pointer_id else { return }
    let delta = if horizontal {
      pointer.get_client_x() - start_x
    } else {
      pointer.get_client_y() - start_y
    }
    let cross = if horizontal {
      pointer.get_client_y() - start_y
    } else {
      pointer.get_client_x() - start_x
    }
    if !active.val {
      if delta.abs() < 6 || delta.abs() <= cross.abs() {
        return
      }
      active.val = true
      surface.set_attribute("data-dragging", "")
    }
    event.prevent_default()
    let progress = delta * sign
    let visual = if progress < 0 { delta * 0.2 } else { delta }
    style.set_property(
      "--rui-drawer-drag-transform",
      if horizontal {
        "translate3d(\{visual}px,0,0)"
      } else {
        "translate3d(0,\{visual}px,0)"
      },
    )
    let ratio = (progress / size.max(1.0)).clamp(min=0.0, max=1.0)
    style.set_property("--rui-drawer-backdrop-opacity", "\{1.0 - ratio}")
  }
  fn finish(event : @dom.Event) -> Unit {
    guard event.to_pointer_event() is Some(pointer) else { return }
    guard pointer.get_pointer_id() == pointer_id else { return }
    let delta = if horizontal {
      pointer.get_client_x() - start_x
    } else {
      pointer.get_client_y() - start_y
    }
    let progress = delta * sign
    let elapsed = (pointer.get_time_stamp() - start_time).max(1.0)
    let threshold = (size * 0.25).max(48.0).min(160.0)
    let clicked_outside = !active.val &&
      (pointer.get_client_x() - start_x).abs() < 6 &&
      (pointer.get_client_y() - start_y).abs() < 6 &&
      surface.get_attribute("closedby") is Some("any")
    if clicked_outside ||
      (
        active.val &&
        progress > 0 &&
        (
          progress >= threshold ||
          (progress >= 16.0 && progress / elapsed >= 0.5)
        )
      ) {
      event.prevent_default()
      // Restore transitions before the native close starts the exit animation.
      surface.remove_attribute("data-dragging")
      dialog.request_close()
    }
    cleanup(event)
  }
  listeners.push(("pointermove", on_move))
  listeners.push(("pointerup", finish))
  listeners.push(("pointercancel", cleanup))
  listeners.push(("lostpointercapture", cleanup))
  listeners.push(("close", cleanup))
  for (name, listener) in listeners {
    surface.add_event_listener(name, listener)
  }
  swipe_area.set_pointer_capture(pointer_id)
}

///|
#cfg(target="js")
fn drawer_bind_pointer_attrs(
  attrs : @html.Attrs,
  direction : DrawerDirection,
) -> Unit {
  ignore(
    attrs.on_pointerdown(event => {
      drawer_pointer_start(event, direction)
      @cmd.none
    }),
  )
}

///|
#cfg(not(target="js"))
fn drawer_bind_pointer_attrs(
  attrs : @html.Attrs,
  direction : DrawerDirection,
) -> Unit {
  ignore((attrs, direction))
}

///|
/// Render a floating native drawer.
/// Set `swipe_area` to a positive pixel size to enable a transparent swipe
/// area outside its inward-facing edge (width for side drawers, height for
/// top/bottom drawers). It is disabled by default.
/// `--rui-drawer-inset` controls the viewport gutter (defaults to 0.5rem).
/// Open it with `@rabbita/dialog.show(id)` and close it with a
/// `<form method="dialog">` or `@rabbita/dialog.close(id)`.
/// Swiping the outside area requests native dismissal and respects `on_cancel`.
/// Native events and title/description IDs follow [`dialog`].
pub fn[C : @html.IsChildren] drawer(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  direction? : DrawerDirection = DrawerBottom,
  swipe_area? : Int = 0,
  open? : Bool,
  closedby? : String = "any",
  on_close? : @cmd.Emit[String],
  on_cancel? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let attrs = ui_attrs(attrs)
    .data_set("slot", "drawer")
    .data_set("direction", drawer_direction_value(direction))
  if swipe_area > 0 {
    drawer_bind_pointer_attrs(attrs, direction)
  }
  let swipe_area_style = match direction {
    DrawerTop =>
      "top:calc(100% + 1px);left:calc(-1 * (var(--rui-drawer-inset,0.5rem) + 1px));width:100vw;height:\{swipe_area}px"
    DrawerRight =>
      "right:calc(100% + 1px);top:calc(-1 * (var(--rui-drawer-inset,0.5rem) + 1px));width:\{swipe_area}px;height:100dvh"
    DrawerBottom =>
      "bottom:calc(100% + 1px);left:calc(-1 * (var(--rui-drawer-inset,0.5rem) + 1px));width:100vw;height:\{swipe_area}px"
    DrawerLeft =>
      "left:calc(100% + 1px);top:calc(-1 * (var(--rui-drawer-inset,0.5rem) + 1px));width:\{swipe_area}px;height:100dvh"
  }
  @html.dialog(
    id?,
    class?,
    title?,
    hidden?,
    open?,
    closedby~,
    on_close?,
    on_cancel?,
    attrs~,
    style=ui_styles(
      [UiBoxSizing, DrawerStyle, drawer_direction_style(direction)],
      style,
    ),
    [
      if swipe_area > 0 {
        @html.div(
          attrs=@html.Attrs::build()
            .data_set("slot", "drawer-swipe-area")
            .aria_hidden("true"),
          style=[UiBoxSizing, DrawerSwipeAreaStyle, swipe_area_style],
          @html.nothing,
        )
      } else {
        @html.nothing
      },
      @html.div(style=[UiBoxSizing, DrawerContentStyle], children),
    ],
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
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.h2(
    style=ui_styles([UiBoxSizing, DrawerTitleStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "drawer-title"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] drawer_description(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.p(
    style=ui_styles([UiBoxSizing, DrawerDescriptionStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "drawer-description"),
    children,
  )
}
