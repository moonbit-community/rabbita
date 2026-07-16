///|
pub(all) enum ToastVariant {
  ToastDefault
  ToastDestructive
  ToastSuccess
} derive(Debug, Eq)

///|
priv struct ToastEntry {
  id : Int
  title : String
  description : String?
  variant : ToastVariant
  closing : Bool
  swipe_direction : Int
} derive(Eq)

///|
priv struct ToastModel {
  next_id : Int
  entries : Array[ToastEntry]
  pause_sources : Array[String]
  expired : Array[Int]
} derive(Eq)

///|
priv enum ToastMsg {
  ShowToast(String, String?, ToastVariant, Int)
  DismissToast(Int, Int)
  AutoDismissToast(Int)
  SetToastPaused(String, Bool)
  RemoveToast(Int)
  DismissAllToasts
}

///|
const ToastExitDurationMs : Int = 150

///|
const ToastSurfaceStyle : String = "position:relative;display:grid;width:100%;grid-template-columns:1fr auto;align-items:start;gap:0.25rem 0.75rem;border:1px solid;border-radius:var(--rui-toast-radius,var(--rui-toast-base-radius,1rem));padding:0.875rem 1rem;box-shadow:var(--rui-toast-shadow,var(--rui-toast-base-shadow,0 4px 12px rgb(0 0 0 / 0.1)));touch-action:pan-y;transition:opacity 150ms ease,transform 150ms ease,box-shadow 200ms ease"

///|
const ToastCardShadowStyle : String = "--rui-toast-base-shadow:0 4px 12px rgb(0 0 0 / 0.1)"

///|
const ToastViewportStyle : String = "position:fixed;z-index:100;display:flex;flex-direction:column;overflow:visible;border:0;background:transparent;box-shadow:none;pointer-events:none"

///|
const ToasterViewportStyle : String = "width:min(26rem,calc(100vw - 2rem));max-height:calc(100dvh - 2rem);gap:0.5rem;--rui-toast-base-offset:1rem"

///|
const SonnerViewportStyle : String = "width:min(22.25rem,calc(100vw - 3rem));max-height:calc(100dvh - 3rem);gap:0.875rem;--rui-toast-base-offset:1.5rem"

///|
/// Opaque command scope owned by `toaster` or `sonner`.
struct ToastScope {
  emit : @cmd.Emit[ToastMsg]
}

///|
pub fn ToastScope::show(
  self : ToastScope,
  title~ : String,
  description? : String,
  variant? : ToastVariant = ToastDefault,
  duration_ms? : Int = 4000,
) -> @cmd.Cmd {
  (self.emit)(ShowToast(title, description, variant, duration_ms))
}

///|
pub fn ToastScope::dismiss(self : ToastScope, id~ : Int) -> @cmd.Cmd {
  (self.emit)(DismissToast(id, 0))
}

///|
pub fn ToastScope::dismiss_all(self : ToastScope) -> @cmd.Cmd {
  (self.emit)(DismissAllToasts)
}

///|
fn toast_variant_value(variant : ToastVariant) -> String {
  match variant {
    ToastDefault => "default"
    ToastDestructive => "destructive"
    ToastSuccess => "success"
  }
}

///|
fn toast_variant_style(variant : ToastVariant, rich_colors : Bool) -> String {
  match variant {
    ToastDefault =>
      "border-color:var(--rui-border,oklch(0.922 0 0));background:var(--rui-background,white);color:var(--rui-foreground,oklch(0.145 0 0))"
    ToastDestructive =>
      if rich_colors {
        "border-color:color-mix(in oklch,var(--rui-destructive,oklch(0.577 0.245 27.325)) 35%,transparent);background:color-mix(in oklch,var(--rui-destructive,oklch(0.577 0.245 27.325)) 12%,var(--rui-background,white));color:var(--rui-destructive,oklch(0.577 0.245 27.325))"
      } else {
        "border-color:var(--rui-destructive-border,var(--rui-destructive,oklch(0.577 0.245 27.325)));background:var(--rui-background,white);color:var(--rui-destructive,oklch(0.577 0.245 27.325))"
      }
    ToastSuccess =>
      if rich_colors {
        "border-color:oklch(0.72 0.17 142 / 0.45);background:oklch(0.97 0.04 142);color:oklch(0.38 0.12 142)"
      } else {
        "border-color:var(--rui-border,oklch(0.922 0 0));background:var(--rui-background,white);color:var(--rui-foreground,oklch(0.145 0 0))"
      }
  }
}

///|
pub fn[C : @html.IsChildren] toast(
  variant? : ToastVariant = ToastDefault,
  open? : Bool = true,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    hidden=!open,
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .role(if variant is ToastDestructive { "alert" } else { "status" })
      .aria_live(
        if variant is ToastDestructive {
          "assertive"
        } else {
          "polite"
        },
      )
      .aria_atomic("true")
      .data_set("slot", "toast")
      .data_set("state", if open { "open" } else { "closed" })
      .data_set("variant", toast_variant_value(variant)),
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        ToastSurfaceStyle,
        ToastCardShadowStyle,
        if open {
          "opacity:1;transform:translateY(0) scale(1)"
        } else {
          "opacity:0;transform:translateY(0.5rem) scale(0.98);pointer-events:none"
        },
        toast_variant_style(variant, false),
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] toast_title(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "toast-title"),
    style=ui_styles(
      ["font-size:0.875rem;line-height:1.25rem;font-weight:500"],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] toast_description(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "toast-description"),
    style=ui_styles(
      [
        "grid-column:1;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.8125rem;line-height:1.25rem",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] toast_action(
  on_click? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  button(
    variant=Outline,
    size=Sm,
    slot="toast-action",
    on_click?,
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "toast-action"),
    style~,
    children,
  )
}

///|
pub fn toast_close(
  scope~ : ToastScope,
  toast_id~ : Int,
  label? : String = "Close notification",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  button(
    variant=Ghost,
    size=IconXs,
    slot="toast-close",
    on_click=scope.dismiss(id=toast_id),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).aria_label(label).data_set("slot", "toast-close"),
    style~,
    ui_x_icon(),
  )
}

///|
fn toast_trimmed(
  entries : Array[ToastEntry],
  max_toasts : Int,
) -> Array[ToastEntry] {
  let limit = if max_toasts < 1 { 1 } else { max_toasts }
  let start = if entries.length() > limit {
    entries.length() - limit
  } else {
    0
  }
  let result : Array[ToastEntry] = []
  for index, entry in entries {
    if index >= start {
      result.push(entry)
    }
  }
  result
}

///|
fn toast_remove(entries : Array[ToastEntry], id : Int) -> Array[ToastEntry] {
  let result : Array[ToastEntry] = []
  for entry in entries {
    if entry.id != id {
      result.push(entry)
    }
  }
  result
}

///|
fn toast_mark_closing(
  entries : Array[ToastEntry],
  id : Int,
  swipe_direction : Int,
) -> (Array[ToastEntry], Bool) {
  let result : Array[ToastEntry] = []
  let mut changed = false
  for entry in entries {
    if entry.id == id && !entry.closing {
      result.push({ ..entry, closing: true, swipe_direction })
      changed = true
    } else {
      result.push(entry)
    }
  }
  (result, changed)
}

///|
fn toast_mark_all_closing(
  entries : Array[ToastEntry],
) -> (Array[ToastEntry], Array[Int]) {
  let result : Array[ToastEntry] = []
  let ids : Array[Int] = []
  for entry in entries {
    if entry.closing {
      result.push(entry)
    } else {
      result.push({ ..entry, closing: true, swipe_direction: 0 })
      ids.push(entry.id)
    }
  }
  (result, ids)
}

///|
#cfg(target="js")
extern "js" fn ffi_toast_pointer_start(event : @dom.MouseEvent) -> Bool =
  #| event => {
  #|   const surface = event.currentTarget
  #|   if (!surface || surface.__ruiToastSwipe) return false
  #|   if (event.isPrimary === false || (event.button ?? 0) !== 0) return false
  #|   if (event.target?.closest?.("button,a,input,textarea,select,[contenteditable=true]")) return false
  #|   const pointerId = event.pointerId ?? 1
  #|   const direction = typeof getComputedStyle === "function"
  #|     && getComputedStyle(surface).direction === "rtl" ? -1 : 1
  #|   const state = {
  #|     pointerId,
  #|     startX: event.clientX,
  #|     startY: event.clientY,
  #|     startTime: Number.isFinite(event.timeStamp) ? event.timeStamp : Date.now(),
  #|     direction,
  #|     active: false,
  #|     transition: surface.style.getPropertyValue("transition"),
  #|   }
  #|   const restore = () => {
  #|     surface.style.removeProperty("--rui-toast-swipe-x")
  #|     if (state.transition) surface.style.setProperty("transition", state.transition)
  #|     else surface.style.removeProperty("transition")
  #|     delete surface.dataset.swipe
  #|     try { surface.releasePointerCapture?.(pointerId) } catch (_) { }
  #|     if (surface.__ruiToastSwipe === state) delete surface.__ruiToastSwipe
  #|   }
  #|   state.restore = restore
  #|   surface.__ruiToastSwipe = state
  #|   try { surface.setPointerCapture?.(pointerId) } catch (_) { }
  #|   return true
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_toast_pointer_move(event : @dom.MouseEvent) -> Bool =
  #| event => {
  #|   const surface = event.currentTarget
  #|   const state = surface?.__ruiToastSwipe
  #|   if (!state || (event.pointerId ?? 1) !== state.pointerId) return false
  #|   const deltaX = event.clientX - state.startX
  #|   const deltaY = event.clientY - state.startY
  #|   if (!state.active) {
  #|     if (Math.abs(deltaX) < 6 && Math.abs(deltaY) < 6) return false
  #|     if (Math.abs(deltaX) <= Math.abs(deltaY)) {
  #|       state.restore()
  #|       return false
  #|     }
  #|     state.active = true
  #|     surface.dataset.swipe = "move"
  #|   }
  #|   const progress = deltaX * state.direction
  #|   const visual = progress < 0 ? deltaX * 0.2 : deltaX
  #|   surface.style.setProperty("transition", "none")
  #|   surface.style.setProperty("--rui-toast-swipe-x", `${visual}px`)
  #|   return true
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_toast_pointer_end(event : @dom.MouseEvent) -> Int =
  #| event => {
  #|   const surface = event.currentTarget
  #|   const state = surface?.__ruiToastSwipe
  #|   if (!state || (event.pointerId ?? 1) !== state.pointerId) return 0
  #|   const deltaX = event.clientX - state.startX
  #|   const progress = deltaX * state.direction
  #|   const now = Number.isFinite(event.timeStamp) ? event.timeStamp : Date.now()
  #|   const elapsed = Math.max(1, now - state.startTime)
  #|   const threshold = Math.min(160, Math.max(48, surface.clientWidth * 0.35))
  #|   const dismiss = state.active && progress > 0
  #|     && (progress >= threshold || (progress >= 16 && progress / elapsed >= 0.5))
  #|   const active = state.active
  #|   state.restore()
  #|   if (dismiss) return state.direction * 2
  #|   return active ? 1 : 0
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_toast_pointer_cancel(event : @dom.MouseEvent) -> Unit =
  #| event => {
  #|   const surface = event.currentTarget
  #|   const state = surface?.__ruiToastSwipe
  #|   if (!state || (event.pointerId ?? 1) !== state.pointerId) return
  #|   state.restore()
  #| }

///|
#cfg(target="js")
fn toast_bind_pointer_attrs(
  attrs : @html.Attrs,
  scope : ToastScope,
  id : Int,
) -> Unit {
  ignore(
    attrs
    .on_pointerdown_after(event => {
      ignore(ffi_toast_pointer_start(event))
      @cmd.none
    })
    .on_pointermove_after(event => {
      if ffi_toast_pointer_move(event) {
        event.prevent_default()
      }
      @cmd.none
    })
    .on_pointerup_after(event => {
      let result = ffi_toast_pointer_end(event)
      if result != 0 {
        event.prevent_default()
      }
      if result == 2 {
        (scope.emit)(DismissToast(id, 1))
      } else if result == -2 {
        (scope.emit)(DismissToast(id, -1))
      } else {
        @cmd.none
      }
    })
    .on_pointercancel_after(event => {
      ffi_toast_pointer_cancel(event)
      @cmd.none
    }),
  )
}

///|
#cfg(not(target="js"))
fn toast_bind_pointer_attrs(
  attrs : @html.Attrs,
  scope : ToastScope,
  id : Int,
) -> Unit {
  ignore((attrs, scope, id))
}

///|
fn toast_entry_view(
  scope : ToastScope,
  entry : ToastEntry,
  rich_colors : Bool,
) -> @html.Html {
  let variant = entry.variant
  let element_attrs = @html.Attrs::build()
    .role(if variant is ToastDestructive { "alert" } else { "status" })
    .aria_live(if variant is ToastDestructive { "assertive" } else { "polite" })
    .aria_atomic("true")
    .data_set("slot", "toast")
    .data_set("toast-id", "\{entry.id}")
    .data_set("state", if entry.closing { "closed" } else { "open" })
    .data_set("variant", toast_variant_value(variant))
    .data_set("swipe-direction", "inline-end")
    .on_mouseenter(_ => (scope.emit)(SetToastPaused("hover-\{entry.id}", true)))
    .on_mouseleave(_ => (scope.emit)(SetToastPaused("hover-\{entry.id}", false)))
  toast_bind_pointer_attrs(element_attrs, scope, entry.id)
  let close_attrs = @html.Attrs::build()
    .on_focus(_ => (scope.emit)(SetToastPaused("focus-\{entry.id}", true)))
    .on_blur(_ => (scope.emit)(SetToastPaused("focus-\{entry.id}", false)))
  @html.div(
    attrs=element_attrs,
    style=[
      UiBoxSizing,
      UiFontSans,
      ToastSurfaceStyle,
      ToastCardShadowStyle,
      if entry.closing {
        if entry.swipe_direction < 0 {
          "opacity:0;transform:translate3d(-110%,0,0) scale(0.98);pointer-events:none"
        } else if entry.swipe_direction > 0 {
          "opacity:0;transform:translate3d(110%,0,0) scale(0.98);pointer-events:none"
        } else {
          "opacity:0;transform:translate3d(0,0.5rem,0) scale(0.98);pointer-events:none"
        }
      } else {
        "opacity:1;transform:translate3d(var(--rui-toast-swipe-x,0px),0,0) scale(1);pointer-events:auto"
      },
      toast_variant_style(variant, rich_colors),
    ],
    [
      toast_title(entry.title),
      toast_close(scope~, toast_id=entry.id, attrs=close_attrs),
      if entry.description is Some(description) {
        toast_description(description)
      } else {
        @html.nothing
      },
    ],
  )
}

///|
fn render_toaster(
  model : ToastModel,
  scope : ToastScope,
  slot : String,
  rich_colors : Bool,
  position : String,
  class : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : (ToastScope) -> @html.Html,
) -> @html.Html {
  let entries : Array[@html.Html] = []
  for entry in model.entries {
    entries.push(toast_entry_view(scope, entry, rich_colors))
  }
  @html.fragment([
    children(scope),
    @html.div(
      class?,
      attrs=ui_attrs(attrs)
        .role("region")
        .aria_label("Notifications")
        .data_set("slot", slot)
        .data_set("position", position),
      style=ui_styles(
        [
          UiBoxSizing,
          ToastViewportStyle,
          if rich_colors {
            SonnerViewportStyle
          } else {
            ToasterViewportStyle
          },
          if position == "top-left" {
            "top:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem));left:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem))"
          } else if position == "top-center" {
            "top:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem));left:50%;transform:translateX(-50%)"
          } else if position == "top-right" {
            "top:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem));right:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem))"
          } else if position == "bottom-left" {
            "bottom:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem));left:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem))"
          } else if position == "bottom-center" {
            "bottom:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem));left:50%;transform:translateX(-50%)"
          } else {
            "right:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem));bottom:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem))"
          },
        ],
        style,
      ),
      entries,
    ),
  ])
}

///|
#cfg(target="js")
extern "js" fn ffi_bind_toast_document_pause(
  slot : String,
  changed : (Bool) -> Unit,
) -> Unit =
  #| (slot, changed) => {
  #|   if (typeof document === "undefined") return
  #|   const callbacks = document.__ruiToastPauseCallbacks ||= new Map()
  #|   callbacks.set(slot, changed)
  #|   if (!document.__ruiToastPauseBound) {
  #|     document.__ruiToastPauseBound = true
  #|     const notify = paused => {
  #|       for (const callback of document.__ruiToastPauseCallbacks?.values?.() || []) {
  #|         callback(paused)
  #|       }
  #|     }
  #|     document.addEventListener("visibilitychange", () => {
  #|       notify(document.visibilityState === "hidden")
  #|     })
  #|     if (typeof window !== "undefined") {
  #|       window.addEventListener("blur", () => notify(true))
  #|       window.addEventListener("focus", () => {
  #|         if (document.visibilityState !== "hidden") notify(false)
  #|       })
  #|     }
  #|   }
  #|   changed(document.visibilityState === "hidden")
  #| }

///|
#cfg(target="js")
fn toast_bind_document_pause_cmd(
  slot : String,
  emit : @cmd.Emit[ToastMsg],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, scheduler => {
    ffi_bind_toast_document_pause(slot, paused => {
      scheduler.add(emit(SetToastPaused("document", paused)))
    })
  })
}

///|
fn toast_remove_pause_source(
  sources : Array[String],
  source : String,
) -> Array[String] {
  let result : Array[String] = []
  for value in sources {
    if value != source {
      result.push(value)
    }
  }
  result
}

///|
fn toast_remove_entry_pause_sources(
  sources : Array[String],
  id : Int,
) -> Array[String] {
  let result = toast_remove_pause_source(sources, "hover-\{id}")
  toast_remove_pause_source(result, "focus-\{id}")
}

///|
fn toast_contains_entry(entries : Array[ToastEntry], id : Int) -> Bool {
  for entry in entries {
    if entry.id == id {
      return true
    }
  }
  false
}

///|
fn toast_filter_expired(
  expired : Array[Int],
  entries : Array[ToastEntry],
) -> Array[Int] {
  let result : Array[Int] = []
  for id in expired {
    if toast_contains_entry(entries, id) {
      result.push(id)
    }
  }
  result
}

///|
fn toast_with_pause_sources(
  model : ToastModel,
  pause_sources : Array[String],
) -> (ToastModel, Array[Int]) {
  let resumed = model.pause_sources.length() > 0 && pause_sources.length() == 0
  (
    {
      ..model,
      pause_sources,
      expired: if resumed {
        []
      } else {
        model.expired
      },
    },
    if resumed {
      model.expired.copy()
    } else {
      []
    },
  )
}

///|
fn toast_set_paused(
  model : ToastModel,
  source : String,
  paused : Bool,
) -> (ToastModel, Array[Int]) {
  if paused {
    if model.pause_sources.contains(source) {
      (model, [])
    } else {
      let pause_sources = model.pause_sources.copy()
      pause_sources.push(source)
      toast_with_pause_sources(model, pause_sources)
    }
  } else if !model.pause_sources.contains(source) {
    (model, [])
  } else {
    toast_with_pause_sources(
      model,
      toast_remove_pause_source(model.pause_sources, source),
    )
  }
}

///|
#cfg(target="js")
fn toaster_impl(
  slot : String,
  rich_colors : Bool,
  max_toasts : Int,
  position : String,
  class : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : (ToastScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  let (model, emit) = @rabbita.create_state_with_init(
    init=emit => {
      (
        { next_id: 1, entries: [], pause_sources: [], expired: [] },
        toast_bind_document_pause_cmd(slot, emit),
      )
    },
    update=fn(emit, msg, model) {
      match msg {
        ShowToast(title, description, variant, duration_ms) => {
          let id = model.next_id
          let entries = model.entries.copy()
          entries.push({
            id,
            title,
            description,
            variant,
            closing: false,
            swipe_direction: 0,
          })
          let entries = toast_trimmed(entries, max_toasts)
          let mut pause_sources = model.pause_sources
          for previous in model.entries {
            if !toast_contains_entry(entries, previous.id) {
              pause_sources = toast_remove_entry_pause_sources(
                pause_sources,
                previous.id,
              )
            }
          }
          let filtered = {
            ..model,
            next_id: id + 1,
            entries,
            expired: toast_filter_expired(model.expired, entries),
          }
          let (next, resume_ids) = toast_with_pause_sources(
            filtered, pause_sources,
          )
          let commands : Array[@cmd.Cmd] = []
          if duration_ms > 0 {
            commands.push(
              @rabbita.delay(emit(AutoDismissToast(id)), duration_ms),
            )
          }
          for expired_id in resume_ids {
            commands.push(emit(DismissToast(expired_id, 0)))
          }
          (next, @cmd.batch(commands))
        }
        DismissToast(id, swipe_direction) => {
          let (entries, changed) = toast_mark_closing(
            model.entries,
            id,
            swipe_direction,
          )
          let (unpaused, resume_ids) = toast_with_pause_sources(
            model,
            toast_remove_entry_pause_sources(model.pause_sources, id),
          )
          let commands : Array[@cmd.Cmd] = []
          if changed {
            commands.push(
              @rabbita.delay(emit(RemoveToast(id)), ToastExitDurationMs),
            )
          }
          for expired_id in resume_ids {
            commands.push(emit(DismissToast(expired_id, 0)))
          }
          ({ ..unpaused, entries, }, @cmd.batch(commands))
        }
        AutoDismissToast(id) =>
          if !toast_contains_entry(model.entries, id) {
            (model, @cmd.none)
          } else if model.pause_sources.length() > 0 {
            let expired = model.expired.copy()
            if !expired.contains(id) {
              expired.push(id)
            }
            ({ ..model, expired, }, @cmd.none)
          } else {
            let (entries, changed) = toast_mark_closing(model.entries, id, 0)
            (
              { ..model, entries, },
              if changed {
                @rabbita.delay(emit(RemoveToast(id)), ToastExitDurationMs)
              } else {
                @cmd.none
              },
            )
          }
        SetToastPaused(source, paused) => {
          let (next, resume_ids) = toast_set_paused(model, source, paused)
          let commands : Array[@cmd.Cmd] = []
          for expired_id in resume_ids {
            commands.push(emit(DismissToast(expired_id, 0)))
          }
          (next, @cmd.batch(commands))
        }
        RemoveToast(id) => {
          let entries = toast_remove(model.entries, id)
          let cleaned = {
            ..model,
            entries,
            expired: toast_filter_expired(model.expired, entries),
          }
          let (next, resume_ids) = toast_with_pause_sources(
            cleaned,
            toast_remove_entry_pause_sources(cleaned.pause_sources, id),
          )
          let commands : Array[@cmd.Cmd] = []
          for expired_id in resume_ids {
            commands.push(emit(DismissToast(expired_id, 0)))
          }
          (next, @cmd.batch(commands))
        }
        DismissAllToasts => {
          let (entries, ids) = toast_mark_all_closing(model.entries)
          let mut pause_sources = model.pause_sources
          for entry in model.entries {
            pause_sources = toast_remove_entry_pause_sources(
              pause_sources,
              entry.id,
            )
          }
          let commands : Array[@cmd.Cmd] = []
          for id in ids {
            commands.push(
              @rabbita.delay(emit(RemoveToast(id)), ToastExitDurationMs),
            )
          }
          (
            { ..model, entries, pause_sources, expired: [] },
            @cmd.batch(commands),
          )
        }
      }
    },
  )
  model.view(model => {
    render_toaster(
      model,
      { emit, },
      slot,
      rich_colors,
      position,
      class,
      attrs,
      style,
      children,
    )
  })
}

///|
#cfg(not(target="js"))
fn toaster_impl(
  slot : String,
  rich_colors : Bool,
  max_toasts : Int,
  position : String,
  class : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : (ToastScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  ignore(max_toasts)
  let scope = { emit: @cmd.Emit(_ => @cmd.none) }
  @rabbita.Val::constant(
    render_toaster(
      { next_id: 1, entries: [], pause_sources: [], expired: [] },
      scope,
      slot,
      rich_colors,
      position,
      class,
      attrs,
      style,
      children,
    ),
  )
}

///|
pub fn toaster(
  max_toasts? : Int = 3,
  position? : String = "bottom-right",
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (ToastScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  toaster_impl(
    "toaster", false, max_toasts, position, class, attrs, style, children,
  )
}
