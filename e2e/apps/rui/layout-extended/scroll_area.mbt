///|
fn fixture_scroll_items(prefix : String) -> Array[Html] {
  let items : Array[Html] = []
  for index in 1..<=18 {
    items.push(
      div(
        id="\{prefix}-\{index}",
        style=["height:2rem;flex:none;padding:0.25rem"],
        "Fixture item \{index}",
      ),
    )
  }
  items
}

///|
fn scroll_area_fixture() -> Val[Html] {
  let vertical = @rui.scroll_area_with_scrollbar(
    id="fixture-scroll-area",
    orientation=Vertical,
    style=["width:18rem;height:8rem;border:1px solid \{fixture_section_border}"],
    div(
      style=["display:flex;flex-direction:column"],
      fixture_scroll_items("scroll-item"),
    ),
  )
  let horizontal = @rui.scroll_area_with_scrollbar(
    id="fixture-scroll-area-horizontal",
    orientation=Horizontal,
    style=["width:18rem;height:4rem;border:1px solid \{fixture_section_border}"],
    div(
      style=["display:flex;width:56rem;height:100%;align-items:center;gap:1rem"],
      fixture_scroll_items("horizontal-scroll-item"),
    ),
  )
  vertical.map2(horizontal, fn(vertical, horizontal) {
    @fixture.section("fixture-section-scroll-area", "Scroll Area", [
      vertical, horizontal,
    ])
  })
}
