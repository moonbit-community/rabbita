///|
using @rabbita {type Html, type Val}

///|
using @html {fragment}

///|
fn app() -> Val[Html] {
  dropdown_menu_fixture().map3(
    menubar_fixture(),
    focus_after_dismiss_fixture(),
    fn(dropdown_menu, menubar, focus_after_dismiss) {
      fragment([dropdown_menu, menubar, focus_after_dismiss])
    },
  )
}

///|
fn main {
  @fixture.mount("menu", app)
}
