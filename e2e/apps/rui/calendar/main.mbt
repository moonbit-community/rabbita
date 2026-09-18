///|
using @rabbita {type Html, type Val}

///|
using @html {fragment}

///|
fn calendar_extended_fixture() -> Val[Html] {
  calendar_range_fixture().map3(
    calendar_multiple_fixture(),
    date_range_picker_fixture(),
    fn(range, multiple, picker) { fragment([range, multiple, picker]) },
  )
}

///|
fn app() -> Val[Html] {
  calendar_fixture().map3(date_picker_fixture(), calendar_extended_fixture(), fn(
    calendar,
    date_picker,
    calendar_extended,
  ) {
    fragment([calendar, date_picker, calendar_extended])
  })
}

///|
fn main {
  @fixture.mount("calendar", app)
}
