///|
fn native_select_fixture() -> Val[Html] {
  let (value, set_value) = @rabbita.create_variable("team")
  value.view(value => {
    @fixture.section("fixture-section-native-select", "Native Select", [
      div(style=["display:grid;gap:0.5rem"], [
        @rui.label(for_="fixture-native-select", "Access scope"),
        @rui.native_select(
          id="fixture-native-select",
          name="access-scope",
          value~,
          on_change=set_value.map(value => _ => value),
          [
            @rui.native_select_optgroup(label="Workspace", [
              @rui.native_select_option(value="personal", "Personal"),
              @rui.native_select_option(value="team", "Team"),
            ]),
            @rui.native_select_optgroup(label="Advanced", [
              @rui.native_select_option(value="organization", "Organization"),
            ]),
          ],
        ),
        @html.output(id="fixture-native-select-output", "selected:\{value}"),
      ]),
      div(style=["display:grid;gap:0.5rem"], [
        @rui.label(for_="fixture-native-select-disabled", "Environment"),
        @rui.native_select(
          id="fixture-native-select-disabled",
          disabled=true,
          value="production",
          [
            @rui.native_select_option(value="production", "Production"),
            @rui.native_select_option(value="preview", "Preview"),
          ],
        ),
      ]),
    ])
  })
}
