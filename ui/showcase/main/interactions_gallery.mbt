///|
const IgComponentListStyle : String = "display:flex;width:100%;min-width:0;flex-direction:column;gap:4rem"

///|
const IgDemoSurfaceStyle : String = "position:relative;min-width:0;padding-block:1rem"

///|
const IgVariantGridStyle : String = "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,20rem),1fr));gap:1rem;min-width:0"

///|
const IgDropdownIconGridStyle : String = "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,12rem),1fr));gap:1rem;min-width:0"

///|
const IgFourDirectionGridStyle : String = "display:grid;width:min(100%,44rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,18rem),1fr));gap:2rem 3rem;min-width:0"

///|
const IgSpecimenStyle : String = "display:flex;min-width:0;flex-direction:column;gap:0.75rem"

///|
const IgSpecimenHeaderStyle : String = "display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"

///|
const IgControlWrapStyle : String = "display:flex;min-width:0;flex-wrap:wrap;align-items:center;gap:0.5rem"

///|
const IgSlideStyle : String = "display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px solid var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);font-size:1rem;font-weight:600"

///|
const IgCarouselStyle : String = "width:min(calc(100% - 6rem),32rem);margin-inline:auto"

///|
const IgVerticalCarouselStyle : String = "width:min(calc(100% - 6rem),32rem);margin:3rem auto"

///|
const IgVerticalSlideStyle : String = "height:var(--rui-carousel-height,12rem)"

///|
const IgNavigationContentStyle : String = "box-sizing:border-box;display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,8rem),1fr));gap:0.5rem;width:min(30rem,calc(100vw - 2rem));padding:0.25rem"

///|
const IgNavigationLinkStyle : String = "display:flex;min-height:4.5rem;flex-direction:column;justify-content:center;gap:0.25rem"

///|
const IgSidebarVariantsStyle : String = "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,28rem),1fr));gap:1rem;min-width:0"

///|
const IgSidebarVariantFrameStyle : String = "--rui-sidebar-width:min(15rem,calc(100% - 3.25rem));height:21rem;min-height:21rem;overflow:hidden;border:1px solid var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-background)"

///|
const IgSidebarInsetStyle : String = "min-width:0;padding:0.75rem"

///|
const IgContextTargetStyle : String = "display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px dashed var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);color:var(--rui-muted-foreground);font-size:0.8125rem;text-align:center;user-select:none"

///|
const IgCommandStyle : String = "max-width:none;border:1px solid var(--rui-border);border-radius:var(--rui-radius);box-shadow:none"

///|
const IgMessageViewportStyle : String = "height:13rem"

///|
const IgMessageListStyle : String = "display:flex;flex-direction:column;gap:0.625rem;padding:0.75rem"

///|
const IgResizeStyle : String = "height:14rem;overflow:hidden;border:1px solid var(--rui-border);border-radius:var(--rui-radius)"

///|
const IgResizePanelStyle : String = "display:flex;align-items:center;justify-content:center;padding:1.5rem;color:var(--rui-foreground);font-size:0.875rem;line-height:1.25rem;font-weight:500;text-align:center"

///|
const IgResizableVariantsStyle : String = "display:grid;width:min(100%,50rem);min-width:0;margin-inline:auto;gap:2rem"

///|
const IgResizableVerticalStyle : String = "width:min(100%,32rem);height:14rem;margin-inline:auto"

///|
const IgScrollAreaStyle : String = "height:13rem;border:1px solid var(--rui-border);border-radius:var(--rui-radius)"

///|
const IgScrollContentStyle : String = "display:flex;flex-direction:column;gap:0.625rem;padding:0.875rem 1.25rem 0.875rem 0.875rem"

///|
const IgHorizontalScrollAreaStyle : String = "width:100%;max-width:100%;height:5.5rem;border:1px solid var(--rui-border);border-radius:var(--rui-radius)"

///|
const IgHorizontalScrollContentStyle : String = "display:flex;width:max-content;min-width:44rem;gap:0.625rem;padding:0.875rem 1.25rem 1.25rem 0.875rem"

///|
fn ig_demo_card(
  title : String,
  description : String,
  body : @html.Html,
  variant_title : String,
  variant_description : String,
  code : String,
  wide? : Bool = false,
) -> @html.Html {
  showcase_component_demos(title, description, [
    showcase_demo_section(
      variant_title,
      variant_description,
      showcase_demo_stage(body, code, tall=wide),
    ),
  ])
}

///|
fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  @html.div(style=[IgSpecimenStyle], [
    @html.div(style=[IgSpecimenHeaderStyle], [
      @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
      @html.span(style=[MutedStyle, "font-size:0.75rem;text-align:start"], note),
    ]),
    @html.div(style=["min-width:0"], body),
  ])
}

///|
fn ig_breadcrumb_demo() -> @html.Html {
  ig_demo_card(
    "Breadcrumb",
    "Full and condensed trails cover links, separators, ellipsis, and current page state.",
    @html.div(style=[IgVariantGridStyle], [
      ig_specimen(
        "Default",
        "Linked ancestors",
        @ui.breadcrumb(
          @ui.breadcrumb_list([
            @ui.breadcrumb_item(@ui.breadcrumb_link(href="#interactions", "UI")),
            @ui.breadcrumb_separator(),
            @ui.breadcrumb_item(
              @ui.breadcrumb_link(href="#navigation", "Patterns"),
            ),
            @ui.breadcrumb_separator(),
            @ui.breadcrumb_item(@ui.breadcrumb_page("Navigation")),
          ]),
        ),
      ),
      ig_specimen(
        "Condensed",
        "Collapsed ancestors",
        @ui.breadcrumb(
          @ui.breadcrumb_list([
            @ui.breadcrumb_item(
              @ui.breadcrumb_link(href="#interactions", "Home"),
            ),
            @ui.breadcrumb_separator(),
            @ui.breadcrumb_item(@ui.breadcrumb_ellipsis()),
            @ui.breadcrumb_separator(),
            @ui.breadcrumb_item(@ui.breadcrumb_page("Current page")),
          ]),
        ),
      ),
    ]),
    "Default and condensed",
    "Linked ancestors and collapsed trails preserve the current-page relationship.",
    IgBreadcrumbCode,
  )
}

///|
fn ig_pagination_demo() -> @html.Html {
  ig_demo_card(
    "Pagination",
    "Default and compact compositions preserve native link semantics.",
    @html.div(style=[IgVariantGridStyle], [
      ig_specimen(
        "Default",
        "Pages + ellipsis",
        @ui.pagination(
          @ui.pagination_content([
            @ui.pagination_item(@ui.pagination_previous(href="#page-1")),
            @ui.pagination_item(
              @ui.pagination_link(href="#page-1", is_active=true, "1"),
            ),
            @ui.pagination_item(@ui.pagination_link(href="#page-2", "2")),
            @ui.pagination_item(@ui.pagination_ellipsis()),
            @ui.pagination_item(@ui.pagination_next(href="#page-2")),
          ]),
        ),
      ),
      ig_specimen(
        "Compact",
        "Small page links",
        @ui.pagination(
          aria_label="Compact pagination",
          @ui.pagination_content([
            @ui.pagination_item(@ui.pagination_previous(href="#page-1")),
            @ui.pagination_item(
              @ui.pagination_link(
                href="#page-1",
                is_active=true,
                size=@ui.Sm,
                "1",
              ),
            ),
            @ui.pagination_item(
              @ui.pagination_link(href="#page-2", size=@ui.Sm, "2"),
            ),
            @ui.pagination_item(@ui.pagination_next(href="#page-2")),
          ]),
        ),
      ),
    ]),
    "Default and compact",
    "Page links, ellipsis, previous, and next controls retain native link behavior at both sizes.",
    IgPaginationCode,
  )
}

///|
fn ig_sidebar_variant(
  id : String,
  side : @ui.SidebarSide,
  variant : @ui.SidebarVariant,
  collapsible : @ui.SidebarCollapsible,
  default_collapsed : Bool,
  menu_size : @ui.SidebarMenuButtonSize,
) -> @rabbita.Val[@html.Html] {
  @ui.sidebar_provider(default_collapsed~, style=[IgSidebarVariantFrameStyle], scope => {
    @html.fragment([
      @ui.sidebar(scope, id~, side~, variant~, collapsible~, [
        @ui.sidebar_header(
          @ui.sidebar_input(
            aria_label="Filter workspace navigation",
            placeholder="Filter…",
          ),
        ),
        @ui.sidebar_content(
          @ui.sidebar_group([
            @ui.sidebar_group_label(scope~, "Workspace"),
            @ui.sidebar_group_action(
              aria_label="Add workspace item",
              showcase_plus_icon(),
            ),
            @ui.sidebar_group_content(
              @ui.sidebar_menu([
                @ui.sidebar_menu_item([
                  @ui.sidebar_menu_button(
                    href="#overview",
                    is_active=true,
                    size=menu_size,
                    [showcase_layout_icon(), @html.span("Overview")],
                  ),
                  @ui.sidebar_menu_badge("6"),
                  @ui.sidebar_menu_action(
                    show_on_hover=true,
                    aria_label="Overview actions",
                    showcase_settings_icon(),
                  ),
                ]),
                @ui.sidebar_menu_item(
                  @ui.sidebar_menu_button(href="#activity", size=menu_size, [
                    showcase_activity_icon(),
                    @html.span("Activity"),
                  ]),
                ),
                @ui.sidebar_menu_item(
                  @ui.sidebar_menu_button(
                    href="#settings",
                    size=menu_size,
                    disabled=true,
                    [showcase_settings_icon(), @html.span("Disabled")],
                  ),
                ),
                @ui.sidebar_menu_item(
                  @ui.sidebar_menu_sub(
                    @ui.sidebar_menu_sub_item(
                      @ui.sidebar_menu_sub_button(
                        href="#reports",
                        is_active=true,
                        "Reports",
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ]),
        ),
        @ui.sidebar_separator(),
        @ui.sidebar_footer(
          @ui.sidebar_menu(
            @ui.sidebar_menu_item(
              @ui.sidebar_menu_button(href="#account", size=menu_size, [
                showcase_user_icon(),
                @html.span("Account"),
              ]),
            ),
          ),
        ),
        @ui.sidebar_rail(scope, side~),
      ]),
      @ui.sidebar_inset(style=[IgSidebarInsetStyle], [
        @html.div(style=[RowStyle, "justify-content:space-between"], [
          @ui.sidebar_trigger(
            scope,
            controls=id,
            aria_label="Toggle sidebar specimen",
            showcase_panel_left_icon(),
          ),
          @ui.badge(variant=@ui.Outline, "Live"),
        ]),
        @html.div(
          style=[
            "display:flex;min-height:11rem;align-items:center;justify-content:center",
          ],
          @html.p(
            style=[MutedStyle, "max-width:13rem;text-align:center"],
            "Use the trigger or rail to verify provider-owned state.",
          ),
        ),
      ]),
    ])
  })
}

///|
fn ig_navigation_section() -> @rabbita.Val[@html.Html] {
  let accordion_view = @ui.accordion(
    id="showcase-accordion",
    type_=@ui.Single,
    collapsible=true,
    default_value="keyboard",
    items=[
      @ui.accordion_entry(
        value="keyboard",
        label="Keyboard interaction",
        content=@html.p(
          style=[MutedStyle, "margin:0"],
          "Tab reaches each trigger; Enter and Space toggle its panel.",
        ),
      ),
      @ui.accordion_entry(
        value="state",
        label="Owned state",
        content=@html.p(
          style=[MutedStyle, "margin:0"],
          "The black-box root owns its expanded value through Rabbita.",
        ),
      ),
      @ui.accordion_entry(
        value="markup",
        label="Native markup",
        content=@html.p(
          style=[MutedStyle, "margin:0"],
          "Details and summary preserve useful behavior without JavaScript.",
        ),
      ),
    ],
  )
  let accordion_multiple_view = @ui.accordion(
    id="showcase-accordion-multiple",
    type_=@ui.Multiple,
    default_values=["motion", "focus"],
    items=[
      @ui.accordion_entry(
        value="motion",
        label="Motion",
        content=@html.p(
          style=[MutedStyle, "margin:0"],
          "Each expanded panel animates independently.",
        ),
      ),
      @ui.accordion_entry(
        value="focus",
        label="Keyboard focus",
        content=@html.p(
          style=[MutedStyle, "margin:0"],
          "Arrow keys move between enabled triggers.",
        ),
      ),
      @ui.accordion_entry(
        value="locked",
        label="Unavailable section",
        disabled=true,
        content=@html.p("This panel cannot be opened."),
      ),
    ],
  )
  let carousel_view = @ui.carousel(
    id="showcase-carousel",
    count=3,
    loop_=true,
    orientation=@ui.CarouselHorizontal,
    aria_label="Rabbita UI highlights",
    style=[IgCarouselStyle],
    scope => {
      @html.fragment([
        @ui.carousel_items(scope~, items=[
          @html.div(style=[IgSlideStyle], "Inline styles"),
          @html.div(style=[IgSlideStyle], "Incremental state"),
          @html.div(style=[IgSlideStyle], "Native semantics"),
        ]),
        @ui.carousel_previous(scope~),
        @ui.carousel_next(scope~),
      ])
    },
  )
  let carousel_vertical_view = @ui.carousel(
    id="showcase-carousel-vertical",
    count=3,
    default_index=1,
    orientation=@ui.CarouselVertical,
    aria_label="Vertical Rabbita UI highlights",
    style=[IgVerticalCarouselStyle],
    scope => {
      @html.fragment([
        @ui.carousel_items(scope~, items=[
          @html.div(style=[IgSlideStyle, IgVerticalSlideStyle], "First slide"),
          @html.div(
            style=[IgSlideStyle, IgVerticalSlideStyle],
            "Selected slide",
          ),
          @html.div(style=[IgSlideStyle, IgVerticalSlideStyle], "Last slide"),
        ]),
        @ui.carousel_previous(scope~),
        @ui.carousel_next(scope~),
      ])
    },
  )
  let collapsible_view = @ui.collapsible(
    id="showcase-collapsible",
    default_open=true,
    trigger="What ships inside the component?",
    content=@html.div(style=[StackStyle, "padding-top:0.75rem;gap:0.5rem"], [
      @html.p(
        style=[MutedStyle, "margin:0"],
        "State, ARIA relationships, and keyboard behavior.",
      ),
      @ui.badge(variant=@ui.Secondary, "No registration step"),
    ]),
  )
  let navigation_view = @ui.navigation_menu(
    id="showcase-navigation-menu",
    aria_label="Showcase navigation",
    scope => {
      @html.div(style=["min-height:10rem"], [
        @ui.navigation_menu_list(scope, [
          @ui.navigation_menu_item(scope, value="platform", item => {
            @html.fragment([
              @ui.navigation_menu_trigger(item, "Platform"),
              @ui.navigation_menu_indicator(item),
              @ui.navigation_menu_content(
                item,
                style=[IgNavigationContentStyle],
                [
                  @ui.navigation_menu_link(
                    href="#components",
                    active=true,
                    style=[IgNavigationLinkStyle],
                    [
                      @html.strong("Components"),
                      @html.span(style=[MutedStyle], "Black-box defaults"),
                    ],
                  ),
                  @ui.navigation_menu_link(
                    href="#patterns",
                    style=[IgNavigationLinkStyle],
                    [
                      @html.strong("Patterns"),
                      @html.span(style=[MutedStyle], "Compound composition"),
                    ],
                  ),
                ],
              ),
            ])
          }),
          @ui.navigation_menu_item(scope, value="resources", item => {
            @html.fragment([
              @ui.navigation_menu_trigger(item, "Resources"),
              @ui.navigation_menu_indicator(item),
              @ui.navigation_menu_content(
                item,
                style=[IgNavigationContentStyle],
                [
                  @ui.navigation_menu_link(
                    href="#api",
                    style=[IgNavigationLinkStyle],
                    [
                      @html.strong("API reference"),
                      @html.span(style=[MutedStyle], "Typed MoonBit surface"),
                    ],
                  ),
                  @ui.navigation_menu_link(
                    href="#examples",
                    style=[IgNavigationLinkStyle],
                    [
                      @html.strong("Examples"),
                      @html.span(style=[MutedStyle], "Working interactions"),
                    ],
                  ),
                ],
              ),
            ])
          }),
        ]),
        @ui.navigation_menu_viewport(scope, @html.nothing),
      ])
    },
  )
  let navigation_inline_view = @ui.navigation_menu(
    id="showcase-navigation-menu-inline",
    viewport=false,
    aria_label="Inline navigation menu",
    scope => {
      @ui.navigation_menu_list(scope, [
        @ui.navigation_menu_item(scope, value="learn", item => {
          @html.fragment([
            @ui.navigation_menu_trigger(item, "Learn"),
            @ui.navigation_menu_content(
              item,
              style=[IgNavigationContentStyle],
              [
                @ui.navigation_menu_link(
                  href="#guide",
                  active=true,
                  style=[IgNavigationLinkStyle],
                  [
                    @html.strong("Guide"),
                    @html.span(style=[MutedStyle], "Active destination"),
                  ],
                ),
                @ui.navigation_menu_link(
                  href="#examples",
                  style=[IgNavigationLinkStyle],
                  [
                    @html.strong("Examples"),
                    @html.span(style=[MutedStyle], "Inline content"),
                  ],
                ),
              ],
            ),
          ])
        }),
        @ui.navigation_menu_item(scope, value="disabled", item => {
          @ui.navigation_menu_trigger(item, disabled=true, "Unavailable")
        }),
      ])
    },
  )
  let sidebar_fixed_view = ig_sidebar_variant(
    "showcase-sidebar-fixed",
    @ui.SidebarLeft,
    @ui.SidebarDefault,
    @ui.SidebarFixed,
    false,
    @ui.SidebarMenuSm,
  )
  let sidebar_icon_view = ig_sidebar_variant(
    "showcase-sidebar-icon",
    @ui.SidebarLeft,
    @ui.SidebarFloating,
    @ui.SidebarIcon,
    true,
    @ui.SidebarMenuDefault,
  )
  let sidebar_offcanvas_view = ig_sidebar_variant(
    "showcase-sidebar-offcanvas",
    @ui.SidebarRight,
    @ui.SidebarInset,
    @ui.SidebarOffcanvas,
    false,
    @ui.SidebarMenuLg,
  )
  let tabs_view = @ui.tabs(
    id="showcase-tabs",
    default_value="preview",
    orientation=@ui.TabsHorizontal,
    aria_label="Component workflow",
    items=[
      @ui.tab_entry(
        value="preview",
        label="Preview",
        content=@html.div(style=[IgDemoSurfaceStyle], [
          @html.strong("Ready to interact"),
          @html.p(
            style=[MutedStyle, "margin:0.375rem 0 0"],
            "The selected panel is linked to its trigger.",
          ),
        ]),
      ),
      @ui.tab_entry(
        value="source",
        label="Source",
        content=@html.div(style=[IgDemoSurfaceStyle], [
          @html.strong("Copy when you need control"),
          @html.p(
            style=[MutedStyle, "margin:0.375rem 0 0"],
            "Otherwise consume the component as a black box.",
          ),
        ]),
      ),
      @ui.tab_entry(
        value="accessibility",
        label="A11y",
        content=@html.div(style=[IgDemoSurfaceStyle], [
          @html.strong("Roving focus"),
          @html.p(
            style=[MutedStyle, "margin:0.375rem 0 0"],
            "Use Left and Right to move across tabs.",
          ),
        ]),
      ),
    ],
  )
  let tabs_vertical_view = @ui.tabs(
    id="showcase-tabs-vertical",
    default_value="general",
    orientation=@ui.TabsVertical,
    aria_label="Vertical settings tabs",
    items=[
      @ui.tab_entry(
        value="general",
        label="General",
        content=@html.div(style=[IgDemoSurfaceStyle], [
          @html.strong("General settings"),
          @html.p(
            style=[MutedStyle, "margin:0.375rem 0 0"],
            "Up and Down move focus in a vertical list.",
          ),
        ]),
      ),
      @ui.tab_entry(
        value="members",
        label="Members",
        content=@html.div(style=[IgDemoSurfaceStyle], "Member access settings"),
      ),
      @ui.tab_entry(
        value="billing",
        label="Billing",
        disabled=true,
        content=@html.div(style=[IgDemoSurfaceStyle], "Unavailable"),
      ),
    ],
  )
  let tabs_line_view = @ui.tabs(
    id="showcase-tabs-line",
    default_value="account",
    list_variant=@ui.TabsLine,
    aria_label="Account sections",
    items=[
      @ui.tab_entry(
        value="account",
        label="Account",
        content=@html.div(style=[IgDemoSurfaceStyle], [
          @html.strong("Account profile"),
          @html.p(
            style=[MutedStyle, "margin:0.375rem 0 0"],
            "The active line follows the selected tab.",
          ),
        ]),
      ),
      @ui.tab_entry(
        value="security",
        label="Security",
        content=@html.div(style=[IgDemoSurfaceStyle], "Security settings"),
      ),
      @ui.tab_entry(
        value="notifications",
        label="Notifications",
        content=@html.div(
          style=[IgDemoSurfaceStyle],
          "Notification preferences",
        ),
      ),
    ],
  )
  let accordion_variants = accordion_view.view2(accordion_multiple_view, (
    single_html,
    multiple_html,
  ) => {
    @html.div(style=[IgVariantGridStyle], [
      ig_specimen("Single", "Collapsible", single_html),
      ig_specimen("Multiple", "Independent panels", multiple_html),
    ])
  })
  let carousel_variants = carousel_view.view2(carousel_vertical_view, (
    horizontal_html,
    vertical_html,
  ) => {
    @html.div(style=[IgVariantGridStyle], [
      ig_specimen("Horizontal", "Looping", horizontal_html),
      ig_specimen("Vertical", "Bounded", vertical_html),
    ])
  })
  let collapsible_variants = collapsible_view.view(open_html => open_html)
  let navigation_variants = navigation_view.view2(navigation_inline_view, (
    viewport_html,
    inline_html,
  ) => {
    @html.div(style=[IgVariantGridStyle], [
      ig_specimen("Viewport", "Shared layer", viewport_html),
      ig_specimen("Inline", "Local panels", inline_html),
    ])
  })
  let sidebar_variants = sidebar_fixed_view.view3(
    sidebar_icon_view,
    sidebar_offcanvas_view,
    (fixed_html, icon_html, offcanvas_html) => {
      @html.div(style=[IgSidebarVariantsStyle], [
        ig_specimen("Default · left", "Fixed · small", fixed_html),
        ig_specimen("Floating · left", "Icon · default", icon_html),
        ig_specimen("Inset · right", "Offcanvas · large", offcanvas_html),
      ])
    },
  )
  let tabs_variants = tabs_view.view3(tabs_line_view, tabs_vertical_view, (
    horizontal_html,
    line_html,
    vertical_html,
  ) => {
    @html.div(style=[IgVariantGridStyle], [
      ig_specimen("Default", "Horizontal · Left / Right", horizontal_html),
      ig_specimen("Line", "Horizontal · Left / Right", line_html),
      ig_specimen("Vertical", "Up / Down", vertical_html),
    ])
  })
  accordion_variants.view6(
    carousel_variants,
    collapsible_variants,
    navigation_variants,
    sidebar_variants,
    tabs_variants,
    (
      accordion_html,
      carousel_html,
      collapsible_html,
      navigation_html,
      sidebar_html,
      tabs_html,
    ) => {
      @html.section(
        id="navigation",
        style=[IgComponentListStyle, "scroll-margin-top:1rem"],
        [
          ig_demo_card(
            "Accordion",
            "Single and multiple disclosure models.",
            accordion_html,
            "Single and multiple",
            "Single mode can collapse its active panel; multiple mode keeps independent panels open.",
            IgAccordionCode,
            wide=true,
          ),
          ig_demo_card(
            "Collapsible",
            "One interactive disclosure demonstrates the complete open and close cycle.",
            collapsible_html,
            "Default open",
            "The trigger and region stay linked while the component owns its open state.",
            IgCollapsibleCode,
          ),
          ig_demo_card(
            "Tabs",
            "Horizontal and vertical orientation with roving keyboard focus.",
            tabs_html,
            "Default, line, and vertical",
            "List treatment and orientation change without moving selection state into the showcase.",
            IgTabsCode,
            wide=true,
          ),
          ig_breadcrumb_demo(),
          ig_pagination_demo(),
          ig_demo_card(
            "Carousel",
            "Horizontal and vertical tracks with bounded and looping navigation.",
            carousel_html,
            "Horizontal and vertical",
            "Both orientations expose previous and next controls while the root owns the active slide.",
            IgCarouselCode,
            wide=true,
          ),
          ig_demo_card(
            "Navigation Menu",
            "Shared viewport and inline content use the same anchored interaction model.",
            navigation_html,
            "Viewport and inline",
            "Shared-viewport and local-panel variants retain the same trigger and link semantics.",
            IgNavigationMenuCode,
            wide=true,
          ),
          ig_demo_card(
            "Sidebar",
            "Default, floating, and inset layouts use left, right, fixed, icon, and off-canvas configurations.",
            sidebar_html,
            "Fixed, icon, and off-canvas",
            "Provider-owned collapse state is exercised across side, surface, and menu-size variants.",
            IgSidebarCode,
            wide=true,
          ),
        ],
      )
    },
  )
}

///|
fn ig_dialog_variant(
  id : String,
  modal : Bool,
  trigger_variant : @ui.ButtonVariant,
  trigger_label : String,
) -> @rabbita.Val[@html.Html] {
  @ui.dialog(id~, modal~, scope => {
    @html.fragment([
      @ui.dialog_trigger(scope, variant=trigger_variant, trigger_label),
      @ui.dialog_portal([
        @ui.dialog_content(scope, show_close=true, [
          @ui.dialog_header([
            @ui.dialog_title(scope, trigger_label),
            @ui.dialog_description(
              scope,
              if modal {
                "Focus stays inside this modal surface until it closes."
              } else {
                "This non-modal surface leaves the surrounding page available."
              },
            ),
          ]),
          @html.div(style=[StackStyle], [
            @ui.label(for_=id + "-name", "Display name"),
            @ui.input(id=id + "-name", value="Rabbita team"),
          ]),
          @ui.dialog_footer(@ui.dialog_close(scope, "Save changes")),
        ]),
      ]),
    ])
  })
}

///|
fn ig_drawer_variant(
  id : String,
  direction : @ui.DrawerDirection,
  trigger_label : String,
) -> @rabbita.Val[@html.Html] {
  @ui.drawer(id~, scope => {
    @html.fragment([
      @ui.drawer_trigger(scope, variant=@ui.Outline, trigger_label),
      @ui.drawer_portal([
        @ui.drawer_content(
          scope,
          direction~,
          show_handle=true,
          show_close=true,
          [
            @ui.drawer_header([
              @ui.drawer_title(scope, trigger_label),
              @ui.drawer_description(
                scope, "The direction controls placement, motion, and handle orientation.",
              ),
            ]),
            @html.div(style=[IgDemoSurfaceStyle], "All checks passed"),
            @ui.drawer_footer(@ui.drawer_close(scope, "Close")),
          ],
        ),
      ]),
    ])
  })
}

///|
fn ig_sheet_variant(
  id : String,
  side : @ui.SheetSide,
  trigger_label : String,
) -> @rabbita.Val[@html.Html] {
  @ui.sheet(id~, scope => {
    @html.fragment([
      @ui.sheet_trigger(scope, variant=@ui.Outline, trigger_label),
      @ui.sheet_content(scope, side~, [
        @ui.sheet_header([
          @ui.sheet_title(scope, trigger_label),
          @ui.sheet_description(
            scope, "Placement changes while focus and dismissal behavior stay consistent.",
          ),
        ]),
        @html.div(style=[StackStyle], [
          @ui.label(for_=id + "-email", "Notification email"),
          @ui.input(id=id + "-email", value="team@example.com"),
        ]),
        @ui.sheet_footer(@ui.sheet_close(scope, "Save settings")),
      ]),
    ])
  })
}

///|
fn ig_popover_variant(
  id : String,
  side : @ui.PopupSide,
  align : @ui.PopupAlign,
  trigger_label : String,
) -> @rabbita.Val[@html.Html] {
  let title_id = id + "-title"
  let description_id = id + "-description"
  @ui.popover(
    id~,
    side~,
    align~,
    title_id~,
    description_id~,
    trigger_variant=@ui.Outline,
    trigger_label,
    @html.div(style=[StackStyle, "gap:0.75rem"], [
      @ui.popover_header([
        @ui.popover_title(id=title_id, trigger_label),
        @ui.popover_description(
          id=description_id,
          "Anchored content stays labelled at this placement.",
        ),
      ]),
      @ui.input(
        value="320 px",
        attrs=@html.Attrs::build().aria_label("Preferred width"),
      ),
      @ui.popover_close_button(target_id=id, size=@ui.Sm, "Apply"),
    ]),
  )
}

///|
fn ig_hover_card_variant(
  id : String,
  side : @ui.PopupSide,
  align : @ui.PopupAlign,
  trigger_label : String,
) -> @rabbita.Val[@html.Html] {
  @ui.hover_card(
    id~,
    href="#rabbita-profile",
    open_delay=120,
    close_delay=80,
    side~,
    align~,
    trigger_variant=@ui.Link,
    trigger_label,
    @html.div(style=[StackStyle, "gap:0.5rem"], [
      @html.strong("Rabbita UI"),
      @html.p(
        style=[MutedStyle, "margin:0"],
        "Native MoonBit components with incremental state.",
      ),
      @html.div(style=[RowStyle], [
        @ui.badge(variant=@ui.Secondary, "Vega"),
        @ui.badge(variant=@ui.Outline, "Inline"),
      ]),
    ]),
  )
}

///|
fn ig_tooltip_variant(
  id : String,
  side : @ui.PopupSide,
  align : @ui.PopupAlign,
  size : @ui.ButtonSize,
  label : String,
) -> @rabbita.Val[@html.Html] {
  @ui.tooltip(
    id~,
    delay=100,
    side~,
    align~,
    show_arrow=true,
    trigger_variant=@ui.Outline,
    trigger_size=size,
    trigger_attrs=@html.Attrs::build().aria_label(label),
    showcase_circle_help_icon(),
    label,
  )
}

///|
fn ig_overlay_section() -> @rabbita.Val[@html.Html] {
  let alert_dialog_view = @ui.alert_dialog(id="showcase-alert-dialog", scope => {
    @html.fragment([
      @ui.alert_dialog_trigger(
        scope,
        variant=@ui.Destructive,
        "Delete snapshot",
      ),
      @ui.alert_dialog_portal([
        @ui.alert_dialog_content(scope, [
          @ui.alert_dialog_header([
            @ui.alert_dialog_media(showcase_alert_triangle_icon()),
            @ui.alert_dialog_title(scope, "Delete this snapshot?"),
            @ui.alert_dialog_description(
              scope, "This removes the saved state permanently.",
            ),
          ]),
          @ui.alert_dialog_footer([
            @ui.alert_dialog_cancel(scope, "Cancel"),
            @ui.alert_dialog_action(scope, "Delete"),
          ]),
        ]),
      ]),
    ])
  })
  let alert_dialog_default_view = @ui.alert_dialog(
    id="showcase-alert-dialog-default",
    scope => {
      @html.fragment([
        @ui.alert_dialog_trigger(scope, variant=@ui.Outline, "Archive project"),
        @ui.alert_dialog_portal([
          @ui.alert_dialog_content(scope, [
            @ui.alert_dialog_header([
              @ui.alert_dialog_title(scope, "Archive this project?"),
              @ui.alert_dialog_description(
                scope, "You can restore an archived project later from workspace settings.",
              ),
            ]),
            @ui.alert_dialog_footer([
              @ui.alert_dialog_cancel(scope, "Cancel"),
              @ui.alert_dialog_action(scope, "Archive"),
            ]),
          ]),
        ]),
      ])
    },
  )
  let command_view = @ui.command(
    id="showcase-command",
    style=[IgCommandStyle],
    scope => {
      @html.fragment([
        @ui.command_input(scope~, placeholder="Search actions…"),
        @ui.command_list(scope~, [
          @ui.command_empty(scope~, "No matching actions."),
          @ui.command_group(scope~, heading="Workspace", [
            @ui.command_item(
              scope~,
              value="Open dashboard",
              keywords=["home"],
              [@html.span("Open dashboard"), @ui.command_shortcut("⌘D")],
            ),
            @ui.command_item(scope~, value="Create project", keywords=["new"], [
              @html.span("Create project"),
              @ui.command_shortcut("⌘N"),
            ]),
            @ui.command_separator(),
            @ui.command_item(
              scope~,
              value="Settings",
              keywords=["preferences"],
              "Settings",
            ),
          ]),
        ]),
      ])
    },
  )
  let command_dialog_view = @ui.command_dialog(
    id="showcase-command-dialog",
    aria_label="Command palette",
    trigger=scope => {
      @ui.command_dialog_trigger(scope~, variant=@ui.Outline, "Open palette")
    },
    scope => {
      @html.fragment([
        @ui.command_input(scope~, placeholder="Type a command…"),
        @ui.command_list(scope~, [
          @ui.command_empty(scope~, "No matching commands."),
          @ui.command_group(scope~, heading="Navigation", [
            @ui.command_item(scope~, value="Go to overview", "Go to overview"),
            @ui.command_item(scope~, value="Open settings", "Open settings"),
            @ui.command_item(
              scope~,
              value="Unavailable command",
              disabled=true,
              "Unavailable command",
            ),
          ]),
        ]),
      ])
    },
  )
  let context_menu_view = @ui.context_menu(
    id="showcase-context-menu",
    default_checked_values=["grid"],
    default_radio_values=[("density", "comfortable")],
    scope => {
      @html.fragment([
        @ui.context_menu_trigger(
          scope,
          style=[IgContextTargetStyle],
          "Right-click or press the context-menu key",
        ),
        @ui.context_menu_portal([
          @ui.context_menu_content(scope, aria_label="Canvas actions", [
            @ui.context_menu_label("Canvas"),
            @ui.context_menu_item(scope, [
              @html.span("Duplicate"),
              @ui.context_menu_shortcut("⌘D"),
            ]),
            @ui.context_menu_item(scope, "Rename"),
            @ui.context_menu_item(scope, inset=true, "Move to folder"),
            @ui.context_menu_item(scope, disabled=true, "Paste"),
            @ui.context_menu_checkbox_item(scope, value="grid", "Show grid"),
            @ui.context_menu_radio_group(scope, value="density", radio => {
              @html.fragment([
                @ui.context_menu_radio_item(
                  radio,
                  value="compact",
                  "Compact density",
                ),
                @ui.context_menu_radio_item(
                  radio,
                  value="comfortable",
                  "Comfortable density",
                ),
              ])
            }),
            @ui.context_menu_sub(scope, value="share", sub => {
              @html.fragment([
                @ui.context_menu_sub_trigger(sub, "Share"),
                @ui.context_menu_sub_content(sub, [
                  @ui.context_menu_item(scope, "Copy link"),
                  @ui.context_menu_item(scope, "Invite people"),
                ]),
              ])
            }),
            @ui.context_menu_separator(),
            @ui.context_menu_item(scope, destructive=true, "Delete"),
          ]),
        ]),
      ])
    },
  )
  let dialog_modal_view = ig_dialog_variant(
    "showcase-dialog-modal",
    true,
    @ui.Outline,
    "Edit profile",
  )
  let dialog_nonmodal_view = ig_dialog_variant(
    "showcase-dialog-nonmodal",
    false,
    @ui.Secondary,
    "Open non-modal",
  )
  let drawer_top_view = ig_drawer_variant(
    "showcase-drawer-top",
    @ui.DrawerTop,
    "Open top drawer",
  )
  let drawer_right_view = ig_drawer_variant(
    "showcase-drawer-right",
    @ui.DrawerRight,
    "Open right drawer",
  )
  let drawer_bottom_view = ig_drawer_variant(
    "showcase-drawer-bottom",
    @ui.DrawerBottom,
    "Open bottom drawer",
  )
  let drawer_left_view = ig_drawer_variant(
    "showcase-drawer-left",
    @ui.DrawerLeft,
    "Open left drawer",
  )
  let dropdown_view = @ui.dropdown_menu(
    id="showcase-dropdown-menu",
    default_checked_values=["status"],
    default_radio_values=[("density", "comfortable")],
    scope => {
      @html.fragment([
        @ui.dropdown_menu_trigger(scope, variant=@ui.Outline, "Workspace menu"),
        @ui.dropdown_menu_portal([
          @ui.dropdown_menu_content(scope, side=@ui.Bottom, align=@ui.Start, [
            @ui.dropdown_menu_label("Workspace"),
            @ui.dropdown_menu_item(scope, [
              @html.span("New tab"),
              @ui.dropdown_menu_shortcut("⌘T"),
            ]),
            @ui.dropdown_menu_item(scope, "Invite member"),
            @ui.dropdown_menu_item(scope, inset=true, "Move workspace"),
            @ui.dropdown_menu_item(scope, disabled=true, "Duplicate workspace"),
            @ui.dropdown_menu_checkbox_item(
              scope,
              value="status",
              close_on_select=false,
              "Show status",
            ),
            @ui.dropdown_menu_radio_group(scope, value="density", radio => {
              @html.fragment([
                @ui.dropdown_menu_radio_item(
                  radio,
                  value="compact",
                  "Compact density",
                ),
                @ui.dropdown_menu_radio_item(
                  radio,
                  value="comfortable",
                  "Comfortable density",
                ),
              ])
            }),
            @ui.dropdown_menu_sub(scope, value="share", sub => {
              @html.fragment([
                @ui.dropdown_menu_sub_trigger(sub, "Share"),
                @ui.dropdown_menu_sub_content(sub, [
                  @ui.dropdown_menu_item(scope, "Copy link"),
                  @ui.dropdown_menu_item(scope, "Invite people"),
                ]),
              ])
            }),
            @ui.dropdown_menu_separator(),
            @ui.dropdown_menu_item(scope, destructive=true, "Leave workspace"),
          ]),
        ]),
      ])
    },
  )
  let dropdown_placed_view = @ui.dropdown_menu(
    id="showcase-dropdown-menu-placed",
    scope => {
      @html.fragment([
        @ui.dropdown_menu_trigger(
          scope,
          variant=@ui.Secondary,
          size=@ui.Sm,
          "Top-end menu",
        ),
        @ui.dropdown_menu_portal([
          @ui.dropdown_menu_content(scope, side=@ui.Top, align=@ui.End, [
            @ui.dropdown_menu_item(scope, "Open"),
            @ui.dropdown_menu_item(scope, disabled=true, "Unavailable"),
            @ui.dropdown_menu_item(scope, destructive=true, "Remove"),
          ]),
        ]),
      ])
    },
  )
  let dropdown_icons_view = @ui.dropdown_menu(
    id="showcase-dropdown-menu-icons",
    scope => {
      @html.fragment([
        @ui.dropdown_menu_trigger(scope, variant=@ui.Outline, "Account"),
        @ui.dropdown_menu_portal([
          @ui.dropdown_menu_content(
            scope,
            side=@ui.Bottom,
            align=@ui.Start,
            style=["min-width:12rem"],
            [
              @ui.dropdown_menu_item(scope, [
                showcase_user_icon(),
                @html.span("Profile"),
              ]),
              @ui.dropdown_menu_item(scope, [
                showcase_credit_card_icon(),
                @html.span("Billing"),
              ]),
              @ui.dropdown_menu_item(scope, [
                showcase_settings_icon(),
                @html.span("Settings"),
              ]),
              @ui.dropdown_menu_separator(),
              @ui.dropdown_menu_item(scope, destructive=true, [
                showcase_log_out_icon(),
                @html.span("Log out"),
              ]),
            ],
          ),
        ]),
      ])
    },
  )
  let dropdown_checkbox_icons_view = @ui.dropdown_menu(
    id="showcase-dropdown-menu-checkbox-icons",
    default_checked_values=["email", "push"],
    scope => {
      @html.fragment([
        @ui.dropdown_menu_trigger(scope, variant=@ui.Outline, "Notifications"),
        @ui.dropdown_menu_portal([
          @ui.dropdown_menu_content(scope, style=["min-width:12rem"], [
            @ui.dropdown_menu_checkbox_item(scope, value="email", [
              showcase_mail_icon(),
              @html.span("Email"),
            ]),
            @ui.dropdown_menu_checkbox_item(scope, value="sms", [
              showcase_message_square_icon(),
              @html.span("SMS"),
            ]),
            @ui.dropdown_menu_checkbox_item(scope, value="push", [
              showcase_bell_icon(),
              @html.span("Push notifications"),
            ]),
          ]),
        ]),
      ])
    },
  )
  let dropdown_radio_icons_view = @ui.dropdown_menu(
    id="showcase-dropdown-menu-radio-icons",
    default_radio_values=[("payment", "card")],
    scope => {
      @html.fragment([
        @ui.dropdown_menu_trigger(scope, variant=@ui.Outline, "Payment method"),
        @ui.dropdown_menu_portal([
          @ui.dropdown_menu_content(
            scope,
            style=["min-width:12rem"],
            @ui.dropdown_menu_radio_group(scope, value="payment", radio => {
              @html.fragment([
                @ui.dropdown_menu_radio_item(radio, value="card", [
                  showcase_credit_card_icon(),
                  @html.span("Credit card"),
                ]),
                @ui.dropdown_menu_radio_item(radio, value="wallet", [
                  showcase_wallet_icon(),
                  @html.span("PayPal"),
                ]),
                @ui.dropdown_menu_radio_item(radio, value="bank", [
                  showcase_building_icon(),
                  @html.span("Bank transfer"),
                ]),
              ])
            }),
          ),
        ]),
      ])
    },
  )
  let alert_dialog_variants = alert_dialog_default_view.view2(
    alert_dialog_view,
    (default_html, destructive_html) => {
      @html.div(style=[IgVariantGridStyle], [
        ig_specimen("Default", "Reversible", default_html),
        ig_specimen("Destructive", "Permanent", destructive_html),
      ])
    },
  )
  let command_variants = command_view.view2(command_dialog_view, (
    inline_html,
    dialog_html,
  ) => {
    @html.div(style=[IgVariantGridStyle], [
      ig_specimen("Inline", "Filterable list", inline_html),
      ig_specimen("Dialog", "Trigger + modal", dialog_html),
    ])
  })
  let dialog_variants = dialog_modal_view.view2(dialog_nonmodal_view, (
    modal_html,
    nonmodal_html,
  ) => {
    @html.div(style=[IgVariantGridStyle], [
      ig_specimen("Modal", "Focus contained", modal_html),
      ig_specimen("Non-modal", "Page remains active", nonmodal_html),
    ])
  })
  let drawer_variants = drawer_top_view.view4(
    drawer_right_view,
    drawer_bottom_view,
    drawer_left_view,
    (top_html, right_html, bottom_html, left_html) => {
      @html.div(style=[IgFourDirectionGridStyle], [
        ig_specimen("Top", "Handle horizontal", top_html),
        ig_specimen("Right", "Handle vertical", right_html),
        ig_specimen("Bottom", "Handle horizontal", bottom_html),
        ig_specimen("Left", "Handle vertical", left_html),
      ])
    },
  )
  let first_row = alert_dialog_variants.view5(
    command_variants,
    context_menu_view,
    dialog_variants,
    drawer_variants,
    (
      alert_dialog_html,
      command_html,
      context_menu_html,
      dialog_html,
      drawer_html,
    ) => {
      @html.fragment([
        ig_demo_card(
          "Alert Dialog",
          "Default and destructive decisions require an explicit action.",
          alert_dialog_html,
          "Default and destructive",
          "Both decisions trap focus and require an explicit cancel or action before dismissal.",
          IgAlertDialogCode,
        ),
        ig_demo_card(
          "Dialog",
          "Modal and non-modal top-layer focus behavior.",
          dialog_html,
          "Modal and non-modal",
          "The modal variant contains focus while the non-modal variant leaves the surrounding page available.",
          IgDialogCode,
        ),
        ig_demo_card(
          "Drawer",
          "Top, right, bottom, and left placement include matching motion and handle orientation.",
          drawer_html,
          "Four directions",
          "Placement controls motion, edge geometry, and handle orientation through one public root.",
          IgDrawerCode,
        ),
        ig_demo_card(
          "Context Menu",
          "A complete menu composition opens on a dedicated right-click surface.",
          context_menu_html,
          "Rich menu",
          "Items, checkbox and radio values, a submenu, shortcuts, and destructive actions share one menu scope.",
          IgContextMenuCode,
          wide=true,
        ),
        ig_demo_card(
          "Command",
          "Inline and dialog listboxes share active-descendant navigation.",
          command_html,
          "Inline and dialog",
          "Filtering, groups, empty state, disabled items, and keyboard navigation use the same command API.",
          IgCommandCode,
          wide=true,
        ),
      ])
    },
  )
  let hover_card_top_view = ig_hover_card_variant(
    "showcase-hover-card-top",
    @ui.Top,
    @ui.Center,
    "Top-center preview",
  )
  let hover_card_left_view = ig_hover_card_variant(
    "showcase-hover-card-left",
    @ui.Left,
    @ui.End,
    "Left-end preview",
  )
  let menubar_view = @ui.menubar(
    id="showcase-menubar",
    default_checked_values=["sidebar"],
    default_radio_values=[("theme", "system")],
    scope => {
      @html.fragment([
        @ui.menubar_menu(scope, value="file", menu => {
          @html.fragment([
            @ui.menubar_trigger(menu, "File"),
            @ui.menubar_portal([
              @ui.menubar_content(menu, [
                @ui.menubar_label("Project"),
                @ui.menubar_item(menu, [
                  @html.span("New project"),
                  @ui.menubar_shortcut("⌘N"),
                ]),
                @ui.menubar_item(menu, inset=true, "Open…"),
                @ui.menubar_item(menu, disabled=true, "Import"),
                @ui.menubar_sub(menu, value="recent", sub => {
                  @html.fragment([
                    @ui.menubar_sub_trigger(sub, "Recent projects"),
                    @ui.menubar_sub_content(sub, [
                      @ui.menubar_item(menu, "Design system"),
                      @ui.menubar_item(menu, "Documentation"),
                    ]),
                  ])
                }),
                @ui.menubar_separator(),
                @ui.menubar_item(menu, destructive=true, "Close project"),
              ]),
            ]),
          ])
        }),
        @ui.menubar_menu(scope, value="view", menu => {
          @html.fragment([
            @ui.menubar_trigger(menu, "View"),
            @ui.menubar_content(menu, [
              @ui.menubar_checkbox_item(
                menu,
                value="sidebar",
                close_on_select=false,
                "Sidebar",
              ),
              @ui.menubar_radio_group(menu, value="theme", radio => {
                @html.fragment([
                  @ui.menubar_radio_item(radio, value="system", "System theme"),
                  @ui.menubar_radio_item(radio, value="light", "Light theme"),
                  @ui.menubar_radio_item(radio, value="dark", "Dark theme"),
                ])
              }),
              @ui.menubar_item(menu, "Focus mode"),
            ]),
          ])
        }),
        @ui.menubar_menu(scope, value="help", menu => {
          @html.fragment([
            @ui.menubar_trigger(menu, "Help"),
            @ui.menubar_content(
              menu,
              @ui.menubar_item(menu, "Keyboard shortcuts"),
            ),
          ])
        }),
      ])
    },
  )
  let popover_bottom_view = ig_popover_variant(
    "showcase-popover-bottom",
    @ui.Bottom,
    @ui.Start,
    "Bottom-start popover",
  )
  let popover_right_view = ig_popover_variant(
    "showcase-popover-right",
    @ui.Right,
    @ui.Center,
    "Right-center popover",
  )
  let sheet_top_view = ig_sheet_variant(
    "showcase-sheet-top",
    @ui.SheetTop,
    "Open top sheet",
  )
  let sheet_right_view = ig_sheet_variant(
    "showcase-sheet-right",
    @ui.SheetRight,
    "Open right sheet",
  )
  let sheet_bottom_view = ig_sheet_variant(
    "showcase-sheet-bottom",
    @ui.SheetBottom,
    "Open bottom sheet",
  )
  let sheet_left_view = ig_sheet_variant(
    "showcase-sheet-left",
    @ui.SheetLeft,
    "Open left sheet",
  )
  let tooltip_top_view = ig_tooltip_variant(
    "showcase-tooltip-top",
    @ui.Top,
    @ui.Start,
    @ui.IconSm,
    "Top-start tooltip",
  )
  let tooltip_right_view = ig_tooltip_variant(
    "showcase-tooltip-right",
    @ui.Right,
    @ui.Center,
    @ui.Icon,
    "Right-center tooltip",
  )
  let tooltip_bottom_view = ig_tooltip_variant(
    "showcase-tooltip-bottom",
    @ui.Bottom,
    @ui.End,
    @ui.IconLg,
    "Bottom-end tooltip",
  )
  let tooltip_left_view = ig_tooltip_variant(
    "showcase-tooltip-left",
    @ui.Left,
    @ui.Center,
    @ui.Icon,
    "Left-center tooltip",
  )
  let dropdown_variants = dropdown_view.view2(dropdown_placed_view, (
    bottom_html,
    top_html,
  ) => {
    @html.div(style=[IgVariantGridStyle], [
      ig_specimen("Bottom · start", "Rich menu", bottom_html),
      ig_specimen("Top · end", "Small trigger", top_html),
    ])
  })
  let dropdown_icon_variants = dropdown_icons_view.view3(
    dropdown_checkbox_icons_view,
    dropdown_radio_icons_view,
    (icons_html, checkbox_html, radio_html) => {
      @html.div(style=[IgDropdownIconGridStyle], [
        ig_specimen("Items", "Leading icons", icons_html),
        ig_specimen("Checkboxes", "Icons + trailing checks", checkbox_html),
        ig_specimen("Radio group", "Icons + trailing check", radio_html),
      ])
    },
  )
  let hover_card_variants = hover_card_top_view.view2(hover_card_left_view, (
    top_html,
    left_html,
  ) => {
    @html.div(style=[IgVariantGridStyle], [
      ig_specimen("Top · center", "Hover or focus", top_html),
      ig_specimen("Left · end", "Hoverable content", left_html),
    ])
  })
  let popover_variants = popover_bottom_view.view2(popover_right_view, (
    bottom_html,
    right_html,
  ) => {
    @html.div(style=[IgVariantGridStyle], [
      ig_specimen("Bottom · start", "Labelled form", bottom_html),
      ig_specimen("Right · center", "Focus restored", right_html),
    ])
  })
  let sheet_variants = sheet_top_view.view4(
    sheet_right_view,
    sheet_bottom_view,
    sheet_left_view,
    (top_html, right_html, bottom_html, left_html) => {
      @html.div(style=[IgFourDirectionGridStyle], [
        ig_specimen("Top", "Modal", top_html),
        ig_specimen("Right", "Modal", right_html),
        ig_specimen("Bottom", "Modal", bottom_html),
        ig_specimen("Left", "Modal", left_html),
      ])
    },
  )
  let tooltip_variants = tooltip_top_view.view4(
    tooltip_right_view,
    tooltip_bottom_view,
    tooltip_left_view,
    (top_html, right_html, bottom_html, left_html) => {
      @html.div(style=[IgFourDirectionGridStyle], [
        ig_specimen("Top · start", "Small icon", top_html),
        ig_specimen("Right · center", "Default icon", right_html),
        ig_specimen("Bottom · end", "Large icon", bottom_html),
        ig_specimen("Left · center", "Default icon", left_html),
      ])
    },
  )
  let second_row = dropdown_variants.view7(
    dropdown_icon_variants,
    hover_card_variants,
    menubar_view,
    popover_variants,
    sheet_variants,
    tooltip_variants,
    (
      dropdown_html,
      dropdown_icons_html,
      hover_card_html,
      menubar_html,
      popover_html,
      sheet_html,
      tooltip_html,
    ) => {
      @html.fragment([
        showcase_component_demos(
          "Dropdown Menu",
          "Placement, selection, and icon compositions use the same menu API.",
          [
            showcase_demo_section(
              "Bottom-start and top-end",
              "Placement variants share items, selection groups, submenus, shortcuts, and dismissal behavior.",
              showcase_demo_stage(dropdown_html, IgDropdownMenuCode),
            ),
            showcase_demo_section(
              "Icons",
              "Leading SVG icons combine with plain, checkbox, radio, and destructive items; selection checks stay in the trailing slot.",
              showcase_demo_stage(dropdown_icons_html, IgDropdownMenuIconsCode),
            ),
          ],
        ),
        ig_demo_card(
          "Menubar",
          "Project, view, and help menus share one keyboard-aware bar.",
          menubar_html,
          "Menus and selection items",
          "Checkbox, radio, submenu, disabled, inset, shortcut, and destructive items remain keyboard reachable.",
          IgMenubarCode,
          wide=true,
        ),
        ig_demo_card(
          "Popover",
          "Labelled content at bottom-start and right-center.",
          popover_html,
          "Bottom and side placement",
          "Both anchored forms preserve their labels, focus restoration, arrow position, and close action.",
          IgPopoverCode,
        ),
        ig_demo_card(
          "Hover Card",
          "Top-center and left-end previews remain keyboard reachable.",
          hover_card_html,
          "Top and side placement",
          "Pointer and keyboard entry share open and close delays while content remains hoverable.",
          IgHoverCardCode,
        ),
        ig_demo_card(
          "Tooltip",
          "Four placements demonstrate arrow alignment around icon triggers.",
          tooltip_html,
          "Four placements",
          "Top, right, bottom, and left variants align their arrows to real icon buttons.",
          IgTooltipCode,
        ),
        ig_demo_card(
          "Sheet",
          "Top, right, bottom, and left placements share one focus and dismissal contract.",
          sheet_html,
          "Four directions",
          "Every side uses the same labelled content, close action, focus behavior, and overlay dismissal.",
          IgSheetCode,
        ),
      ])
    },
  )
  first_row.view2(second_row, (first_html, second_html) => {
    @html.section(
      id="overlays",
      style=[IgComponentListStyle, "scroll-margin-top:1rem"],
      [first_html, second_html],
    )
  })
}

///|
fn ig_feedback_section() -> @rabbita.Val[@html.Html] {
  let sonner_view = @ui.sonner(max_toasts=3, position="bottom-right", scope => {
    @html.div(style=[IgControlWrapStyle], [
      @ui.button(
        size=@ui.Sm,
        on_click=scope.show(
          title="Saved",
          description="The draft remains in this workspace.",
          variant=@ui.ToastDefault,
        ),
        "Default toast",
      ),
      @ui.button(
        size=@ui.Sm,
        variant=@ui.Secondary,
        on_click=scope.show(
          title="Published",
          description="The latest UI preview is live.",
          variant=@ui.ToastSuccess,
        ),
        "Success toast",
      ),
      @ui.button(
        size=@ui.Sm,
        variant=@ui.Destructive,
        on_click=scope.show(
          title="Could not sync",
          description="Check the connection and try again.",
          variant=@ui.ToastDestructive,
        ),
        "Error toast",
      ),
      @ui.button(
        size=@ui.Sm,
        variant=@ui.Ghost,
        on_click=scope.dismiss_all(),
        "Dismiss queue",
      ),
    ])
  })
  let scroller_view = @ui.message_scroller(
    id="showcase-message-scroller",
    default_at_end=true,
    scope => {
      @html.div(style=["position:relative"], [
        @ui.message_scroller_viewport(
          scope~,
          style=[IgMessageViewportStyle],
          @ui.message_scroller_content(style=[IgMessageListStyle], [
            @ui.message_scroller_item(
              @ui.message([
                @ui.message_avatar(@ui.avatar(@ui.avatar_fallback("RA"))),
                @ui.message_content([
                  @ui.message_header("Rabbita · 09:41"),
                  @ui.bubble_group(
                    @ui.bubble(
                      variant=@ui.BubbleSecondary,
                      @ui.bubble_content(
                        "The component catalogue is ready for review.",
                      ),
                    ),
                  ),
                ]),
              ]),
            ),
            @ui.message_scroller_item(
              @ui.message(align=@ui.AlignEnd, [
                @ui.message_avatar(@ui.avatar(@ui.avatar_fallback("YO"))),
                @ui.message_content([
                  @ui.message_header("You · 09:42"),
                  @ui.bubble_group(
                    @ui.bubble(
                      align=@ui.AlignEnd,
                      @ui.bubble_content(
                        "Great — keep state local and the API black-box.",
                      ),
                    ),
                  ),
                  @ui.message_footer("Delivered"),
                ]),
              ]),
            ),
            @ui.message_scroller_item(
              @ui.message([
                @ui.message_avatar(@ui.avatar(@ui.avatar_fallback("RA"))),
                @ui.message_content(
                  @ui.bubble_group(
                    @ui.bubble(
                      variant=@ui.BubbleMuted,
                      @ui.bubble_content(
                        "This scroller tracks both edges and exposes jump controls.",
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            @ui.message_scroller_item(
              scroll_anchor=true,
              @ui.message(align=@ui.AlignEnd, [
                @ui.message_avatar(@ui.avatar(@ui.avatar_fallback("YO"))),
                @ui.message_content(
                  @ui.bubble_group(
                    @ui.bubble(
                      align=@ui.AlignEnd,
                      @ui.bubble_content("Ship the showcase."),
                    ),
                  ),
                ),
              ]),
            ),
          ]),
        ),
        @html.div(
          style=[
            "position:absolute;right:0.625rem;bottom:0.625rem;display:flex;gap:0.375rem",
          ],
          [
            @ui.message_scroller_button(
              scope~,
              direction=@ui.ScrollStart,
              label="Jump to first message",
              size=@ui.IconSm,
              showcase_arrow_up_icon(),
            ),
            @ui.message_scroller_button(
              scope~,
              direction=@ui.ScrollEnd,
              label="Jump to latest message",
              size=@ui.IconSm,
              showcase_arrow_down_icon(),
            ),
          ],
        ),
      ])
    },
  )
  let resizable_view = @ui.resizable_group(
    id="showcase-resizable",
    default_sizes=[26, 44, 30],
    min_sizes=[16, 24, 18],
    max_sizes=[52, 68, 54],
    orientation=@ui.Horizontal,
    style=[IgResizeStyle],
    scope => {
      @html.fragment([
        @ui.resizable_group_panel(
          scope~,
          index=0,
          style=[IgResizePanelStyle],
          "Files",
        ),
        @ui.resizable_group_handle(
          scope~,
          between=0,
          with_handle=true,
          aria_label="Resize files and editor",
        ),
        @ui.resizable_group_panel(
          scope~,
          index=1,
          style=[IgResizePanelStyle],
          "Editor",
        ),
        @ui.resizable_group_handle(
          scope~,
          between=1,
          with_handle=true,
          aria_label="Resize editor and preview",
        ),
        @ui.resizable_group_panel(
          scope~,
          index=2,
          style=[IgResizePanelStyle],
          "Preview",
        ),
      ])
    },
  )
  let resizable_panel_view = @ui.resizable_panel_group(
    id="showcase-resizable-panel-group",
    default_size=42,
    min=24,
    max=72,
    orientation=@ui.Vertical,
    aria_label="Resize preview and console",
    style=[IgResizeStyle, IgResizableVerticalStyle],
    scope => {
      @html.fragment([
        @ui.resizable_panel(
          scope~,
          side=@ui.FirstPanel,
          style=[IgResizePanelStyle],
          "Preview",
        ),
        @ui.resizable_handle(
          scope~,
          with_handle=true,
          aria_label="Resize preview and console",
        ),
        @ui.resizable_panel(
          scope~,
          side=@ui.SecondPanel,
          style=[IgResizePanelStyle],
          "Console",
        ),
      ])
    },
  )
  let scroll_view = @ui.scroll_area_with_scrollbar(
    id="showcase-scroll-area",
    orientation=@ui.Vertical,
    style=[IgScrollAreaStyle],
    @html.div(style=[IgScrollContentStyle], [
      @html.strong("Release checklist"),
      @ui.separator(),
      @html.span("Check semantic roles"),
      @html.span("Check keyboard order"),
      @html.span("Check light and dark themes"),
      @html.span("Check long labels"),
      @html.span("Check narrow containers"),
      @html.span("Check reduced motion"),
      @html.span("Check empty and error states"),
      @html.span("Check server rendering"),
      @html.span("Check native fallback"),
      @html.span("Ready to publish"),
    ]),
  )
  let scroll_horizontal_view = @ui.scroll_area_with_scrollbar(
    id="showcase-scroll-area-horizontal",
    orientation=@ui.Horizontal,
    style=[IgHorizontalScrollAreaStyle],
    @html.div(style=[IgHorizontalScrollContentStyle], [
      @ui.badge(variant=@ui.Secondary, "Keyboard"),
      @ui.badge(variant=@ui.Secondary, "Pointer"),
      @ui.badge(variant=@ui.Secondary, "Touch"),
      @ui.badge(variant=@ui.Secondary, "RTL"),
      @ui.badge(variant=@ui.Secondary, "Measured thumb"),
      @ui.badge(variant=@ui.Secondary, "Native fallback"),
    ]),
  )
  let toast_surfaces = @html.div(style=[IgVariantGridStyle], [
    ig_specimen(
      "Default",
      "Neutral status",
      @ui.toast(variant=@ui.ToastDefault, [
        @ui.toast_title("Draft saved"),
        @ui.toast_description("Your changes remain local."),
        @ui.toast_action("View"),
      ]),
    ),
    ig_specimen(
      "Success",
      "Positive status",
      @ui.toast(variant=@ui.ToastSuccess, [
        @ui.toast_title("Published"),
        @ui.toast_description("The latest preview is live."),
      ]),
    ),
    ig_specimen(
      "Destructive",
      "Error status",
      @ui.toast(variant=@ui.ToastDestructive, [
        @ui.toast_title("Could not sync"),
        @ui.toast_description("Check the connection and try again."),
      ]),
    ),
  ])
  let scroller_variants = scroller_view.view(scroller_html => scroller_html)
  let resizable_variants = resizable_view.view2(resizable_panel_view, (
    group_html,
    panel_html,
  ) => {
    @html.div(style=[IgResizableVariantsStyle], [
      ig_specimen("Multi-panel", "Horizontal · resizable_group", group_html),
      ig_specimen("Two-panel", "Vertical · panel_group", panel_html),
    ])
  })
  let scroll_variants = scroll_view.view2(scroll_horizontal_view, (
    vertical_html,
    horizontal_html,
  ) => {
    @html.div(style=[IgVariantGridStyle], [
      ig_specimen("Vertical", "Measured thumb", vertical_html),
      ig_specimen("Horizontal", "Measured thumb", horizontal_html),
    ])
  })
  sonner_view.view4(scroller_variants, resizable_variants, scroll_variants, (
    sonner_html,
    scroller_html,
    resizable_html,
    scroll_html,
  ) => {
    @html.section(
      id="feedback",
      style=[IgComponentListStyle, "scroll-margin-top:1rem"],
      [
        ig_demo_card(
          "Sonner",
          "A component-owned queue covers default, success, destructive, and dismissal behavior.",
          sonner_html,
          "Queue and dismissal",
          "Default, success, and destructive notifications share a bounded bottom-right queue with explicit dismissal.",
          IgSonnerCode,
          wide=true,
        ),
        ig_demo_card(
          "Toast",
          "Default, success, and destructive visual variants.",
          toast_surfaces,
          "Semantic variants",
          "Static toast compositions expose neutral, positive, and destructive treatments with optional actions.",
          IgToastCode,
          wide=true,
        ),
        ig_demo_card(
          "Message Scroller",
          "One interactive conversation exposes both jump directions.",
          scroller_html,
          "Conversation and edge controls",
          "Real Message and Bubble compositions sit inside the measured viewport with start and end jump buttons.",
          IgMessageScrollerCode,
          wide=true,
        ),
        ig_demo_card(
          "Resizable",
          "Horizontal multi-panel and vertical two-panel layouts.",
          resizable_html,
          "Horizontal and vertical",
          "Multi-panel and two-panel roots expose pointer and keyboard resize handles in both orientations.",
          IgResizableCode,
          wide=true,
        ),
        ig_demo_card(
          "Scroll Area",
          "Vertical and horizontal orientations use measured scrollbars.",
          scroll_html,
          "Vertical and horizontal",
          "Each viewport measures its content and exposes the matching proportional scrollbar.",
          IgScrollAreaCode,
          wide=true,
        ),
      ],
    )
  })
}

///|
fn interactions_gallery() -> @rabbita.Val[@html.Html] {
  let navigation_view = ig_navigation_section()
  let overlay_view = ig_overlay_section()
  let feedback_view = ig_feedback_section()
  navigation_view.view3(overlay_view, feedback_view, (
    navigation_html,
    overlay_html,
    feedback_html,
  ) => {
    @html.div(id="interactions-gallery", style=[IgComponentListStyle], [
      navigation_html, overlay_html, feedback_html,
    ])
  })
}
