///|
using @rabbita {type Html, type Val}

///|
using @html {div, fragment}

///|
fn app() -> Val[Html] {
  carousel_fixture().map2(carousel_non_loop_fixture(), fn(
    carousel,
    carousel_non_loop,
  ) {
    fragment([carousel, carousel_non_loop])
  })
}

///|
fn main {
  @fixture.mount("carousel", app)
}
