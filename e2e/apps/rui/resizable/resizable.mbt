///|
let fixture_resizable_panel_style : String = "display:flex;align-items:center;justify-content:center;background:var(--rui-muted,oklch(0.97 0 0));border-radius:0.5rem"

///|
fn resizable_fixture() -> Val[Html] {
  let group = @rui.resizable_panel_group(
    id="fixture-resizable",
    default_size=50,
    min=25,
    max=75,
    orientation=Vertical,
    aria_label="Resize fixture panels",
    style=["height:12rem;width:min(100%,32rem)"],
    scope => {
      fragment([
        @rui.resizable_panel(
          scope~,
          side=FirstPanel,
          style=[fixture_resizable_panel_style],
          "First panel",
        ),
        @rui.resizable_handle(
          scope~,
          with_handle=true,
          aria_label="Resize fixture panels",
        ),
        @rui.resizable_panel(
          scope~,
          side=SecondPanel,
          style=[fixture_resizable_panel_style],
          "Second panel",
        ),
      ])
    },
  )
  group.map(group_html => {
    @fixture.section("fixture-section-resizable", "Resizable", [group_html])
  })
}
