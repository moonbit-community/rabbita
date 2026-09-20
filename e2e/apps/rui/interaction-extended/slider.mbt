///|
fn slider_values_fixture() -> Val[Html] {
  let (changed, set_changed) = @rabbita.create_variable("20,80")
  let (committed, set_committed) = @rabbita.create_variable("none")
  let slider = @rui.slider_values(
    id="fixture-slider-values",
    default_values=[20, 80],
    min=0,
    max=100,
    step=10,
    large_step=30,
    min_steps_between_values=2,
    aria_label="Fixture budget",
    on_value_change=set_changed.map(values => {
      _ => values.map(value => value.to_string()).join(",")
    }),
    on_value_commit=set_committed.map(values => {
      _ => values.map(value => value.to_string()).join(",")
    }),
    style=["width:min(100%,24rem)"],
  )
  slider.map3(changed, committed, fn(slider, changed, committed) {
    @fixture.section("fixture-section-slider-values", "Slider Values", [
      slider,
      @html.output(
        id="fixture-slider-values-output",
        "change:\{changed}|commit:\{committed}",
      ),
    ])
  })
}
