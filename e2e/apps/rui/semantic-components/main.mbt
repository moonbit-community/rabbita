///|
using @rabbita {type Html, type Val}

///|
using @html {div, fragment, span}

///|
fn semantic_components_fixture() -> Val[Html] {
  semantic_actions_fixture().map2(semantic_avatar_fixture(), fn(
    actions,
    media,
  ) {
    fragment([
      actions,
      media,
      semantic_navigation_fixture(),
      semantic_compositions_fixture(),
      semantic_data_fixture(),
      semantic_status_fixture(),
    ])
  })
}

///|
fn main {
  @fixture.mount("semantic-components", semantic_components_fixture)
}
