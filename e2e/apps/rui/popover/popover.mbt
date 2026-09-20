///|
fn popover_fixture() -> Val[Html] {
  let popover = @rui.popover(
    id="fixture-popover",
    title_id="fixture-popover-title",
    description_id="fixture-popover-desc",
    trigger_variant=Outline,
    "Open popover",
    div(style=["display:flex;flex-direction:column;gap:0.5rem"], [
      @rui.popover_header([
        @rui.popover_title(id="fixture-popover-title", "Popover title"),
        @rui.popover_description(
          id="fixture-popover-desc",
          "Popover description.",
        ),
      ]),
      @rui.popover_close_button(target_id="fixture-popover", size=Sm, "Apply"),
    ]),
  )
  popover.map(popover_html => {
    @fixture.section("fixture-section-popover", "Popover", [popover_html])
  })
}
