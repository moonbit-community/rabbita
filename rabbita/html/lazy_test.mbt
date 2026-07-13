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
