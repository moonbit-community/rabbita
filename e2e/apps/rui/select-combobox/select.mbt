///|
fn select_fixture() -> Val[Html] {
  let select = @rui.select(
    id="fixture-select",
    options=[
      @rui.select_option(value="alpha", label="Alpha"),
      @rui.select_option(value="beta", label="Beta"),
      @rui.select_option(value="gamma", label="Gamma", disabled=true),
    ],
    placeholder="Choose an option…",
  )
  select.map(select_html => {
    @fixture.section("fixture-section-select", "Select", [select_html])
  })
}
