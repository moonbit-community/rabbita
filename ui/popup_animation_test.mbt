///|
test "floating surfaces retain native top-layer entry and exit transitions" {
  let common = "display 100ms allow-discrete,overlay 100ms allow-discrete;transition-behavior:allow-discrete"
  let primitives = render(
    @html.div([
      @rabbita-ui.popover_content(
        id="animation-popover",
        trigger_id="animation-popover-trigger",
        open=true,
        "Popover",
      ),
      @rabbita-ui.tooltip_content(
        id="animation-tooltip",
        trigger_id="animation-tooltip-trigger",
        open=true,
        "Tooltip",
      ),
      @rabbita-ui.hover_card_content(
        id="animation-hover-card",
        trigger_id="animation-hover-card-trigger",
        open=true,
        "Hover card",
      ),
    ]),
  )
  assert_contains(primitives, "data-slot=\"popover-content\"")
  assert_contains(primitives, "data-slot=\"tooltip-content\"")
  assert_contains(primitives, "data-slot=\"hover-card-content\"")
  assert_contains(primitives, common)
  assert_contains(
    primitives, "visibility:visible;opacity:1;pointer-events:auto;transform:scale(1)",
  )

  let select_html = render_incremental(() => {
    @rabbita-ui.select(
      id="animation-select",
      options=[@rabbita-ui.select_option(value="one", label="One")],
      default_open=true,
    )
  })
  assert_contains(select_html, "data-slot=\"select-content\"")
  assert_contains(select_html, common)

  let combobox_html = render_incremental(() => {
    @rabbita-ui.combobox(
      id="animation-combobox",
      options=[@rabbita-ui.combobox_option(value="one", label="One")],
      default_open=true,
    )
  })
  assert_contains(combobox_html, "data-slot=\"combobox-content\"")
  assert_contains(combobox_html, common)
}

///|
test "menu and navigation popup families share the discrete transition recipe" {
  let common = "display 100ms allow-discrete,overlay 100ms allow-discrete;transition-behavior:allow-discrete"
  let menu_html = render_incremental(() => {
    @rabbita-ui.dropdown_menu(id="animation-menu", default_open=true, scope => {
      @html.div([
        @rabbita-ui.dropdown_menu_trigger(scope, "Menu"),
        @rabbita-ui.dropdown_menu_content(scope, [
          @rabbita-ui.dropdown_menu_item(scope, "Item"),
          @rabbita-ui.dropdown_menu_sub(scope, value="more", sub => {
            @html.div([
              @rabbita-ui.dropdown_menu_sub_trigger(sub, "More"),
              @rabbita-ui.dropdown_menu_sub_content(
                sub,
                @rabbita-ui.dropdown_menu_item(scope, "Nested"),
              ),
            ])
          }),
        ]),
      ])
    })
  })
  assert_contains(menu_html, "data-slot=\"dropdown-menu-content\"")
  assert_contains(menu_html, "data-slot=\"dropdown-menu-sub-content\"")
  assert_contains(menu_html, common)

  let navigation_html = render_incremental(() => {
    @rabbita-ui.navigation_menu(
      id="animation-navigation",
      default_value="docs",
      viewport=false,
      scope => {
        @rabbita-ui.navigation_menu_list(
          scope,
          @rabbita-ui.navigation_menu_item(scope, value="docs", item => {
            @html.fragment([
              @rabbita-ui.navigation_menu_trigger(item, "Docs"),
              @rabbita-ui.navigation_menu_content(item, "Navigation content"),
            ])
          }),
        )
      },
    )
  })
  assert_contains(navigation_html, "data-slot=\"navigation-menu-content\"")
  assert_contains(
    navigation_html, "display 150ms allow-discrete,overlay 150ms allow-discrete;transition-behavior:allow-discrete",
  )
}

///|
test "theme provides closed first frames and reduced-motion fallback" {
  let html = render(@rabbita-ui.theme(@html.nothing))
  assert_contains(html, "@starting-style")
  assert_contains(
    html, "[data-slot=\"popover-content\"],[data-slot=\"tooltip-content\"],[data-slot=\"hover-card-content\"]",
  )
  assert_contains(
    html, "[data-submenu-owner])[data-state=\"open\"]:popover-open",
  )
  assert_contains(
    html, "dialog[data-slot=\"popover-content\"][data-state=\"open\"][open]",
  )
  assert_contains(html, "transform:scale(0.95) !important")
  assert_contains(html, "@media (prefers-reduced-motion:reduce)")
  assert_contains(html, "transition-duration:0s !important")
}
