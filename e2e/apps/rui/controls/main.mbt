///|
using @rabbita {type Html, type Val}

///|
using @html {fragment, label, span}

///|
fn app() -> Val[Html] {
  checkbox_fixture().map3(switch_fixture(), toggle_fixture(), fn(
    checkbox,
    switch,
    toggle,
  ) {
    fragment([checkbox, switch, toggle])
  })
}

///|
fn main {
  @fixture.mount("controls", app)
}
