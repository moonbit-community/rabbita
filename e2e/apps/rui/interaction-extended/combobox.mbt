///|
fn combobox_multiple_fixture() -> Val[Html] {
  let options = [
    @rui.combobox_option(value="moonbit", label="MoonBit"),
    @rui.combobox_option(value="rabbita", label="Rabbita"),
    @rui.combobox_option(value="typescript", label="TypeScript"),
    @rui.combobox_option(value="legacy", label="Legacy runtime", disabled=true),
  ]
  let (values, set_values) = @rabbita.create_variable("moonbit,rabbita")
  let combobox = @rui.combobox(
    id="fixture-combobox-multiple",
    options~,
    multiple=true,
    default_values=["moonbit", "rabbita"],
    placeholder="Add a fixture runtime…",
    empty_text="No additional runtimes.",
    name="fixture-runtimes",
    on_values_change=set_values.map(values => _ => values.join(",")),
  )
  combobox.map2(values, fn(combobox, values) {
    @fixture.section("fixture-section-combobox-multiple", "Combobox Multiple", [
      div(style=["width:min(100%,24rem)"], combobox),
      @html.output(id="fixture-combobox-multiple-output", values),
    ])
  })
}
