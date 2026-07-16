///|
test "radio group uses native radio semantics" {
  let html = render_incremental(() => {
    @rabbita-ui.radio_group(
      default_value="pro",
      name="plan",
      aria_label="Plan",
      scope => {
        @rabbita-ui.radio_group_item(scope~, value="pro", aria_label="Pro")
      },
    )
  })
  assert_contains(html, "role=\"radiogroup\"")
  assert_contains(html, "type=\"radio\"")
  assert_contains(html, "name=\"plan\"")
  assert_contains(html, "data-slot=\"radio-group-item\"")
  assert_contains(html, "data-checked=\"\"")
  assert_contains(
    html, "--rui-control-base-bg:radial-gradient(circle at center",
  )
  assert_contains(
    html, "radial-gradient(circle at center,var(--rui-primary,oklch(0.205 0 0))",
  )
  assert_contains(
    html, "--rui-control-base-border:var(--rui-input,oklch(0.922 0 0))",
  )
  assert_contains(
    html, "background:var(--rui-control-bg,var(--rui-control-base-bg,var(--rui-input-background,transparent)))",
  )
}

///|
test "native select exposes wrapper options and controlled value" {
  let html = render(
    @rabbita-ui.native_select(value="team", aria_label="Scope", [
      @rabbita-ui.native_select_option(value="personal", "Personal"),
      @rabbita-ui.native_select_option(value="team", selected=true, "Team"),
    ]),
  )
  assert_contains(html, "data-slot=\"native-select-wrapper\"")
  assert_contains(html, "data-slot=\"native-select\"")
  assert_contains(html, "data-slot=\"native-select-icon\"")
  assert_contains(html, "<svg")
  assert_contains(html, "width=\"16\"")
  assert_contains(html, "height=\"16\"")
  assert_not_contains(html, "border-right:1.5px")
  assert_contains(html, "value=\"team\"")
  assert_contains(html, "selected")
  assert_contains(
    html, "border-color:var(--rui-control-border,var(--rui-control-base-border,var(--rui-input,oklch(0.922 0 0))))",
  )
}

///|
test "button group supplies one shared control surface" {
  let html = render(
    @rabbita-ui.button_group(aria_label="History", [
      @rabbita-ui.button(variant=@rabbita-ui.Outline, "Back"),
      @rabbita-ui.button_group_text("2 / 5"),
      @rabbita-ui.button(variant=@rabbita-ui.Outline, "Next"),
    ]),
  )
  assert_contains(html, "role=\"group\"")
  assert_contains(html, "data-slot=\"button-group\"")
  assert_contains(html, "data-orientation=\"horizontal\"")
  assert_contains(html, "overflow:visible")
  assert_contains(html, "align-items:stretch;gap:0")
  assert_contains(html, "data-slot=\"button\"")
  assert_contains(html, "data-slot=\"button-group-text\"")
  assert_contains(html, "border-style:solid")
  assert_contains(html, "padding-inline:0.625rem")
  assert_not_contains(html, "min-height:2.25rem")
  assert_contains(html, "border-color:var(--rui-border,oklch(0.922 0 0))")
  assert_contains(
    html, "border-top-width:var(--rui-control-border-top-width,var(--rui-control-border-width,1px))",
  )
}

///|
test "form field adapts explicit Rabbita-owned semantics without hidden context" {
  let html = render(
    @rabbita-ui.form_field(
      name="email",
      invalid=true,
      required=true,
      describedby="email-description",
      errormessage="email-message",
      style=["max-width:24rem"],
      [
        @rabbita-ui.form_label(for_="email", "Email"),
        @rabbita-ui.form_control(@rabbita-ui.input(id="email")),
        @rabbita-ui.form_description(
          id="email-description",
          "Used for notifications.",
        ),
        @rabbita-ui.form_message(id="email-message", "Enter a valid address."),
      ],
    ),
  )
  assert_contains(html, "data-slot=\"form-field\"")
  assert_contains(html, "data-name=\"email\"")
  assert_contains(html, "data-invalid=\"true\"")
  assert_contains(html, "data-required=\"true\"")
  assert_contains(html, "aria-invalid=\"true\"")
  assert_contains(html, "aria-required=\"true\"")
  assert_contains(html, "aria-describedby=\"email-description\"")
  assert_contains(html, "aria-errormessage=\"email-message\"")
  assert_contains(html, "max-width:24rem")
}

///|
test "field label exposes the choice-card state bridge" {
  let html = render_incremental(() => {
    let checkbox_view = @rabbita-ui.checkbox(
      default_checked=true,
      aria_label="Use priority support",
    )
    checkbox_view.view(checkbox_html => {
      @rabbita-ui.field_label(
        style=["background:rebeccapurple"],
        @rabbita-ui.field([
          checkbox_html,
          @rabbita-ui.field_content([
            @rabbita-ui.field_title("Priority support"),
            @rabbita-ui.field_description("Replies within one business day."),
          ]),
        ]),
      )
    })
  })
  assert_contains(html, "data-slot=\"field-label\"")
  assert_contains(html, "--rui-field-label-base-bg:transparent")
  assert_contains(
    html, "border-color:var(--rui-field-label-border,var(--rui-field-label-base-border,transparent))",
  )
  assert_contains(
    html, "background:var(--rui-field-label-bg,var(--rui-field-label-base-bg,transparent))",
  )
  assert_contains(
    html, "box-shadow:var(--rui-field-label-shadow,var(--rui-field-label-base-shadow,none))",
  )
  assert_contains(html, "font-weight:500;background:rebeccapurple")
  assert_contains(html, "data-slot=\"checkbox\"")
  assert_contains(html, "data-state=\"checked\"")
}

///|
test "field responsive layout uses its own container and shared label slot" {
  let html = render(
    @rabbita-ui.theme(
      @rabbita-ui.field_group(
        @rabbita-ui.field(orientation=@rabbita-ui.FieldResponsive, [
          @rabbita-ui.field_title("Workspace"),
          @rabbita-ui.field_content(@rabbita-ui.input()),
        ]),
      ),
    ),
  )
  assert_contains(html, "container-name:rui-field-group")
  assert_contains(html, "data-orientation=\"responsive\"")
  assert_contains(html, "data-slot=\"field-label\"")
  assert_contains(html, "@container rui-field-group (min-width:28rem)")
  assert_not_contains(html, "data-slot=\"field-title\"")
}

///|
test "input otp marks one insertion slot and delegates focus styling to css" {
  let otp_html = render_incremental(() => {
    @rabbita-ui.input_otp(
      id="verification",
      max_length=6,
      default_value="123",
      separator_after=3,
      invalid=true,
    )
  })
  assert_contains(otp_html, "data-current=\"true\"")
  assert_contains(otp_html, "data-index=\"3\"")
  assert_contains(otp_html, "data-slot=\"input-otp-caret\"")
  assert_contains(otp_html, "data-slot=\"input-otp-separator\"")
  assert_contains(otp_html, "aria-invalid=\"true\"")

  let theme_html = render(@rabbita-ui.theme(@html.nothing))
  assert_contains(
    theme_html, "[data-slot=\"input-otp\"]:focus-within [data-slot=\"input-otp-slot\"][data-current=\"true\"]",
  )
  assert_contains(
    theme_html, "[data-slot=\"input-otp\"]:focus-within [data-slot=\"input-otp-caret\"]",
  )
}
