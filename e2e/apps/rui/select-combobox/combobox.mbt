///|
fn combobox_fixture() -> Val[Html] {
  let combobox = @rui.combobox(
    id="fixture-combobox",
    options=[
      @rui.combobox_option(value="moonbit", label="MoonBit"),
      @rui.combobox_option(value="rabbita", label="Rabbita"),
      @rui.combobox_option(value="typescript", label="TypeScript"),
      @rui.combobox_option(value="rust", label="Rust"),
    ],
    placeholder="Search runtimes…",
    empty_text="No matching runtimes.",
  )
  combobox.map(combobox_html => {
    @fixture.section("fixture-section-combobox", "Combobox", [combobox_html])
  })
}
