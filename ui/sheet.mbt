///|
/// Edge from which a [`sheet_content`] surface enters the viewport.
pub(all) enum SheetSide {
  SheetTop
  SheetRight
  SheetBottom
  SheetLeft
} derive(Debug, Eq)

///|
/// Explicit compound-component scope created by [`sheet`].
struct SheetScope(DialogScope)

///|
const SheetPositionerStyle : String = "position:fixed;inset:0;z-index:51;display:flex;overflow:hidden;pointer-events:none"

///|
const SheetSurfaceStyle : String = "position:relative;display:flex;min-width:0;min-height:0;flex-direction:column;gap:1rem;overflow:auto;background:var(--rui-popover,var(--rui-background,oklch(1 0 0)));color:var(--rui-popover-foreground,var(--rui-foreground,oklch(0.145 0 0)));padding:1.5rem;box-shadow:0 16px 48px rgb(0 0 0 / 0.2);opacity:var(--rui-sheet-opacity,1);transform:var(--rui-sheet-transform,translate3d(0,0,0));pointer-events:auto;transition:opacity 200ms ease,transform 200ms ease"

///|
const SheetCloseButtonStyle : String = "position:absolute;top:1rem;inset-inline-end:1rem;background:var(--rui-close-bg,var(--rui-button-bg,var(--rui-button-base-bg,transparent)));color:var(--rui-close-fg,var(--rui-button-fg,var(--rui-button-base-fg,currentColor)));box-shadow:var(--rui-close-shadow,var(--rui-button-shadow,var(--rui-button-base-shadow,none)));opacity:var(--rui-close-opacity,var(--rui-close-base-opacity,0.7))"

///|
fn sheet_side_value(side : SheetSide) -> String {
  match side {
    SheetTop => "top"
    SheetRight => "right"
    SheetBottom => "bottom"
    SheetLeft => "left"
  }
}

///|
fn sheet_positioner_side_style(side : SheetSide) -> String {
  match side {
    SheetTop => "align-items:flex-start"
    SheetRight => "justify-content:flex-end"
    SheetBottom => "align-items:flex-end"
    SheetLeft => "justify-content:flex-start"
  }
}

///|
fn sheet_surface_side_style(side : SheetSide) -> String {
  match side {
    SheetTop =>
      "width:100%;max-height:85vh;border-bottom:1px solid var(--rui-border,oklch(0.922 0 0))"
    SheetRight =>
      "width:min(85vw,24rem);height:100%;border-left:1px solid var(--rui-border,oklch(0.922 0 0))"
    SheetBottom =>
      "width:100%;max-height:85vh;border-top:1px solid var(--rui-border,oklch(0.922 0 0))"
    SheetLeft =>
      "width:min(85vw,24rem);height:100%;border-right:1px solid var(--rui-border,oklch(0.922 0 0))"
  }
}

///|
fn sheet_motion_style(side : SheetSide, open : Bool) -> String {
  if open {
    "--rui-sheet-opacity:1;--rui-sheet-transform:translate3d(0,0,0)"
  } else {
    match side {
      SheetTop =>
        "--rui-sheet-opacity:0;--rui-sheet-transform:translate3d(0,-100%,0);pointer-events:none"
      SheetRight =>
        "--rui-sheet-opacity:0;--rui-sheet-transform:translate3d(100%,0,0);pointer-events:none"
      SheetBottom =>
        "--rui-sheet-opacity:0;--rui-sheet-transform:translate3d(0,100%,0);pointer-events:none"
      SheetLeft =>
        "--rui-sheet-opacity:0;--rui-sheet-transform:translate3d(-100%,0,0);pointer-events:none"
    }
  }
}

///|
fn sheet_close_icon(scope : DialogScope, label : String) -> @html.Html {
  let close_attrs = @html.Attrs::build()
    .data_set("rui-close-icon", "")
    .data_set("state", dialog_state_value(scope.open))
  dialog_control_button(
    slot="sheet-close",
    command=scope.close_command,
    variant=Ghost,
    size=IconSm,
    disabled=false,
    id=None,
    class=None,
    title=None,
    aria_label=Some(label),
    on_click=None,
    attrs=Some(close_attrs),
    style=[SheetCloseButtonStyle],
    ui_x_icon(),
  )
}

///|
/// Create a stateful edge sheet backed by native dialog behavior. Modal sheets
/// enter the browser top layer; `modal=false` leaves the page interactive. The
/// returned value participates in Rabbita's incremental renderer.
pub fn sheet(
  id~ : String,
  default_open? : Bool = false,
  modal? : Bool = true,
  close_on_escape? : Bool = true,
  on_open_change? : @cmd.Emit[Bool],
  on_close? : @cmd.Emit[String],
  children : (SheetScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  dialog(
    id~,
    default_open~,
    modal~,
    close_on_escape~,
    on_open_change?,
    on_close?,
    scope => children(SheetScope(scope)),
  )
}

///|
pub fn[C : @html.IsChildren] sheet_trigger(
  scope : SheetScope,
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
      "sheet-trigger",
      dialog_scope.open,
    )
    .aria_haspopup("dialog")
    .aria_controls(dialog_scope.id)
    .aria_expanded(ui_bool(dialog_scope.open))
  dialog_control_button(
    slot="sheet-trigger",
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
/// Render an edge-anchored sheet surface. Caller styles are appended after the
/// built-in Vega recipe, so CSS variables or individual properties can be
/// overridden without copying the component.
pub fn[C : @html.IsChildren] sheet_content(
  scope : SheetScope,
  side? : SheetSide = SheetRight,
  close_on_overlay? : Bool = true,
  show_close? : Bool = true,
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
      "sheet-native",
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
  let overlay_element_attrs = dialog_state_attrs(
    overlay_attrs,
    "sheet-overlay",
    dialog_scope.open,
  )
  if close_on_overlay {
    ignore(
      overlay_element_attrs.on_click_after(_ => {
        if ui_dialog_should_close_outside() {
          dialog_scope.close_command
        } else {
          @cmd.none
        }
      }),
    )
  }
  let content_attrs = dialog_state_attrs(
    attrs,
    "sheet-content",
    dialog_scope.open,
  ).data_set("side", sheet_side_value(side))
  let positioner_attrs = dialog_state_attrs(
    None,
    "sheet-positioner",
    dialog_scope.open,
  ).data_set("side", sheet_side_value(side))
  let content = @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        SheetSurfaceStyle,
        sheet_surface_side_style(side),
        sheet_motion_style(side, dialog_scope.open),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=content_attrs,
    [
      @html.div(style=[UiBoxSizing, "display:contents"], children),
      if show_close {
        sheet_close_icon(dialog_scope, close_label)
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
        @html.div(
          style=ui_styles(
            [
              UiBoxSizing,
              DialogOverlayStyle,
              dialog_overlay_motion_style(dialog_scope.open),
            ],
            overlay_style,
          ),
          attrs=overlay_element_attrs,
          @html.nothing,
        )
      } else {
        @html.nothing
      },
      @html.div(
        style=[
          UiBoxSizing,
          SheetPositionerStyle,
          sheet_positioner_side_style(side),
        ],
        attrs=positioner_attrs,
        content,
      ),
    ],
  )
}

///|
pub fn[C : @html.IsChildren] sheet_header(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, DialogHeaderStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "sheet-header"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] sheet_footer(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, DialogFooterStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "sheet-footer"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] sheet_title(
  scope : SheetScope,
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
    attrs=ui_attrs(attrs).data_set("slot", "sheet-title"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] sheet_description(
  scope : SheetScope,
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
    attrs=ui_attrs(attrs).data_set("slot", "sheet-description"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] sheet_close(
  scope : SheetScope,
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
    slot="sheet-close",
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
