///|
using @rabbita {type Html, type Val}

///|
using @html {div, fragment}

///|
let fixture_section_border = "1px solid var(--rui-border,oklch(0.922 0 0))"

///|
fn main {
  @fixture.mount("message-scroller", message_scroller_fixture)
}
