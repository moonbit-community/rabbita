///|
test "checkbox owns checked and mixed state through incremental API" {
  let html = render_incremental(() => {
    @rabbita-ui.checkbox(default_indeterminate=true, aria_label="Select all")
  })
  assert_contains(html, "data-slot=\"checkbox\"")
  assert_contains(html, "aria-checked=\"mixed\"")
  assert_contains(html, "data-state=\"indeterminate\"")
}

///|
test "switch and toggle expose black-box initial state" {
  let switch_html = render_incremental(() => {
    @rabbita-ui.switch(default_checked=true, aria_label="Notifications")
  })
  assert_contains(switch_html, "role=\"switch\"")
  assert_contains(switch_html, "aria-checked=\"true\"")

  let toggle_html = render_incremental(() => {
    @rabbita-ui.toggle(default_pressed=true, "Bold")
  })
  assert_contains(toggle_html, "aria-pressed=\"true\"")
  assert_contains(toggle_html, "data-state=\"on\"")
}

///|
test "radio group owns one shared selected value" {
  let html = render_incremental(() => {
    @rabbita-ui.radio_group(
      default_value="pro",
      name="plan",
      aria_label="Plan",
      scope => {
        [
          @rabbita-ui.radio_group_item(scope~, value="free", aria_label="Free"),
          @rabbita-ui.radio_group_item(scope~, value="pro", aria_label="Pro"),
        ]
      },
    )
  })
  assert_contains(html, "role=\"radiogroup\"")
  assert_contains(html, "data-value=\"pro\"")
  assert_contains(html, "name=\"plan\"")
  assert_contains(html, "value=\"pro\"")
  assert_contains(html, "data-checked=\"\"")
}
