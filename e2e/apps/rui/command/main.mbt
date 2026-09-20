///|
using @rabbita {type Html, type Val}

///|
using @html {fragment, span}

///|
fn app() -> Val[Html] {
  command_fixture().map2(command_dialog_fixture(), fn(command, command_dialog) {
    fragment([command, command_dialog])
  })
}

///|
fn main {
  @fixture.mount("command", app)
}
