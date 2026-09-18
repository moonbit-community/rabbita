///|
using @rabbita {type Html, type Val}

///|
using @html {fragment}

///|
fn app() -> Val[Html] {
  select_fixture().map2(combobox_fixture(), fn(select, combobox) {
    fragment([select, combobox])
  })
}

///|
fn main {
  @fixture.mount("select-combobox", app)
}
