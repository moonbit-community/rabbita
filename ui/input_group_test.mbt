///|
#warnings("-alert_unstable")
fn render_input_group_test(html : @html.Html) -> String {
  @rabbita.render_to_string(() => @rabbita.Val::constant(html))
}

///|
test "input group owns the border and clears nested control chrome" {
  let html = render_input_group_test(
    @rabbita-ui.input_group([
      @rabbita-ui.input_group_addon("https://"),
      @rabbita-ui.input_group_input(value="workspace"),
      @rabbita-ui.input_group_addon(
        align=@rabbita-ui.InputInlineEnd,
        ".moonbit.app",
      ),
    ]),
  )
  assert_true(html.contains("data-slot=\"input-group\""))
  assert_true(html.contains("data-slot=\"input-group-control\""))
  assert_true(
    html.contains(
      "flex:1;border:0;border-radius:0;background:transparent;box-shadow:none;outline:none",
    ),
  )
  assert_true(!html.contains("border-radius:inherit"))
}

///|
test "input group textarea uses the same single-border contract" {
  let html = render_input_group_test(
    @rabbita-ui.input_group(@rabbita-ui.input_group_textarea(value="Notes")),
  )
  assert_true(
    html.contains(
      "flex:1;resize:none;border:0;border-radius:0;background:transparent;box-shadow:none;outline:none",
    ),
  )
  assert_true(!html.contains("outline-offset:0"))
}
