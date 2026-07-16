///|
pub(all) enum CarouselOrientation {
  CarouselHorizontal
  CarouselVertical
} derive(Debug, Eq)

///|
/// Opaque state passed from `carousel` to its compound content, item, and
/// previous/next controls.
struct CarouselScope {
  index : Int
  count : Int
  max_index : Int
  loop_ : Bool
  orientation : CarouselOrientation
  emit : @cmd.Emit[Int]
}

///|
#cfg(target="js")
priv struct CarouselModel {
  index : Int
  max_index : Int
} derive(Eq)

///|
#cfg(target="js")
priv enum CarouselMsg {
  CarouselSetIndex(Int)
  CarouselMeasured(Int)
}

///|
const CarouselRootStyle : String = "position:relative;display:block;width:100%;min-width:0;color:var(--rui-foreground,oklch(0.145 0 0))"

///|
const CarouselScopeStyle : String = "display:contents"

///|
const CarouselViewportStyle : String = "position:relative;width:100%;min-width:0;overflow:hidden;touch-action:var(--rui-carousel-touch-action,pan-y pinch-zoom);cursor:var(--rui-carousel-cursor,grab);user-select:var(--rui-carousel-user-select,auto);-webkit-user-select:var(--rui-carousel-user-select,auto)"

///|
const CarouselViewportVerticalStyle : String = "height:var(--rui-carousel-height,12rem);--rui-carousel-touch-action:pan-x pinch-zoom"

///|
const CarouselTrackStyle : String = "display:flex;min-width:0;will-change:transform;transition:var(--rui-carousel-track-transition,transform 300ms cubic-bezier(0.22,1,0.36,1))"

///|
const CarouselTrackHorizontalStyle : String = "flex-direction:row;margin-inline-start:-1rem"

///|
const CarouselTrackVerticalStyle : String = "height:100%;flex-direction:column;margin-top:-1rem"

///|
const CarouselItemStyle : String = "position:relative;min-width:0;flex-grow:0;flex-shrink:0;flex-basis:100%"

///|
const CarouselItemHorizontalStyle : String = "padding-inline-start:1rem"

///|
const CarouselItemVerticalStyle : String = "min-height:100%;padding-top:1rem"

///|
const CarouselControlStyle : String = "position:absolute;z-index:2;border-radius:9999px"

///|
const CarouselPreviousHorizontalStyle : String = "top:50%;inset-inline-start:var(--rui-carousel-control-inline-offset,-3rem);transform:translateY(-50%)"

///|
const CarouselNextHorizontalStyle : String = "top:50%;inset-inline-end:var(--rui-carousel-control-inline-offset,-3rem);transform:translateY(-50%)"

///|
const CarouselPreviousVerticalStyle : String = "top:var(--rui-carousel-control-block-offset,-3rem);left:50%;transform:translateX(-50%)"

///|
const CarouselNextVerticalStyle : String = "bottom:var(--rui-carousel-control-block-offset,-3rem);left:50%;transform:translateX(-50%)"

///|
const CarouselChevronBoxStyle : String = "display:inline-flex;width:1rem;height:1rem;flex-shrink:0;align-items:center;justify-content:center"

///|
const CarouselChevronStyle : String = "display:block;width:0.5rem;height:0.5rem;border-right:1.5px solid currentColor;border-bottom:1.5px solid currentColor;transform-origin:center"

///|
const CarouselChevronLeftStyle : String = "transform:rotate(135deg)"

///|
const CarouselChevronRightStyle : String = "transform:rotate(-45deg)"

///|
const CarouselChevronUpStyle : String = "transform:rotate(225deg)"

///|
const CarouselChevronDownStyle : String = "transform:rotate(45deg)"

///|
const CarouselScreenReaderStyle : String = "position:absolute;width:1px;height:1px;margin:-1px;padding:0;border:0;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap"

///|
fn carousel_orientation_value(orientation : CarouselOrientation) -> String {
  match orientation {
    CarouselHorizontal => "horizontal"
    CarouselVertical => "vertical"
  }
}

///|
fn carousel_count(count : Int) -> Int {
  if count < 0 {
    0
  } else {
    count
  }
}

///|
fn carousel_index(index : Int, count : Int) -> Int {
  if count <= 0 || index < 0 {
    0
  } else if index >= count {
    count - 1
  } else {
    index
  }
}

///|
fn carousel_previous_index(scope : CarouselScope) -> Int {
  if scope.max_index <= 0 {
    scope.index
  } else if scope.index > 0 {
    scope.index - 1
  } else if scope.loop_ {
    scope.max_index
  } else {
    scope.index
  }
}

///|
fn carousel_next_index(scope : CarouselScope) -> Int {
  if scope.max_index <= 0 {
    scope.index
  } else if scope.index < scope.max_index {
    scope.index + 1
  } else if scope.loop_ {
    0
  } else {
    scope.index
  }
}

///|
/// Return the active zero-based index from a compound carousel scope.
pub fn carousel_active_index(scope : CarouselScope) -> Int {
  scope.index
}

///|
/// Return the normalized number of slides from a compound carousel scope.
pub fn carousel_slide_count(scope : CarouselScope) -> Int {
  scope.count
}

///|
pub fn carousel_can_previous(scope : CarouselScope) -> Bool {
  scope.max_index > 0 && (scope.loop_ || scope.index > 0)
}

///|
pub fn carousel_can_next(scope : CarouselScope) -> Bool {
  scope.max_index > 0 && (scope.loop_ || scope.index < scope.max_index)
}

///|
fn carousel_track_transform(scope : CarouselScope) -> String {
  let offset = scope.index * 100
  match scope.orientation {
    CarouselHorizontal =>
      "--rui-carousel-ltr-offset:-\{offset}%;--rui-carousel-rtl-offset:\{offset}%;transform:translate3d(var(--rui-carousel-offset,var(--rui-carousel-ltr-offset)),0,0)"
    CarouselVertical =>
      "--rui-carousel-block-offset:-\{offset}%;transform:translate3d(0,var(--rui-carousel-offset,var(--rui-carousel-block-offset)),0)"
  }
}

///|
fn carousel_track_orientation_style(
  orientation : CarouselOrientation,
) -> String {
  match orientation {
    CarouselHorizontal => CarouselTrackHorizontalStyle
    CarouselVertical => CarouselTrackVerticalStyle
  }
}

///|
fn carousel_viewport_orientation_style(
  orientation : CarouselOrientation,
) -> String {
  match orientation {
    CarouselHorizontal => ""
    CarouselVertical => CarouselViewportVerticalStyle
  }
}

///|
fn carousel_item_orientation_style(orientation : CarouselOrientation) -> String {
  match orientation {
    CarouselHorizontal => CarouselItemHorizontalStyle
    CarouselVertical => CarouselItemVerticalStyle
  }
}

///|
fn carousel_control_position_style(
  orientation : CarouselOrientation,
  previous : Bool,
) -> String {
  match (orientation, previous) {
    (CarouselHorizontal, true) => CarouselPreviousHorizontalStyle
    (CarouselHorizontal, false) => CarouselNextHorizontalStyle
    (CarouselVertical, true) => CarouselPreviousVerticalStyle
    (CarouselVertical, false) => CarouselNextVerticalStyle
  }
}

///|
fn carousel_control_chevron_style(
  orientation : CarouselOrientation,
  previous : Bool,
) -> String {
  match (orientation, previous) {
    (CarouselHorizontal, true) => CarouselChevronLeftStyle
    (CarouselHorizontal, false) => CarouselChevronRightStyle
    (CarouselVertical, true) => CarouselChevronUpStyle
    (CarouselVertical, false) => CarouselChevronDownStyle
  }
}

///|
#cfg(target="js")
extern "js" fn ffi_carousel_key_step(
  event : @dom.KeyboardEvent,
  orientation : String,
) -> Int =
  #| (event, orientation) => {
  #|   if (event.altKey || event.ctrlKey || event.metaKey || event.shiftKey) return 0
  #|   const target = event.target
  #|   if (target?.closest?.('input,textarea,select,[contenteditable="true"]')) return 0
  #|   if (orientation === "vertical") {
  #|     if (event.key === "ArrowUp") return -1
  #|     if (event.key === "ArrowDown") return 1
  #|     return 0
  #|   }
  #|   const rtl = typeof getComputedStyle === "function"
  #|     && getComputedStyle(event.currentTarget).direction === "rtl"
  #|   if (event.key === "ArrowLeft") return rtl ? 1 : -1
  #|   if (event.key === "ArrowRight") return rtl ? -1 : 1
  #|   return 0
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_carousel_next_id() -> String =
  #| () => {
  #|   globalThis.__ruiCarouselId = (globalThis.__ruiCarouselId || 0) + 1
  #|   return `rui-carousel-${globalThis.__ruiCarouselId}`
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_carousel_sync_layout(
  id : String,
  notify : (Int) -> Unit,
) -> Unit =
  #| (id, notify) => {
  #|   if (typeof document === "undefined") return
  #|   const root = document.getElementById(id)
  #|   if (!root || root.dataset?.slot !== "carousel") return
  #|   const rootSelector = '[data-slot="carousel"]'
  #|   const own = element => element?.closest?.(rootSelector) === root
  #|   const all = selector => Array.from(root.querySelectorAll?.(selector) || []).filter(own)
  #|   const one = selector => all(selector)[0] || null
  #|   const viewport = one('[data-slot="carousel-content"]')
  #|   const track = one('[data-slot="carousel-track"]')
  #|   const items = all('[data-slot="carousel-item"]')
  #|   if (!viewport || !track || items.length === 0) return
  #|   root.__ruiCarouselNotify = notify
  #|   const finite = value => Number.isFinite(Number(value)) ? Number(value) : 0
  #|   const dimension = (item, vertical) => {
  #|     const offset = finite(vertical ? item.offsetHeight : item.offsetWidth)
  #|     if (offset > 0) return offset
  #|     const rect = item.getBoundingClientRect?.()
  #|     return Math.max(0, finite(vertical ? rect?.height : rect?.width))
  #|   }
  #|   const sync = suppressInitial => {
  #|     const orientation = root.dataset.orientation || "horizontal"
  #|     const vertical = orientation === "vertical"
  #|     const rtl = !vertical && typeof getComputedStyle === "function"
  #|       && getComputedStyle(viewport).direction === "rtl"
  #|     const first = items[0]
  #|     const firstRight = finite(first.offsetLeft) + dimension(first, false)
  #|     const firstTop = finite(first.offsetTop)
  #|     const starts = items.map(item => {
  #|       if (vertical) return Math.max(0, finite(item.offsetTop) - firstTop)
  #|       if (rtl) {
  #|         const right = finite(item.offsetLeft) + dimension(item, false)
  #|         return Math.max(0, firstRight - right)
  #|       }
  #|       return Math.max(0, finite(item.offsetLeft) - finite(first.offsetLeft))
  #|     })
  #|     const sizes = items.map(item => dimension(item, vertical))
  #|     const contentSpan = starts.reduce(
  #|       (span, start, index) => Math.max(span, start + sizes[index]),
  #|       0,
  #|     )
  #|     const viewportSize = Math.max(
  #|       0,
  #|       finite(vertical ? viewport.clientHeight : viewport.clientWidth),
  #|     )
  #|     const maxTravel = Math.max(0, contentSpan - viewportSize)
  #|     let maxIndex = 0
  #|     if (maxTravel > 0.5) {
  #|       const firstAtEnd = starts.findIndex(start => start >= maxTravel - 0.5)
  #|       maxIndex = firstAtEnd < 0 ? items.length - 1 : firstAtEnd
  #|     }
  #|     const requested = Math.max(0, Math.min(
  #|       items.length - 1,
  #|       finite(root.dataset.activeIndex),
  #|     ))
  #|     const index = Math.min(requested, maxIndex)
  #|     const travel = Math.max(0, Math.min(maxTravel, starts[index] || 0))
  #|     const offset = travel === 0 ? 0 : rtl ? travel : -travel
  #|     const loop = root.dataset.loop === "true"
  #|     const previous = track.__ruiCarouselIndex
  #|     const wrapped = loop && maxIndex > 0 && (
  #|       (previous === 0 && index === maxIndex)
  #|       || (previous === maxIndex && index === 0)
  #|     )
  #|     if ((suppressInitial && previous === undefined) || wrapped) {
  #|       const transition = track.style.getPropertyValue("transition")
  #|       const token = {}
  #|       track.__ruiCarouselTransitionToken = token
  #|       track.style.setProperty("transition", "none")
  #|       const restore = () => {
  #|         if (track.__ruiCarouselTransitionToken !== token) return
  #|         if (transition) track.style.setProperty("transition", transition)
  #|         else track.style.removeProperty("transition")
  #|         delete track.__ruiCarouselTransitionToken
  #|       }
  #|       if (typeof requestAnimationFrame === "function") requestAnimationFrame(restore)
  #|       else setTimeout(restore, 0)
  #|     }
  #|     track.style.setProperty("--rui-carousel-offset", `${offset}px`)
  #|     track.__ruiCarouselOffset = offset
  #|     track.__ruiCarouselIndex = index
  #|     root.dataset.maxSnapIndex = String(maxIndex)
  #|     items.forEach((item, itemIndex) => {
  #|       const visible = sizes[itemIndex] > 0
  #|         && starts[itemIndex] + sizes[itemIndex] > travel + 0.5
  #|         && starts[itemIndex] < travel + viewportSize - 0.5
  #|       item.dataset.visible = String(visible)
  #|       item.inert = !visible
  #|       if (visible) {
  #|         item.removeAttribute?.("aria-hidden")
  #|         item.removeAttribute?.("inert")
  #|       } else {
  #|         item.setAttribute?.("aria-hidden", "true")
  #|         item.setAttribute?.("inert", "")
  #|       }
  #|     })
  #|     const controls = [
  #|       [one('[data-slot="carousel-previous"]'), index > 0],
  #|       [one('[data-slot="carousel-next"]'), index < maxIndex],
  #|     ]
  #|     controls.forEach(([control, bounded]) => {
  #|       if (!control) return
  #|       const enabled = maxIndex > 0 && (loop || bounded)
  #|       control.disabled = !enabled
  #|       control.setAttribute?.("aria-disabled", String(!enabled))
  #|       control.dataset.state = enabled ? "enabled" : "disabled"
  #|       if (enabled) delete control.dataset.disabled
  #|       else control.dataset.disabled = ""
  #|     })
  #|     return maxIndex
  #|   }
  #|   const report = maxIndex => {
  #|     if (!Number.isFinite(maxIndex)) return
  #|     if (root.__ruiCarouselReportedMax === maxIndex) return
  #|     root.__ruiCarouselReportedMax = maxIndex
  #|     root.__ruiCarouselNotify?.(maxIndex)
  #|   }
  #|   root.__ruiCarouselResync = () => report(sync(false))
  #|   report(sync(true))
  #|   if (!root.__ruiCarouselResizeObserver && typeof ResizeObserver === "function") {
  #|     const observer = new ResizeObserver(() => {
  #|       if (root.isConnected === false) {
  #|         observer.disconnect()
  #|         delete root.__ruiCarouselResizeObserver
  #|         return
  #|       }
  #|       root.__ruiCarouselResync?.()
  #|     })
  #|     root.__ruiCarouselResizeObserver = observer
  #|     observer.observe(viewport)
  #|     observer.observe(track)
  #|     items.forEach(item => observer.observe(item))
  #|   } else {
  #|     const observer = root.__ruiCarouselResizeObserver
  #|     observer?.observe?.(viewport)
  #|     observer?.observe?.(track)
  #|     items.forEach(item => observer?.observe?.(item))
  #|   }
  #| }

///|
#cfg(target="js")
fn carousel_sync_layout_cmd(
  id : String,
  emit : @cmd.Emit[CarouselMsg],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, scheduler => {
    ui_after_mount(
      id,
      () => {
        ffi_carousel_sync_layout(id, max_index => {
          scheduler.add(emit(CarouselMeasured(max_index)))
        })
      },
      purpose="carousel-layout",
    )
  })
}

///|
#cfg(target="js")
extern "js" fn ffi_carousel_pointer_start(
  event : @dom.MouseEvent,
  orientation : String,
  index : Int,
  can_previous : Bool,
  can_next : Bool,
) -> Bool =
  #| (event, orientation, index, canPrevious, canNext) => {
  #|   if (event.defaultPrevented || event.isPrimary === false) return false
  #|   if (event.pointerType === "mouse" && event.button !== 0) return false
  #|   const viewport = event.currentTarget
  #|   const track = viewport?.querySelector?.('[data-slot="carousel-track"]')
  #|   if (!viewport || !track || (!canPrevious && !canNext)) return false
  #|   if (event.target?.closest?.('input,textarea,select,[contenteditable="true"]')) return false
  #|   viewport.__ruiCarouselDrag?.cancel?.()
  #|   const horizontal = orientation === "horizontal"
  #|   const rtl = horizontal && typeof getComputedStyle === "function"
  #|     && getComputedStyle(viewport).direction === "rtl"
  #|   const root = viewport.closest?.('[data-slot="carousel"]')
  #|   const measuredMax = Number(root?.dataset?.maxSnapIndex)
  #|   const maxIndex = Number.isFinite(measuredMax)
  #|     ? measuredMax
  #|     : Math.max(0, Number(root?.dataset?.count || 1) - 1)
  #|   const loop = root?.dataset?.loop === "true"
  #|   const measuredOffset = Number(track.__ruiCarouselOffset)
  #|   const pointerId = event.pointerId ?? 1
  #|   const originalTransform = track.style.getPropertyValue("transform")
  #|   const originalTransition = track.style.getPropertyValue("transition")
  #|   const originalCursor = viewport.style.getPropertyValue("--rui-carousel-cursor")
  #|   const originalUserSelect = viewport.style.getPropertyValue("--rui-carousel-user-select")
  #|   const state = {
  #|     pointerId,
  #|     horizontal,
  #|     rtl,
  #|     canPrevious,
  #|     canNext,
  #|     resistPrevious: loop && index <= 0,
  #|     resistNext: loop && index >= maxIndex,
  #|     startX: event.clientX,
  #|     startY: event.clientY,
  #|     startTime: Number.isFinite(event.timeStamp) ? event.timeStamp : Date.now(),
  #|     size: horizontal ? viewport.clientWidth : viewport.clientHeight,
  #|     baseOffset: Number.isFinite(measuredOffset) ? measuredOffset : null,
  #|     basePercent: index * 100 * (horizontal && rtl ? 1 : -1),
  #|     active: false,
  #|     suppressClick: null,
  #|   }
  #|   const removeClickSuppression = () => {
  #|     if (!state.suppressClick) return
  #|     viewport.removeEventListener?.("click", state.suppressClick, true)
  #|     state.suppressClick = null
  #|   }
  #|   state.installClickSuppression = () => {
  #|     if (state.suppressClick) return
  #|     state.suppressClick = click => {
  #|       click.preventDefault()
  #|       click.stopPropagation()
  #|       removeClickSuppression()
  #|     }
  #|     viewport.addEventListener?.("click", state.suppressClick, true)
  #|   }
  #|   state.restore = keepClickSuppression => {
  #|     if (originalTransform) track.style.setProperty("transform", originalTransform)
  #|     else track.style.removeProperty("transform")
  #|     if (originalTransition) track.style.setProperty("transition", originalTransition)
  #|     else track.style.removeProperty("transition")
  #|     if (originalCursor) viewport.style.setProperty("--rui-carousel-cursor", originalCursor)
  #|     else viewport.style.removeProperty("--rui-carousel-cursor")
  #|     if (originalUserSelect) viewport.style.setProperty("--rui-carousel-user-select", originalUserSelect)
  #|     else viewport.style.removeProperty("--rui-carousel-user-select")
  #|     delete viewport.dataset.dragging
  #|     try { viewport.releasePointerCapture?.(pointerId) } catch (_) { }
  #|     if (keepClickSuppression && state.suppressClick) {
  #|       setTimeout(removeClickSuppression, 0)
  #|     } else {
  #|       removeClickSuppression()
  #|     }
  #|     if (viewport.__ruiCarouselDrag === state) delete viewport.__ruiCarouselDrag
  #|   }
  #|   state.cancel = () => state.restore(false)
  #|   viewport.__ruiCarouselDrag = state
  #|   try { viewport.setPointerCapture?.(pointerId) } catch (_) { }
  #|   return true
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_carousel_pointer_move(event : @dom.MouseEvent) -> Bool =
  #| event => {
  #|   const viewport = event.currentTarget
  #|   const state = viewport?.__ruiCarouselDrag
  #|   if (!state || (event.pointerId ?? 1) !== state.pointerId) return false
  #|   const primary = state.horizontal
  #|     ? event.clientX - state.startX
  #|     : event.clientY - state.startY
  #|   const cross = state.horizontal
  #|     ? event.clientY - state.startY
  #|     : event.clientX - state.startX
  #|   if (!state.active) {
  #|     if (Math.abs(primary) < 6 || Math.abs(primary) <= Math.abs(cross)) return false
  #|     state.active = true
  #|     state.installClickSuppression()
  #|     viewport.dataset.dragging = "true"
  #|     viewport.style.setProperty("--rui-carousel-cursor", "grabbing")
  #|     viewport.style.setProperty("--rui-carousel-user-select", "none")
  #|   }
  #|   const towardNext = state.horizontal
  #|     ? state.rtl ? primary > 0 : primary < 0
  #|     : primary < 0
  #|   const blocked = towardNext
  #|     ? !state.canNext || state.resistNext
  #|     : !state.canPrevious || state.resistPrevious
  #|   const visual = blocked ? primary * 0.35 : primary
  #|   const track = viewport.querySelector('[data-slot="carousel-track"]')
  #|   if (!track) {
  #|     state.cancel()
  #|     return false
  #|   }
  #|   track.style.setProperty("transition", "none")
  #|   const base = state.baseOffset === null
  #|     ? `${state.basePercent}%`
  #|     : `${state.baseOffset}px`
  #|   const transform = state.horizontal
  #|     ? `translate3d(calc(${base} + ${visual}px),0,0)`
  #|     : `translate3d(0,calc(${base} + ${visual}px),0)`
  #|   track.style.setProperty("transform", transform)
  #|   return true
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_carousel_pointer_end(event : @dom.MouseEvent) -> Int =
  #| event => {
  #|   const viewport = event.currentTarget
  #|   const state = viewport?.__ruiCarouselDrag
  #|   if (!state || (event.pointerId ?? 1) !== state.pointerId) return 0
  #|   const primary = state.horizontal
  #|     ? event.clientX - state.startX
  #|     : event.clientY - state.startY
  #|   const now = Number.isFinite(event.timeStamp) ? event.timeStamp : Date.now()
  #|   const elapsed = Math.max(1, now - state.startTime)
  #|   const threshold = Math.min(64, Math.max(24, state.size * 0.12))
  #|   const qualifies = state.active
  #|     && (Math.abs(primary) >= threshold || (Math.abs(primary) >= 12 && Math.abs(primary / elapsed) >= 0.45))
  #|   const towardNext = state.horizontal
  #|     ? state.rtl ? primary > 0 : primary < 0
  #|     : primary < 0
  #|   let step = qualifies ? towardNext ? 1 : -1 : 0
  #|   if ((step > 0 && !state.canNext) || (step < 0 && !state.canPrevious)) step = 0
  #|   const dragged = state.active
  #|   state.restore(dragged)
  #|   return step || (dragged ? 2 : 0)
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_carousel_pointer_cancel(event : @dom.MouseEvent) -> Unit =
  #| event => {
  #|   const viewport = event.currentTarget
  #|   const state = viewport?.__ruiCarouselDrag
  #|   if (!state || (event.pointerId ?? 1) !== state.pointerId) return
  #|   state.cancel()
  #| }

///|
#cfg(target="js")
fn carousel_bind_pointer_attrs(
  attrs : @html.Attrs,
  scope : CarouselScope,
) -> Unit {
  ignore(
    attrs
    .on_pointerdown_after(event => {
      ignore(
        ffi_carousel_pointer_start(
          event,
          carousel_orientation_value(scope.orientation),
          scope.index,
          carousel_can_previous(scope),
          carousel_can_next(scope),
        ),
      )
      @cmd.none
    })
    .on_pointermove_after(event => {
      if ffi_carousel_pointer_move(event) {
        event.prevent_default()
      }
      @cmd.none
    })
    .on_pointerup_after(event => {
      let result = ffi_carousel_pointer_end(event)
      if result != 0 {
        event.prevent_default()
      }
      if result == -1 {
        (scope.emit)(carousel_previous_index(scope))
      } else if result == 1 {
        (scope.emit)(carousel_next_index(scope))
      } else {
        @cmd.none
      }
    })
    .on_pointercancel_after(event => {
      ffi_carousel_pointer_cancel(event)
      @cmd.none
    }),
  )
}

///|
#cfg(not(target="js"))
fn carousel_bind_pointer_attrs(
  attrs : @html.Attrs,
  scope : CarouselScope,
) -> Unit {
  ignore((attrs, scope))
}

///|
#cfg(target="js")
fn carousel_keyboard_attrs(scope : CarouselScope) -> @html.Attrs {
  let attrs = @html.Attrs::build().data_set("slot", "carousel-scope")
  ignore(
    attrs.on_keydown(event => {
      let step = ffi_carousel_key_step(
        event,
        carousel_orientation_value(scope.orientation),
      )
      if step < 0 && carousel_can_previous(scope) {
        event.prevent_default()
        (scope.emit)(carousel_previous_index(scope))
      } else if step > 0 && carousel_can_next(scope) {
        event.prevent_default()
        (scope.emit)(carousel_next_index(scope))
      } else {
        @cmd.none
      }
    }),
  )
  attrs
}

///|
#cfg(not(target="js"))
fn carousel_keyboard_attrs(scope : CarouselScope) -> @html.Attrs {
  ignore(scope)
  @html.Attrs::build().data_set("slot", "carousel-scope")
}

///|
fn carousel_status(scope : CarouselScope) -> @html.Html {
  let text = if scope.count == 0 {
    "No slides"
  } else {
    "Slide \{scope.index + 1} of \{scope.count}"
  }
  @html.span(
    style=[UiBoxSizing, CarouselScreenReaderStyle],
    attrs=@html.Attrs::build()
      .data_set("slot", "carousel-status")
      .aria_live("polite")
      .aria_atomic("true"),
    text,
  )
}

///|
fn[C : @html.IsChildren] render_carousel(
  scope : CarouselScope,
  aria_label : String?,
  id : String?,
  class : String?,
  title : String?,
  hidden : Bool?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : (CarouselScope) -> C,
) -> @html.Html {
  let root_attrs = ui_attrs(attrs)
    .data_set("slot", "carousel")
    .data_set("orientation", carousel_orientation_value(scope.orientation))
    .data_set("active-index", scope.index.to_string())
    .data_set("count", scope.count.to_string())
    .data_set("max-snap-index", scope.max_index.to_string())
    .data_set("loop", ui_bool(scope.loop_))
    .role("region")
    .aria_roledescription("carousel")
    .aria_orientation(carousel_orientation_value(scope.orientation))
  if aria_label is Some(label) {
    ignore(root_attrs.aria_label(label))
  }
  @html.div(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, CarouselRootStyle],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=root_attrs,
    [
      @html.div(
        style=[UiBoxSizing, CarouselScopeStyle],
        attrs=carousel_keyboard_attrs(scope),
        children(scope),
      ),
      carousel_status(scope),
    ],
  )
}

///|
/// Render the clipping viewport and translated slide track for a scope.
///
/// Component props style the viewport; `track_attrs` and `track_style` target
/// the moving flex track. All caller attribute values are cloned.
pub fn[C : @html.IsChildren] carousel_content(
  scope~ : CarouselScope,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  track_attrs? : @html.Attrs,
  style? : Array[String] = [],
  track_style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let orientation = carousel_orientation_value(scope.orientation)
  let viewport_attrs = ui_attrs(attrs)
    .data_set("slot", "carousel-content")
    .data_set("orientation", orientation)
    .data_set("swipe", "true")
  carousel_bind_pointer_attrs(viewport_attrs, scope)
  let moving_attrs = ui_attrs(track_attrs)
    .data_set("slot", "carousel-track")
    .data_set("orientation", orientation)
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        CarouselViewportStyle,
        carousel_viewport_orientation_style(scope.orientation),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=viewport_attrs,
    @html.div(
      style=ui_styles(
        [
          UiBoxSizing,
          CarouselTrackStyle,
          carousel_track_orientation_style(scope.orientation),
          carousel_track_transform(scope),
        ],
        track_style,
      ),
      attrs=moving_attrs,
      children,
    ),
  )
}

///|
/// Render one semantic carousel slide.
///
/// Mounted stateful carousels measure the viewport and make only truly clipped
/// slides inert. Static/controlled markup stays conservative because active
/// index alone cannot determine visibility when callers customize item sizes.
pub fn[C : @html.IsChildren] carousel_item(
  scope~ : CarouselScope,
  index~ : Int,
  aria_label? : String,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let active = index == scope.index && index >= 0 && index < scope.count
  let label = aria_label.unwrap_or("Slide \{index + 1} of \{scope.count}")
  let item_attrs = ui_attrs(attrs)
    .data_set("slot", "carousel-item")
    .data_set("orientation", carousel_orientation_value(scope.orientation))
    .data_set("index", index.to_string())
    .data_set("state", if active { "active" } else { "inactive" })
    .data_set("active", ui_bool(active))
    .role("group")
    .aria_roledescription("slide")
    .aria_label(label)
    .aria_posinset((index + 1).to_string())
    .aria_setsize(scope.count.to_string())
  if active {
    ignore(item_attrs.aria_current("true"))
  }
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        CarouselItemStyle,
        carousel_item_orientation_style(scope.orientation),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=item_attrs,
    children,
  )
}

///|
/// Convenience composition for an array of already-built slide bodies.
pub fn carousel_items(
  scope~ : CarouselScope,
  items~ : Array[@html.Html],
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  track_attrs? : @html.Attrs,
  style? : Array[String] = [],
  track_style? : Array[String] = [],
  item_style? : Array[String] = [],
) -> @html.Html {
  let slides : Array[@html.Html] = []
  for index, item in items {
    slides.push(carousel_item(scope~, index~, style=item_style, item))
  }
  carousel_content(
    scope~,
    id?,
    class?,
    title?,
    attrs?,
    track_attrs?,
    style~,
    track_style~,
    slides,
  )
}

///|
fn carousel_control(
  scope : CarouselScope,
  previous : Bool,
  disabled : Bool,
  aria_label : String,
  id : String?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
) -> @html.Html {
  let can_move = if previous {
    carousel_can_previous(scope)
  } else {
    carousel_can_next(scope)
  }
  let disabled = disabled || !can_move
  let direction = if previous { "previous" } else { "next" }
  let target = if previous {
    carousel_previous_index(scope)
  } else {
    carousel_next_index(scope)
  }
  let control_attrs = ui_attrs(attrs)
    .data_set("slot", "carousel-\{direction}")
    .data_set("direction", direction)
    .data_set("state", if disabled { "disabled" } else { "enabled" })
    .data_set("variant", button_variant_value(Outline))
    .data_set("size", button_size_value(IconSm))
    .aria_label(aria_label)
    .aria_disabled(ui_bool(disabled))
  if disabled {
    ignore(control_attrs.data_set("disabled", ""))
  } else {
    ignore(control_attrs.on_click_after(_ => (scope.emit)(target)))
  }
  @html.button(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        ButtonBaseStyle,
        ButtonOutlineStyle,
        ButtonSizeIconSmStyle,
        CarouselControlStyle,
        carousel_control_position_style(scope.orientation, previous),
        ui_disabled_style(disabled),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    type_="button",
    disabled~,
    attrs=control_attrs,
    @html.span(
      style=[UiBoxSizing, CarouselChevronBoxStyle],
      attrs=@html.Attrs::build()
        .aria_hidden("true")
        .data_set("icon", if previous { "previous" } else { "next" }),
      @html.span(
        style=[
          UiBoxSizing,
          CarouselChevronStyle,
          carousel_control_chevron_style(scope.orientation, previous),
        ],
        @html.nothing,
      ),
    ),
  )
}

///|
/// Render the previous control bound to a carousel scope.
pub fn carousel_previous(
  scope~ : CarouselScope,
  disabled? : Bool = false,
  aria_label? : String = "Previous slide",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  carousel_control(
    scope, true, disabled, aria_label, id, class, title, attrs, style,
  )
}

///|
/// Render the next control bound to a carousel scope.
pub fn carousel_next(
  scope~ : CarouselScope,
  disabled? : Bool = false,
  aria_label? : String = "Next slide",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  carousel_control(
    scope, false, disabled, aria_label, id, class, title, attrs, style,
  )
}

///|
/// Render one indexed Carousel state for the native incremental fallback.
///
/// This synchronous primitive uses the 100% slide fallback encoded in the
/// track. Use stateful `carousel` for automatic measured snapping when public
/// `track_style`/item styles introduce gaps or non-default flex bases; callers
/// that own DOM measurement may also set `--rui-carousel-offset` themselves.
#cfg(not(target="js"))
fn[C : @html.IsChildren] render_carousel_index(
  index~ : Int,
  count~ : Int,
  loop_? : Bool = false,
  orientation? : CarouselOrientation = CarouselHorizontal,
  aria_label? : String,
  on_index_change? : @cmd.Emit[Int],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (CarouselScope) -> C,
) -> @html.Html {
  let count = carousel_count(count)
  let index = carousel_index(index, count)
  let max_index = carousel_index(count - 1, count)
  let emit = on_index_change.unwrap_or(Emit(_ => @cmd.none))
  render_carousel(
    { index, count, max_index, loop_, orientation, emit },
    aria_label,
    id,
    class,
    title,
    hidden,
    attrs,
    style,
    children,
  )
}

///|
/// Stateful carousel root. The active slide is component-local; the scope
/// binds content, items, previous/next buttons, and orientation-aware arrow
/// keys without Embla or another runtime dependency.
#cfg(target="js")
pub fn[C : @html.IsChildren] carousel(
  count~ : Int,
  default_index? : Int = 0,
  loop_? : Bool = false,
  orientation? : CarouselOrientation = CarouselHorizontal,
  aria_label? : String,
  on_index_change? : @cmd.Emit[Int],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (CarouselScope) -> C,
) -> @rabbita.Val[@html.Html] {
  let count = carousel_count(count)
  let initial = carousel_index(default_index, count)
  let root_id = id.unwrap_or(ffi_carousel_next_id())
  let initial_max = carousel_index(count - 1, count)
  let (model, emit) = @rabbita.create_state_with_init(
    init=fn(emit) {
      (
        { index: initial, max_index: initial_max },
        carousel_sync_layout_cmd(root_id, emit),
      )
    },
    update=fn(emit, message, current) {
      match message {
        CarouselSetIndex(requested) => {
          let next = carousel_index(requested, count).clamp(
            min=0,
            max=current.max_index,
          )
          let notify = if on_index_change is Some(callback) {
            callback(next)
          } else {
            @cmd.none
          }
          (
            { ..current, index: next },
            @cmd.batch([notify, carousel_sync_layout_cmd(root_id, emit)]),
          )
        }
        CarouselMeasured(measured) => {
          let max_index = carousel_index(measured, count)
          let index = current.index.clamp(min=0, max=max_index)
          if max_index == current.max_index && index == current.index {
            (current, @cmd.none)
          } else {
            let notify = if index != current.index &&
              on_index_change is Some(callback) {
              callback(index)
            } else {
              @cmd.none
            }
            (
              { index, max_index },
              @cmd.batch([notify, carousel_sync_layout_cmd(root_id, emit)]),
            )
          }
        }
      }
    },
  )
  model.view(model => {
    let set_index = emit.map(index => CarouselSetIndex(index))
    render_carousel(
      {
        index: model.index,
        count,
        max_index: model.max_index,
        loop_,
        orientation,
        emit: set_index,
      },
      aria_label,
      Some(root_id),
      class,
      title,
      hidden,
      attrs,
      style,
      children,
    )
  })
}

///|
/// Native/SSR fallback for `carousel`; renders the requested initial scope as
/// a constant incremental value.
#cfg(not(target="js"))
pub fn[C : @html.IsChildren] carousel(
  count~ : Int,
  default_index? : Int = 0,
  loop_? : Bool = false,
  orientation? : CarouselOrientation = CarouselHorizontal,
  aria_label? : String,
  on_index_change? : @cmd.Emit[Int],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (CarouselScope) -> C,
) -> @rabbita.Val[@html.Html] {
  ignore(on_index_change)
  let count = carousel_count(count)
  let index = carousel_index(default_index, count)
  let emit = @cmd.Emit(_ => @cmd.none)
  @rabbita.Val::constant(
    render_carousel_index(
      index~,
      count~,
      loop_~,
      orientation~,
      aria_label?,
      on_index_change=emit,
      id?,
      class?,
      title?,
      hidden?,
      attrs?,
      style~,
      children,
    ),
  )
}
