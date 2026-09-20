///|
fn date_picker_fixture() -> Val[Html] {
  let today = @rui.calendar_date(year=2026, month=7, day=16)
  let picker = @rui.date_picker(
    id="fixture-date-picker",
    default_value=today,
    today~,
    placeholder="Pick a date…",
    aria_label="Fixture date picker",
    presets=[
      @rui.date_picker_preset(label="Today", value=today),
      @rui.date_picker_preset(
        label="Release",
        value=@rui.calendar_date(year=2026, month=8, day=4),
      ),
    ],
  )
  picker.map(picker_html => {
    @fixture.section("fixture-section-date-picker", "Date picker", [picker_html])
  })
}
