///|
/// Explicit scope passed by [`alert_dialog`] to its compound parts.
struct AlertDialogScope(DialogScope)

///|
const AlertDialogContentStyle : String = "width:min(100%,32rem)"

///|
const AlertDialogMediaStyle : String = "display:inline-flex;width:4rem;height:4rem;flex-shrink:0;align-items:center;justify-content:center;margin-bottom:0.5rem;border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-muted,oklch(0.97 0 0));color:var(--rui-muted-foreground,oklch(0.556 0 0))"

///|
/// Create a stateful alert dialog.
///
/// Unlike [`dialog_content`], [`alert_dialog_content`] does not dismiss on an
/// overlay click and does not render an implicit close icon. A deliberate
/// action or cancel control is therefore always visible in normal use.
pub fn alert_dialog(
  id~ : String,
  default_open? : Bool = false,
  close_on_escape? : Bool = true,
  on_open_change? : @cmd.Emit[Bool],
  on_close? : @cmd.Emit[String],
  children : (AlertDialogScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  dialog(
    id~,
    default_open~,
    modal=true,
    close_on_escape~,
    on_open_change?,
    on_close?,
    scope => children(AlertDialogScope(scope)),
  )
}

///|
pub fn[C : @html.IsChildren] alert_dialog_trigger(
  scope : AlertDialogScope,
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
      "alert-dialog-trigger",
      dialog_scope.open,
    )
    .aria_haspopup("dialog")
    .aria_controls(dialog_scope.id)
    .aria_expanded(ui_bool(dialog_scope.open))
  dialog_control_button(
    slot="alert-dialog-trigger",
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
/// Pass native alert-dialog content through without adding a DOM node.
pub fn alert_dialog_portal(children : Array[@html.Html]) -> @html.Html {
  @html.fragment(children)
}

///|
/// Render the non-dismissible backdrop for an alert-dialog scope.
pub fn alert_dialog_overlay(
  scope : AlertDialogScope,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  dialog_overlay_part(
    scope.0,
    slot="alert-dialog-overlay",
    close_on_overlay=false,
    id~,
    class~,
    title~,
    hidden~,
    attrs~,
    style~,
  )
}

///|
/// Render a native `role="alertdialog"` with a non-dismissible backdrop.
pub fn[C : @html.IsChildren] alert_dialog_content(
  scope : AlertDialogScope,
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
      "alert-dialog-native",
      dialog_scope.open,
    )
    .role("alertdialog")
    .aria_modal("true")
    .data_set("modal", "true")
    .data_set("close-on-outside", "false")
    .data_set("close-on-escape", ui_bool(dialog_scope.close_on_escape))
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
    "alert-dialog-content",
    dialog_scope.open,
  )
  let positioner_attrs = dialog_state_attrs(
    None,
    "alert-dialog-positioner",
    dialog_scope.open,
  )
  let content = @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        DialogContentStyle,
        AlertDialogContentStyle,
        dialog_content_motion_style(dialog_scope.open),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=content_attrs,
    children,
  )
  let open = dialog_scope.native_open
  let on_close = dialog_scope.on_close
  let on_cancel = dialog_scope.on_cancel
  let closedby = if dialog_scope.close_on_escape {
    "closerequest"
  } else {
    "none"
  }
  alert_dialog_portal([
    @html.dialog(
      style=ui_styles([UiBoxSizing, DialogNativeStyle], native_style),
      id=dialog_scope.id,
      open?,
      closedby~,
      on_close?,
      on_cancel?,
      attrs=native_element_attrs,
      [
        alert_dialog_overlay(
          scope,
          attrs=ui_attrs(overlay_attrs),
          style=overlay_style,
        ),
        @html.div(
          style=[UiBoxSizing, DialogPositionerStyle],
          attrs=positioner_attrs,
          content,
        ),
      ],
    ),
  ])
}

///|
pub fn[C : @html.IsChildren] alert_dialog_header(
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
    attrs=ui_attrs(attrs).data_set("slot", "alert-dialog-header"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] alert_dialog_footer(
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
    attrs=ui_attrs(attrs).data_set("slot", "alert-dialog-footer"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] alert_dialog_title(
  scope : AlertDialogScope,
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
    attrs=ui_attrs(attrs).data_set("slot", "alert-dialog-title"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] alert_dialog_description(
  scope : AlertDialogScope,
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
    attrs=ui_attrs(attrs).data_set("slot", "alert-dialog-description"),
    children,
  )
}

///|
/// Render the shadcn alert-dialog media tile for an icon or illustration.
pub fn[C : @html.IsChildren] alert_dialog_media(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, AlertDialogMediaStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "alert-dialog-media"),
    children,
  )
}

///|
/// Render the primary alert-dialog action and close after its caller handler.
pub fn[C : @html.IsChildren] alert_dialog_action(
  scope : AlertDialogScope,
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
    slot="alert-dialog-action",
    command=scope.0.close_command,
    variant=Default,
    size=Default,
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

///|
/// Render the secondary alert-dialog cancel control.
pub fn[C : @html.IsChildren] alert_dialog_cancel(
  scope : AlertDialogScope,
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
  let cancel_attrs = ui_attrs(attrs).autofocus(!disabled)
  dialog_control_button(
    slot="alert-dialog-cancel",
    command=scope.0.close_command,
    variant=Outline,
    size=Default,
    disabled~,
    id~,
    class~,
    title~,
    aria_label~,
    on_click~,
    attrs=Some(cancel_attrs),
    style~,
    children,
  )
}
