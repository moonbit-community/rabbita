///|
struct MenuCoreModel {
  open : Bool
  active : Int
  checked : Array[String]
  radios : Array[(String, String)]
  submenus : Array[String]
} derive(Eq)

///|
enum MenuSubmenuChange {
  MenuOpenSubmenu(String)
  MenuSwitchSubmenu(String, String)
  MenuCloseSubmenu(String)
  MenuCloseSubmenusUnder(String)
  MenuCloseAllSubmenus
} derive(Eq)

///|
struct MenuScope {
  id : String
  content_id : String
  trigger_id : String
  model : MenuCoreModel
  counter : Ref[Int]
  open_command : @cmd.Cmd
  close_command : @cmd.Cmd
  toggle_command : @cmd.Cmd
  set_active : @cmd.Emit[Int]
  toggle_checked : @cmd.Emit[String]
  set_radio : @cmd.Emit[(String, String)]
  set_submenu : @cmd.Emit[MenuSubmenuChange]
}

///|
enum MenuIndicatorPlacement {
  MenuIndicatorInlineStart
  MenuIndicatorInlineEnd
} derive(Eq)

///|
const MenuRootStyle : String = "display:contents"

///|
const MenuContentStyle : String = "position:fixed;inset:auto;left:var(--rui-floating-left,auto);top:var(--rui-floating-top,auto);z-index:50;display:flex;min-width:8rem;max-width:calc(100vw - 1rem);max-height:var(--rui-menu-available-height,calc(100vh - 1rem));transform-origin:var(--rui-floating-transform-origin,center);flex-direction:column;gap:0.125rem;overflow-x:hidden;overflow-y:auto;margin:0;border:1px solid color-mix(in oklab,var(--rui-foreground,oklch(0.145 0 0)) 10%,transparent);border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-popover,oklch(1 0 0));padding:0.25rem;color:var(--rui-popover-foreground,oklch(0.145 0 0));font-size:0.875rem;line-height:1.25rem;box-shadow:0 10px 15px -3px rgb(0 0 0 / 0.1),0 4px 6px -4px rgb(0 0 0 / 0.1);outline:none;transition:opacity 100ms ease,transform 100ms ease,visibility 100ms ease"

///|
const MenuSubContentStyle : String = "position:fixed;inset:auto;left:var(--rui-submenu-left,auto);top:var(--rui-submenu-top,auto);z-index:51;display:flex;min-width:8rem;max-width:min(18rem,calc(100vw - 1rem));max-height:calc(100vh - 1rem);transform-origin:var(--rui-floating-transform-origin,0% 0%);flex-direction:column;gap:0.125rem;overflow-x:hidden;overflow-y:auto;border:1px solid color-mix(in oklab,var(--rui-foreground,oklch(0.145 0 0)) 10%,transparent);border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-popover,oklch(1 0 0));padding:0.25rem;color:var(--rui-popover-foreground,oklch(0.145 0 0));box-shadow:0 10px 15px -3px rgb(0 0 0 / 0.1),0 4px 6px -4px rgb(0 0 0 / 0.1);outline:none;transition:opacity 100ms ease,transform 100ms ease,visibility 100ms ease"

///|
const MenuItemStyle : String = "position:relative;display:flex;width:100%;min-height:2rem;cursor:default;align-items:center;gap:0.5rem;border:0;border-radius:calc(var(--rui-radius,0.625rem) - 0.25rem);background:var(--rui-menu-item-bg,var(--rui-menu-item-base-bg,transparent));padding:0.375rem 0.5rem;color:var(--rui-menu-item-fg,var(--rui-menu-item-base-fg,inherit));font:inherit;line-height:1.25rem;text-align:start;white-space:nowrap;outline:none;user-select:none"

///|
const MenuItemInsetStyle : String = "padding-inline-start:2rem"

///|
const MenuItemDestructiveStyle : String = "--rui-menu-item-base-fg:var(--rui-destructive,oklch(0.577 0.245 27.325))"

///|
const MenuItemHighlightedStyle : String = "--rui-menu-item-base-bg:var(--rui-accent,oklch(0.97 0 0));--rui-menu-item-base-fg:var(--rui-accent-foreground,oklch(0.205 0 0))"

///|
const MenuLabelStyle : String = "padding:0.375rem 0.5rem;font-size:0.75rem;line-height:1rem;font-weight:500;color:var(--rui-muted-foreground,oklch(0.556 0 0))"

///|
const MenuSeparatorStyle : String = "height:1px;margin:0.25rem -0.25rem;background:var(--rui-border,oklch(0.922 0 0));pointer-events:none"

///|
const MenuShortcutStyle : String = "margin-inline-start:auto;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.75rem;line-height:1rem;letter-spacing:0.08em"

///|
const MenuItemEndIndicatorStyle : String = "padding-inline-start:0.5rem;padding-inline-end:2rem"

///|
const MenuIndicatorStartStyle : String = "display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;font-size:0.75rem;line-height:1"

///|
const MenuIndicatorEndStyle : String = "position:absolute;inset-inline-end:0.5rem;display:inline-flex;width:1rem;height:1rem;align-items:center;justify-content:center;font-size:0.75rem;line-height:1;pointer-events:none"

///|
fn menu_core_model(
  open : Bool,
  checked : Array[String],
  radios : Array[(String, String)],
) -> MenuCoreModel {
  { open, active: -1, checked, radios, submenus: [] }
}

///|
fn menu_contains(values : Array[String], value : String) -> Bool {
  for current in values {
    if current == value {
      return true
    }
  }
  false
}

///|
fn menu_toggle_value(values : Array[String], value : String) -> Array[String] {
  let next : Array[String] = []
  let mut found = false
  for current in values {
    if current == value {
      found = true
    } else {
      next.push(current)
    }
  }
  if !found {
    next.push(value)
  }
  next
}

///|
fn menu_submenu_open(values : Array[String], value : String) -> Bool {
  menu_contains(values, value)
}

///|
fn menu_update_submenus(
  values : Array[String],
  change : MenuSubmenuChange,
) -> Array[String] {
  match change {
    MenuOpenSubmenu(value) =>
      if menu_contains(values, value) {
        values
      } else {
        let next = values.copy()
        next.push(value)
        next
      }
    MenuSwitchSubmenu(parent, value) =>
      if parent == "" {
        if values == [value] {
          values
        } else {
          [value]
        }
      } else {
        let next : Array[String] = []
        for current in values {
          next.push(current)
          if current == parent {
            next.push(value)
            return if next == values { values } else { next }
          }
        }
        values
      }
    MenuCloseSubmenu(value) => {
      let next : Array[String] = []
      for current in values {
        if current == value {
          return next
        }
        next.push(current)
      }
      values
    }
    MenuCloseSubmenusUnder(parent) =>
      if parent == "" {
        []
      } else {
        let next : Array[String] = []
        for current in values {
          next.push(current)
          if current == parent {
            return if next == values { values } else { next }
          }
        }
        values
      }
    MenuCloseAllSubmenus => []
  }
}

///|
fn menu_submenu_key(scope : MenuScope, value : String) -> String {
  scope.id + "::" + value + "::submenu-\{scope.counter.val}"
}

///|
fn menu_submenu_anchor_style(key : String) -> String {
  "position-anchor:\{popup_anchor_name(key)};position-area:inline-end span-y-end;position-try-fallbacks:flip-inline,flip-block,flip-inline flip-block;position-visibility:always;margin-inline-start:0.25rem;--rui-floating-transform-origin:0% 0%"
}

///|
fn menu_submenu_trigger_id(key : String) -> String {
  popup_anchor_name(key) + "-trigger"
}

///|
fn menu_submenu_content_id(key : String) -> String {
  popup_anchor_name(key) + "-content"
}

///|
fn menu_radio_value(
  radios : Array[(String, String)],
  group : String,
) -> String? {
  for entry in radios {
    if entry.0 == group {
      return Some(entry.1)
    }
  }
  None
}

///|
fn menu_set_radio_value(
  radios : Array[(String, String)],
  group : String,
  value : String,
) -> Array[(String, String)] {
  let next : Array[(String, String)] = []
  let mut replaced = false
  for entry in radios {
    if entry.0 == group {
      if !replaced {
        next.push((group, value))
        replaced = true
      }
    } else {
      next.push(entry)
    }
  }
  if !replaced {
    next.push((group, value))
  }
  next
}

///|
fn menu_scope_next_index(scope : MenuScope) -> Int {
  let index = scope.counter.val
  scope.counter.val += 1
  index
}

///|
fn[A] menu_noop_emit() -> @cmd.Emit[A] {
  @cmd.Emit(_ => @cmd.none)
}

///|
fn menu_state_attrs(
  attrs : @html.Attrs?,
  slot : String,
  open : Bool,
) -> @html.Attrs {
  popup_state_attrs(attrs, slot, open)
}

///|
#cfg(target="js")
extern "js" fn ffi_bind_menu_surface(
  id : String,
  dispatch : (Int, Int, String, String) -> Unit,
) -> Unit =
  #| (id, dispatch) => {
  #|   const root = document.getElementById(id)
  #|   if (!root) return
  #|   root.__ruiMenuDispatch = dispatch
  #|   const pendingEdges = globalThis.__ruiMenuPendingEdges ||= new Map()
  #|   if (root.__ruiMenuBound) return
  #|   root.__ruiMenuBound = true
  #|   const isVisible = item => {
  #|     if (!item || item.disabled || item.getAttribute("aria-disabled") === "true") return false
  #|     if (item.hidden || item.closest?.("[inert]") || item.closest?.('[aria-hidden="true"]')) return false
  #|     if (item.getClientRects().length === 0) return false
  #|     const style = getComputedStyle(item)
  #|     return style.display !== "none" && style.visibility !== "hidden"
  #|   }
  #|   const enabledItems = container => Array.from(
  #|     (container || root).querySelectorAll("[data-menu-index]")
  #|   ).filter(item => {
  #|     if (!isVisible(item)) return false
  #|     return !container || item.closest('[role="menu"]') === container
  #|   })
  #|   const sendActive = item => {
  #|     if (!item || item.disabled) return
  #|     const index = Number(item.dataset.menuIndex)
  #|     if (Number.isInteger(index) && root.__ruiMenuDispatch) {
  #|       root.__ruiMenuDispatch(0, index, "", "")
  #|     }
  #|   }
  #|   const focusSubmenuTrigger = key => {
  #|     requestAnimationFrame(() => {
  #|       const target = Array.from(root.querySelectorAll("[data-menu-index][data-submenu-key]"))
  #|         .find(node => node.dataset.submenuKey === key && isVisible(node))
  #|       if (target) {
  #|         target.focus()
  #|         sendActive(target)
  #|       }
  #|     })
  #|   }
  #|   const focusDropdownEdge = (contentId, edge, attempt = 0) => {
  #|     requestAnimationFrame(() => {
  #|       const liveRoot = document.getElementById(id)
  #|       const content = document.getElementById(contentId)
  #|       const items = enabledItems(content)
  #|       if (!liveRoot) return
  #|       if (liveRoot.dataset.state !== "open" || !items.length) {
  #|         if (attempt < 20) focusDropdownEdge(contentId, edge, attempt + 1)
  #|         return
  #|       }
  #|       const requestedEdge = pendingEdges.get(id) || edge
  #|       const target = requestedEdge === "last" ? items[items.length - 1] : items[0]
  #|       if (!target) return
  #|       const index = Number(target.dataset.menuIndex)
  #|       target.focus()
  #|       if (Number.isInteger(index)) liveRoot.__ruiMenuDispatch?.(0, index, "", "")
  #|       // The generic focus command may still be waiting for showPopover().
  #|       // Keep the requested edge briefly so that command cannot overwrite ArrowUp.
  #|       setTimeout(() => {
  #|         if (pendingEdges.get(id) === edge) pendingEdges.delete(id)
  #|       }, 250)
  #|     })
  #|   }
  #|   root.addEventListener("focusin", event => {
  #|     sendActive(event.target.closest?.("[data-menu-index]"))
  #|   })
  #|   const submenuParent = item =>
  #|     item?.closest?.('[role="menu"]')?.dataset?.submenuOwner || ""
  #|   const focusSubmenuFirst = (key, attempt = 0) => {
  #|     requestAnimationFrame(() => {
  #|       const owner = Array.from(root.querySelectorAll("[data-submenu-owner]"))
  #|         .find(node => node.dataset.submenuOwner === key && isVisible(node))
  #|       if (!owner) {
  #|         if (attempt < 20) focusSubmenuFirst(key, attempt + 1)
  #|         return
  #|       }
  #|       const target = enabledItems(owner)[0]
  #|       if (target) {
  #|         target.focus()
  #|         sendActive(target)
  #|       } else if (attempt < 20) {
  #|         focusSubmenuFirst(key, attempt + 1)
  #|       }
  #|     })
  #|   }
  #|   const switchSubmenu = (item, focusFirst = false) => {
  #|     const key = item?.dataset?.submenuKey || ""
  #|     if (!key || item.disabled) return false
  #|     root.__ruiMenuDispatch?.(
  #|       4,
  #|       Number(item.dataset.menuIndex),
  #|       key,
  #|       submenuParent(item),
  #|     )
  #|     if (focusFirst) focusSubmenuFirst(key)
  #|     return true
  #|   }
  #|   root.addEventListener("pointermove", event => {
  #|     const item = event.target.closest?.("[data-menu-index]")
  #|     sendActive(item)
  #|     const submenu = item?.dataset.submenuKey
  #|     if (submenu && !item.disabled && root.__ruiMenuDispatch) {
  #|       switchSubmenu(item)
  #|     } else if (item && root.__ruiMenuDispatch) {
  #|       root.__ruiMenuDispatch(5, Number(item.dataset.menuIndex), "", submenuParent(item))
  #|     }
  #|   })
  #|   root.addEventListener("click", event => {
  #|     const item = event.target.closest?.("[data-menu-index][data-submenu-key]")
  #|     switchSubmenu(item)
  #|   }, true)
  #|   root.addEventListener("keydown", event => {
  #|     if (event.defaultPrevented) return
  #|     const dropdownTrigger = event.target.closest?.('[data-slot="dropdown-menu-trigger"]')
  #|     if (dropdownTrigger && (event.key === "ArrowDown" || event.key === "ArrowUp")) {
  #|       event.preventDefault()
  #|       const edge = event.key === "ArrowUp" ? "last" : "first"
  #|       const contentId = dropdownTrigger.getAttribute("aria-controls") || ""
  #|       pendingEdges.set(id, edge)
  #|       setTimeout(() => {
  #|         if (pendingEdges.get(id) === edge) pendingEdges.delete(id)
  #|       }, 1000)
  #|       if (root.dataset.state !== "open") dropdownTrigger.click()
  #|       focusDropdownEdge(contentId, edge)
  #|       return
  #|     }
  #|     const current = event.target.closest?.("[data-menu-index]")
  #|     const container = current?.closest?.('[role="menu"]') || root
  #|     const items = enabledItems(container)
  #|     const activeSubmenu = event.target.closest?.("[data-submenu-owner]")
  #|     const rtl = typeof getComputedStyle === "function"
  #|       && getComputedStyle(container).direction === "rtl"
  #|     const openSubmenuKey = rtl ? "ArrowLeft" : "ArrowRight"
  #|     const closeSubmenuKey = rtl ? "ArrowRight" : "ArrowLeft"
  #|     if (event.key === "Escape" && activeSubmenu) {
  #|       event.preventDefault()
  #|       event.stopPropagation()
  #|       const key = activeSubmenu.dataset.submenuOwner || ""
  #|       root.__ruiMenuDispatch?.(3, -1, key, "")
  #|       focusSubmenuTrigger(key)
  #|       return
  #|     }
  #|     if (event.key === "Escape") {
  #|       event.preventDefault()
  #|       root.__ruiMenuDispatch?.(1, -1, "", "")
  #|       return
  #|     }
  #|     if (!items.length) return
  #|     const position = items.indexOf(current)
  #|     let target = null
  #|     if (event.key === "ArrowDown") target = position < 0 ? items[0] : items[(position + 1) % items.length]
  #|     if (event.key === "ArrowUp") target = position < 0 ? items[items.length - 1] : items[(position - 1 + items.length) % items.length]
  #|     if (event.key === "Home") target = items[0]
  #|     if (event.key === "End") target = items[items.length - 1]
  #|     if (
  #|       (event.key === openSubmenuKey || event.key === "Enter" || event.key === " ")
  #|       && current?.dataset.submenuKey
  #|     ) {
  #|       event.preventDefault()
  #|       switchSubmenu(current, true)
  #|       return
  #|     }
  #|     if (event.key === closeSubmenuKey) {
  #|       const sub = activeSubmenu
  #|       if (sub) {
  #|         event.preventDefault()
  #|         event.stopPropagation()
  #|         const key = sub.dataset.submenuOwner || ""
  #|         root.__ruiMenuDispatch?.(3, -1, key, "")
  #|         focusSubmenuTrigger(key)
  #|         return
  #|       }
  #|     }
  #|     if (!target && event.key.length === 1 && !event.metaKey && !event.ctrlKey && !event.altKey) {
  #|       if (event.key === " " && !root.__ruiMenuTypeahead) return
  #|       const now = Date.now()
  #|       if (!root.__ruiMenuTypeaheadAt || now - root.__ruiMenuTypeaheadAt > 1000) {
  #|         root.__ruiMenuTypeahead = ""
  #|       }
  #|       root.__ruiMenuTypeaheadAt = now
  #|       root.__ruiMenuTypeahead = (root.__ruiMenuTypeahead || "") + event.key.toLocaleLowerCase()
  #|       clearTimeout(root.__ruiMenuTypeaheadTimer)
  #|       root.__ruiMenuTypeaheadTimer = setTimeout(() => {
  #|         root.__ruiMenuTypeahead = ""
  #|         root.__ruiMenuTypeaheadAt = 0
  #|       }, 1000)
  #|       const buffer = root.__ruiMenuTypeahead
  #|       const query = Array.from(buffer).every(char => char === buffer[0]) ? buffer[0] : buffer
  #|       const ordered = position < 0
  #|         ? items
  #|         : items.slice(position + 1).concat(items.slice(0, position + 1))
  #|       target = ordered.find(item => {
  #|         const label = item.dataset.menuLabel || item.textContent || ""
  #|         return label.trim().toLocaleLowerCase().startsWith(query)
  #|       }) || null
  #|       event.preventDefault()
  #|     }
  #|     if (target) {
  #|       event.preventDefault()
  #|       target.focus()
  #|       sendActive(target)
  #|     }
  #|   })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_focus_menu_item(
  id : String,
  content_id : String,
  index : Int,
) -> Bool =
  #| (id, contentId, index) => {
  #|   const stability = globalThis.__ruiMenuFocusStability ||= new Map()
  #|   const key = `${id}:${contentId}:${index}`
  #|   const root = document.getElementById(id)
  #|   if (!root) {
  #|     stability.delete(key)
  #|     return false
  #|   }
  #|   const isVisible = node => {
  #|     if (!node || node.disabled || node.getAttribute("aria-disabled") === "true") return false
  #|     if (node.hidden || node.closest?.("[inert]") || node.getClientRects().length === 0) return false
  #|     const style = getComputedStyle(node)
  #|     return style.display !== "none" && style.visibility !== "hidden"
  #|   }
  #|   const resolveItem = () => {
  #|     const liveRoot = document.getElementById(id)
  #|     const content = contentId ? document.getElementById(contentId) : null
  #|     if (!liveRoot || (contentId && !content)) return null
  #|     const scope = content || liveRoot
  #|     const candidates = Array.from(scope.querySelectorAll(`[data-menu-index="${index}"]`))
  #|       .filter(isVisible)
  #|     if (content) {
  #|       return candidates.find(node => {
  #|         const owner = node.closest('[role="menu"]')
  #|         // `content` is the top-level boundary; descendant menus belong to
  #|         // that same menubar entry, while sibling contents stay excluded.
  #|         return owner === content || (owner && content.contains(owner))
  #|       }) || null
  #|     }
  #|     return candidates.find(node => node.closest('[role="menu"]')?.dataset.state === "open")
  #|       || candidates[0]
  #|       || null
  #|   }
  #|   const item = resolveItem()
  #|   if (!item || item.isConnected === false) {
  #|     stability.delete(key)
  #|     return false
  #|   }
  #|   if (document.activeElement !== item) item.focus({ preventScroll: true })
  #|   // focusin may synchronously enqueue a state patch that replaces `item`
  #|   // after focus() succeeds. Re-resolve the live node and require the same
  #|   // connected target to retain focus across multiple animation frames.
  #|   const liveItem = resolveItem()
  #|   if (liveItem !== item || item.isConnected === false || document.activeElement !== item) {
  #|     stability.set(key, { item: liveItem || null, frames: 0 })
  #|     return false
  #|   }
  #|   const previous = stability.get(key)
  #|   const frames = previous?.item === item ? previous.frames + 1 : 1
  #|   if (frames < 3) {
  #|     stability.set(key, { item, frames })
  #|     return false
  #|   }
  #|   stability.delete(key)
  #|   return true
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_focus_first_menu_item(
  id : String,
  found : (Int) -> Unit,
) -> Unit =
  #| (id, found) => {
  #|   const pendingEdges = globalThis.__ruiMenuPendingEdges ||= new Map()
  #|   const isVisible = node => {
  #|     if (!node || node.disabled || node.getAttribute("aria-disabled") === "true") return false
  #|     if (node.hidden || node.closest?.("[inert]") || node.getClientRects().length === 0) return false
  #|     const style = getComputedStyle(node)
  #|     return style.display !== "none" && style.visibility !== "hidden"
  #|   }
  #|   const focusWhenVisible = (attempt = 0) => {
  #|     const root = document.getElementById(id)
  #|     if (!root) return
  #|     const items = Array.from(root.querySelectorAll("[data-menu-index]")).filter(isVisible)
  #|     if (root.dataset.state === "open" && items.length) {
  #|       const item = pendingEdges.get(id) === "last"
  #|         ? items[items.length - 1]
  #|         : items[0]
  #|       pendingEdges.delete(id)
  #|       const index = Number(item.dataset.menuIndex)
  #|       item.focus()
  #|       if (Number.isInteger(index)) found(index)
  #|       return
  #|     }
  #|     // showPopover() and focus commands share an AfterRender batch. The
  #|     // popover may not be in the top layer during the first visibility query.
  #|     if (attempt < 20) requestAnimationFrame(() => focusWhenVisible(attempt + 1))
  #|   }
  #|   focusWhenVisible()
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_find_open_menu_content(
  id : String,
  slot : String,
  found : (String, Int) -> Unit,
) -> Unit =
  #| (id, slot, found) => {
  #|   const root = document.getElementById(id)
  #|   const content = Array.from(root?.querySelectorAll("[data-slot]") || [])
  #|     .find(node => node.dataset.slot === slot && node.dataset.state === "open")
  #|   if (!content?.id) return
  #|   const index = Number(
  #|     content.dataset.menubarIndex ?? content.dataset.navigationIndex ?? -1
  #|   )
  #|   found(content.id, Number.isInteger(index) ? index : -1)
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_position_menu_submenus(id : String) -> Unit =
  #| id => {
  #|   if (typeof document === "undefined") return
  #|   const resolveRoot = () => document.getElementById(id)
  #|   const position = () => {
  #|     const root = resolveRoot()
  #|     if (!root || root.isConnected === false) return
  #|     const contents = Array.from(root.querySelectorAll("[data-submenu-owner]"))
  #|     const positionArea = "inline-end span-y-end"
  #|     const cssAnchored = typeof CSS !== "undefined"
  #|       && typeof CSS.supports === "function"
  #|       && CSS.supports("anchor-name", "--rui-anchor")
  #|       && CSS.supports("position-anchor", "--rui-anchor")
  #|       && CSS.supports("position-area", positionArea)
  #|       && CSS.supports("position-try-fallbacks", "flip-inline")
  #|     for (const content of contents) {
  #|       const requestedOpen = content.dataset.state === "open"
  #|       let nativeOpen = false
  #|       try { nativeOpen = content.matches(":popover-open") }
  #|       catch (_) { nativeOpen = Boolean(content.__ruiSubmenuOpen) }
  #|       try {
  #|         if (requestedOpen && !nativeOpen && typeof content.showPopover === "function") {
  #|           content.showPopover()
  #|           nativeOpen = true
  #|         } else if (!requestedOpen && nativeOpen && typeof content.hidePopover === "function") {
  #|           content.hidePopover()
  #|           nativeOpen = false
  #|         }
  #|       } catch (_) {
  #|       }
  #|       content.__ruiSubmenuOpen = requestedOpen && nativeOpen
  #|       if (!requestedOpen) {
  #|         content.dataset.positioned = "false"
  #|         continue
  #|       }
  #|       const key = content.dataset.submenuOwner || ""
  #|       const trigger = Array.from(
  #|         root.querySelectorAll("[data-menu-index][data-submenu-key]")
  #|       )
  #|         .find(item => item.dataset.submenuKey === key)
  #|       if (!trigger || trigger.isConnected === false) continue
  #|       if (cssAnchored) {
  #|         content.style.removeProperty("--rui-submenu-left")
  #|         content.style.removeProperty("--rui-submenu-top")
  #|         content.style.removeProperty("margin")
  #|         content.dataset.positioning = "css-anchor"
  #|         content.dataset.positioned = "true"
  #|         continue
  #|       }
  #|       const anchor = trigger.getBoundingClientRect()
  #|       const measured = content.getBoundingClientRect()
  #|       const floating = {
  #|         width: content.offsetWidth || measured.width,
  #|         height: content.offsetHeight || measured.height,
  #|       }
  #|       const viewport = typeof window !== "undefined" ? window.visualViewport : null
  #|       const viewportLeft = viewport?.offsetLeft || 0
  #|       const viewportTop = viewport?.offsetTop || 0
  #|       const width = viewport?.width || document.documentElement.clientWidth
  #|       const height = viewport?.height || document.documentElement.clientHeight
  #|       const clipLeft = viewportLeft + 8
  #|       const clipTop = viewportTop + 8
  #|       const clipRight = viewportLeft + width - 8
  #|       const clipBottom = viewportTop + height - 8
  #|       const rtl = typeof getComputedStyle === "function"
  #|         && getComputedStyle(trigger).direction === "rtl"
  #|       const inlineEnd = rtl
  #|         ? { side: "left", left: anchor.left - floating.width - 4 }
  #|         : { side: "right", left: anchor.right + 4 }
  #|       const inlineStart = rtl
  #|         ? { side: "right", left: anchor.right + 4 }
  #|         : { side: "left", left: anchor.left - floating.width - 4 }
  #|       const overflow = candidate => Math.max(clipLeft - candidate.left, 0)
  #|         + Math.max(candidate.left + floating.width - clipRight, 0)
  #|       const endOverflow = overflow(inlineEnd)
  #|       const startOverflow = overflow(inlineStart)
  #|       const placed = endOverflow <= 0 || endOverflow <= startOverflow
  #|         ? inlineEnd
  #|         : inlineStart
  #|       const left = Math.min(
  #|         Math.max(placed.left, clipLeft),
  #|         Math.max(clipLeft, clipRight - floating.width),
  #|       )
  #|       const top = Math.min(
  #|         Math.max(anchor.top, clipTop),
  #|         Math.max(clipTop, clipBottom - floating.height),
  #|       )
  #|       content.style.setProperty("margin", "0")
  #|       content.style.setProperty("--rui-submenu-left", `${Math.round(left)}px`)
  #|       content.style.setProperty("--rui-submenu-top", `${Math.round(top)}px`)
  #|       content.style.setProperty(
  #|         "--rui-floating-transform-origin",
  #|         placed.side === "right" ? "0% 0%" : "100% 0%",
  #|       )
  #|       content.dataset.side = placed.side
  #|       content.dataset.positioning = "javascript-fallback"
  #|       content.dataset.positioned = "true"
  #|     }
  #|   }
  #|   const registry = globalThis.__ruiMenuSubmenuRoots ||= new Set()
  #|   registry.add(id)
  #|   const root = resolveRoot()
  #|   if (root) root.__ruiPositionSubmenus = position
  #|   if (typeof window !== "undefined" && !window.__ruiMenuSubmenuPositionBound) {
  #|     window.__ruiMenuSubmenuPositionBound = true
  #|     let frame = 0
  #|     const schedule = () => {
  #|       if (frame) return
  #|       const run = () => {
  #|         frame = 0
  #|         for (const rootId of Array.from(registry)) {
  #|           const live = document.getElementById(rootId)
  #|           if (!live || live.isConnected === false) {
  #|             registry.delete(rootId)
  #|             continue
  #|           }
  #|           live.__ruiPositionSubmenus?.()
  #|         }
  #|       }
  #|       if (typeof requestAnimationFrame === "function") frame = requestAnimationFrame(run)
  #|       else run()
  #|     }
  #|     window.addEventListener("scroll", schedule, { capture: true, passive: true })
  #|     window.addEventListener("resize", schedule, { passive: true })
  #|     window.visualViewport?.addEventListener("scroll", schedule, { passive: true })
  #|     window.visualViewport?.addEventListener("resize", schedule, { passive: true })
  #|   }
  #|   position()
  #| }

///|
#cfg(target="js")
fn menu_position_submenus_cmd(id : String) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, _ => ffi_position_menu_submenus(id))
}

///|
#cfg(not(target="js"))
fn menu_position_submenus_cmd(id : String) -> @cmd.Cmd {
  ignore(id)
  @cmd.none
}

///|
#cfg(target="js")
fn menu_bind_surface_cmd(
  id : String,
  set_active : @cmd.Emit[Int],
  close_command : @cmd.Cmd,
  set_submenu : @cmd.Emit[MenuSubmenuChange],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, scheduler => {
    ui_after_mount(
      id,
      () => {
        ffi_bind_menu_surface(id, (kind, index, key, parent) => {
          let command = match kind {
            0 => set_active(index)
            1 => close_command
            2 => set_submenu(MenuOpenSubmenu(key))
            3 => set_submenu(MenuCloseSubmenu(key))
            4 => set_submenu(MenuSwitchSubmenu(parent, key))
            5 => set_submenu(MenuCloseSubmenusUnder(parent))
            _ => set_submenu(MenuCloseAllSubmenus)
          }
          scheduler.add(command)
        })
      },
      purpose="menu-surface-bind",
    )
  })
}

///|
#cfg(not(target="js"))
fn menu_bind_surface_cmd(
  id : String,
  set_active : @cmd.Emit[Int],
  close_command : @cmd.Cmd,
  set_submenu : @cmd.Emit[MenuSubmenuChange],
) -> @cmd.Cmd {
  ignore((id, set_active, close_command, set_submenu))
  @cmd.none
}

///|
#cfg(target="js")
fn menu_focus_item_cmd(
  id : String,
  index : Int,
  content_id? : String = "",
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, _ => {
    ui_after_ready("menu-focus-item:" + id, () => {
      ffi_focus_menu_item(id, content_id, index)
    })
  })
}

///|
#cfg(not(target="js"))
fn menu_focus_item_cmd(
  id : String,
  index : Int,
  content_id? : String = "",
) -> @cmd.Cmd {
  ignore((id, index, content_id))
  @cmd.none
}

///|
#cfg(target="js")
fn menu_focus_first_cmd(id : String, set_active : @cmd.Emit[Int]) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, scheduler => {
    ffi_focus_first_menu_item(id, index => scheduler.add(set_active(index)))
  })
}

///|
#cfg(target="js")
fn menu_open_marked_cmd(
  id : String,
  slot : String,
  set_index : @cmd.Emit[Int],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, scheduler => {
    ui_after_mount(
      id,
      () => {
        ffi_find_open_menu_content(id, slot, (content_id, index) => {
          ignore(ffi_set_floating_open(content_id, true))
          ffi_position_floating(content_id)
          if index >= 0 {
            scheduler.add(set_index(index))
          }
        })
      },
      purpose="menu-open-marked",
    )
  })
}

///|
#cfg(not(target="js"))
fn menu_open_marked_cmd(
  id : String,
  slot : String,
  set_index : @cmd.Emit[Int],
) -> @cmd.Cmd {
  ignore((id, slot, set_index))
  @cmd.none
}

///|
#cfg(not(target="js"))
fn menu_focus_first_cmd(id : String, set_active : @cmd.Emit[Int]) -> @cmd.Cmd {
  ignore((id, set_active))
  @cmd.none
}

///|
fn[C : @html.IsChildren] menu_root_surface(
  slot : String,
  id : String,
  open : Bool,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  @html.span(
    style=ui_styles([UiBoxSizing, MenuRootStyle], style),
    id~,
    attrs=menu_state_attrs(attrs, slot, open),
    children,
  )
}

///|
fn[C : @html.IsChildren] menu_trigger_button(
  slot : String,
  scope : MenuScope,
  variant : ButtonVariant,
  size : ButtonSize,
  disabled : Bool,
  aria_label : String?,
  on_click : @cmd.Cmd?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  let element_attrs = menu_state_attrs(attrs, slot, scope.model.open)
    .aria_haspopup("menu")
    .aria_expanded(ui_bool(scope.model.open))
    .aria_controls(scope.content_id)
    .data_set("variant", button_variant_value(variant))
    .data_set("size", button_size_value(size))
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  }
  if disabled {
    ignore(element_attrs.aria_disabled("true").data_set("disabled", ""))
  } else {
    if on_click is Some(on_click) {
      ignore(element_attrs.on_click_after(_ => on_click))
    }
    ignore(element_attrs.on_click_after(_ => scope.toggle_command))
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
        popup_anchor_style(scope.trigger_id),
      ],
      style,
    ),
    id=scope.trigger_id,
    class?,
    title?,
    type_="button",
    disabled~,
    attrs=element_attrs,
    children,
  )
}

///|
fn[C : @html.IsChildren] menu_content_surface(
  slot : String,
  scope : MenuScope,
  side : PopupSide,
  align : PopupAlign,
  side_offset : Int,
  align_offset : Int,
  aria_label : String?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  let is_context_menu = slot == "context-menu-content"
  let element_attrs = menu_state_attrs(attrs, slot, scope.model.open)
    .popover(if is_context_menu { "manual" } else { "auto" })
    .role("menu")
    .tabindex(-1)
    .aria_orientation("vertical")
    .data_set("trigger-id", scope.trigger_id)
    .data_set("requested-side", popup_side_value(side))
    .data_set("requested-align", popup_align_value(align))
    .data_set("side", popup_side_value(side))
    .data_set("align", popup_align_value(align))
    .data_set("side-offset", "\{side_offset}")
    .data_set("align-offset", "\{align_offset}")
    .data_set("active-index", "\{scope.model.active}")
  if is_context_menu {
    ignore(element_attrs.data_set("light-dismiss", "true"))
  }
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  } else {
    ignore(element_attrs.aria_labelledby(scope.trigger_id))
  }
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        MenuContentStyle,
        PopupTransition100Style,
        if is_context_menu {
          popup_floating_anchor_style(
            context_menu_point_id(scope.trigger_id),
            Bottom,
            Start,
            0,
            0,
          )
        } else {
          popup_floating_anchor_style(
            scope.trigger_id,
            side,
            align,
            side_offset,
            align_offset,
          )
        },
        popup_state_style(scope.model.open),
      ],
      style,
    ),
    id=scope.content_id,
    class?,
    title?,
    attrs=element_attrs,
    children,
  )
}

///|
fn[C : @html.IsChildren] menu_group_surface(
  slot : String,
  aria_label : String?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs).data_set("slot", slot).role("group")
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  }
  @html.div(
    style=ui_styles([UiBoxSizing, "display:flex;flex-direction:column"], style),
    class?,
    title?,
    attrs=element_attrs,
    children,
  )
}

///|
fn[C : @html.IsChildren] menu_label_surface(
  slot : String,
  inset : Bool,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles(
      [UiBoxSizing, MenuLabelStyle, if inset { MenuItemInsetStyle } else { "" }],
      style,
    ),
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", slot),
    children,
  )
}

///|
fn menu_separator_surface(
  slot : String,
  class : String?,
  attrs : @html.Attrs?,
  style : Array[String],
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, MenuSeparatorStyle], style),
    class?,
    attrs=ui_attrs(attrs)
      .data_set("slot", slot)
      .role("separator")
      .aria_orientation("horizontal"),
    @html.nothing,
  )
}

///|
fn[C : @html.IsChildren] menu_shortcut_surface(
  slot : String,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  @html.span(
    style=ui_styles([UiBoxSizing, MenuShortcutStyle], style),
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", slot).aria_hidden("true"),
    children,
  )
}

///|
fn[C : @html.IsChildren] menu_item_surface(
  slot : String,
  scope : MenuScope,
  role : String,
  checked : Bool?,
  indicator_placement : MenuIndicatorPlacement,
  disabled : Bool,
  inset : Bool,
  destructive : Bool,
  submenu_key : String?,
  close_on_select : Bool,
  action : @cmd.Cmd?,
  on_select : @cmd.Cmd?,
  aria_label : String?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  let index = menu_scope_next_index(scope)
  let highlighted = scope.model.active == index
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", slot)
    .data_set("variant", if destructive { "destructive" } else { "default" })
    .data_set("menu-index", "\{index}")
    .data_set("highlighted", ui_bool(highlighted))
    .role(role)
    .tabindex(if highlighted { 0 } else { -1 })
  if highlighted {
    ignore(element_attrs.data_set("active", ""))
  }
  if checked is Some(checked) {
    ignore(
      element_attrs
      .aria_checked(ui_bool(checked))
      .data_set("state", if checked { "checked" } else { "unchecked" }),
    )
  }
  if submenu_key is Some(key) {
    let open = menu_submenu_open(scope.model.submenus, key)
    ignore(
      element_attrs
      .id(menu_submenu_trigger_id(key))
      .data_set("submenu-key", key)
      .data_set("state", if open { "open" } else { "closed" })
      .aria_haspopup("menu")
      .aria_expanded(ui_bool(open))
      .aria_controls(menu_submenu_content_id(key)),
    )
  }
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label).data_set("menu-label", label))
  }
  if disabled {
    ignore(element_attrs.aria_disabled("true").data_set("disabled", ""))
  } else {
    if on_select is Some(on_select) {
      ignore(element_attrs.on_click_after(_ => on_select))
    }
    if action is Some(action) {
      ignore(element_attrs.on_click_after(_ => action))
    }
    if close_on_select {
      ignore(element_attrs.on_click_after(_ => scope.close_command))
    }
  }
  let body = @html.span(
    style=[UiBoxSizing, "display:contents"],
    attrs=@html.Attrs::build().data_set("slot", slot + "-body"),
    children,
  )
  let row = if checked is Some(checked) {
    [
      @html.span(
        style=[
          UiBoxSizing,
          match indicator_placement {
            MenuIndicatorInlineStart => MenuIndicatorStartStyle
            MenuIndicatorInlineEnd => MenuIndicatorEndStyle
          },
        ],
        attrs=@html.Attrs::build()
          .data_set("slot", slot + "-indicator")
          .aria_hidden("true"),
        if checked {
          ui_check_icon()
        } else {
          @html.nothing
        },
      ),
      body,
    ]
  } else if submenu_key is Some(_) {
    [
      body,
      @html.span(
        style=[
          UiBoxSizing,
          "display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;margin-inline-start:auto",
        ],
        attrs=@html.Attrs::build()
          .aria_hidden("true")
          .data_set("icon", "inline-end"),
        ui_chevron_right_icon(),
      ),
    ]
  } else {
    [body]
  }
  @html.button(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        MenuItemStyle,
        if checked is Some(_) && indicator_placement == MenuIndicatorInlineEnd {
          MenuItemEndIndicatorStyle
        } else {
          ""
        },
        if inset {
          MenuItemInsetStyle
        } else {
          ""
        },
        if destructive {
          MenuItemDestructiveStyle
        } else {
          ""
        },
        if highlighted {
          MenuItemHighlightedStyle
        } else {
          ""
        },
        match submenu_key {
          Some(key) => popup_anchor_style(key)
          None => ""
        },
        ui_disabled_style(disabled),
      ],
      style,
    ),
    class?,
    title?,
    type_="button",
    disabled~,
    attrs=element_attrs,
    row,
  )
}

///|
fn[C : @html.IsChildren] menu_sub_root_surface(
  slot : String,
  open : Bool,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, "position:relative;display:contents"], style),
    attrs=menu_state_attrs(attrs, slot, open),
    children,
  )
}

///|
fn[C : @html.IsChildren] menu_sub_content_surface(
  slot : String,
  key : String,
  open : Bool,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        MenuSubContentStyle,
        PopupTransition100Style,
        menu_submenu_anchor_style(key),
        popup_state_style(open),
      ],
      style,
    ),
    class?,
    title?,
    attrs=menu_state_attrs(attrs, slot, open)
      .id(menu_submenu_content_id(key))
      .popover("manual")
      .data_set("restore-focus", "false")
      .data_set("submenu-owner", key)
      .data_set("requested-side", "inline-end")
      .data_set("requested-align", "start")
      .data_set("positioned", if open { "pending" } else { "false" })
      .role("menu")
      .aria_orientation("vertical")
      .aria_labelledby(menu_submenu_trigger_id(key))
      .tabindex(-1),
    children,
  )
}
