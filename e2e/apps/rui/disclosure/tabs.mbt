///|
fn tabs_fixture() -> Val[Html] {
  let horizontal = @rui.tabs(
    id="fixture-tabs-horizontal",
    default_value="preview",
    orientation=TabsHorizontal,
    aria_label="Fixture workflow",
    items=[
      @rui.tab_entry(
        value="preview",
        label="Preview",
        content=div("Preview panel content"),
      ),
      @rui.tab_entry(
        value="source",
        label="Source",
        content=div("Source panel content"),
      ),
      @rui.tab_entry(
        value="disabled",
        label="Disabled",
        disabled=true,
        content=div("Disabled panel content"),
      ),
    ],
  )
  let vertical = @rui.tabs(
    id="fixture-tabs-vertical",
    default_value="general",
    orientation=TabsVertical,
    aria_label="Fixture settings",
    items=[
      @rui.tab_entry(
        value="general",
        label="General",
        content=div("General settings content"),
      ),
      @rui.tab_entry(
        value="members",
        label="Members",
        content=div("Member settings content"),
      ),
      @rui.tab_entry(
        value="billing",
        label="Billing",
        content=div("Billing settings content"),
      ),
    ],
  )
  horizontal.map2(vertical, fn(horizontal, vertical) {
    @fixture.section("fixture-section-tabs", "Tabs", [
      div(style=["width:min(100%,28rem)"], horizontal),
      div(style=["width:min(100%,28rem)"], vertical),
    ])
  })
}
