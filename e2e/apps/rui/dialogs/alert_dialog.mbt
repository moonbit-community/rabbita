///|
fn alert_dialog_fixture() -> Html {
  @fixture.section("fixture-section-alert-dialog", "Alert dialog", [
    @rui.button(
      variant=Destructive,
      on_click=@dialog.show("fixture-alert-dialog"),
      "Delete fixture",
    ),
    @rui.alert_dialog(
      id="fixture-alert-dialog",
      attrs=@html.Attrs::build()
        .aria_labelledby("fixture-alert-dialog-title")
        .aria_describedby("fixture-alert-dialog-description"),
      [
        @rui.alert_dialog_header([
          @rui.alert_dialog_title(
            id="fixture-alert-dialog-title",
            "Delete this fixture?",
          ),
          @rui.alert_dialog_description(
            id="fixture-alert-dialog-description",
            "This action cannot be undone.",
          ),
        ]),
        @html.form(
          method_="dialog",
          @rui.alert_dialog_footer([
            @rui.alert_dialog_cancel(value="cancel", "Cancel deletion"),
            @rui.alert_dialog_action(value="confirm", "Confirm deletion"),
          ]),
        ),
      ],
    ),
  ])
}
