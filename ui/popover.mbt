///|
pub(all) enum PopupSide {
  Top
  Right
  Bottom
  Left
} derive(Debug, Eq)

///|
pub(all) enum PopupAlign {
  Start
  Center
  End
} derive(Debug, Eq)

///|
const PopoverRootStyle : String = "display:contents"

///|
const PopoverAnchorStyle : String = "position:relative;display:inline-flex;max-width:100%"

///|
const PopoverContentStyle : String = "position:fixed;inset:auto;left:var(--rui-floating-left,auto);top:var(--rui-floating-top,auto);z-index:50;display:flex;width:18rem;max-width:calc(100vw - 1rem);transform-origin:var(--rui-floating-transform-origin,center);flex-direction:column;gap:1rem;margin:0;border:0;border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-popover,oklch(1 0 0));padding:1rem;color:var(--rui-popover-foreground,oklch(0.145 0 0));font-size:0.875rem;line-height:1.25rem;box-shadow:0 10px 15px -3px rgb(0 0 0 / 0.1),0 4px 6px -4px rgb(0 0 0 / 0.1),0 0 0 1px color-mix(in oklab,var(--rui-foreground,oklch(0.145 0 0)) 10%,transparent);outline:none;transition:opacity 100ms ease,transform 100ms ease,visibility 100ms ease"

///|
const PopoverHeaderStyle : String = "display:flex;flex-direction:column;gap:0.25rem;font-size:0.875rem;line-height:1.25rem"

///|
const PopoverTitleStyle : String = "margin:0;font-size:0.875rem;line-height:1.25rem;font-weight:500"

///|
const PopoverDescriptionStyle : String = "margin:0;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem;line-height:1.25rem"

///|
const PopupOpenStyle : String = "visibility:visible;opacity:1;pointer-events:auto;transform:scale(1)"

///|
const PopupClosedStyle : String = "visibility:hidden;opacity:0;pointer-events:none;transform:scale(0.95)"

///|
/// Keep a native popover or dialog in the top layer while its visual exit
/// finishes. `@starting-style` in the internal theme supplies the matching
/// closed first frame for entry, so consumers do not need lifecycle scripts or
/// an external animation stylesheet.
const PopupTransition100Style : String = "transition:opacity 100ms ease,transform 100ms ease,visibility 100ms ease,display 100ms allow-discrete,overlay 100ms allow-discrete;transition-behavior:allow-discrete"

///|
const PopupTransition150Style : String = "transition:opacity 150ms ease,transform 150ms ease,visibility 150ms ease,display 150ms allow-discrete,overlay 150ms allow-discrete;transition-behavior:allow-discrete"

///|
fn popup_side_value(side : PopupSide) -> String {
  match side {
    Top => "top"
    Right => "right"
    Bottom => "bottom"
    Left => "left"
  }
}

///|
fn popup_align_value(align : PopupAlign) -> String {
  match align {
    Start => "start"
    Center => "center"
    End => "end"
  }
}

///|
/// Encode an arbitrary HTML id as a valid, collision-free CSS dashed-ident.
/// Keeping this deterministic lets both compound and standalone parts render
/// their anchor relationship directly, without a post-render setup pass.
fn popup_anchor_name(id : String) -> String {
  let name = StringBuilder::new()
  name.write_string("--rui-anchor")
  for character in id.iter() {
    name.write_char('_')
    name.write_object(character.to_int())
  }
  name.to_string()
}

///|
fn popup_anchor_style(id : String) -> String {
  "anchor-name:\{popup_anchor_name(id)}"
}

///|
fn popup_position_area(side : PopupSide, align : PopupAlign) -> String {
  let side_value = popup_side_value(side)
  match (side, align) {
    (Top | Bottom, Start) => side_value + " span-x-end"
    (Top | Bottom, Center) => side_value
    (Top | Bottom, End) => side_value + " span-x-start"
    (Left | Right, Start) => side_value + " span-y-end"
    (Left | Right, Center) => side_value
    (Left | Right, End) => side_value + " span-y-start"
  }
}

///|
fn popup_side_offset_style(side : PopupSide, offset : Int) -> String {
  match side {
    Top => "margin-bottom:\{offset}px"
    Right => "margin-left:\{offset}px"
    Bottom => "margin-top:\{offset}px"
    Left => "margin-right:\{offset}px"
  }
}

///|
fn popup_align_offset_style(side : PopupSide, offset : Int) -> String {
  match side {
    Top | Bottom => "translate:\{offset}px 0"
    Right | Left => "translate:0 \{offset}px"
  }
}

///|
fn popup_transform_origin(side : PopupSide, align : PopupAlign) -> String {
  let cross_axis = match align {
    Start => "0%"
    Center => "50%"
    End => "100%"
  }
  match side {
    Top => cross_axis + " 100%"
    Right => "0% " + cross_axis
    Bottom => cross_axis + " 0%"
    Left => "100% " + cross_axis
  }
}

///|
/// Native CSS Anchor Positioning is the primary path. The browser performs
/// scroll tracking, viewport fitting, and opposite-side fallbacks during its
/// own layout pass; `ffi_position_floating` is retained only for older engines.
fn popup_floating_anchor_style(
  trigger_id : String,
  side : PopupSide,
  align : PopupAlign,
  side_offset : Int,
  align_offset : Int,
) -> String {
  let fallbacks = match side {
    Top | Bottom => "flip-inline,flip-block,flip-inline flip-block"
    Right | Left => "flip-block,flip-inline,flip-block flip-inline"
  }
  "position-anchor:\{popup_anchor_name(trigger_id)};position-area:\{popup_position_area(side, align)};position-try-fallbacks:\{fallbacks};position-visibility:always;\{popup_side_offset_style(side, side_offset)};\{popup_align_offset_style(side, align_offset)};--rui-floating-transform-origin:\{popup_transform_origin(side, align)}"
}

///|
fn popup_state_style(open : Bool) -> String {
  if open {
    PopupOpenStyle
  } else {
    PopupClosedStyle
  }
}

///|
fn popup_state_attrs(
  attrs : @html.Attrs?,
  slot : String,
  open : Bool,
) -> @html.Attrs {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", slot)
    .data_set("state", if open { "open" } else { "closed" })
  if open {
    ignore(element_attrs.data_set("open", ""))
  } else {
    ignore(element_attrs.data_set("closed", ""))
  }
  element_attrs
}

///|
#cfg(target="js")
fn floating_dialog_open(open : Bool) -> Bool? {
  ignore(open)
  None
}

///|
#cfg(not(target="js"))
fn floating_dialog_open(open : Bool) -> Bool? {
  Some(open)
}

///|
#cfg(target="js")
extern "js" fn ffi_bind_floating_sync(
  id : String,
  sync : (Bool) -> Unit,
) -> Unit =
  #| (id, sync) => {
  #|   const popup = document.getElementById(id)
  #|   if (!popup) return
  #|   popup.__ruiFloatingSync = sync
  #|   const isDialog = typeof HTMLDialogElement !== "undefined"
  #|     && popup instanceof HTMLDialogElement
  #|   const isOpen = () => isDialog
  #|     ? popup.open
  #|     : (() => {
  #|         try {
  #|           if (popup.matches(":popover-open")) return true
  #|         } catch (_) {
  #|         }
  #|         return Boolean(popup.__ruiFloatingOpen)
  #|       })()
  #|   const stack = globalThis.__ruiFloatingStack ||= []
  #|   const updateStack = open => {
  #|     const index = stack.indexOf(id)
  #|     if (index >= 0) stack.splice(index, 1)
  #|     if (open) stack.push(id)
  #|   }
  #|   const topFloating = () => {
  #|     const liveStack = globalThis.__ruiFloatingStack ||= []
  #|     for (let index = liveStack.length - 1; index >= 0; index -= 1) {
  #|       const item = document.getElementById(liveStack[index])
  #|       if (!item || !item.isConnected) {
  #|         liveStack.splice(index, 1)
  #|         continue
  #|       }
  #|       if (typeof HTMLDialogElement !== "undefined"
  #|         && item instanceof HTMLDialogElement) {
  #|         if (item.open) return item
  #|         liveStack.splice(index, 1)
  #|         continue
  #|       }
  #|       try {
  #|         if (item.matches(":popover-open")) return item
  #|       } catch (_) {
  #|       }
  #|       if (item.__ruiFloatingOpen) return item
  #|       liveStack.splice(index, 1)
  #|     }
  #|     return null
  #|   }
  #|   const restoreFocus = () => {
  #|     if (popup.dataset.restoreFocus === "false") return
  #|     const finalId = popup.dataset.finalFocusId || ""
  #|     const triggerId = popup.dataset.triggerId || ""
  #|     const finalTarget = document.getElementById(finalId)
  #|     if (finalTarget instanceof HTMLElement && finalTarget.isConnected) {
  #|       finalTarget.focus({ preventScroll: true })
  #|       return
  #|     }
  #|     const active = document.activeElement
  #|     if (active && active !== document.body && !popup.contains(active)) return
  #|     const target = popup.__ruiReturnFocus || document.getElementById(triggerId)
  #|     if (target instanceof HTMLElement && target.isConnected) {
  #|       target.focus({ preventScroll: true })
  #|     }
  #|   }
  #|   const notify = open => {
  #|     popup.__ruiFloatingOpen = open
  #|     updateStack(open)
  #|     if (!open) {
  #|       popup.__ruiFloatingStopPositioning?.()
  #|       const provider = popup.closest('[data-slot="tooltip-provider"]')
  #|       if (provider && popup.dataset.slot === "tooltip-content") {
  #|         provider.__ruiTooltipLastClose = typeof performance !== "undefined"
  #|           ? performance.now()
  #|           : Date.now()
  #|       }
  #|       if (typeof queueMicrotask === "function") queueMicrotask(restoreFocus)
  #|       else setTimeout(restoreFocus, 0)
  #|     }
  #|     popup.__ruiFloatingSync?.(open)
  #|   }
  #|   popup.__ruiFloatingNotify = notify
  #|   popup.__ruiFloatingOpen = isOpen()
  #|   updateStack(popup.__ruiFloatingOpen)
  #|   const requestClose = current => {
  #|     if (typeof current.__ruiFloatingRequestClose === "function") {
  #|       current.__ruiFloatingRequestClose()
  #|     } else if (typeof HTMLDialogElement !== "undefined"
  #|       && current instanceof HTMLDialogElement) {
  #|       current.close()
  #|     } else if (typeof current.hidePopover === "function") {
  #|       current.hidePopover()
  #|     } else if (typeof current.__ruiFloatingNotify === "function") {
  #|       current.__ruiFloatingNotify(false)
  #|     } else {
  #|       current.__ruiFloatingOpen = false
  #|       current.__ruiFloatingStopPositioning?.()
  #|       current.__ruiFloatingSync?.(false)
  #|     }
  #|   }
  #|   if (!document.__ruiFloatingEscapeBound) {
  #|     document.__ruiFloatingEscapeBound = true
  #|     document.addEventListener("keydown", event => {
  #|       if (event.key !== "Escape" || event.defaultPrevented) return
  #|       const current = topFloating()
  #|       if (!current) return
  #|       event.preventDefault()
  #|       event.stopPropagation()
  #|       requestClose(current)
  #|     })
  #|   }
  #|   if (!document.__ruiFloatingLightDismissBound) {
  #|     document.__ruiFloatingLightDismissBound = true
  #|     document.addEventListener("pointerdown", event => {
  #|       const current = topFloating()
  #|       if (!current || current.dataset.lightDismiss !== "true") return
  #|       const path = typeof event.composedPath === "function" ? event.composedPath() : []
  #|       if (current.contains(event.target) || path.includes(current)) return
  #|       requestClose(current)
  #|     }, true)
  #|   }
  #|   if (popup.__ruiFloatingSyncBound) return
  #|   popup.__ruiFloatingSyncBound = true
  #|   if (isDialog) {
  #|     popup.addEventListener("close", () => notify(false))
  #|     const hasNestedFloating = () => {
  #|       const currentIndex = stack.lastIndexOf(id)
  #|       for (let index = stack.length - 1; index > currentIndex; index -= 1) {
  #|         const nested = document.getElementById(stack[index])
  #|         if (nested && nested.isConnected && nested !== popup) return true
  #|       }
  #|       try {
  #|         return Array.from(document.querySelectorAll(":popover-open"))
  #|           .some(item => popup.contains(item))
  #|       } catch (_) {
  #|         return false
  #|       }
  #|     }
  #|     popup.addEventListener("pointerdown", event => {
  #|       if (event.target === popup) {
  #|         popup.__ruiHadNestedFloatingOnPointerDown = hasNestedFloating()
  #|       }
  #|     })
  #|     popup.addEventListener("click", event => {
  #|       if (event.target !== popup) return
  #|       const hadNested = Boolean(popup.__ruiHadNestedFloatingOnPointerDown)
  #|         || hasNestedFloating()
  #|       popup.__ruiHadNestedFloatingOnPointerDown = false
  #|       if (hadNested) return
  #|       const rect = popup.getBoundingClientRect()
  #|       const outside = event.clientX < rect.left || event.clientX > rect.right
  #|         || event.clientY < rect.top || event.clientY > rect.bottom
  #|       if (outside && popup.open) popup.close()
  #|     })
  #|   } else {
  #|     popup.addEventListener("toggle", event => {
  #|       const open = event.newState
  #|         ? event.newState === "open"
  #|         : isOpen()
  #|       notify(open)
  #|     })
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_set_floating_open(id : String, open : Bool) -> Bool =
  #| (id, open) => {
  #|   if (typeof document === "undefined") return false
  #|   const popup = document.getElementById(id)
  #|   if (!popup || popup.isConnected === false) return false
  #|   const isDialog = typeof HTMLDialogElement !== "undefined"
  #|     && popup instanceof HTMLDialogElement
  #|   const native = typeof popup.showPopover === "function"
  #|   const stack = globalThis.__ruiFloatingStack ||= []
  #|   const updateStack = value => {
  #|     const index = stack.indexOf(id)
  #|     if (index >= 0) stack.splice(index, 1)
  #|     if (value) stack.push(id)
  #|     popup.__ruiFloatingOpen = value
  #|   }
  #|   const isOpen = element => {
  #|     if (typeof HTMLDialogElement !== "undefined"
  #|       && element instanceof HTMLDialogElement) return element.open
  #|     try {
  #|       if (element.matches(":popover-open")) return true
  #|     } catch (_) {
  #|     }
  #|     return Boolean(element.__ruiFloatingOpen)
  #|   }
  #|   const focusPopup = () => {
  #|     if (popup.dataset.initialFocus !== "true") return
  #|     const requested = document.getElementById(popup.dataset.initialFocusId || "")
  #|     const selector = [
  #|       'button:not([disabled])',
  #|       'a[href]',
  #|       'input:not([disabled])',
  #|       'select:not([disabled])',
  #|       'textarea:not([disabled])',
  #|       '[tabindex]:not([tabindex="-1"])',
  #|     ].join(',')
  #|     const target = requested && popup.contains(requested)
  #|       ? requested
  #|       : popup.querySelector(selector) || popup
  #|     if (target instanceof HTMLElement) target.focus({ preventScroll: true })
  #|   }
  #|   const notify = value => {
  #|     if (typeof popup.__ruiFloatingNotify === "function") {
  #|       popup.__ruiFloatingNotify(value)
  #|     } else {
  #|       updateStack(value)
  #|       popup.__ruiFloatingSync?.(value)
  #|     }
  #|   }
  #|   try {
  #|     if (open) {
  #|       const active = document.activeElement
  #|       if (active instanceof HTMLElement && !popup.contains(active)) {
  #|         popup.__ruiReturnFocus = active
  #|       }
  #|       if (popup.dataset.slot === "tooltip-content") {
  #|         const provider = popup.closest('[data-slot="tooltip-provider"]')
  #|         if (provider) {
  #|           provider.querySelectorAll('[data-slot="tooltip-content"]').forEach(other => {
  #|             if (other === popup || !isOpen(other)) return
  #|             if (typeof HTMLDialogElement !== "undefined"
  #|               && other instanceof HTMLDialogElement) other.close()
  #|             else if (typeof other.hidePopover === "function") other.hidePopover()
  #|           })
  #|         }
  #|       }
  #|       if (isDialog) {
  #|         if (!popup.open) {
  #|           popup.showModal()
  #|           notify(true)
  #|         }
  #|       } else if (native && !isOpen(popup)) {
  #|         popup.showPopover()
  #|       } else if (!native) {
  #|         notify(true)
  #|       }
  #|       if (isDialog || native) updateStack(true)
  #|       if (typeof requestAnimationFrame === "function") requestAnimationFrame(focusPopup)
  #|       else focusPopup()
  #|     } else {
  #|       if (isDialog) {
  #|         if (popup.open) popup.close()
  #|       } else if (native && isOpen(popup)) {
  #|         popup.hidePopover()
  #|       } else if (!native) {
  #|         notify(false)
  #|       }
  #|       if (isDialog || native) updateStack(false)
  #|       popup.__ruiFloatingStopPositioning?.()
  #|     }
  #|   } catch (_) {
  #|   }
  #|   return true
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_toggle_floating(id : String) -> Unit =
  #| id => {
  #|   const popup = document.getElementById(id)
  #|   if (!popup) return
  #|   if (typeof HTMLDialogElement !== "undefined"
  #|     && popup instanceof HTMLDialogElement) {
  #|     if (popup.open) {
  #|       popup.__ruiFloatingStopPositioning?.()
  #|       popup.close()
  #|     } else {
  #|       const active = document.activeElement
  #|       if (active instanceof HTMLElement && !popup.contains(active)) {
  #|         popup.__ruiReturnFocus = active
  #|       }
  #|       popup.showModal()
  #|       if (typeof popup.__ruiFloatingNotify === "function") {
  #|         popup.__ruiFloatingNotify(true)
  #|       } else {
  #|         popup.__ruiFloatingOpen = true
  #|         const stack = globalThis.__ruiFloatingStack ||= []
  #|         const index = stack.indexOf(id)
  #|         if (index >= 0) stack.splice(index, 1)
  #|         stack.push(id)
  #|         popup.__ruiFloatingSync?.(true)
  #|       }
  #|       if (popup.dataset.initialFocus === "true") {
  #|         const focusRequested = () => {
  #|           const requested = document.getElementById(
  #|             popup.dataset.initialFocusId || "",
  #|           )
  #|           const selector = [
  #|             'button:not([disabled])',
  #|             'a[href]',
  #|             'input:not([disabled])',
  #|             'select:not([disabled])',
  #|             'textarea:not([disabled])',
  #|             '[tabindex]:not([tabindex="-1"])',
  #|           ].join(',')
  #|           const target = requested instanceof HTMLElement && popup.contains(requested)
  #|             ? requested
  #|             : popup.querySelector(selector) || popup
  #|           if (target instanceof HTMLElement) target.focus({ preventScroll: true })
  #|         }
  #|         if (typeof requestAnimationFrame === "function") {
  #|           requestAnimationFrame(focusRequested)
  #|         } else {
  #|           focusRequested()
  #|         }
  #|       }
  #|     }
  #|     return
  #|   }
  #|   const native = typeof popup.togglePopover === "function"
  #|   try {
  #|     if (native) {
  #|       let wasOpen = false
  #|       try { wasOpen = popup.matches(":popover-open") }
  #|       catch (_) { wasOpen = Boolean(popup.__ruiFloatingOpen) }
  #|       if (wasOpen) popup.__ruiFloatingStopPositioning?.()
  #|       popup.togglePopover()
  #|     } else {
  #|       const open = !popup.__ruiFloatingOpen
  #|       if (typeof popup.__ruiFloatingNotify === "function") {
  #|         popup.__ruiFloatingNotify(open)
  #|       } else {
  #|         popup.__ruiFloatingOpen = open
  #|         const stack = globalThis.__ruiFloatingStack ||= []
  #|         const index = stack.indexOf(id)
  #|         if (index >= 0) stack.splice(index, 1)
  #|         if (open) stack.push(id)
  #|         if (!open) popup.__ruiFloatingStopPositioning?.()
  #|         popup.__ruiFloatingSync?.(open)
  #|       }
  #|     }
  #|   } catch (_) {
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_position_floating(id : String) -> Unit =
  #| id => {
  #|   const popup = document.getElementById(id)
  #|   if (!popup || popup.isConnected === false) return
  #|   const trigger = document.getElementById(popup.dataset.triggerId || "")
  #|   const hasTooltipArrow = () => Boolean(
  #|     popup.querySelector?.('[data-slot="tooltip-arrow"]'),
  #|   )
  #|   const setTooltipArrowSide = side => {
  #|     if (!hasTooltipArrow()) return
  #|     const placements = {
  #|       top: ["auto", "auto", "-0.25rem", "50%", "0", "-0.3125rem"],
  #|       right: ["50%", "auto", "auto", "-0.25rem", "-0.3125rem", "0"],
  #|       bottom: ["-0.25rem", "auto", "auto", "50%", "0", "-0.3125rem"],
  #|       left: ["50%", "-0.25rem", "auto", "auto", "-0.3125rem", "0"],
  #|     }
  #|     const names = [
  #|       "--rui-tooltip-arrow-top",
  #|       "--rui-tooltip-arrow-right",
  #|       "--rui-tooltip-arrow-bottom",
  #|       "--rui-tooltip-arrow-left",
  #|       "--rui-tooltip-arrow-margin-top",
  #|       "--rui-tooltip-arrow-margin-left",
  #|     ]
  #|     const values = placements[side] || placements.top
  #|     names.forEach((name, index) => {
  #|       if (popup.style.getPropertyValue(name) !== values[index]) {
  #|         popup.style.setProperty(name, values[index])
  #|       }
  #|     })
  #|   }
  #|   const inferTooltipSide = reference => {
  #|     const anchor = reference.getBoundingClientRect()
  #|     const floating = popup.getBoundingClientRect()
  #|     if (floating.bottom <= anchor.top + 1) return "top"
  #|     if (floating.top >= anchor.bottom - 1) return "bottom"
  #|     if (floating.right <= anchor.left + 1) return "left"
  #|     if (floating.left >= anchor.right - 1) return "right"
  #|     const dx = (floating.left + floating.right - anchor.left - anchor.right) / 2
  #|     const dy = (floating.top + floating.bottom - anchor.top - anchor.bottom) / 2
  #|     return Math.abs(dx) > Math.abs(dy)
  #|       ? dx < 0 ? "left" : "right"
  #|       : dy < 0 ? "top" : "bottom"
  #|   }
  #|   const positionArea = popup.style.getPropertyValue("position-area")
  #|   const positionFallbacks = popup.style.getPropertyValue("position-try-fallbacks")
  #|   const cssAnchored = Boolean(trigger)
  #|     && typeof CSS !== "undefined"
  #|     && typeof CSS.supports === "function"
  #|     && CSS.supports("anchor-name", "--rui-anchor")
  #|     && CSS.supports("position-anchor", "--rui-anchor")
  #|     && CSS.supports("position-area", positionArea)
  #|     && CSS.supports("position-try-fallbacks", positionFallbacks)
  #|   if (cssAnchored) {
  #|     popup.__ruiFloatingStopPositioning?.()
  #|     popup.style.removeProperty("--rui-floating-left")
  #|     popup.style.removeProperty("--rui-floating-top")
  #|     popup.style.removeProperty("--rui-floating-anchor-width")
  #|     popup.style.removeProperty("--rui-floating-anchor-height")
  #|     popup.style.removeProperty("--rui-floating-available-width")
  #|     popup.style.removeProperty("--rui-floating-available-height")
  #|     popup.dataset.positioning = "css-anchor"
  #|     popup.dataset.positioned = "true"
  #|     delete popup.dataset.anchorHidden
  #|     if (hasTooltipArrow()) {
  #|       let frame = 0
  #|       let resizeObserver = null
  #|       let mutationObserver = null
  #|       let observing = true
  #|       const syncArrow = () => {
  #|         if (!observing || popup.isConnected === false) return
  #|         const reference = document.getElementById(popup.dataset.triggerId || "")
  #|         if (!reference || reference.isConnected === false) return
  #|         const side = inferTooltipSide(reference)
  #|         if (popup.dataset.side !== side) popup.dataset.side = side
  #|         setTooltipArrowSide(side)
  #|       }
  #|       const schedule = () => {
  #|         if (frame) return
  #|         if (typeof requestAnimationFrame === "function") {
  #|           frame = requestAnimationFrame(() => {
  #|             frame = 0
  #|             syncArrow()
  #|           })
  #|         } else {
  #|           syncArrow()
  #|         }
  #|       }
  #|       const stop = () => {
  #|         if (!observing) return
  #|         observing = false
  #|         if (frame && typeof cancelAnimationFrame === "function") {
  #|           cancelAnimationFrame(frame)
  #|         }
  #|         frame = 0
  #|         if (typeof window !== "undefined") {
  #|           window.removeEventListener("scroll", schedule, true)
  #|           window.removeEventListener("resize", schedule)
  #|           window.visualViewport?.removeEventListener("scroll", schedule)
  #|           window.visualViewport?.removeEventListener("resize", schedule)
  #|         }
  #|         resizeObserver?.disconnect()
  #|         mutationObserver?.disconnect()
  #|         delete popup.dataset.positioned
  #|       }
  #|       popup.__ruiFloatingStopPositioning = stop
  #|       if (typeof window !== "undefined") {
  #|         window.addEventListener("scroll", schedule, { capture: true, passive: true })
  #|         window.addEventListener("resize", schedule, { passive: true })
  #|         window.visualViewport?.addEventListener("scroll", schedule, { passive: true })
  #|         window.visualViewport?.addEventListener("resize", schedule, { passive: true })
  #|       }
  #|       if (typeof ResizeObserver === "function") {
  #|         resizeObserver = new ResizeObserver(schedule)
  #|         resizeObserver.observe(trigger)
  #|         resizeObserver.observe(popup)
  #|       }
  #|       if (typeof MutationObserver === "function") {
  #|         mutationObserver = new MutationObserver(schedule)
  #|         mutationObserver.observe(popup, {
  #|           attributes: true,
  #|           attributeFilter: ["style", "data-requested-side"],
  #|           childList: true,
  #|         })
  #|       }
  #|       syncArrow()
  #|     }
  #|     return
  #|   }
  #|   popup.dataset.positioning = "javascript-fallback"
  #|   const isOpen = () => {
  #|     if (typeof HTMLDialogElement !== "undefined"
  #|       && popup instanceof HTMLDialogElement) return popup.open
  #|     try {
  #|       if (popup.matches(":popover-open")) return true
  #|     } catch (_) {
  #|     }
  #|     return Boolean(popup.__ruiFloatingOpen)
  #|   }
  #|   const position = () => {
  #|     if (popup.isConnected === false) {
  #|       popup.__ruiFloatingStopPositioning?.()
  #|       return
  #|     }
  #|     const trigger = document.getElementById(popup.dataset.triggerId || "")
  #|     if (!trigger || trigger.isConnected === false) return
  #|     const anchor = trigger.getBoundingClientRect()
  #|     const measuredFloating = popup.getBoundingClientRect()
  #|     // The transition scales the popup itself. Layout dimensions keep the
  #|     // positioning calculation stable while that visual transform runs.
  #|     const floating = {
  #|       width: popup.offsetWidth || measuredFloating.width,
  #|       height: popup.offsetHeight || measuredFloating.height,
  #|     }
  #|     const requestedSide = popup.dataset.requestedSide || popup.dataset.side || "bottom"
  #|     const requestedAlign = popup.dataset.requestedAlign || popup.dataset.align || "center"
  #|     const sideOffset = Number(popup.dataset.sideOffset || 0)
  #|     const alignOffset = Number(popup.dataset.alignOffset || 0)
  #|     const viewport = typeof window !== "undefined" ? window.visualViewport : null
  #|     const viewportLeft = viewport?.offsetLeft || 0
  #|     const viewportTop = viewport?.offsetTop || 0
  #|     const width = viewport?.width || document.documentElement.clientWidth
  #|     const height = viewport?.height || document.documentElement.clientHeight
  #|     const padding = Math.max(0, Number(popup.dataset.collisionPadding || 0))
  #|     const clipLeft = viewportLeft + padding
  #|     const clipTop = viewportTop + padding
  #|     const clipRight = viewportLeft + width - padding
  #|     const clipBottom = viewportTop + height - padding
  #|     const isRtl = typeof getComputedStyle === "function"
  #|       && getComputedStyle(trigger).direction === "rtl"
  #|     const oppositeSide = { top: "bottom", bottom: "top", left: "right", right: "left" }
  #|     const coordinates = side => {
  #|       let left = anchor.left
  #|       let top = anchor.bottom + sideOffset
  #|       if (side === "top") top = anchor.top - floating.height - sideOffset
  #|       if (side === "left") left = anchor.left - floating.width - sideOffset
  #|       if (side === "right") left = anchor.right + sideOffset
  #|       if (side === "top" || side === "bottom") {
  #|         const start = isRtl ? anchor.right - floating.width : anchor.left
  #|         const end = isRtl ? anchor.left : anchor.right - floating.width
  #|         if (requestedAlign === "start") left = start + alignOffset
  #|         if (requestedAlign === "center") {
  #|           left = anchor.left + (anchor.width - floating.width) / 2 + alignOffset
  #|         }
  #|         if (requestedAlign === "end") left = end + alignOffset
  #|       } else {
  #|         if (requestedAlign === "start") top = anchor.top + alignOffset
  #|         if (requestedAlign === "center") {
  #|           top = anchor.top + (anchor.height - floating.height) / 2 + alignOffset
  #|         }
  #|         if (requestedAlign === "end") top = anchor.bottom - floating.height + alignOffset
  #|       }
  #|       return { side, left, top }
  #|     }
  #|     const overflow = candidate => {
  #|       const left = Math.max(clipLeft - candidate.left, 0)
  #|       const top = Math.max(clipTop - candidate.top, 0)
  #|       const right = Math.max(candidate.left + floating.width - clipRight, 0)
  #|       const bottom = Math.max(candidate.top + floating.height - clipBottom, 0)
  #|       return { left, top, right, bottom, total: left + top + right + bottom }
  #|     }
  #|     const preferred = coordinates(requestedSide)
  #|     const opposite = coordinates(oppositeSide[requestedSide] || "top")
  #|     const preferredOverflow = overflow(preferred)
  #|     const oppositeOverflow = overflow(opposite)
  #|     // The compatibility fallback first tries the opposite side, then
  #|     // shifts on the alignment axis with a partial-sticky limiter.
  #|     const placed = preferredOverflow.total <= 0
  #|       ? preferred
  #|       : oppositeOverflow.total <= 0 || oppositeOverflow.total < preferredOverflow.total
  #|         ? opposite
  #|         : preferred
  #|     let left = placed.left
  #|     let top = placed.top
  #|     const sticky = popup.dataset.sticky || "partial"
  #|     if (placed.side === "top" || placed.side === "bottom") {
  #|       left = Math.min(Math.max(left, clipLeft), Math.max(clipLeft, clipRight - floating.width))
  #|       if (sticky === "partial") {
  #|         left = Math.min(Math.max(left, anchor.left - floating.width), anchor.right)
  #|       }
  #|     } else {
  #|       top = Math.min(Math.max(top, clipTop), Math.max(clipTop, clipBottom - floating.height))
  #|       if (sticky === "partial") {
  #|         top = Math.min(Math.max(top, anchor.top - floating.height), anchor.bottom)
  #|       }
  #|     }
  #|     const anchorHidden = anchor.right <= viewportLeft || anchor.left >= viewportLeft + width
  #|       || anchor.bottom <= viewportTop || anchor.top >= viewportTop + height
  #|     popup.dataset.side = placed.side
  #|     popup.dataset.align = requestedAlign
  #|     setTooltipArrowSide(placed.side)
  #|     if (anchorHidden) popup.dataset.anchorHidden = ""
  #|     else delete popup.dataset.anchorHidden
  #|     popup.style.setProperty("--rui-floating-left", `${Math.round(left)}px`)
  #|     popup.style.setProperty("--rui-floating-top", `${Math.round(top)}px`)
  #|     popup.style.setProperty("--rui-floating-anchor-width", `${Math.round(anchor.width)}px`)
  #|     popup.style.setProperty("--rui-floating-anchor-height", `${Math.round(anchor.height)}px`)
  #|     popup.style.setProperty("--rui-floating-available-width", `${Math.max(0, clipRight - clipLeft)}px`)
  #|     popup.style.setProperty("--rui-floating-available-height", `${Math.max(0, clipBottom - clipTop)}px`)
  #|     const originAlign = { start: "0%", center: "50%", end: "100%" }[requestedAlign] || "50%"
  #|     const origin = placed.side === "bottom" ? `${originAlign} 0%`
  #|       : placed.side === "top" ? `${originAlign} 100%`
  #|       : placed.side === "right" ? `0% ${originAlign}`
  #|       : `100% ${originAlign}`
  #|     popup.style.setProperty("--rui-floating-transform-origin", origin)
  #|     popup.dataset.positioned = "true"
  #|   }
  #|   if (!popup.__ruiFloatingPositioning) {
  #|     let frame = 0
  #|     let observing = false
  #|     let resizeObserver = null
  #|     let intersectionObserver = null
  #|     let mutationObserver = null
  #|     const schedule = () => {
  #|       if (frame) return
  #|       if (typeof requestAnimationFrame === "function") {
  #|         frame = requestAnimationFrame(() => {
  #|           frame = 0
  #|           position()
  #|         })
  #|       } else {
  #|         position()
  #|       }
  #|     }
  #|     const stop = () => {
  #|       if (!observing) return
  #|       observing = false
  #|       if (frame && typeof cancelAnimationFrame === "function") {
  #|         cancelAnimationFrame(frame)
  #|       }
  #|       frame = 0
  #|       if (typeof window !== "undefined") {
  #|         window.removeEventListener("scroll", schedule, true)
  #|         window.removeEventListener("resize", schedule)
  #|         window.visualViewport?.removeEventListener("scroll", schedule)
  #|         window.visualViewport?.removeEventListener("resize", schedule)
  #|       }
  #|       resizeObserver?.disconnect()
  #|       resizeObserver = null
  #|       intersectionObserver?.disconnect()
  #|       intersectionObserver = null
  #|       mutationObserver?.disconnect()
  #|       mutationObserver = null
  #|       delete popup.dataset.positioned
  #|       delete popup.dataset.anchorHidden
  #|     }
  #|     const start = () => {
  #|       if (observing || !isOpen()) return
  #|       observing = true
  #|       if (typeof window !== "undefined") {
  #|         window.addEventListener("scroll", schedule, { capture: true, passive: true })
  #|         window.addEventListener("resize", schedule, { passive: true })
  #|         window.visualViewport?.addEventListener("scroll", schedule, { passive: true })
  #|         window.visualViewport?.addEventListener("resize", schedule, { passive: true })
  #|       }
  #|       if (typeof ResizeObserver === "function") {
  #|         const trigger = document.getElementById(popup.dataset.triggerId || "")
  #|         resizeObserver = new ResizeObserver(schedule)
  #|         if (trigger) resizeObserver.observe(trigger)
  #|         resizeObserver.observe(popup)
  #|       }
  #|       if (typeof IntersectionObserver === "function") {
  #|         const trigger = document.getElementById(popup.dataset.triggerId || "")
  #|         intersectionObserver = new IntersectionObserver(schedule, { threshold: [0, 1] })
  #|         if (trigger) intersectionObserver.observe(trigger)
  #|       }
  #|       if (typeof MutationObserver === "function") {
  #|         mutationObserver = new MutationObserver(records => {
  #|           if (!isOpen()) return
  #|           const positioningInputChanged = records.some(record => record.attributeName !== "style")
  #|           const coordinatesWereReset = !popup.style.getPropertyValue("--rui-floating-left")
  #|             || !popup.style.getPropertyValue("--rui-floating-top")
  #|           if (positioningInputChanged || coordinatesWereReset) position()
  #|         })
  #|         mutationObserver.observe(popup, {
  #|           attributes: true,
  #|           attributeFilter: [
  #|             "style",
  #|             "data-requested-side",
  #|             "data-requested-align",
  #|             "data-side-offset",
  #|             "data-align-offset",
  #|           ],
  #|         })
  #|       }
  #|     }
  #|     popup.__ruiFloatingPositioning = { position, schedule, start, stop }
  #|     popup.__ruiFloatingStopPositioning = stop
  #|   }
  #|   popup.__ruiFloatingPositioning.start()
  #|   // AfterRender already runs inside Rabbita's frame flush. Measuring and
  #|   // writing here keeps the first visible frame anchored to its trigger.
  #|   popup.__ruiFloatingPositioning.position()
  #| }

///|
#cfg(target="js")
fn floating_bind_sync_cmd(id : String, sync : @cmd.Emit[Bool]) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, scheduler => {
    ui_after_mount(
      id,
      () => ffi_bind_floating_sync(id, open => scheduler.add(sync(open))),
      purpose="floating-sync-bind",
    )
  })
}

///|
#cfg(target="js")
fn floating_set_open_when_ready(id : String, open : Bool) -> Unit {
  ui_after_ready("floating-set-open:" + id, () => {
    let ready = ffi_set_floating_open(id, open)
    if ready && open {
      ffi_position_floating(id)
    }
    ready
  })
}

///|
#cfg(target="js")
fn floating_set_open_cmd(id : String, open : Bool) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, _ => {
    floating_set_open_when_ready(id, open)
  })
}

///|
#cfg(not(target="js"))
fn floating_set_open_cmd(id : String, open : Bool) -> @cmd.Cmd {
  ignore((id, open))
  @cmd.none
}

///|
#cfg(target="js")
fn floating_toggle_cmd(id : String) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, _ => {
    ffi_toggle_floating(id)
    ffi_position_floating(id)
  })
}

///|
#cfg(not(target="js"))
fn floating_toggle_cmd(id : String) -> @cmd.Cmd {
  ignore(id)
  @cmd.none
}

///|
/// Imperatively open a mounted popover. Its incremental component synchronizes
/// through the native `toggle` event.
pub fn popover_open(id : String) -> @cmd.Cmd {
  floating_set_open_cmd(id, true)
}

///|
pub fn popover_close(id : String) -> @cmd.Cmd {
  floating_set_open_cmd(id, false)
}

///|
pub fn popover_toggle(id : String) -> @cmd.Cmd {
  floating_toggle_cmd(id)
}

///|
/// Render a measurable custom anchor for controlled popover composition.
///
/// Pass this element's `id` as `popover_content(trigger_id=...)`. The anchor
/// may wrap any trigger or visual target; positioning then uses the anchor's
/// bounding box instead of requiring the trigger itself to be the reference.
pub fn[C : @html.IsChildren] popover_anchor(
  id~ : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.span(
    style=ui_styles(
      [UiBoxSizing, PopoverAnchorStyle, popup_anchor_style(id)],
      style,
    ),
    id~,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "popover-anchor"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] popover_trigger(
  target_id~ : String,
  open? : Bool = false,
  disabled? : Bool = false,
  variant? : ButtonVariant = Outline,
  size? : ButtonSize = Default,
  on_click? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let resolved_id = id.unwrap_or(target_id + "-trigger")
  let element_attrs = popup_state_attrs(attrs, "popover-trigger", open)
    .data_set("variant", button_variant_value(variant))
    .data_set("size", button_size_value(size))
    .aria_haspopup("dialog")
    .aria_expanded(ui_bool(open))
    .aria_controls(target_id)
  if disabled {
    ignore(element_attrs.aria_disabled("true").data_set("disabled", ""))
  }
  if !disabled && on_click is Some(command) {
    ignore(element_attrs.on_click_after(_ => command))
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
pub fn[C : @html.IsChildren] popover_content(
  id~ : String,
  trigger_id~ : String,
  open? : Bool = false,
  modal? : Bool = false,
  initial_focus? : Bool = true,
  initial_focus_id? : String,
  restore_focus? : Bool = true,
  final_focus_id? : String,
  side? : PopupSide = Bottom,
  align? : PopupAlign = Center,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  title_id? : String,
  description_id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = popup_state_attrs(attrs, "popover-content", open)
    .role("dialog")
    .tabindex(-1)
    .data_set("modal", ui_bool(modal))
    .data_set("initial-focus", ui_bool(initial_focus))
    .data_set("restore-focus", ui_bool(restore_focus))
    .data_set("trigger-id", trigger_id)
    .data_set("requested-side", popup_side_value(side))
    .data_set("requested-align", popup_align_value(align))
    .data_set("side", popup_side_value(side))
    .data_set("align", popup_align_value(align))
    .data_set("side-offset", "\{side_offset}")
    .data_set("align-offset", "\{align_offset}")
    .data_set("collision-padding", "0")
    .data_set("sticky", "partial")
  if modal {
    ignore(element_attrs.aria_modal("true"))
  } else {
    ignore(element_attrs.popover("auto"))
  }
  if initial_focus_id is Some(initial_focus_id) {
    ignore(element_attrs.data_set("initial-focus-id", initial_focus_id))
  }
  if final_focus_id is Some(final_focus_id) {
    ignore(element_attrs.data_set("final-focus-id", final_focus_id))
  }
  if title_id is Some(title_id) {
    ignore(element_attrs.aria_labelledby(title_id))
  }
  if description_id is Some(description_id) {
    ignore(element_attrs.aria_describedby(description_id))
  }
  let content_style = ui_styles(
    [
      UiBoxSizing,
      UiFontSans,
      UiTextRendering,
      PopoverContentStyle,
      PopupTransition100Style,
      popup_floating_anchor_style(
        trigger_id, side, align, side_offset, align_offset,
      ),
      popup_state_style(open),
    ],
    style,
  )
  if modal {
    let native_open = floating_dialog_open(open)
    @html.dialog(
      style=content_style,
      id~,
      class?,
      title?,
      open?=native_open,
      closedby="any",
      attrs=element_attrs,
      children,
    )
  } else {
    @html.div(
      style=content_style,
      id~,
      class?,
      title?,
      attrs=element_attrs,
      children,
    )
  }
}

///|
pub fn[C : @html.IsChildren] popover_header(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, PopoverHeaderStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "popover-header"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] popover_title(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.h2(
    style=ui_styles([UiBoxSizing, PopoverTitleStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "popover-title"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] popover_description(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.p(
    style=ui_styles([UiBoxSizing, PopoverDescriptionStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "popover-description"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] popover_close_button(
  target_id~ : String,
  disabled? : Bool = false,
  variant? : ButtonVariant = Ghost,
  size? : ButtonSize = Sm,
  aria_label? : String = "Close",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "popover-close")
    .data_set("variant", button_variant_value(variant))
    .data_set("size", button_size_value(size))
  ignore(element_attrs.aria_label(aria_label))
  if disabled {
    ignore(element_attrs.aria_disabled("true").data_set("disabled", ""))
  }
  if !disabled {
    ignore(element_attrs.on_click_after(_ => popover_close(target_id)))
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
#cfg(target="js")
priv enum PopoverMsg {
  PopoverToggleRequested
  PopoverNativeChanged(Bool)
}

///|
#cfg(target="js")
fn popover_notify_cmd(
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
fn[T : @html.IsChildren, C : @html.IsChildren] render_popover(
  id : String,
  open : Bool,
  disabled : Bool,
  modal : Bool,
  initial_focus : Bool,
  initial_focus_id : String?,
  restore_focus : Bool,
  final_focus_id : String?,
  side : PopupSide,
  align : PopupAlign,
  side_offset : Int,
  align_offset : Int,
  trigger_variant : ButtonVariant,
  trigger_size : ButtonSize,
  title_id : String?,
  description_id : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  trigger_attrs : @html.Attrs?,
  trigger_style : Array[String],
  content_attrs : @html.Attrs?,
  content_style : Array[String],
  on_trigger_click : @cmd.Cmd?,
  trigger : T,
  content : C,
) -> @html.Html {
  let trigger_id = id + "-trigger"
  let root_attrs = popup_state_attrs(attrs, "popover", open)
  let on_click = on_trigger_click
  let attrs = trigger_attrs
  let popup_attrs = content_attrs
  @html.span(
    style=ui_styles([UiBoxSizing, PopoverRootStyle], style),
    attrs=root_attrs,
    [
      popover_trigger(
        target_id=id,
        open~,
        disabled~,
        variant=trigger_variant,
        size=trigger_size,
        on_click?,
        id=trigger_id,
        attrs?,
        style=trigger_style,
        trigger,
      ),
      popover_content(
        id~,
        trigger_id~,
        open~,
        modal~,
        initial_focus~,
        initial_focus_id?,
        restore_focus~,
        final_focus_id?,
        side~,
        align~,
        side_offset~,
        align_offset~,
        title_id?,
        description_id?,
        attrs?=popup_attrs,
        style=content_style,
        content,
      ),
    ],
  )
}

///|
/// Build a stateful Rabbita popover backed by native browser primitives.
///
/// The default non-modal mode uses the HTML Popover API for light-dismiss and
/// Escape. `modal=true` uses `<dialog>` for inert background and Tab
/// containment. Initial and final focus IDs configure focus entry and
/// restoration. `id` is also used by `popover_open`, `popover_close`, and
/// `popover_toggle`.
#cfg(target="js")
pub fn[T : @html.IsChildren, C : @html.IsChildren] popover(
  id~ : String,
  default_open? : Bool = false,
  disabled? : Bool = false,
  modal? : Bool = false,
  initial_focus? : Bool = true,
  initial_focus_id? : String,
  restore_focus? : Bool = true,
  final_focus_id? : String,
  side? : PopupSide = Bottom,
  align? : PopupAlign = Center,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  trigger_variant? : ButtonVariant = Outline,
  trigger_size? : ButtonSize = Default,
  title_id? : String,
  description_id? : String,
  on_open_change? : @cmd.Emit[Bool],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  trigger_attrs? : @html.Attrs,
  trigger_style? : Array[String] = [],
  content_attrs? : @html.Attrs,
  content_style? : Array[String] = [],
  trigger : T,
  content : C,
) -> @rabbita.Val[@html.Html] {
  let initial_open = default_open && !disabled
  let (open, emit) = @rabbita.create_state_with_init(
    init=emit => {
      let sync = emit.map(value => PopoverNativeChanged(value))
      (
        initial_open,
        @cmd.batch([
          floating_bind_sync_cmd(id, sync),
          if initial_open {
            floating_set_open_cmd(id, true)
          } else {
            @cmd.none
          },
        ]),
      )
    },
    update=(_, msg, current) => {
      match msg {
        PopoverToggleRequested =>
          if disabled {
            (current, @cmd.none)
          } else {
            let next = !current
            (
              next,
              @cmd.batch([
                floating_set_open_cmd(id, next),
                popover_notify_cmd(on_open_change, next),
              ]),
            )
          }
        PopoverNativeChanged(next) =>
          if next == current {
            (current, @cmd.none)
          } else {
            (next, popover_notify_cmd(on_open_change, next))
          }
      }
    },
  )
  open.view(open => {
    render_popover(
      id,
      open,
      disabled,
      modal,
      initial_focus,
      initial_focus_id,
      restore_focus,
      final_focus_id,
      side,
      align,
      side_offset,
      align_offset,
      trigger_variant,
      trigger_size,
      title_id,
      description_id,
      attrs,
      style,
      trigger_attrs,
      trigger_style,
      content_attrs,
      content_style,
      Some(emit(PopoverToggleRequested)),
      trigger,
      content,
    )
  })
}

///|
/// Native/SSR fallback: renders the initial state as a constant incremental
/// value. Browser interaction is available on the JavaScript target.
#cfg(not(target="js"))
pub fn[T : @html.IsChildren, C : @html.IsChildren] popover(
  id~ : String,
  default_open? : Bool = false,
  disabled? : Bool = false,
  modal? : Bool = false,
  initial_focus? : Bool = true,
  initial_focus_id? : String,
  restore_focus? : Bool = true,
  final_focus_id? : String,
  side? : PopupSide = Bottom,
  align? : PopupAlign = Center,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  trigger_variant? : ButtonVariant = Outline,
  trigger_size? : ButtonSize = Default,
  title_id? : String,
  description_id? : String,
  on_open_change? : @cmd.Emit[Bool],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  trigger_attrs? : @html.Attrs,
  trigger_style? : Array[String] = [],
  content_attrs? : @html.Attrs,
  content_style? : Array[String] = [],
  trigger : T,
  content : C,
) -> @rabbita.Val[@html.Html] {
  ignore(on_open_change)
  @rabbita.Val::constant(
    render_popover(
      id,
      default_open && !disabled,
      disabled,
      modal,
      initial_focus,
      initial_focus_id,
      restore_focus,
      final_focus_id,
      side,
      align,
      side_offset,
      align_offset,
      trigger_variant,
      trigger_size,
      title_id,
      description_id,
      attrs,
      style,
      trigger_attrs,
      trigger_style,
      content_attrs,
      content_style,
      None,
      trigger,
      content,
    ),
  )
}
