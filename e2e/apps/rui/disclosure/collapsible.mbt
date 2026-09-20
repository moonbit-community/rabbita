///|
fn collapsible_fixture() -> Val[Html] {
  let enabled = @rui.collapsible(
    id="fixture-collapsible",
    trigger="Advanced settings",
    content=p(style=["margin:0"], "Advanced settings content"),
  )
  let disabled = @rui.collapsible(
    id="fixture-collapsible-disabled",
    disabled=true,
    trigger="Unavailable settings",
    content=p(style=["margin:0"], "Unavailable content"),
  )
  enabled.map2(disabled, fn(enabled, disabled) {
    @fixture.section("fixture-section-collapsible", "Collapsible", [
      div(style=["width:min(100%,24rem)"], enabled),
      div(style=["width:min(100%,24rem)"], disabled),
    ])
  })
}
