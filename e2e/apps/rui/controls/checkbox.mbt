///|
fn checkbox_fixture() -> Val[Html] {
  let unchecked = @rui.checkbox(
    id="fixture-checkbox",
    aria_label="Accept fixture policy",
  )
  let mixed = @rui.checkbox(
    id="fixture-checkbox-mixed",
    default_indeterminate=true,
    aria_label="Select all fixture items",
  )
  let disabled = @rui.checkbox(
    id="fixture-checkbox-disabled",
    default_checked=true,
    disabled=true,
    aria_label="Managed fixture policy",
  )
  unchecked.map3(mixed, disabled, fn(unchecked, mixed, disabled) {
    @fixture.section("fixture-section-checkbox", "Checkbox", [
      label(for_="fixture-checkbox", [unchecked, span("Accept policy")]),
      label(for_="fixture-checkbox-mixed", [mixed, span("Select all")]),
      label(for_="fixture-checkbox-disabled", [disabled, span("Managed policy")]),
    ])
  })
}
