///|
using @rabbita {type Emit, type Html}

///|
using @html {
  type Attrs,
  type Mouse,
  ul,
  div,
  li,
  p,
  h1,
  h2,
  button,
  span,
  canvas,
  text,
  nothing,
  node,
}

///|
test {
  let model : Model = { count: 0, }
  ignore(model)

  ignore(Inc)
  ignore(Dec)
  let msg_score = match Inc {
    Inc => 1
    Dec => 0
  }
  ignore(msg_score)
  let lift_start : (Mouse) -> DrawMsg = mouse => Start(mouse)
  let lift_end : (Mouse) -> DrawMsg = mouse => End(mouse)
  ignore(lift_start)
  ignore(lift_end)

  ignore(view)
  ignore(tag_view)
  ignore(card_view)
  ignore(todo_list)
  ignore(handle_draw)
  ignore(canvas_view)

  ignore(children_array)
  ignore(children_text)
  ignore(single_child)
  ignore(keyed_children)
  ignore(card_html)
  ignore(custom_node_html)

  let attrs : Attrs = Attrs::build().class("probe")
  ignore(attrs)
  ignore(node("div", Attrs::build(), "probe"))
}
