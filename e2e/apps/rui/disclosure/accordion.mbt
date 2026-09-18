///|
fn accordion_fixture() -> Val[Html] {
  let single = @rui.accordion(
    id="fixture-accordion-single",
    type_=Single,
    collapsible=true,
    default_value="keyboard",
    items=[
      @rui.accordion_entry(
        value="keyboard",
        label="Keyboard interaction",
        content=p(style=["margin:0"], "Enter and Space toggle this panel."),
      ),
      @rui.accordion_entry(
        value="state",
        label="Owned state",
        content=p(style=["margin:0"], "Only one panel stays open."),
      ),
      @rui.accordion_entry(
        value="disabled",
        label="Unavailable section",
        disabled=true,
        content=p(style=["margin:0"], "This content stays unavailable."),
      ),
    ],
  )
  let multiple = @rui.accordion(
    id="fixture-accordion-multiple",
    type_=Multiple,
    default_values=["first"],
    items=[
      @rui.accordion_entry(
        value="first",
        label="First independent panel",
        content=p(style=["margin:0"], "First panel content"),
      ),
      @rui.accordion_entry(
        value="second",
        label="Second independent panel",
        content=p(style=["margin:0"], "Second panel content"),
      ),
    ],
  )
  single.map2(multiple, fn(single, multiple) {
    @fixture.section("fixture-section-accordion", "Accordion", [
      div(style=["width:min(100%,28rem)"], single),
      div(style=["width:min(100%,28rem)"], multiple),
    ])
  })
}
