///|
fn command_dialog_fixture() -> Val[Html] {
  let (selection, set_selection) = @rabbita.create_variable("none")
  let (query, set_query) = @rabbita.create_variable("")
  let (closed, set_closed) = @rabbita.create_variable("pending")
  let dialog = @rui.command_dialog(
    id="fixture-command-dialog",
    aria_label="Fixture command palette",
    on_value_select=set_selection.map(value => _ => value),
    on_query_change=set_query.map(value => _ => value),
    on_close=set_closed.map(value => _ => value),
    fixture_command_items,
  )
  let output = selection.map3(query, closed, fn(selection, query, closed) {
    @html.output(
      id="fixture-command-dialog-output",
      "query:\{query}|selected:\{selection}|closed:\{closed}",
    )
  })
  dialog.map2(output, fn(dialog, output) {
    @fixture.section("fixture-section-command-dialog", "Command Dialog", [
      @rui.button(
        on_click=@dialog.show("fixture-command-dialog"),
        "Open fixture palette",
      ),
      dialog,
      output,
    ])
  })
}

///|
fn command_dialog_options_fixture(
  id : String,
  name : String,
  close_on_select? : Bool = true,
  prevent_cancel? : Bool = false,
) -> Val[Html] {
  let (selection, set_selection) = @rabbita.create_variable("none")
  let on_cancel = if prevent_cancel { Some(@cmd.none) } else { None }
  let dialog = @rui.command_dialog(
    id~,
    aria_label=name,
    close_on_select~,
    on_value_select=set_selection.map(value => _ => value),
    on_cancel?,
    fixture_command_items,
  )
  dialog.map2(selection, fn(dialog, selection) {
    @fixture.section(id + "-section", name, [
      @rui.button(on_click=@dialog.show(id), "Open " + name),
      dialog,
      @html.output(id=id + "-selection", selection),
    ])
  })
}
