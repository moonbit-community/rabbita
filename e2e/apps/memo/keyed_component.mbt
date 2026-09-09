///|
priv enum KeyedShape {
  Element
  Fragment
  Empty
  Text
} derive(Eq, Hash)

///|
priv struct KeyedState {
  reversed : Bool
  shown : Bool
  trailing_marker : Bool
  shape : KeyedShape
  value : Int
} derive(Eq)

///|
fn keyed_memo_row(
  key : String,
  shape : KeyedShape,
  value : Int,
  select : Emit[String],
  computes : RenderCounter,
) -> Html {
  @html.memo((key, shape, value), row => {
    computes.value += 1
    let (key, shape, value) = row
    let children = [
      span(id="keyed-\{key}-label", "\{key}:\{value}"),
      input(id="keyed-\{key}-draft", placeholder="Keyed draft \{key}"),
      button(
        id="keyed-\{key}-pick",
        on_click=select("\{key}:\{value}"),
        "Pick keyed \{key} \{value}",
      ),
    ]
    match shape {
      Element => div(id="keyed-\{key}-element", children)
      Fragment => @html.fragment(children)
      Empty => @html.fragment([])
      Text => @html.text("\{key} text \{value}")
    }
  })
}

///|
fn keyed_memo_component() -> Val[Html] {
  let (model, set_model) = @rabbita.create_variable(KeyedState::{
    reversed: false,
    shown: true,
    trailing_marker: true,
    shape: Fragment,
    value: 1,
  })
  let (selected, set_selected) = @rabbita.create_variable("")
  let select = set_selected.map(value => _ => value)
  let (computes, compute_counter) = render_counter("keyed")
  let move_as = set_model.map(shape => {
    model => {
      ..model,
      reversed: !model.reversed,
      shape,
      value: model.value + 1,
    }
  })
  let content = model.view(model => {
    let rows : Map[String, Html] = {
      "before": span(id="keyed-before", "before|"),
    }
    let order = if model.reversed { ["c", "b", "a"] } else { ["a", "b", "c"] }
    for key in order {
      if key != "a" {
        rows[key] = keyed_memo_row(key, Fragment, 1, select, computes)
      } else if model.shown {
        rows[key] = keyed_memo_row(
          key,
          model.shape,
          model.value,
          select,
          computes,
        )
      }
    }
    if model.trailing_marker {
      rows["after"] = span(id="keyed-after", "|after")
    }
    div <| [
      button(
        on_click=set_model(model => { ..model, reversed: !model.reversed, }),
        "Reverse keyed rows",
      ),
      button(on_click=move_as(Element), "Move keyed a as element"),
      button(on_click=move_as(Fragment), "Move keyed a as fragment"),
      button(on_click=move_as(Empty), "Move keyed a as empty"),
      button(on_click=move_as(Text), "Move keyed a as text"),
      button(
        on_click=set_model(model => {
          ..model,
          shape: Empty,
          value: model.value + 1,
        }),
        "Clear keyed a",
      ),
      button(
        on_click=set_model(model => { ..model, shown: false, }),
        "Remove keyed a",
      ),
      button(
        on_click=set_model(model => { ..model, shown: true, }),
        "Add keyed a",
      ),
      button(
        on_click=set_model(model => { ..model, value: model.value + 1, }),
        "Update keyed a",
      ),
      button(
        on_click=set_model(model => {
          ..model,
          trailing_marker: !model.trailing_marker,
        }),
        "Toggle keyed trailing marker",
      ),
      div(id="keyed-stage", rows),
    ]
  })
  let result = selected.view(value => p(id="keyed-selected", value))
  content.map3(result, compute_counter, (content, result, compute_counter) => {
    div([content, result, compute_counter])
  })
}
