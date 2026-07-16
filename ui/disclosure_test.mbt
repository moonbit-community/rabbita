///|
#cfg(target="js")
extern "js" fn install_incremental_test_window() =
  #| () => {
  #|   if (typeof globalThis.window === "undefined") {
  #|     globalThis.window = { requestAnimationFrame: () => 0 };
  #|   }
  #| }

///|
#warnings("-alert_unstable")
#cfg(target="js")
fn render_incremental(builder : () -> @rabbita.Val[@html.Html]) -> String {
  install_incremental_test_window()
  ignore(@rabbita.new(builder))
  @rabbita.render_to_string(builder)
}

///|
#warnings("-alert_unstable")
#cfg(not(target="js"))
fn render_incremental(builder : () -> @rabbita.Val[@html.Html]) -> String {
  @rabbita.render_to_string(builder)
}

///|
test "collapsible composes a native button with an animated default state" {
  let attrs = @html.Attrs::build().data_set("owner", "caller")
  let html = render_incremental(() => {
    @rabbita-ui.collapsible(
      default_open=true,
      id="release-notes",
      trigger_id="release-notes-trigger",
      content_id="release-notes-content",
      attrs~,
      style=["width:32rem"],
      trigger_style=["background:rebeccapurple"],
      trigger="What changed?",
      content="Native button keeps its browser keyboard behavior.",
    )
  })
  assert_contains(html, "<button")
  assert_contains(html, "type=\"button\"")
  assert_contains(html, "data-slot=\"collapsible\"")
  assert_contains(html, "data-state=\"open\"")
  assert_contains(html, "data-open=\"\"")
  assert_contains(html, "aria-expanded=\"true\"")
  assert_contains(html, "aria-controls=\"release-notes-content\"")
  assert_contains(html, "aria-labelledby=\"release-notes-trigger\"")
  assert_contains(html, "data-slot=\"collapsible-indicator\"")
  assert_contains(html, "data-slot=\"collapsible-content-clip\"")
  assert_contains(html, "data-slot=\"collapsible-content-body\"")
  assert_contains(
    html, "grid-template-rows:var(--rui-collapsible-content-rows,0fr)",
  )
  assert_contains(html, "--rui-collapsible-content-rows:1fr")
  assert_contains(
    html, "color:var(--rui-foreground,oklch(0.145 0 0));width:32rem",
  )
  assert_contains(html, "background:rebeccapurple")

  let original = render(@html.div(attrs~, @html.nothing))
  assert_contains(original, "data-owner=\"caller\"")
  assert_not_contains(original, "data-slot")
  assert_not_contains(original, "data-state")
}

///|
test "collapsible owns incremental state and renders its initial value" {
  let html = render_incremental(() => {
    @rabbita-ui.collapsible(
      default_open=true,
      trigger="Advanced settings",
      content="Visible on the first render",
    )
  })
  assert_contains(html, "data-slot=\"collapsible\"")
  assert_contains(html, "data-state=\"open\"")
  assert_contains(html, "aria-hidden=\"false\"")
  assert_contains(html, "--rui-collapsible-content-visibility:visible")
}

///|
test "collapsible derives its trigger and content relationship from the root id" {
  let html = render_incremental(() => {
    @rabbita-ui.collapsible(
      id="derived-disclosure",
      trigger="Details",
      content="More details",
    )
  })
  assert_contains(html, "id=\"derived-disclosure-trigger\"")
  assert_contains(html, "aria-controls=\"derived-disclosure-content\"")
  assert_contains(html, "id=\"derived-disclosure-content\"")
  assert_contains(html, "aria-labelledby=\"derived-disclosure-trigger\"")
}

///|
test "collapsible closed state stays mounted for its exit animation" {
  let html = render_incremental(() => {
    @rabbita-ui.collapsible(
      trigger="Advanced settings",
      content="Hidden after the transition",
    )
  })
  assert_contains(html, "data-slot=\"collapsible-content\"")
  assert_contains(html, "data-state=\"closed\"")
  assert_contains(html, "aria-hidden=\"true\"")
  assert_contains(html, "inert")
  assert_contains(html, "--rui-collapsible-content-rows:0fr")
  assert_contains(html, "--rui-collapsible-content-visibility-delay:200ms")
  assert_not_contains(html, "data-slot=\"collapsible-content\" hidden")
}

///|
test "accordion renders one animated button group with incremental state" {
  let items = [
    @rabbita-ui.accordion_entry(
      value="shipping",
      label="Shipping",
      content=@html.p("Ships in two business days."),
    ),
    @rabbita-ui.accordion_entry(
      value="returns",
      label="Returns",
      content=@html.p("Return within thirty days."),
      disabled=true,
    ),
  ]
  let html = render_incremental(() => {
    @rabbita-ui.accordion(items~, default_value="shipping", id="faq", trigger_style=[
      "padding-inline:0.5rem",
    ])
  })
  assert_contains(html, "data-slot=\"accordion\"")
  assert_contains(html, "data-type=\"single\"")
  assert_contains(html, "data-collapsible=\"true\"")
  assert_contains(html, "data-group=\"faq-group\"")
  assert_contains(html, "id=\"faq-trigger-0\"")
  assert_contains(html, "id=\"faq-content-0\"")
  assert_contains(html, "aria-controls=\"faq-content-0\"")
  assert_contains(html, "aria-labelledby=\"faq-trigger-0\"")
  assert_contains(html, "role=\"region\"")
  assert_contains(html, "data-slot=\"accordion-content-clip\"")
  assert_contains(
    html, "grid-template-rows:var(--rui-accordion-content-rows,0fr)",
  )
  assert_contains(html, "--rui-accordion-content-rows:1fr")
  assert_contains(html, "data-value=\"shipping\"")
  assert_contains(html, "data-state=\"open\"")
  assert_contains(
    html, "border:1px solid var(--rui-accordion-border,var(--rui-accordion-base-border,transparent))",
  )
  assert_contains(
    html, "background:var(--rui-accordion-bg,var(--rui-accordion-base-bg,transparent))",
  )
  assert_contains(
    html, "box-shadow:var(--rui-accordion-shadow,var(--rui-accordion-base-shadow,none))",
  )
  assert_contains(
    html, "--rui-accordion-base-fg:var(--rui-foreground,oklch(0.145 0 0))",
  )
  assert_contains(html, "data-value=\"returns\"")
  assert_contains(html, "aria-disabled=\"true\"")
  assert_contains(html, "data-disabled=\"\"")
  assert_contains(html, "padding-inline:0.5rem")
}

///|
test "accordion multiple mode keeps independent default open values" {
  let items = [
    @rabbita-ui.accordion_entry(
      value="one",
      label="One",
      content=@html.p("First panel"),
    ),
    @rabbita-ui.accordion_entry(
      value="two",
      label="Two",
      content=@html.p("Second panel"),
    ),
  ]
  let html = render_incremental(() => {
    @rabbita-ui.accordion(
      items~,
      default_values=["one", "two"],
      type_=@rabbita-ui.Multiple,
      id="sections",
    )
  })
  assert_contains(html, "data-type=\"multiple\"")
  assert_contains(
    html, "data-slot=\"accordion-item\" data-state=\"open\" data-open=\"\" data-value=\"one\"",
  )
  assert_contains(
    html, "data-slot=\"accordion-item\" data-state=\"open\" data-open=\"\" data-value=\"two\"",
  )
  assert_not_contains(html, "data-group=\"sections-group\"")
}

///|
test "tabs expose tablist, roving tab stops, and linked panels" {
  let items = [
    @rabbita-ui.tab_entry(
      value="account",
      label="Account",
      content=@html.p("Account preferences"),
    ),
    @rabbita-ui.tab_entry(
      value="password",
      label="Password",
      content=@html.p("Password preferences"),
    ),
  ]
  let html = render_incremental(() => {
    @rabbita-ui.tabs(
      items~,
      default_value="password",
      orientation=@rabbita-ui.TabsVertical,
      aria_label="Settings",
      id="settings",
      trigger_style=["background:rebeccapurple"],
    )
  })
  assert_contains(html, "data-slot=\"tabs\"")
  assert_contains(html, "data-orientation=\"vertical\"")
  assert_contains(html, "flex-direction:row;flex-wrap:wrap")
  assert_contains(html, "min-width:min(9rem,100%);flex:0 1 9rem")
  assert_contains(html, "role=\"tablist\"")
  assert_contains(html, "aria-label=\"Settings\"")
  assert_contains(html, "aria-orientation=\"vertical\"")
  assert_contains(html, "id=\"settings-trigger-0\"")
  assert_contains(html, "id=\"settings-content-0\"")
  assert_contains(html, "aria-controls=\"settings-content-0\"")
  assert_contains(html, "aria-labelledby=\"settings-trigger-0\"")
  assert_contains(html, "role=\"tab\"")
  assert_contains(html, "role=\"tabpanel\"")
  assert_contains(
    html, "data-value=\"account\" role=\"tab\" aria-selected=\"false\"",
  )
  assert_contains(
    html, "data-value=\"password\" role=\"tab\" aria-selected=\"true\"",
  )
  assert_contains(html, "tabindex=\"-1\"")
  assert_contains(html, "tabindex=\"0\"")
  assert_contains(html, "background:rebeccapurple")
  assert_contains(
    html, "background:var(--rui-tabs-bg,var(--rui-tabs-base-bg,transparent))",
  )
  assert_contains(
    html, "border-color:var(--rui-control-border,var(--rui-tabs-border,var(--rui-tabs-base-border,transparent)))",
  )
  assert_contains(
    html, "box-shadow:var(--rui-control-shadow,var(--rui-tabs-shadow,var(--rui-tabs-base-shadow,none)))",
  )
  assert_element_tag_contains(
    html, "data-value=\"password\" role=\"tab\"", "--rui-tabs-base-bg:var(--rui-tabs-active-bg,var(--rui-background",
  )
  assert_element_tag_contains(
    html, "data-value=\"account\" role=\"tab\"", "--rui-tabs-base-fg:var(--rui-muted-foreground",
  )
}

///|
test "tabs normalize an unavailable default and clone caller attrs" {
  let attrs = @html.Attrs::build().data_set("owner", "caller")
  let items = [
    @rabbita-ui.tab_entry(
      value="disabled",
      label="Disabled",
      content=@html.p("Unavailable"),
      disabled=true,
    ),
    @rabbita-ui.tab_entry(
      value="ready",
      label="Ready",
      content=@html.p("Available"),
    ),
  ]
  let html = render_incremental(() => {
    @rabbita-ui.tabs(items~, default_value="disabled", attrs~)
  })
  assert_contains(html, "data-value=\"ready\"")
  assert_contains(
    html, "data-value=\"ready\" role=\"tab\" aria-selected=\"true\"",
  )
  assert_contains(
    html, "data-value=\"disabled\" role=\"tab\" aria-selected=\"false\"",
  )
  assert_contains(html, "data-disabled=\"\"")
  assert_contains(html, "aria-disabled=\"true\" tabindex=\"-1\"")
  assert_element_tag_contains(
    html, "data-value=\"disabled\" role=\"tab\"", " disabled>",
  )

  let original = render(@html.div(attrs~, @html.nothing))
  assert_contains(original, "data-owner=\"caller\"")
  assert_not_contains(original, "data-slot")
  assert_not_contains(original, "data-orientation")
}

///|
test "tabs keep a usable tab stop when the default value is unavailable" {
  let items = [
    @rabbita-ui.tab_entry(
      value="disabled",
      label="Disabled",
      content=@html.p("Unavailable"),
      disabled=true,
    ),
    @rabbita-ui.tab_entry(
      value="ready",
      label="Ready",
      content=@html.p("Available"),
    ),
  ]
  let html = render_incremental(() => {
    @rabbita-ui.tabs(
      items~,
      default_value="disabled",
      force_mount=true,
      id="invalid-tabs",
    )
  })
  assert_element_tag_contains(
    html, "data-value=\"disabled\" role=\"tab\"", "aria-selected=\"false\"",
  )
  assert_element_tag_contains(
    html, "data-value=\"disabled\" role=\"tab\"", "tabindex=\"-1\"",
  )
  assert_element_tag_contains(
    html, "data-value=\"ready\" role=\"tab\"", "tabindex=\"0\"",
  )
  assert_element_tag_contains(html, "id=\"invalid-tabs-content-1\"", "hidden")
  assert_contains(html, "data-force-mount=\"true\"")
  assert_contains(html, "aria-hidden=\"true\"")
}
