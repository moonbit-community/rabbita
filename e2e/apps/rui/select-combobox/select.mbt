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
  let modal_select = @rui.select(id="fixture-modal-select", options=[
    @rui.select_option(value="alpha", label="Alpha"),
  ])
  select.map2(modal_select, (select_html, modal_select_html) => {
    @fixture.section("fixture-section-select", "Select", [
      select_html,
      @html.dialog(
        id="fixture-select-dialog",
        attrs=@html.Attrs::build().aria_label("Select in a modal"),
        modal_select_html,
      ),
    ])
  })
}
