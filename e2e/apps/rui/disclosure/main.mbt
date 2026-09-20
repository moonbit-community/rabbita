///|
using @rabbita {type Html, type Val}

///|
using @html {div, fragment, p}

///|
fn app() -> Val[Html] {
  accordion_fixture().map3(collapsible_fixture(), tabs_fixture(), fn(
    accordion,
    collapsible,
    tabs,
  ) {
    fragment([accordion, collapsible, tabs])
  })
}

///|
fn main {
  @fixture.mount("disclosure", app)
}
