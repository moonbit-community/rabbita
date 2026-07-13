///|
test "lazy defers constructing its subtree" {
  let render_count = Ref::{ val: 0 }
  let html = @html.lazy(7, () => {
    render_count.val += 1
    @html.p("deferred")
  })
  assert_eq(render_count.val, 0)
  inspect(
    @rabbita.render_to_string(() => @rabbita.Val::constant(html)),
    content="<p>deferred</p>",
  )
  assert_eq(render_count.val, 1)
}

///|
test "lazy composes with ordinary html" {
  let html = @html.div([
    @html.text("before"),
    @html.lazy(1, () => @html.span("inside")),
    @html.text("after"),
  ])
  inspect(
    @rabbita.render_to_string(() => @rabbita.Val::constant(html)),
    content="<div>before<span>inside</span>after</div>",
  )
}
