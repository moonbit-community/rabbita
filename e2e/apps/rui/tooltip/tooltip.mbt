///|
fn tooltip_fixture() -> Val[Html] {
  let tip = @rui.tooltip(
    id="fixture-tooltip",
    delay=80,
    close_delay=0,
    show_arrow=true,
    trigger_variant=Outline,
    "Hover for tooltip",
    "Tooltip body content",
  )
  tip.map(tip_html => {
    @fixture.section("fixture-section-tooltip", "Tooltip", [tip_html])
  })
}
