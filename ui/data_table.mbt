///|
/// One typed column in a black-box `data_table`.
///
/// `value` supplies the searchable and sortable text. `render`, when present,
/// only changes the visual cell content, so formatting never breaks table
/// operations.
struct DataTableColumn[T] {
  key : String
  label : String
  value : (T) -> String
  render : ((T) -> @html.Html)?
  sortable : Bool
  searchable : Bool
  hideable : Bool
  numeric : Bool
}

///|
priv struct DataTableModel {
  query : String
  sort_key : String?
  sort_descending : Bool
  page : Int
  selected : Array[String]
  hidden_columns : Array[String]
  columns_open : Bool
} derive(Eq)

///|
priv enum DataTableMsg {
  DataTableSetQuery(String)
  DataTableSort(String)
  DataTableSetPage(Int)
  DataTableSetSelection(Array[String])
  DataTableToggleColumn(String)
  DataTableToggleColumns
}

///|
const DataTableRootStyle : String = "position:relative;display:flex;width:100%;min-width:0;flex-direction:column;gap:1rem;color:var(--rui-foreground,oklch(0.145 0 0))"

///|
const DataTableToolbarStyle : String = "position:relative;z-index:2;display:flex;width:100%;min-width:0;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:0.75rem"

///|
const DataTableSearchStyle : String = "width:min(20rem,100%)"

///|
const DataTableColumnsWrapStyle : String = "position:relative;display:inline-flex;margin-inline-start:auto"

///|
const DataTableColumnsMenuStyle : String = "position:absolute;inset-block-start:calc(100% + 0.375rem);inset-inline-end:0;z-index:20;display:flex;min-width:11rem;flex-direction:column;gap:0.125rem;border:1px solid color-mix(in oklab,var(--rui-foreground,oklch(0.145 0 0)) 10%,transparent);border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-popover,oklch(1 0 0));padding:0.25rem;color:var(--rui-popover-foreground,oklch(0.145 0 0));box-shadow:0 10px 15px -3px rgb(0 0 0 / 0.1),0 4px 6px -4px rgb(0 0 0 / 0.1);transform-origin:top right;transition:opacity 100ms ease,transform 100ms ease,visibility 100ms ease"

///|
const DataTableColumnsMenuOpenStyle : String = "visibility:visible;opacity:1;pointer-events:auto;transform:scale(1)"

///|
const DataTableColumnsMenuClosedStyle : String = "visibility:hidden;opacity:0;pointer-events:none;transform:scale(0.96)"

///|
const DataTableColumnOptionStyle : String = "display:flex;width:100%;min-height:2rem;align-items:center;gap:0.5rem;border-radius:calc(var(--rui-radius,0.625rem) - 0.25rem);padding:0.375rem 0.5rem;font-size:0.875rem;line-height:1.25rem;text-transform:capitalize;white-space:nowrap"

///|
const DataTableSurfaceStyle : String = "overflow:hidden;border:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem)"

///|
const DataTableSortButtonStyle : String = "height:2rem;margin-inline-start:-0.5rem;padding-inline:0.5rem"

///|
const DataTableSortIconStyle : String = "display:inline-flex;width:1rem;height:1rem;align-items:center;justify-content:center;color:var(--rui-muted-foreground,oklch(0.556 0 0))"

///|
const DataTableEmptyStyle : String = "height:7rem;color:var(--rui-muted-foreground,oklch(0.556 0 0));text-align:center"

///|
const DataTableFooterStyle : String = "display:flex;width:100%;min-width:0;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:0.75rem"

///|
const DataTableSummaryStyle : String = "color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.8125rem;line-height:1.25rem"

///|
const DataTablePagerStyle : String = "display:flex;align-items:center;gap:0.5rem"

///|
const DataTablePageLabelStyle : String = "min-width:5.5rem;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.8125rem;line-height:1.25rem;text-align:center"

///|
/// Construct a typed column for `data_table`.
pub fn[T] data_table_column(
  key~ : String,
  label~ : String,
  value~ : (T) -> String,
  render? : (T) -> @html.Html,
  sortable? : Bool = true,
  searchable? : Bool = true,
  hideable? : Bool = true,
  numeric? : Bool = false,
) -> DataTableColumn[T] {
  { key, label, value, render, sortable, searchable, hideable, numeric }
}

///|
fn data_table_contains(values : Array[String], value : String) -> Bool {
  for current in values {
    if current == value {
      return true
    }
  }
  false
}

///|
fn data_table_remove(values : Array[String], value : String) -> Array[String] {
  let result : Array[String] = []
  for current in values {
    if current != value {
      result.push(current)
    }
  }
  result
}

///|
fn data_table_toggle(values : Array[String], value : String) -> Array[String] {
  if data_table_contains(values, value) {
    data_table_remove(values, value)
  } else {
    let result = values.copy()
    result.push(value)
    result
  }
}

///|
fn[T] data_table_column_index(
  columns : Array[DataTableColumn[T]],
  key : String,
) -> Int {
  for index, column in columns {
    if column.key == key {
      return index
    }
  }
  -1
}

///|
fn[T] data_table_row_matches(
  row : T,
  columns : Array[DataTableColumn[T]],
  query : String,
) -> Bool {
  if query == "" {
    return true
  }
  let needle = query.to_lower()
  for column in columns {
    if column.searchable && (column.value)(row).to_lower().contains(needle) {
      return true
    }
  }
  false
}

///|
fn[T] data_table_visible_indices(
  rows : Array[T],
  columns : Array[DataTableColumn[T]],
  model : DataTableModel,
) -> Array[Int] {
  let indices : Array[Int] = []
  for index, row in rows {
    if data_table_row_matches(row, columns, model.query) {
      indices.push(index)
    }
  }
  if model.sort_key is Some(key) {
    let column_index = data_table_column_index(columns, key)
    if column_index >= 0 && columns[column_index].sortable {
      let column = columns[column_index]
      indices.sort_by((left, right) => {
        let order = (column.value)(rows[left]).compare(
          (column.value)(rows[right]),
        )
        if model.sort_descending {
          -order
        } else {
          order
        }
      })
    }
  }
  indices
}

///|
fn data_table_page_count(row_count : Int, page_size : Int) -> Int {
  if row_count == 0 {
    1
  } else {
    (row_count + page_size - 1) / page_size
  }
}

///|
fn data_table_effective_page(page : Int, page_count : Int) -> Int {
  if page < 0 {
    0
  } else if page >= page_count {
    page_count - 1
  } else {
    page
  }
}

///|
fn data_table_command(
  emit : @cmd.Emit[DataTableMsg]?,
  message : DataTableMsg,
) -> @cmd.Cmd? {
  if emit is Some(emit) {
    Some(emit(message))
  } else {
    None
  }
}

///|
fn data_table_value_emit(
  emit : @cmd.Emit[DataTableMsg]?,
  wrap : (String) -> DataTableMsg,
) -> @cmd.Emit[String]? {
  if emit is Some(emit) {
    Some(emit.map(wrap))
  } else {
    None
  }
}

///|
fn data_table_bool_emit(
  emit : @cmd.Emit[DataTableMsg]?,
  wrap : (Bool) -> DataTableMsg,
) -> @cmd.Emit[Bool]? {
  if emit is Some(emit) {
    Some(emit.map(wrap))
  } else {
    None
  }
}

///|
fn[T] data_table_render_cell(
  column : DataTableColumn[T],
  row : T,
) -> @html.Html {
  if column.render is Some(render) {
    render(row)
  } else {
    @html.text((column.value)(row))
  }
}

///|
fn[T] render_data_table(
  id : String,
  rows : Array[T],
  columns : Array[DataTableColumn[T]],
  row_key : (T) -> String,
  model : DataTableModel,
  page_size : Int,
  searchable : Bool,
  selectable : Bool,
  show_columns : Bool,
  search_placeholder : String,
  empty_text : String,
  aria_label : String,
  emit : @cmd.Emit[DataTableMsg]?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
) -> @html.Html {
  let visible_indices = data_table_visible_indices(rows, columns, model)
  let page_count = data_table_page_count(visible_indices.length(), page_size)
  let page = data_table_effective_page(model.page, page_count)
  let page_start = page * page_size
  let page_end = if page_start + page_size < visible_indices.length() {
    page_start + page_size
  } else {
    visible_indices.length()
  }
  let page_keys : Array[String] = []
  for position, row_index in visible_indices {
    if position >= page_start && position < page_end {
      page_keys.push(row_key(rows[row_index]))
    }
  }
  let selected_on_page = page_keys.fold(init=0, (count, key) => {
    if data_table_contains(model.selected, key) {
      count + 1
    } else {
      count
    }
  })
  let selected_visible = visible_indices.fold(init=0, (count, row_index) => {
    if data_table_contains(model.selected, row_key(rows[row_index])) {
      count + 1
    } else {
      count
    }
  })
  let all_page_selected = page_keys.length() > 0 &&
    selected_on_page == page_keys.length()
  let some_page_selected = selected_on_page > 0 && !all_page_selected
  let header_cells : Array[@html.Html] = []
  if selectable {
    let next_selection = if all_page_selected {
      model.selected.filter(key => !data_table_contains(page_keys, key))
    } else {
      let selected = model.selected.copy()
      for key in page_keys {
        if !data_table_contains(selected, key) {
          selected.push(key)
        }
      }
      selected
    }
    let on_checked_change = data_table_bool_emit(emit, _ => {
      DataTableSetSelection(next_selection)
    })
    header_cells.push(
      table_head(
        style=["width:2.75rem;padding-inline:0.75rem"],
        render_checkbox(
          checked=all_page_selected,
          indeterminate=some_page_selected,
          disabled=page_keys.length() == 0,
          aria_label="Select all rows on this page",
          on_checked_change?,
        ),
      ),
    )
  }
  for column in columns {
    if !data_table_contains(model.hidden_columns, column.key) {
      let active = model.sort_key == Some(column.key)
      let sort_attrs = @html.Attrs::build()
        .data_set("slot", "data-table-sort-trigger")
        .data_set("column", column.key)
      let on_click = data_table_command(emit, DataTableSort(column.key))
      let head_attrs = @html.Attrs::build()
      if active {
        ignore(
          head_attrs.aria_sort(
            if model.sort_descending {
              "descending"
            } else {
              "ascending"
            },
          ),
        )
      } else if column.sortable {
        ignore(head_attrs.aria_sort("none"))
      }
      let heading = if column.sortable {
        button(
          variant=Ghost,
          size=Sm,
          on_click?,
          attrs=sort_attrs,
          style=[DataTableSortButtonStyle],
          slot="data-table-sort-trigger",
          [
            @html.span(column.label),
            @html.span(
              attrs=@html.Attrs::build()
                .data_set("slot", "data-table-sort-icon")
                .aria_hidden("true"),
              style=[
                DataTableSortIconStyle,
                if active {
                  "opacity:1"
                } else {
                  "opacity:0.35"
                },
              ],
              if active && model.sort_descending {
                ui_chevron_down_icon()
              } else {
                ui_chevron_up_icon()
              },
            ),
          ],
        )
      } else {
        @html.text(column.label)
      }
      header_cells.push(
        table_head(
          attrs=head_attrs,
          style=[if column.numeric { "text-align:end" } else { "" }],
          heading,
        ),
      )
    }
  }
  let body_rows : Array[@html.Html] = []
  for position, row_index in visible_indices {
    if position >= page_start && position < page_end {
      let row = rows[row_index]
      let key = row_key(row)
      let selected = data_table_contains(model.selected, key)
      let cells : Array[@html.Html] = []
      if selectable {
        let next = if selected {
          data_table_remove(model.selected, key)
        } else {
          let selected = model.selected.copy()
          selected.push(key)
          selected
        }
        let on_checked_change = data_table_bool_emit(emit, _ => {
          DataTableSetSelection(next)
        })
        cells.push(
          table_cell(
            style=["width:2.75rem;padding-inline:0.75rem"],
            render_checkbox(
              checked=selected,
              aria_label="Select row \{key}",
              on_checked_change?,
            ),
          ),
        )
      }
      for column in columns {
        if !data_table_contains(model.hidden_columns, column.key) {
          cells.push(
            table_cell(
              style=[if column.numeric { "text-align:end" } else { "" }],
              data_table_render_cell(column, row),
            ),
          )
        }
      }
      body_rows.push(
        table_row(
          selected~,
          attrs=@html.Attrs::build()
            .data_set("data-table-row", "")
            .data_set("row-key", key),
          cells,
        ),
      )
    }
  }
  if body_rows.length() == 0 {
    let visible_column_count = columns.fold(init=0, (count, column) => {
      if data_table_contains(model.hidden_columns, column.key) {
        count
      } else {
        count + 1
      }
    })
    let colspan = visible_column_count + (if selectable { 1 } else { 0 })
    body_rows.push(
      table_row(table_cell(colspan~, style=[DataTableEmptyStyle], empty_text)),
    )
  }
  let toolbar_children : Array[@html.Html] = []
  if searchable {
    let on_input = data_table_value_emit(emit, query => DataTableSetQuery(query))
    toolbar_children.push(
      input(
        input_type=@html.Search,
        value=model.query,
        placeholder=search_placeholder,
        on_input?,
        attrs=@html.Attrs::build().aria_label("Filter rows"),
        style=[DataTableSearchStyle],
        slot="data-table-search",
      ),
    )
  }
  if show_columns {
    let menu_items : Array[@html.Html] = []
    for column in columns {
      if column.hideable {
        let visible = !data_table_contains(model.hidden_columns, column.key)
        let on_checked_change = data_table_bool_emit(emit, _ => {
          DataTableToggleColumn(column.key)
        })
        menu_items.push(
          @html.label(style=[DataTableColumnOptionStyle], [
            render_checkbox(
              checked=visible,
              aria_label="Toggle \{column.label} column",
              on_checked_change?,
            ),
            @html.span(column.label),
          ]),
        )
      }
    }
    let toggle_columns = data_table_command(emit, DataTableToggleColumns)
    let trigger_attrs = @html.Attrs::build()
      .data_set("slot", "data-table-columns-trigger")
      .aria_haspopup("menu")
      .aria_expanded(ui_bool(model.columns_open))
      .aria_controls("\{id}-columns-menu")
    toolbar_children.push(
      @html.div(style=[DataTableColumnsWrapStyle], [
        button(
          variant=Outline,
          size=Sm,
          on_click?=toggle_columns,
          attrs=trigger_attrs,
          slot="data-table-columns-trigger",
          [@html.span("Columns"), ui_chevron_down_icon()],
        ),
        @html.div(
          id="\{id}-columns-menu",
          attrs=@html.Attrs::build()
            .data_set("slot", "data-table-columns-menu")
            .data_set(
              "state",
              if model.columns_open {
                "open"
              } else {
                "closed"
              },
            )
            .role("menu")
            .aria_hidden(ui_bool(!model.columns_open)),
          style=[
            DataTableColumnsMenuStyle,
            if model.columns_open {
              DataTableColumnsMenuOpenStyle
            } else {
              DataTableColumnsMenuClosedStyle
            },
          ],
          menu_items,
        ),
      ]),
    )
  }
  let previous = data_table_command(emit, DataTableSetPage(page - 1))
  let next = data_table_command(emit, DataTableSetPage(page + 1))
  let root_attrs = ui_attrs(attrs)
    .data_set("slot", "data-table")
    .data_set("page", "\{page + 1}")
    .data_set("page-count", "\{page_count}")
    .data_set("row-count", "\{visible_indices.length()}")
  @html.div(
    id~,
    class?,
    title?,
    attrs=root_attrs,
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, DataTableRootStyle],
      style,
    ),
    [
      if toolbar_children.length() > 0 {
        @html.div(
          attrs=@html.Attrs::build().data_set("slot", "data-table-toolbar"),
          style=[DataTableToolbarStyle],
          toolbar_children,
        )
      } else {
        @html.nothing
      },
      @html.div(
        attrs=@html.Attrs::build().data_set("slot", "data-table-surface"),
        style=[DataTableSurfaceStyle],
        table(attrs=@html.Attrs::build().aria_label(aria_label), [
          table_header(table_row(header_cells)),
          table_body(body_rows),
        ]),
      ),
      @html.div(
        attrs=@html.Attrs::build().data_set("slot", "data-table-footer"),
        style=[DataTableFooterStyle],
        [
          @html.div(
            attrs=@html.Attrs::build().data_set(
              "slot", "data-table-selection-summary",
            ),
            style=[DataTableSummaryStyle],
            if selectable {
              "\{selected_visible} of \{visible_indices.length()} row(s) selected."
            } else {
              "\{visible_indices.length()} row(s)."
            },
          ),
          @html.div(style=[DataTablePagerStyle], [
            button(
              variant=Outline,
              size=Sm,
              disabled=page == 0,
              on_click?=previous,
              attrs=@html.Attrs::build().data_set("slot", "data-table-previous"),
              slot="data-table-previous",
              "Previous",
            ),
            @html.span(
              attrs=@html.Attrs::build()
                .data_set("slot", "data-table-page-label")
                .aria_live("polite"),
              style=[DataTablePageLabelStyle],
              "Page \{page + 1} of \{page_count}",
            ),
            button(
              variant=Outline,
              size=Sm,
              disabled=page >= page_count - 1,
              on_click?=next,
              attrs=@html.Attrs::build().data_set("slot", "data-table-next"),
              slot="data-table-next",
              "Next",
            ),
          ]),
        ],
      ),
    ],
  )
}

///|
fn data_table_update(
  message : DataTableMsg,
  model : DataTableModel,
) -> DataTableModel {
  match message {
    DataTableSetQuery(query) => { ..model, query, page: 0 }
    DataTableSort(key) =>
      if model.sort_key == Some(key) {
        { ..model, sort_descending: !model.sort_descending, page: 0 }
      } else {
        { ..model, sort_key: Some(key), sort_descending: false, page: 0 }
      }
    DataTableSetPage(page) => { ..model, page, }
    DataTableSetSelection(selected) => { ..model, selected, }
    DataTableToggleColumn(key) =>
      { ..model, hidden_columns: data_table_toggle(model.hidden_columns, key) }
    DataTableToggleColumns => { ..model, columns_open: !model.columns_open }
  }
}

///|
fn data_table_initial_model(
  default_sort_key : String?,
  default_sort_descending : Bool,
  default_selected : Array[String],
  default_hidden_columns : Array[String],
) -> DataTableModel {
  {
    query: "",
    sort_key: default_sort_key,
    sort_descending: default_sort_descending,
    page: 0,
    selected: default_selected.copy(),
    hidden_columns: default_hidden_columns.copy(),
    columns_open: false,
  }
}

///|
/// Build a typed, self-contained data table with local filter, sort,
/// pagination, row-selection, and column-visibility state.
#cfg(target="js")
pub fn[T] data_table(
  id~ : String,
  rows~ : Array[T],
  columns~ : Array[DataTableColumn[T]],
  row_key~ : (T) -> String,
  page_size? : Int = 5,
  searchable? : Bool = true,
  selectable? : Bool = true,
  show_columns? : Bool = true,
  search_placeholder? : String = "Filter rows…",
  empty_text? : String = "No results.",
  aria_label? : String = "Data table",
  default_sort_key? : String,
  default_sort_descending? : Bool = false,
  default_selected? : Array[String] = [],
  default_hidden_columns? : Array[String] = [],
  on_selection_change? : @cmd.Emit[Array[String]],
  on_query_change? : @cmd.Emit[String],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @rabbita.Val[@html.Html] {
  let initial = data_table_initial_model(
    default_sort_key, default_sort_descending, default_selected, default_hidden_columns,
  )
  let page_size = if page_size < 1 { 1 } else { page_size }
  let (model, emit) = @rabbita.create_state(initial, update=fn(
    _,
    message,
    current,
  ) {
    let next = data_table_update(message, current)
    let commands : Array[@cmd.Cmd] = []
    match message {
      DataTableSetSelection(_) =>
        if on_selection_change is Some(notify) {
          commands.push(notify(next.selected))
        }
      DataTableSetQuery(_) =>
        if on_query_change is Some(notify) {
          commands.push(notify(next.query))
        }
      _ => ()
    }
    (next, @cmd.batch(commands))
  })
  model.view(model => {
    render_data_table(
      id,
      rows,
      columns,
      row_key,
      model,
      page_size,
      searchable,
      selectable,
      show_columns,
      search_placeholder,
      empty_text,
      aria_label,
      Some(emit),
      class,
      title,
      attrs,
      style,
    )
  })
}

///|
/// Native/SSR fallback: render the requested initial table state as a
/// constant incremental value.
#cfg(not(target="js"))
pub fn[T] data_table(
  id~ : String,
  rows~ : Array[T],
  columns~ : Array[DataTableColumn[T]],
  row_key~ : (T) -> String,
  page_size? : Int = 5,
  searchable? : Bool = true,
  selectable? : Bool = true,
  show_columns? : Bool = true,
  search_placeholder? : String = "Filter rows…",
  empty_text? : String = "No results.",
  aria_label? : String = "Data table",
  default_sort_key? : String,
  default_sort_descending? : Bool = false,
  default_selected? : Array[String] = [],
  default_hidden_columns? : Array[String] = [],
  on_selection_change? : @cmd.Emit[Array[String]],
  on_query_change? : @cmd.Emit[String],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @rabbita.Val[@html.Html] {
  ignore((on_selection_change, on_query_change))
  let page_size = if page_size < 1 { 1 } else { page_size }
  @rabbita.Val::constant(
    render_data_table(
      id,
      rows,
      columns,
      row_key,
      data_table_initial_model(
        default_sort_key, default_sort_descending, default_selected, default_hidden_columns,
      ),
      page_size,
      searchable,
      selectable,
      show_columns,
      search_placeholder,
      empty_text,
      aria_label,
      None,
      class,
      title,
      attrs,
      style,
    ),
  )
}
