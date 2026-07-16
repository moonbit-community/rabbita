///|
test "toggle group propagates the Vega variant size and spacing recipe" {
  let html = render_incremental(() => {
    @rabbita-ui.toggle_group(
      default_values=["bold"],
      multiple=true,
      orientation=@rabbita-ui.Vertical,
      variant=@rabbita-ui.Outline,
      size=@rabbita-ui.Lg,
      spacing=0,
      scope => {
        [
          @rabbita-ui.toggle_group_item(scope~, value="bold", "Bold"),
          @rabbita-ui.toggle_group_item(scope~, value="italic", "Italic"),
        ]
      },
    )
  })
  assert_contains(html, "data-slot=\"toggle-group\"")
  assert_contains(html, "data-orientation=\"vertical\"")
  assert_contains(html, "data-variant=\"outline\"")
  assert_contains(html, "data-size=\"lg\"")
  assert_contains(html, "data-spacing=\"0\"")
  assert_contains(html, "--rui-toggle-group-gap:0rem")
  assert_contains(html, "gap:var(--rui-toggle-group-gap)")
  assert_contains(html, "flex-direction:column;align-items:stretch")
  assert_contains(html, "--rui-toggle-base-border:var(--rui-outline-border")
  assert_contains(
    html, "background:var(--rui-toggle-bg,var(--rui-toggle-base-bg,transparent))",
  )
  assert_contains(html, "height:2.5rem")
  assert_contains(
    html, "width:auto;min-width:0;flex-shrink:0;--rui-toggle-padding-inline:0.75rem;--rui-toggle-base-radius:0;--rui-toggle-base-shadow:none",
  )
  assert_contains(
    html, "--rui-toggle-base-bg:var(--rui-accent,oklch(0.97 0 0))",
  )
  assert_contains(
    html, "data-slot=\"toggle-group-item\" data-variant=\"outline\" data-size=\"lg\" data-spacing=\"0\" data-value=\"bold\" data-state=\"on\"",
  )
  assert_contains(
    html, "data-slot=\"toggle-group-item\" data-variant=\"outline\" data-size=\"lg\" data-spacing=\"0\" data-value=\"italic\" data-state=\"off\"",
  )
}

///|
test "toggle group keeps the Vega zero spacing on every item" {
  let html = render_incremental(() => {
    @rabbita-ui.toggle_group(scope => {
      [
        @rabbita-ui.toggle_group_item(scope~, value="left", "Left"),
        @rabbita-ui.toggle_group_item(scope~, value="right", "Right"),
      ]
    })
  })
  assert_contains(html, "data-spacing=\"0\"")
  assert_contains(html, "--rui-toggle-group-gap:0rem")
  assert_contains(
    html, "data-slot=\"toggle-group-item\" data-variant=\"default\" data-size=\"default\" data-spacing=\"0\"",
  )
}
