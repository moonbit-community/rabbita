///|
fn radio_group_fixture() -> Val[Html] {
  let group = @rui.radio_group(
    default_value="monthly",
    name="fixture-billing",
    orientation=RadioHorizontal,
    aria_label="Billing cycle",
    scope => {
      div(style=["display:flex;flex-wrap:wrap;align-items:center;gap:1rem"], [
        div(style=["display:flex;align-items:center;gap:0.5rem"], [
          @rui.radio_group_item(
            scope~,
            value="monthly",
            id="fixture-billing-monthly",
            aria_label="Monthly",
          ),
          label(for_="fixture-billing-monthly", "Monthly"),
        ]),
        div(style=["display:flex;align-items:center;gap:0.5rem"], [
          @rui.radio_group_item(
            scope~,
            value="annual",
            id="fixture-billing-annual",
            aria_label="Annual",
          ),
          label(for_="fixture-billing-annual", "Annual"),
        ]),
        div(style=["display:flex;align-items:center;gap:0.5rem"], [
          @rui.radio_group_item(
            scope~,
            value="weekly",
            id="fixture-billing-weekly",
            aria_label="Weekly",
          ),
          label(for_="fixture-billing-weekly", "Weekly"),
        ]),
      ])
    },
  )
  group.map(group_html => {
    @fixture.section("fixture-section-radio", "Radio group", [group_html])
  })
}
