///|
using @rabbita {type Cmd, type Emit, type Html, type Val}

///|
using @html {type Attrs, button, div, h1, node, span, table, tbody, td, tr}

///|
using @ref {type Ref}

///|
let adjectives : Array[String] = [
  "pretty", "large", "big", "small", "tall", "short", "long", "handsome", "plain",
  "quaint", "clean", "elegant", "easy", "angry", "crazy", "helpful", "mushy", "odd",
  "unsightly", "adorable", "important", "inexpensive", "cheap", "expensive", "fancy",
]

///|
let colours : Array[String] = [
  "red", "yellow", "blue", "green", "pink", "brown", "purple", "brown", "white",
  "black", "orange",
]

///|
let nouns : Array[String] = [
  "table", "chair", "house", "bbq", "desk", "car", "pony", "cookie", "sandwich",
  "burger", "pizza", "mouse", "keyboard",
]

///|
extern "js" fn random_index(max : Int) -> Int = "(max) => Math.round(Math.random() * 1000) % max"

///|
priv struct Row {
  id : Int
  label : String
  view_version : Int
} derive(Eq)

///|
fn build_data(count : Int, next_id : Ref[Int]) -> Array[Row] {
  Array::makei(count, _ => {
    let row = {
      id: next_id.val,
      label: adjectives[random_index(adjectives.length())] +
      " " +
      colours[random_index(colours.length())] +
      " " +
      nouns[random_index(nouns.length())],
      view_version: 0,
    }
    next_id.val = next_id.val + 1
    row
  })
}

///|
fn update_every_tenth(rows : Array[Row]) -> Array[Row] {
  let updated = rows.copy()
  for i = 0; i < updated.length(); i = i + 10 {
    let row = updated[i]
    updated[i] = {
      ..row,
      label: row.label + " !!!",
      view_version: row.view_version + 1,
    }
  }
  updated
}

///|
fn remove_row(rows : Array[Row], id : Int) -> Array[Row] {
  let updated = rows.copy()
  if updated.search_by(row => row.id == id) is Some(index) {
    ignore(updated.remove(index))
  }
  updated
}

///|
fn swap_rows(rows : Array[Row]) -> Array[Row] {
  if rows.length() <= 998 {
    return rows
  }
  let updated = rows.copy()
  updated.swap(1, 998)
  updated
}

///|
fn click_attrs(cmd : Cmd) -> Attrs {
  Attrs::build().on_click(_ => cmd)
}

///|
fn action_button(id : String, title : String, on_click : Cmd) -> Html {
  div(class="col-sm-6 smallpad", [
    button(
      type_="button",
      class="btn btn-primary btn-block",
      id~,
      on_click~,
      title,
    ),
  ])
}

///|
fn controls(
  run : Cmd,
  run_lots : Cmd,
  add : Cmd,
  update : Cmd,
  clear : Cmd,
  swap : Cmd,
) -> Html {
  div(class="jumbotron", [
    div(class="row", [
      div(class="col-md-6", [h1("Rabbita keyed")]),
      div(class="col-md-6", [
        div(class="row", [
          action_button("run", "Create 1,000 rows", run),
          action_button("runlots", "Create 10,000 rows", run_lots),
          action_button("add", "Append 1,000 rows", add),
          action_button("update", "Update every 10th row", update),
          action_button("clear", "Clear", clear),
          action_button("swaprows", "Swap Rows", swap),
        ]),
      ]),
    ]),
  ])
}

///|
fn row_view(
  row : Row,
  selected : Bool,
  set_selected : Emit[(Int) -> Int],
  set_rows : Emit[(Array[Row]) -> Array[Row]],
) -> Html {
  tr(class=if selected { "danger" } else { "" }, [
    td(class="col-md-1", row.id.to_string()),
    td(class="col-md-4", [
      node("a", click_attrs(set_selected(_ => row.id)), row.label),
    ]),
    td(class="col-md-1", [
      node("a", click_attrs(set_rows(rows => remove_row(rows, row.id))), [
        span(
          class="glyphicon glyphicon-remove",
          attrs=Attrs::build().aria_hidden("true"),
          ([] : Array[Html]),
        ),
      ]),
    ]),
    td(class="col-md-6", ([] : Array[Html])),
  ])
}

///|
fn app() -> Val[Html] {
  let next_id = @ref.new(1)
  let (rows, set_rows) = @rabbita.create_variable(([] : Array[Row]))
  let (selected, set_selected) = @rabbita.create_variable(0)

  let controls = controls(
    @rabbita.batch([
      set_rows(_ => build_data(1000, next_id)),
      set_selected(_ => 0),
    ]),
    @rabbita.batch([
      set_rows(_ => build_data(10000, next_id)),
      set_selected(_ => 0),
    ]),
    set_rows(rows => rows + build_data(1000, next_id)),
    set_rows(update_every_tenth),
    @rabbita.batch([set_rows(_ => []), set_selected(_ => 0)]),
    set_rows(swap_rows),
  )
  let preload = span(
    class="preloadicon glyphicon glyphicon-remove",
    attrs=Attrs::build().aria_hidden("true"),
    ([] : Array[Html]),
  )

  rows.map2(selected, (rows, selected) => {
    let rendered_rows = Map(
      rows.map(row => {
        let is_selected = selected == row.id
        let selected_hash = if is_selected { 1 } else { 0 }
        let hash = row.view_version * 2 + selected_hash
        (
          row.id.to_string(),
          @html.lazy(hash, () => {
            row_view(row, is_selected, set_selected, set_rows)
          }),
        )
      }),
    )

    div(class="container", [
      controls,
      table(class="table table-hover table-striped test-data", [
        tbody(rendered_rows),
      ]),
      preload,
    ])
  })
}

///|
fn main {
  @rabbita.new(app).mount("main")
}
