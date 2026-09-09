///|
using @rabbita {type Html, type Val, type Emit}

///|
using @html {button, div, h1, input, p, span}

///|
fn app() -> Val[Html] {
  let (parent, set_parent) = @rabbita.create_variable(0)
  let (value, set_value) = @rabbita.create_variable(1)
  let (selected, set_selected) = @rabbita.create_variable(0)
  let select = set_selected.map(value => _ => value)
  let basic = basic_memo_component(parent, value, select)
  let custom = custom_memo_component(parent, value, select)
  let lifecycle = memo_lifecycle_component(parent, value, select)
  let keyed = keyed_memo_component()
  parent.view7(value, selected, basic, custom, lifecycle, keyed, (
    parent,
    value,
    selected,
    basic,
    custom,
    lifecycle,
    keyed,
  ) => {
    div <| [
      h1("Memo rendering"),
      p(id="parent-version", "parent: \{parent}"),
      p(id="input-value", "input: \{value}"),
      p(id="selected-value", "selected: \{selected}"),
      button(on_click=set_parent(value => value + 1), "Update parent"),
      button(on_click=set_value(value => value + 1), "Update memo input"),
      basic,
      custom,
      lifecycle,
      keyed,
    ]
  })
}
