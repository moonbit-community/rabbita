///|
/// Edge from which a [`drawer_content`] surface is presented.
pub(all) enum DrawerDirection {
  DrawerTop
  DrawerRight
  DrawerBottom
  DrawerLeft
} derive(Debug, Eq)

///|
/// Explicit compound-component scope created by [`drawer`].
struct DrawerScope(DialogScope)

///|
const DrawerPositionerStyle : String = "position:fixed;inset:0;z-index:51;display:flex;overflow:hidden;pointer-events:none"

///|
const DrawerSurfaceStyle : String = "position:relative;display:flex;min-width:0;min-height:0;flex-direction:column;overflow:auto;background:var(--rui-popover,var(--rui-background,oklch(1 0 0)));color:var(--rui-popover-foreground,var(--rui-foreground,oklch(0.145 0 0)));box-shadow:0 16px 48px rgb(0 0 0 / 0.2);opacity:var(--rui-drawer-opacity,1);transform:var(--rui-drawer-transform,translate3d(0,0,0));pointer-events:auto;transition:opacity 200ms ease,transform 200ms ease"

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
fn drawer_motion_style(direction : DrawerDirection, open : Bool) -> String {
  if open {
    "--rui-drawer-opacity:1;--rui-drawer-transform:translate3d(0,0,0)"
  } else {
    match direction {
      DrawerTop =>
        "--rui-drawer-opacity:0;--rui-drawer-transform:translate3d(0,-100%,0);pointer-events:none"
      DrawerRight =>
        "--rui-drawer-opacity:0;--rui-drawer-transform:translate3d(100%,0,0);pointer-events:none"
      DrawerBottom =>
        "--rui-drawer-opacity:0;--rui-drawer-transform:translate3d(0,100%,0);pointer-events:none"
      DrawerLeft =>
        "--rui-drawer-opacity:0;--rui-drawer-transform:translate3d(-100%,0,0);pointer-events:none"
    }
  }
}

///|
#cfg(target="js")
extern "js" fn ffi_drawer_pointer_start(
  event : @dom.MouseEvent,
  direction : String,
) -> Bool =
  #| (event, direction) => {
  #|   if (event.defaultPrevented || event.isPrimary === false) return false
  #|   if (event.pointerType === "mouse" && event.button !== 0) return false
  #|   const surface = event.currentTarget
  #|   const handle = event.target?.closest?.('[data-slot="drawer-handle"]')
  #|   if (!surface || !handle || !surface.contains?.(handle)) return false
  #|   surface.__ruiDrawerDrag?.cancel?.()
  #|   const pointerId = event.pointerId ?? 1
  #|   const horizontal = direction === "left" || direction === "right"
  #|   const sign = direction === "left" || direction === "top" ? -1 : 1
  #|   const overlay = surface.closest?.("dialog")?.querySelector?.('[data-slot="drawer-overlay"]')
  #|   const state = {
  #|     pointerId,
  #|     horizontal,
  #|     sign,
  #|     startX: event.clientX,
  #|     startY: event.clientY,
  #|     startTime: Number.isFinite(event.timeStamp) ? event.timeStamp : Date.now(),
  #|     size: horizontal ? surface.clientWidth : surface.clientHeight,
  #|     active: false,
  #|     overlay,
  #|     originalTransform: surface.style.getPropertyValue("--rui-drawer-transform"),
  #|     originalTransition: surface.style.getPropertyValue("transition"),
  #|     originalOverlayOpacity: overlay?.style?.getPropertyValue("--rui-dialog-overlay-opacity") || "",
  #|   }
  #|   state.restore = () => {
  #|     if (state.originalTransform) {
  #|       surface.style.setProperty("--rui-drawer-transform", state.originalTransform)
  #|     } else {
  #|       surface.style.removeProperty("--rui-drawer-transform")
  #|     }
  #|     if (state.originalTransition) surface.style.setProperty("transition", state.originalTransition)
  #|     else surface.style.removeProperty("transition")
  #|     if (overlay?.style) {
  #|       if (state.originalOverlayOpacity) {
  #|         overlay.style.setProperty("--rui-dialog-overlay-opacity", state.originalOverlayOpacity)
  #|       } else {
  #|         overlay.style.removeProperty("--rui-dialog-overlay-opacity")
  #|       }
  #|     }
  #|     delete surface.dataset.dragging
  #|     try { surface.releasePointerCapture?.(pointerId) } catch (_) { }
  #|     if (surface.__ruiDrawerDrag === state) delete surface.__ruiDrawerDrag
  #|   }
  #|   state.finish = () => {
  #|     // Keep the dragged transform and overlay opacity as the start of the
  #|     // close transition. The incremental closed-state patch supplies the
  #|     // final off-screen transform without an intervening snap to open.
  #|     if (state.originalTransition) surface.style.setProperty("transition", state.originalTransition)
  #|     else surface.style.removeProperty("transition")
  #|     delete surface.dataset.dragging
  #|     try { surface.releasePointerCapture?.(pointerId) } catch (_) { }
  #|     if (surface.__ruiDrawerDrag === state) delete surface.__ruiDrawerDrag
  #|   }
  #|   state.cancel = state.restore
  #|   surface.__ruiDrawerDrag = state
  #|   try { surface.setPointerCapture?.(pointerId) } catch (_) { }
  #|   return true
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_drawer_pointer_move(event : @dom.MouseEvent) -> Bool =
  #| event => {
  #|   const surface = event.currentTarget
  #|   const state = surface?.__ruiDrawerDrag
  #|   if (!state || (event.pointerId ?? 1) !== state.pointerId) return false
  #|   const delta = state.horizontal
  #|     ? event.clientX - state.startX
  #|     : event.clientY - state.startY
  #|   const cross = state.horizontal
  #|     ? event.clientY - state.startY
  #|     : event.clientX - state.startX
  #|   const progress = delta * state.sign
  #|   if (!state.active) {
  #|     if (Math.abs(delta) < 6 || Math.abs(delta) <= Math.abs(cross)) return false
  #|     state.active = true
  #|     surface.dataset.dragging = "true"
  #|   }
  #|   const visual = progress < 0 ? delta * 0.2 : delta
  #|   surface.style.setProperty("transition", "none")
  #|   surface.style.setProperty(
  #|     "--rui-drawer-transform",
  #|     state.horizontal
  #|       ? `translate3d(${visual}px,0,0)`
  #|       : `translate3d(0,${visual}px,0)`,
  #|   )
  #|   if (state.overlay?.style) {
  #|     const ratio = Math.min(Math.max(progress / Math.max(1, state.size), 0), 1)
  #|     state.overlay.style.setProperty("--rui-dialog-overlay-opacity", String(1 - ratio))
  #|   }
  #|   return true
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_drawer_pointer_end(event : @dom.MouseEvent) -> Bool =
  #| event => {
  #|   const surface = event.currentTarget
  #|   const state = surface?.__ruiDrawerDrag
  #|   if (!state || (event.pointerId ?? 1) !== state.pointerId) return false
  #|   const delta = state.horizontal
  #|     ? event.clientX - state.startX
  #|     : event.clientY - state.startY
  #|   const progress = delta * state.sign
  #|   const now = Number.isFinite(event.timeStamp) ? event.timeStamp : Date.now()
  #|   const elapsed = Math.max(1, now - state.startTime)
  #|   const threshold = Math.min(160, Math.max(48, state.size * 0.25))
  #|   const dismiss = state.active && progress > 0
  #|     && (progress >= threshold || (progress >= 16 && progress / elapsed >= 0.5))
  #|   if (dismiss) state.finish()
  #|   else state.restore()
  #|   return dismiss
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_drawer_pointer_cancel(event : @dom.MouseEvent) -> Unit =
  #| event => {
  #|   const surface = event.currentTarget
  #|   const state = surface?.__ruiDrawerDrag
  #|   if (!state || (event.pointerId ?? 1) !== state.pointerId) return
  #|   state.cancel()
  #| }

///|
#cfg(target="js")
fn drawer_bind_pointer_attrs(
  attrs : @html.Attrs,
  direction : DrawerDirection,
  close_command : @cmd.Cmd,
) -> Unit {
  ignore(
    attrs
    .on_pointerdown_after(event => {
      ignore(ffi_drawer_pointer_start(event, drawer_direction_value(direction)))
      @cmd.none
    })
    .on_pointermove_after(event => {
      if ffi_drawer_pointer_move(event) {
        event.prevent_default()
      }
      @cmd.none
    })
    .on_pointerup_after(event => {
      if ffi_drawer_pointer_end(event) {
        event.prevent_default()
        close_command
      } else {
        @cmd.none
      }
    })
    .on_pointercancel_after(event => {
      ffi_drawer_pointer_cancel(event)
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
      "width:0.25rem;height:3rem;margin:auto 0 auto 0.5rem;border-radius:999px;background:var(--rui-muted,oklch(0.97 0 0))"
    DrawerLeft =>
      "width:0.25rem;height:3rem;margin:auto 0.5rem auto auto;border-radius:999px;background:var(--rui-muted,oklch(0.97 0 0))"
  }
}

///|
fn drawer_close_icon(scope : DialogScope, label : String) -> @html.Html {
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
  dialog(
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
