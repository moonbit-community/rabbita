///|
fn command_dialog_fixture() -> Val[Html] {
  let (selection, set_selection) = @rabbita.create_variable("none")
  let (open_state, set_open_state) = @rabbita.create_variable("closed")
  let dialog = @rui.command_dialog(
    id="fixture-command-dialog",
    aria_label="Fixture command palette",
    on_value_select=set_selection.map(value => _ => value),
    on_open_change=set_open_state.map(open => {
      _ => if open { "open" } else { "closed" }
    }),
    trigger=scope => @rui.command_dialog_trigger(scope~, "Open fixture palette"),
    fixture_command_items,
  )
  dialog.map3(selection, open_state, fn(dialog, selection, open_state) {
    @fixture.section("fixture-section-command-dialog", "Command Dialog", [
      dialog,
      @html.output(
        id="fixture-command-dialog-output",
        "state:\{open_state}|selected:\{selection}",
      ),
    ])
  })
}
