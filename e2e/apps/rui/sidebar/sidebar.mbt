///|
let fixture_section_border = "1px solid var(--rui-border,oklch(0.922 0 0))"

///|
fn sidebar_fixture() -> Val[Html] {
  let overview_button = @rui.sidebar_menu_button_with_tooltip(
    id="fixture-sidebar-overview",
    tooltip="Overview",
    href="#fixture-section-sidebar",
    is_active=true,
    size=SidebarMenuDefault,
    [@html.span("Overview")],
  )
  let settings_button = @rui.sidebar_menu_button_with_tooltip(
    id="fixture-sidebar-settings",
    tooltip="Settings",
    href="#fixture-section-sidebar",
    size=SidebarMenuDefault,
    [@html.span("Settings")],
  )
  let menu = overview_button.map2(settings_button, fn(overview, settings) {
    @rui.sidebar_menu([
      @rui.sidebar_menu_item([overview]),
      @rui.sidebar_menu_item([settings]),
    ])
  })
  let provider = @rui.sidebar_provider_with_input(
    input=menu,
    default_collapsed=false,
    style=[
      "--rui-sidebar-width:20rem;height:17rem;min-height:17rem;overflow:hidden;display:flex;border:1px solid \{fixture_section_border};border-radius:0.625rem",
    ],
    (scope, menu_html) => {
      fragment([
        @rui.sidebar(
          scope,
          id="fixture-sidebar-root",
          collapsible=SidebarIcon,
          mobile=false,
          [
            @rui.sidebar_header(
              @rui.sidebar_input(
                aria_label="Filter fixture navigation",
                placeholder="Filter…",
              ),
            ),
            @rui.sidebar_content(
              @rui.sidebar_group([
                @rui.sidebar_group_label(scope~, "Workspace"),
                @rui.sidebar_group_action(
                  aria_label="Collapse sidebar",
                  on_click=@rui.sidebar_collapse(scope),
                  @html.span("«"),
                ),
                @rui.sidebar_group_content(menu_html),
              ]),
            ),
            @rui.sidebar_rail(
              scope,
              min_width=192,
              max_width=352,
              aria_label="Resize sidebar",
            ),
          ],
        ),
        div(
          style=[
            "display:flex;flex:1;flex-direction:column;gap:0.5rem;padding:0.75rem",
          ],
          [
            div(style=["display:flex;align-items:center;gap:0.5rem"], [
              @rui.sidebar_trigger(
                scope,
                mobile=false,
                controls="fixture-sidebar-root",
                aria_label="Toggle sidebar",
                @html.span("☰"),
              ),
              strong("Workspace overview"),
            ]),
            p(style=["margin:0"], "Use the trigger to collapse the sidebar."),
          ],
        ),
      ])
    },
  )
  provider.map(provider_html => {
    @fixture.section("fixture-section-sidebar", "Sidebar", [provider_html])
  })
}

///|
fn sidebar_mobile_fixture() -> Val[Html] {
  let (state, set_state) = @rabbita.create_variable("closed")
  let provider = @rui.sidebar_provider(
    default_mobile_open=false,
    on_mobile_open_change=set_state.map(open => {
      _ => if open { "open" } else { "closed" }
    }),
    style=["height:8rem;min-height:8rem"],
    scope => {
      fragment([
        @rui.sidebar(
          scope,
          id="fixture-sidebar-mobile",
          collapsible=SidebarOffcanvas,
          mobile=true,
          aria_label="Fixture mobile navigation",
          [
            @rui.sidebar_header([
              strong("Mobile workspace"),
              @rui.button(
                on_click=@rui.sidebar_close_mobile(scope),
                "Close mobile navigation",
              ),
            ]),
            @rui.sidebar_content(
              @rui.sidebar_group(
                @rui.sidebar_group_content(
                  @rui.sidebar_menu([
                    @rui.sidebar_menu_item(
                      @rui.sidebar_menu_button(
                        href="#fixture-section-sidebar-mobile",
                        "Mobile overview",
                      ),
                    ),
                    @rui.sidebar_menu_item(
                      @rui.sidebar_menu_button(
                        href="#fixture-section-sidebar-mobile",
                        "Mobile settings",
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
        @rui.sidebar_trigger(
          scope,
          mobile=true,
          controls="fixture-sidebar-mobile",
          aria_label="Open mobile sidebar",
          "☰",
        ),
      ])
    },
  )
  provider.map2(state, fn(provider, state) {
    @fixture.section("fixture-section-sidebar-mobile", "Sidebar Mobile", [
      provider,
      @html.output(id="fixture-sidebar-mobile-output", state),
    ])
  })
}
