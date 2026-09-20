///|
const DialogStyle : String = "position:fixed;inset:0;width:min(calc(100% - 2rem),32rem);max-width:none;max-height:calc(100vh - 2rem);margin:auto;overflow-y:auto;border:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:var(--rui-radius,0.625rem);background:var(--rui-popover,var(--rui-background,oklch(1 0 0)));padding:1.5rem;color:var(--rui-popover-foreground,var(--rui-foreground,oklch(0.145 0 0)));box-shadow:0 16px 48px rgb(0 0 0 / 0.18)"

///|
/// Render a styled native dialog without component state.
///
/// Open it with `@rabbita/dialog.show(id)` (or `modal=false` for a non-modal
/// dialog), and close it with a `<form method="dialog">` submit button or
/// `@rabbita/dialog.close(id)`. The browser owns visibility and focus.
/// `open=true` renders an initially open, non-modal dialog.
///
/// Give the title and description IDs and link them with `aria_labelledby`
/// and `aria_describedby` in `attrs`, or provide an `aria_label` there.
/// `closedby` controls native dismissal: `"any"` allows outside clicks and
/// Escape, `"closerequest"` allows Escape, and `"none"` requires an explicit
/// close. As with `@html.dialog`, supplying `on_cancel` prevents the default
/// close so the caller can decide how to handle the request.
pub fn[C : @html.IsChildren] dialog(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  open? : Bool,
  closedby? : String = "any",
  show_close? : Bool = true,
  close_label? : String = "Close",
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
    attrs=ui_attrs(attrs).data_set("slot", "dialog"),
    style=ui_styles([UiBoxSizing, DialogStyle], style),
    [
      @html.div(style=[UiBoxSizing, "display:contents"], children),
      if show_close {
        @html.form(
          attrs=@html.Attrs::build().method_("dialog"),
          style=["position:absolute;top:1rem;inset-inline-end:1rem"],
          button(
            variant=Ghost,
            size=IconSm,
            type_="submit",
            slot="dialog-close",
            attrs=@html.Attrs::build()
              .aria_label(close_label)
              .formnovalidate(true)
              .data_set("rui-close-icon", ""),
            style=[DialogCloseIconButtonStyle],
            @html.span(
              attrs=@html.Attrs::build().aria_hidden("true"),
              ui_x_icon(),
            ),
          ),
        )
      } else {
        @html.nothing
      },
    ],
  )
}

///|
const DialogCloseIconButtonStyle : String = "background:var(--rui-close-bg,var(--rui-button-bg,var(--rui-button-base-bg,transparent)));color:var(--rui-close-fg,var(--rui-button-fg,var(--rui-button-base-fg,currentColor)));box-shadow:var(--rui-close-shadow,var(--rui-button-shadow,var(--rui-button-base-shadow,none)));opacity:var(--rui-close-opacity,var(--rui-close-base-opacity,0.7))"

///|
const DialogDescriptionStyle : String = "margin:0;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem;line-height:1.5;text-wrap:pretty"

///|
const DialogTitleStyle : String = "margin:0;color:var(--rui-foreground,oklch(0.145 0 0));font-size:1.125rem;line-height:1.25;font-weight:600;letter-spacing:-0.01em;text-wrap:balance"

///|
const DialogFooterStyle : String = "display:flex;flex-wrap:wrap;align-items:center;justify-content:flex-end;gap:0.5rem"

///|
const DialogHeaderStyle : String = "display:flex;min-width:0;flex-direction:column;gap:0.375rem;text-align:start"

///|
/// Render the heading group with default spacing below it.
pub fn[C : @html.IsChildren] dialog_header(
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
    attrs=ui_attrs(attrs).data_set("slot", "dialog-header"),
    children,
  )
}

///|
/// Render the action row with default spacing above it, including inside forms.
pub fn[C : @html.IsChildren] dialog_footer(
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
    attrs=ui_attrs(attrs).data_set("slot", "dialog-footer"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] dialog_title(
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
    attrs=ui_attrs(attrs).data_set("slot", "dialog-title"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] dialog_description(
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
    attrs=ui_attrs(attrs).data_set("slot", "dialog-description"),
    children,
  )
}
