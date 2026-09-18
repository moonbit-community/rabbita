///|
let fixture_slide_style : String = "display:flex;align-items:center;justify-content:center;height:8rem;background:var(--rui-muted,oklch(0.97 0 0));border-radius:0.5rem"

///|
fn carousel_fixture() -> Val[Html] {
  let carousel = @rui.carousel(
    id="fixture-carousel",
    count=3,
    loop_=true,
    orientation=CarouselHorizontal,
    aria_label="Fixture carousel",
    style=["width:24rem"],
    scope => {
      fragment([
        @rui.carousel_items(scope~, items=[
          div(style=[fixture_slide_style], "First slide"),
          div(style=[fixture_slide_style], "Second slide"),
          div(style=[fixture_slide_style], "Third slide"),
        ]),
        @rui.carousel_previous(scope~),
        @rui.carousel_next(scope~),
      ])
    },
  )
  carousel.map(carousel_html => {
    @fixture.section("fixture-section-carousel", "Carousel", [carousel_html])
  })
}

///|
fn carousel_non_loop_fixture() -> Val[Html] {
  let (index, set_index) = @rabbita.create_variable(0)
  let carousel = @rui.carousel(
    id="fixture-carousel-non-loop",
    count=3,
    loop_=false,
    aria_label="Fixture bounded carousel",
    on_index_change=set_index.map(value => _ => value),
    style=["width:24rem"],
    scope => {
      fragment([
        @rui.carousel_items(scope~, items=[
          div(style=[fixture_slide_style], "Bounded first slide"),
          div(style=[fixture_slide_style], "Bounded second slide"),
          div(style=[fixture_slide_style], "Bounded third slide"),
        ]),
        @rui.carousel_previous(scope~),
        @rui.carousel_next(scope~),
      ])
    },
  )
  carousel.map2(index, fn(carousel, index) {
    @fixture.section("fixture-section-carousel-non-loop", "Carousel Bounded", [
      carousel,
      @html.output(id="fixture-carousel-non-loop-output", "index:\{index}"),
    ])
  })
}
