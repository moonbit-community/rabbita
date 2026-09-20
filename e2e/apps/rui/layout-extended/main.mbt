///|
using @rabbita {type Html, type Val}

///|
using @html {div, fragment}

///|
let fixture_section_border = "1px solid var(--rui-border,oklch(0.922 0 0))"

///|
let fixture_resizable_panel_style : String = "display:flex;align-items:center;justify-content:center;background:var(--rui-muted,oklch(0.97 0 0));border-radius:0.5rem"

///|
fn app() -> Val[Html] {
  resizable_group_fixture().map2(scroll_area_fixture(), fn(
    resizable_group,
    scroll_area,
  ) {
    fragment([resizable_group, scroll_area])
  })
}

///|
fn main {
  @fixture.mount("layout-extended", app)
}
