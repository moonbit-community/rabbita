///|
priv struct PhysicalKeyedState {
  tick : Int
  reversed : Bool
  shown : Bool
  trailing : Bool
} derive(Eq)

///|
fn physical_keyed_app() -> Val[Html] {
  let (state, update) = @rabbita.create_variable(PhysicalKeyedState::{
    tick: 0,
    reversed: false,
    shown: true,
    trailing: true,
  })
  let (computes, counter) = render_counter("shared_keyed")
  let shared_input = input(
    class="shared-alias",
    placeholder="Shared alias draft",
  )
  // Keep the same Html objects across ordering, removal, and remounting.
  let shared : Map[String, Html] = {
    "element": div(id="shared-element", [input(placeholder="Element draft")]),
    "text": @html.text("shared text"),
    "fragment": @html.fragment([
      span(id="shared-fragment", "fragment"),
      input(placeholder="Fragment draft"),
    ]),
    "empty": @html.fragment([]),
    "thunk": @html.memo(0, _ => {
      computes.value += 1
      @html.fragment([
        span(id="shared-thunk", "thunk"),
        input(placeholder="Thunk draft"),
      ])
    }),
    "alias-a": shared_input,
    "alias-b": shared_input,
  }
  let content = state.view(state => {
    let order = [
      "element", "text", "fragment", "empty", "thunk", "alias-a", "alias-b",
    ]
    let order = if state.reversed { order.rev() } else { order }
    let children : Map[String, Html] = Map([])
    for key in order {
      if state.shown || (key != "fragment" && key != "empty" && key != "thunk") {
        children[key] = shared[key]
      }
    }
    if state.trailing {
      children["after"] = span(id="shared-after", "after")
    }
    div([
      button(
        on_click=update(s => { ..s, tick: s.tick + 1, }),
        "Refresh shared rows",
      ),
      button(
        on_click=update(s => { ..s, reversed: !s.reversed, }),
        "Reverse shared rows",
      ),
      button(
        on_click=update(s => { ..s, shown: !s.shown, }),
        "Toggle shared ranges",
      ),
      button(
        on_click=update(s => { ..s, trailing: !s.trailing, }),
        "Toggle shared tail",
      ),
      p(id="shared-tick", "\{state.tick}"),
      div(id="shared-stage", children),
    ])
  })
  content.map2(counter, (content, counter) => div([content, counter]))
}
