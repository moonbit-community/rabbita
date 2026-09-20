///|
fn date_range_picker_fixture() -> Val[Html] {
  let today = @rui.calendar_date(year=2026, month=7, day=16)
  let (selection, set_selection) = @rabbita.create_variable(
    "2026-07-20..2026-07-24",
  )
  let (open_state, set_open_state) = @rabbita.create_variable("closed")
  let picker = @rui.date_range_picker(
    id="fixture-date-range-picker",
    default_value=@rui.date_range(
      start=@rui.calendar_date(year=2026, month=7, day=20),
      end=@rui.calendar_date(year=2026, month=7, day=24),
    ),
    today~,
    aria_label="Fixture deployment window",
    on_value_change=set_selection.map(value => _ => fixture_range_text(value)),
    on_open_change=set_open_state.map(open => {
      _ => if open { "open" } else { "closed" }
    }),
  )
  picker.map3(selection, open_state, fn(picker, selection, open_state) {
    @fixture.section("fixture-section-date-range-picker", "Date Range Picker", [
      picker,
      @html.output(
        id="fixture-date-range-picker-output",
        "state:\{open_state}|value:\{selection}",
      ),
    ])
  })
}
