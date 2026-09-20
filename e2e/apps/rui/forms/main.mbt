///|
using @rabbita {type Html, type Val}

///|
using @html {div, fragment}

///|
fn forms_extended_fixture() -> Val[Html] {
  form_fixture().map3(native_select_fixture(), input_otp_fixture(), fn(
    form,
    native_select,
    otp,
  ) {
    fragment([form, native_select, otp])
  })
}

///|
fn main {
  @fixture.mount("forms", forms_extended_fixture)
}
