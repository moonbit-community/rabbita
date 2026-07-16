///|
pub(all) enum SidebarSide {
  SidebarLeft
  SidebarRight
} derive(Debug, Eq)

///|
pub(all) enum SidebarVariant {
  SidebarDefault
  SidebarFloating
  SidebarInset
} derive(Debug, Eq)

///|
pub(all) enum SidebarCollapsible {
  SidebarOffcanvas
  SidebarIcon
  SidebarFixed
} derive(Debug, Eq)

///|
pub(all) enum SidebarMenuButtonSize {
  SidebarMenuSm
  SidebarMenuDefault
  SidebarMenuLg
} derive(Debug, Eq)

///|
#cfg(target="js")
priv struct SidebarState {
  collapsed : Bool
  mobile_open : Bool
  desktop_width : Int?
} derive(Eq)

///|
#cfg(target="js")
priv enum SidebarMessage {
  ToggleSidebarCollapsed
  SetSidebarCollapsed(Bool)
  ToggleSidebarMobile
  SetSidebarMobile(Bool)
  CommitSidebarWidth(Int)
}

///|
/// Explicit state and commands shared by every part inside
/// [`sidebar_provider`].
struct SidebarScope {
  collapsed : Bool
  mobile_open : Bool
  desktop_width : Int?
  toggle_collapsed : @cmd.Cmd
  expand : @cmd.Cmd
  collapse : @cmd.Cmd
  toggle_mobile : @cmd.Cmd
  open_mobile : @cmd.Cmd
  close_mobile : @cmd.Cmd
  commit_width : @cmd.Emit[Int]
}

///|
const SidebarProviderStyle : String = "display:flex;width:100%;min-height:100%;align-items:stretch;background:var(--rui-background,oklch(1 0 0));color:var(--rui-foreground,oklch(0.145 0 0))"

///|
const SidebarBaseStyle : String = "position:relative;display:flex;min-width:0;flex-direction:column;flex-shrink:0;overflow-x:hidden;background:var(--rui-sidebar,var(--rui-muted,oklch(0.97 0 0)));color:var(--rui-sidebar-foreground,var(--rui-foreground,oklch(0.145 0 0)));transition:width 200ms ease,transform 200ms ease"

///|
const SidebarMobileStyle : String = "position:fixed;top:0;bottom:0;z-index:50;width:min(var(--rui-sidebar-width,16rem),calc(100vw - 2rem));max-width:100vw;box-shadow:0 16px 48px rgb(0 0 0 / 0.22)"

///|
const SidebarOverlayStyle : String = "position:fixed;inset:0;z-index:49;background:rgb(0 0 0 / 0.5);opacity:var(--rui-sidebar-overlay-opacity,0);visibility:var(--rui-sidebar-overlay-visibility,hidden);pointer-events:var(--rui-sidebar-overlay-pointer-events,none);transition:opacity 200ms ease,visibility 0s linear var(--rui-sidebar-overlay-visibility-delay,200ms)"

///|
const SidebarOverlayOpenStyle : String = "--rui-sidebar-overlay-opacity:1;--rui-sidebar-overlay-visibility:visible;--rui-sidebar-overlay-pointer-events:auto;--rui-sidebar-overlay-visibility-delay:0s"

///|
const SidebarOverlayClosedStyle : String = "--rui-sidebar-overlay-opacity:0;--rui-sidebar-overlay-visibility:hidden;--rui-sidebar-overlay-pointer-events:none;--rui-sidebar-overlay-visibility-delay:200ms"

///|
const SidebarHeaderFooterStyle : String = "display:flex;min-width:0;flex-direction:column;gap:0.5rem;padding:0.5rem"

///|
const SidebarContentStyle : String = "display:flex;min-width:0;min-height:0;flex:1;flex-direction:column;gap:0.5rem;overflow-x:hidden;overflow-y:auto"

///|
const SidebarGroupStyle : String = "position:relative;display:flex;min-width:0;flex-direction:column;padding:0.5rem"

///|
const SidebarGroupLabelStyle : String = "display:var(--rui-sidebar-group-label-display,var(--rui-sidebar-group-label-local-display,flex));height:2rem;min-width:0;align-items:center;padding-inline:0.5rem;color:var(--rui-sidebar-label-fg,var(--rui-sidebar-label-base-fg,color-mix(in oklab,var(--rui-sidebar-foreground,var(--rui-foreground,oklch(0.145 0 0))) 70%,transparent)));font-size:0.75rem;line-height:1rem;font-weight:500;white-space:nowrap;overflow:hidden"

///|
const SidebarGroupActionStyle : String = "position:absolute;top:0.75rem;inset-inline-end:0.75rem;display:var(--rui-sidebar-group-action-display,inline-flex)"

///|
const SidebarActionSurfaceStyle : String = "border-color:var(--rui-sidebar-action-border,var(--rui-button-border,var(--rui-button-base-border,transparent)));background:var(--rui-sidebar-action-bg,var(--rui-button-bg,var(--rui-button-base-bg,transparent)));color:var(--rui-sidebar-action-fg,var(--rui-button-fg,var(--rui-button-base-fg,var(--rui-sidebar-foreground,inherit))));box-shadow:var(--rui-sidebar-action-shadow,var(--rui-button-shadow,var(--rui-button-base-shadow,none)))"

///|
const SidebarGroupContentStyle : String = "min-width:0;width:100%;font-size:0.875rem;line-height:1.25rem"

///|
const SidebarMenuStyle : String = "display:flex;min-width:0;width:100%;flex-direction:column;gap:0.125rem;margin:0;padding:0;list-style:none"

///|
const SidebarMenuItemStyle : String = "position:relative;display:block;min-width:0"

///|
const SidebarMenuButtonStyle : String = "display:flex;width:100%;min-width:0;align-items:center;justify-content:var(--rui-sidebar-item-justify-content,flex-start);gap:var(--rui-sidebar-item-collapse-gap,0.5rem);border:1px solid transparent;border-color:var(--rui-sidebar-item-border,var(--rui-sidebar-item-base-border,transparent));border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);margin:0;padding-inline:0.5rem;background:var(--rui-sidebar-item-bg,var(--rui-sidebar-item-base-bg,transparent));color:var(--rui-sidebar-item-fg,var(--rui-sidebar-item-base-fg,inherit));box-shadow:var(--rui-sidebar-item-shadow,var(--rui-sidebar-item-base-shadow,none));font-size:var(--rui-sidebar-item-collapse-font-size,var(--rui-sidebar-item-base-font-size,0.875rem));line-height:1.25rem;font-weight:var(--rui-sidebar-item-font-weight,var(--rui-sidebar-item-base-font-weight,400));text-align:start;text-decoration:none;white-space:nowrap;cursor:pointer;outline-offset:2px;overflow:hidden;appearance:none;-webkit-appearance:none"

///|
const SidebarMenuButtonActiveStyle : String = "--rui-sidebar-item-base-bg:var(--rui-sidebar-accent,var(--rui-accent,oklch(0.97 0 0)));--rui-sidebar-item-base-fg:var(--rui-sidebar-accent-foreground,var(--rui-accent-foreground,var(--rui-foreground,oklch(0.145 0 0))));--rui-sidebar-item-base-font-weight:500"

///|
const SidebarMenuActionStyle : String = "position:absolute;top:0.25rem;inset-inline-end:0.25rem;display:var(--rui-sidebar-menu-action-display,inline-flex);opacity:var(--rui-sidebar-action-opacity,var(--rui-sidebar-action-base-opacity,1))"

///|
const SidebarMenuActionHoverStyle : String = "--rui-sidebar-action-base-opacity:0"

///|
const SidebarRailStyle : String = "position:absolute;top:0;bottom:0;z-index:1;width:1rem;height:auto;border:0;border-radius:0;margin:0;padding:0;background:transparent;color:inherit;box-shadow:none;cursor:col-resize;touch-action:none;user-select:none"

///|
const SidebarRailLineStyle : String = "position:absolute;top:0;bottom:0;display:block;width:2px;background:var(--rui-sidebar-rail-line-bg,transparent);transition:background-color 150ms ease;pointer-events:none"

///|
const SidebarMenuBadgeStyle : String = "position:absolute;top:50%;inset-inline-end:0.5rem;display:var(--rui-sidebar-menu-badge-display,flex);min-width:1.25rem;height:1.25rem;align-items:center;justify-content:center;border-radius:0.25rem;padding-inline:0.25rem;color:var(--rui-sidebar-badge-fg,var(--rui-sidebar-badge-base-fg,inherit));font-size:0.75rem;line-height:1rem;font-variant-numeric:tabular-nums;transform:translateY(-50%);pointer-events:none"

///|
const SidebarMenuSubStyle : String = "display:var(--rui-sidebar-menu-sub-display,flex);min-width:0;flex-direction:column;gap:0.125rem;margin-block:0.25rem;margin-inline:0 0.875rem;padding-block:0.25rem;padding-inline:0 0.625rem;border-inline-start:1px solid var(--rui-border,oklch(0.922 0 0));list-style:none"

///|
const SidebarMenuSubButtonStyle : String = "display:flex;min-width:0;height:1.75rem;align-items:center;gap:0.5rem;border:0;border-radius:calc(var(--rui-radius,0.625rem) - 0.25rem);padding-inline:0.5rem;background:var(--rui-sidebar-item-bg,var(--rui-sidebar-item-base-bg,transparent));color:var(--rui-sidebar-item-fg,var(--rui-sidebar-item-base-fg,inherit));box-shadow:var(--rui-sidebar-item-shadow,var(--rui-sidebar-item-base-shadow,none));font-size:0.8125rem;line-height:1rem;font-weight:var(--rui-sidebar-item-font-weight,var(--rui-sidebar-item-base-font-weight,400));text-align:start;text-decoration:none;white-space:nowrap;overflow:hidden;cursor:pointer;outline-offset:2px"

///|
const SidebarInsetStyle : String = "position:relative;display:flex;min-width:0;min-height:100%;flex:1;flex-direction:column;background:var(--rui-background,oklch(1 0 0))"

///|
fn sidebar_side_value(side : SidebarSide) -> String {
  match side {
    SidebarLeft => "left"
    SidebarRight => "right"
  }
}

///|
fn sidebar_variant_value(variant : SidebarVariant) -> String {
  match variant {
    SidebarDefault => "sidebar"
    SidebarFloating => "floating"
    SidebarInset => "inset"
  }
}

///|
fn sidebar_collapsible_value(collapsible : SidebarCollapsible) -> String {
  match collapsible {
    SidebarOffcanvas => "offcanvas"
    SidebarIcon => "icon"
    SidebarFixed => "none"
  }
}

///|
fn sidebar_state_value(collapsed : Bool) -> String {
  if collapsed {
    "collapsed"
  } else {
    "expanded"
  }
}

///|
#cfg(target="js")
extern "js" fn ffi_sidebar_pointer_start(
  event : @dom.MouseEvent,
  min_width : Int,
  max_width : Int,
) -> Bool =
  #| (event, minWidth, maxWidth) => {
  #|   if (event.defaultPrevented || event.isPrimary === false) return false
  #|   if (event.pointerType === "mouse" && event.button !== 0) return false
  #|   const rail = event.currentTarget
  #|   const root = rail?.closest?.('[data-slot="sidebar-wrapper"]')
  #|   const sidebar = rail?.closest?.('[data-slot="sidebar"]')
  #|   if (!rail || !root || !sidebar || sidebar.dataset?.mobile === "true") return false
  #|   rail.__ruiSidebarResize?.restore?.(false)
  #|   const restoreProperty = (style, name, value) => {
  #|     if (value) style.setProperty(name, value)
  #|     else style.removeProperty(name)
  #|   }
  #|   const pointerId = event.pointerId ?? 1
  #|   const wasCollapsed = sidebar.dataset?.state === "collapsed"
  #|   const originalSidebarWidth = sidebar.style.getPropertyValue("width")
  #|   const originalTransition = sidebar.style.getPropertyValue("transition")
  #|   let startWidth = sidebar.getBoundingClientRect().width
  #|   if (wasCollapsed) {
  #|     sidebar.style.setProperty("transition", "none")
  #|     sidebar.style.setProperty(
  #|       "width",
  #|       "var(--rui-sidebar-current-width,var(--rui-sidebar-width,16rem))",
  #|     )
  #|     startWidth = sidebar.getBoundingClientRect().width
  #|     restoreProperty(sidebar.style, "width", originalSidebarWidth)
  #|     restoreProperty(sidebar.style, "transition", originalTransition)
  #|   }
  #|   const available = Math.max(0, root.getBoundingClientRect().width - 52)
  #|   const configuredMin = Number(minWidth)
  #|   const configuredMax = Number(maxWidth)
  #|   const min = Math.min(
  #|     Number.isFinite(configuredMin) ? Math.max(0, configuredMin) : 160,
  #|     available,
  #|   )
  #|   const max = Math.max(
  #|     min,
  #|     Math.min(
  #|       Number.isFinite(configuredMax) ? Math.max(min, configuredMax) : 512,
  #|       available,
  #|     ),
  #|   )
  #|   startWidth = Math.min(Math.max(startWidth, min), max)
  #|   const state = {
  #|     pointerId,
  #|     rail,
  #|     root,
  #|     sidebar,
  #|     side: rail.dataset.side === "right" ? "right" : "left",
  #|     startX: event.clientX,
  #|     startWidth,
  #|     min,
  #|     max,
  #|     width: startWidth,
  #|     active: false,
  #|     wasCollapsed,
  #|     originalCurrentWidth: root.style.getPropertyValue(
  #|       "--rui-sidebar-current-width",
  #|     ),
  #|     originalSidebarWidth,
  #|     originalTransition,
  #|     originalUserSelect: root.style.getPropertyValue("user-select"),
  #|     suppressClick: null,
  #|     lostPointerCapture: null,
  #|   }
  #|   state.removeClickSuppression = () => {
  #|     if (!state.suppressClick) return
  #|     rail.removeEventListener?.("click", state.suppressClick, true)
  #|     state.suppressClick = null
  #|   }
  #|   state.installClickSuppression = () => {
  #|     if (state.suppressClick) return
  #|     state.suppressClick = click => {
  #|       click.preventDefault()
  #|       click.stopImmediatePropagation?.()
  #|       click.stopPropagation?.()
  #|       state.removeClickSuppression()
  #|     }
  #|     rail.addEventListener?.("click", state.suppressClick, true)
  #|   }
  #|   state.restore = committed => {
  #|     const dragged = state.active
  #|     if (committed && dragged) {
  #|       restoreProperty(
  #|         sidebar.style,
  #|         "transition",
  #|         state.originalTransition,
  #|       )
  #|       restoreProperty(root.style, "user-select", state.originalUserSelect)
  #|       if (!state.wasCollapsed) {
  #|         restoreProperty(
  #|           sidebar.style,
  #|           "width",
  #|           state.originalSidebarWidth,
  #|         )
  #|       }
  #|     } else {
  #|       restoreProperty(
  #|         root.style,
  #|         "--rui-sidebar-current-width",
  #|         state.originalCurrentWidth,
  #|       )
  #|       restoreProperty(
  #|         sidebar.style,
  #|         "width",
  #|         state.originalSidebarWidth,
  #|       )
  #|       restoreProperty(
  #|         sidebar.style,
  #|         "transition",
  #|         state.originalTransition,
  #|       )
  #|       restoreProperty(root.style, "user-select", state.originalUserSelect)
  #|     }
  #|     delete root.dataset.resizing
  #|     delete sidebar.dataset.resizing
  #|     delete rail.dataset.resizing
  #|     if (state.lostPointerCapture) {
  #|       rail.removeEventListener?.(
  #|         "lostpointercapture",
  #|         state.lostPointerCapture,
  #|       )
  #|     }
  #|     if (rail.__ruiSidebarResize === state) delete rail.__ruiSidebarResize
  #|     try { rail.releasePointerCapture?.(state.pointerId) } catch (_) { }
  #|     if (committed && dragged) {
  #|       setTimeout(() => state.removeClickSuppression(), 0)
  #|     } else {
  #|       state.removeClickSuppression()
  #|     }
  #|   }
  #|   state.lostPointerCapture = lost => {
  #|     if (rail.__ruiSidebarResize !== state) return
  #|     if ((lost.pointerId ?? 1) !== state.pointerId) return
  #|     state.restore(false)
  #|   }
  #|   rail.addEventListener?.(
  #|     "lostpointercapture",
  #|     state.lostPointerCapture,
  #|   )
  #|   rail.__ruiSidebarResize = state
  #|   try { rail.setPointerCapture?.(pointerId) } catch (_) { }
  #|   return true
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_sidebar_pointer_move(event : @dom.MouseEvent) -> Bool =
  #| event => {
  #|     const rail = event.currentTarget
  #|     const state = rail?.__ruiSidebarResize
  #|     if (!state || (event.pointerId ?? 1) !== state.pointerId) return false
  #|     const physicalDelta = event.clientX - state.startX
  #|     if (!state.active) {
  #|       if (Math.abs(physicalDelta) < 4) return false
  #|       state.active = true
  #|       state.installClickSuppression()
  #|       state.root.dataset.resizing = "true"
  #|       state.sidebar.dataset.resizing = "true"
  #|       rail.dataset.resizing = "true"
  #|       state.root.style.setProperty("user-select", "none")
  #|     }
  #|     const delta = state.side === "right" ? -physicalDelta : physicalDelta
  #|     state.width = Math.min(
  #|       Math.max(state.startWidth + delta, state.min),
  #|       state.max,
  #|     )
  #|     state.root.style.setProperty(
  #|       "--rui-sidebar-current-width",
  #|       `${Math.round(state.width)}px`,
  #|     )
  #|     state.sidebar.style.setProperty("transition", "none")
  #|     state.sidebar.style.setProperty("width", `${Math.round(state.width)}px`)
  #|     return true
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_sidebar_pointer_end(event : @dom.MouseEvent) -> Int =
  #| event => {
  #|   const rail = event.currentTarget
  #|   const state = rail?.__ruiSidebarResize
  #|   if (!state || (event.pointerId ?? 1) !== state.pointerId) return 0
  #|   const width = state.active ? Math.round(state.width) : 0
  #|   state.restore(state.active)
  #|   return width
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_sidebar_pointer_cancel(event : @dom.MouseEvent) -> Unit =
  #| event => {
  #|   const rail = event.currentTarget
  #|   const state = rail?.__ruiSidebarResize
  #|   if (!state || (event.pointerId ?? 1) !== state.pointerId) return
  #|   state.restore(false)
  #| }

///|
fn sidebar_side_style(side : SidebarSide) -> String {
  match side {
    SidebarLeft =>
      "order:0;border-right:1px solid var(--rui-border,oklch(0.922 0 0))"
    SidebarRight =>
      "order:1;border-left:1px solid var(--rui-border,oklch(0.922 0 0))"
  }
}

///|
fn sidebar_mobile_side_style(side : SidebarSide) -> String {
  match side {
    SidebarLeft => "left:0"
    SidebarRight => "right:0"
  }
}

///|
fn sidebar_mobile_state_style(side : SidebarSide, open : Bool) -> String {
  if open {
    "transform:translateX(0)"
  } else {
    match side {
      SidebarLeft => "transform:translateX(-100%)"
      SidebarRight => "transform:translateX(100%)"
    }
  }
}

///|
fn sidebar_variant_style(
  variant : SidebarVariant,
  side : SidebarSide,
) -> String {
  match (variant, side) {
    (SidebarDefault, _) => ""
    (SidebarFloating, _) =>
      "margin:0.5rem;border:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:var(--rui-radius,0.625rem);box-shadow:0 2px 8px rgb(0 0 0 / 0.08)"
    (SidebarInset, SidebarLeft) =>
      "margin:0.5rem 0 0.5rem 0.5rem;border:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:var(--rui-radius,0.625rem)"
    (SidebarInset, SidebarRight) =>
      "margin:0.5rem 0.5rem 0.5rem 0;border:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:var(--rui-radius,0.625rem)"
  }
}

///|
fn sidebar_descendant_state_style(
  collapsed : Bool,
  collapsible : SidebarCollapsible,
  mobile : Bool,
) -> String {
  if mobile {
    "--rui-sidebar-group-label-display:flex;--rui-sidebar-group-action-display:inline-flex;--rui-sidebar-menu-action-display:inline-flex;--rui-sidebar-menu-badge-display:flex;--rui-sidebar-menu-sub-display:flex;--rui-sidebar-input-display:block;--rui-sidebar-item-collapse-gap:initial;--rui-sidebar-item-collapse-font-size:initial;--rui-sidebar-item-justify-content:flex-start"
  } else if collapsed && collapsible is SidebarIcon {
    "--rui-sidebar-group-label-display:none;--rui-sidebar-group-action-display:none;--rui-sidebar-menu-action-display:none;--rui-sidebar-menu-badge-display:none;--rui-sidebar-menu-sub-display:none;--rui-sidebar-input-display:none;--rui-sidebar-item-collapse-gap:0;--rui-sidebar-item-collapse-font-size:0;--rui-sidebar-item-justify-content:center"
  } else {
    ""
  }
}

///|
#cfg(target="js")
extern "js" fn ffi_sidebar_trap_focus(event : @dom.KeyboardEvent) -> Bool =
  #| event => {
  #|   if (event.key !== "Tab" || event.altKey || event.ctrlKey || event.metaKey) return false
  #|   const root = event.currentTarget
  #|   if (!root || root.getAttribute("aria-hidden") === "true") return false
  #|   const selector = 'a[href],button:not([disabled]),input:not([disabled]),select:not([disabled]),textarea:not([disabled]),[tabindex]:not([tabindex="-1"])'
  #|   const visible = node => !node.closest?.("[inert]")
  #|     && node.getClientRects().length > 0
  #|     && getComputedStyle(node).visibility !== "hidden"
  #|   const items = Array.from(root.querySelectorAll(selector)).filter(visible)
  #|   if (!items.length) {
  #|     root.focus()
  #|     return true
  #|   }
  #|   const first = items[0]
  #|   const last = items[items.length - 1]
  #|   const active = document.activeElement
  #|   if (event.shiftKey && (active === first || !root.contains(active))) {
  #|     last.focus()
  #|     return true
  #|   }
  #|   if (!event.shiftKey && (active === last || !root.contains(active))) {
  #|     first.focus()
  #|     return true
  #|   }
  #|   return false
  #| }

///|
#cfg(target="js")
fn sidebar_bind_mobile_dismiss(attrs : @html.Attrs, command : @cmd.Cmd) -> Unit {
  ignore(
    attrs.on_keydown_after(event => {
      if event.key() == "Escape" {
        event.prevent_default()
        command
      } else if ffi_sidebar_trap_focus(event) {
        event.prevent_default()
        @cmd.none
      } else {
        @cmd.none
      }
    }),
  )
}

///|
#cfg(target="js")
extern "js" fn ffi_sidebar_focus_open() -> Bool =
  #| () => {
  #|   if (typeof document === "undefined") return false
  #|   const openSidebars = () => Array.from(
  #|     document.querySelectorAll('[data-slot="sidebar"][data-mobile="true"][data-mobile-state="open"]')
  #|   ).filter(root => !root.hidden && root.getAttribute("aria-hidden") !== "true")
  #|   const current = () => openSidebars().at(-1) || null
  #|   const focusable = root => {
  #|     const selector = 'a[href],button:not([disabled]),input:not([disabled]),select:not([disabled]),textarea:not([disabled]),[tabindex]:not([tabindex="-1"])'
  #|     return Array.from(root.querySelectorAll(selector)).filter(node => {
  #|       if (node.closest?.("[inert]") || node.getClientRects().length === 0) return false
  #|       const style = typeof getComputedStyle === "function" ? getComputedStyle(node) : null
  #|       return !style || (style.display !== "none" && style.visibility !== "hidden")
  #|     })
  #|   }
  #|   const focusEdge = (root, last = false) => {
  #|     const items = focusable(root)
  #|     const target = items.length ? items[last ? items.length - 1 : 0] : root
  #|     try { target.focus({ preventScroll: true }) }
  #|     catch (_) { target.focus?.() }
  #|   }
  #|   const releaseModal = () => {
  #|     const state = globalThis.__ruiSidebarModalState
  #|     if (!state) return
  #|     state.observer?.disconnect?.()
  #|     for (const record of state.records.reverse()) {
  #|       if (record.hadInert) record.node.setAttribute?.("inert", record.inertValue)
  #|       else record.node.removeAttribute?.("inert")
  #|       if (record.ariaHidden === null) record.node.removeAttribute?.("aria-hidden")
  #|       else record.node.setAttribute?.("aria-hidden", record.ariaHidden)
  #|     }
  #|     delete globalThis.__ruiSidebarModalState
  #|   }
  #|   globalThis.__ruiSidebarReleaseModal = releaseModal
  #|   const containBackground = root => {
  #|     const existing = globalThis.__ruiSidebarModalState
  #|     if (existing?.root === root) return
  #|     releaseModal()
  #|     const records = []
  #|     let node = root
  #|     while (node?.parentElement) {
  #|       const parent = node.parentElement
  #|       for (const sibling of Array.from(parent.children || [])) {
  #|         if (sibling === node || sibling.dataset?.slot === "sidebar-overlay") continue
  #|         records.push({
  #|           node: sibling,
  #|           hadInert: sibling.hasAttribute?.("inert") || false,
  #|           inertValue: sibling.getAttribute?.("inert") || "",
  #|           ariaHidden: sibling.getAttribute?.("aria-hidden") ?? null,
  #|         })
  #|         sibling.setAttribute?.("inert", "")
  #|         sibling.setAttribute?.("aria-hidden", "true")
  #|       }
  #|       node = parent
  #|       if (node === document.body) break
  #|     }
  #|     const observer = typeof MutationObserver === "function"
  #|       ? new MutationObserver(() => {
  #|           if (root.hidden || root.getAttribute("aria-hidden") === "true"
  #|             || root.dataset.mobileState !== "open") releaseModal()
  #|         })
  #|       : null
  #|     observer?.observe(root, {
  #|       attributes: true,
  #|       attributeFilter: ["data-mobile-state", "aria-hidden", "hidden"],
  #|     })
  #|     globalThis.__ruiSidebarModalState = { root, records, observer }
  #|   }
  #|   if (!document.__ruiSidebarModalBound) {
  #|     document.__ruiSidebarModalBound = true
  #|     document.addEventListener("focusin", event => {
  #|       const root = current()
  #|       if (!root) {
  #|         releaseModal()
  #|       } else if (!root.contains(event.target)) {
  #|         focusEdge(root)
  #|       }
  #|     }, true)
  #|     document.addEventListener("keydown", event => {
  #|       const root = current()
  #|       if (!root || event.defaultPrevented) return
  #|       if (event.key === "Tab" && !root.contains(document.activeElement)) {
  #|         event.preventDefault()
  #|         focusEdge(root, Boolean(event.shiftKey))
  #|         return
  #|       }
  #|       if (event.key === "Escape" && !root.contains(event.target)) {
  #|         event.preventDefault()
  #|         const forwarded = new KeyboardEvent("keydown", {
  #|           key: "Escape",
  #|           bubbles: true,
  #|           cancelable: true,
  #|         })
  #|         root.dispatchEvent(forwarded)
  #|       }
  #|     }, true)
  #|   }
  #|   const root = current()
  #|   if (!root) return false
  #|   containBackground(root)
  #|   if (!root.contains(document.activeElement)) focusEdge(root)
  #|   return root.contains(document.activeElement) || document.activeElement === root
  #| }

///|
#cfg(target="js")
fn sidebar_focus_open_cmd() -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, _ => ignore(ffi_sidebar_focus_open()))
}

///|
#cfg(not(target="js"))
fn sidebar_focus_open_cmd() -> @cmd.Cmd {
  @cmd.none
}

///|
#cfg(target="js")
fn sidebar_bind_mobile_focus(attrs : @html.Attrs, open : Bool) -> Unit {
  if open {
    ignore(
      attrs.on_focus_after(_ => {
        ignore(ffi_sidebar_focus_open())
        @cmd.none
      }),
    )
  }
}

///|
#cfg(not(target="js"))
fn sidebar_bind_mobile_focus(attrs : @html.Attrs, open : Bool) -> Unit {
  ignore((attrs, open))
}

///|
#cfg(not(target="js"))
fn sidebar_bind_mobile_dismiss(attrs : @html.Attrs, command : @cmd.Cmd) -> Unit {
  ignore((attrs, command))
}

///|
#cfg(target="js")
fn sidebar_bind_disabled_link(attrs : @html.Attrs, disabled : Bool) -> Unit {
  if disabled {
    ignore(
      attrs.on_click_after(event => {
        event.prevent_default()
        @cmd.none
      }),
    )
  }
}

///|
#cfg(not(target="js"))
fn sidebar_bind_disabled_link(attrs : @html.Attrs, disabled : Bool) -> Unit {
  ignore((attrs, disabled))
}

///|
#cfg(target="js")
extern "js" fn ffi_sidebar_capture_restore_trigger(
  event : @dom.MouseEvent,
) -> Unit =
  #| event => {
  #|   const trigger = event.currentTarget
  #|   if (!trigger || typeof trigger.focus !== "function") return
  #|   globalThis.__ruiSidebarRestoreTrigger = trigger
  #| }

///|
#cfg(target="js")
fn sidebar_bind_restore_trigger(attrs : @html.Attrs, enabled : Bool) -> Unit {
  if enabled {
    ignore(
      attrs.on_click_after(event => {
        ffi_sidebar_capture_restore_trigger(event)
        @cmd.none
      }),
    )
  }
}

///|
#cfg(not(target="js"))
fn sidebar_bind_restore_trigger(attrs : @html.Attrs, enabled : Bool) -> Unit {
  ignore((attrs, enabled))
}

///|
#cfg(target="js")
extern "js" fn ffi_sidebar_restore_trigger() -> Unit =
  #| () => {
  #|   globalThis.__ruiSidebarReleaseModal?.()
  #|   const trigger = globalThis.__ruiSidebarRestoreTrigger
  #|   delete globalThis.__ruiSidebarRestoreTrigger
  #|   if (!trigger?.isConnected || typeof trigger.focus !== "function") return
  #|   if (trigger.disabled || trigger.getAttribute?.("aria-disabled") === "true") return
  #|   if (trigger.closest?.("[inert],[hidden],[aria-hidden=\"true\"]")) return
  #|   try {
  #|     trigger.focus({ preventScroll: true })
  #|   } catch (_) {
  #|     trigger.focus()
  #|   }
  #| }

///|
#cfg(target="js")
fn sidebar_restore_trigger_cmd() -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, _ => ffi_sidebar_restore_trigger())
}

///|
#cfg(not(target="js"))
fn sidebar_restore_trigger_cmd() -> @cmd.Cmd {
  @cmd.none
}

///|
fn sidebar_mobile_change_cmd(
  notify : @cmd.Emit[Bool]?,
  open : Bool,
) -> @cmd.Cmd {
  @cmd.batch([
    sidebar_emit_bool(notify, open),
    if open {
      sidebar_focus_open_cmd()
    } else {
      sidebar_restore_trigger_cmd()
    },
  ])
}

///|
fn sidebar_width_style(
  collapsed : Bool,
  collapsible : SidebarCollapsible,
) -> String {
  match (collapsed, collapsible) {
    (true, SidebarOffcanvas) =>
      "width:0;min-width:0;margin:0;border:0;padding:0;box-shadow:none;overflow:hidden"
    (true, SidebarIcon) => "width:var(--rui-sidebar-width-icon,3rem)"
    (_, _) =>
      "width:var(--rui-sidebar-current-width,var(--rui-sidebar-width,16rem))"
  }
}

///|
fn sidebar_provider_width_style(width : Int?) -> String {
  match width {
    Some(width) => "--rui-sidebar-current-width:\{width}px"
    None => ""
  }
}

///|
fn sidebar_menu_size_value(size : SidebarMenuButtonSize) -> String {
  match size {
    SidebarMenuSm => "sm"
    SidebarMenuDefault => "default"
    SidebarMenuLg => "lg"
  }
}

///|
fn sidebar_menu_size_style(size : SidebarMenuButtonSize) -> String {
  match size {
    SidebarMenuSm => "height:1.75rem;--rui-sidebar-item-base-font-size:0.75rem"
    SidebarMenuDefault =>
      "height:2rem;--rui-sidebar-item-base-font-size:0.875rem"
    SidebarMenuLg => "height:3rem;--rui-sidebar-item-base-font-size:0.875rem"
  }
}

///|
fn sidebar_emit_bool(emit : @cmd.Emit[Bool]?, value : Bool) -> @cmd.Cmd {
  if emit is Some(notify) {
    notify(value)
  } else {
    @cmd.none
  }
}

///|
#cfg(target="js")
fn sidebar_scope(
  state : SidebarState,
  emit : @cmd.Emit[SidebarMessage],
) -> SidebarScope {
  {
    collapsed: state.collapsed,
    mobile_open: state.mobile_open,
    desktop_width: state.desktop_width,
    toggle_collapsed: emit(ToggleSidebarCollapsed),
    expand: emit(SetSidebarCollapsed(false)),
    collapse: emit(SetSidebarCollapsed(true)),
    toggle_mobile: emit(ToggleSidebarMobile),
    open_mobile: emit(SetSidebarMobile(true)),
    close_mobile: emit(SetSidebarMobile(false)),
    commit_width: emit.map(width => CommitSidebarWidth(width)),
  }
}

///|
fn sidebar_provider_view(
  scope : SidebarScope,
  id : String?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : (SidebarScope) -> @html.Html,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "sidebar-wrapper")
    .data_set("state", sidebar_state_value(scope.collapsed))
    .data_set("mobile", if scope.mobile_open { "open" } else { "closed" })
    .data_set(
      "width",
      match scope.desktop_width {
        Some(width) => "\{width}"
        None => "auto"
      },
    )
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        SidebarProviderStyle,
        sidebar_provider_width_style(scope.desktop_width),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    attrs=element_attrs,
    children(scope),
  )
}

///|
/// Own desktop-collapse and mobile-open state for a complete sidebar tree.
/// The native fallback renders the requested initial state as a constant value.
#cfg(target="js")
pub fn sidebar_provider(
  default_collapsed? : Bool = false,
  default_mobile_open? : Bool = false,
  on_collapsed_change? : @cmd.Emit[Bool],
  on_mobile_open_change? : @cmd.Emit[Bool],
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (SidebarScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  let initial : SidebarState = {
    collapsed: default_collapsed,
    mobile_open: default_mobile_open,
    desktop_width: None,
  }
  let (state, emit) = @rabbita.create_state(initial, update=fn(_, msg, state) {
    match msg {
      ToggleSidebarCollapsed => {
        let next = !state.collapsed
        (
          { ..state, collapsed: next },
          sidebar_emit_bool(on_collapsed_change, next),
        )
      }
      SetSidebarCollapsed(next) =>
        if next == state.collapsed {
          (state, @cmd.none)
        } else {
          (
            { ..state, collapsed: next },
            sidebar_emit_bool(on_collapsed_change, next),
          )
        }
      ToggleSidebarMobile => {
        let next = !state.mobile_open
        (
          { ..state, mobile_open: next },
          sidebar_mobile_change_cmd(on_mobile_open_change, next),
        )
      }
      SetSidebarMobile(next) =>
        if next == state.mobile_open {
          (state, @cmd.none)
        } else {
          (
            { ..state, mobile_open: next },
            sidebar_mobile_change_cmd(on_mobile_open_change, next),
          )
        }
      CommitSidebarWidth(width) => {
        let next = { ..state, collapsed: false, desktop_width: Some(width) }
        if next == state {
          (state, @cmd.none)
        } else {
          (
            next,
            if state.collapsed {
              sidebar_emit_bool(on_collapsed_change, false)
            } else {
              @cmd.none
            },
          )
        }
      }
    }
  })
  state.view(state => {
    sidebar_provider_view(
      sidebar_scope(state, emit),
      id,
      class,
      title,
      attrs,
      style,
      children,
    )
  })
}

///|
#cfg(not(target="js"))
pub fn sidebar_provider(
  default_collapsed? : Bool = false,
  default_mobile_open? : Bool = false,
  on_collapsed_change? : @cmd.Emit[Bool],
  on_mobile_open_change? : @cmd.Emit[Bool],
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (SidebarScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  ignore((on_collapsed_change, on_mobile_open_change))
  let scope : SidebarScope = {
    collapsed: default_collapsed,
    mobile_open: default_mobile_open,
    desktop_width: None,
    toggle_collapsed: @cmd.none,
    expand: @cmd.none,
    collapse: @cmd.none,
    toggle_mobile: @cmd.none,
    open_mobile: @cmd.none,
    close_mobile: @cmd.none,
    commit_width: @cmd.Emit(_ => @cmd.none),
  }
  @rabbita.Val::constant(
    sidebar_provider_view(scope, id, class, title, attrs, style, children),
  )
}

///|
pub fn sidebar_is_collapsed(scope : SidebarScope) -> Bool {
  scope.collapsed
}

///|
pub fn sidebar_is_mobile_open(scope : SidebarScope) -> Bool {
  scope.mobile_open
}

///|
/// Commands for applications that need custom controls instead of the default
/// trigger and rail.
pub fn sidebar_expand(scope : SidebarScope) -> @cmd.Cmd {
  scope.expand
}

///|
pub fn sidebar_collapse(scope : SidebarScope) -> @cmd.Cmd {
  scope.collapse
}

///|
pub fn sidebar_open_mobile(scope : SidebarScope) -> @cmd.Cmd {
  scope.open_mobile
}

///|
pub fn sidebar_close_mobile(scope : SidebarScope) -> @cmd.Cmd {
  scope.close_mobile
}

///|
/// Render either the desktop sidebar or its explicit mobile sheet form.
/// `mobile=true` is intentional: inline styles have no hidden stylesheet or
/// breakpoint registration, so applications choose when to switch forms.
pub fn[C : @html.IsChildren] sidebar(
  scope : SidebarScope,
  side? : SidebarSide = SidebarLeft,
  variant? : SidebarVariant = SidebarDefault,
  collapsible? : SidebarCollapsible = SidebarOffcanvas,
  mobile? : Bool = false,
  aria_label? : String = "Sidebar",
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool = false,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  overlay_attrs? : @html.Attrs,
  overlay_style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let collapsed = if mobile || collapsible == SidebarFixed {
    false
  } else {
    scope.collapsed
  }
  let is_hidden = hidden
  let mobile_open = scope.mobile_open && !is_hidden
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "sidebar")
    .data_set("side", sidebar_side_value(side))
    .data_set("variant", sidebar_variant_value(variant))
    .data_set("collapsible", sidebar_collapsible_value(collapsible))
    .data_set("state", sidebar_state_value(collapsed))
    .data_set("mobile", ui_bool(mobile))
    .data_set("mobile-state", if mobile_open { "open" } else { "closed" })
    .aria_label(aria_label)
  if mobile {
    ignore(
      element_attrs
      .role("dialog")
      .aria_modal("true")
      .aria_hidden(ui_bool(!mobile_open))
      .inert(!mobile_open)
      .autofocus(mobile_open)
      .tabindex(-1),
    )
    sidebar_bind_mobile_dismiss(element_attrs, scope.close_mobile)
    sidebar_bind_mobile_focus(element_attrs, mobile_open)
  }
  let surface = @html.aside(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        SidebarBaseStyle,
        if mobile {
          SidebarMobileStyle
        } else {
          ""
        },
        if mobile {
          sidebar_mobile_side_style(side)
        } else {
          ""
        },
        if mobile {
          sidebar_mobile_state_style(side, mobile_open)
        } else {
          ""
        },
        sidebar_side_style(side),
        if mobile {
          ""
        } else {
          sidebar_variant_style(variant, side)
        },
        if mobile {
          ""
        } else {
          sidebar_width_style(collapsed, collapsible)
        },
        sidebar_descendant_state_style(collapsed, collapsible, mobile),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    hidden=is_hidden,
    attrs=element_attrs,
    children,
  )
  if mobile {
    let backdrop_attrs = ui_attrs(overlay_attrs)
      .data_set("slot", "sidebar-overlay")
      .data_set("state", if mobile_open { "open" } else { "closed" })
      .aria_hidden("true")
    ignore(backdrop_attrs.on_click_after(_ => scope.close_mobile))
    @html.fragment([
      @html.div(
        style=ui_styles(
          [
            UiBoxSizing,
            SidebarOverlayStyle,
            if mobile_open {
              SidebarOverlayOpenStyle
            } else {
              SidebarOverlayClosedStyle
            },
          ],
          overlay_style,
        ),
        attrs=backdrop_attrs,
        @html.nothing,
      ),
      surface,
    ])
  } else {
    surface
  }
}

///|
pub fn[C : @html.IsChildren] sidebar_trigger(
  scope : SidebarScope,
  mobile? : Bool = false,
  controls? : String,
  disabled? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String = "Toggle sidebar",
  on_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let expanded = if mobile { scope.mobile_open } else { !scope.collapsed }
  let trigger_attrs = ui_attrs(attrs)
    .data_set("slot", "sidebar-trigger")
    .data_set("state", if expanded { "open" } else { "closed" })
    .aria_expanded(ui_bool(expanded))
  if controls is Some(value) {
    ignore(trigger_attrs.aria_controls(value))
  }
  sidebar_bind_restore_trigger(
    trigger_attrs,
    mobile && !scope.mobile_open && !disabled,
  )
  dialog_control_button(
    slot="sidebar-trigger",
    command=if mobile { scope.toggle_mobile } else { scope.toggle_collapsed },
    variant=Ghost,
    size=IconSm,
    disabled~,
    id~,
    class~,
    title~,
    aria_label=Some(aria_label),
    on_click~,
    attrs=Some(trigger_attrs),
    style~,
    children,
  )
}

///|
#cfg(target="js")
fn sidebar_bind_resize_attrs(
  attrs : @html.Attrs,
  scope : SidebarScope,
  min_width : Int,
  max_width : Int,
) -> Unit {
  ignore(
    attrs
    .on_pointerdown_after(event => {
      ignore(ffi_sidebar_pointer_start(event, min_width, max_width))
      @cmd.none
    })
    .on_pointermove_after(event => {
      if ffi_sidebar_pointer_move(event) {
        event.prevent_default()
      }
      @cmd.none
    })
    .on_pointerup_after(event => {
      let width = ffi_sidebar_pointer_end(event)
      if width > 0 {
        event.prevent_default()
        (scope.commit_width)(width)
      } else {
        @cmd.none
      }
    })
    .on_pointercancel_after(event => {
      ffi_sidebar_pointer_cancel(event)
      @cmd.none
    }),
  )
}

///|
#cfg(not(target="js"))
fn sidebar_bind_resize_attrs(
  attrs : @html.Attrs,
  scope : SidebarScope,
  min_width : Int,
  max_width : Int,
) -> Unit {
  ignore((attrs, scope, min_width, max_width))
}

///|
pub fn sidebar_rail(
  scope : SidebarScope,
  side? : SidebarSide = SidebarLeft,
  min_width? : Int = 160,
  max_width? : Int = 512,
  id? : String,
  class? : String,
  title? : String = "Toggle sidebar",
  aria_label? : String = "Toggle sidebar",
  on_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let (edge, line_edge) = match side {
    SidebarLeft => ("right:0", "right:0")
    SidebarRight => ("left:0", "left:0")
  }
  let rail_attrs = ui_attrs(attrs)
    .data_set("slot", "sidebar-rail")
    .data_set("side", sidebar_side_value(side))
    .data_set("min-width", "\{min_width}")
    .data_set("max-width", "\{max_width}")
    .aria_expanded(ui_bool(!scope.collapsed))
    .tabindex(-1)
  sidebar_bind_resize_attrs(rail_attrs, scope, min_width, max_width)
  dialog_control_button(
    slot="sidebar-rail",
    command=scope.toggle_collapsed,
    variant=Ghost,
    size=IconXs,
    disabled=false,
    id~,
    class~,
    title=Some(title),
    aria_label=Some(aria_label),
    on_click~,
    attrs=Some(rail_attrs),
    style=ui_styles([SidebarRailStyle, edge], style),
    @html.span(
      attrs=@html.Attrs::build()
        .data_set("slot", "sidebar-rail-line")
        .aria_hidden("true"),
      style=[SidebarRailLineStyle, line_edge],
      @html.nothing,
    ),
  )
}

///|
pub fn[C : @html.IsChildren] sidebar_header(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, SidebarHeaderFooterStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "sidebar-header"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] sidebar_footer(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, SidebarHeaderFooterStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "sidebar-footer"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] sidebar_content(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, SidebarContentStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "sidebar-content"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] sidebar_group(
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs).data_set("slot", "sidebar-group")
  if aria_label is Some(label) {
    ignore(element_attrs.role("group").aria_label(label))
  }
  @html.div(
    style=ui_styles([UiBoxSizing, SidebarGroupStyle], style),
    id?,
    class?,
    title?,
    attrs=element_attrs,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] sidebar_group_label(
  scope? : SidebarScope,
  hide_when_collapsed? : Bool = true,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  // The owning sidebar knows whether its collapse mode actually hides labels.
  // Rely on that inherited custom property so SidebarFixed never hides a label
  // merely because the provider also drives a different collapsed sidebar.
  ignore(scope)
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        SidebarGroupLabelStyle,
        if hide_when_collapsed {
          ""
        } else {
          "--rui-sidebar-group-label-display:flex"
        },
      ],
      style,
    ),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "sidebar-group-label")
      .data_set("state", if hide_when_collapsed { "auto" } else { "visible" }),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] sidebar_group_action(
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
    slot="sidebar-group-action",
    command=@cmd.none,
    variant=Ghost,
    size=IconXs,
    disabled~,
    id~,
    class~,
    title~,
    aria_label~,
    on_click~,
    attrs~,
    style=ui_styles([SidebarGroupActionStyle, SidebarActionSurfaceStyle], style),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] sidebar_group_content(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, SidebarGroupContentStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "sidebar-group-content"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] sidebar_menu(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.ul(
    style=ui_styles([UiBoxSizing, SidebarMenuStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "sidebar-menu"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] sidebar_menu_item(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.li(
    style=ui_styles([UiBoxSizing, SidebarMenuItemStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "sidebar-menu-item"),
    children,
  )
}

///|
/// Render a native button, or a native anchor when `href` is supplied.
pub fn[C : @html.IsChildren] sidebar_menu_button(
  href? : String,
  is_active? : Bool = false,
  size? : SidebarMenuButtonSize = SidebarMenuDefault,
  disabled? : Bool = false,
  aria_label? : String,
  target? : @html.Target = Self,
  rel? : String,
  download? : String,
  on_click? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "sidebar-menu-button")
    .data_set("size", sidebar_menu_size_value(size))
    .data_set("active", ui_bool(is_active))
    .data_set("state", if is_active { "active" } else { "inactive" })
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  }
  if is_active {
    ignore(element_attrs.aria_current("page"))
  }
  if disabled {
    ignore(
      element_attrs.aria_disabled("true").data_set("disabled", "").tabindex(-1),
    )
  } else if on_click is Some(command) {
    ignore(element_attrs.on_click_after(_ => command))
  }
  sidebar_bind_disabled_link(element_attrs, disabled && href is Some(_))
  let styles = ui_styles(
    [
      UiBoxSizing,
      UiFontSans,
      UiTextRendering,
      UiTransition,
      SidebarMenuButtonStyle,
      sidebar_menu_size_style(size),
      if is_active {
        SidebarMenuButtonActiveStyle
      } else {
        ""
      },
      ui_disabled_style(disabled),
    ],
    style,
  )
  match href {
    Some(href) =>
      @html.a(
        style=styles,
        id?,
        class?,
        title?,
        href~,
        target~,
        rel?,
        download?,
        attrs=element_attrs,
        children,
      )
    None =>
      @html.button(
        style=styles,
        id?,
        class?,
        title?,
        type_="button",
        disabled~,
        attrs=element_attrs,
        children,
      )
  }
}

///|
pub fn[C : @html.IsChildren] sidebar_menu_action(
  show_on_hover? : Bool = false,
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
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "sidebar-menu-action")
    .data_set("show-on-hover", ui_bool(show_on_hover))
  dialog_control_button(
    slot="sidebar-menu-action",
    command=@cmd.none,
    variant=Ghost,
    size=IconXs,
    disabled~,
    id~,
    class~,
    title~,
    aria_label~,
    on_click~,
    attrs=Some(element_attrs),
    style=ui_styles(
      [
        SidebarMenuActionStyle,
        SidebarActionSurfaceStyle,
        if show_on_hover {
          SidebarMenuActionHoverStyle
        } else {
          ""
        },
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] sidebar_menu_badge(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.span(
    style=ui_styles([UiBoxSizing, SidebarMenuBadgeStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "sidebar-menu-badge"),
    children,
  )
}

///|
pub fn sidebar_menu_skeleton(
  show_icon? : Bool = false,
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
        "display:flex;height:2rem;align-items:center;gap:0.5rem;padding-inline:0.5rem;border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem)",
      ],
      style,
    ),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "sidebar-menu-skeleton")
      .data_set("icon", ui_bool(show_icon))
      .aria_hidden("true"),
    [
      if show_icon {
        @html.span(
          style=[
            UiBoxSizing,
            "width:1rem;height:1rem;flex-shrink:0;border-radius:0.25rem;background:var(--rui-muted-foreground,oklch(0.556 0 0) / 0.18)",
          ],
          @html.nothing,
        )
      } else {
        @html.nothing
      },
      @html.span(
        style=[
          UiBoxSizing,
          "height:0.75rem;width:70%;border-radius:0.25rem;background:var(--rui-muted-foreground,oklch(0.556 0 0) / 0.18)",
        ],
        @html.nothing,
      ),
    ],
  )
}

///|
pub fn[C : @html.IsChildren] sidebar_menu_sub(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.ul(
    style=ui_styles([UiBoxSizing, SidebarMenuSubStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "sidebar-menu-sub"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] sidebar_menu_sub_item(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.li(
    style=ui_styles([UiBoxSizing, SidebarMenuItemStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "sidebar-menu-sub-item"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] sidebar_menu_sub_button(
  href? : String,
  is_active? : Bool = false,
  disabled? : Bool = false,
  aria_label? : String,
  target? : @html.Target = Self,
  rel? : String,
  download? : String,
  on_click? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "sidebar-menu-sub-button")
    .data_set("active", ui_bool(is_active))
    .data_set("state", if is_active { "active" } else { "inactive" })
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  }
  if is_active {
    ignore(element_attrs.aria_current("page"))
  }
  if disabled {
    ignore(
      element_attrs.aria_disabled("true").data_set("disabled", "").tabindex(-1),
    )
  } else if on_click is Some(command) {
    ignore(element_attrs.on_click_after(_ => command))
  }
  sidebar_bind_disabled_link(element_attrs, disabled && href is Some(_))
  let styles = ui_styles(
    [
      UiBoxSizing,
      UiFontSans,
      UiTransition,
      SidebarMenuSubButtonStyle,
      if is_active {
        SidebarMenuButtonActiveStyle
      } else {
        ""
      },
      ui_disabled_style(disabled),
    ],
    style,
  )
  match href {
    Some(href) =>
      @html.a(
        style=styles,
        id?,
        class?,
        title?,
        href~,
        target~,
        rel?,
        download?,
        attrs=element_attrs,
        children,
      )
    None =>
      @html.button(
        style=styles,
        id?,
        class?,
        title?,
        type_="button",
        disabled~,
        attrs=element_attrs,
        children,
      )
  }
}

///|
pub fn sidebar_separator(
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
        "width:auto;height:1px;flex-shrink:0;margin-inline:0.5rem;background:var(--rui-border,oklch(0.922 0 0))",
      ],
      style,
    ),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "sidebar-separator")
      .role("separator")
      .aria_orientation("horizontal"),
    @html.nothing,
  )
}

///|
pub fn sidebar_input(
  name? : String,
  value? : String,
  placeholder? : String,
  auto_complete? : @html.AutoComplete,
  id? : String,
  class? : String,
  title? : String,
  disabled? : Bool = false,
  aria_label? : String,
  on_change? : @cmd.Emit[String],
  on_input? : @cmd.Emit[String],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = ui_attrs(attrs).data_set("slot", "sidebar-input")
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  }
  if disabled {
    ignore(element_attrs.disabled(true).data_set("disabled", ""))
  }
  @html.input(
    input_type=@html.Text,
    name?,
    value?,
    placeholder?,
    auto_complete?,
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        InputBaseStyle,
        "height:2rem;background:var(--rui-background,oklch(1 0 0))",
        "display:var(--rui-sidebar-input-display,block)",
        ui_disabled_style(disabled),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    on_change?,
    on_input?,
    attrs=element_attrs,
  )
}

///|
pub fn[C : @html.IsChildren] sidebar_inset(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, SidebarInsetStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "sidebar-inset").role("main"),
    children,
  )
}
