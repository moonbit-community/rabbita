///|
fn toggle_fixture() -> Val[Html] {
  let toggle = @rui.toggle(
    id="fixture-toggle",
    variant=Outline,
    aria_label="Pin fixture release",
    "Pin release",
  )
  let single_group = @rui.toggle_group(
    id="fixture-toggle-group-single",
    default_values=["grid"],
    aria_label="Fixture layout",
    scope => {
      fragment([
        @rui.toggle_group_item(scope~, value="list", "List"),
        @rui.toggle_group_item(scope~, value="grid", "Grid"),
        @rui.toggle_group_item(
          scope~,
          value="disabled",
          disabled=true,
          "Disabled",
        ),
      ])
    },
  )
  let multiple_group = @rui.toggle_group(
    id="fixture-toggle-group-multiple",
    default_values=["bold"],
    multiple=true,
    aria_label="Fixture formatting",
    scope => {
      fragment([
        @rui.toggle_group_item(scope~, value="bold", "Bold"),
        @rui.toggle_group_item(scope~, value="italic", "Italic"),
        @rui.toggle_group_item(scope~, value="underline", "Underline"),
      ])
    },
  )
  toggle.map3(single_group, multiple_group, fn(toggle, single, multiple) {
    @fixture.section("fixture-section-toggle", "Toggle and toggle group", [
      toggle, single, multiple,
    ])
  })
}
