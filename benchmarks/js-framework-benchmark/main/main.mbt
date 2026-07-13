///|
using @rabbita {type Cmd, type Emit, type Html, type Val}

///|
using @html {type Attrs, button, div, h1, node, span, table, tbody}

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
  id_text : String
  label : String
  view_version : Int
}

///|
priv struct Model {
  rows : Array[Row]
  selected : Int
  next_id : Int
}

///|
impl Eq for Model with fn equal(a, b) {
  a.selected == b.selected &&
  a.next_id == b.next_id &&
  physical_equal(a.rows, b.rows)
}

///|
priv enum Msg {
  Create(Int)
  Append
  UpdateEveryTenth
  Clear
  Swap
  Select(Int)
  Remove(Int)
}

///|
fn build_data(count : Int, start_id : Int) -> Array[Row] {
  Array::makei(count, index => {
    let id = start_id + index
    {
      id,
      id_text: id.to_string(),
      label: adjectives[random_index(adjectives.length())] +
      " " +
      colours[random_index(colours.length())] +
      " " +
      nouns[random_index(nouns.length())],
      view_version: 0,
    }
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
fn update_model(msg : Msg, model : Model) -> Model {
  match msg {
    Create(count) =>
      {
        rows: build_data(count, model.next_id),
        selected: 0,
        next_id: model.next_id + count,
      }
    Append =>
      {
        ..model,
        rows: model.rows + build_data(1000, model.next_id),
        next_id: model.next_id + 1000,
      }
    UpdateEveryTenth => { ..model, rows: update_every_tenth(model.rows) }
    Clear => { ..model, rows: [], selected: 0 }
    Swap => { ..model, rows: swap_rows(model.rows) }
    Select(id) => { ..model, selected: id }
    Remove(id) => { ..model, rows: remove_row(model.rows, id) }
  }
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
// These values are immutable after initialization. Reusing them reflects how
// static attributes and static subtrees are normally hoisted by a UI compiler,
// and lets Rabbita's VNode identity fast path do useful work inside changed
// rows as well.
let normal_row_attrs : Attrs = Attrs::build().class("")

///|
let selected_row_attrs : Attrs = Attrs::build().class("danger")

///|
let narrow_cell_attrs : Attrs = Attrs::build().class("col-md-1")

///|
let label_cell_attrs : Attrs = Attrs::build().class("col-md-4")

///|
let trailing_cell : Html = node(
  "td",
  Attrs::build().class("col-md-6"),
  ([] : Array[Html]),
)

///|
let remove_icon : Html = node(
  "span",
  Attrs::build().class("glyphicon glyphicon-remove").aria_hidden("true"),
  ([] : Array[Html]),
)

///|
fn row_view(row : Row, selected : Bool, emit : Emit[Msg]) -> Html {
  node("tr", if selected { selected_row_attrs } else { normal_row_attrs }, [
    node("td", narrow_cell_attrs, row.id_text),
    node("td", label_cell_attrs, [
      node("a", click_attrs(emit(Select(row.id))), row.label),
    ]),
    node("td", narrow_cell_attrs, [
      node("a", click_attrs(emit(Remove(row.id))), [remove_icon]),
    ]),
    trailing_cell,
  ])
}

///|
fn app() -> Val[Html] {
  let (model, emit) = @rabbita.create_pure_state(
    Model::{ rows: [], selected: 0, next_id: 1 },
    update=update_model,
  )

  let controls = controls(
    emit(Create(1000)),
    emit(Create(10000)),
    emit(Append),
    emit(UpdateEveryTenth),
    emit(Clear),
    emit(Swap),
  )
  let preload = span(
    class="preloadicon glyphicon glyphicon-remove",
    attrs=Attrs::build().aria_hidden("true"),
    ([] : Array[Html]),
  )

  model.map(model => {
    let rendered_rows = @html.keyed(
      model.rows.map(row => {
        let is_selected = model.selected == row.id
        let selected_hash = if is_selected { 1 } else { 0 }
        let hash = row.view_version * 2 + selected_hash
        (row.id_text, @html.lazy(hash, () => row_view(row, is_selected, emit)))
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
