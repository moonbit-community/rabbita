///|
fn assert_element_tag_contains(
  html : String,
  marker : String,
  expected : String,
) -> Unit raise {
  guard html.split_once(marker) is Some((before, after)) else {
    fail("expected rendered HTML to contain marker `\{marker}`")
  }
  guard before.to_owned().rev_split_once("<button") is Some((_, start)) else {
    fail("expected marker `\{marker}` to occur inside a button")
  }
  guard after.to_owned().split_once(">") is Some((end, _)) else {
    fail("expected marker `\{marker}` to occur in a complete start tag")
  }
  let tag = "<button" + start.to_owned() + marker + end.to_owned() + ">"
  assert_contains(tag, expected)
}

///|
test "dropdown menu composes official parts with owned selection state" {
  let attrs = @html.Attrs::build().data_set("owner", "caller")
  let html = render_incremental(() => {
    @rabbita-ui.dropdown_menu(
      id="account-menu",
      default_open=true,
      default_checked_values=["status"],
      default_radio_values=[("theme", "dark")],
      attrs~,
      style=["--menu-test:1"],
      scope => {
        @html.div([
          @rabbita-ui.dropdown_menu_trigger(scope, "Account"),
          @rabbita-ui.dropdown_menu_portal([
            @rabbita-ui.dropdown_menu_content(scope, style=["width:14rem"], [
              @rabbita-ui.dropdown_menu_label("Preferences"),
              @rabbita-ui.dropdown_menu_group(aria_label="Actions", [
                @rabbita-ui.dropdown_menu_item(scope, [
                  @html.span("Profile"),
                  @rabbita-ui.dropdown_menu_shortcut("\u2318P"),
                ]),
                @rabbita-ui.dropdown_menu_item(
                  scope,
                  destructive=true,
                  aria_label="Delete account",
                  "Delete",
                ),
              ]),
              @rabbita-ui.dropdown_menu_checkbox_item(
                scope,
                value="status",
                "Show status",
              ),
              @rabbita-ui.dropdown_menu_radio_group(scope, value="theme", radio => {
                @html.div([
                  @rabbita-ui.dropdown_menu_radio_item(
                    radio,
                    value="light",
                    "Light",
                  ),
                  @rabbita-ui.dropdown_menu_radio_item(
                    radio,
                    value="dark",
                    "Dark",
                  ),
                ])
              }),
              @rabbita-ui.dropdown_menu_separator(),
              @rabbita-ui.dropdown_menu_sub(scope, value="share", sub => {
                @html.div([
                  @rabbita-ui.dropdown_menu_sub_trigger(sub, "Share"),
                  @rabbita-ui.dropdown_menu_sub_content(
                    sub,
                    @rabbita-ui.dropdown_menu_item(scope, "Copy link"),
                  ),
                ])
              }),
            ]),
          ]),
        ])
      },
    )
  })
  assert_contains(html, "data-slot=\"dropdown-menu\"")
  assert_contains(html, "data-state=\"open\"")
  assert_contains(html, "data-slot=\"dropdown-menu-trigger\"")
  assert_contains(html, "aria-haspopup=\"menu\"")
  assert_contains(html, "aria-expanded=\"true\"")
  assert_contains(html, "popover=\"auto\"")
  assert_contains(html, "role=\"menu\"")
  assert_contains(html, "role=\"menuitem\"")
  assert_element_tag_contains(
    html, "data-slot=\"dropdown-menu-item\"", "data-variant=\"default\"",
  )
  assert_element_tag_contains(
    html, "data-slot=\"dropdown-menu-item\"", "background:var(--rui-menu-item-bg,var(--rui-menu-item-base-bg,transparent))",
  )
  assert_element_tag_contains(
    html, "aria-label=\"Delete account\"", "data-variant=\"destructive\"",
  )
  assert_element_tag_contains(
    html, "aria-label=\"Delete account\"", "--rui-menu-item-base-fg:var(--rui-destructive",
  )
  assert_contains(html, "role=\"menuitemcheckbox\"")
  assert_contains(html, "aria-checked=\"true\"")
  assert_element_tag_contains(
    html, "data-slot=\"dropdown-menu-checkbox-item\"", "padding-inline-start:0.5rem;padding-inline-end:2rem",
  )
  assert_contains(html, "data-slot=\"dropdown-menu-checkbox-item-indicator\"")
  assert_contains(
    html, "position:absolute;inset-inline-end:0.5rem;display:inline-flex;width:1rem;height:1rem",
  )
  assert_contains(html, "role=\"menuitemradio\"")
  assert_element_tag_contains(
    html, "data-slot=\"dropdown-menu-radio-item\"", "padding-inline-start:0.5rem;padding-inline-end:2rem",
  )
  assert_contains(html, "data-slot=\"dropdown-menu-radio-group\"")
  assert_contains(html, "data-slot=\"dropdown-menu-sub-trigger\"")
  assert_contains(html, "data-slot=\"dropdown-menu-sub-content\"")
  assert_contains(html, "popover=\"manual\"")
  assert_contains(html, "data-restore-focus=\"false\"")
  assert_element_tag_contains(
    html, "data-slot=\"dropdown-menu-sub-trigger\"", "data-state=\"closed\"",
  )
  assert_element_tag_contains(
    html, "data-slot=\"dropdown-menu-sub-trigger\"", "aria-controls=\"",
  )
  assert_contains(html, "aria-labelledby=\"")
  assert_contains(html, "aria-haspopup=\"menu\"")
  assert_contains(html, "data-slot=\"dropdown-menu-shortcut\"")
  assert_contains(html, "width:14rem")
  assert_contains(html, "--menu-test:1")
  assert_contains(html, "anchor-name:--rui-anchor_")
  assert_contains(html, "position-anchor:--rui-anchor_")
  assert_contains(html, "position-area:bottom span-x-end")
  assert_not_contains(html, "-10000px")
  assert_not_contains(html, "dropdown-menu-portal")

  let original = render(@html.div(attrs~, @html.nothing))
  assert_contains(original, "data-owner=\"caller\"")
  assert_not_contains(original, "data-slot")
}

///|
test "context menu exposes right-click target and complete menu semantics" {
  let html = render_incremental(() => {
    @rabbita-ui.context_menu(id="editor-menu", scope => {
      @html.div([
        @rabbita-ui.context_menu_trigger(
          scope,
          style=["min-height:10rem"],
          "Right click the editor",
        ),
        @rabbita-ui.context_menu_portal([
          @rabbita-ui.context_menu_content(scope, aria_label="Editor actions", [
            @rabbita-ui.context_menu_label("Edit"),
            @rabbita-ui.context_menu_group(
              @rabbita-ui.context_menu_item(scope, "Undo"),
            ),
            @rabbita-ui.context_menu_checkbox_item(
              scope,
              value="wrap",
              "Word wrap",
            ),
            @rabbita-ui.context_menu_radio_group(scope, value="indent", radio => {
              @rabbita-ui.context_menu_radio_item(
                radio,
                value="spaces",
                "Spaces",
              )
            }),
            @rabbita-ui.context_menu_separator(),
            @rabbita-ui.context_menu_sub(scope, value="more", sub => {
              @html.div([
                @rabbita-ui.context_menu_sub_trigger(sub, "More"),
                @rabbita-ui.context_menu_sub_content(
                  sub,
                  @rabbita-ui.context_menu_item(scope, [
                    @html.span("Inspect"),
                    @rabbita-ui.context_menu_shortcut("F12"),
                  ]),
                ),
              ])
            }),
          ]),
        ]),
      ])
    })
  })
  assert_contains(html, "data-slot=\"context-menu\"")
  assert_contains(html, "data-slot=\"context-menu-trigger\"")
  assert_contains(html, "data-slot=\"context-menu-anchor\"")
  assert_contains(
    html, "position:absolute;width:0;height:0;pointer-events:none",
  )
  assert_contains(html, "left:0px;top:0px")
  assert_contains(html, "anchor-name:--rui-anchor_")
  assert_contains(html, "tabindex=\"0\"")
  assert_contains(html, "aria-haspopup=\"menu\"")
  assert_contains(html, "data-slot=\"context-menu-content\"")
  assert_contains(html, "popover=\"manual\"")
  assert_not_contains(html, " hidden")
  assert_contains(html, "data-light-dismiss=\"true\"")
  assert_contains(
    html, "transition:opacity 100ms ease,transform 100ms ease,visibility 100ms ease",
  )
  assert_contains(
    html, "visibility:hidden;opacity:0;pointer-events:none;transform:scale(0.95)",
  )
  assert_contains(html, "role=\"menu\"")
  assert_contains(html, "aria-label=\"Editor actions\"")
  assert_contains(html, "role=\"menuitemcheckbox\"")
  assert_contains(html, "role=\"menuitemradio\"")
  assert_element_tag_contains(
    html, "data-slot=\"context-menu-checkbox-item\"", "padding-inline-start:0.5rem;padding-inline-end:2rem",
  )
  assert_contains(html, "data-slot=\"context-menu-checkbox-item-indicator\"")
  assert_contains(html, "inset-inline-end:0.5rem")
  assert_contains(html, "data-slot=\"context-menu-sub-content\"")
  assert_contains(html, "min-height:10rem")
  assert_contains(html, "position:fixed;inset:auto")
  assert_contains(html, "position-anchor:--rui-anchor_")
  assert_contains(html, "position-area:bottom span-x-end")
  assert_contains(html, "position-area:inline-end span-y-end")
  assert_contains(html, "position-try-fallbacks:flip-inline")
  assert_not_contains(html, "context-menu-portal")
}

///|
test "menubar owns one active menu and all official item variants" {
  let html = render_incremental(() => {
    @rabbita-ui.menubar(
      id="app-menubar",
      default_value="edit",
      default_checked_values=["sidebar"],
      default_radio_values=[("theme", "system")],
      scope => {
        @html.fragment([
          @rabbita-ui.menubar_menu(scope, value="file", menu => {
            @html.fragment([
              @rabbita-ui.menubar_trigger(menu, "File"),
              @rabbita-ui.menubar_portal([
                @rabbita-ui.menubar_content(menu, [
                  @rabbita-ui.menubar_label("Workspace"),
                  @rabbita-ui.menubar_group(
                    @rabbita-ui.menubar_item(menu, [
                      @html.span("New"),
                      @rabbita-ui.menubar_shortcut("\u2318N"),
                    ]),
                  ),
                  @rabbita-ui.menubar_checkbox_item(
                    menu,
                    value="sidebar",
                    "Sidebar",
                  ),
                  @rabbita-ui.menubar_radio_group(menu, value="theme", radio => {
                    @rabbita-ui.menubar_radio_item(
                      radio,
                      value="system",
                      "System",
                    )
                  }),
                  @rabbita-ui.menubar_separator(),
                  @rabbita-ui.menubar_sub(menu, value="recent", sub => {
                    @html.fragment([
                      @rabbita-ui.menubar_sub_trigger(sub, "Recent"),
                      @rabbita-ui.menubar_sub_content(
                        sub,
                        @rabbita-ui.menubar_item(menu, "Project A"),
                      ),
                    ])
                  }),
                ]),
              ]),
            ])
          }),
          @rabbita-ui.menubar_menu(scope, value="edit", menu => {
            @html.fragment([
              @rabbita-ui.menubar_trigger(menu, "Edit"),
              @rabbita-ui.menubar_content(
                menu,
                @rabbita-ui.menubar_item(menu, "Copy"),
              ),
            ])
          }),
        ])
      },
    )
  })
  assert_contains(html, "role=\"menubar\"")
  assert_contains(html, "aria-orientation=\"horizontal\"")
  assert_contains(html, "max-width:100%;min-width:0;flex-wrap:wrap")
  assert_contains(html, "data-slot=\"menubar-menu\"")
  assert_contains(html, "data-value=\"edit\"")
  assert_contains(html, "data-slot=\"menubar-trigger\"")
  assert_contains(html, "aria-expanded=\"true\"")
  assert_element_tag_contains(
    html, "data-menubar-value=\"file\"", "data-state=\"closed\"",
  )
  assert_element_tag_contains(
    html, "data-menubar-value=\"edit\"", "data-state=\"open\"",
  )
  assert_element_tag_contains(
    html, "data-menubar-value=\"edit\"", "--rui-menu-item-base-bg:var(--rui-accent",
  )
  assert_contains(html, "data-slot=\"menubar-content\"")
  assert_contains(html, "role=\"menuitemcheckbox\"")
  assert_contains(html, "role=\"menuitemradio\"")
  assert_contains(html, "data-slot=\"menubar-checkbox-item-indicator\"")
  assert_contains(
    html, "display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center",
  )
  assert_not_contains(html, "inset-inline-end:0.5rem")
  assert_contains(html, "data-slot=\"menubar-sub-content\"")
  assert_contains(html, "popover=\"manual\"")
  assert_not_contains(html, "menubar-portal")
}

///|
test "navigation menu maps list item trigger content viewport link indicator" {
  let html = render_incremental(() => {
    @rabbita-ui.navigation_menu(
      id="docs-navigation",
      default_value="products",
      style=["max-width:60rem"],
      scope => {
        @html.div([
          @rabbita-ui.navigation_menu_list(scope, [
            @rabbita-ui.navigation_menu_item(scope, value="overview", item => {
              @html.fragment([
                @rabbita-ui.navigation_menu_trigger(item, "Overview"),
                @rabbita-ui.navigation_menu_content(
                  item,
                  @rabbita-ui.navigation_menu_link(href="/overview", "Overview"),
                ),
              ])
            }),
            @rabbita-ui.navigation_menu_item(scope, value="products", item => {
              @html.fragment([
                @rabbita-ui.navigation_menu_trigger(item, "Products"),
                @rabbita-ui.navigation_menu_indicator(item),
                @rabbita-ui.navigation_menu_content(item, [
                  @rabbita-ui.navigation_menu_link(
                    href="/products/one",
                    active=true,
                    "Product one",
                  ),
                  @rabbita-ui.navigation_menu_link(
                    href="/products/two",
                    "Product two",
                  ),
                ]),
              ])
            }),
          ]),
          @rabbita-ui.navigation_menu_viewport(
            scope, "Viewport-compatible custom content",
          ),
        ])
      },
    )
  })
  assert_contains(html, "<nav")
  assert_contains(html, "data-slot=\"navigation-menu\"")
  assert_contains(html, "data-value=\"products\"")
  assert_contains(html, "aria-label=\"Main navigation\"")
  assert_contains(html, "data-slot=\"navigation-menu-list\"")
  assert_contains(html, "data-slot=\"navigation-menu-item\"")
  assert_contains(html, "data-slot=\"navigation-menu-trigger\"")
  assert_contains(html, "aria-expanded=\"true\"")
  assert_contains(html, "data-slot=\"navigation-menu-content\"")
  assert_contains(html, "role=\"region\"")
  assert_contains(html, "data-slot=\"navigation-menu-viewport\"")
  assert_not_contains(html, "popover=\"auto\"")
  assert_contains(html, "data-slot=\"navigation-menu-link\"")
  assert_contains(html, "href=\"/products/one\"")
  assert_contains(html, "aria-current=\"page\"")
  assert_contains(html, "data-slot=\"navigation-menu-indicator\"")
  assert_contains(
    html, "top:100%;inset-inline:0;z-index:1;display:flex;height:0.375rem",
  )
  assert_contains(
    html, "align-items:flex-end;justify-content:center;overflow:hidden",
  )
  assert_contains(
    html, "top:60%;width:0.5rem;height:0.5rem;flex:none;transform:rotate(45deg)",
  )
  assert_contains(
    html, "background:var(--rui-border,oklch(0.922 0 0));box-shadow:",
  )
  assert_not_contains(html, "bottom:-0.375rem;left:50%;z-index:51")
  assert_contains(html, "data-icon=\"chevron-down\"")
  assert_not_contains(html, "\u2304")
  assert_contains(html, "position-anchor:")
  assert_contains(html, "position:fixed;inset:auto")
  assert_contains(html, "top:calc(anchor(bottom) + 0.375rem)")
  assert_contains(
    html, "left:clamp(calc(var(--rui-navigation-viewport-half) + 0.5rem),anchor(center),calc(100vw - var(--rui-navigation-viewport-half) - 0.5rem))",
  )
  assert_contains(
    html, "--rui-navigation-viewport-half:min(16rem,calc(50vw - 0.5rem))",
  )
  assert_contains(html, "position-try-fallbacks:flip-block")
  assert_contains(html, "max-height:calc(100dvh - 1rem)")
  assert_contains(html, "max-width:100%")
  assert_contains(html, "max-width:60rem")
  assert_element_tag_contains(
    html, "data-navigation-value=\"overview\"", "tabindex=\"-1\"",
  )
  assert_element_tag_contains(
    html, "data-navigation-value=\"products\"", "tabindex=\"0\"",
  )
  assert_contains(
    html, "background:var(--rui-nav-bg,var(--rui-nav-base-bg,var(--rui-background",
  )
  assert_contains(
    html, "color:var(--rui-nav-fg,var(--rui-nav-base-fg,var(--rui-foreground",
  )
  assert_contains(
    html, "box-shadow:var(--rui-nav-shadow,var(--rui-nav-base-shadow,none))",
  )
  assert_element_tag_contains(
    html, "data-navigation-value=\"products\"", "--rui-nav-base-bg:color-mix(in oklab,var(--rui-accent",
  )
  assert_element_tag_contains(
    html, "href=\"/products/one\"", "--rui-nav-base-bg:color-mix(in oklab,var(--rui-accent",
  )
}

///|
test "navigation menu can opt out of the shared viewport" {
  let html = render_incremental(() => {
    @rabbita-ui.navigation_menu(
      id="compact-navigation",
      default_value="docs",
      viewport=false,
      scope => {
        @rabbita-ui.navigation_menu_list(
          scope,
          @rabbita-ui.navigation_menu_item(scope, value="docs", item => {
            @html.fragment([
              @rabbita-ui.navigation_menu_trigger(item, "Docs"),
              @rabbita-ui.navigation_menu_content(
                item,
                @rabbita-ui.navigation_menu_link(href="/docs", "Docs"),
              ),
            ])
          }),
        )
      },
    )
  })
  assert_contains(html, "data-slot=\"navigation-menu-content\"")
  assert_contains(html, "popover=\"auto\"")
  assert_not_contains(html, "data-slot=\"navigation-menu-viewport\"")
}

///|
test "menubar roving tab stop skips an initially disabled first trigger" {
  let html = render_incremental(() => {
    @rabbita-ui.menubar(id="disabled-first-menubar", scope => {
      @html.fragment([
        @rabbita-ui.menubar_menu(scope, value="disabled", menu => {
          @html.fragment([
            @rabbita-ui.menubar_trigger(
              menu,
              disabled=true,
              title="disabled-menubar-trigger",
              "Disabled",
            ),
            @rabbita-ui.menubar_content(menu, @html.nothing),
          ])
        }),
        @rabbita-ui.menubar_menu(scope, value="enabled", menu => {
          @html.fragment([
            @rabbita-ui.menubar_trigger(
              menu,
              title="enabled-menubar-trigger",
              "Enabled",
            ),
            @rabbita-ui.menubar_content(menu, @html.nothing),
          ])
        }),
      ])
    })
  })
  assert_element_tag_contains(
    html, "title=\"disabled-menubar-trigger\"", "tabindex=\"-1\"",
  )
  assert_element_tag_contains(
    html, "title=\"enabled-menubar-trigger\"", "tabindex=\"0\"",
  )
}

///|
test "navigation menu roving tab stop skips an initially disabled trigger" {
  let html = render_incremental(() => {
    @rabbita-ui.navigation_menu(
      id="disabled-first-navigation",
      viewport=false,
      scope => {
        @rabbita-ui.navigation_menu_list(scope, [
          @rabbita-ui.navigation_menu_item(scope, value="disabled", item => {
            @html.fragment([
              @rabbita-ui.navigation_menu_trigger(
                item,
                disabled=true,
                title="disabled-navigation-trigger",
                "Disabled",
              ),
              @rabbita-ui.navigation_menu_content(item, @html.nothing),
            ])
          }),
          @rabbita-ui.navigation_menu_item(scope, value="enabled", item => {
            @html.fragment([
              @rabbita-ui.navigation_menu_trigger(
                item,
                title="enabled-navigation-trigger",
                "Enabled",
              ),
              @rabbita-ui.navigation_menu_content(item, @html.nothing),
            ])
          }),
        ])
      },
    )
  })
  assert_element_tag_contains(
    html, "title=\"disabled-navigation-trigger\"", "tabindex=\"-1\"",
  )
  assert_element_tag_contains(
    html, "title=\"enabled-navigation-trigger\"", "tabindex=\"0\"",
  )
}

///|
test "menu subtrees use internal keys when public values repeat" {
  let html = render_incremental(() => {
    @rabbita-ui.dropdown_menu(
      id="duplicate-submenu-values",
      default_open=true,
      scope => {
        @html.fragment([
          @rabbita-ui.dropdown_menu_trigger(scope, "Open"),
          @rabbita-ui.dropdown_menu_content(scope, [
            @rabbita-ui.dropdown_menu_sub(scope, value="share", sub => {
              @html.fragment([
                @rabbita-ui.dropdown_menu_sub_trigger(sub, "Share one"),
                @rabbita-ui.dropdown_menu_sub_content(sub, @html.nothing),
              ])
            }),
            @rabbita-ui.dropdown_menu_sub(scope, value="share", sub => {
              @html.fragment([
                @rabbita-ui.dropdown_menu_sub_trigger(sub, "Share two"),
                @rabbita-ui.dropdown_menu_sub_content(sub, @html.nothing),
              ])
            }),
          ]),
        ])
      },
    )
  })
  assert_contains(
    html, "data-submenu-key=\"duplicate-submenu-values::share::submenu-0\"",
  )
  assert_contains(
    html, "data-submenu-key=\"duplicate-submenu-values::share::submenu-1\"",
  )
}
