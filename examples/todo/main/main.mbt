///|
using @sorted_map {type SortedMap}

///|
using @vector {type Vector, from_iter}

///|
using @rabbita {type Val, none, type Emit, type Html }

///|
using @html {button, div, h1, input, li, nav, span, ul, form, text, p}

///|
struct Todo {
  title : String
  done : Bool
} derive(Eq)

///|
enum TodoTab {
  All
  Active
  Done
  Stats
} derive(Eq)

///|
impl @rabbita.Enumerate for TodoTab with tag(self) {
  match self {
    All => "all"
    Active => "active"
    Done => "done"
    Stats => "stats"
  }
}

///|
fn TodoTab::label(self : Self) -> String {
  match self {
    All => "All"
    Active => "Active"
    Done => "Done"
    Stats => "Stats"
  }
}

///|
fn TodoTab::empty_text(self : Self) -> String {
  match self {
    All => "No todos yet."
    Active => "No active todos."
    Done => "No completed todos."
    Stats => "No data yet."
  }
}

///|
struct Model {
  title : String
  items : SortedMap[Int, Todo]
  next : Int
  tab : TodoTab
} derive(Eq)

///|
enum Msg {
  TitleChanged(String)
  Add
  Delete(Int)
  Toggle(Int)
  SetTab(TodoTab)
}

///|
enum Msg2 {
  Inc
  Dec
}

///|
enum TodoMsg {
  Tick
  Toggle
}

///|
struct TodoModel {
  folded : Bool
  tick : Int
} derive(Eq)

///|
fn todo(id : Int, todo : Val[Todo], emit : Emit[Msg]) -> Val[Html] {
  let (flag, set_flag) = @rabbita.create_variable(false)

  flag.map2(todo, (flag, todo) => {
    let is_long = todo.title.length() > 20
    let title = if is_long && flag { todo.title[:20].to_owned() } else { todo.title }
    li(class=if todo.done { "todo-row is-done" } else { "todo-row" }, [
      button(
        type_="button",
        class=if todo.done { "status-toggle is-done" } else { "status-toggle" },
        on_click=emit(Toggle(id)),
        if todo.done { "done" } else { "open" },
      ),
      div(class="todo-copy", [
        span(class="todo-title", title),
        if is_long {
          button(
            type_="button",
            class="inline-toggle",
            on_click=set_flag(x => !x),
            if flag { "more" } else { "less" },
          )
        } else {
          span(class="inline-placeholder", "")
        },
      ]),
      button(
        type_="button",
        class="delete-button",
        on_click=emit(Delete(id)),
        "delete",
      ),
    ])
  })
}

///|
fn tab_button(emit : Emit[Msg], current : TodoTab, tab : TodoTab, count : Int) -> Html {
  let class = if current == tab { "tab is-active" } else { "tab" }
  button(type_="button", class~, on_click=emit(SetTab(tab)), [
    span(class="tab-label", tab.label()),
    span(class="tab-count", count.to_string()),
  ])
}

///|
fn metric_card(label : String, value : Int) -> Html {
  div(class="metric-card", [
    span(class="metric-value", value.to_string()),
    span(class="metric-label", label),
  ])
}

///|
fn list_content(tab : TodoTab, todos : Val[Vector[Html]]) -> Val[Html] {
  todos.map(todos => {
    if todos.length() == 0 {
      p(class="empty", tab.empty_text())
    } else {
      ul(class="todo-list", todos)
    }
  })
}

///|
fn all_content(model : Val[Model], emit : Emit[Msg]) -> Val[Html] {
  let entries = model.map(m => from_iter(m.items.iter()))
  let todos = entries.assoc((id, todo_value) =>
    todo(id, todo_value, emit)
  )
  list_content(All, todos)
}

///|
fn active_content(model : Val[Model], emit : Emit[Msg]) -> Val[Html] {
  let entries = model.map(m =>
    from_iter(m.items.iter().filter(pair => !pair.1.done))
  )
  let todos = entries.assoc((id, todo_value) =>
    todo(id, todo_value, emit)
  )
  list_content(Active, todos)
}

///|
fn done_content(model : Val[Model], emit : Emit[Msg]) -> Val[Html] {
  let entries = model.map(m =>
    from_iter(m.items.iter().filter(pair => pair.1.done))
  )
  let todos = entries.assoc((id, todo_value) =>
    todo(id, todo_value, emit)
  )
  list_content(Done, todos)
}

///|
fn stats_content(model : Val[Model]) -> Val[Html] {
  model.map(model => {
    let items = model.items
    let total = items.length()
    let completed = items.filter((_, todo) => todo.done).length()
    let active = total - completed
    div(class="stats-grid", [
      metric_card("total", total),
      metric_card("active", active),
      metric_card("done", completed),
    ])
  })
}

///|
fn tab_content(
  current_tab : Val[TodoTab],
  model : Val[Model],
  emit : Emit[Msg],
) -> Val[Html] {
  current_tab.switch(tab => {
    match tab {
      All => all_content(model, emit)
      Active => active_content(model, emit)
      Done => done_content(model, emit)
      Stats => stats_content(model)
    }
  })
}

///|
fn app() -> Val[Html] {
  let (model, emit) = @rabbita.create_state(
    { title: "", items: SortedMap::new(), next: 0, tab: All },
    update=fn(model, msg, _) {
      let { title, items, next, .. } = model
      let model = match msg {
        TitleChanged(title) => { ..model, title, }
        SetTab(tab) => { ..model, tab }
        Add if title == "" => model
        Toggle(id) => {
          let todo = items[id]
          let todo = { ..todo, done: !todo.done }
          { ..model, items: items.add(id, todo) }
        }
        Add =>
          { ..model,
            title: "",
            items: items.add(next, { title, done: false }),
            next: next + 1,
          }
        Delete(id) => { ..model, items: items.remove(id) }
      }
      (model, none)
    },
  )

  let current_tab = model.map(m => m.tab)
  let content = tab_content(current_tab, model, emit)

  model.map2(content, (model, content) => {
    let { items, title, .. } = model
    let total = items.length()
    let completed = items.filter((_, todo) => todo.done).length()
    let active = total - completed
    div(class="panel", [
      div(class="panel-header", [
        h1("Todos"),
        span(class="panel-kicker", "\{active} active"),
      ]),
      form(on_submit=emit(Add), [
        input(
          value=title,
          placeholder="What needs doing?",
          on_input=emit.map(s => TitleChanged(s)),
        ),
        input(input_type=Submit, value="add"),
      ]),
      nav(class="tabs", [
        tab_button(emit, model.tab, All, total),
        tab_button(emit, model.tab, Active, active),
        tab_button(emit, model.tab, Done, completed),
        tab_button(emit, model.tab, Stats, total),
      ]),
      content,
    ])
  })
}

///|
fn main {
  @rabbita.new(app).mount("app")
}
