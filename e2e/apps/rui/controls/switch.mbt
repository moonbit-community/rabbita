///|
fn switch_fixture() -> Val[Html] {
  let enabled = @rui.switch(
    id="fixture-switch",
    aria_label="Enable fixture previews",
  )
  let disabled = @rui.switch(
    id="fixture-switch-disabled",
    default_checked=true,
    disabled=true,
    aria_label="Managed fixture backups",
  )
  enabled.map2(disabled, fn(enabled, disabled) {
    @fixture.section("fixture-section-switch", "Switch", [
      label(for_="fixture-switch", [enabled, span("Live previews")]),
      label(for_="fixture-switch-disabled", [disabled, span("Managed backups")]),
    ])
  })
}
