///|
test "keyed children preserve insertion order" {
  let html = @html.div(
    @html.keyed([
      ("second", @html.span("second")),
      ("first", @html.span("first")),
    ]),
  )
  inspect(
    @rabbita.render_to_string(() => @rabbita.Val::constant(html)),
    content="<div><span>second</span><span>first</span></div>",
  )
}
