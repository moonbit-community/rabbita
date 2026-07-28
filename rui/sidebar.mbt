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
pub(all) enum SidebarMenuButtonVariant {
  SidebarMenuButtonDefault
  SidebarMenuButtonOutline
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
const SidebarProviderStyle : String = "position:relative;display:flex;width:100%;min-height:100svh;align-items:stretch;background:var(--rui-sidebar-wrapper-background,var(--rui-background,oklch(1 0 0)));color:var(--rui-foreground,oklch(0.145 0 0))"

///|
const SidebarShellStyle : String = "position:relative;min-width:0;align-self:stretch;flex:none;transition:width 200ms linear"

///|
const SidebarBaseStyle : String = "position:relative;display:flex;min-width:0;flex-direction:column;flex-shrink:0;overflow:visible;background:var(--rui-sidebar,oklch(0.985 0 0));color:var(--rui-sidebar-foreground,var(--rui-foreground,oklch(0.145 0 0)));transition:width 200ms linear,transform 200ms linear"

///|
const SidebarDesktopStyle : String = "position:absolute;top:0;bottom:0;z-index:10"

///|
const SidebarMobileLayerStyle : String = "position:fixed;inset:0;width:auto;height:auto;max-width:none;max-height:none;margin:0;border:0;padding:0;background:transparent;color:inherit;overflow:visible;pointer-events:none;transition:display 200ms,overlay 200ms;transition-behavior:allow-discrete"

///|
const SidebarMobileStyle : String = "position:fixed;top:0;bottom:0;z-index:1;width:min(var(--rui-sidebar-width-mobile,18rem),calc(100vw - 2rem));max-width:100vw;margin:0;border-block:0;padding:0;overflow:hidden;pointer-events:auto;outline:none;box-shadow:0 16px 48px rgb(0 0 0 / 0.22);transition:transform 200ms ease-in-out,opacity 200ms ease-in-out"

///|
const SidebarOverlayStyle : String = "position:fixed;inset:0;z-index:0;background:rgb(0 0 0 / 0.5);opacity:var(--rui-sidebar-overlay-opacity,0);visibility:var(--rui-sidebar-overlay-visibility,hidden);pointer-events:var(--rui-sidebar-overlay-pointer-events,none);transition:opacity 200ms ease,visibility 0s linear var(--rui-sidebar-overlay-visibility-delay,200ms)"

///|
const SidebarOverlayOpenStyle : String = "--rui-sidebar-overlay-opacity:1;--rui-sidebar-overlay-visibility:visible;--rui-sidebar-overlay-pointer-events:auto;--rui-sidebar-overlay-visibility-delay:0s"

///|
const SidebarOverlayClosedStyle : String = "--rui-sidebar-overlay-opacity:0;--rui-sidebar-overlay-visibility:hidden;--rui-sidebar-overlay-pointer-events:auto;--rui-sidebar-overlay-visibility-delay:200ms"

///|
const SidebarHeaderFooterStyle : String = "display:flex;min-width:0;flex-direction:column;gap:0.5rem;padding:0.5rem;overflow:hidden"

///|
const SidebarContentStyle : String = "display:flex;min-width:0;min-height:0;flex:1;flex-direction:column;gap:0.5rem;overflow-x:hidden;overflow-y:var(--rui-sidebar-content-overflow-y,auto);scrollbar-width:none"

///|
const SidebarGroupStyle : String = "position:relative;display:flex;min-width:0;flex-direction:column;padding:0.5rem"

///|
const SidebarGroupLabelStyle : String = "display:flex;height:2rem;min-width:0;align-items:center;margin-block-start:var(--rui-sidebar-group-label-local-margin,var(--rui-sidebar-group-label-margin,0));padding-inline:0.5rem;color:var(--rui-sidebar-label-fg,var(--rui-sidebar-label-base-fg,color-mix(in oklab,var(--rui-sidebar-foreground,var(--rui-foreground,oklch(0.145 0 0))) 70%,transparent)));font-size:0.75rem;line-height:1rem;font-weight:500;white-space:nowrap;opacity:var(--rui-sidebar-group-label-local-opacity,var(--rui-sidebar-group-label-opacity,1));overflow:hidden;pointer-events:var(--rui-sidebar-group-label-local-pointer-events,var(--rui-sidebar-group-label-pointer-events,auto));transition:margin 200ms linear,opacity 150ms ease"

///|
const SidebarGroupActionStyle : String = "position:absolute;top:0.875rem;inset-inline-end:0.75rem;z-index:2;display:var(--rui-sidebar-group-action-display,inline-flex)"

///|
const SidebarActionSurfaceStyle : String = "border-color:var(--rui-sidebar-action-border,var(--rui-button-border,var(--rui-button-base-border,transparent)));background:var(--rui-sidebar-action-bg,var(--rui-button-bg,var(--rui-button-base-bg,transparent)));color:var(--rui-sidebar-action-fg,var(--rui-sidebar-foreground,inherit));box-shadow:var(--rui-sidebar-action-shadow,var(--rui-button-shadow,var(--rui-button-base-shadow,none)))"

///|
const SidebarActionSizeStyle : String = "width:1.25rem;height:1.25rem;--rui-button-icon-size:1rem;--rui-button-padding-inline:0"

///|
const SidebarGroupContentStyle : String = "min-width:0;width:100%;font-size:0.875rem;line-height:1.25rem"

///|
const SidebarMenuStyle : String = "display:flex;min-width:0;width:100%;flex-direction:column;gap:0.25rem;margin:0;padding:0;list-style:none"

///|
const SidebarMenuItemStyle : String = "position:relative;display:block;min-width:0"

///|
const SidebarMenuButtonStyle : String = "display:flex;width:var(--rui-sidebar-item-collapse-width,100%);min-width:0;align-items:center;justify-content:var(--rui-sidebar-item-justify-content,flex-start);gap:var(--rui-sidebar-item-collapse-gap,0.5rem);border:1px solid transparent;border-color:var(--rui-sidebar-item-border,var(--rui-sidebar-item-base-border,transparent));border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);margin:0;padding-inline-start:0.5rem;padding-inline-end:var(--rui-sidebar-item-local-padding-end,var(--rui-sidebar-item-padding-end,0.5rem));background:var(--rui-sidebar-item-bg,var(--rui-sidebar-item-base-bg,transparent));color:var(--rui-sidebar-item-fg,var(--rui-sidebar-item-base-fg,inherit));box-shadow:var(--rui-sidebar-item-shadow,var(--rui-sidebar-item-base-shadow,none));font-size:var(--rui-sidebar-item-collapse-font-size,var(--rui-sidebar-item-base-font-size,0.875rem));line-height:1.25rem;font-weight:var(--rui-sidebar-item-font-weight,var(--rui-sidebar-item-base-font-weight,400));text-align:start;text-decoration:none;white-space:nowrap;cursor:pointer;outline-offset:2px;overflow:hidden;appearance:none;-webkit-appearance:none;transition:width 200ms linear,height 200ms linear,gap 200ms linear,padding 200ms linear,font-size 150ms ease,color 150ms ease,background-color 150ms ease,border-color 150ms ease,box-shadow 150ms ease"

///|
const SidebarMenuButtonActiveStyle : String = "--rui-sidebar-item-base-bg:var(--rui-sidebar-accent,var(--rui-accent,oklch(0.97 0 0)));--rui-sidebar-item-base-fg:var(--rui-sidebar-accent-foreground,var(--rui-accent-foreground,var(--rui-foreground,oklch(0.145 0 0))));--rui-sidebar-item-base-font-weight:500"

///|
const SidebarMenuButtonOutlineStyle : String = "--rui-sidebar-item-base-bg:var(--rui-background,oklch(1 0 0));--rui-sidebar-item-base-shadow:0 0 0 1px var(--rui-sidebar-border,var(--rui-border,oklch(0.922 0 0)))"

///|
const SidebarMenuActionStyle : String = "position:absolute;top:var(--rui-sidebar-menu-action-top,0.375rem);inset-inline-end:0.25rem;z-index:2;display:var(--rui-sidebar-menu-action-display,inline-flex);opacity:var(--rui-sidebar-action-opacity,var(--rui-sidebar-action-base-opacity,1));transform:translateY(var(--rui-sidebar-action-press-offset,0))"

///|
const SidebarMenuActionHoverStyle : String = "--rui-sidebar-action-base-opacity:0"

///|
const SidebarRailStyle : String = "position:absolute;top:0;bottom:0;left:var(--rui-sidebar-rail-left,auto);right:var(--rui-sidebar-rail-right,-0.5rem);z-index:4;width:1rem;height:auto;border:0;border-radius:0;margin:0;padding:0;background:transparent;color:inherit;box-shadow:none;cursor:var(--rui-sidebar-rail-cursor,col-resize);touch-action:none;user-select:none"

///|
const SidebarRailLineStyle : String = "position:absolute;top:0;bottom:0;left:var(--rui-sidebar-rail-line-left,50%);display:block;width:2px;background:var(--rui-sidebar-rail-line-bg,transparent);transition:background-color 150ms ease;pointer-events:none"

///|
const SidebarMenuBadgeStyle : String = "position:absolute;top:var(--rui-sidebar-menu-badge-top,0.375rem);inset-inline-end:var(--rui-sidebar-badge-local-end,var(--rui-sidebar-badge-end,0.5rem));display:var(--rui-sidebar-menu-badge-display,flex);min-width:1.25rem;height:1.25rem;align-items:center;justify-content:center;border-radius:0.25rem;padding-inline:0.25rem;color:var(--rui-sidebar-badge-fg,var(--rui-sidebar-badge-base-fg,inherit));font-size:0.75rem;line-height:1rem;font-variant-numeric:tabular-nums;pointer-events:none"

///|
const SidebarMenuSubStyle : String = "display:var(--rui-sidebar-menu-sub-display,flex);min-width:0;flex-direction:column;gap:0.125rem;margin-block:0.25rem;margin-inline:0.875rem;padding-block:0.25rem;padding-inline:0.625rem;border-inline-start:1px solid var(--rui-sidebar-border,var(--rui-border,oklch(0.922 0 0)));list-style:none"

///|
const SidebarMenuSubButtonStyle : String = "display:flex;width:100%;min-width:0;height:1.75rem;align-items:center;gap:0.5rem;border:0;border-radius:calc(var(--rui-radius,0.625rem) - 0.25rem);padding-inline:0.5rem;background:var(--rui-sidebar-item-bg,var(--rui-sidebar-item-base-bg,transparent));color:var(--rui-sidebar-item-fg,var(--rui-sidebar-item-base-fg,inherit));box-shadow:var(--rui-sidebar-item-shadow,var(--rui-sidebar-item-base-shadow,none));font-size:0.8125rem;line-height:1rem;font-weight:var(--rui-sidebar-item-font-weight,var(--rui-sidebar-item-base-font-weight,400));text-align:start;text-decoration:none;white-space:nowrap;overflow:hidden;cursor:pointer;outline-offset:2px"

///|
const SidebarInsetStyle : String = "position:relative;display:flex;min-width:0;flex:1;flex-direction:column;background:var(--rui-background,oklch(1 0 0));transition:margin 200ms linear,border-radius 200ms linear,box-shadow 200ms linear"

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
priv struct SidebarPointerState {
  rail : @dom.Element
  root : @dom.Element
  sidebar : @dom.Element
  shell : @dom.Element
  pointer_id : Int
  right : Bool
  gutter : Int
  start_x : Int
  start_width : Double
  min : Double
  max : Double
  mut width : Double
  mut active : Bool
  was_collapsed : Bool
  original_current_width : String
  original_sidebar_width : String
  original_transition : String
  original_shell_width : String
  original_shell_transition : String
  original_user_select : String
  original_cursor : String
  mut captured : Bool
  mut suppress_click : @dom.Listener?
  mut lost_pointer_capture : @dom.Listener?
}

///|
#cfg(target="js")
let sidebar_pointer_states : Array[SidebarPointerState] = []

///|
#cfg(target="js")
fn sidebar_pointer_state(rail : @dom.Element) -> SidebarPointerState? {
  for state in sidebar_pointer_states {
    if state.rail.is_same_node(rail.as_node()) {
      return Some(state)
    }
  }
  None
}

///|
#cfg(target="js")
fn sidebar_remove_pointer_state(rail : @dom.Element) -> Unit {
  for index, state in sidebar_pointer_states {
    if state.rail.is_same_node(rail.as_node()) {
      ignore(sidebar_pointer_states.remove(index))
      return
    }
  }
}

///|
#cfg(target="js")
fn sidebar_restore_style_property(
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
fn sidebar_remove_click_suppression(state : SidebarPointerState) -> Unit {
  if state.suppress_click is Some(listener) {
    state.rail.remove_event_listener_with_options(
      "click",
      listener,
      capture=true,
    )
    state.suppress_click = None
  }
}

///|
#cfg(target="js")
fn sidebar_install_click_suppression(state : SidebarPointerState) -> Unit {
  if state.suppress_click is Some(_) {
    return
  }
  let listener : @dom.Listener = event => {
    event.prevent_default()
    event.stop_immediate_propagation()
    event.stop_propagation()
    sidebar_remove_click_suppression(state)
  }
  state.suppress_click = Some(listener)
  state.rail.add_event_listener_with_options("click", listener, capture=true)
}

///|
#cfg(target="js")
fn sidebar_release_pointer_state(
  state : SidebarPointerState,
  committed : Bool,
) -> Unit {
  let dragged = state.active
  guard state.root.to_html_element() is Some(root) else {
    sidebar_remove_pointer_state(state.rail)
    return
  }
  guard state.sidebar.to_html_element() is Some(sidebar) else {
    sidebar_remove_pointer_state(state.rail)
    return
  }
  guard state.shell.to_html_element() is Some(shell) else {
    sidebar_remove_pointer_state(state.rail)
    return
  }
  let root_style = root.get_style()
  let sidebar_style = sidebar.get_style()
  let shell_style = shell.get_style()
  if committed && dragged {
    sidebar_restore_style_property(
      sidebar_style,
      "transition",
      state.original_transition,
    )
    sidebar_restore_style_property(
      shell_style,
      "transition",
      state.original_shell_transition,
    )
    sidebar_restore_style_property(
      root_style,
      "user-select",
      state.original_user_select,
    )
    sidebar_restore_style_property(root_style, "cursor", state.original_cursor)
    if !state.was_collapsed {
      sidebar_restore_style_property(
        sidebar_style,
        "width",
        state.original_sidebar_width,
      )
      sidebar_restore_style_property(
        shell_style,
        "width",
        state.original_shell_width,
      )
    }
  } else {
    sidebar_restore_style_property(
      root_style,
      "--rui-sidebar-current-width",
      state.original_current_width,
    )
    sidebar_restore_style_property(
      sidebar_style,
      "width",
      state.original_sidebar_width,
    )
    sidebar_restore_style_property(
      sidebar_style,
      "transition",
      state.original_transition,
    )
    sidebar_restore_style_property(
      shell_style,
      "width",
      state.original_shell_width,
    )
    sidebar_restore_style_property(
      shell_style,
      "transition",
      state.original_shell_transition,
    )
    sidebar_restore_style_property(
      root_style,
      "user-select",
      state.original_user_select,
    )
    sidebar_restore_style_property(root_style, "cursor", state.original_cursor)
  }
  state.root.remove_attribute("data-resizing")
  state.sidebar.remove_attribute("data-resizing")
  state.rail.remove_attribute("data-resizing")
  if state.lost_pointer_capture is Some(listener) {
    state.rail.remove_event_listener("lostpointercapture", listener)
    state.lost_pointer_capture = None
  }
  sidebar_remove_pointer_state(state.rail)
  if state.captured {
    state.captured = false
    if state.rail.has_pointer_capture(state.pointer_id) {
      state.rail.release_pointer_capture(state.pointer_id)
    }
  }
  if committed && dragged {
    ignore(
      @dom.window().set_timeout(
        () => sidebar_remove_click_suppression(state),
        0,
      ),
    )
  } else {
    sidebar_remove_click_suppression(state)
  }
}

///|
#cfg(target="js")
fn sidebar_pointer_start(
  event : @dom.MouseEvent,
  min_width : Int,
  max_width : Int,
) -> Bool {
  guard event.to_pointer_event() is Some(pointer) else { return false }
  if pointer.get_default_prevented() ||
    !pointer.get_is_primary() ||
    (pointer.get_pointer_type() == "mouse" && pointer.get_button() != 0) {
    return false
  }
  guard pointer.current_target().to_option() is Some(current_target) else {
    return false
  }
  guard current_target.to_element() is Some(rail) else { return false }
  guard rail.closest("[data-slot=\"sidebar-wrapper\"]") is Some(root) else {
    return false
  }
  guard rail.closest("[data-slot=\"sidebar\"]") is Some(sidebar) else {
    return false
  }
  guard sidebar.closest("[data-slot=\"sidebar-shell\"]") is Some(shell) else {
    return false
  }
  if sidebar.get_attribute("data-mobile").unwrap_or("") == "true" ||
    sidebar.get_attribute("data-state").unwrap_or("") == "collapsed" {
    return false
  }
  if sidebar_pointer_state(rail) is Some(previous) {
    sidebar_release_pointer_state(previous, false)
  }
  guard root.to_html_element() is Some(root_html) else { return false }
  guard sidebar.to_html_element() is Some(sidebar_html) else { return false }
  guard shell.to_html_element() is Some(shell_html) else { return false }
  let gutter = if shell.get_attribute("data-variant").unwrap_or("") == "sidebar" {
    0
  } else {
    16
  }
  let min = min_width.max(1).to_double()
  let available = root.get_bounding_client_rect().get_width() - 52.0
  if available < min {
    return false
  }
  let max = max_width.max(min_width.max(1)).to_double().min(available).max(min)
  let start_width = (sidebar.get_bounding_client_rect().get_width() +
  gutter.to_double()).clamp(min~, max~)
  let root_style = root_html.get_style()
  let sidebar_style = sidebar_html.get_style()
  let shell_style = shell_html.get_style()
  let state : SidebarPointerState = {
    rail,
    root,
    sidebar,
    shell,
    pointer_id: pointer.get_pointer_id(),
    right: sidebar.get_attribute("data-side").unwrap_or("") == "right",
    gutter,
    start_x: pointer.get_client_x(),
    start_width,
    min,
    max,
    width: start_width,
    active: false,
    was_collapsed: false,
    original_current_width: root_style.get_property_value(
      "--rui-sidebar-current-width",
    ),
    original_sidebar_width: sidebar_style.get_property_value("width"),
    original_transition: sidebar_style.get_property_value("transition"),
    original_shell_width: shell_style.get_property_value("width"),
    original_shell_transition: shell_style.get_property_value("transition"),
    original_user_select: root_style.get_property_value("user-select"),
    original_cursor: root_style.get_property_value("cursor"),
    captured: false,
    suppress_click: None,
    lost_pointer_capture: None,
  }
  let lost_pointer_capture : @dom.Listener = lost => {
    if lost.to_pointer_event() is Some(lost_pointer) &&
      lost_pointer.get_pointer_id() == state.pointer_id &&
      sidebar_pointer_state(state.rail) is Some(_) {
      sidebar_release_pointer_state(state, false)
    }
  }
  state.lost_pointer_capture = Some(lost_pointer_capture)
  rail.add_event_listener("lostpointercapture", lost_pointer_capture)
  sidebar_pointer_states.push(state)
  rail.set_pointer_capture(state.pointer_id)
  if rail.has_pointer_capture(state.pointer_id) {
    state.captured = true
    true
  } else {
    sidebar_release_pointer_state(state, false)
    false
  }
}

///|
#cfg(target="js")
fn sidebar_pointer_move(event : @dom.MouseEvent) -> Bool {
  guard event.to_pointer_event() is Some(pointer) else { return false }
  guard pointer.current_target().to_option() is Some(current_target) else {
    return false
  }
  guard current_target.to_element() is Some(rail) else { return false }
  guard sidebar_pointer_state(rail) is Some(state) else { return false }
  guard state.pointer_id == pointer.get_pointer_id() else { return false }
  guard state.root.to_html_element() is Some(root) else { return false }
  guard state.sidebar.to_html_element() is Some(sidebar) else { return false }
  guard state.shell.to_html_element() is Some(shell) else { return false }
  let physical_delta = pointer.get_client_x() - state.start_x
  if !state.active {
    if physical_delta.abs() < 4 {
      return false
    }
    state.active = true
    sidebar_install_click_suppression(state)
    state.root.set_attribute("data-resizing", "true")
    state.sidebar.set_attribute("data-resizing", "true")
    state.rail.set_attribute("data-resizing", "true")
    root.get_style().set_property("user-select", "none")
    root.get_style().set_property("cursor", "col-resize")
  }
  let delta = if state.right { -physical_delta } else { physical_delta }
  state.width = (state.start_width + delta.to_double()).clamp(
    min=state.min,
    max=state.max,
  )
  let rounded_width = state.width.round().to_int().max(1)
  root
  .get_style()
  .set_property("--rui-sidebar-current-width", "\{rounded_width}px")
  sidebar.get_style().set_property("transition", "none")
  sidebar
  .get_style()
  .set_property("width", "\{(rounded_width - state.gutter).max(1)}px")
  shell.get_style().set_property("transition", "none")
  shell.get_style().set_property("width", "\{rounded_width}px")
  true
}

///|
#cfg(target="js")
fn sidebar_pointer_end(event : @dom.MouseEvent) -> Int {
  guard event.to_pointer_event() is Some(pointer) else { return 0 }
  guard pointer.current_target().to_option() is Some(current_target) else {
    return 0
  }
  guard current_target.to_element() is Some(rail) else { return 0 }
  guard sidebar_pointer_state(rail) is Some(state) else { return 0 }
  guard state.pointer_id == pointer.get_pointer_id() else { return 0 }
  let width = if state.active { state.width.round().to_int().max(1) } else { 0 }
  sidebar_release_pointer_state(state, state.active)
  width
}

///|
#cfg(target="js")
fn sidebar_pointer_cancel(event : @dom.MouseEvent) -> Unit {
  guard event.to_pointer_event() is Some(pointer) else { return }
  guard pointer.current_target().to_option() is Some(current_target) else {
    return
  }
  guard current_target.to_element() is Some(rail) else { return }
  guard sidebar_pointer_state(rail) is Some(state) else { return }
  guard state.pointer_id == pointer.get_pointer_id() else { return }
  sidebar_release_pointer_state(state, false)
}

///|
fn sidebar_side_style(side : SidebarSide) -> String {
  match side {
    SidebarLeft =>
      "--rui-sidebar-rail-left:auto;--rui-sidebar-rail-right:-0.5rem;--rui-sidebar-rail-line-left:50%;border-right:1px solid var(--rui-sidebar-border,var(--rui-border,oklch(0.922 0 0)))"
    SidebarRight =>
      "--rui-sidebar-rail-left:-0.5rem;--rui-sidebar-rail-right:auto;--rui-sidebar-rail-line-left:50%;border-left:1px solid var(--rui-sidebar-border,var(--rui-border,oklch(0.922 0 0)))"
  }
}

///|
fn sidebar_shell_side_style(side : SidebarSide) -> String {
  match side {
    SidebarLeft => "order:0"
    SidebarRight => "order:1"
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
    "transform:translateX(0);opacity:1"
  } else {
    match side {
      SidebarLeft => "transform:translateX(-100%);opacity:0"
      SidebarRight => "transform:translateX(100%);opacity:0"
    }
  }
}

///|
fn sidebar_variant_style(variant : SidebarVariant) -> String {
  match variant {
    SidebarDefault => ""
    SidebarFloating =>
      "border:1px solid var(--rui-sidebar-border,var(--rui-border,oklch(0.922 0 0)));border-radius:var(--rui-radius,0.625rem);box-shadow:0 1px 3px rgb(0 0 0 / 0.08)"
    SidebarInset => "border:0;border-radius:0;box-shadow:none"
  }
}

///|
fn sidebar_desktop_position_style(
  side : SidebarSide,
  variant : SidebarVariant,
) -> String {
  if variant is SidebarDefault {
    match side {
      SidebarLeft => "left:0"
      SidebarRight => "right:0"
    }
  } else {
    match side {
      SidebarLeft => "top:0.5rem;bottom:0.5rem;left:0.5rem"
      SidebarRight => "top:0.5rem;bottom:0.5rem;right:0.5rem"
    }
  }
}

///|
fn sidebar_desktop_surface_width_style(
  collapsed : Bool,
  collapsible : SidebarCollapsible,
  variant : SidebarVariant,
) -> String {
  if collapsed && collapsible is SidebarIcon {
    "width:var(--rui-sidebar-width-icon,3rem)"
  } else if variant is SidebarDefault {
    "width:var(--rui-sidebar-current-width,var(--rui-sidebar-width,16rem))"
  } else {
    "width:calc(var(--rui-sidebar-current-width,var(--rui-sidebar-width,16rem)) - 1rem)"
  }
}

///|
fn sidebar_desktop_state_style(
  side : SidebarSide,
  collapsed : Bool,
  collapsible : SidebarCollapsible,
  variant : SidebarVariant,
) -> String {
  if collapsed && collapsible is SidebarOffcanvas {
    if variant is SidebarDefault {
      match side {
        SidebarLeft => "transform:translateX(-100%)"
        SidebarRight => "transform:translateX(100%)"
      }
    } else {
      match side {
        SidebarLeft => "transform:translateX(calc(-100% - 0.5rem))"
        SidebarRight => "transform:translateX(calc(100% + 0.5rem))"
      }
    }
  } else {
    "transform:translateX(0)"
  }
}

///|
fn sidebar_shell_width_style(
  collapsed : Bool,
  collapsible : SidebarCollapsible,
  variant : SidebarVariant,
) -> String {
  if collapsed && collapsible is SidebarOffcanvas {
    "width:0px"
  } else if collapsed && collapsible is SidebarIcon {
    if variant is SidebarDefault {
      "width:var(--rui-sidebar-width-icon,3rem)"
    } else {
      "width:calc(var(--rui-sidebar-width-icon,3rem) + 1rem)"
    }
  } else {
    "width:var(--rui-sidebar-current-width,var(--rui-sidebar-width,16rem))"
  }
}

///|
fn sidebar_descendant_state_style(
  collapsed : Bool,
  collapsible : SidebarCollapsible,
  mobile : Bool,
  side : SidebarSide,
) -> String {
  if mobile {
    "--rui-sidebar-group-label-margin:0;--rui-sidebar-group-label-opacity:1;--rui-sidebar-group-label-pointer-events:auto;--rui-sidebar-group-action-display:inline-flex;--rui-sidebar-menu-action-display:inline-flex;--rui-sidebar-menu-badge-display:flex;--rui-sidebar-menu-sub-display:flex;--rui-sidebar-input-display:block;--rui-sidebar-content-overflow-y:auto;--rui-sidebar-item-collapse-width:100%;--rui-sidebar-item-collapse-height:var(--rui-sidebar-item-base-height,2rem);--rui-sidebar-item-collapse-gap:0.5rem;--rui-sidebar-item-collapse-font-size:var(--rui-sidebar-item-base-font-size,0.875rem);--rui-sidebar-item-justify-content:flex-start"
  } else if collapsed && collapsible is SidebarIcon {
    "--rui-sidebar-group-label-margin:-2rem;--rui-sidebar-group-label-opacity:0;--rui-sidebar-group-label-pointer-events:none;--rui-sidebar-group-action-display:none;--rui-sidebar-menu-action-display:none;--rui-sidebar-menu-badge-display:none;--rui-sidebar-menu-sub-display:none;--rui-sidebar-input-display:none;--rui-sidebar-content-overflow-y:hidden;--rui-sidebar-item-collapse-width:2rem;--rui-sidebar-item-collapse-height:2rem;--rui-sidebar-item-collapse-gap:0;--rui-sidebar-item-collapse-font-size:0;--rui-sidebar-item-justify-content:center;--rui-sidebar-item-local-padding-end:0.5rem;--rui-sidebar-badge-local-end:0.5rem;--rui-sidebar-skeleton-text-display:none;--rui-sidebar-rail-cursor:pointer"
  } else if collapsed && collapsible is SidebarOffcanvas {
    match side {
      SidebarLeft =>
        "--rui-sidebar-rail-cursor:pointer;--rui-sidebar-rail-left:auto;--rui-sidebar-rail-right:-1rem;--rui-sidebar-rail-line-left:0%"
      SidebarRight =>
        "--rui-sidebar-rail-cursor:pointer;--rui-sidebar-rail-left:-1rem;--rui-sidebar-rail-right:auto;--rui-sidebar-rail-line-left:100%"
    }
  } else {
    ""
  }
}

///|
#cfg(target="js")
const SidebarFocusableSelector : String = "a[href]:not([aria-disabled=\"true\"]):not([tabindex=\"-1\"]),button:not(:disabled):not([aria-disabled=\"true\"]):not([tabindex=\"-1\"]),input:not(:disabled):not([aria-disabled=\"true\"]):not([tabindex=\"-1\"]),select:not(:disabled):not([aria-disabled=\"true\"]):not([tabindex=\"-1\"]),textarea:not(:disabled):not([aria-disabled=\"true\"]):not([tabindex=\"-1\"]),[tabindex]:not([tabindex=\"-1\"]):not(:disabled):not([disabled]):not([aria-disabled=\"true\"])"

///|
#cfg(target="js")
priv struct SidebarModalRecord {
  node : @dom.Element
  had_inert : Bool
  inert_value : String
  had_aria_hidden : Bool
  aria_hidden : String
}

///|
#cfg(target="js")
priv struct SidebarModalState {
  root : @dom.Element
  records : Array[SidebarModalRecord]
  observer : @dom.MutationObserver?
}

///|
#cfg(target="js")
priv struct SidebarDesktopCollapseFocus {
  active : @dom.Element
  sidebar : @dom.Element
  wrapper : @dom.Element?
}

///|
#cfg(target="js")
priv struct SidebarMobileLayerBinding {
  layer : @dom.Element
  mut close_timer : Int?
}

///|
#cfg(target="js")
let sidebar_restore_trigger : Ref[@dom.Element?] = Ref(None)

///|
#cfg(target="js")
let sidebar_modal_state : Ref[SidebarModalState?] = Ref(None)

///|
#cfg(target="js")
let sidebar_desktop_collapse_focus : Ref[SidebarDesktopCollapseFocus?] = Ref(
  None,
)

///|
#cfg(target="js")
let sidebar_focus_bound_documents : Array[@dom.Document] = []

///|
#cfg(target="js")
let sidebar_mobile_layer_bindings : Array[SidebarMobileLayerBinding] = []

///|
#cfg(target="js")
fn sidebar_document_elements(selector : String) -> Array[@dom.Element] {
  let elements : Array[@dom.Element] = []
  if !ui_has_document() {
    return elements
  }
  let nodes = @dom.document().query_selector_all(selector)
  for index in 0..<nodes.get_length().to_int() {
    if nodes.item(index.to_double()).to_option() is Some(node) &&
      node.to_element() is Some(element) {
      elements.push(element)
    }
  }
  elements
}

///|
#cfg(target="js")
fn sidebar_element_is_visible(element : @dom.Element) -> Bool {
  if element.get_client_rects().length() == 0 ||
    element.closest("[inert]") is Some(_) ||
    !ui_element_is_enabled(element) {
    return false
  }
  if ui_has_window() {
    let style = @dom.window().get_computed_style(element)
    style.get_property_value("display") != "none" &&
    style.get_property_value("visibility") != "hidden"
  } else {
    true
  }
}

///|
#cfg(target="js")
fn sidebar_focusable_elements(root : @dom.Element) -> Array[@dom.Element] {
  root
  .query_selector_all(SidebarFocusableSelector)
  .filter(sidebar_element_is_visible)
}

///|
#cfg(target="js")
fn sidebar_focus_edge(root : @dom.Element, last : Bool) -> Unit {
  let items = sidebar_focusable_elements(root)
  let target = if items.length() == 0 {
    root
  } else if last {
    items[items.length() - 1]
  } else {
    items[0]
  }
  ui_focus_element_without_scroll(target)
  if target.is_same_node(root.as_node()) && ui_has_window() {
    ignore(
      @dom.window().request_animation_frame(_ => {
        if !root.get_is_connected() ||
          root.get_attribute("data-mobile-state").unwrap_or("") != "open" ||
          !ui_has_document() {
          return
        }
        let document = @dom.document()
        guard document.get_active_element() is Some(active) &&
          active.is_same_node(root.as_node()) else {
          return
        }
        let refreshed = sidebar_focusable_elements(root)
        if refreshed.length() > 0 {
          ui_focus_element_without_scroll(
            if last {
              refreshed[refreshed.length() - 1]
            } else {
              refreshed[0]
            },
          )
        }
      }),
    )
  }
}

///|
#cfg(target="js")
fn sidebar_trap_focus(event : @dom.KeyboardEvent) -> Bool {
  if event.key() != "Tab" ||
    event.alt_key() ||
    event.ctrl_key() ||
    event.meta_key() {
    return false
  }
  guard event.current_target().to_option() is Some(current) &&
    current.to_element() is Some(root) else {
    return false
  }
  if root.get_attribute("aria-hidden").unwrap_or("") == "true" {
    return false
  }
  let items = sidebar_focusable_elements(root)
  if items.length() == 0 {
    ui_focus_element_without_scroll(root)
    return true
  }
  let active = if ui_has_document() {
    @dom.document().get_active_element()
  } else {
    None
  }
  let mut active_index = -1
  if active is Some(active) {
    for index, item in items {
      if item.is_same_node(active.as_node()) {
        active_index = index
      }
    }
  }
  let next_index = if event.shift_key() {
    if active_index <= 0 {
      items.length() - 1
    } else {
      active_index - 1
    }
  } else if active_index < 0 || active_index == items.length() - 1 {
    0
  } else {
    active_index + 1
  }
  ui_focus_element_without_scroll(items[next_index])
  true
}

///|
#cfg(target="js")
fn sidebar_bind_mobile_dismiss(attrs : @html.Attrs, command : @cmd.Cmd) -> Unit {
  ignore(
    attrs.on_keydown(event => {
      if event.key() == "Escape" {
        event.prevent_default()
        command
      } else if sidebar_trap_focus(event) {
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
fn sidebar_current_mobile_root() -> @dom.Element? {
  let roots = sidebar_document_elements(
    "[data-slot=\"sidebar\"][data-mobile=\"true\"][data-mobile-state=\"open\"]",
  ).filter(root => {
    !root.has_attribute("hidden") &&
    root.get_attribute("aria-hidden").unwrap_or("") != "true"
  })
  roots.get(roots.length() - 1)
}

///|
#cfg(target="js")
fn sidebar_release_modal() -> Unit {
  guard sidebar_modal_state.val is Some(state) else { return }
  if state.observer is Some(observer) {
    observer.disconnect()
  }
  let mut index = state.records.length() - 1
  while index >= 0 {
    let record = state.records[index]
    if record.had_inert {
      record.node.set_attribute("inert", record.inert_value)
    } else {
      record.node.remove_attribute("inert")
    }
    if record.had_aria_hidden {
      record.node.set_attribute("aria-hidden", record.aria_hidden)
    } else {
      record.node.remove_attribute("aria-hidden")
    }
    index -= 1
  }
  sidebar_modal_state.val = None
}

///|
#cfg(target="js")
fn sidebar_contain_background(root : @dom.Element) -> Unit {
  if sidebar_modal_state.val is Some(state) &&
    state.root.is_same_node(root.as_node()) {
    return
  }
  sidebar_release_modal()
  let records : Array[SidebarModalRecord] = []
  let body = if ui_has_document() { @dom.document().get_body() } else { None }
  let mut node = root
  let mut complete = false
  while !complete {
    if node.get_parent_element() is Some(parent) {
      for sibling in parent.get_children() {
        if !sibling.is_same_node(node.as_node()) &&
          sibling.get_attribute("data-slot").unwrap_or("") != "sidebar-overlay" {
          records.push({
            node: sibling,
            had_inert: sibling.has_attribute("inert"),
            inert_value: sibling.get_attribute("inert").unwrap_or(""),
            had_aria_hidden: sibling.has_attribute("aria-hidden"),
            aria_hidden: sibling.get_attribute("aria-hidden").unwrap_or(""),
          })
          sibling.set_attribute("inert", "")
          sibling.set_attribute("aria-hidden", "true")
        }
      }
      node = parent
      complete = body is Some(body) && node.is_same_node(body.as_node())
    } else {
      complete = true
    }
  }
  let observer = @dom.MutationObserver::new((_, _) => {
    if !root.get_is_connected() ||
      root.has_attribute("hidden") ||
      root.get_attribute("aria-hidden").unwrap_or("") == "true" ||
      root.get_attribute("data-mobile-state").unwrap_or("") != "open" {
      sidebar_release_modal()
    }
  })
  if ui_has_document() &&
    @dom.document().get_document_element() is Some(document_element) {
    observer.observe(
      document_element.as_node(),
      attributes=true,
      child_list=true,
      subtree=true,
      attribute_filter=["data-mobile-state", "aria-hidden", "hidden"],
    )
  }
  sidebar_modal_state.val = Some({ root, records, observer: Some(observer) })
}

///|
#cfg(target="js")
fn sidebar_document_is_bound(document : @dom.Document) -> Bool {
  for bound in sidebar_focus_bound_documents {
    if bound.to_node().is_same_node(document.to_node()) {
      return true
    }
  }
  false
}

///|
#cfg(target="js")
fn sidebar_bind_focus_document(document : @dom.Document) -> Unit {
  if sidebar_document_is_bound(document) {
    return
  }
  sidebar_focus_bound_documents.push(document)
  document.add_event_listener_with_options(
    "focusin",
    event => {
      if sidebar_current_mobile_root() is Some(root) {
        if !ui_element_contains_target(root, event.target()) {
          sidebar_focus_edge(root, false)
        }
      } else {
        sidebar_release_modal()
      }
    },
    capture=true,
  )
  document.add_event_listener_with_options(
    "keydown",
    event => {
      guard event.to_keyboard_event() is Some(keyboard) else { return }
      guard sidebar_current_mobile_root() is Some(root) else {
        sidebar_release_modal()
        return
      }
      if keyboard.get_default_prevented() {
        return
      }
      let active_outside = document.get_active_element() is Some(active) &&
        !root.contains(active.as_node())
      if keyboard.key() == "Tab" && active_outside {
        keyboard.prevent_default()
        sidebar_focus_edge(root, keyboard.shift_key())
      } else if keyboard.key() == "Escape" &&
        !ui_element_contains_target(root, keyboard.target()) {
        keyboard.prevent_default()
        if ui_has_window() {
          // Re-dispatch the same typed event once the document dispatch completes.
          @dom.window().queue_microtask(() => {
            if root.get_is_connected() &&
              root.get_attribute("data-mobile-state").unwrap_or("") == "open" {
              root.dispatch_event(keyboard.as_event())
            }
          })
        }
      }
    },
    capture=true,
  )
}

///|
#cfg(target="js")
fn sidebar_capture_active_restore_target(
  document : @dom.Document,
  root : @dom.Element,
) -> Unit {
  if sidebar_restore_trigger.val is Some(_) {
    return
  }
  guard document.get_active_element() is Some(active) else { return }
  if root.contains(active.as_node()) || active.to_html_element() is None {
    return
  }
  if document.get_body() is Some(body) && active.is_same_node(body.as_node()) {
    return
  }
  if document.get_document_element() is Some(document_element) &&
    active.is_same_node(document_element.as_node()) {
    return
  }
  sidebar_restore_trigger.val = Some(active)
}

///|
#cfg(target="js")
fn sidebar_focus_open() -> Bool {
  if !ui_has_document() {
    return false
  }
  let document = @dom.document()
  sidebar_bind_focus_document(document)
  guard sidebar_current_mobile_root() is Some(root) else { return false }
  sidebar_capture_active_restore_target(document, root)
  sidebar_contain_background(root)
  if document.get_active_element() is None ||
    (
      document.get_active_element() is Some(active) &&
      !root.contains(active.as_node())
    ) {
    sidebar_focus_edge(root, false)
  }
  document.get_active_element() is Some(active) &&
  (root.contains(active.as_node()) || active.is_same_node(root.as_node()))
}

///|
#cfg(target="js")
fn sidebar_bind_mobile_focus(attrs : @html.Attrs, open : Bool) -> Unit {
  if open {
    ignore(
      attrs.on_focus(_ => {
        ignore(sidebar_focus_open())
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
      attrs.on_click(event => {
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
fn sidebar_capture_restore_trigger(event : @dom.MouseEvent) -> Unit {
  if event.current_target().to_option() is Some(current) &&
    current.to_element() is Some(trigger) &&
    trigger.to_html_element() is Some(_) {
    sidebar_restore_trigger.val = Some(trigger)
  }
}

///|
#cfg(target="js")
fn sidebar_bind_restore_trigger(attrs : @html.Attrs, enabled : Bool) -> Unit {
  if enabled {
    ignore(
      attrs.on_click(event => {
        sidebar_capture_restore_trigger(event)
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
fn sidebar_restore_captured_trigger() -> Unit {
  sidebar_release_modal()
  let trigger = sidebar_restore_trigger.val
  sidebar_restore_trigger.val = None
  guard trigger is Some(trigger) else { return }
  if trigger.get_is_connected() &&
    ui_element_is_enabled(trigger) &&
    trigger.closest("[inert],[hidden],[aria-hidden=\"true\"]") is None {
    ui_focus_element_without_scroll(trigger)
  }
}

///|
#cfg(target="js")
fn sidebar_mobile_layer_binding(
  layer : @dom.Element,
) -> SidebarMobileLayerBinding? {
  for binding in sidebar_mobile_layer_bindings {
    if binding.layer.is_same_node(layer.as_node()) {
      return Some(binding)
    }
  }
  None
}

///|
#cfg(target="js")
fn sidebar_prune_mobile_layer_bindings() -> Unit {
  let mut index = 0
  while index < sidebar_mobile_layer_bindings.length() {
    let binding = sidebar_mobile_layer_bindings[index]
    if binding.layer.get_is_connected() {
      index += 1
    } else {
      if binding.close_timer is Some(timer) && ui_has_window() {
        @dom.window().clear_timeout(timer)
      }
      ignore(sidebar_mobile_layer_bindings.remove(index))
    }
  }
}

///|
#cfg(target="js")
fn sidebar_finish_mobile_layer_close(
  binding : SidebarMobileLayerBinding,
) -> Unit {
  binding.close_timer = None
  if binding.layer.get_attribute("data-state").unwrap_or("") == "open" {
    return
  }
  if binding.layer.to_html_element() is Some(layer) &&
    binding.layer.matches(":popover-open") {
    layer.hide_popover()
  }
}

///|
#cfg(target="js")
fn sidebar_sync_mobile_layers() -> Unit {
  if !ui_has_document() {
    return
  }
  sidebar_prune_mobile_layer_bindings()
  let layers = sidebar_document_elements(
    "[data-slot=\"sidebar-mobile-layer\"][popover]",
  )
  for layer in layers {
    let binding = if sidebar_mobile_layer_binding(layer) is Some(binding) {
      binding
    } else {
      let binding : SidebarMobileLayerBinding = { layer, close_timer: None }
      sidebar_mobile_layer_bindings.push(binding)
      binding
    }
    let requested = layer.get_attribute("data-state").unwrap_or("") == "open"
    let native_open = layer.matches(":popover-open")
    if requested {
      if binding.close_timer is Some(timer) {
        if ui_has_window() {
          @dom.window().clear_timeout(timer)
        }
        binding.close_timer = None
      }
      if !native_open && layer.to_html_element() is Some(html) {
        html.show_popover()
      }
    } else if native_open && binding.close_timer is None {
      if ui_has_window() {
        binding.close_timer = Some(
          @dom.window().set_timeout(
            () => sidebar_finish_mobile_layer_close(binding),
            200,
          ),
        )
      } else {
        sidebar_finish_mobile_layer_close(binding)
      }
    }
  }
}

///|
#cfg(target="js")
fn sidebar_mobile_effect_cmd(open : Bool, restore_on_close : Bool) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, _ => {
    sidebar_sync_mobile_layers()
    if open {
      ignore(sidebar_focus_open())
    } else if restore_on_close && !sidebar_focus_open() {
      sidebar_restore_captured_trigger()
    }
  })
}

///|
#cfg(not(target="js"))
fn sidebar_mobile_effect_cmd(open : Bool, restore_on_close : Bool) -> @cmd.Cmd {
  ignore((open, restore_on_close))
  @cmd.none
}

///|
#cfg(target="js")
fn sidebar_capture_desktop_collapse_focus() -> Unit {
  sidebar_desktop_collapse_focus.val = None
  if !ui_has_document() {
    return
  }
  guard @dom.document().get_active_element() is Some(active) else { return }
  guard active.closest("[data-slot=\"sidebar\"][data-mobile=\"false\"]")
    is Some(sidebar) else {
    return
  }
  if active.get_attribute("data-slot").unwrap_or("") == "sidebar-rail" {
    return
  }
  sidebar_desktop_collapse_focus.val = Some({
    active,
    sidebar,
    wrapper: sidebar.closest("[data-slot=\"sidebar-wrapper\"]"),
  })
}

///|
#cfg(target="js")
fn sidebar_restore_desktop_collapse_focus() -> Unit {
  let captured = sidebar_desktop_collapse_focus.val
  sidebar_desktop_collapse_focus.val = None
  guard captured is Some(state) else { return }
  if !ui_has_document() ||
    !state.sidebar.get_is_connected() ||
    state.sidebar.get_attribute("data-state").unwrap_or("") != "collapsed" {
    return
  }
  let document = @dom.document()
  guard document.get_active_element() is Some(current) else { return }
  let active_still_current = current.is_same_node(state.active.as_node())
  let body_is_current = document.get_body() is Some(body) &&
    current.is_same_node(body.as_node())
  if !active_still_current && !body_is_current {
    return
  }
  let hidden = !state.active.get_is_connected() ||
    state.sidebar.get_attribute("data-collapsible").unwrap_or("") == "offcanvas" ||
    state.active.get_client_rects().length() == 0 ||
    (
      ui_has_window() &&
      (
        @dom.window()
        .get_computed_style(state.active)
        .get_property_value("display") ==
        "none" ||
        @dom.window()
        .get_computed_style(state.active)
        .get_property_value("visibility") ==
        "hidden"
      )
    )
  if !hidden {
    return
  }
  let trigger = if state.wrapper is Some(wrapper) {
    wrapper.query_selector(
      "[data-slot=\"sidebar-trigger\"][aria-expanded=\"false\"]:not(:disabled):not([aria-disabled=\"true\"])",
    )
  } else {
    None
  }
  let target = if trigger is Some(trigger) {
    Some(trigger)
  } else {
    state.sidebar.query_selector("[data-slot=\"sidebar-rail\"]")
  }
  if target is Some(target) {
    ui_focus_element_without_scroll(target)
  }
}

///|
#cfg(target="js")
fn sidebar_desktop_collapse_focus_cmd() -> @cmd.Cmd {
  @cmd.batch([
    @cmd.custom_cmd(kind=Immediately, _ => {
      sidebar_capture_desktop_collapse_focus()
    }),
    @cmd.custom_cmd(kind=AfterRender, _ => {
      sidebar_restore_desktop_collapse_focus()
    }),
  ])
}

///|
#cfg(not(target="js"))
fn sidebar_desktop_collapse_focus_cmd() -> @cmd.Cmd {
  @cmd.none
}

///|
fn sidebar_mobile_change_cmd(
  notify : @cmd.Emit[Bool]?,
  open : Bool,
) -> @cmd.Cmd {
  @cmd.batch([
    sidebar_emit_bool(notify, open),
    sidebar_mobile_effect_cmd(open, true),
  ])
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
fn sidebar_menu_variant_value(variant : SidebarMenuButtonVariant) -> String {
  match variant {
    SidebarMenuButtonDefault => "default"
    SidebarMenuButtonOutline => "outline"
  }
}

///|
fn sidebar_menu_variant_style(variant : SidebarMenuButtonVariant) -> String {
  match variant {
    SidebarMenuButtonDefault => ""
    SidebarMenuButtonOutline => SidebarMenuButtonOutlineStyle
  }
}

///|
fn sidebar_menu_size_style(size : SidebarMenuButtonSize) -> String {
  match size {
    SidebarMenuSm =>
      "height:var(--rui-sidebar-item-collapse-height,1.75rem);--rui-sidebar-item-base-height:1.75rem;--rui-sidebar-item-base-font-size:0.75rem"
    SidebarMenuDefault =>
      "height:var(--rui-sidebar-item-collapse-height,2rem);--rui-sidebar-item-base-height:2rem;--rui-sidebar-item-base-font-size:0.875rem"
    SidebarMenuLg =>
      "height:var(--rui-sidebar-item-collapse-height,3rem);--rui-sidebar-item-base-height:3rem;--rui-sidebar-item-base-font-size:0.875rem"
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
  let (state, emit) = @rabbita.create_state_with_init(
    init=fn(_) {
      (
        initial,
        if default_mobile_open {
          sidebar_mobile_effect_cmd(true, false)
        } else {
          @cmd.none
        },
      )
    },
    update=fn(state, msg, _) {
      match msg {
        ToggleSidebarCollapsed => {
          let next = !state.collapsed
          (
            { ..state, collapsed: next },
            @cmd.batch([
              sidebar_emit_bool(on_collapsed_change, next),
              if next {
                sidebar_desktop_collapse_focus_cmd()
              } else {
                @cmd.none
              },
            ]),
          )
        }
        SetSidebarCollapsed(next) =>
          if next == state.collapsed {
            (state, @cmd.none)
          } else {
            (
              { ..state, collapsed: next },
              @cmd.batch([
                sidebar_emit_bool(on_collapsed_change, next),
                if next {
                  sidebar_desktop_collapse_focus_cmd()
                } else {
                  @cmd.none
                },
              ]),
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
    },
  )
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
          SidebarDesktopStyle
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
          sidebar_variant_style(variant)
        },
        if mobile {
          ""
        } else {
          sidebar_desktop_position_style(side, variant)
        },
        if mobile {
          ""
        } else {
          sidebar_desktop_surface_width_style(collapsed, collapsible, variant)
        },
        if mobile {
          ""
        } else {
          sidebar_desktop_state_style(side, collapsed, collapsible, variant)
        },
        sidebar_descendant_state_style(collapsed, collapsible, mobile, side),
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
    ignore(backdrop_attrs.on_click(_ => scope.close_mobile))
    let layer_attrs = @html.Attrs::build()
      .data_set("slot", "sidebar-mobile-layer")
      .data_set("state", if mobile_open { "open" } else { "closed" })
      .popover("manual")
    @html.div(
      style=[UiBoxSizing, UiFontSans, SidebarMobileLayerStyle],
      attrs=layer_attrs,
      [
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
      ],
    )
  } else {
    let shell_attrs = @html.Attrs::build()
      .data_set("slot", "sidebar-shell")
      .data_set("side", sidebar_side_value(side))
      .data_set("variant", sidebar_variant_value(variant))
      .data_set("collapsible", sidebar_collapsible_value(collapsible))
      .data_set("state", sidebar_state_value(collapsed))
    @html.div(
      style=[
        UiBoxSizing,
        SidebarShellStyle,
        sidebar_shell_side_style(side),
        sidebar_shell_width_style(collapsed, collapsible, variant),
      ],
      hidden=is_hidden,
      attrs=shell_attrs,
      surface,
    )
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
    style=ui_styles(
      ["width:1.75rem;height:1.75rem;--rui-button-base-shadow:0 0 #0000"],
      style,
    ),
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
    .on_pointerdown(event => {
      ignore(sidebar_pointer_start(event, min_width, max_width))
      @cmd.none
    })
    .on_pointermove(event => {
      if sidebar_pointer_move(event) {
        event.prevent_default()
      }
      @cmd.none
    })
    .on_pointerup(event => {
      let width = sidebar_pointer_end(event)
      if width > 0 {
        event.prevent_default()
        (scope.commit_width)(width)
      } else {
        @cmd.none
      }
    })
    .on_pointercancel(event => {
      sidebar_pointer_cancel(event)
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
/// Render the desktop edge control for toggling and pointer resizing.
/// Placement and resize direction are derived from the nearest sidebar.
pub fn sidebar_rail(
  scope : SidebarScope,
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
  let line_edge = "transform:translateX(-50%)"
  let rail_attrs = ui_attrs(attrs)
    .data_set("slot", "sidebar-rail")
    .data_set("min-width", "\{min_width}")
    .data_set("max-width", "\{max_width}")
    .aria_expanded(ui_bool(!scope.collapsed))
    .tabindex(-1)
  ignore(
    rail_attrs.on_click(_ => {
      @cmd.batch([
        match on_click {
          Some(command) => command
          None => @cmd.none
        },
        scope.toggle_collapsed,
      ])
    }),
  )
  sidebar_bind_resize_attrs(rail_attrs, scope, min_width, max_width)
  dialog_control_button(
    slot="sidebar-rail",
    command=@cmd.none,
    variant=Ghost,
    size=IconXs,
    disabled=false,
    id~,
    class~,
    title=Some(title),
    aria_label=Some(aria_label),
    on_click=None,
    attrs=Some(rail_attrs),
    style=ui_styles([SidebarRailStyle], style),
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
          "--rui-sidebar-group-label-local-margin:0;--rui-sidebar-group-label-local-opacity:1;--rui-sidebar-group-label-local-pointer-events:auto"
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
    style=ui_styles(
      [
        SidebarGroupActionStyle,
        SidebarActionSurfaceStyle,
        SidebarActionSizeStyle,
      ],
      style,
    ),
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
fn[C : @html.IsChildren] render_sidebar_menu_button(
  href : String?,
  is_active : Bool,
  variant : SidebarMenuButtonVariant,
  size : SidebarMenuButtonSize,
  disabled : Bool,
  aria_label : String?,
  target : @html.Target,
  rel : String?,
  download : String?,
  on_click : @cmd.Cmd?,
  id : String?,
  class_ : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "sidebar-menu-button")
    .data_set("variant", sidebar_menu_variant_value(variant))
    .data_set("size", sidebar_menu_size_value(size))
    .data_set("active", ui_bool(is_active))
    .data_set("state", if is_active { "active" } else { "inactive" })
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  }
  if is_active && href is Some(_) {
    ignore(element_attrs.aria_current("page"))
  }
  if disabled {
    ignore(
      element_attrs.aria_disabled("true").data_set("disabled", "").tabindex(-1),
    )
  } else if on_click is Some(command) {
    ignore(element_attrs.on_click(_ => command))
  }
  sidebar_bind_disabled_link(element_attrs, disabled && href is Some(_))
  let styles = ui_styles(
    [
      UiBoxSizing,
      UiFontSans,
      UiTextRendering,
      UiTransition,
      SidebarMenuButtonStyle,
      sidebar_menu_variant_style(variant),
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
        class?=class_,
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
        class?=class_,
        title?,
        type_="button",
        disabled~,
        attrs=element_attrs,
        children,
      )
  }
}

///|
/// Render a native button, or a native anchor when `href` is supplied.
pub fn[C : @html.IsChildren] sidebar_menu_button(
  href? : String,
  is_active? : Bool = false,
  variant? : SidebarMenuButtonVariant = SidebarMenuButtonDefault,
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
  render_sidebar_menu_button(
    href, is_active, variant, size, disabled, aria_label, target, rel, download,
    on_click, id, class, title, attrs, style, children,
  )
}

///|
fn[C : @html.IsChildren] render_sidebar_menu_button_with_tooltip(
  id : String,
  tooltip : String,
  open : Bool,
  href : String?,
  is_active : Bool,
  variant : SidebarMenuButtonVariant,
  size : SidebarMenuButtonSize,
  disabled : Bool,
  aria_label : String?,
  target : @html.Target,
  rel : String?,
  download : String?,
  on_click : @cmd.Cmd?,
  class_ : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  tooltip_side : PopupSide,
  tooltip_align : PopupAlign,
  tooltip_side_offset : Int,
  tooltip_align_offset : Int,
  tooltip_show_arrow : Bool,
  tooltip_attrs : @html.Attrs?,
  tooltip_style : Array[String],
  children : C,
) -> @html.Html {
  let content_id = id + "-tooltip"
  let trigger_attrs = ui_attrs(attrs)
    .data_set("tooltip-root", "")
    .data_set("tooltip-state", if open { "open" } else { "closed" })
    .data_set("close-on-click", "true")
    .data_set("hoverable", "true")
    .data_set("sidebar-collapsed-only", "true")
  if open {
    ignore(trigger_attrs.aria_describedby(content_id))
  }
  let content_attrs = ui_attrs(tooltip_attrs).data_set("tooltip-owner-id", id)
  @html.fragment([
    render_sidebar_menu_button(
      href,
      is_active,
      variant,
      size,
      disabled,
      aria_label,
      target,
      rel,
      download,
      on_click,
      Some(id),
      class_,
      title,
      Some(trigger_attrs),
      style,
      children,
    ),
    tooltip_content(
      id=content_id,
      trigger_id=id,
      open~,
      side=tooltip_side,
      align=tooltip_align,
      side_offset=tooltip_side_offset,
      align_offset=tooltip_align_offset,
      show_arrow=tooltip_show_arrow,
      attrs=content_attrs,
      style=tooltip_style,
      tooltip,
    ),
  ])
}

///|
/// Render a sidebar menu button with a tooltip that is active only while its
/// desktop icon sidebar is collapsed.
///
/// The tooltip reuses the button or anchor as its trigger, so this API never
/// nests interactive elements. Expanded, off-canvas, fixed, and mobile
/// sidebars suppress the tooltip automatically.
#cfg(target="js")
pub fn[C : @html.IsChildren] sidebar_menu_button_with_tooltip(
  id~ : String,
  tooltip~ : String,
  href? : String,
  is_active? : Bool = false,
  variant? : SidebarMenuButtonVariant = SidebarMenuButtonDefault,
  size? : SidebarMenuButtonSize = SidebarMenuDefault,
  disabled? : Bool = false,
  aria_label? : String,
  target? : @html.Target = Self,
  rel? : String,
  download? : String,
  on_click? : @cmd.Cmd,
  on_tooltip_open_change? : @cmd.Emit[Bool],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  tooltip_side? : PopupSide = Right,
  tooltip_align? : PopupAlign = Center,
  tooltip_side_offset? : Int = 4,
  tooltip_align_offset? : Int = 0,
  tooltip_show_arrow? : Bool = true,
  tooltip_attrs? : @html.Attrs,
  tooltip_style? : Array[String] = [],
  children : C,
) -> @rabbita.Val[@html.Html] {
  let content_id = id + "-tooltip"
  let initial_model : TooltipModel = {
    open: false,
    trigger_hovered: false,
    trigger_focused: false,
    content_hovered: false,
    generation: 0,
  }
  let (model, _) = @rabbita.create_state_with_init(
    init=emit => {
      let sync = emit.map(value => TooltipNativeChanged(value))
      (
        initial_model,
        @cmd.batch([
          floating_bind_sync_cmd(content_id, sync),
          tooltip_bind_trigger_events_cmd(content_id, id, id, emit),
        ]),
      )
    },
    update=(current, msg, emit) => {
      tooltip_update(
        content_id, true, on_tooltip_open_change, emit, msg, current,
      )
    },
  )
  model.view(model => {
    render_sidebar_menu_button_with_tooltip(
      id,
      tooltip,
      model.open,
      href,
      is_active,
      variant,
      size,
      disabled,
      aria_label,
      target,
      rel,
      download,
      on_click,
      class,
      title,
      attrs,
      style,
      tooltip_side,
      tooltip_align,
      tooltip_side_offset,
      tooltip_align_offset,
      tooltip_show_arrow,
      tooltip_attrs,
      tooltip_style,
      children,
    )
  })
}

///|
#cfg(not(target="js"))
pub fn[C : @html.IsChildren] sidebar_menu_button_with_tooltip(
  id~ : String,
  tooltip~ : String,
  href? : String,
  is_active? : Bool = false,
  variant? : SidebarMenuButtonVariant = SidebarMenuButtonDefault,
  size? : SidebarMenuButtonSize = SidebarMenuDefault,
  disabled? : Bool = false,
  aria_label? : String,
  target? : @html.Target = Self,
  rel? : String,
  download? : String,
  on_click? : @cmd.Cmd,
  on_tooltip_open_change? : @cmd.Emit[Bool],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  tooltip_side? : PopupSide = Right,
  tooltip_align? : PopupAlign = Center,
  tooltip_side_offset? : Int = 4,
  tooltip_align_offset? : Int = 0,
  tooltip_show_arrow? : Bool = true,
  tooltip_attrs? : @html.Attrs,
  tooltip_style? : Array[String] = [],
  children : C,
) -> @rabbita.Val[@html.Html] {
  ignore(on_tooltip_open_change)
  @rabbita.Val::constant(
    render_sidebar_menu_button_with_tooltip(
      id, tooltip, false, href, is_active, variant, size, disabled, aria_label, target,
      rel, download, on_click, class, title, attrs, style, tooltip_side, tooltip_align,
      tooltip_side_offset, tooltip_align_offset, tooltip_show_arrow, tooltip_attrs,
      tooltip_style, children,
    ),
  )
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
        SidebarActionSizeStyle,
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
        skeleton(
          attrs=@html.Attrs::build().data_set("sidebar-skeleton-part", "icon"),
          style=["width:1rem;height:1rem;flex-shrink:0;border-radius:0.25rem"],
        )
      } else {
        @html.nothing
      },
      skeleton(
        attrs=@html.Attrs::build().data_set("sidebar-skeleton-part", "text"),
        style=[
          "display:var(--rui-sidebar-skeleton-text-display,block);height:0.75rem;width:70%;border-radius:0.25rem",
        ],
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
  if is_active && href is Some(_) {
    ignore(element_attrs.aria_current("page"))
  }
  if disabled {
    ignore(
      element_attrs.aria_disabled("true").data_set("disabled", "").tabindex(-1),
    )
  } else if on_click is Some(command) {
    ignore(element_attrs.on_click(_ => command))
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
        "width:auto;height:1px;flex-shrink:0;margin-inline:0.5rem;background:var(--rui-sidebar-border,var(--rui-border,oklch(0.922 0 0)))",
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
    input_type=Text,
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
        "height:2rem;--rui-control-base-shadow:0 0 #0000;background:var(--rui-background,oklch(1 0 0));font-size:0.875rem;line-height:1.25rem",
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
