///|
fn input_otp_fixture() -> Val[Html] {
  let (value, set_value) = @rabbita.create_variable("")
  let (completed, set_completed) = @rabbita.create_variable("")
  let otp = @rui.input_otp(
    id="fixture-input-otp",
    max_length=6,
    separator_after=3,
    pattern="[0-9]*",
    aria_label="Fixture verification code",
    on_value_change=set_value.map(value => _ => value),
    on_complete=set_completed.map(value => _ => value),
  )
  let disabled = @rui.input_otp(
    id="fixture-input-otp-disabled",
    max_length=6,
    default_value="482931",
    disabled=true,
    aria_label="Previously verified fixture code",
  )
  otp.map4(value, completed, disabled, fn(otp, value, completed, disabled) {
    @fixture.section("fixture-section-input-otp", "Input OTP", [
      div(style=["display:grid;gap:0.5rem"], [
        otp,
        @html.output(id="fixture-otp-value", "value:\{value}"),
        @html.output(id="fixture-otp-complete", "complete:\{completed}"),
      ]),
      disabled,
    ])
  })
}
