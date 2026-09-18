///|
using @rabbita {type Html, type Val}

///|
using @html {fragment}

///|
fn app() -> Val[Html] {
  dropdown_menu_fixture().map2(menubar_fixture(), fn(dropdown_menu, menubar) {
    fragment([dropdown_menu, menubar])
  })
}

///|
fn main {
  @fixture.mount("menu", app)
}
