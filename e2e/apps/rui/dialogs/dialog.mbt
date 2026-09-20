///|
fn dialog_fixture() -> Val[Html] {
  let (status, set_status) = @rabbita.create_variable("Ready")
  status.map(status => {
    @fixture.section("fixture-section-dialog", "Dialog", [
      @html.output(id="fixture-dialog-status", status),
      @rui.button(
        variant=Outline,
        on_click=@dialog.show("fixture-dialog-modal"),
        "Open modal dialog",
      ),
      @rui.dialog(
        id="fixture-dialog-modal",
        on_close=value => set_status(_ => value),
        attrs=@html.Attrs::build()
          .aria_labelledby("fixture-dialog-modal-title")
          .aria_describedby("fixture-dialog-modal-description"),
      ) <| [
        @rui.dialog_header <| [
          @rui.dialog_title(
            id="fixture-dialog-modal-title",
            "Edit fixture profile",
          ),
          @rui.dialog_description(
            id="fixture-dialog-modal-description",
            "Update the profile and save the dialog.",
          ),
        ],
        @html.form(attrs=@html.Attrs::build().method_("dialog")) <| [
          div(style=["display:grid;gap:0.5rem"], [
            @rui.label(for_="fixture-dialog-name", "Display name"),
            @rui.input(id="fixture-dialog-name", value="Rabbita team"),
          ]),
          @rui.dialog_footer <| [
            @rui.button(
              on_click=set_status(_ => "Updated"),
              "Update caller state",
            ),
            @rui.button(type_="submit", value="saved", "Save dialog"),
          ],
        ],
      ],
      @rui.button(
        variant=Outline,
        on_click=@dialog.show("fixture-dialog-non-modal", modal=false),
        "Open non-modal dialog",
      ),
      @rui.dialog(
        id="fixture-dialog-non-modal",
        attrs=@html.Attrs::build()
          .aria_labelledby("fixture-dialog-non-modal-title")
          .aria_describedby("fixture-dialog-non-modal-description"),
        [
          @rui.dialog_header([
            @rui.dialog_title(
              id="fixture-dialog-non-modal-title",
              "Non-modal fixture",
            ),
            @rui.dialog_description(
              id="fixture-dialog-non-modal-description",
              "The surrounding page remains interactive.",
            ),
          ]),
          @rui.dialog_footer(
            @html.form(
              attrs=@html.Attrs::build().method_("dialog"),
              @rui.button(type_="submit", "Close non-modal"),
            ),
          ),
        ],
      ),
    ])
  })
}
