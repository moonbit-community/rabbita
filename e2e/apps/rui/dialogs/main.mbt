///|
using @rabbita {type Html, type Val}

///|
using @html {div, fragment}

///|
fn app() -> Val[Html] {
  dialog_fixture().map3(alert_dialog_fixture(), sheet_fixture(), fn(
    dialog,
    alert_dialog,
    sheet,
  ) {
    fragment([dialog, alert_dialog, sheet])
  })
}

///|
fn main {
  @fixture.mount("dialogs", app)
}
