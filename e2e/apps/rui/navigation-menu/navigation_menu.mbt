///|
fn navigation_menu_fixture() -> Val[Html] {
  let nav = @rui.navigation_menu(
    id="fixture-navigation-menu",
    aria_label="Fixture navigation",
    scope => {
      div(style=["min-height:8rem"], [
        @rui.navigation_menu_list(scope, [
          @rui.navigation_menu_item(scope, value="platform", item => {
            fragment([
              @rui.navigation_menu_trigger(item, "Platform"),
              @rui.navigation_menu_indicator(item),
              @rui.navigation_menu_content(item, [
                @rui.navigation_menu_link(
                  href="#fixture-section-navigation-menu",
                  active=true,
                  [
                    strong("Components"),
                    span(style=["display:block"], "Black-box defaults"),
                  ],
                ),
                @rui.navigation_menu_link(
                  href="#fixture-section-navigation-menu",
                  [
                    strong("Patterns"),
                    span(style=["display:block"], "Compound composition"),
                  ],
                ),
              ]),
            ])
          }),
          @rui.navigation_menu_item(scope, value="resources", item => {
            fragment([
              @rui.navigation_menu_trigger(item, "Resources"),
              @rui.navigation_menu_indicator(item),
              @rui.navigation_menu_content(item, [
                @rui.navigation_menu_link(
                  href="#fixture-section-navigation-menu",
                  [
                    strong("API reference"),
                    span(style=["display:block"], "Typed MoonBit surface"),
                  ],
                ),
                @rui.navigation_menu_link(
                  href="#fixture-section-navigation-menu",
                  [
                    strong("Examples"),
                    span(style=["display:block"], "Working interactions"),
                  ],
                ),
              ]),
            ])
          }),
        ]),
        @rui.navigation_menu_viewport(scope, nothing),
      ])
    },
  )
  nav.map(nav_html => {
    @fixture.section("fixture-section-navigation-menu", "Navigation menu", [
      nav_html,
    ])
  })
}
