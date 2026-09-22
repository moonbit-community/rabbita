///|
/// Edge from which a [`sheet`] enters the viewport.
pub(all) enum SheetSide {
  SheetTop
  SheetRight
  SheetBottom
  SheetLeft
} derive(Debug, Eq)

///|
pub extend SheetSide with Debug::{to_repr}

///|
pub extend SheetSide with Eq::{equal, not_equal}

///|
const SheetStyle : String = "min-width:0;min-height:0;max-height:100dvh;margin:0;border:0;border-radius:0;box-shadow:0 16px 48px rgb(0 0 0 / 0.2)"

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
fn sheet_side_style(side : SheetSide) -> String {
  match side {
    SheetTop =>
      "inset:0 0 auto;width:100%;max-height:85dvh;border-bottom:1px solid var(--rui-border,oklch(0.922 0 0))"
    SheetRight =>
      "inset:0 0 0 auto;width:min(85vw,24rem);height:100dvh;border-left:1px solid var(--rui-border,oklch(0.922 0 0))"
    SheetBottom =>
      "inset:auto 0 0;width:100%;max-height:85dvh;border-top:1px solid var(--rui-border,oklch(0.922 0 0))"
    SheetLeft =>
      "inset:0 auto 0 0;width:min(85vw,24rem);height:100dvh;border-right:1px solid var(--rui-border,oklch(0.922 0 0))"
  }
}

///|
fn sheet_closed_transform(side : SheetSide) -> String {
  match side {
    SheetTop => "translate3d(0,-2.5rem,0)"
    SheetRight => "translate3d(2.5rem,0,0)"
    SheetBottom => "translate3d(0,2.5rem,0)"
    SheetLeft => "translate3d(-2.5rem,0,0)"
  }
}

///|
/// Render an edge-anchored native dialog without component state.
/// Open it with `@rabbita/dialog.show(id)` and close it with a
/// `<form method="dialog">` or `@rabbita/dialog.close(id)`.
/// Native dismissal, events and title/description IDs follow [`dialog`].
pub fn[C : @html.IsChildren] sheet(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  side? : SheetSide = SheetRight,
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
    attrs=ui_attrs(attrs)
      .data_set("slot", "sheet")
      .data_set("side", sheet_side_value(side)),
    style=ui_styles(
      [
        UiBoxSizing,
        DialogStyle,
        SheetStyle,
        sheet_side_style(side),
        "--rui-dialog-closed-transform:" + sheet_closed_transform(side),
      ],
      style,
    ),
    [
      @html.div(style=[UiBoxSizing, "display:contents"], children),
      if show_close {
        @html.form(
          method_="dialog",
          style=["position:absolute;top:1rem;inset-inline-end:1rem"],
          button(
            variant=Ghost,
            size=IconSm,
            type_="submit",
            slot="sheet-close",
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
pub fn[C : @html.IsChildren] sheet_header(
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
    style=ui_styles(
      [UiBoxSizing, DialogFooterStyle, "margin-block-start:1rem"],
      style,
    ),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "sheet-footer"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] sheet_title(
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
    attrs=ui_attrs(attrs).data_set("slot", "sheet-title"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] sheet_description(
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
    attrs=ui_attrs(attrs).data_set("slot", "sheet-description"),
    children,
  )
}
