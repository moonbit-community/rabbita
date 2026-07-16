///|
test "input exposes native field state and caller override" {
  let html = render(
    @rabbita-ui.input(
      id="email",
      value="hello@example.com",
      placeholder="you@example.com",
      required=true,
      invalid=true,
      style=["background:rebeccapurple", "height:3rem"],
    ),
  )
  assert_contains(html, "<input")
  assert_contains(html, "id=\"email\"")
  assert_contains(html, "aria-invalid=\"true\"")
  assert_contains(html, "required")
  assert_contains(
    html, "background:var(--rui-control-bg,var(--rui-control-base-bg,var(--rui-input-background,transparent)))",
  )
  assert_contains(
    html, "border-color:var(--rui-control-border,var(--rui-control-base-border,var(--rui-input,oklch(0.922 0 0))))",
  )
  assert_contains(html, "background:rebeccapurple;height:3rem")
  assert_contains(html, "height:3rem")
}

///|
test "textarea SSR value is text content" {
  let html = render(@rabbita-ui.textarea(value="one < two & three"))
  assert_contains(
    html, "box-shadow:var(--rui-control-shadow,var(--rui-control-base-shadow,0 1px 2px rgb(0 0 0 / 0.05)))",
  )
  assert_contains(html, ">one &lt; two &amp; three</textarea>")
  assert_not_contains(html, "value=\"one")
}

///|
test "card composition carries shadcn slots" {
  let html = render(
    @rabbita-ui.card([
      @rabbita-ui.card_header([
        @rabbita-ui.card_title("Account"),
        @rabbita-ui.card_description("Profile details"),
      ]),
      @rabbita-ui.card_content("Content"),
      @rabbita-ui.card_footer("Footer"),
    ]),
  )
  assert_contains(html, "data-slot=\"card\"")
  assert_contains(html, "data-slot=\"card-header\"")
  assert_contains(html, "data-slot=\"card-title\"")
  assert_contains(html, "data-slot=\"card-description\"")
  assert_contains(html, "data-slot=\"card-content\"")
  assert_contains(html, "data-slot=\"card-footer\"")
}

///|
test "checkbox exposes mixed state and native ARIA semantics" {
  let html = render_incremental(() => {
    @rabbita-ui.checkbox(
      default_indeterminate=true,
      invalid=true,
      aria_label="Select all",
    )
  })
  assert_contains(html, "<button")
  assert_contains(html, "type=\"button\"")
  assert_contains(html, "role=\"checkbox\"")
  assert_contains(html, "aria-checked=\"mixed\"")
  assert_contains(html, "aria-invalid=\"true\"")
  assert_contains(html, "data-slot=\"checkbox\"")
  assert_contains(html, "data-state=\"indeterminate\"")
  assert_contains(html, "data-indeterminate=\"\"")
  assert_contains(
    html, "--rui-control-base-bg:var(--rui-primary,oklch(0.205 0 0))",
  )
  assert_contains(
    html, "background:var(--rui-control-bg,var(--rui-control-base-bg,var(--rui-input-background,transparent)))",
  )
  assert_contains(
    html, "border-color:var(--rui-destructive-border,var(--rui-destructive,oklch(0.577 0.245 27.325)))",
  )
}

///|
test "switch and toggle expose black-box initial state" {
  let switch_html = render_incremental(() => {
    @rabbita-ui.switch(
      default_checked=true,
      size=@rabbita-ui.Sm,
      aria_label="Notifications",
      style=["outline-offset:4px"],
    )
  })
  assert_contains(switch_html, "role=\"switch\"")
  assert_contains(switch_html, "aria-checked=\"true\"")
  assert_contains(switch_html, "data-slot=\"switch\"")
  assert_contains(switch_html, "data-size=\"sm\"")
  assert_contains(switch_html, "data-checked=\"\"")
  assert_contains(switch_html, "width:1.5rem")
  assert_contains(switch_html, "outline-offset:4px")
  assert_contains(
    switch_html, "--rui-control-base-bg:var(--rui-primary,oklch(0.205 0 0))",
  )
  assert_contains(
    switch_html, "background:var(--rui-control-bg,var(--rui-control-base-bg,var(--rui-switch-unchecked,var(--rui-input,oklch(0.922 0 0)))))",
  )

  let toggle_html = render_incremental(() => {
    @rabbita-ui.toggle(
      default_pressed=true,
      variant=@rabbita-ui.Outline,
      "Bold",
    )
  })
  assert_contains(toggle_html, "aria-pressed=\"true\"")
  assert_contains(toggle_html, "data-slot=\"toggle\"")
  assert_contains(toggle_html, "data-variant=\"outline\"")
  assert_contains(toggle_html, "data-pressed=\"\"")
  assert_contains(toggle_html, "data-state=\"on\"")
  assert_contains(
    toggle_html, "background:var(--rui-toggle-bg,var(--rui-toggle-base-bg,transparent))",
  )
  assert_contains(
    toggle_html, "--rui-toggle-base-bg:var(--rui-accent,oklch(0.97 0 0))",
  )
  assert_contains(toggle_html, ">Bold</button>")
}

///|
test "switch thumb keeps the Vega checked endpoint at both sizes" {
  let default_checked = render_incremental(() => {
    @rabbita-ui.switch(default_checked=true, aria_label="Default switch")
  })
  assert_contains(default_checked, "width:2rem;height:1.15rem")
  assert_contains(default_checked, "width:1rem;height:1rem")
  assert_contains(default_checked, "transform:translateX(calc(100% - 2px))")
  assert_not_contains(default_checked, "background-clip:padding-box")

  let small_checked = render_incremental(() => {
    @rabbita-ui.switch(
      default_checked=true,
      size=@rabbita-ui.Sm,
      aria_label="Small switch",
    )
  })
  assert_contains(small_checked, "width:1.5rem;height:0.875rem")
  assert_contains(small_checked, "width:0.75rem;height:0.75rem")
  assert_contains(small_checked, "transform:translateX(calc(100% - 2px))")

  let unchecked = render_incremental(() => {
    @rabbita-ui.switch(aria_label="Unchecked switch")
  })
  assert_contains(unchecked, "transform:translateX(0)")
}

///|
test "components do not mutate caller attrs" {
  let attrs = @html.Attrs::build().aria_label("Shared")
  ignore(render_incremental(() => @rabbita-ui.checkbox(attrs~)))
  let original = render(@html.div(attrs~, @html.nothing))
  assert_contains(original, "aria-label=\"Shared\"")
  assert_not_contains(original, "role=\"checkbox\"")
  assert_not_contains(original, "aria-checked")
}

///|
test "alert and separator expose semantic roles" {
  let alert_html = render(
    @rabbita-ui.alert([
      @rabbita-ui.alert_title("Heads up"),
      @rabbita-ui.alert_description("Something changed"),
    ]),
  )
  assert_contains(alert_html, "role=\"alert\"")
  assert_contains(alert_html, "data-slot=\"alert-title\"")

  let separator_html = render(
    @rabbita-ui.separator(orientation=@rabbita-ui.Vertical, decorative=false),
  )
  assert_contains(separator_html, "role=\"separator\"")
  assert_contains(separator_html, "aria-orientation=\"vertical\"")
}
