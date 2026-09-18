///|
fn form_fixture() -> Val[Html] {
  let (state, set_state) = @rabbita.create_variable(
    ("Ada Lovelace", "analytical-engine", "Initial launch note", false),
  )
  state.view(state => {
    let (name, website, note, submitted) = state
    @fixture.section(
      "fixture-section-form",
      "Form, Field, Input, Input Group, and Textarea",
      [
        @rui.form(
          id="fixture-profile-form",
          name="fixture-profile",
          on_submit=set_state(current => (current.0, current.1, current.2, true)),
          @rui.field_set([
            @rui.field_legend("Fixture profile"),
            @rui.field_group([
              @rui.form_field(
                name="display-name",
                required=true,
                describedby="fixture-name-description",
                [
                  @rui.form_label(for_="fixture-form-name", "Display name"),
                  @rui.form_control(
                    @rui.input(
                      id="fixture-form-name",
                      name="display-name",
                      value=name,
                      required=true,
                      attrs=@html.Attrs::build().aria_describedby(
                        "fixture-name-description",
                      ),
                      placeholder="Ada Lovelace",
                      on_input=set_state.map(value => {
                        current => (value, current.1, current.2, false)
                      }),
                    ),
                  ),
                  @rui.form_description(
                    id="fixture-name-description",
                    "Shown to fixture collaborators.",
                  ),
                ],
              ),
              @rui.field([
                @rui.field_label(for_="fixture-form-site", "Workspace URL"),
                @rui.input_group([
                  @rui.input_group_addon(
                    for_="fixture-form-site",
                    @rui.input_group_text("https://"),
                  ),
                  @rui.input_group_input(
                    id="fixture-form-site",
                    name="workspace-url",
                    value=website,
                    on_input=set_state.map(value => {
                      current => (current.0, value, current.2, false)
                    }),
                  ),
                  @rui.input_group_addon(
                    align=InputInlineEnd,
                    @rui.input_group_text(".moonbit.app"),
                  ),
                ]),
              ]),
              @rui.field([
                @rui.field_label(for_="fixture-form-note", "Launch note"),
                @rui.textarea(
                  id="fixture-form-note",
                  name="launch-note",
                  value=note,
                  rows=3,
                  on_input=set_state.map(value => {
                    current => (current.0, current.1, value, false)
                  }),
                ),
              ]),
            ]),
            @html.output(
              id="fixture-form-output",
              if submitted {
                "submitted:\{name}|\{website}|\{note}"
              } else {
                "editing:\{name}|\{website}|\{note}"
              },
            ),
            @rui.button(type_="submit", "Save fixture profile"),
          ]),
        ),
      ],
    )
  })
}
