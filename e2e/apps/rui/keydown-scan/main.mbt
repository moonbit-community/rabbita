///|
using @rabbita {type Html, type Val}

///|
using @html {fragment}

///|
fn keydown_scan_fixture() -> Val[Html] {
  @rui.context_menu(id="fixture-keydown-scan", scope => {
    let items : Array[Html] = []
    for index in 0..<200 {
      items.push(@rui.context_menu_item(scope, "Scan item \{index}"))
    }
    fragment([
      @rui.context_menu_trigger(
        scope,
        tabindex=0,
        style=[
          "display:block;padding:0.75rem;border:1px dashed var(--rui-border);border-radius:0.625rem",
        ],
        @rui.textarea(
          id="fixture-scan-textarea",
          rows=3,
          placeholder="Type here without menu work",
          style=["width:100%"],
        ),
      ),
      @rui.context_menu_content(scope, aria_label="Scan menu", items),
    ])
  })
}

///|
fn main {
  @fixture.mount("keydown-scan", keydown_scan_fixture)
}
