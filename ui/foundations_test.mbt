///|
#warnings("-alert_unstable")
fn render(html : @html.Html) -> String {
  @rabbita.render_to_string(() => @rabbita.Val::constant(html))
}

///|
fn assert_contains(actual : String, expected : String) -> Unit raise {
  if !actual.contains(expected) {
    fail("expected rendered HTML to contain `\{expected}`; got `\{actual}`")
  }
}

///|
fn assert_not_contains(actual : String, unexpected : String) -> Unit raise {
  if actual.contains(unexpected) {
    fail(
      "expected rendered HTML not to contain `\{unexpected}`; got `\{actual}`",
    )
  }
}

///|
test "button is a zero-setup native button" {
  let html = render(
    @rabbita-ui.button(
      variant=@rabbita-ui.Outline,
      size=@rabbita-ui.Sm,
      disabled=true,
      style=["background:rebeccapurple"],
      "Save",
    ),
  )
  assert_contains(html, "<button")
  assert_contains(html, "type=\"button\"")
  assert_contains(html, "disabled")
  assert_contains(html, "height:2rem")
  assert_contains(
    html, "background:var(--rui-button-bg,var(--rui-button-base-bg,transparent))",
  )
  assert_contains(
    html, "--rui-button-base-bg:var(--rui-outline-background,var(--rui-background,oklch(1 0 0)))",
  )
  assert_contains(
    html, "box-shadow:var(--rui-button-shadow,var(--rui-button-base-shadow,none))",
  )
  assert_contains(
    html, "cursor:not-allowed;pointer-events:none;opacity:0.5;background:rebeccapurple",
  )
  assert_contains(html, ">Save</button>")
}

///|
test "caller styles are appended after the built-in recipe" {
  let html = render(
    @rabbita-ui.badge(
      style=["background:rebeccapurple", "border-radius:2px"],
      "Custom",
    ),
  )
  assert_contains(
    html, "--rui-badge-base-bg:var(--rui-primary,oklch(0.205 0 0));--rui-badge-base-fg:var(--rui-primary-foreground,oklch(0.985 0 0));--rui-badge-base-border:transparent;background:rebeccapurple;border-radius:2px",
  )
}

///|
test "destructive controls keep the Vega solid surface before hover" {
  let button_html = render(
    @rabbita-ui.button(variant=@rabbita-ui.Destructive, "Delete"),
  )
  assert_contains(
    button_html, "--rui-button-base-bg:var(--rui-destructive-surface,var(--rui-destructive",
  )
  assert_contains(button_html, "--rui-button-base-fg:white")

  let badge_html = render(
    @rabbita-ui.badge(variant=@rabbita-ui.Destructive, "Failed"),
  )
  assert_contains(
    badge_html, "--rui-badge-base-bg:var(--rui-destructive-surface,var(--rui-destructive",
  )
  assert_contains(badge_html, "--rui-badge-base-fg:white")
}

///|
test "theme supplies dark Neutral tokens inline" {
  let html = render(
    @rabbita-ui.theme(mode=@rabbita-ui.Dark, @rabbita-ui.badge("Dark")),
  )
  assert_contains(html, "color-scheme:dark")
  assert_contains(html, "--rui-background:oklch(0.145 0 0)")
  assert_contains(
    html, "<style data-rui-style=\"interactions\">@keyframes rui-spin",
  )
  assert_contains(html, "@layer rui-interactions")
  assert_contains(html, ":hover")
  assert_contains(html, ":focus-visible")
  assert_contains(html, "[data-state=\"on\"]")
  assert_contains(html, "::-webkit-slider-thumb")
  assert_contains(html, "[data-slot=\"combobox-chip-remove\"]")
  assert_contains(html, "--rui-field-label-checked-bg")
  assert_contains(html, "--rui-tabs-active-bg")
  assert_contains(html, ":where([hidden]:not([hidden=\"until-found\"]))")
  assert_contains(
    html, ":where([data-slot=\"accordion-trigger\"],[data-slot=\"collapsible-trigger\"]):not([aria-disabled=\"true\"]):hover",
  )
  assert_contains(
    html, ":where([data-slot=\"toggle\"],[data-slot=\"toggle-group-item\"]):not(:disabled):not([aria-disabled=\"true\"])[data-variant][data-state=\"on\"]",
  )
  assert_contains(
    html, ":not([aria-disabled=\"true\"]):not([aria-haspopup]):active",
  )
  assert_contains(html, "transform:translateY(1px)")
  assert_contains(html, "[data-state=\"off\"][data-variant=\"outline\"]:hover")
  assert_contains(
    html, ":where(button,a)[data-variant=\"destructive\"][data-size]:not(:disabled):not([aria-disabled=\"true\"]):focus-visible",
  )
  assert_contains(
    html, "[data-slot=\"navigation-menu-trigger\"][data-state=\"open\"]:not(:disabled):hover",
  )
  assert_contains(
    html, "[data-slot=\"navigation-menu-link\"][data-active=\"true\"]:not(:disabled):focus",
  )
  assert_contains(
    html, "[data-slot=\"sidebar-menu-button\"][data-active=\"true\"] ~ [data-slot=\"sidebar-menu-badge\"]",
  )
  assert_contains(html, "@media (hover: none)")
  assert_contains(
    html, "[data-slot=\"popover-content\"][data-date-range-picker-popup]",
  )
  assert_contains(html, "--rui-date-range-picker-width:15.5rem")
  assert_contains(html, "--rui-date-range-picker-max-height:calc(100% - 1rem)")
  assert_contains(html, ":not([data-range-start]):not([data-range-end]):hover")
  assert_contains(
    html, "[data-slot=\"combobox-chip-remove\"]:not(:disabled):not([aria-disabled=\"true\"]):focus-visible",
  )
  assert_not_contains(html, "&gt;")
  assert_contains(html, ">Dark</span>")
}
