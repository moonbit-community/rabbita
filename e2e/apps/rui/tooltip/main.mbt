///|
using @rabbita {type Html, type Val}

///|
using @html {div, fragment, p, strong}

///|
fn app() -> Val[Html] {
  tooltip_fixture().map2(hover_card_fixture(), fn(tooltip, hover_card) {
    fragment([tooltip, hover_card])
  })
}

///|
fn main {
  @fixture.mount("tooltip", app)
}
