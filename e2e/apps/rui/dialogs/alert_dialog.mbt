///|
fn alert_dialog_fixture() -> Val[Html] {
  @rui.alert_dialog(id="fixture-alert-dialog", scope => {
    fragment([
      @rui.alert_dialog_trigger(scope, variant=Destructive, "Delete fixture"),
      @rui.alert_dialog_portal([
        @rui.alert_dialog_content(scope, [
          @rui.alert_dialog_header([
            @rui.alert_dialog_title(scope, "Delete this fixture?"),
            @rui.alert_dialog_description(
              scope, "This action cannot be undone.",
            ),
          ]),
          @rui.alert_dialog_footer([
            @rui.alert_dialog_cancel(scope, "Cancel deletion"),
            @rui.alert_dialog_action(scope, "Confirm deletion"),
          ]),
        ]),
      ]),
    ])
  }).map(dialog => {
    @fixture.section("fixture-section-alert-dialog", "Alert dialog", [dialog])
  })
}
