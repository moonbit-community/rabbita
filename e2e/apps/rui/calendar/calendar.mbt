///|
fn fixture_range_text(value : @rui.DateRange) -> String {
  let start = value.start().to_iso_string()
  match value.end() {
    Some(end) => "\{start}..\{end.to_iso_string()}"
    None => "\{start}..pending"
  }
}

///|
fn calendar_fixture() -> Val[Html] {
  let today = @rui.calendar_date(year=2026, month=7, day=16)
  let calendar = @rui.calendar(
    default_selected=today,
    today~,
    aria_label="Fixture calendar",
  )
  calendar.map(calendar_html => {
    @fixture.section("fixture-section-calendar", "Calendar", [calendar_html])
  })
}

///|
fn calendar_range_fixture() -> Val[Html] {
  let today = @rui.calendar_date(year=2026, month=7, day=16)
  let (selection, set_selection) = @rabbita.create_variable(
    "2026-07-10..2026-07-17",
  )
  let calendar = @rui.calendar_range(
    id="fixture-calendar-range",
    default_month=@rui.calendar_date(year=2026, month=7, day=1),
    default_selected=@rui.date_range(
      start=@rui.calendar_date(year=2026, month=7, day=10),
      end=@rui.calendar_date(year=2026, month=7, day=17),
    ),
    today~,
    aria_label="Fixture release window",
    on_select=set_selection.map(value => _ => fixture_range_text(value)),
  )
  calendar.map2(selection, fn(calendar, selection) {
    @fixture.section("fixture-section-calendar-range", "Calendar Range", [
      calendar,
      @html.output(id="fixture-calendar-range-output", selection),
    ])
  })
}

///|
fn calendar_multiple_fixture() -> Val[Html] {
  let today = @rui.calendar_date(year=2026, month=7, day=16)
  let (selection, set_selection) = @rabbita.create_variable(
    "2026-07-08,2026-07-16",
  )
  let calendar = @rui.calendar_multiple(
    id="fixture-calendar-multiple",
    default_month=@rui.calendar_date(year=2026, month=7, day=1),
    default_selected=[@rui.calendar_date(year=2026, month=7, day=8), today],
    today~,
    aria_label="Fixture available dates",
    on_select=set_selection.map(values => {
      _ => values.map(date => date.to_iso_string()).join(",")
    }),
  )
  calendar.map2(selection, fn(calendar, selection) {
    @fixture.section("fixture-section-calendar-multiple", "Calendar Multiple", [
      calendar,
      @html.output(id="fixture-calendar-multiple-output", selection),
    ])
  })
}
