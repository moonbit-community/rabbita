///|
priv struct PhysicalNodesState {
  choice : Int
  revision : Int
} derive(Eq)

///|
fn physical_nodes(
  value : String,
  select : Emit[String],
  computes : RenderCounter,
) -> Array[Html] {
  [
    button(
      id="physical-element",
      title=value,
      on_click=select("element \{value}"),
      "element \{value}",
    ),
    @html.text("text \{value}"),
    @html.fragment([
      span(id="physical-first", "first \{value}"),
      span(id="physical-second", "second \{value}"),
    ]),
    @html.memo_by(
      value,
      value => {
        computes.value += 1
        button(
          id="physical-thunk",
          on_click=select("thunk \{value}"),
          "thunk \{value}",
        )
      },
      by=value => if value == "A" { 0 } else { 1 },
    ),
  ]
}

///|
fn physical_nodes_app() -> Val[Html] {
  let (state, set_state) = @rabbita.create_variable(PhysicalNodesState::{
    choice: 0,
    revision: 0,
  })
  let choose = set_state.map(choice => {
    state => { choice, revision: state.revision + 1, }
  })
  let (selected, set_selected) = @rabbita.create_variable("")
  let select = set_selected.map(value => _ => value)
  let (computes, counter) = render_counter("physical")
  let a = physical_nodes("A", select, computes)
  let b = physical_nodes("B", select, computes)
  let empty = @html.fragment([])
  let replacements = [
    span(id="physical-element", "replacement element"),
    span(id="physical-text-replacement", "replacement text"),
    @html.text("replacement fragment"),
    span(id="physical-thunk-replacement", "replacement thunk"),
  ]
  let html_svg = @html.svg(id="physical-svg", ([] : Array[Html]))
  let svg = @svg.svg(id="physical-svg", [])
  // The parent always renders on refresh, even when its children reuse a VNode.
  let content = state.view(state => {
    let nodes = match state.choice {
      0 => a
      1 => b
      2 => physical_nodes("A", select, computes)
      3 => [empty, empty, empty, empty]
      _ => replacements
    }
    div([
      p(id="physical-revision", "\{state.revision}"),
      button(
        on_click=set_state(state => { ..state, revision: state.revision + 1, }),
        "Reuse nodes",
      ),
      button(on_click=choose(0), "Use A"),
      button(on_click=choose(1), "Use B"),
      button(on_click=choose(2), "Use fresh A"),
      button(on_click=choose(3), "Use empty fragments"),
      button(on_click=choose(4), "Replace node kinds"),
      div(id="physical-element-stage", nodes[0]),
      div(id="physical-text-stage", nodes[1]),
      div(id="physical-fragment-stage", [
        span(id="physical-before", "before|"),
        nodes[2],
        span(id="physical-after", "|after"),
      ]),
      div(id="physical-thunk-stage", nodes[3]),
      if state.choice == 1 {
        svg
      } else {
        html_svg
      },
    ])
  })
  let selection = selected.view(selected => p(id="physical-selected", selected))
  content.map3(counter, selection, (content, counter, selection) => {
    div([content, counter, selection])
  })
}
