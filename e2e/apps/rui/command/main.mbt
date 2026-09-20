///|
using @rabbita {type Html, type Val}

///|
using @html {fragment, span}

///|
fn app() -> Val[Html] {
  let base = command_fixture().map2(command_dialog_fixture(), fn(
    command,
    dialog,
  ) {
    fragment([command, dialog])
  })
  let persistent = command_dialog_options_fixture(
    "fixture-command-persistent",
    "Persistent palette",
    close_on_select=false,
  )
  let cancel = command_dialog_options_fixture(
    "fixture-command-cancel",
    "Cancel palette",
    prevent_cancel=true,
  )
  base.map3(persistent, cancel, fn(base, persistent, cancel) {
    fragment([base, persistent, cancel])
  })
}

///|
fn main {
  @fixture.mount("command", app)
}
