///|
using @rabbita {type Html, type Val}

///|
using @html {div, fragment, p, strong}

///|
fn app() -> Val[Html] {
  let tooltip = tooltip_fixture()
  let options = tooltip_options_fixture()
  let placements = tooltip_placement_fixture()
  hover_card_fixture().map2(tooltip_lifecycle_fixture(), (hover_card, lifecycle) => {
    fragment([tooltip, hover_card, lifecycle, options, placements])
  })
}

///|
fn main {
  @fixture.mount("tooltip", app)
}
