///|
fn dialog_fixture() -> Val[Html] {
  let modal = @rui.dialog(id="fixture-dialog-modal", scope => {
    fragment([
      @rui.dialog_trigger(scope, variant=Outline, "Open modal dialog"),
      @rui.dialog_portal([
        @rui.dialog_content(scope, show_close=true, [
          @rui.dialog_header([
            @rui.dialog_title(scope, "Edit fixture profile"),
            @rui.dialog_description(
              scope, "Update the profile and save the dialog.",
            ),
          ]),
          div(style=["display:grid;gap:0.5rem"], [
            @rui.label(for_="fixture-dialog-name", "Display name"),
            @rui.input(id="fixture-dialog-name", value="Rabbita team"),
          ]),
          @rui.dialog_footer(@rui.dialog_close(scope, "Save dialog")),
        ]),
      ]),
    ])
  })
  let non_modal = @rui.dialog(id="fixture-dialog-non-modal", modal=false, scope => {
    fragment([
      @rui.dialog_trigger(scope, variant=Outline, "Open non-modal dialog"),
      @rui.dialog_portal([
        @rui.dialog_content(scope, show_close=true, [
          @rui.dialog_header([
            @rui.dialog_title(scope, "Non-modal fixture"),
            @rui.dialog_description(
              scope, "The surrounding page remains interactive.",
            ),
          ]),
          @rui.dialog_footer(@rui.dialog_close(scope, "Close non-modal")),
        ]),
      ]),
    ])
  })
  modal.map2(non_modal, fn(modal, non_modal) {
    @fixture.section("fixture-section-dialog", "Dialog", [modal, non_modal])
  })
}
