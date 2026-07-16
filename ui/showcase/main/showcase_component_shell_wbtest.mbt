///|
#warnings("-alert_unstable")
fn render_showcase_stage(html : @html.Html) -> String {
  @rabbita.render_to_string(() => @rabbita.Val::constant(html))
}

///|
fn assert_showcase_stage_contains(
  actual : String,
  expected : String,
) -> Unit raise {
  if !actual.contains(expected) {
    fail("expected showcase stage HTML to contain `\{expected}`")
  }
}

///|
test "shared showcase stage exposes one-way code reveal and copy action" {
  let html = render_showcase_stage(
    showcase_stage(@html.span("Demo"), "@ui.button(\"Save\")"),
  )
  for
    expected in [
      "rui-showcase-demo-code-summary", "View Code", "rui-showcase-demo-code-panel",
      "rui-showcase-demo-code-scroll", "rui-showcase-demo-code-copy", "aria-label=\"Copy code\"",
      "title=\"Copy code\"", "type=\"button\"", "@ui.button",
    ] {
    assert_showcase_stage_contains(html, expected)
  }
  if html.contains("Hide Code") || html.contains("rui-showcase-demo-code-hide") {
    fail("shared showcase stage must not render a code-collapse control")
  }
}
