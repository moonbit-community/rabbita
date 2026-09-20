///|
const IgComponentListStyle : String = "display:flex;width:100%;min-width:0;flex-direction:column;gap:4rem"

///|
const IgDemoSurfaceStyle : String = "position:relative;min-width:0;padding-block:1rem"

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
const IgSidebarVariantFrameStyle : String = "--rui-sidebar-width:15rem;height:24rem;min-height:24rem;overflow:hidden"

///|
const IgSidebarWorkspaceStyle : String = "box-sizing:border-box;display:flex;min-width:0;flex:1;flex-direction:column;padding:0.75rem"

///|
const IgSidebarWorkspaceBodyStyle : String = "display:flex;min-height:0;flex:1;align-items:center;justify-content:center;padding:1rem"

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
fn ig_breadcrumb_demo() -> @html.Html {
  showcase_component_demos(
    "Breadcrumb",
    "Full and condensed trails cover links, separators, ellipsis, and current page state.",
    [
      showcase_demo_section(
        "Default",
        "Linked ancestors preserve the current-page relationship.",
        showcase_demo_stage(
          @rui.breadcrumb(
            @rui.breadcrumb_list([
              @rui.breadcrumb_item(
                @rui.breadcrumb_link(href="#interactions", "UI"),
              ),
              @rui.breadcrumb_separator(),
              @rui.breadcrumb_item(
                @rui.breadcrumb_link(href="#navigation", "Patterns"),
              ),
              @rui.breadcrumb_separator(),
              @rui.breadcrumb_item(@rui.breadcrumb_page("Navigation")),
            ]),
          ),
          IgBreadcrumbDefaultCode,
        ),
      ),
      showcase_demo_section(
        "Condensed",
        "An ellipsis collapses intermediate ancestors without changing semantics.",
        showcase_demo_stage(
          @rui.breadcrumb(
            @rui.breadcrumb_list([
              @rui.breadcrumb_item(
                @rui.breadcrumb_link(href="#interactions", "Home"),
              ),
              @rui.breadcrumb_separator(),
              @rui.breadcrumb_item(@rui.breadcrumb_ellipsis()),
              @rui.breadcrumb_separator(),
              @rui.breadcrumb_item(@rui.breadcrumb_page("Current page")),
            ]),
          ),
          IgBreadcrumbCondensedCode,
        ),
      ),
    ],
  )
}

///|
fn ig_pagination_demo() -> @html.Html {
  showcase_component_demos(
    "Pagination",
    "Default and compact compositions preserve native link semantics.",
    [
      showcase_demo_section(
        "Default",
        "Pages, ellipsis, previous, and next controls retain native link behavior.",
        showcase_demo_stage(
          @rui.pagination(
            @rui.pagination_content([
              @rui.pagination_item(@rui.pagination_previous(href="#page-1")),
              @rui.pagination_item(
                @rui.pagination_link(href="#page-1", is_active=true, "1"),
              ),
              @rui.pagination_item(@rui.pagination_link(href="#page-2", "2")),
              @rui.pagination_item(@rui.pagination_ellipsis()),
              @rui.pagination_item(@rui.pagination_next(href="#page-2")),
            ]),
          ),
          IgPaginationDefaultCode,
        ),
      ),
      showcase_demo_section(
        "Compact",
        "Smaller numbered links keep the same previous and next navigation.",
        showcase_demo_stage(
          @rui.pagination(
            aria_label="Compact pagination",
            @rui.pagination_content([
              @rui.pagination_item(@rui.pagination_previous(href="#page-1")),
              @rui.pagination_item(
                @rui.pagination_link(
                  href="#page-1",
                  is_active=true,
                  size=Sm,
                  "1",
                ),
              ),
              @rui.pagination_item(
                @rui.pagination_link(href="#page-2", size=Sm, "2"),
              ),
              @rui.pagination_item(@rui.pagination_next(href="#page-2")),
            ]),
          ),
          IgPaginationCompactCode,
        ),
      ),
    ],
  )
}

///|
fn ig_carousel_component(
  horizontal_html : @html.Html,
  vertical_html : @html.Html,
) -> @html.Html {
  showcase_component_demos(
    "Carousel",
    "Horizontal and vertical tracks with bounded and looping navigation.",
    [
      showcase_demo_section(
        "Horizontal",
        "A looping horizontal track keeps previous and next controls outside the viewport.",
        showcase_demo_stage(
          horizontal_html,
          IgCarouselHorizontalCode,
          tall=true,
        ),
      ),
      showcase_demo_section(
        "Vertical",
        "A bounded vertical track starts on the selected middle slide.",
        showcase_demo_stage(vertical_html, IgCarouselVerticalCode, tall=true),
      ),
    ],
  )
}

///|
fn ig_accordion_component(
  single_html : @html.Html,
  multiple_html : @html.Html,
) -> @html.Html {
  showcase_component_demos(
    "Accordion",
    "Single and multiple disclosure models.",
    [
      showcase_demo_section(
        "Single",
        "Single mode can collapse its active panel.",
        showcase_demo_stage(single_html, IgAccordionSingleCode, tall=true),
      ),
      showcase_demo_section(
        "Multiple",
        "Multiple mode keeps independent panels open.",
        showcase_demo_stage(multiple_html, IgAccordionMultipleCode, tall=true),
      ),
    ],
  )
}

///|
fn ig_tabs_component(
  default_html : @html.Html,
  line_html : @html.Html,
  vertical_html : @html.Html,
  disabled_html : @html.Html,
  icons_html : @html.Html,
) -> @html.Html {
  showcase_component_demos(
    "Tabs",
    "List treatment and orientation change without moving selection state into the showcase.",
    [
      showcase_demo_section(
        "Default",
        "Horizontal tabs use Left and Right for roving focus.",
        showcase_demo_stage(default_html, IgTabsDefaultCode),
      ),
      showcase_demo_section(
        "Line",
        "A line treatment keeps the same horizontal interaction model.",
        showcase_demo_stage(line_html, IgTabsLineCode),
      ),
      showcase_demo_section(
        "Vertical",
        "Vertical tabs use Up and Down for roving focus.",
        showcase_demo_stage(vertical_html, IgTabsVerticalCode),
      ),
      showcase_demo_section(
        "Disabled",
        "Disabled triggers stay visible while leaving the roving tab order.",
        showcase_demo_stage(disabled_html, IgTabsDisabledCode),
      ),
      showcase_demo_section(
        "Icons",
        "SVG icons and text share the same trigger alignment and selection behavior.",
        showcase_demo_stage(icons_html, IgTabsIconsCode),
      ),
    ],
  )
}

///|
fn ig_navigation_menu_component(
  viewport_html : @html.Html,
  inline_html : @html.Html,
) -> @html.Html {
  showcase_component_demos(
    "Navigation Menu",
    "Shared viewport and inline content use the same anchored interaction model.",
    [
      showcase_demo_section(
        "Viewport",
        "A shared viewport hosts content from the active navigation item.",
        showcase_demo_stage(
          viewport_html,
          IgNavigationMenuViewportCode,
          tall=true,
        ),
      ),
      showcase_demo_section(
        "Inline",
        "Local panels remain anchored to their own navigation items.",
        showcase_demo_stage(inline_html, IgNavigationMenuInlineCode, tall=true),
      ),
    ],
  )
}

///|
fn ig_sidebar_panel_icon(side : @rui.SidebarSide) -> @html.Html {
  if side == SidebarRight {
    showcase_stroke_icon("M3 3h18v18H3zM15 3v18")
  } else {
    showcase_panel_left_icon()
  }
}

///|
fn ig_sidebar_navigation(
  scope : @rui.SidebarScope,
  side : @rui.SidebarSide,
  menu_size : @rui.SidebarMenuButtonSize,
  mobile : Bool,
  interactive : Bool,
) -> @html.Html {
  let close_command = if mobile {
    @rui.sidebar_close_mobile(scope)
  } else {
    @rui.sidebar_collapse(scope)
  }
  @html.fragment([
    @rui.sidebar_header(
      @rui.sidebar_input(
        aria_label="Filter workspace navigation",
        placeholder="Filter…",
      ),
    ),
    @rui.sidebar_content(
      @rui.sidebar_group([
        @rui.sidebar_group_label(scope~, "Workspace"),
        if interactive {
          @rui.sidebar_group_action(
            aria_label=if mobile { "Close sidebar" } else { "Collapse sidebar" },
            on_click=close_command,
            ig_sidebar_panel_icon(side),
          )
        } else {
          @html.nothing
        },
        @rui.sidebar_group_content(
          @rui.sidebar_menu([
            @rui.sidebar_menu_item([
              @rui.sidebar_menu_button(
                href="#overview",
                is_active=true,
                size=menu_size,
                [showcase_layout_icon(), @html.span("Overview")],
              ),
              if interactive {
                @rui.sidebar_menu_action(
                  show_on_hover=true,
                  aria_label=if mobile {
                    "Close sidebar"
                  } else {
                    "Collapse sidebar"
                  },
                  on_click=close_command,
                  showcase_panel_left_icon(),
                )
              } else {
                @html.nothing
              },
            ]),
            @rui.sidebar_menu_item([
              @rui.sidebar_menu_button(href="#activity", size=menu_size, [
                showcase_activity_icon(),
                @html.span("Activity"),
              ]),
              @rui.sidebar_menu_badge("6"),
            ]),
            @rui.sidebar_menu_item([
              @rui.sidebar_menu_button(href="#projects", size=menu_size, [
                showcase_folder_icon(),
                @html.span("Projects and longer workspace names"),
              ]),
              @rui.sidebar_menu_sub([
                @rui.sidebar_menu_sub_item(
                  @rui.sidebar_menu_sub_button(href="#reports", "Reports"),
                ),
                @rui.sidebar_menu_sub_item(
                  @rui.sidebar_menu_sub_button(href="#roadmap", "Roadmap"),
                ),
              ]),
            ]),
            @rui.sidebar_menu_item(
              @rui.sidebar_menu_button(
                href="#settings",
                size=menu_size,
                disabled=true,
                [showcase_settings_icon(), @html.span("Unavailable")],
              ),
            ),
          ]),
        ),
      ]),
    ),
    @rui.sidebar_separator(),
    @rui.sidebar_footer(
      @rui.sidebar_menu(
        @rui.sidebar_menu_item(
          @rui.sidebar_menu_button(
            href="#account",
            size=menu_size,
            variant=if menu_size == SidebarMenuLg {
              SidebarMenuButtonOutline
            } else {
              SidebarMenuButtonDefault
            },
            if menu_size == SidebarMenuLg {
              [
                showcase_user_icon(),
                @html.span(style=["display:grid;min-width:0;line-height:1.1"], [
                  @html.strong("Yorkin"),
                  @html.span(
                    style=[
                      "color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35",
                    ],
                    "yorkin@example.com",
                  ),
                ]),
              ]
            } else {
              [showcase_user_icon(), @html.span("Account")]
            },
          ),
        ),
      ),
    ),
  ])
}

///|
fn ig_sidebar_loading_navigation() -> @html.Html {
  @html.fragment([
    @rui.sidebar_header(
      @rui.sidebar_menu(
        @rui.sidebar_menu_item(@rui.sidebar_menu_skeleton(show_icon=true)),
      ),
    ),
    @rui.sidebar_content(
      @rui.sidebar_group([
        @rui.sidebar_group_label("Workspace"),
        @rui.sidebar_group_content(
          @rui.sidebar_menu([
            @rui.sidebar_menu_item(@rui.sidebar_menu_skeleton(show_icon=true)),
            @rui.sidebar_menu_item(@rui.sidebar_menu_skeleton(show_icon=true)),
            @rui.sidebar_menu_item(@rui.sidebar_menu_skeleton(show_icon=true)),
            @rui.sidebar_menu_item(@rui.sidebar_menu_skeleton(show_icon=true)),
          ]),
        ),
      ]),
    ),
    @rui.sidebar_separator(),
    @rui.sidebar_footer(
      @rui.sidebar_menu(
        @rui.sidebar_menu_item(@rui.sidebar_menu_skeleton(show_icon=true)),
      ),
    ),
  ])
}

///|
fn ig_sidebar_workspace_content(
  scope : @rui.SidebarScope,
  id : String,
  side : @rui.SidebarSide,
  mobile : Bool,
  interactive : Bool,
) -> @html.Html {
  @html.fragment([
    @html.div(style=[RowStyle], [
      if interactive {
        @rui.sidebar_trigger(
          scope,
          mobile~,
          controls=id,
          aria_label=if mobile {
            "Open mobile sidebar"
          } else {
            "Toggle sidebar"
          },
          ig_sidebar_panel_icon(side),
        )
      } else {
        @html.nothing
      },
      @html.strong("Workspace overview"),
    ]),
    @html.div(
      style=[IgSidebarWorkspaceBodyStyle],
      @html.p(
        style=[MutedStyle, "max-width:18rem;margin:0;text-align:center"],
        if mobile {
          "Open the mobile sheet, then close it with the overlay, Escape, or its navigation action."
        } else if interactive {
          "Use the trigger or sidebar rail; the provider owns every state change."
        } else {
          "This persistent sidebar remains visible and does not expose a collapse control."
        },
      ),
    ),
  ])
}

///|
fn ig_sidebar_variant(
  id : String,
  side : @rui.SidebarSide,
  variant : @rui.SidebarVariant,
  collapsible : @rui.SidebarCollapsible,
  default_collapsed : Bool,
  menu_size : @rui.SidebarMenuButtonSize,
  use_inset : Bool,
  mobile : Bool,
  resizable : Bool,
) -> @rabbita.Val[@html.Html] {
  @rui.sidebar_provider(
    default_collapsed~,
    style=[IgSidebarVariantFrameStyle],
    scope => {
      let interactive = collapsible != SidebarFixed
      let rail = if mobile || !interactive {
        @html.nothing
      } else if resizable {
        @rui.sidebar_rail(scope, min_width=192, max_width=352)
      } else {
        @rui.sidebar_rail(scope)
      }
      let workspace_content = ig_sidebar_workspace_content(
        scope, id, side, mobile, interactive,
      )
      let workspace = if use_inset {
        @rui.sidebar_inset(style=[IgSidebarWorkspaceStyle], workspace_content)
      } else {
        @html.div(style=[IgSidebarWorkspaceStyle], workspace_content)
      }
      @html.fragment([
        @rui.sidebar(scope, id~, side~, variant~, collapsible~, mobile~, [
          ig_sidebar_navigation(scope, side, menu_size, mobile, interactive),
          rail,
        ]),
        workspace,
      ])
    },
  )
}

///|
fn ig_sidebar_loading_variant() -> @rabbita.Val[@html.Html] {
  @rui.sidebar_provider(
    default_collapsed=false,
    style=[IgSidebarVariantFrameStyle],
    scope => {
      let id = "showcase-sidebar-loading"
      @html.fragment([
        @rui.sidebar(
          scope,
          id~,
          side=SidebarLeft,
          variant=SidebarDefault,
          collapsible=SidebarFixed,
          mobile=false,
          ig_sidebar_loading_navigation(),
        ),
        @html.div(
          style=[IgSidebarWorkspaceStyle],
          ig_sidebar_workspace_content(scope, id, SidebarLeft, false, false),
        ),
      ])
    },
  )
}

///|
fn ig_sidebar_component(
  default : @html.Html,
  fixed : @html.Html,
  icon : @html.Html,
  loading : @html.Html,
  floating : @html.Html,
  inset : @html.Html,
  right : @html.Html,
  resize : @html.Html,
  mobile : @html.Html,
) -> @html.Html {
  showcase_component_demos(
    "Sidebar",
    "Desktop and mobile compositions cover collapse modes, surface variants, side placement, and rail resizing.",
    [
      showcase_demo_section(
        "Default",
        "The default surface starts expanded and moves fully off-canvas from its trigger or rail.",
        showcase_demo_stage(
          default,
          ig_sidebar_code(IgSidebarDefaultCode),
          tall=true,
          stage_style="--rui-showcase-stage-min-height:24rem;padding:0",
        ),
      ),
      showcase_demo_section(
        "Fixed",
        "A persistent surface omits collapse controls because its visible state never changes.",
        showcase_demo_stage(
          fixed,
          ig_sidebar_code(IgSidebarFixedCode),
          tall=true,
          stage_style="--rui-showcase-stage-min-height:24rem;padding:0",
        ),
      ),
      showcase_demo_section(
        "Icon collapse",
        "Collapsed navigation keeps its icons available without leaving a second active destination.",
        showcase_demo_stage(
          icon,
          ig_sidebar_code(IgSidebarIconCode),
          tall=true,
          stage_style="--rui-showcase-stage-min-height:24rem;padding:0",
        ),
      ),
      showcase_demo_section(
        "Loading",
        "A complete persistent composition uses the public menu skeleton while navigation data is loading.",
        showcase_demo_stage(
          loading,
          ig_sidebar_code(IgSidebarLoadingCode),
          tall=true,
          stage_style="--rui-showcase-stage-min-height:24rem;padding:0",
        ),
      ),
      showcase_demo_section(
        "Floating",
        "Floating adds its own radius, border, and shadow while the stage supplies the only outer frame.",
        showcase_demo_stage(
          floating,
          ig_sidebar_code(IgSidebarFloatingCode),
          tall=true,
          stage_style="--rui-showcase-stage-min-height:24rem;padding:0",
        ),
      ),
      showcase_demo_section(
        "Inset",
        "Only this composition uses sidebar_inset for the adjacent content surface.",
        showcase_demo_stage(
          inset,
          ig_sidebar_code(IgSidebarInsetCode),
          tall=true,
          stage_style="--rui-showcase-stage-min-height:24rem;padding:0",
        ),
      ),
      showcase_demo_section(
        "Right side",
        "Right placement mirrors the shell, rail edge, and trigger icon without changing menu semantics.",
        showcase_demo_stage(
          right,
          ig_sidebar_code(IgSidebarRightCode),
          tall=true,
          stage_style="--rui-showcase-stage-min-height:24rem;padding:0",
        ),
      ),
      showcase_demo_section(
        "Resize",
        "Drag the rail between its minimum and maximum width; a click still toggles collapse.",
        showcase_demo_stage(
          resize,
          ig_sidebar_code(IgSidebarResizeCode),
          tall=true,
          stage_style="--rui-showcase-stage-min-height:24rem;padding:0",
        ),
      ),
      showcase_demo_section(
        "Mobile",
        "The explicit mobile form opens as a modal sheet and keeps desktop state independent.",
        showcase_demo_stage(
          mobile,
          ig_sidebar_code(IgSidebarMobileCode),
          tall=true,
          stage_style="--rui-showcase-stage-min-height:24rem;padding:0",
        ),
      ),
    ],
  )
}

///|
fn ig_navigation_page(selected : String) -> @rabbita.Val[@html.Html] {
  let accordion_view = @rui.accordion(
    id="showcase-accordion",
    type_=Single,
    collapsible=true,
    default_value="keyboard",
    items=[
      @rui.accordion_entry(
        value="keyboard",
        label="Keyboard interaction",
        content=@html.p(
          style=[MutedStyle, "margin:0"],
          "Tab reaches each trigger; Enter and Space toggle its panel.",
        ),
      ),
      @rui.accordion_entry(
        value="state",
        label="Owned state",
        content=@html.p(
          style=[MutedStyle, "margin:0"],
          "The black-box root owns its expanded value through Rabbita.",
        ),
      ),
      @rui.accordion_entry(
        value="markup",
        label="Native markup",
        content=@html.p(
          style=[MutedStyle, "margin:0"],
          "Details and summary preserve useful behavior without JavaScript.",
        ),
      ),
    ],
  )
  let accordion_multiple_view = @rui.accordion(
    id="showcase-accordion-multiple",
    type_=Multiple,
    default_values=["motion", "focus"],
    items=[
      @rui.accordion_entry(
        value="motion",
        label="Motion",
        content=@html.p(
          style=[MutedStyle, "margin:0"],
          "Each expanded panel animates independently.",
        ),
      ),
      @rui.accordion_entry(
        value="focus",
        label="Keyboard focus",
        content=@html.p(
          style=[MutedStyle, "margin:0"],
          "Arrow keys move between enabled triggers.",
        ),
      ),
      @rui.accordion_entry(
        value="locked",
        label="Unavailable section",
        disabled=true,
        content=@html.p("This panel cannot be opened."),
      ),
    ],
  )
  let carousel_view = @rui.carousel(
    id="showcase-carousel",
    count=3,
    loop_=true,
    orientation=CarouselHorizontal,
    aria_label="Rabbita UI highlights",
    style=[IgCarouselStyle],
    scope => {
      @html.fragment([
        @rui.carousel_items(scope~, items=[
          @html.div(style=[IgSlideStyle], "Inline styles"),
          @html.div(style=[IgSlideStyle], "Incremental state"),
          @html.div(style=[IgSlideStyle], "Native semantics"),
        ]),
        @rui.carousel_previous(scope~),
        @rui.carousel_next(scope~),
      ])
    },
  )
  let carousel_vertical_view = @rui.carousel(
    id="showcase-carousel-vertical",
    count=3,
    default_index=1,
    orientation=CarouselVertical,
    aria_label="Vertical Rabbita UI highlights",
    style=[IgVerticalCarouselStyle],
    scope => {
      @html.fragment([
        @rui.carousel_items(scope~, items=[
          @html.div(style=[IgSlideStyle, IgVerticalSlideStyle], "First slide"),
          @html.div(
            style=[IgSlideStyle, IgVerticalSlideStyle],
            "Selected slide",
          ),
          @html.div(style=[IgSlideStyle, IgVerticalSlideStyle], "Last slide"),
        ]),
        @rui.carousel_previous(scope~),
        @rui.carousel_next(scope~),
      ])
    },
  )
  let collapsible_order_view = ig_collapsible_order_view()
  let collapsible_basic_view = ig_collapsible_basic_view()
  let collapsible_settings_view = ig_collapsible_settings_view()
  let collapsible_file_tree_view = ig_collapsible_file_tree_view()
  let navigation_view = @rui.navigation_menu(
    id="showcase-navigation-menu",
    aria_label="Showcase navigation",
    scope => {
      @html.div(style=["min-height:10rem"], [
        @rui.navigation_menu_list(scope, [
          @rui.navigation_menu_item(scope, value="platform", item => {
            @html.fragment([
              @rui.navigation_menu_trigger(item, "Platform"),
              @rui.navigation_menu_indicator(item),
              @rui.navigation_menu_content(
                item,
                style=[IgNavigationContentStyle],
                [
                  @rui.navigation_menu_link(
                    href="#components",
                    active=true,
                    style=[IgNavigationLinkStyle],
                    [
                      @html.strong("Components"),
                      @html.span(style=[MutedStyle], "Black-box defaults"),
                    ],
                  ),
                  @rui.navigation_menu_link(
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
          @rui.navigation_menu_item(scope, value="resources", item => {
            @html.fragment([
              @rui.navigation_menu_trigger(item, "Resources"),
              @rui.navigation_menu_indicator(item),
              @rui.navigation_menu_content(
                item,
                style=[IgNavigationContentStyle],
                [
                  @rui.navigation_menu_link(
                    href="#api",
                    style=[IgNavigationLinkStyle],
                    [
                      @html.strong("API reference"),
                      @html.span(style=[MutedStyle], "Typed MoonBit surface"),
                    ],
                  ),
                  @rui.navigation_menu_link(
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
        @rui.navigation_menu_viewport(scope, @html.nothing),
      ])
    },
  )
  let navigation_inline_view = @rui.navigation_menu(
    id="showcase-navigation-menu-inline",
    viewport=false,
    aria_label="Inline navigation menu",
    scope => {
      @rui.navigation_menu_list(scope, [
        @rui.navigation_menu_item(scope, value="learn", item => {
          @html.fragment([
            @rui.navigation_menu_trigger(item, "Learn"),
            @rui.navigation_menu_content(
              item,
              style=[IgNavigationContentStyle],
              [
                @rui.navigation_menu_link(
                  href="#guide",
                  active=true,
                  style=[IgNavigationLinkStyle],
                  [
                    @html.strong("Guide"),
                    @html.span(style=[MutedStyle], "Active destination"),
                  ],
                ),
                @rui.navigation_menu_link(
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
        @rui.navigation_menu_item(scope, value="disabled", item => {
          @rui.navigation_menu_trigger(item, disabled=true, "Unavailable")
        }),
      ])
    },
  )
  let sidebar_default_view = ig_sidebar_variant(
    "showcase-sidebar-default",
    SidebarLeft,
    SidebarDefault,
    SidebarOffcanvas,
    false,
    SidebarMenuDefault,
    false,
    false,
    false,
  )
  let sidebar_fixed_view = ig_sidebar_variant(
    "showcase-sidebar-fixed",
    SidebarLeft,
    SidebarDefault,
    SidebarFixed,
    false,
    SidebarMenuSm,
    false,
    false,
    false,
  )
  let sidebar_icon_view = ig_sidebar_variant(
    "showcase-sidebar-icon",
    SidebarLeft,
    SidebarDefault,
    SidebarIcon,
    true,
    SidebarMenuDefault,
    false,
    false,
    false,
  )
  let sidebar_loading_view = ig_sidebar_loading_variant()
  let sidebar_floating_view = ig_sidebar_variant(
    "showcase-sidebar-floating",
    SidebarLeft,
    SidebarFloating,
    SidebarIcon,
    false,
    SidebarMenuLg,
    false,
    false,
    false,
  )
  let sidebar_inset_view = ig_sidebar_variant(
    "showcase-sidebar-inset",
    SidebarLeft,
    SidebarInset,
    SidebarOffcanvas,
    false,
    SidebarMenuDefault,
    true,
    false,
    false,
  )
  let sidebar_right_view = ig_sidebar_variant(
    "showcase-sidebar-right",
    SidebarRight,
    SidebarDefault,
    SidebarIcon,
    false,
    SidebarMenuDefault,
    false,
    false,
    false,
  )
  let sidebar_resize_view = ig_sidebar_variant(
    "showcase-sidebar-resize",
    SidebarLeft,
    SidebarDefault,
    SidebarIcon,
    false,
    SidebarMenuDefault,
    false,
    false,
    true,
  )
  let sidebar_mobile_view = ig_sidebar_variant(
    "showcase-sidebar-mobile",
    SidebarLeft,
    SidebarDefault,
    SidebarOffcanvas,
    false,
    SidebarMenuDefault,
    false,
    true,
    false,
  )
  let tabs_view = @rui.tabs(
    id="showcase-tabs",
    default_value="preview",
    orientation=TabsHorizontal,
    aria_label="Component workflow",
    items=[
      @rui.tab_entry(
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
      @rui.tab_entry(
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
      @rui.tab_entry(
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
  let tabs_vertical_view = @rui.tabs(
    id="showcase-tabs-vertical",
    default_value="general",
    orientation=TabsVertical,
    aria_label="Vertical settings tabs",
    items=[
      @rui.tab_entry(
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
      @rui.tab_entry(
        value="members",
        label="Members",
        content=@html.div(style=[IgDemoSurfaceStyle], "Member access settings"),
      ),
      @rui.tab_entry(
        value="billing",
        label="Billing",
        content=@html.div(style=[IgDemoSurfaceStyle], "Billing settings"),
      ),
    ],
  )
  let tabs_line_view = @rui.tabs(
    id="showcase-tabs-line",
    default_value="account",
    list_variant=TabsLine,
    aria_label="Account sections",
    items=[
      @rui.tab_entry(
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
      @rui.tab_entry(
        value="security",
        label="Security",
        content=@html.div(style=[IgDemoSurfaceStyle], "Security settings"),
      ),
      @rui.tab_entry(
        value="notifications",
        label="Notifications",
        content=@html.div(
          style=[IgDemoSurfaceStyle],
          "Notification preferences",
        ),
      ),
    ],
  )
  let tabs_disabled_view = @rui.tabs(
    id="showcase-tabs-disabled",
    default_value="home",
    aria_label="Disabled tab example",
    items=[
      @rui.tab_entry(
        value="home",
        label="Home",
        content=@html.div(style=[IgDemoSurfaceStyle], "Home content"),
      ),
      @rui.tab_entry(
        value="disabled",
        label="Disabled",
        disabled=true,
        content=@html.div(style=[IgDemoSurfaceStyle], "Unavailable"),
      ),
    ],
  )
  let tabs_icons_view = @rui.tabs(
    id="showcase-tabs-icons",
    default_value="preview",
    aria_label="View mode",
    items=[
      @rui.tab_entry(
        value="preview",
        label="Preview",
        icon=showcase_layout_icon(),
        content=@html.div(style=[IgDemoSurfaceStyle], "Preview content"),
      ),
      @rui.tab_entry(
        value="code",
        label="Code",
        icon=showcase_code_icon(),
        content=@html.div(style=[IgDemoSurfaceStyle], "Code content"),
      ),
    ],
  )
  let accordion_component = if selected == "" || selected == "accordion" {
    accordion_view.view2(accordion_multiple_view, ig_accordion_component)
  } else {
    showcase_static_page(@html.nothing)
  }
  let carousel_component = if selected == "" || selected == "carousel" {
    carousel_view.view2(carousel_vertical_view, ig_carousel_component)
  } else {
    showcase_static_page(@html.nothing)
  }
  let collapsible_component = if selected == "" || selected == "collapsible" {
    collapsible_order_view.view4(
      collapsible_basic_view, collapsible_settings_view, collapsible_file_tree_view,
      ig_collapsible_component,
    )
  } else {
    showcase_static_page(@html.nothing)
  }
  let navigation_component = if selected == "" || selected == "navigation-menu" {
    navigation_view.view2(navigation_inline_view, ig_navigation_menu_component)
  } else {
    showcase_static_page(@html.nothing)
  }
  let sidebar_component = if selected == "" || selected == "sidebar" {
    sidebar_default_view.view9(
      sidebar_fixed_view, sidebar_icon_view, sidebar_loading_view, sidebar_floating_view,
      sidebar_inset_view, sidebar_right_view, sidebar_resize_view, sidebar_mobile_view,
      ig_sidebar_component,
    )
  } else {
    showcase_static_page(@html.nothing)
  }
  let tabs_component = if selected == "" || selected == "tabs" {
    tabs_view.view5(
      tabs_line_view, tabs_vertical_view, tabs_disabled_view, tabs_icons_view, ig_tabs_component,
    )
  } else {
    showcase_static_page(@html.nothing)
  }
  accordion_component.view6(
    carousel_component,
    collapsible_component,
    navigation_component,
    sidebar_component,
    tabs_component,
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
          accordion_html,
          collapsible_html,
          tabs_html,
          if selected == "" || selected == "breadcrumb" {
            ig_breadcrumb_demo()
          } else {
            @html.nothing
          },
          if selected == "" || selected == "pagination" {
            ig_pagination_demo()
          } else {
            @html.nothing
          },
          carousel_html,
          navigation_html,
          sidebar_html,
        ],
      )
    },
  )
}

///|
fn ig_dialog_variant(
  id : String,
  modal : Bool,
  trigger_variant : @rui.ButtonVariant,
  trigger_label : String,
) -> @rabbita.Val[@html.Html] {
  @rabbita.Val::constant(
    @html.fragment([
      @rui.button(
        variant=trigger_variant,
        on_click=@dialog.show(id, modal~),
        trigger_label,
      ),
      @rui.dialog(
        id~,
        attrs=@html.Attrs::build()
          .aria_labelledby(id + "-title")
          .aria_describedby(id + "-description"),
        [
          @rui.dialog_header([
            @rui.dialog_title(id=id + "-title", trigger_label),
            @rui.dialog_description(
              id=id + "-description",
              if modal {
                "Focus stays inside this modal surface until it closes."
              } else {
                "This non-modal surface leaves the surrounding page available."
              },
            ),
          ]),
          @html.form(method_="dialog", [
            @html.div(style=[StackStyle], [
              @rui.label(for_=id + "-name", "Display name"),
              @rui.input(id=id + "-name", value="Rabbita team"),
            ]),
            @rui.dialog_footer(@rui.button(type_="submit", "Save changes")),
          ]),
        ],
      ),
    ]),
  )
}

///|
fn ig_drawer_variant(
  id : String,
  direction : @rui.DrawerDirection,
  trigger_label : String,
) -> @rabbita.Val[@html.Html] {
  @rui.drawer(id~, scope => {
    @html.fragment([
      @rui.drawer_trigger(scope, variant=Outline, trigger_label),
      @rui.drawer_portal([
        @rui.drawer_content(
          scope,
          direction~,
          show_handle=true,
          show_close=true,
          [
            @rui.drawer_header([
              @rui.drawer_title(scope, trigger_label),
              @rui.drawer_description(
                scope, "The direction controls placement, motion, and handle orientation.",
              ),
            ]),
            @html.div(style=[IgDemoSurfaceStyle], "All checks passed"),
            @rui.drawer_footer(@rui.drawer_close(scope, "Close")),
          ],
        ),
      ]),
    ])
  })
}

///|
fn ig_sheet_variant(
  id : String,
  side : @rui.SheetSide,
  trigger_label : String,
) -> @html.Html {
  @html.fragment([
    @rui.button(variant=Outline, on_click=@dialog.show(id), trigger_label),
    @rui.sheet(
      id~,
      side~,
      attrs=@html.Attrs::build()
        .aria_labelledby(id + "-title")
        .aria_describedby(id + "-description"),
      [
        @rui.sheet_header([
          @rui.sheet_title(id=id + "-title", trigger_label),
          @rui.sheet_description(
            id=id + "-description",
            "Placement changes while focus and dismissal behavior stay consistent.",
          ),
        ]),
        @html.form(method_="dialog", [
          @html.div(style=[StackStyle], [
            @rui.label(for_=id + "-email", "Notification email"),
            @rui.input(id=id + "-email", value="team@example.com"),
          ]),
          @rui.sheet_footer(@rui.button(type_="submit", "Save settings")),
        ]),
      ],
    ),
  ])
}

///|
fn ig_popover_variant(
  id : String,
  side : @rui.PopupSide,
  align : @rui.PopupAlign,
  trigger_label : String,
) -> @rabbita.Val[@html.Html] {
  let title_id = id + "-title"
  let description_id = id + "-description"
  @rui.popover(
    id~,
    side~,
    align~,
    title_id~,
    description_id~,
    trigger_variant=Outline,
    trigger_label,
    @html.div(style=[StackStyle, "gap:0.75rem"], [
      @rui.popover_header([
        @rui.popover_title(id=title_id, trigger_label),
        @rui.popover_description(
          id=description_id,
          "Anchored content stays labelled at this placement.",
        ),
      ]),
      @rui.input(
        value="320 px",
        attrs=@html.Attrs::build().aria_label("Preferred width"),
      ),
      @rui.popover_close_button(target_id=id, size=Sm, "Apply"),
    ]),
  )
}

///|
fn ig_hover_card_variant(
  id : String,
  side : @rui.PopupSide,
  align : @rui.PopupAlign,
  trigger_label : String,
) -> @rabbita.Val[@html.Html] {
  @rui.hover_card(
    id~,
    href="#rabbita-profile",
    open_delay=120,
    close_delay=80,
    side~,
    align~,
    trigger_variant=Link,
    trigger_label,
    @html.div(style=[StackStyle, "gap:0.5rem"], [
      @html.strong("Rabbita UI"),
      @html.p(
        style=[MutedStyle, "margin:0"],
        "Native MoonBit components with incremental state.",
      ),
      @html.div(style=[RowStyle], [
        @rui.badge(variant=Secondary, "Vega"),
        @rui.badge(variant=Outline, "Inline"),
      ]),
    ]),
  )
}

///|
fn ig_tooltip_variant(
  id : String,
  side : @rui.PopupSide,
  align : @rui.PopupAlign,
  size : @rui.ButtonSize,
  label : String,
) -> @rabbita.Val[@html.Html] {
  @rui.tooltip(
    id~,
    delay=100,
    side~,
    align~,
    show_arrow=true,
    trigger_variant=Outline,
    trigger_size=size,
    trigger_attrs=@html.Attrs::build().aria_label(label),
    showcase_circle_help_icon(),
    label,
  )
}

///|
fn ig_alert_dialog_component(
  default_html : @html.Html,
  destructive_html : @html.Html,
) -> @html.Html {
  showcase_component_demos(
    "Alert Dialog",
    "Default and destructive decisions require an explicit action.",
    [
      showcase_demo_section(
        "Default",
        "A reversible archive decision requires an explicit cancel or action.",
        showcase_demo_stage(default_html, IgAlertDialogDefaultCode),
      ),
      showcase_demo_section(
        "Destructive",
        "A permanent action adds destructive treatment and warning media.",
        showcase_demo_stage(destructive_html, IgAlertDialogDestructiveCode),
      ),
    ],
  )
}

///|
fn ig_dialog_component(
  modal_html : @html.Html,
  nonmodal_html : @html.Html,
) -> @html.Html {
  showcase_component_demos(
    "Dialog",
    "Modal and non-modal top-layer focus behavior.",
    [
      showcase_demo_section(
        "Modal",
        "The modal surface contains focus until it closes.",
        showcase_demo_stage(modal_html, ig_dialog_code(IgDialogModalCallCode)),
      ),
      showcase_demo_section(
        "Non-modal",
        "The non-modal surface leaves the surrounding page available.",
        showcase_demo_stage(
          nonmodal_html,
          ig_dialog_code(IgDialogNonModalCallCode),
        ),
      ),
    ],
  )
}

///|
fn ig_drawer_component(
  top_html : @html.Html,
  right_html : @html.Html,
  bottom_html : @html.Html,
  left_html : @html.Html,
) -> @html.Html {
  showcase_component_demos(
    "Drawer",
    "Placement controls motion, edge geometry, and handle orientation.",
    [
      showcase_demo_section(
        "Top",
        "A horizontal handle accompanies motion from the top edge.",
        showcase_demo_stage(top_html, ig_drawer_code(IgDrawerTopCallCode)),
      ),
      showcase_demo_section(
        "Right",
        "A vertical handle accompanies motion from the right edge.",
        showcase_demo_stage(right_html, ig_drawer_code(IgDrawerRightCallCode)),
      ),
      showcase_demo_section(
        "Bottom",
        "A horizontal handle accompanies motion from the bottom edge.",
        showcase_demo_stage(bottom_html, ig_drawer_code(IgDrawerBottomCallCode)),
      ),
      showcase_demo_section(
        "Left",
        "A vertical handle accompanies motion from the left edge.",
        showcase_demo_stage(left_html, ig_drawer_code(IgDrawerLeftCallCode)),
      ),
    ],
  )
}

///|
fn ig_command_component(
  inline_html : @html.Html,
  dialog_html : @html.Html,
) -> @html.Html {
  showcase_component_demos(
    "Command",
    "Inline and dialog listboxes share active-descendant navigation.",
    [
      showcase_demo_section(
        "Inline",
        "An inline filterable list exposes groups, shortcuts, and empty state.",
        showcase_demo_stage(inline_html, IgCommandInlineCode, tall=true),
      ),
      showcase_demo_section(
        "Dialog",
        "A trigger opens the same command interaction inside a modal surface.",
        showcase_demo_stage(dialog_html, IgCommandDialogCode),
      ),
    ],
  )
}

///|
fn ig_popover_component(
  bottom_html : @html.Html,
  right_html : @html.Html,
) -> @html.Html {
  showcase_component_demos(
    "Popover",
    "Anchored forms preserve labels, focus restoration, and close actions.",
    [
      showcase_demo_section(
        "Bottom start",
        "The labelled form aligns to the start of a bottom anchor.",
        showcase_demo_stage(
          bottom_html,
          ig_popover_code(IgPopoverBottomStartCallCode),
        ),
      ),
      showcase_demo_section(
        "Right center",
        "The same form aligns to the center of a right-side anchor.",
        showcase_demo_stage(
          right_html,
          ig_popover_code(IgPopoverRightCenterCallCode),
        ),
      ),
    ],
  )
}

///|
fn ig_hover_card_component(
  top_html : @html.Html,
  left_html : @html.Html,
) -> @html.Html {
  showcase_component_demos(
    "Hover Card",
    "Pointer and keyboard entry share delays while content remains hoverable.",
    [
      showcase_demo_section(
        "Top center",
        "A keyboard-reachable preview opens above the trigger.",
        showcase_demo_stage(
          top_html,
          ig_hover_card_code(IgHoverCardTopCenterCallCode),
        ),
      ),
      showcase_demo_section(
        "Left end",
        "Hoverable content aligns to the end of a left-side trigger.",
        showcase_demo_stage(
          left_html,
          ig_hover_card_code(IgHoverCardLeftEndCallCode),
        ),
      ),
    ],
  )
}

///|
fn ig_tooltip_component(
  top_html : @html.Html,
  right_html : @html.Html,
  bottom_html : @html.Html,
  left_html : @html.Html,
) -> @html.Html {
  showcase_component_demos(
    "Tooltip",
    "Placement and trigger size variants align arrows to real icon buttons.",
    [
      showcase_demo_section(
        "Top start",
        "A small icon trigger places its tooltip above and start-aligned.",
        showcase_demo_stage(
          top_html,
          ig_tooltip_code(IgTooltipTopStartCallCode),
        ),
      ),
      showcase_demo_section(
        "Right center",
        "A default icon trigger places its tooltip at the right center.",
        showcase_demo_stage(
          right_html,
          ig_tooltip_code(IgTooltipRightCenterCallCode),
        ),
      ),
      showcase_demo_section(
        "Bottom end",
        "A large icon trigger places its tooltip below and end-aligned.",
        showcase_demo_stage(
          bottom_html,
          ig_tooltip_code(IgTooltipBottomEndCallCode),
        ),
      ),
      showcase_demo_section(
        "Left center",
        "A default icon trigger places its tooltip at the left center.",
        showcase_demo_stage(
          left_html,
          ig_tooltip_code(IgTooltipLeftCenterCallCode),
        ),
      ),
    ],
  )
}

///|
fn ig_sheet_component(
  top_html : @html.Html,
  right_html : @html.Html,
  bottom_html : @html.Html,
  left_html : @html.Html,
) -> @html.Html {
  showcase_component_demos(
    "Sheet",
    "Every side keeps the same labelled content and dismissal behavior.",
    [
      showcase_demo_section(
        "Top",
        "The modal sheet enters from the top edge.",
        showcase_demo_stage(top_html, ig_sheet_code(IgSheetTopCallCode)),
      ),
      showcase_demo_section(
        "Right",
        "The modal sheet enters from the right edge.",
        showcase_demo_stage(right_html, ig_sheet_code(IgSheetRightCallCode)),
      ),
      showcase_demo_section(
        "Bottom",
        "The modal sheet enters from the bottom edge.",
        showcase_demo_stage(bottom_html, ig_sheet_code(IgSheetBottomCallCode)),
      ),
      showcase_demo_section(
        "Left",
        "The modal sheet enters from the left edge.",
        showcase_demo_stage(left_html, ig_sheet_code(IgSheetLeftCallCode)),
      ),
    ],
  )
}

///|
fn ig_overlay_page(selected : String) -> @rabbita.Val[@html.Html] {
  let alert_dialog_view = @html.fragment([
    @rui.button(
      variant=Destructive,
      on_click=@dialog.show("showcase-alert-dialog"),
      "Delete snapshot",
    ),
    @rui.alert_dialog(
      id="showcase-alert-dialog",
      attrs=@html.Attrs::build()
        .aria_labelledby("showcase-alert-dialog-title")
        .aria_describedby("showcase-alert-dialog-description"),
      [
        @rui.alert_dialog_header([
          @rui.alert_dialog_media(showcase_alert_triangle_icon()),
          @rui.alert_dialog_title(
            id="showcase-alert-dialog-title",
            "Delete this snapshot?",
          ),
          @rui.alert_dialog_description(
            id="showcase-alert-dialog-description",
            "This removes the saved state permanently.",
          ),
        ]),
        @html.form(
          method_="dialog",
          @rui.alert_dialog_footer([
            @rui.alert_dialog_cancel("Cancel"),
            @rui.alert_dialog_action("Delete"),
          ]),
        ),
      ],
    ),
  ])
  let alert_dialog_default_view = @html.fragment([
    @rui.button(
      variant=Outline,
      on_click=@dialog.show("showcase-alert-dialog-default"),
      "Archive project",
    ),
    @rui.alert_dialog(
      id="showcase-alert-dialog-default",
      attrs=@html.Attrs::build()
        .aria_labelledby("showcase-alert-dialog-default-title")
        .aria_describedby("showcase-alert-dialog-default-description"),
      [
        @rui.alert_dialog_header([
          @rui.alert_dialog_title(
            id="showcase-alert-dialog-default-title",
            "Archive this project?",
          ),
          @rui.alert_dialog_description(
            id="showcase-alert-dialog-default-description",
            "You can restore an archived project later from workspace settings.",
          ),
        ]),
        @html.form(
          method_="dialog",
          @rui.alert_dialog_footer([
            @rui.alert_dialog_cancel("Cancel"),
            @rui.alert_dialog_action("Archive"),
          ]),
        ),
      ],
    ),
  ])
  let command_view = @rui.command(
    id="showcase-command",
    style=[IgCommandStyle],
    scope => {
      @html.fragment([
        @rui.command_input(scope~, placeholder="Search actions…"),
        @rui.command_list(scope~, [
          @rui.command_empty(scope~, "No matching actions."),
          @rui.command_group(scope~, heading="Workspace", [
            @rui.command_item(
              scope~,
              value="Open dashboard",
              keywords=["home"],
              [@html.span("Open dashboard"), @rui.command_shortcut("⌘D")],
            ),
            @rui.command_item(
              scope~,
              value="Create project",
              keywords=["new"],
              [@html.span("Create project"), @rui.command_shortcut("⌘N")],
            ),
            @rui.command_separator(),
            @rui.command_item(
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
  let command_dialog_view = @rui.command_dialog(
    id="showcase-command-dialog",
    aria_label="Command palette",
    trigger=scope => {
      @rui.command_dialog_trigger(scope~, variant=Outline, "Open palette")
    },
    scope => {
      @html.fragment([
        @rui.command_input(scope~, placeholder="Type a command…"),
        @rui.command_list(scope~, [
          @rui.command_empty(scope~, "No matching commands."),
          @rui.command_group(scope~, heading="Navigation", [
            @rui.command_item(scope~, value="Go to overview", "Go to overview"),
            @rui.command_item(scope~, value="Open settings", "Open settings"),
            @rui.command_item(
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
  let context_menu_actions_view = @rui.context_menu(
    id="showcase-context-menu-actions",
    scope => {
      @html.fragment([
        @rui.context_menu_trigger(
          scope,
          style=[IgContextTargetStyle],
          "Right-click for canvas actions",
        ),
        @rui.context_menu_portal([
          @rui.context_menu_content(scope, aria_label="Canvas actions", [
            @rui.context_menu_group(aria_label="Canvas", [
              @rui.context_menu_label("Canvas"),
              @rui.context_menu_item(scope, [
                showcase_copy_icon(),
                @html.span("Duplicate"),
                @rui.context_menu_shortcut("⌘D"),
              ]),
              @rui.context_menu_item(scope, [
                showcase_settings_icon(),
                @html.span("Rename"),
              ]),
              @rui.context_menu_item(scope, [
                showcase_file_icon(),
                @html.span("Export"),
                @rui.context_menu_shortcut("⇧⌘E"),
              ]),
              @rui.context_menu_item(scope, disabled=true, [
                showcase_archive_icon(),
                @html.span("Paste"),
              ]),
            ]),
          ]),
        ]),
      ])
    },
  )
  let context_menu_submenu_view = @rui.context_menu(
    id="showcase-context-menu-submenu",
    scope => {
      @html.fragment([
        @rui.context_menu_trigger(
          scope,
          style=[IgContextTargetStyle],
          "Right-click for project options",
        ),
        @rui.context_menu_portal([
          @rui.context_menu_content(scope, aria_label="Project options", [
            @rui.context_menu_item(scope, [
              showcase_settings_icon(),
              @html.span("Project settings"),
            ]),
            @rui.context_menu_sub(scope, value="move", sub => {
              @html.fragment([
                @rui.context_menu_sub_trigger(sub, [
                  showcase_archive_icon(),
                  @html.span("Move to"),
                ]),
                @rui.context_menu_sub_content(sub, [
                  @rui.context_menu_group(aria_label="Destination", [
                    @rui.context_menu_label("Destination"),
                    @rui.context_menu_item(scope, [
                      showcase_layout_icon(),
                      @html.span("Design system"),
                    ]),
                    @rui.context_menu_item(scope, [
                      showcase_activity_icon(),
                      @html.span("Experiments"),
                    ]),
                  ]),
                ]),
              ])
            }),
            @rui.context_menu_separator(),
            @rui.context_menu_item(scope, destructive=true, [
              showcase_close_icon(),
              @html.span("Delete project"),
            ]),
          ]),
        ]),
      ])
    },
  )
  let context_menu_checkbox_view = @rui.context_menu(
    id="showcase-context-menu-checkbox",
    default_checked_values=["grid", "activity"],
    scope => {
      @html.fragment([
        @rui.context_menu_trigger(
          scope,
          style=[IgContextTargetStyle],
          "Right-click for visibility controls",
        ),
        @rui.context_menu_portal([
          @rui.context_menu_content(scope, aria_label="Visibility controls", [
            @rui.context_menu_group(aria_label="Visibility", [
              @rui.context_menu_label("Visibility"),
              @rui.context_menu_checkbox_item(scope, value="grid", [
                showcase_layout_icon(),
                @html.span("Show grid"),
              ]),
              @rui.context_menu_checkbox_item(scope, value="sidebar", [
                showcase_panel_left_icon(),
                @html.span("Show sidebar"),
              ]),
              @rui.context_menu_checkbox_item(scope, value="activity", [
                showcase_activity_icon(),
                @html.span("Show activity"),
              ]),
            ]),
          ]),
        ]),
      ])
    },
  )
  let context_menu_radio_view = @rui.context_menu(
    id="showcase-context-menu-radio",
    default_radio_values=[("layout", "canvas")],
    scope => {
      @html.fragment([
        @rui.context_menu_trigger(
          scope,
          style=[IgContextTargetStyle],
          "Right-click for layout controls",
        ),
        @rui.context_menu_portal([
          @rui.context_menu_content(scope, aria_label="Layout controls", [
            @rui.context_menu_group(aria_label="Layout", [
              @rui.context_menu_label("Layout"),
              @rui.context_menu_radio_group(scope, value="layout", radio => {
                @html.fragment([
                  @rui.context_menu_radio_item(radio, value="canvas", [
                    showcase_layout_icon(),
                    @html.span("Canvas"),
                  ]),
                  @rui.context_menu_radio_item(radio, value="editor", [
                    showcase_file_icon(),
                    @html.span("Editor"),
                  ]),
                  @rui.context_menu_radio_item(radio, value="focus", [
                    showcase_activity_icon(),
                    @html.span("Focus"),
                  ]),
                ])
              }),
            ]),
          ]),
        ]),
      ])
    },
  )
  let dialog_modal_view = ig_dialog_variant(
    "showcase-dialog-modal",
    true,
    Outline,
    "Edit profile",
  )
  let dialog_nonmodal_view = ig_dialog_variant(
    "showcase-dialog-nonmodal",
    false,
    Secondary,
    "Open non-modal",
  )
  let drawer_top_view = ig_drawer_variant(
    "showcase-drawer-top",
    DrawerTop,
    "Open top drawer",
  )
  let drawer_right_view = ig_drawer_variant(
    "showcase-drawer-right",
    DrawerRight,
    "Open right drawer",
  )
  let drawer_bottom_view = ig_drawer_variant(
    "showcase-drawer-bottom",
    DrawerBottom,
    "Open bottom drawer",
  )
  let drawer_left_view = ig_drawer_variant(
    "showcase-drawer-left",
    DrawerLeft,
    "Open left drawer",
  )
  let dropdown_basic_view = @rui.dropdown_menu(
    id="showcase-dropdown-menu-basic",
    scope => {
      @html.fragment([
        @rui.dropdown_menu_trigger(scope, variant=Outline, "Workspace menu"),
        @rui.dropdown_menu_portal([
          @rui.dropdown_menu_content(scope, side=Bottom, align=Start, [
            @rui.dropdown_menu_group(aria_label="Workspace", [
              @rui.dropdown_menu_label("Workspace"),
              @rui.dropdown_menu_item(scope, [
                @html.span("New tab"),
                @rui.dropdown_menu_shortcut("⌘T"),
              ]),
              @rui.dropdown_menu_item(scope, "Invite member"),
              @rui.dropdown_menu_item(scope, "Move workspace"),
              @rui.dropdown_menu_item(
                scope,
                disabled=true,
                "Duplicate workspace",
              ),
            ]),
          ]),
        ]),
      ])
    },
  )
  let dropdown_icons_view = @rui.dropdown_menu(
    id="showcase-dropdown-menu-icons",
    scope => {
      @html.fragment([
        @rui.dropdown_menu_trigger(scope, variant=Outline, "Account"),
        @rui.dropdown_menu_portal([
          @rui.dropdown_menu_content(
            scope,
            side=Bottom,
            align=Start,
            style=["min-width:12rem"],
            [
              @rui.dropdown_menu_item(scope, [
                showcase_user_icon(),
                @html.span("Profile"),
              ]),
              @rui.dropdown_menu_item(scope, [
                showcase_credit_card_icon(),
                @html.span("Billing"),
              ]),
              @rui.dropdown_menu_item(scope, [
                showcase_settings_icon(),
                @html.span("Settings"),
              ]),
              @rui.dropdown_menu_separator(),
              @rui.dropdown_menu_item(scope, destructive=true, [
                showcase_log_out_icon(),
                @html.span("Log out"),
              ]),
            ],
          ),
        ]),
      ])
    },
  )
  let dropdown_checkbox_view = @rui.dropdown_menu(
    id="showcase-dropdown-menu-checkbox",
    default_checked_values=["email", "push"],
    scope => {
      @html.fragment([
        @rui.dropdown_menu_trigger(scope, variant=Outline, "Notifications"),
        @rui.dropdown_menu_portal([
          @rui.dropdown_menu_content(scope, style=["min-width:14rem"], [
            @rui.dropdown_menu_group(aria_label="Notifications", [
              @rui.dropdown_menu_label("Notifications"),
              @rui.dropdown_menu_checkbox_item(scope, value="email", [
                showcase_mail_icon(),
                @html.span("Email"),
              ]),
              @rui.dropdown_menu_checkbox_item(scope, value="sms", [
                showcase_message_square_icon(),
                @html.span("SMS"),
              ]),
              @rui.dropdown_menu_checkbox_item(scope, value="push", [
                showcase_bell_icon(),
                @html.span("Push notifications"),
              ]),
            ]),
          ]),
        ]),
      ])
    },
  )
  let dropdown_radio_view = @rui.dropdown_menu(
    id="showcase-dropdown-menu-radio",
    default_radio_values=[("payment", "card")],
    scope => {
      @html.fragment([
        @rui.dropdown_menu_trigger(scope, variant=Outline, "Payment method"),
        @rui.dropdown_menu_portal([
          @rui.dropdown_menu_content(scope, style=["min-width:14rem"], [
            @rui.dropdown_menu_group(aria_label="Payment method", [
              @rui.dropdown_menu_label("Payment method"),
              @rui.dropdown_menu_radio_group(scope, value="payment", radio => {
                @html.fragment([
                  @rui.dropdown_menu_radio_item(radio, value="card", [
                    showcase_credit_card_icon(),
                    @html.span("Credit card"),
                  ]),
                  @rui.dropdown_menu_radio_item(radio, value="wallet", [
                    showcase_wallet_icon(),
                    @html.span("PayPal"),
                  ]),
                  @rui.dropdown_menu_radio_item(radio, value="bank", [
                    showcase_building_icon(),
                    @html.span("Bank transfer"),
                  ]),
                ])
              }),
            ]),
          ]),
        ]),
      ])
    },
  )
  let dropdown_submenu_view = @rui.dropdown_menu(
    id="showcase-dropdown-menu-submenu",
    scope => {
      @html.fragment([
        @rui.dropdown_menu_trigger(
          scope,
          variant=Secondary,
          size=Sm,
          "Top-end menu",
        ),
        @rui.dropdown_menu_portal([
          @rui.dropdown_menu_content(
            scope,
            side=Top,
            align=End,
            style=["min-width:12rem"],
            [
              @rui.dropdown_menu_item(scope, [
                @html.span("Open workspace"),
                @rui.dropdown_menu_shortcut("⌘O"),
              ]),
              @rui.dropdown_menu_sub(scope, value="share", sub => {
                @html.fragment([
                  @rui.dropdown_menu_sub_trigger(sub, "Share"),
                  @rui.dropdown_menu_sub_content(sub, [
                    @rui.dropdown_menu_group(aria_label="Share workspace", [
                      @rui.dropdown_menu_label("Share workspace"),
                      @rui.dropdown_menu_item(scope, "Copy link"),
                      @rui.dropdown_menu_item(scope, "Invite people"),
                    ]),
                  ]),
                ])
              }),
              @rui.dropdown_menu_item(scope, disabled=true, "Unavailable"),
            ],
          ),
        ]),
      ])
    },
  )
  let dropdown_multilevel_view = @rui.dropdown_menu(
    id="showcase-dropdown-menu-multilevel",
    scope => {
      @html.fragment([
        @rui.dropdown_menu_trigger(scope, variant=Outline, "Organize file"),
        @rui.dropdown_menu_portal([
          @rui.dropdown_menu_content(scope, style=["min-width:13rem"], [
            @rui.dropdown_menu_item(scope, [
              showcase_file_icon(),
              @html.span("Rename"),
            ]),
            @rui.dropdown_menu_sub(scope, value="move", destination => {
              @html.fragment([
                @rui.dropdown_menu_sub_trigger(destination, [
                  showcase_folder_icon(),
                  @html.span("Move to"),
                ]),
                @rui.dropdown_menu_sub_content(
                  destination,
                  style=["min-width:12rem"],
                  [
                    @rui.dropdown_menu_label("Destination"),
                    @rui.dropdown_menu_item(scope, [
                      showcase_folder_icon(),
                      @html.span("Inbox"),
                    ]),
                    @rui.dropdown_menu_sub(scope, value="projects", project => {
                      @html.fragment([
                        @rui.dropdown_menu_sub_trigger(project, [
                          showcase_folder_open_icon(),
                          @html.span("Projects"),
                        ]),
                        @rui.dropdown_menu_sub_content(
                          project,
                          style=["min-width:13rem"],
                          [
                            @rui.dropdown_menu_group(
                              aria_label="Project destination",
                              [
                                @rui.dropdown_menu_label("Project destination"),
                                @rui.dropdown_menu_item(scope, [
                                  showcase_layout_icon(),
                                  @html.span("Design system"),
                                ]),
                                @rui.dropdown_menu_item(scope, [
                                  showcase_activity_icon(),
                                  @html.span("Experiments"),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      ])
                    }),
                  ],
                ),
              ])
            }),
            @rui.dropdown_menu_separator(),
            @rui.dropdown_menu_item(scope, destructive=true, [
              showcase_archive_icon(),
              @html.span("Archive"),
            ]),
          ]),
        ]),
      ])
    },
  )
  let alert_dialog_component = if selected == "" || selected == "alert-dialog" {
    showcase_static_page(
      ig_alert_dialog_component(alert_dialog_default_view, alert_dialog_view),
    )
  } else {
    showcase_static_page(@html.nothing)
  }
  let command_component = if selected == "" || selected == "command" {
    command_view.view2(command_dialog_view, ig_command_component)
  } else {
    showcase_static_page(@html.nothing)
  }
  let dialog_component = if selected == "" || selected == "dialog" {
    dialog_modal_view.view2(dialog_nonmodal_view, ig_dialog_component)
  } else {
    showcase_static_page(@html.nothing)
  }
  let drawer_component = if selected == "" || selected == "drawer" {
    drawer_top_view.view4(
      drawer_right_view, drawer_bottom_view, drawer_left_view, ig_drawer_component,
    )
  } else {
    showcase_static_page(@html.nothing)
  }
  let context_menu_component = if selected == "" || selected == "context-menu" {
    context_menu_actions_view.view4(
      context_menu_submenu_view,
      context_menu_checkbox_view,
      context_menu_radio_view,
      (actions_html, submenu_html, checkbox_html, radio_html) => {
        showcase_component_demos(
          "Context Menu",
          "Actions, nested commands, and selection controls use independent right-click surfaces.",
          [
            showcase_demo_section(
              "Actions & shortcuts",
              "Grouped canvas commands include shortcuts and a disabled action.",
              showcase_demo_stage(
                actions_html,
                ig_menu_code(
                  IgContextMenuActionsIconsCode,
                  IgContextMenuActionsCode,
                ),
              ),
            ),
            showcase_demo_section(
              "Submenu & destructive action",
              "Leading icons continue through nested destinations and the destructive row.",
              showcase_demo_stage(
                submenu_html,
                ig_menu_code(
                  IgContextMenuSubmenuIconsCode,
                  IgContextMenuSubmenuCode,
                ),
              ),
            ),
            showcase_demo_section(
              "Checkbox items",
              "Visibility choices combine leading icons with trailing checkmarks.",
              showcase_demo_stage(
                checkbox_html,
                ig_menu_code(
                  IgContextMenuCheckboxIconsCode,
                  IgContextMenuCheckboxCode,
                ),
              ),
            ),
            showcase_demo_section(
              "Radio group",
              "One layout choice remains active within a labelled radio group.",
              showcase_demo_stage(
                radio_html,
                ig_menu_code(
                  IgContextMenuRadioIconsCode,
                  IgContextMenuRadioCode,
                ),
              ),
            ),
          ],
        )
      },
    )
  } else {
    showcase_static_page(@html.nothing)
  }
  let first_row = alert_dialog_component.view5(
    command_component,
    context_menu_component,
    dialog_component,
    drawer_component,
    (
      alert_dialog_html,
      command_html,
      context_menu_html,
      dialog_html,
      drawer_html,
    ) => {
      @html.fragment([
        alert_dialog_html, dialog_html, drawer_html, context_menu_html, command_html,
      ])
    },
  )
  let hover_card_top_view = ig_hover_card_variant(
    "showcase-hover-card-top",
    Top,
    Center,
    "Top-center preview",
  )
  let hover_card_left_view = ig_hover_card_variant(
    "showcase-hover-card-left",
    Left,
    End,
    "Left-end preview",
  )
  let menubar_commands_view = @rui.menubar(id="showcase-menubar-commands", scope => {
    @html.fragment([
      @rui.menubar_menu(scope, value="file", menu => {
        @html.fragment([
          @rui.menubar_trigger(menu, "File"),
          @rui.menubar_portal([
            @rui.menubar_content(menu, [
              @rui.menubar_group(aria_label="Project commands", [
                @rui.menubar_label("Project"),
                @rui.menubar_item(menu, [
                  showcase_plus_icon(),
                  @html.span("New project"),
                  @rui.menubar_shortcut("⌘N"),
                ]),
                @rui.menubar_item(menu, [
                  showcase_file_icon(),
                  @html.span("Open…"),
                  @rui.menubar_shortcut("⌘O"),
                ]),
                @rui.menubar_item(menu, disabled=true, [
                  showcase_archive_icon(),
                  @html.span("Import"),
                ]),
              ]),
            ]),
          ]),
        ])
      }),
      @rui.menubar_menu(scope, value="help", menu => {
        @html.fragment([
          @rui.menubar_trigger(menu, "Help"),
          @rui.menubar_portal([
            @rui.menubar_content(menu, [
              @rui.menubar_group(aria_label="Help", [
                @rui.menubar_label("Help"),
                @rui.menubar_item(menu, [
                  showcase_circle_help_icon(),
                  @html.span("Keyboard shortcuts"),
                  @rui.menubar_shortcut("?"),
                ]),
              ]),
            ]),
          ]),
        ])
      }),
    ])
  })
  let menubar_submenu_view = @rui.menubar(id="showcase-menubar-submenu", scope => {
    @html.fragment([
      @rui.menubar_menu(scope, value="project", menu => {
        @html.fragment([
          @rui.menubar_trigger(menu, "Project"),
          @rui.menubar_portal([
            @rui.menubar_content(menu, [
              @rui.menubar_item(menu, [
                showcase_settings_icon(),
                @html.span("Project settings"),
              ]),
              @rui.menubar_sub(menu, value="recent", sub => {
                @html.fragment([
                  @rui.menubar_sub_trigger(sub, [
                    showcase_layout_icon(),
                    @html.span("Recent projects"),
                  ]),
                  @rui.menubar_sub_content(sub, [
                    @rui.menubar_group(aria_label="Recent projects", [
                      @rui.menubar_label("Recent projects"),
                      @rui.menubar_item(menu, [
                        showcase_file_icon(),
                        @html.span("Design system"),
                      ]),
                      @rui.menubar_item(menu, [
                        showcase_activity_icon(),
                        @html.span("Experiments"),
                      ]),
                    ]),
                  ]),
                ])
              }),
              @rui.menubar_separator(),
              @rui.menubar_item(menu, destructive=true, [
                showcase_close_icon(),
                @html.span("Close project"),
              ]),
            ]),
          ]),
        ])
      }),
    ])
  })
  let menubar_checkbox_view = @rui.menubar(
    id="showcase-menubar-checkbox",
    default_checked_values=["sidebar", "activity"],
    scope => {
      @html.fragment([
        @rui.menubar_menu(scope, value="view", menu => {
          @html.fragment([
            @rui.menubar_trigger(menu, "View"),
            @rui.menubar_portal([
              @rui.menubar_content(menu, [
                @rui.menubar_group(aria_label="Panels", [
                  @rui.menubar_label("Panels"),
                  @rui.menubar_checkbox_item(menu, value="sidebar", [
                    showcase_panel_left_icon(),
                    @html.span("Sidebar"),
                  ]),
                  @rui.menubar_checkbox_item(menu, value="activity", [
                    showcase_activity_icon(),
                    @html.span("Activity bar"),
                  ]),
                  @rui.menubar_checkbox_item(menu, value="status", [
                    showcase_layout_icon(),
                    @html.span("Status bar"),
                  ]),
                ]),
              ]),
            ]),
          ])
        }),
      ])
    },
  )
  let menubar_radio_view = @rui.menubar(
    id="showcase-menubar-radio",
    default_radio_values=[("workspace", "editor")],
    scope => {
      @html.fragment([
        @rui.menubar_menu(scope, value="workspace", menu => {
          @html.fragment([
            @rui.menubar_trigger(menu, "Workspace"),
            @rui.menubar_portal([
              @rui.menubar_content(menu, [
                @rui.menubar_group(aria_label="Workspace mode", [
                  @rui.menubar_label("Workspace mode"),
                  @rui.menubar_radio_group(menu, value="workspace", radio => {
                    @html.fragment([
                      @rui.menubar_radio_item(radio, value="editor", [
                        showcase_file_icon(),
                        @html.span("Editor"),
                      ]),
                      @rui.menubar_radio_item(radio, value="canvas", [
                        showcase_layout_icon(),
                        @html.span("Canvas"),
                      ]),
                      @rui.menubar_radio_item(radio, value="focus", [
                        showcase_activity_icon(),
                        @html.span("Focus"),
                      ]),
                    ])
                  }),
                ]),
              ]),
            ]),
          ])
        }),
      ])
    },
  )
  let popover_bottom_view = ig_popover_variant(
    "showcase-popover-bottom",
    Bottom,
    Start,
    "Bottom-start popover",
  )
  let popover_right_view = ig_popover_variant(
    "showcase-popover-right",
    Right,
    Center,
    "Right-center popover",
  )
  let sheet_top_view = ig_sheet_variant(
    "showcase-sheet-top",
    SheetTop,
    "Open top sheet",
  )
  let sheet_right_view = ig_sheet_variant(
    "showcase-sheet-right",
    SheetRight,
    "Open right sheet",
  )
  let sheet_bottom_view = ig_sheet_variant(
    "showcase-sheet-bottom",
    SheetBottom,
    "Open bottom sheet",
  )
  let sheet_left_view = ig_sheet_variant(
    "showcase-sheet-left",
    SheetLeft,
    "Open left sheet",
  )
  let tooltip_top_view = ig_tooltip_variant(
    "showcase-tooltip-top",
    Top,
    Start,
    IconSm,
    "Top-start tooltip",
  )
  let tooltip_right_view = ig_tooltip_variant(
    "showcase-tooltip-right",
    Right,
    Center,
    Icon,
    "Right-center tooltip",
  )
  let tooltip_bottom_view = ig_tooltip_variant(
    "showcase-tooltip-bottom",
    Bottom,
    End,
    IconLg,
    "Bottom-end tooltip",
  )
  let tooltip_left_view = ig_tooltip_variant(
    "showcase-tooltip-left",
    Left,
    Center,
    Icon,
    "Left-center tooltip",
  )
  let dropdown_component = if selected == "" || selected == "dropdown-menu" {
    dropdown_basic_view.view6(
      dropdown_icons_view,
      dropdown_checkbox_view,
      dropdown_radio_view,
      dropdown_submenu_view,
      dropdown_multilevel_view,
      (
        basic_html,
        icons_html,
        checkbox_html,
        radio_html,
        submenu_html,
        multilevel_html,
      ) => {
        showcase_component_demos(
          "Dropdown Menu",
          "Groups, icons, selection controls, placement, and true multi-level navigation use independent menus.",
          [
            showcase_demo_section(
              "Basic groups",
              "A labelled group combines ordinary commands, shortcuts, and a disabled item.",
              showcase_demo_stage(basic_html, IgDropdownMenuBasicCode),
            ),
            showcase_demo_section(
              "Leading icons",
              "Account commands use SVG icons and a separated destructive action.",
              showcase_demo_stage(
                icons_html,
                ig_menu_code(
                  IgDropdownMenuIconsIconsCode,
                  IgDropdownMenuIconsCode,
                ),
              ),
            ),
            showcase_demo_section(
              "Checkbox items",
              "Notification choices keep SVG icons at the start and checkmarks at the end.",
              showcase_demo_stage(
                checkbox_html,
                ig_menu_code(
                  IgDropdownMenuCheckboxIconsCode,
                  IgDropdownMenuCheckboxCode,
                ),
              ),
            ),
            showcase_demo_section(
              "Radio group",
              "Payment methods keep one active value with its selection mark at the end.",
              showcase_demo_stage(
                radio_html,
                ig_menu_code(
                  IgDropdownMenuRadioIconsCode,
                  IgDropdownMenuRadioCode,
                ),
              ),
            ),
            showcase_demo_section(
              "Submenu & placement",
              "A top-end popup contains a labelled nested sharing menu.",
              showcase_demo_stage(submenu_html, IgDropdownMenuSubmenuCode),
            ),
            showcase_demo_section(
              "Multi-level submenu",
              "Move through a root menu, destination submenu, and nested project submenu.",
              showcase_demo_stage(
                multilevel_html,
                ig_menu_code(
                  IgDropdownMenuMultiLevelIconsCode,
                  IgDropdownMenuMultiLevelCode,
                ),
              ),
            ),
          ],
        )
      },
    )
  } else {
    showcase_static_page(@html.nothing)
  }
  let menubar_component = if selected == "" || selected == "menubar" {
    menubar_commands_view.view4(
      menubar_submenu_view,
      menubar_checkbox_view,
      menubar_radio_view,
      (commands_html, submenu_html, checkbox_html, radio_html) => {
        showcase_component_demos(
          "Menubar",
          "Application commands, nested projects, and selection controls use separate bars.",
          [
            showcase_demo_section(
              "Application commands",
              "Grouped File and Help menus include leading icons, shortcuts, and disabled commands.",
              showcase_demo_stage(
                commands_html,
                ig_menu_code(IgMenubarCommandsIconsCode, IgMenubarCommandsCode),
              ),
            ),
            showcase_demo_section(
              "Submenu & destructive action",
              "A project submenu keeps icon alignment through nested and destructive commands.",
              showcase_demo_stage(
                submenu_html,
                ig_menu_code(IgMenubarSubmenuIconsCode, IgMenubarSubmenuCode),
              ),
            ),
            showcase_demo_section(
              "Checkbox items",
              "Panel visibility choices combine SVG icons with trailing checkmarks.",
              showcase_demo_stage(
                checkbox_html,
                ig_menu_code(IgMenubarCheckboxIconsCode, IgMenubarCheckboxCode),
              ),
            ),
            showcase_demo_section(
              "Radio group",
              "Workspace modes combine SVG icons with one trailing selection mark.",
              showcase_demo_stage(
                radio_html,
                ig_menu_code(IgMenubarRadioIconsCode, IgMenubarRadioCode),
              ),
            ),
          ],
        )
      },
    )
  } else {
    showcase_static_page(@html.nothing)
  }
  let hover_card_component = if selected == "" || selected == "hover-card" {
    hover_card_top_view.view2(hover_card_left_view, ig_hover_card_component)
  } else {
    showcase_static_page(@html.nothing)
  }
  let popover_component = if selected == "" || selected == "popover" {
    popover_bottom_view.view2(popover_right_view, ig_popover_component)
  } else {
    showcase_static_page(@html.nothing)
  }
  let sheet_component = if selected == "" || selected == "sheet" {
    showcase_static_page(
      ig_sheet_component(
        sheet_top_view, sheet_right_view, sheet_bottom_view, sheet_left_view,
      ),
    )
  } else {
    showcase_static_page(@html.nothing)
  }
  let tooltip_component = if selected == "" || selected == "tooltip" {
    tooltip_top_view.view4(
      tooltip_right_view, tooltip_bottom_view, tooltip_left_view, ig_tooltip_component,
    )
  } else {
    showcase_static_page(@html.nothing)
  }
  let second_row = dropdown_component.view6(
    hover_card_component,
    menubar_component,
    popover_component,
    sheet_component,
    tooltip_component,
    (
      dropdown_html,
      hover_card_html,
      menubar_html,
      popover_html,
      sheet_html,
      tooltip_html,
    ) => {
      @html.fragment([
        dropdown_html, menubar_html, popover_html, hover_card_html, tooltip_html,
        sheet_html,
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
fn ig_resizable_component(
  horizontal_html : @html.Html,
  vertical_html : @html.Html,
) -> @html.Html {
  showcase_component_demos(
    "Resizable",
    "Horizontal multi-panel and vertical two-panel layouts.",
    [
      showcase_demo_section(
        "Horizontal multi-panel",
        "Three panels expose two pointer and keyboard resize handles.",
        showcase_demo_stage(
          horizontal_html,
          IgResizableHorizontalCode,
          tall=true,
        ),
      ),
      showcase_demo_section(
        "Vertical two-panel",
        "A bounded vertical handle resizes the preview and console panels.",
        showcase_demo_stage(vertical_html, IgResizableVerticalCode, tall=true),
      ),
    ],
  )
}

///|
fn ig_scroll_area_component(
  vertical_html : @html.Html,
  horizontal_html : @html.Html,
) -> @html.Html {
  showcase_component_demos(
    "Scroll Area",
    "Vertical and horizontal orientations use measured scrollbars.",
    [
      showcase_demo_section(
        "Vertical",
        "A measured vertical thumb follows the release checklist viewport.",
        showcase_demo_stage(vertical_html, IgScrollAreaVerticalCode, tall=true),
      ),
      showcase_demo_section(
        "Horizontal",
        "A measured horizontal thumb follows an overflowing row of badges.",
        showcase_demo_stage(horizontal_html, IgScrollAreaHorizontalCode),
      ),
    ],
  )
}

///|
fn ig_sonner_component(
  default_html : @html.Html,
  success_html : @html.Html,
  destructive_html : @html.Html,
  queue_html : @html.Html,
) -> @html.Html {
  showcase_component_demos(
    "Sonner",
    "Each notification treatment and queue behavior has an independent example.",
    [
      showcase_demo_section(
        "Default",
        "A neutral notification appears in a bounded bottom-right queue.",
        showcase_demo_stage(default_html, IgSonnerDefaultCode),
      ),
      showcase_demo_section(
        "Success",
        "A positive notification uses the success treatment.",
        showcase_demo_stage(success_html, IgSonnerSuccessCode),
      ),
      showcase_demo_section(
        "Destructive",
        "An error notification uses the destructive treatment.",
        showcase_demo_stage(destructive_html, IgSonnerDestructiveCode),
      ),
      showcase_demo_section(
        "Queue & dismissal",
        "Add neutral notifications to a bounded queue or dismiss the queue at once.",
        showcase_demo_stage(queue_html, IgSonnerQueueCode),
      ),
    ],
  )
}

///|
fn ig_toast_component() -> @html.Html {
  showcase_component_demos(
    "Toast",
    "Static toast compositions expose semantic visual treatments.",
    [
      showcase_demo_section(
        "Default",
        "A neutral status can include a compact action.",
        showcase_demo_stage(
          @rui.toast(variant=ToastDefault, [
            @rui.toast_title("Draft saved"),
            @rui.toast_description("Your changes remain local."),
            @rui.toast_action("View"),
          ]),
          IgToastDefaultCode,
        ),
      ),
      showcase_demo_section(
        "Success",
        "A positive status confirms a completed action.",
        showcase_demo_stage(
          @rui.toast(variant=ToastSuccess, [
            @rui.toast_title("Published"),
            @rui.toast_description("The latest preview is live."),
          ]),
          IgToastSuccessCode,
        ),
      ),
      showcase_demo_section(
        "Destructive",
        "An error status calls attention to a failed action.",
        showcase_demo_stage(
          @rui.toast(variant=ToastDestructive, [
            @rui.toast_title("Could not sync"),
            @rui.toast_description("Check the connection and try again."),
          ]),
          IgToastDestructiveCode,
        ),
      ),
    ],
  )
}

///|
fn ig_feedback_page(selected : String) -> @rabbita.Val[@html.Html] {
  let sonner_default_view = @rui.sonner(max_toasts=3, position="bottom-right", scope => {
    @rui.button(
      size=Sm,
      on_click=scope.show(
        title="Saved",
        description="The draft remains in this workspace.",
        variant=ToastDefault,
      ),
      "Default toast",
    )
  })
  let sonner_success_view = @rui.sonner(max_toasts=3, position="bottom-right", scope => {
    @rui.button(
      size=Sm,
      variant=Secondary,
      on_click=scope.show(
        title="Published",
        description="The latest UI preview is live.",
        variant=ToastSuccess,
      ),
      "Success toast",
    )
  })
  let sonner_destructive_view = @rui.sonner(
    max_toasts=3,
    position="bottom-right",
    scope => {
      @rui.button(
        size=Sm,
        variant=Destructive,
        on_click=scope.show(
          title="Could not sync",
          description="Check the connection and try again.",
          variant=ToastDestructive,
        ),
        "Error toast",
      )
    },
  )
  let sonner_queue_view = @rui.sonner(max_toasts=3, position="bottom-right", scope => {
    @html.div(style=[IgControlWrapStyle], [
      @rui.button(
        size=Sm,
        on_click=scope.show(
          title="Queued",
          description="This notification joins the bounded queue.",
          variant=ToastDefault,
        ),
        "Add toast",
      ),
      @rui.button(
        size=Sm,
        variant=Ghost,
        on_click=scope.dismiss_all(),
        "Dismiss queue",
      ),
    ])
  })
  let scroller_view = @rui.message_scroller(
    id="showcase-message-scroller",
    default_at_end=true,
    scope => {
      @html.div(style=["position:relative"], [
        @rui.message_scroller_viewport(
          scope~,
          style=[IgMessageViewportStyle],
          @rui.message_scroller_content(style=[IgMessageListStyle], [
            @rui.message_scroller_item(
              @rui.message([
                @rui.message_avatar(@rui.avatar(@rui.avatar_fallback("RA"))),
                @rui.message_content([
                  @rui.message_header("Rabbita · 09:41"),
                  @rui.bubble_group(
                    @rui.bubble(
                      variant=BubbleSecondary,
                      @rui.bubble_content(
                        "The component catalogue is ready for review.",
                      ),
                    ),
                  ),
                ]),
              ]),
            ),
            @rui.message_scroller_item(
              @rui.message(align=AlignEnd, [
                @rui.message_avatar(@rui.avatar(@rui.avatar_fallback("YO"))),
                @rui.message_content([
                  @rui.message_header("You · 09:42"),
                  @rui.bubble_group(
                    @rui.bubble(
                      align=AlignEnd,
                      @rui.bubble_content(
                        "Great — keep state local and the API black-box.",
                      ),
                    ),
                  ),
                  @rui.message_footer("Delivered"),
                ]),
              ]),
            ),
            @rui.message_scroller_item(
              @rui.message([
                @rui.message_avatar(@rui.avatar(@rui.avatar_fallback("RA"))),
                @rui.message_content(
                  @rui.bubble_group(
                    @rui.bubble(
                      variant=BubbleMuted,
                      @rui.bubble_content(
                        "This scroller tracks both edges and exposes jump controls.",
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            @rui.message_scroller_item(
              scroll_anchor=true,
              @rui.message(align=AlignEnd, [
                @rui.message_avatar(@rui.avatar(@rui.avatar_fallback("YO"))),
                @rui.message_content(
                  @rui.bubble_group(
                    @rui.bubble(
                      align=AlignEnd,
                      @rui.bubble_content("Ship the showcase."),
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
            @rui.message_scroller_button(
              scope~,
              direction=ScrollStart,
              label="Jump to first message",
              size=IconSm,
              showcase_arrow_up_icon(),
            ),
            @rui.message_scroller_button(
              scope~,
              direction=ScrollEnd,
              label="Jump to latest message",
              size=IconSm,
              showcase_arrow_down_icon(),
            ),
          ],
        ),
      ])
    },
  )
  let resizable_view = @rui.resizable_group(
    id="showcase-resizable",
    default_sizes=[26, 44, 30],
    min_sizes=[16, 24, 18],
    max_sizes=[52, 68, 54],
    orientation=Horizontal,
    style=[IgResizeStyle],
    scope => {
      @html.fragment([
        @rui.resizable_group_panel(
          scope~,
          index=0,
          style=[IgResizePanelStyle],
          "Files",
        ),
        @rui.resizable_group_handle(
          scope~,
          between=0,
          with_handle=true,
          aria_label="Resize files and editor",
        ),
        @rui.resizable_group_panel(
          scope~,
          index=1,
          style=[IgResizePanelStyle],
          "Editor",
        ),
        @rui.resizable_group_handle(
          scope~,
          between=1,
          with_handle=true,
          aria_label="Resize editor and preview",
        ),
        @rui.resizable_group_panel(
          scope~,
          index=2,
          style=[IgResizePanelStyle],
          "Preview",
        ),
      ])
    },
  )
  let resizable_panel_view = @rui.resizable_panel_group(
    id="showcase-resizable-panel-group",
    default_size=42,
    min=24,
    max=72,
    orientation=Vertical,
    aria_label="Resize preview and console",
    style=[IgResizeStyle, IgResizableVerticalStyle],
    scope => {
      @html.fragment([
        @rui.resizable_panel(
          scope~,
          side=FirstPanel,
          style=[IgResizePanelStyle],
          "Preview",
        ),
        @rui.resizable_handle(
          scope~,
          with_handle=true,
          aria_label="Resize preview and console",
        ),
        @rui.resizable_panel(
          scope~,
          side=SecondPanel,
          style=[IgResizePanelStyle],
          "Console",
        ),
      ])
    },
  )
  let scroll_view = @rui.scroll_area_with_scrollbar(
    id="showcase-scroll-area",
    orientation=Vertical,
    style=[IgScrollAreaStyle],
    @html.div(style=[IgScrollContentStyle], [
      @html.strong("Release checklist"),
      @rui.separator(),
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
  let scroll_horizontal_view = @rui.scroll_area_with_scrollbar(
    id="showcase-scroll-area-horizontal",
    orientation=Horizontal,
    style=[IgHorizontalScrollAreaStyle],
    @html.div(style=[IgHorizontalScrollContentStyle], [
      @rui.badge(variant=Secondary, "Keyboard"),
      @rui.badge(variant=Secondary, "Pointer"),
      @rui.badge(variant=Secondary, "Touch"),
      @rui.badge(variant=Secondary, "RTL"),
      @rui.badge(variant=Secondary, "Measured thumb"),
      @rui.badge(variant=Secondary, "Native fallback"),
    ]),
  )
  let scroller_variants = if selected == "" || selected == "message-scroller" {
    scroller_view.view(scroller_html => {
      ig_demo_card(
        "Message Scroller",
        "One interactive conversation exposes both jump directions.",
        scroller_html,
        "Conversation and edge controls",
        "Real Message and Bubble compositions sit inside the measured viewport with start and end jump buttons.",
        IgMessageScrollerCode,
        wide=true,
      )
    })
  } else {
    showcase_static_page(@html.nothing)
  }
  let sonner_component = if selected == "" || selected == "sonner" {
    sonner_default_view.view4(
      sonner_success_view, sonner_destructive_view, sonner_queue_view, ig_sonner_component,
    )
  } else {
    showcase_static_page(@html.nothing)
  }
  let resizable_component = if selected == "" || selected == "resizable" {
    resizable_view.view2(resizable_panel_view, ig_resizable_component)
  } else {
    showcase_static_page(@html.nothing)
  }
  let scroll_component = if selected == "" || selected == "scroll-area" {
    scroll_view.view2(scroll_horizontal_view, ig_scroll_area_component)
  } else {
    showcase_static_page(@html.nothing)
  }
  sonner_component.view4(
    scroller_variants,
    resizable_component,
    scroll_component,
    (sonner_html, scroller_html, resizable_html, scroll_html) => {
      @html.section(
        id="feedback",
        style=[IgComponentListStyle, "scroll-margin-top:1rem"],
        [
          sonner_html,
          if selected == "" || selected == "toast" {
            ig_toast_component()
          } else {
            @html.nothing
          },
          scroller_html,
          resizable_html,
          scroll_html,
        ],
      )
    },
  )
}
