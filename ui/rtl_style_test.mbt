///|
test "form controls use logical inline spacing and indicators" {
  let native_html = render(
    @rabbita-ui.direction(
      direction=@rabbita-ui.Rtl,
      @rabbita-ui.native_select(
        @rabbita-ui.native_select_option(value="one", "One"),
      ),
    ),
  )
  assert_contains(native_html, "padding-inline:0.625rem 2.25rem")
  assert_contains(native_html, "inset-inline-end:0.875rem")
  assert_not_contains(native_html, "padding-right:2.25rem")
  assert_not_contains(native_html, "right:0.875rem")

  let group_html = render(
    @rabbita-ui.input_group([
      @rabbita-ui.input_group_addon(align=@rabbita-ui.InputInlineStart, "Start"),
      @rabbita-ui.input_group_input(),
      @rabbita-ui.input_group_addon(align=@rabbita-ui.InputInlineEnd, "End"),
    ]),
  )
  assert_contains(group_html, "padding-inline-start:0.75rem")
  assert_contains(group_html, "padding-inline-end:0.75rem")
  assert_not_contains(group_html, "padding-left:0.75rem")
  assert_not_contains(group_html, "padding-right:0.75rem")
}

///|
test "select and combobox mirror item affordances in rtl" {
  let select_html = render_incremental(() => {
    @rabbita-ui.select(
      id="rtl-select",
      options=[@rabbita-ui.select_option(value="one", label="One")],
      default_value="one",
      default_open=true,
    )
  })
  assert_contains(select_html, "text-align:start")
  assert_contains(select_html, "padding-inline:0.5rem 2rem")
  assert_contains(select_html, "inset-inline-end:0.5rem")
  assert_not_contains(select_html, "text-align:left")
  assert_not_contains(select_html, "right:0.5rem")

  let combobox_html = render_incremental(() => {
    @rabbita-ui.combobox(
      id="rtl-combobox",
      options=[@rabbita-ui.combobox_option(value="one", label="One")],
      multiple=true,
      default_values=["one"],
      default_open=true,
    )
  })
  assert_contains(combobox_html, "text-align:start")
  assert_contains(combobox_html, "padding-inline:0.5rem 2rem")
  assert_contains(combobox_html, "inset-inline-end:0.5rem")
  assert_contains(combobox_html, "margin-inline-start:-0.25rem")
  assert_contains(combobox_html, "padding-inline-end:0.25rem")
  assert_not_contains(combobox_html, "text-align:left")
  assert_not_contains(combobox_html, "right:0.5rem")
  assert_not_contains(combobox_html, "margin-left:-0.25rem")
}

///|
test "otp connected toggles and alert actions carry rtl-safe recipes" {
  let otp_html = render_incremental(() => {
    @rabbita-ui.input_otp(id="rtl-otp", max_length=2, default_value="1")
  })
  assert_contains(otp_html, "border-block:1px solid var(--rui-otp-border")
  assert_contains(otp_html, "border-inline-end:1px solid var(--rui-otp-border")
  assert_not_contains(otp_html, "border-right:1px")

  let alert_html = render(
    @rabbita-ui.alert([
      @rabbita-ui.alert_title("Notice"),
      @rabbita-ui.alert_action("Action"),
    ]),
  )
  assert_contains(alert_html, "margin-inline-start:1rem")
  assert_contains(
    alert_html, "translate(var(--rui-alert-action-offset-inline,0.25rem),-0.125rem)",
  )
  assert_not_contains(alert_html, "margin-left:1rem")

  let theme_html = render(@rabbita-ui.theme(@html.nothing))
  assert_contains(
    theme_html, "border-inline-start:1px solid var(--rui-otp-border",
  )
  assert_contains(theme_html, "border-start-start-radius")
  assert_contains(theme_html, "border-end-end-radius")
  assert_contains(
    theme_html, "[data-slot=\"toggle-group\"][data-spacing=\"0\"][data-orientation=\"horizontal\"]:dir(rtl) > [data-slot=\"toggle-group-item\"]:last-child",
  )
  assert_contains(
    theme_html, "[data-slot=\"toggle-group\"][data-spacing=\"0\"][data-orientation=\"horizontal\"]:dir(rtl) > [data-slot=\"toggle-group-item\"]:first-child",
  )
  assert_contains(
    theme_html, "[data-slot=\"alert\"]:dir(rtl) > [data-slot=\"alert-action\"]",
  )
  assert_contains(theme_html, "--rui-alert-action-offset-inline:-0.25rem")
}

///|
test "switch checked endpoint mirrors without runtime positioning" {
  let html = render_incremental(() => {
    @rabbita-ui.switch(default_checked=true, aria_label="Mirrored switch")
  })
  assert_contains(html, "data-rui-style=\"switch-rtl\"")
  assert_contains(
    html, "[data-slot=\"switch-thumb\"][data-state=\"checked\"]:dir(rtl)",
  )
  assert_contains(html, "translateX(calc(-100% + 2px))")
}
