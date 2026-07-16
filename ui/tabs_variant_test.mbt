///|
test "tabs expose the Vega line list variant through the black-box API" {
  let items = [
    @rabbita-ui.tab_entry(
      value="preview",
      label="Preview",
      content=@html.p("Preview content"),
    ),
    @rabbita-ui.tab_entry(
      value="code",
      label="Code",
      content=@html.p("Code content"),
    ),
  ]
  let html = render_incremental(() => {
    @rabbita-ui.tabs(
      items~,
      default_value="preview",
      list_variant=@rabbita-ui.TabsLine,
      list_style=["gap:0.75rem"],
    )
  })
  assert_contains(
    html, "data-slot=\"tabs-list\" data-orientation=\"horizontal\" data-variant=\"line\"",
  )
  assert_contains(
    html, "gap:0.25rem;border-radius:0;background:transparent;overflow:visible;min-height:2.25rem;flex-direction:row;gap:0.75rem",
  )
  assert_element_tag_contains(
    html, "data-value=\"preview\" role=\"tab\"", "data-state=\"active\"",
  )
  assert_contains(
    html, "--rui-tabs-base-shadow:var(--rui-tabs-active-shadow,0 1px 2px rgb(0 0 0 / 0.05))",
  )
}

///|
test "tabs keep the default muted list variant for existing callers" {
  let html = render(
    @rabbita-ui.tabs_list(
      @rabbita-ui.tabs_trigger(value="one", selected=true, "One"),
    ),
  )
  assert_contains(html, "data-variant=\"default\"")
  assert_contains(
    html, "background:var(--rui-muted,oklch(0.97 0 0));overflow-x:auto",
  )
}

///|
test "theme supplies line tab indicators without consumer CSS" {
  let html = render(
    @rabbita-ui.theme(
      @rabbita-ui.tabs_list(
        variant=@rabbita-ui.TabsLine,
        @rabbita-ui.tabs_trigger(value="one", selected=true, "One"),
      ),
    ),
  )
  assert_contains(
    html, "[data-slot=\"tabs-list\"][data-variant=\"line\"] > [data-slot=\"tabs-trigger\"]::after",
  )
  assert_contains(html, "--rui-tabs-active-bg:transparent")
  assert_contains(html, "--rui-tabs-active-shadow:none")
  assert_contains(html, "bottom:-5px")
  assert_contains(html, "inset-inline-end:-0.25rem")
  assert_contains(
    html, "[data-slot=\"tabs-trigger\"][data-state=\"active\"]::after",
  )
  assert_not_contains(html, "&gt;")
}
