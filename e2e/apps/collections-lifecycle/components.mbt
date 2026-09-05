///|
using @rabbita {type Html, type Val}

///|
using @html {button, div, h1, input, li, p, span, ul}

///|
fn keyed_row(id : Int, name : Val[String]) -> Val[Html] {
  let (state, set_state) = @rabbita.create_variable({ clicks: 0, draft: "", })
  let set_draft = set_state.map(value => state => { ..state, draft: value, })
  state.view2(name, (state, name) => {
    li(id="row-\{id}") <| [
      span(class="row-name", name),
      input(
        id="row-input-\{id}",
        value=state.draft,
        on_input=set_draft,
        placeholder="Draft for \{name}",
      ),
      button(
        on_click=set_state(value => { ..value, clicks: value.clicks + 1, }),
        "Increment \{name}",
      ),
      span(id="row-count-\{id}", "local: \{state.clicks}"),
    ]
  })
}

///|
fn cached_branch(name : String) -> Val[Html] {
  let (count, set_count) = @rabbita.create_variable(0)
  count.view(count => {
    div(id="cached-branch") <| [
      p("\{name} cached count: \{count}"),
      button(on_click=set_count(value => value + 1), "Increment cached branch"),
    ]
  })
}

///|
fn switched_branch(name : String) -> Val[Html] {
  let (count, set_count) = @rabbita.create_variable(0)
  count.view(count => {
    div(id="switched-branch") <| [
      p("\{name} switched count: \{count}"),
      button(
        on_click=set_count(value => value + 1),
        "Increment switched branch",
      ),
    ]
  })
}

///|
fn app() -> Val[Html] {
  let (list_model, list_emit) = @rabbita.create_pure_state(
    { reversed: false, has_first: true, },
    update=update_list,
  )
  let rows = list_model.map(list_items).assoc(keyed_row)
  let (cache_tab, cache_emit) = @rabbita.create_pure_state(CacheA, update=fn(
    _,
    tab,
  ) {
    tab
  })
  let cached = cache_tab.enumerate(tab => {
    match tab {
      CacheA => cached_branch("A")
      CacheB => cached_branch("B")
    }
  })
  let (switch_tab, switch_emit) = @rabbita.create_pure_state(SwitchA, update=fn(
    _,
    tab,
  ) {
    tab
  })
  let switched = switch_tab.switch(tab => {
    match tab {
      SwitchA => switched_branch("A")
      SwitchB => switched_branch("B")
    }
  })
  rows.map3(cached, switched, (rows, cached, switched) => {
    div <| [
      h1("Collections and lifecycle"),
      button(on_click=list_emit(Reorder), "Reorder rows"),
      button(on_click=list_emit(RemoveFirst), "Remove first row"),
      button(on_click=list_emit(AddFirst), "Add first row"),
      ul(id="rows", rows),
      div <| [
        button(on_click=cache_emit(CacheA), "Show cached A"),
        button(on_click=cache_emit(CacheB), "Show cached B"),
        cached,
      ],
      div <| [
        button(on_click=switch_emit(SwitchA), "Show switched A"),
        button(on_click=switch_emit(SwitchB), "Show switched B"),
        switched,
      ],
    ]
  })
}
