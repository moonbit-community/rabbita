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
fn message_scroller_fixture() -> Val[Html] {
  let scroller = @rui.message_scroller(
    id="fixture-message-scroller",
    default_at_end=false,
    style=[
      "width:20rem;height:10rem;border:1px solid \{fixture_section_border}",
    ],
    scope => {
      fragment([
        @rui.message_scroller_viewport(
          scope~,
          @rui.message_scroller_content(
            fixture_scroll_items("message-scroller-item").map(item => {
              @rui.message_scroller_item(style=["min-height:3rem"], item)
            }),
          ),
        ),
        @rui.message_scroller_button(
          scope~,
          direction=ScrollStart,
          label="Jump to first fixture message",
          "↑",
        ),
        @rui.message_scroller_button(
          scope~,
          direction=ScrollEnd,
          label="Jump to latest fixture message",
          "↓",
        ),
      ])
    },
  )
  scroller.map(scroller => {
    @fixture.section("fixture-section-message-scroller", "Message Scroller", [
      scroller,
    ])
  })
}
