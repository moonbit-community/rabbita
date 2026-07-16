///|
const TableContainerStyle : String = "position:relative;width:100%;max-width:100%;overflow-x:auto"

///|
const TableBaseStyle : String = "width:100%;border-collapse:collapse;caption-side:bottom;color:var(--rui-foreground,oklch(0.145 0 0));font-size:0.875rem;line-height:1.25rem"

///|
const TableHeaderStyle : String = "display:table-header-group"

///|
const TableBodyStyle : String = "display:table-row-group"

///|
const TableFooterStyle : String = "display:table-footer-group;border-top:1px solid var(--rui-border,oklch(0.922 0 0));background:color-mix(in oklab,var(--rui-muted,oklch(0.97 0 0)) 50%,transparent);font-weight:500"

///|
const TableRowStyle : String = "border-bottom:1px solid var(--rui-border,oklch(0.922 0 0));background:var(--rui-table-row-bg,var(--rui-table-row-base-bg,transparent));transition:background-color 150ms ease"

///|
const TableRowSelectedStyle : String = "--rui-table-row-base-bg:var(--rui-muted,oklch(0.97 0 0))"

///|
const TableRowExpandedStyle : String = "--rui-table-row-base-bg:color-mix(in oklab,var(--rui-muted,oklch(0.97 0 0)) 50%,transparent)"

///|
const TableHeadStyle : String = "height:2.5rem;padding-inline:0.5rem;color:var(--rui-foreground,oklch(0.145 0 0));text-align:start;vertical-align:middle;font-weight:500;white-space:nowrap"

///|
const TableCellStyle : String = "padding:0.5rem;vertical-align:middle;white-space:nowrap"

///|
const TableCaptionStyle : String = "margin-top:1rem;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem;line-height:1.25rem"

///|
fn table_part_attrs(attrs : @html.Attrs?, slot : String) -> @html.Attrs {
  ui_attrs(attrs).data_set("slot", slot)
}

///|
fn table_row_state_style(selected : Bool, expanded : Bool) -> String {
  if selected {
    TableRowSelectedStyle
  } else if expanded {
    TableRowExpandedStyle
  } else {
    ""
  }
}

///|
/// Render a semantic native table inside Vega's horizontal-scroll container.
///
/// `style` and `attrs` belong to the native `table`; use `container_style` and
/// `container_attrs` when the scroll wrapper needs customization.
pub fn[C : @html.IsChildren] table(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  container_attrs? : @html.Attrs,
  container_style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let table_node = @html.table(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, TableBaseStyle],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=table_part_attrs(attrs, "table"),
    children,
  )
  @html.div(
    style=ui_styles([UiBoxSizing, TableContainerStyle], container_style),
    attrs=table_part_attrs(container_attrs, "table-container"),
    table_node,
  )
}

///|
pub fn[C : @html.IsChildren] table_header(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.thead(
    style=ui_styles([UiBoxSizing, TableHeaderStyle], style),
    id?,
    class?,
    title?,
    hidden?,
    attrs=table_part_attrs(attrs, "table-header"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] table_body(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.tbody(
    style=ui_styles([UiBoxSizing, TableBodyStyle], style),
    id?,
    class?,
    title?,
    hidden?,
    attrs=table_part_attrs(attrs, "table-body"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] table_footer(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.tfoot(
    style=ui_styles([UiBoxSizing, TableFooterStyle], style),
    id?,
    class?,
    title?,
    hidden?,
    attrs=table_part_attrs(attrs, "table-footer"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] table_row(
  selected? : Bool = false,
  expanded? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = table_part_attrs(attrs, "table-row")
  if selected {
    ignore(element_attrs.data_set("state", "selected").data_set("selected", ""))
  }
  if expanded {
    ignore(
      element_attrs
      .data_set("expanded", "")
      .data_set("state", if selected { "selected" } else { "expanded" }),
    )
  }
  @html.tr(
    style=ui_styles(
      [UiBoxSizing, TableRowStyle, table_row_state_style(selected, expanded)],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=element_attrs,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] table_head(
  scope? : @html.Scope = Col,
  abbr? : String,
  colspan? : Int,
  rowspan? : Int,
  headers? : String,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.th(
    style=ui_styles([UiBoxSizing, TableHeadStyle], style),
    id?,
    abbr?,
    colspan?,
    rowspan?,
    headers?,
    scope~,
    class?,
    title?,
    hidden?,
    attrs=table_part_attrs(attrs, "table-head"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] table_cell(
  colspan? : Int,
  rowspan? : Int,
  headers? : String,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.td(
    style=ui_styles([UiBoxSizing, TableCellStyle], style),
    id?,
    colspan?,
    rowspan?,
    headers?,
    class?,
    title?,
    hidden?,
    attrs=table_part_attrs(attrs, "table-cell"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] table_caption(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.caption(
    style=ui_styles([UiBoxSizing, TableCaptionStyle], style),
    id?,
    class?,
    title?,
    hidden?,
    attrs=table_part_attrs(attrs, "table-caption"),
    children,
  )
}
