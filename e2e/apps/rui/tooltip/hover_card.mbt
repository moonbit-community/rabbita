///|
fn hover_card_fixture() -> Val[Html] {
  let card = @rui.hover_card(
    id="fixture-hover-card",
    href="#fixture-section-hover-card",
    open_delay=80,
    close_delay=40,
    trigger_variant=Outline,
    "Hover profile",
    div(style=["display:flex;flex-direction:column;gap:0.5rem"], [
      strong("Rabbita UI"),
      p(style=["margin:0"], "Native MoonBit components with incremental state."),
    ]),
  )
  card.map(card_html => {
    @fixture.section("fixture-section-hover-card", "Hover card", [card_html])
  })
}
