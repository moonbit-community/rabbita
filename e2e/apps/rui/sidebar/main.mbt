///|
using @rabbita {type Html, type Val}

///|
using @html {div, fragment, p, strong}

///|
fn app() -> Val[Html] {
  sidebar_fixture().map2(sidebar_mobile_fixture(), fn(sidebar, sidebar_mobile) {
    fragment([sidebar, sidebar_mobile])
  })
}

///|
fn main {
  @fixture.mount("sidebar", app)
}
