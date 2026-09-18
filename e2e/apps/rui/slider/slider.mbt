///|
fn slider_fixture() -> Val[Html] {
  let slider = @rui.slider(
    id="fixture-slider",
    default_value=30,
    min=0,
    max=100,
    step=10,
    aria_label="Fixture slider",
    style=["width:min(100%,20rem)"],
  )
  slider.map(slider_html => {
    @fixture.section("fixture-section-slider", "Slider", [slider_html])
  })
}
