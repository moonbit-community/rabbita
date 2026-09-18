///|
let fixture_section_border = "1px solid var(--rui-border,oklch(0.922 0 0))"

///|
fn fixture_command_items(scope : @rui.CommandScope) -> Html {
  fragment([
    @rui.command_input(scope~, placeholder="Search fixture actions…"),
    @rui.command_list(scope~, aria_label="Fixture actions", [
      @rui.command_empty(scope~, "No matching fixture actions."),
      @rui.command_group(scope~, heading="Workspace", [
        @rui.command_item(scope~, value="Open dashboard", keywords=["home"], [
          span("Open dashboard"),
          @rui.command_shortcut("Ctrl+D"),
        ]),
        @rui.command_item(
          scope~,
          value="Create project",
          keywords=["new"],
          "Create project",
        ),
        @rui.command_item(
          scope~,
          value="Unavailable action",
          disabled=true,
          "Unavailable action",
        ),
        @rui.command_item(
          scope~,
          value="Open settings",
          keywords=["preferences"],
          "Open settings",
        ),
      ]),
    ]),
  ])
}

///|
fn command_fixture() -> Val[Html] {
  let (selection, set_selection) = @rabbita.create_variable("none")
  let (query, set_query) = @rabbita.create_variable("")
  let command = @rui.command(
    id="fixture-command",
    on_value_select=set_selection.map(value => _ => value),
    on_query_change=set_query.map(value => _ => value),
    style=[
      "width:min(100%,24rem);border:1px solid \{fixture_section_border};border-radius:0.5rem",
    ],
    fixture_command_items,
  )
  command.map3(selection, query, fn(command, selection, query) {
    @fixture.section("fixture-section-command", "Command", [
      command,
      @html.output(
        id="fixture-command-output",
        "query:\{query}|selected:\{selection}",
      ),
    ])
  })
}
