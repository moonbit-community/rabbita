///|
using @rabbita {type Html, type Val}

///|
using @html {div, fragment}

///|
fn app() -> Val[Html] {
  combobox_multiple_fixture().map2(slider_values_fixture(), fn(
    combobox_multiple,
    slider_values,
  ) {
    fragment([combobox_multiple, slider_values])
  })
}

///|
fn main {
  @fixture.mount("interaction-extended", app)
}
