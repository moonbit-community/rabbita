///|
using @rabbita {type Html, type Val}

///|
using @html {div, fragment}

///|
fn app() -> Val[Html] {
  dialog_fixture().map(dialog => {
    fragment([dialog, alert_dialog_fixture(), sheet_fixture()])
  })
}

///|
fn main {
  @fixture.mount("dialogs", app)
}
