///|
fn semantic_actions_fixture() -> Val[Html] {
  let (action, set_action) = @rabbita.create_variable("none")
  action.view(action => {
    @fixture.section("fixture-section-semantic-actions", "Alerts and Actions", [
      @rui.alert(id="fixture-alert", [
        @rui.alert_title("Fixture deployment ready"),
        @rui.alert_description("All semantic checks completed."),
        @rui.alert_action(
          @rui.button(
            size=Sm,
            on_click=set_action(_ => "alert-acknowledged"),
            "Acknowledge fixture alert",
          ),
        ),
      ]),
      @rui.button_group(
        id="fixture-button-group",
        aria_label="Fixture edit actions",
        [
          @rui.button(
            variant=Outline,
            on_click=set_action(_ => "saved"),
            "Save fixture",
          ),
          @rui.button_group_separator(),
          @rui.button(
            variant=Outline,
            disabled=true,
            on_click=set_action(_ => "deleted"),
            "Delete fixture",
          ),
        ],
      ),
      @rui.attachment(id="fixture-attachment", state=AttachmentUploading, [
        @rui.attachment_media(@rui.spinner(label="Uploading fixture file")),
        @rui.attachment_content([
          @rui.attachment_title("fixture-report.pdf"),
          @rui.attachment_description("Uploading · 42%"),
        ]),
        @rui.attachment_actions(
          @rui.attachment_action(
            aria_label="Cancel fixture upload",
            on_click=set_action(_ => "upload-cancelled"),
            "×",
          ),
        ),
      ]),
      @html.output(id="fixture-semantic-actions-output", action),
    ])
  })
}
