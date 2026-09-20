///|
fn semantic_status_fixture() -> Html {
  @fixture.section("fixture-section-semantic-status", "Status and Typography", [
    @rui.typography_h2("Fixture typography"),
    @rui.typography_p([
      @rui.typography_lead("Readable component prose"),
      @rui.typography_inline_code("moon test"),
    ]),
    @rui.kbd_group([@rui.kbd("Ctrl"), span("+"), @rui.kbd("K")]),
    @rui.separator(id="fixture-semantic-separator", decorative=false),
    @rui.skeleton(id="fixture-skeleton", title="Loading fixture preview", style=[
      "width:8rem;height:1rem",
    ]),
    @rui.spinner(id="fixture-spinner", label="Loading fixture semantics"),
  ])
}
