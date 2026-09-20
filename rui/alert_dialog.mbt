///|
const AlertDialogMediaStyle : String = "display:inline-flex;width:4rem;height:4rem;flex-shrink:0;align-items:center;justify-content:center;margin-bottom:0.5rem;border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-muted,oklch(0.97 0 0));color:var(--rui-muted-foreground,oklch(0.556 0 0))"

///|
/// Render a native alert dialog without component state or an implicit close icon.
/// Open it with `@rabbita/dialog.show(id)` and use a `<form method="dialog">`
/// for its action and cancel buttons. Outside clicks do not dismiss it by default.
/// Title/description IDs and native events follow [`dialog`].
pub fn[C : @html.IsChildren] alert_dialog(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  open? : Bool,
  closedby? : String = "closerequest",
  on_close? : @cmd.Emit[String],
  on_cancel? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.dialog(
    id?,
    class?,
    title?,
    hidden?,
    open?,
    closedby~,
    on_close?,
    on_cancel?,
    attrs=ui_attrs(attrs).role("alertdialog").data_set("slot", "alert-dialog"),
    style=ui_styles([UiBoxSizing, DialogStyle], style),
    children,
  )
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
    style=ui_styles(
      [UiBoxSizing, DialogHeaderStyle, "margin-block-end:1rem"],
      style,
    ),
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
    style=ui_styles(
      [UiBoxSizing, DialogFooterStyle, "margin-block-start:1rem"],
      style,
    ),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "alert-dialog-footer"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] alert_dialog_title(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.h2(
    style=ui_styles([UiBoxSizing, DialogTitleStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "alert-dialog-title"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] alert_dialog_description(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.p(
    style=ui_styles([UiBoxSizing, DialogDescriptionStyle], style),
    id?,
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
/// Render the primary submit button for a `<form method="dialog">`.
pub fn[C : @html.IsChildren] alert_dialog_action(
  disabled? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  value? : String,
  on_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs)
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  }
  button(
    slot="alert-dialog-action",
    variant=Default,
    type_="submit",
    disabled~,
    id?,
    class?,
    title?,
    value?,
    on_click?,
    attrs=element_attrs,
    style~,
    children,
  )
}

///|
/// Render a cancel submit button with autofocus and no form validation.
pub fn[C : @html.IsChildren] alert_dialog_cancel(
  disabled? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  value? : String,
  on_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs).formnovalidate(true)
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  }
  button(
    slot="alert-dialog-cancel",
    variant=Outline,
    type_="submit",
    disabled~,
    id?,
    class?,
    title?,
    value?,
    autofocus=!disabled,
    on_click?,
    attrs=element_attrs,
    style~,
    children,
  )
}
