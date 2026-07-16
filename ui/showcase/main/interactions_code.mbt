///|
const IgBreadcrumbCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|@html.div(
  #|  style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,20rem),1fr));gap:1rem;min-width:0"],
  #|  [
  #|    ig_specimen(
  #|      "Default",
  #|      "Linked ancestors",
  #|      @ui.breadcrumb(
  #|        @ui.breadcrumb_list([
  #|          @ui.breadcrumb_item(@ui.breadcrumb_link(href="#interactions", "UI")),
  #|          @ui.breadcrumb_separator(),
  #|          @ui.breadcrumb_item(
  #|            @ui.breadcrumb_link(href="#navigation", "Patterns"),
  #|          ),
  #|          @ui.breadcrumb_separator(),
  #|          @ui.breadcrumb_item(@ui.breadcrumb_page("Navigation")),
  #|        ]),
  #|      ),
  #|    ),
  #|    ig_specimen(
  #|      "Condensed",
  #|      "Collapsed ancestors",
  #|      @ui.breadcrumb(
  #|        @ui.breadcrumb_list([
  #|          @ui.breadcrumb_item(
  #|            @ui.breadcrumb_link(href="#interactions", "Home"),
  #|          ),
  #|          @ui.breadcrumb_separator(),
  #|          @ui.breadcrumb_item(@ui.breadcrumb_ellipsis()),
  #|          @ui.breadcrumb_separator(),
  #|          @ui.breadcrumb_item(@ui.breadcrumb_page("Current page")),
  #|        ]),
  #|      ),
  #|    ),
  #|  ],
  #|)

///|
const IgPaginationCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|@html.div(
  #|  style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,20rem),1fr));gap:1rem;min-width:0"],
  #|  [
  #|    ig_specimen(
  #|      "Default",
  #|      "Pages + ellipsis",
  #|      @ui.pagination(
  #|        @ui.pagination_content([
  #|          @ui.pagination_item(@ui.pagination_previous(href="#page-1")),
  #|          @ui.pagination_item(
  #|            @ui.pagination_link(href="#page-1", is_active=true, "1"),
  #|          ),
  #|          @ui.pagination_item(@ui.pagination_link(href="#page-2", "2")),
  #|          @ui.pagination_item(@ui.pagination_ellipsis()),
  #|          @ui.pagination_item(@ui.pagination_next(href="#page-2")),
  #|        ]),
  #|      ),
  #|    ),
  #|    ig_specimen(
  #|      "Compact",
  #|      "Small page links",
  #|      @ui.pagination(
  #|        aria_label="Compact pagination",
  #|        @ui.pagination_content([
  #|          @ui.pagination_item(@ui.pagination_previous(href="#page-1")),
  #|          @ui.pagination_item(
  #|            @ui.pagination_link(
  #|              href="#page-1",
  #|              is_active=true,
  #|              size=@ui.Sm,
  #|              "1",
  #|            ),
  #|          ),
  #|          @ui.pagination_item(
  #|            @ui.pagination_link(href="#page-2", size=@ui.Sm, "2"),
  #|          ),
  #|          @ui.pagination_item(@ui.pagination_next(href="#page-2")),
  #|        ]),
  #|      ),
  #|    ),
  #|  ],
  #|)

///|
const IgAccordionCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|let single = @ui.accordion(
  #|  id="showcase-accordion",
  #|  type_=@ui.Single,
  #|  collapsible=true,
  #|  default_value="keyboard",
  #|  items=[
  #|    @ui.accordion_entry(
  #|      value="keyboard",
  #|      label="Keyboard interaction",
  #|      content=@html.p(
  #|        style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0"],
  #|        "Tab reaches each trigger; Enter and Space toggle its panel.",
  #|      ),
  #|    ),
  #|    @ui.accordion_entry(
  #|      value="state",
  #|      label="Owned state",
  #|      content=@html.p(
  #|        style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0"],
  #|        "The black-box root owns its expanded value through Rabbita.",
  #|      ),
  #|    ),
  #|    @ui.accordion_entry(
  #|      value="markup",
  #|      label="Native markup",
  #|      content=@html.p(
  #|        style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0"],
  #|        "Details and summary preserve useful behavior without JavaScript.",
  #|      ),
  #|    ),
  #|  ],
  #|)
  #|let multiple = @ui.accordion(
  #|  id="showcase-accordion-multiple",
  #|  type_=@ui.Multiple,
  #|  default_values=["motion", "focus"],
  #|  items=[
  #|    @ui.accordion_entry(
  #|      value="motion",
  #|      label="Motion",
  #|      content=@html.p(
  #|        style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0"],
  #|        "Each expanded panel animates independently.",
  #|      ),
  #|    ),
  #|    @ui.accordion_entry(
  #|      value="focus",
  #|      label="Keyboard focus",
  #|      content=@html.p(
  #|        style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0"],
  #|        "Arrow keys move between enabled triggers.",
  #|      ),
  #|    ),
  #|    @ui.accordion_entry(
  #|      value="locked",
  #|      label="Unavailable section",
  #|      disabled=true,
  #|      content=@html.p("This panel cannot be opened."),
  #|    ),
  #|  ],
  #|)
  #|
  #|single.view2(multiple, (single_html, multiple_html) => {
  #|  @html.div(
  #|    style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,20rem),1fr));gap:1rem;min-width:0"],
  #|    [
  #|      ig_specimen("Single", "Collapsible", single_html),
  #|      ig_specimen("Multiple", "Independent panels", multiple_html),
  #|    ],
  #|  )
  #|})

///|
const IgCollapsibleCode : String =
  #|@ui.collapsible(
  #|  id="showcase-collapsible",
  #|  default_open=true,
  #|  trigger="What ships inside the component?",
  #|  content=@html.div(
  #|    style=["display:flex;flex-direction:column;gap:1rem;padding-top:0.75rem;gap:0.5rem"],
  #|    [
  #|      @html.p(
  #|        style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0"],
  #|        "State, ARIA relationships, and keyboard behavior.",
  #|      ),
  #|      @ui.badge(variant=@ui.Secondary, "No registration step"),
  #|    ],
  #|  ),
  #|)

///|
const IgTabsCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|let tabs = @ui.tabs(
  #|  id="showcase-tabs",
  #|  default_value="preview",
  #|  orientation=@ui.TabsHorizontal,
  #|  aria_label="Component workflow",
  #|  items=[
  #|    @ui.tab_entry(
  #|      value="preview",
  #|      label="Preview",
  #|      content=@html.div(style=["position:relative;min-width:0;padding-block:1rem"], [
  #|        @html.strong("Ready to interact"),
  #|        @html.p(
  #|          style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0.375rem 0 0"],
  #|          "The selected panel is linked to its trigger.",
  #|        ),
  #|      ]),
  #|    ),
  #|    @ui.tab_entry(
  #|      value="source",
  #|      label="Source",
  #|      content=@html.div(style=["position:relative;min-width:0;padding-block:1rem"], [
  #|        @html.strong("Copy when you need control"),
  #|        @html.p(
  #|          style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0.375rem 0 0"],
  #|          "Otherwise consume the component as a black box.",
  #|        ),
  #|      ]),
  #|    ),
  #|    @ui.tab_entry(
  #|      value="accessibility",
  #|      label="A11y",
  #|      content=@html.div(style=["position:relative;min-width:0;padding-block:1rem"], [
  #|        @html.strong("Roving focus"),
  #|        @html.p(
  #|          style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0.375rem 0 0"],
  #|          "Use Left and Right to move across tabs.",
  #|        ),
  #|      ]),
  #|    ),
  #|  ],
  #|)
  #|let line = @ui.tabs(
  #|  id="showcase-tabs-line",
  #|  default_value="account",
  #|  list_variant=@ui.TabsLine,
  #|  aria_label="Account sections",
  #|  items=[
  #|    @ui.tab_entry(
  #|      value="account",
  #|      label="Account",
  #|      content=@html.div(style=["position:relative;min-width:0;padding-block:1rem"], [
  #|        @html.strong("Account profile"),
  #|        @html.p(
  #|          style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0.375rem 0 0"],
  #|          "The active line follows the selected tab.",
  #|        ),
  #|      ]),
  #|    ),
  #|    @ui.tab_entry(
  #|      value="security",
  #|      label="Security",
  #|      content=@html.div(
  #|        style=["position:relative;min-width:0;padding-block:1rem"],
  #|        "Security settings",
  #|      ),
  #|    ),
  #|    @ui.tab_entry(
  #|      value="notifications",
  #|      label="Notifications",
  #|      content=@html.div(
  #|        style=["position:relative;min-width:0;padding-block:1rem"],
  #|        "Notification preferences",
  #|      ),
  #|    ),
  #|  ],
  #|)
  #|let vertical = @ui.tabs(
  #|  id="showcase-tabs-vertical",
  #|  default_value="general",
  #|  orientation=@ui.TabsVertical,
  #|  aria_label="Vertical settings tabs",
  #|  items=[
  #|    @ui.tab_entry(
  #|      value="general",
  #|      label="General",
  #|      content=@html.div(style=["position:relative;min-width:0;padding-block:1rem"], [
  #|        @html.strong("General settings"),
  #|        @html.p(
  #|          style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0.375rem 0 0"],
  #|          "Up and Down move focus in a vertical list.",
  #|        ),
  #|      ]),
  #|    ),
  #|    @ui.tab_entry(
  #|      value="members",
  #|      label="Members",
  #|      content=@html.div(
  #|        style=["position:relative;min-width:0;padding-block:1rem"],
  #|        "Member access settings",
  #|      ),
  #|    ),
  #|    @ui.tab_entry(
  #|      value="billing",
  #|      label="Billing",
  #|      disabled=true,
  #|      content=@html.div(
  #|        style=["position:relative;min-width:0;padding-block:1rem"],
  #|        "Unavailable",
  #|      ),
  #|    ),
  #|  ],
  #|)
  #|
  #|tabs.view3(line, vertical, (tabs_html, line_html, vertical_html) => {
  #|  @html.div(
  #|    style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,20rem),1fr));gap:1rem;min-width:0"],
  #|    [
  #|      ig_specimen(
  #|        "Default",
  #|        "Horizontal · Left / Right",
  #|        tabs_html,
  #|      ),
  #|      ig_specimen(
  #|        "Line",
  #|        "Horizontal · Left / Right",
  #|        line_html,
  #|      ),
  #|      ig_specimen("Vertical", "Up / Down", vertical_html),
  #|    ],
  #|  )
  #|})

///|
const IgCarouselCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|let horizontal = @ui.carousel(
  #|  id="showcase-carousel",
  #|  count=3,
  #|  loop_=true,
  #|  orientation=@ui.CarouselHorizontal,
  #|  aria_label="Rabbita UI highlights",
  #|  style=["width:min(calc(100% - 6rem),32rem);margin-inline:auto"],
  #|  scope => {
  #|    @html.fragment([
  #|      @ui.carousel_items(scope~, items=[
  #|        @html.div(
  #|          style=["display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px solid var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);font-size:1rem;font-weight:600"],
  #|          "Inline styles",
  #|        ),
  #|        @html.div(
  #|          style=["display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px solid var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);font-size:1rem;font-weight:600"],
  #|          "Incremental state",
  #|        ),
  #|        @html.div(
  #|          style=["display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px solid var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);font-size:1rem;font-weight:600"],
  #|          "Native semantics",
  #|        ),
  #|      ]),
  #|      @ui.carousel_previous(scope~),
  #|      @ui.carousel_next(scope~),
  #|    ])
  #|  },
  #|)
  #|let vertical = @ui.carousel(
  #|  id="showcase-carousel-vertical",
  #|  count=3,
  #|  default_index=1,
  #|  orientation=@ui.CarouselVertical,
  #|  aria_label="Vertical Rabbita UI highlights",
  #|  style=["width:min(calc(100% - 6rem),32rem);margin:3rem auto"],
  #|  scope => {
  #|    @html.fragment([
  #|      @ui.carousel_items(scope~, items=[
  #|        @html.div(
  #|          style=["display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px solid var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);font-size:1rem;font-weight:600", "height:var(--rui-carousel-height,12rem)"],
  #|          "First slide",
  #|        ),
  #|        @html.div(
  #|          style=["display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px solid var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);font-size:1rem;font-weight:600", "height:var(--rui-carousel-height,12rem)"],
  #|          "Selected slide",
  #|        ),
  #|        @html.div(
  #|          style=["display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px solid var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);font-size:1rem;font-weight:600", "height:var(--rui-carousel-height,12rem)"],
  #|          "Last slide",
  #|        ),
  #|      ]),
  #|      @ui.carousel_previous(scope~),
  #|      @ui.carousel_next(scope~),
  #|    ])
  #|  },
  #|)
  #|
  #|horizontal.view2(vertical, (horizontal_html, vertical_html) => {
  #|  @html.div(
  #|    style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,20rem),1fr));gap:1rem;min-width:0"],
  #|    [
  #|      ig_specimen("Horizontal", "Looping", horizontal_html),
  #|      ig_specimen("Vertical", "Bounded", vertical_html),
  #|    ],
  #|  )
  #|})

///|
const IgNavigationMenuCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|let viewport = @ui.navigation_menu(
  #|  id="showcase-navigation-menu",
  #|  aria_label="Showcase navigation",
  #|  scope => {
  #|    @html.div(style=["min-height:10rem"], [
  #|      @ui.navigation_menu_list(scope, [
  #|        @ui.navigation_menu_item(scope, value="platform", item => {
  #|          @html.fragment([
  #|            @ui.navigation_menu_trigger(item, "Platform"),
  #|            @ui.navigation_menu_indicator(item),
  #|            @ui.navigation_menu_content(
  #|              item,
  #|              style=["box-sizing:border-box;display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,8rem),1fr));gap:0.5rem;width:min(30rem,calc(100vw - 2rem));padding:0.25rem"],
  #|              [
  #|                @ui.navigation_menu_link(
  #|                  href="#components",
  #|                  active=true,
  #|                  style=["display:flex;min-height:4.5rem;flex-direction:column;justify-content:center;gap:0.25rem"],
  #|                  [
  #|                    @html.strong("Components"),
  #|                    @html.span(
  #|                      style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"],
  #|                      "Black-box defaults",
  #|                    ),
  #|                  ],
  #|                ),
  #|                @ui.navigation_menu_link(
  #|                  href="#patterns",
  #|                  style=["display:flex;min-height:4.5rem;flex-direction:column;justify-content:center;gap:0.25rem"],
  #|                  [
  #|                    @html.strong("Patterns"),
  #|                    @html.span(
  #|                      style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"],
  #|                      "Compound composition",
  #|                    ),
  #|                  ],
  #|                ),
  #|              ],
  #|            ),
  #|          ])
  #|        }),
  #|        @ui.navigation_menu_item(scope, value="resources", item => {
  #|          @html.fragment([
  #|            @ui.navigation_menu_trigger(item, "Resources"),
  #|            @ui.navigation_menu_indicator(item),
  #|            @ui.navigation_menu_content(
  #|              item,
  #|              style=["box-sizing:border-box;display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,8rem),1fr));gap:0.5rem;width:min(30rem,calc(100vw - 2rem));padding:0.25rem"],
  #|              [
  #|                @ui.navigation_menu_link(
  #|                  href="#api",
  #|                  style=["display:flex;min-height:4.5rem;flex-direction:column;justify-content:center;gap:0.25rem"],
  #|                  [
  #|                    @html.strong("API reference"),
  #|                    @html.span(
  #|                      style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"],
  #|                      "Typed MoonBit surface",
  #|                    ),
  #|                  ],
  #|                ),
  #|                @ui.navigation_menu_link(
  #|                  href="#examples",
  #|                  style=["display:flex;min-height:4.5rem;flex-direction:column;justify-content:center;gap:0.25rem"],
  #|                  [
  #|                    @html.strong("Examples"),
  #|                    @html.span(
  #|                      style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"],
  #|                      "Working interactions",
  #|                    ),
  #|                  ],
  #|                ),
  #|              ],
  #|            ),
  #|          ])
  #|        }),
  #|      ]),
  #|      @ui.navigation_menu_viewport(scope, @html.nothing),
  #|    ])
  #|  },
  #|)
  #|let inline = @ui.navigation_menu(
  #|  id="showcase-navigation-menu-inline",
  #|  viewport=false,
  #|  aria_label="Inline navigation menu",
  #|  scope => {
  #|    @ui.navigation_menu_list(scope, [
  #|      @ui.navigation_menu_item(scope, value="learn", item => {
  #|        @html.fragment([
  #|          @ui.navigation_menu_trigger(item, "Learn"),
  #|          @ui.navigation_menu_content(
  #|            item,
  #|            style=["box-sizing:border-box;display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,8rem),1fr));gap:0.5rem;width:min(30rem,calc(100vw - 2rem));padding:0.25rem"],
  #|            [
  #|              @ui.navigation_menu_link(
  #|                href="#guide",
  #|                active=true,
  #|                style=["display:flex;min-height:4.5rem;flex-direction:column;justify-content:center;gap:0.25rem"],
  #|                [
  #|                  @html.strong("Guide"),
  #|                  @html.span(
  #|                    style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"],
  #|                    "Active destination",
  #|                  ),
  #|                ],
  #|              ),
  #|              @ui.navigation_menu_link(
  #|                href="#examples",
  #|                style=["display:flex;min-height:4.5rem;flex-direction:column;justify-content:center;gap:0.25rem"],
  #|                [
  #|                  @html.strong("Examples"),
  #|                  @html.span(
  #|                    style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"],
  #|                    "Inline content",
  #|                  ),
  #|                ],
  #|              ),
  #|            ],
  #|          ),
  #|        ])
  #|      }),
  #|      @ui.navigation_menu_item(scope, value="disabled", item => {
  #|        @ui.navigation_menu_trigger(item, disabled=true, "Unavailable")
  #|      }),
  #|    ])
  #|  },
  #|)
  #|
  #|viewport.view2(inline, (viewport_html, inline_html) => {
  #|  @html.div(
  #|    style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,20rem),1fr));gap:1rem;min-width:0"],
  #|    [
  #|      ig_specimen("Viewport", "Shared layer", viewport_html),
  #|      ig_specimen("Inline", "Local panels", inline_html),
  #|    ],
  #|  )
  #|})

///|
const IgSidebarCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|fn stroke_icon(path : String) -> @html.Html {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=["display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none"],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d=path,
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|
  #|fn layout_icon() -> @html.Html {
  #|  stroke_icon("M4 4h16v16H4zM4 9h16M9 9v11")
  #|}
  #|
  #|fn plus_icon() -> @html.Html {
  #|  stroke_icon("M12 5v14M5 12h14")
  #|}
  #|
  #|fn panel_left_icon() -> @html.Html {
  #|  stroke_icon("M3 3h18v18H3zM9 3v18")
  #|}
  #|
  #|fn activity_icon() -> @html.Html {
  #|  stroke_icon("M3 12h4l2-8 4 16 2-8h6")
  #|}
  #|
  #|fn settings_icon() -> @html.Html {
  #|  stroke_icon(
  #|    "M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.38a2 2 0 0 0-.73-2.73l-.15-.09a2 2 0 0 1-1-1.74v-.51a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2zM12 15.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Z",
  #|  )
  #|}
  #|
  #|fn user_icon() -> @html.Html {
  #|  stroke_icon("M20 21a8 8 0 0 0-16 0M12 13a5 5 0 1 0 0-10 5 5 0 0 0 0 10Z")
  #|}
  #|
  #|fn sidebar_variant(
  #|  id : String,
  #|  side : @ui.SidebarSide,
  #|  variant : @ui.SidebarVariant,
  #|  collapsible : @ui.SidebarCollapsible,
  #|  default_collapsed : Bool,
  #|  menu_size : @ui.SidebarMenuButtonSize,
  #|) -> @rabbita.Val[@html.Html] {
  #|  @ui.sidebar_provider(
  #|    default_collapsed~,
  #|    style=["--rui-sidebar-width:min(15rem,calc(100% - 3.25rem));height:21rem;min-height:21rem;overflow:hidden;border:1px solid var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-background)"],
  #|    scope => {
  #|      @html.fragment([
  #|        @ui.sidebar(scope, id~, side~, variant~, collapsible~, [
  #|          @ui.sidebar_header(
  #|            @ui.sidebar_input(
  #|              aria_label="Filter workspace navigation",
  #|              placeholder="Filter…",
  #|            ),
  #|          ),
  #|          @ui.sidebar_content(
  #|            @ui.sidebar_group([
  #|              @ui.sidebar_group_label(scope~, "Workspace"),
  #|              @ui.sidebar_group_action(
  #|                aria_label="Add workspace item",
  #|                plus_icon(),
  #|              ),
  #|              @ui.sidebar_group_content(
  #|                @ui.sidebar_menu([
  #|                  @ui.sidebar_menu_item([
  #|                    @ui.sidebar_menu_button(
  #|                      href="#overview",
  #|                      is_active=true,
  #|                      size=menu_size,
  #|                      [layout_icon(), @html.span("Overview")],
  #|                    ),
  #|                    @ui.sidebar_menu_badge("6"),
  #|                    @ui.sidebar_menu_action(
  #|                      show_on_hover=true,
  #|                      aria_label="Overview actions",
  #|                      settings_icon(),
  #|                    ),
  #|                  ]),
  #|                  @ui.sidebar_menu_item(
  #|                    @ui.sidebar_menu_button(href="#activity", size=menu_size, [
  #|                      activity_icon(),
  #|                      @html.span("Activity"),
  #|                    ]),
  #|                  ),
  #|                  @ui.sidebar_menu_item(
  #|                    @ui.sidebar_menu_button(
  #|                      href="#settings",
  #|                      size=menu_size,
  #|                      disabled=true,
  #|                      [settings_icon(), @html.span("Disabled")],
  #|                    ),
  #|                  ),
  #|                  @ui.sidebar_menu_item(
  #|                    @ui.sidebar_menu_sub(
  #|                      @ui.sidebar_menu_sub_item(
  #|                        @ui.sidebar_menu_sub_button(
  #|                          href="#reports",
  #|                          is_active=true,
  #|                          "Reports",
  #|                        ),
  #|                      ),
  #|                    ),
  #|                  ),
  #|                ]),
  #|              ),
  #|            ]),
  #|          ),
  #|          @ui.sidebar_separator(),
  #|          @ui.sidebar_footer(
  #|            @ui.sidebar_menu(
  #|              @ui.sidebar_menu_item(
  #|                @ui.sidebar_menu_button(href="#account", size=menu_size, [
  #|                  user_icon(),
  #|                  @html.span("Account"),
  #|                ]),
  #|              ),
  #|            ),
  #|          ),
  #|          @ui.sidebar_rail(scope, side~),
  #|        ]),
  #|        @ui.sidebar_inset(style=["min-width:0;padding:0.75rem"], [
  #|          @html.div(
  #|            style=["display:flex;flex-wrap:wrap;align-items:center;gap:0.75rem;justify-content:space-between"],
  #|            [
  #|              @ui.sidebar_trigger(
  #|                scope,
  #|                controls=id,
  #|                aria_label="Toggle sidebar specimen",
  #|                panel_left_icon(),
  #|              ),
  #|              @ui.badge(variant=@ui.Outline, "Live"),
  #|            ],
  #|          ),
  #|          @html.div(
  #|            style=["display:flex;min-height:11rem;align-items:center;justify-content:center"],
  #|            @html.p(
  #|              style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;max-width:13rem;text-align:center"],
  #|              "Use the trigger or rail to verify provider-owned state.",
  #|            ),
  #|          ),
  #|        ]),
  #|      ])
  #|    },
  #|  )
  #|}
  #|
  #|let fixed = sidebar_variant(
  #|  "showcase-sidebar-fixed",
  #|  @ui.SidebarLeft,
  #|  @ui.SidebarDefault,
  #|  @ui.SidebarFixed,
  #|  false,
  #|  @ui.SidebarMenuSm,
  #|)
  #|let icon = sidebar_variant(
  #|  "showcase-sidebar-icon",
  #|  @ui.SidebarLeft,
  #|  @ui.SidebarFloating,
  #|  @ui.SidebarIcon,
  #|  true,
  #|  @ui.SidebarMenuDefault,
  #|)
  #|let offcanvas = sidebar_variant(
  #|  "showcase-sidebar-offcanvas",
  #|  @ui.SidebarRight,
  #|  @ui.SidebarInset,
  #|  @ui.SidebarOffcanvas,
  #|  false,
  #|  @ui.SidebarMenuLg,
  #|)
  #|
  #|fixed.view3(icon, offcanvas, (fixed_html, icon_html, offcanvas_html) => {
  #|  @html.div(
  #|    style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,28rem),1fr));gap:1rem;min-width:0"],
  #|    [
  #|      ig_specimen("Default · left", "Fixed · small", fixed_html),
  #|      ig_specimen("Floating · left", "Icon · default", icon_html),
  #|      ig_specimen("Inset · right", "Offcanvas · large", offcanvas_html),
  #|    ],
  #|  )
  #|})

///|
const IgAlertDialogCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|fn alert_triangle_icon() -> @html.Html {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=["display:inline-flex;width:2rem;height:2rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none"],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d="M21.73 18 13.73 4a2 2 0 0 0-3.46 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3ZM12 9v4M12 17h.01",
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|
  #|let default_dialog = @ui.alert_dialog(
  #|  id="showcase-alert-dialog-default",
  #|  scope => {
  #|    @html.fragment([
  #|      @ui.alert_dialog_trigger(scope, variant=@ui.Outline, "Archive project"),
  #|      @ui.alert_dialog_portal([
  #|        @ui.alert_dialog_content(scope, [
  #|          @ui.alert_dialog_header([
  #|            @ui.alert_dialog_title(scope, "Archive this project?"),
  #|            @ui.alert_dialog_description(
  #|              scope,
  #|              "You can restore an archived project later from workspace settings.",
  #|            ),
  #|          ]),
  #|          @ui.alert_dialog_footer([
  #|            @ui.alert_dialog_cancel(scope, "Cancel"),
  #|            @ui.alert_dialog_action(scope, "Archive"),
  #|          ]),
  #|        ]),
  #|      ]),
  #|    ])
  #|  },
  #|)
  #|let destructive_dialog = @ui.alert_dialog(
  #|  id="showcase-alert-dialog",
  #|  scope => {
  #|    @html.fragment([
  #|      @ui.alert_dialog_trigger(
  #|        scope,
  #|        variant=@ui.Destructive,
  #|        "Delete snapshot",
  #|      ),
  #|      @ui.alert_dialog_portal([
  #|        @ui.alert_dialog_content(scope, [
  #|          @ui.alert_dialog_header([
  #|            @ui.alert_dialog_media(alert_triangle_icon()),
  #|            @ui.alert_dialog_title(scope, "Delete this snapshot?"),
  #|            @ui.alert_dialog_description(
  #|              scope,
  #|              "This removes the saved state permanently.",
  #|            ),
  #|          ]),
  #|          @ui.alert_dialog_footer([
  #|            @ui.alert_dialog_cancel(scope, "Cancel"),
  #|            @ui.alert_dialog_action(scope, "Delete"),
  #|          ]),
  #|        ]),
  #|      ]),
  #|    ])
  #|  },
  #|)
  #|
  #|default_dialog.view2(destructive_dialog, (default_html, destructive_html) => {
  #|  @html.div(
  #|    style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,20rem),1fr));gap:1rem;min-width:0"],
  #|    [
  #|      ig_specimen("Default", "Reversible", default_html),
  #|      ig_specimen("Destructive", "Permanent", destructive_html),
  #|    ],
  #|  )
  #|})

///|
const IgDialogCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|fn dialog_variant(
  #|  id : String,
  #|  modal : Bool,
  #|  trigger_variant : @ui.ButtonVariant,
  #|  trigger_label : String,
  #|) -> @rabbita.Val[@html.Html] {
  #|  @ui.dialog(id~, modal~, scope => {
  #|    @html.fragment([
  #|      @ui.dialog_trigger(scope, variant=trigger_variant, trigger_label),
  #|      @ui.dialog_portal([
  #|        @ui.dialog_content(scope, show_close=true, [
  #|          @ui.dialog_header([
  #|            @ui.dialog_title(scope, trigger_label),
  #|            @ui.dialog_description(
  #|              scope,
  #|              if modal {
  #|                "Focus stays inside this modal surface until it closes."
  #|              } else {
  #|                "This non-modal surface leaves the surrounding page available."
  #|              },
  #|            ),
  #|          ]),
  #|          @html.div(style=["display:flex;flex-direction:column;gap:1rem"], [
  #|            @ui.label(for_=id + "-name", "Display name"),
  #|            @ui.input(id=id + "-name", value="Rabbita team"),
  #|          ]),
  #|          @ui.dialog_footer(@ui.dialog_close(scope, "Save changes")),
  #|        ]),
  #|      ]),
  #|    ])
  #|  })
  #|}
  #|
  #|let modal = dialog_variant(
  #|  "showcase-dialog-modal",
  #|  true,
  #|  @ui.Outline,
  #|  "Edit profile",
  #|)
  #|let nonmodal = dialog_variant(
  #|  "showcase-dialog-nonmodal",
  #|  false,
  #|  @ui.Secondary,
  #|  "Open non-modal",
  #|)
  #|
  #|modal.view2(nonmodal, (modal_html, nonmodal_html) => {
  #|  @html.div(
  #|    style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,20rem),1fr));gap:1rem;min-width:0"],
  #|    [
  #|      ig_specimen("Modal", "Focus contained", modal_html),
  #|      ig_specimen("Non-modal", "Page remains active", nonmodal_html),
  #|    ],
  #|  )
  #|})

///|
const IgDrawerCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|fn drawer_variant(
  #|  id : String,
  #|  direction : @ui.DrawerDirection,
  #|  trigger_label : String,
  #|) -> @rabbita.Val[@html.Html] {
  #|  @ui.drawer(id~, scope => {
  #|    @html.fragment([
  #|      @ui.drawer_trigger(scope, variant=@ui.Outline, trigger_label),
  #|      @ui.drawer_portal([
  #|        @ui.drawer_content(
  #|          scope,
  #|          direction~,
  #|          show_handle=true,
  #|          show_close=true,
  #|          [
  #|            @ui.drawer_header([
  #|              @ui.drawer_title(scope, trigger_label),
  #|              @ui.drawer_description(
  #|                scope,
  #|                "The direction controls placement, motion, and handle orientation.",
  #|              ),
  #|            ]),
  #|            @html.div(
  #|              style=["position:relative;min-width:0;padding-block:1rem"],
  #|              "All checks passed",
  #|            ),
  #|            @ui.drawer_footer(@ui.drawer_close(scope, "Close")),
  #|          ],
  #|        ),
  #|      ]),
  #|    ])
  #|  })
  #|}
  #|
  #|let top = drawer_variant(
  #|  "showcase-drawer-top",
  #|  @ui.DrawerTop,
  #|  "Open top drawer",
  #|)
  #|let right = drawer_variant(
  #|  "showcase-drawer-right",
  #|  @ui.DrawerRight,
  #|  "Open right drawer",
  #|)
  #|let bottom = drawer_variant(
  #|  "showcase-drawer-bottom",
  #|  @ui.DrawerBottom,
  #|  "Open bottom drawer",
  #|)
  #|let left = drawer_variant(
  #|  "showcase-drawer-left",
  #|  @ui.DrawerLeft,
  #|  "Open left drawer",
  #|)
  #|
  #|top.view4(right, bottom, left, (top_html, right_html, bottom_html, left_html) => {
  #|  @html.div(
  #|    style=["display:grid;width:min(100%,44rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,18rem),1fr));gap:2rem 3rem;min-width:0"],
  #|    [
  #|      ig_specimen("Top", "Handle horizontal", top_html),
  #|      ig_specimen("Right", "Handle vertical", right_html),
  #|      ig_specimen("Bottom", "Handle horizontal", bottom_html),
  #|      ig_specimen("Left", "Handle vertical", left_html),
  #|    ],
  #|  )
  #|})

///|
const IgContextMenuCode : String =
  #|@ui.context_menu(
  #|  id="showcase-context-menu",
  #|  default_checked_values=["grid"],
  #|  default_radio_values=[("density", "comfortable")],
  #|  scope => {
  #|    @html.fragment([
  #|      @ui.context_menu_trigger(
  #|        scope,
  #|        style=["display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px dashed var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);color:var(--rui-muted-foreground);font-size:0.8125rem;text-align:center;user-select:none"],
  #|        "Right-click or press the context-menu key",
  #|      ),
  #|      @ui.context_menu_portal([
  #|        @ui.context_menu_content(scope, aria_label="Canvas actions", [
  #|          @ui.context_menu_label("Canvas"),
  #|          @ui.context_menu_item(scope, [
  #|            @html.span("Duplicate"),
  #|            @ui.context_menu_shortcut("⌘D"),
  #|          ]),
  #|          @ui.context_menu_item(scope, "Rename"),
  #|          @ui.context_menu_item(scope, inset=true, "Move to folder"),
  #|          @ui.context_menu_item(scope, disabled=true, "Paste"),
  #|          @ui.context_menu_checkbox_item(scope, value="grid", "Show grid"),
  #|          @ui.context_menu_radio_group(scope, value="density", radio => {
  #|            @html.fragment([
  #|              @ui.context_menu_radio_item(
  #|                radio,
  #|                value="compact",
  #|                "Compact density",
  #|              ),
  #|              @ui.context_menu_radio_item(
  #|                radio,
  #|                value="comfortable",
  #|                "Comfortable density",
  #|              ),
  #|            ])
  #|          }),
  #|          @ui.context_menu_sub(scope, value="share", sub => {
  #|            @html.fragment([
  #|              @ui.context_menu_sub_trigger(sub, "Share"),
  #|              @ui.context_menu_sub_content(sub, [
  #|                @ui.context_menu_item(scope, "Copy link"),
  #|                @ui.context_menu_item(scope, "Invite people"),
  #|              ]),
  #|            ])
  #|          }),
  #|          @ui.context_menu_separator(),
  #|          @ui.context_menu_item(scope, destructive=true, "Delete"),
  #|        ]),
  #|      ]),
  #|    ])
  #|  },
  #|)

///|
const IgCommandCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|let inline = @ui.command(
  #|  id="showcase-command",
  #|  style=["max-width:none;border:1px solid var(--rui-border);border-radius:var(--rui-radius);box-shadow:none"],
  #|  scope => {
  #|    @html.fragment([
  #|      @ui.command_input(scope~, placeholder="Search actions…"),
  #|      @ui.command_list(scope~, [
  #|        @ui.command_empty(scope~, "No matching actions."),
  #|        @ui.command_group(scope~, heading="Workspace", [
  #|          @ui.command_item(
  #|            scope~,
  #|            value="Open dashboard",
  #|            keywords=["home"],
  #|            [@html.span("Open dashboard"), @ui.command_shortcut("⌘D")],
  #|          ),
  #|          @ui.command_item(scope~, value="Create project", keywords=["new"], [
  #|            @html.span("Create project"),
  #|            @ui.command_shortcut("⌘N"),
  #|          ]),
  #|          @ui.command_separator(),
  #|          @ui.command_item(
  #|            scope~,
  #|            value="Settings",
  #|            keywords=["preferences"],
  #|            "Settings",
  #|          ),
  #|        ]),
  #|      ]),
  #|    ])
  #|  },
  #|)
  #|let dialog = @ui.command_dialog(
  #|  id="showcase-command-dialog",
  #|  aria_label="Command palette",
  #|  trigger=scope => {
  #|    @ui.command_dialog_trigger(scope~, variant=@ui.Outline, "Open palette")
  #|  },
  #|  scope => {
  #|    @html.fragment([
  #|      @ui.command_input(scope~, placeholder="Type a command…"),
  #|      @ui.command_list(scope~, [
  #|        @ui.command_empty(scope~, "No matching commands."),
  #|        @ui.command_group(scope~, heading="Navigation", [
  #|          @ui.command_item(scope~, value="Go to overview", "Go to overview"),
  #|          @ui.command_item(scope~, value="Open settings", "Open settings"),
  #|          @ui.command_item(
  #|            scope~,
  #|            value="Unavailable command",
  #|            disabled=true,
  #|            "Unavailable command",
  #|          ),
  #|        ]),
  #|      ]),
  #|    ])
  #|  },
  #|)
  #|
  #|inline.view2(dialog, (inline_html, dialog_html) => {
  #|  @html.div(
  #|    style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,20rem),1fr));gap:1rem;min-width:0"],
  #|    [
  #|      ig_specimen("Inline", "Filterable list", inline_html),
  #|      ig_specimen("Dialog", "Trigger + modal", dialog_html),
  #|    ],
  #|  )
  #|})

///|
const IgDropdownMenuCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|let bottom = @ui.dropdown_menu(
  #|  id="showcase-dropdown-menu",
  #|  default_checked_values=["status"],
  #|  default_radio_values=[("density", "comfortable")],
  #|  scope => {
  #|    @html.fragment([
  #|      @ui.dropdown_menu_trigger(scope, variant=@ui.Outline, "Workspace menu"),
  #|      @ui.dropdown_menu_portal([
  #|        @ui.dropdown_menu_content(scope, side=@ui.Bottom, align=@ui.Start, [
  #|          @ui.dropdown_menu_label("Workspace"),
  #|          @ui.dropdown_menu_item(scope, [
  #|            @html.span("New tab"),
  #|            @ui.dropdown_menu_shortcut("⌘T"),
  #|          ]),
  #|          @ui.dropdown_menu_item(scope, "Invite member"),
  #|          @ui.dropdown_menu_item(scope, inset=true, "Move workspace"),
  #|          @ui.dropdown_menu_item(scope, disabled=true, "Duplicate workspace"),
  #|          @ui.dropdown_menu_checkbox_item(
  #|            scope,
  #|            value="status",
  #|            close_on_select=false,
  #|            "Show status",
  #|          ),
  #|          @ui.dropdown_menu_radio_group(scope, value="density", radio => {
  #|            @html.fragment([
  #|              @ui.dropdown_menu_radio_item(
  #|                radio,
  #|                value="compact",
  #|                "Compact density",
  #|              ),
  #|              @ui.dropdown_menu_radio_item(
  #|                radio,
  #|                value="comfortable",
  #|                "Comfortable density",
  #|              ),
  #|            ])
  #|          }),
  #|          @ui.dropdown_menu_sub(scope, value="share", sub => {
  #|            @html.fragment([
  #|              @ui.dropdown_menu_sub_trigger(sub, "Share"),
  #|              @ui.dropdown_menu_sub_content(sub, [
  #|                @ui.dropdown_menu_item(scope, "Copy link"),
  #|                @ui.dropdown_menu_item(scope, "Invite people"),
  #|              ]),
  #|            ])
  #|          }),
  #|          @ui.dropdown_menu_separator(),
  #|          @ui.dropdown_menu_item(scope, destructive=true, "Leave workspace"),
  #|        ]),
  #|      ]),
  #|    ])
  #|  },
  #|)
  #|let top = @ui.dropdown_menu(
  #|  id="showcase-dropdown-menu-placed",
  #|  scope => {
  #|    @html.fragment([
  #|      @ui.dropdown_menu_trigger(
  #|        scope,
  #|        variant=@ui.Secondary,
  #|        size=@ui.Sm,
  #|        "Top-end menu",
  #|      ),
  #|      @ui.dropdown_menu_portal([
  #|        @ui.dropdown_menu_content(scope, side=@ui.Top, align=@ui.End, [
  #|          @ui.dropdown_menu_item(scope, "Open"),
  #|          @ui.dropdown_menu_item(scope, disabled=true, "Unavailable"),
  #|          @ui.dropdown_menu_item(scope, destructive=true, "Remove"),
  #|        ]),
  #|      ]),
  #|    ])
  #|  },
  #|)
  #|
  #|bottom.view2(top, (bottom_html, top_html) => {
  #|  @html.div(
  #|    style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,20rem),1fr));gap:1rem;min-width:0"],
  #|    [
  #|      ig_specimen("Bottom · start", "Rich menu", bottom_html),
  #|      ig_specimen("Top · end", "Small trigger", top_html),
  #|    ],
  #|  )
  #|})

///|
const IgDropdownMenuIconsCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|fn stroke_icon(path : String) -> @html.Html {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=["display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none"],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d=path,
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|
  #|fn user_icon() -> @html.Html {
  #|  stroke_icon("M20 21a8 8 0 0 0-16 0M12 13a5 5 0 1 0 0-10 5 5 0 0 0 0 10Z")
  #|}
  #|
  #|fn credit_card_icon() -> @html.Html {
  #|  stroke_icon("M2 10h20M4 4h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2Z")
  #|}
  #|
  #|fn settings_icon() -> @html.Html {
  #|  stroke_icon("M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.38a2 2 0 0 0-.73-2.73l-.15-.09a2 2 0 0 1-1-1.74v-.51a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2zM12 15.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Z")
  #|}
  #|
  #|fn log_out_icon() -> @html.Html {
  #|  stroke_icon("m16 17 5-5-5-5M21 12H9M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4")
  #|}
  #|
  #|fn mail_icon() -> @html.Html {
  #|  stroke_icon("m22 7-8.991 5.727a2 2 0 0 1-2.009 0L2 7M4 4h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2Z")
  #|}
  #|
  #|fn message_square_icon() -> @html.Html {
  #|  stroke_icon("M21 15a4 4 0 0 1-4 4H7l-4 4V7a4 4 0 0 1 4-4h10a4 4 0 0 1 4 4Z")
  #|}
  #|
  #|fn bell_icon() -> @html.Html {
  #|  stroke_icon("M10.268 21a2 2 0 0 0 3.464 0M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326")
  #|}
  #|
  #|fn wallet_icon() -> @html.Html {
  #|  stroke_icon("M20 7V6a2 2 0 0 0-2-2H5a3 3 0 0 0 0 6h15v10H5a3 3 0 0 1-3-3V7M16 14h.01")
  #|}
  #|
  #|fn building_icon() -> @html.Html {
  #|  stroke_icon("M6 22V4a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v18M6 12H4a2 2 0 0 0-2 2v8h20v-8a2 2 0 0 0-2-2h-2M10 6h4M10 10h4M10 14h4M10 18h4")
  #|}
  #|
  #|let items = @ui.dropdown_menu(
  #|  id="showcase-dropdown-menu-icons",
  #|  scope => {
  #|    @html.fragment([
  #|      @ui.dropdown_menu_trigger(scope, variant=@ui.Outline, "Account"),
  #|      @ui.dropdown_menu_portal([
  #|        @ui.dropdown_menu_content(
  #|          scope,
  #|          side=@ui.Bottom,
  #|          align=@ui.Start,
  #|          style=["min-width:12rem"],
  #|          [
  #|            @ui.dropdown_menu_item(scope, [user_icon(), @html.span("Profile")]),
  #|            @ui.dropdown_menu_item(scope, [credit_card_icon(), @html.span("Billing")]),
  #|            @ui.dropdown_menu_item(scope, [settings_icon(), @html.span("Settings")]),
  #|            @ui.dropdown_menu_separator(),
  #|            @ui.dropdown_menu_item(
  #|              scope,
  #|              destructive=true,
  #|              [log_out_icon(), @html.span("Log out")],
  #|            ),
  #|          ],
  #|        ),
  #|      ]),
  #|    ])
  #|  },
  #|)
  #|
  #|let checkboxes = @ui.dropdown_menu(
  #|  id="showcase-dropdown-menu-checkbox-icons",
  #|  default_checked_values=["email", "push"],
  #|  scope => {
  #|    @html.fragment([
  #|      @ui.dropdown_menu_trigger(scope, variant=@ui.Outline, "Notifications"),
  #|      @ui.dropdown_menu_portal([
  #|        @ui.dropdown_menu_content(scope, style=["min-width:12rem"], [
  #|          @ui.dropdown_menu_checkbox_item(
  #|            scope,
  #|            value="email",
  #|            [mail_icon(), @html.span("Email")],
  #|          ),
  #|          @ui.dropdown_menu_checkbox_item(
  #|            scope,
  #|            value="sms",
  #|            [message_square_icon(), @html.span("SMS")],
  #|          ),
  #|          @ui.dropdown_menu_checkbox_item(
  #|            scope,
  #|            value="push",
  #|            [bell_icon(), @html.span("Push notifications")],
  #|          ),
  #|        ]),
  #|      ]),
  #|    ])
  #|  },
  #|)
  #|
  #|let radios = @ui.dropdown_menu(
  #|  id="showcase-dropdown-menu-radio-icons",
  #|  default_radio_values=[("payment", "card")],
  #|  scope => {
  #|    @html.fragment([
  #|      @ui.dropdown_menu_trigger(scope, variant=@ui.Outline, "Payment method"),
  #|      @ui.dropdown_menu_portal([
  #|        @ui.dropdown_menu_content(
  #|          scope,
  #|          style=["min-width:12rem"],
  #|          @ui.dropdown_menu_radio_group(scope, value="payment", radio => {
  #|            @html.fragment([
  #|              @ui.dropdown_menu_radio_item(
  #|                radio,
  #|                value="card",
  #|                [credit_card_icon(), @html.span("Credit card")],
  #|              ),
  #|              @ui.dropdown_menu_radio_item(
  #|                radio,
  #|                value="wallet",
  #|                [wallet_icon(), @html.span("PayPal")],
  #|              ),
  #|              @ui.dropdown_menu_radio_item(
  #|                radio,
  #|                value="bank",
  #|                [building_icon(), @html.span("Bank transfer")],
  #|              ),
  #|            ])
  #|          }),
  #|        ),
  #|      ]),
  #|    ])
  #|  },
  #|)
  #|
  #|items.view3(checkboxes, radios, (items_html, checkbox_html, radio_html) => {
  #|  @html.div(
  #|    style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,12rem),1fr));gap:1rem;min-width:0"],
  #|    [
  #|      ig_specimen("Items", "Leading icons", items_html),
  #|      ig_specimen("Checkboxes", "Icons + trailing checks", checkbox_html),
  #|      ig_specimen("Radio group", "Icons + trailing check", radio_html),
  #|    ],
  #|  )
  #|})

///|
const IgMenubarCode : String =
  #|@ui.menubar(
  #|  id="showcase-menubar",
  #|  default_checked_values=["sidebar"],
  #|  default_radio_values=[("theme", "system")],
  #|  scope => {
  #|    @html.fragment([
  #|      @ui.menubar_menu(scope, value="file", menu => {
  #|        @html.fragment([
  #|          @ui.menubar_trigger(menu, "File"),
  #|          @ui.menubar_portal([
  #|            @ui.menubar_content(menu, [
  #|              @ui.menubar_label("Project"),
  #|              @ui.menubar_item(menu, [
  #|                @html.span("New project"),
  #|                @ui.menubar_shortcut("⌘N"),
  #|              ]),
  #|              @ui.menubar_item(menu, inset=true, "Open…"),
  #|              @ui.menubar_item(menu, disabled=true, "Import"),
  #|              @ui.menubar_sub(menu, value="recent", sub => {
  #|                @html.fragment([
  #|                  @ui.menubar_sub_trigger(sub, "Recent projects"),
  #|                  @ui.menubar_sub_content(sub, [
  #|                    @ui.menubar_item(menu, "Design system"),
  #|                    @ui.menubar_item(menu, "Documentation"),
  #|                  ]),
  #|                ])
  #|              }),
  #|              @ui.menubar_separator(),
  #|              @ui.menubar_item(menu, destructive=true, "Close project"),
  #|            ]),
  #|          ]),
  #|        ])
  #|      }),
  #|      @ui.menubar_menu(scope, value="view", menu => {
  #|        @html.fragment([
  #|          @ui.menubar_trigger(menu, "View"),
  #|          @ui.menubar_content(menu, [
  #|            @ui.menubar_checkbox_item(
  #|              menu,
  #|              value="sidebar",
  #|              close_on_select=false,
  #|              "Sidebar",
  #|            ),
  #|            @ui.menubar_radio_group(menu, value="theme", radio => {
  #|              @html.fragment([
  #|                @ui.menubar_radio_item(radio, value="system", "System theme"),
  #|                @ui.menubar_radio_item(radio, value="light", "Light theme"),
  #|                @ui.menubar_radio_item(radio, value="dark", "Dark theme"),
  #|              ])
  #|            }),
  #|            @ui.menubar_item(menu, "Focus mode"),
  #|          ]),
  #|        ])
  #|      }),
  #|      @ui.menubar_menu(scope, value="help", menu => {
  #|        @html.fragment([
  #|          @ui.menubar_trigger(menu, "Help"),
  #|          @ui.menubar_content(
  #|            menu,
  #|            @ui.menubar_item(menu, "Keyboard shortcuts"),
  #|          ),
  #|        ])
  #|      }),
  #|    ])
  #|  },
  #|)

///|
const IgPopoverCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|fn popover_variant(
  #|  id : String,
  #|  side : @ui.PopupSide,
  #|  align : @ui.PopupAlign,
  #|  trigger_label : String,
  #|) -> @rabbita.Val[@html.Html] {
  #|  let title_id = id + "-title"
  #|  let description_id = id + "-description"
  #|  @ui.popover(
  #|    id~,
  #|    side~,
  #|    align~,
  #|    title_id~,
  #|    description_id~,
  #|    trigger_variant=@ui.Outline,
  #|    trigger_label,
  #|    @html.div(
  #|      style=["display:flex;flex-direction:column;gap:0.75rem"],
  #|      [
  #|        @ui.popover_header([
  #|          @ui.popover_title(id=title_id, trigger_label),
  #|          @ui.popover_description(
  #|            id=description_id,
  #|            "Anchored content stays labelled at this placement.",
  #|          ),
  #|        ]),
  #|        @ui.input(
  #|          value="320 px",
  #|          attrs=@html.Attrs::build().aria_label("Preferred width"),
  #|        ),
  #|        @ui.popover_close_button(target_id=id, size=@ui.Sm, "Apply"),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|
  #|let bottom = popover_variant(
  #|  "showcase-popover-bottom",
  #|  @ui.Bottom,
  #|  @ui.Start,
  #|  "Bottom-start popover",
  #|)
  #|let right = popover_variant(
  #|  "showcase-popover-right",
  #|  @ui.Right,
  #|  @ui.Center,
  #|  "Right-center popover",
  #|)
  #|
  #|bottom.view2(right, (bottom_html, right_html) => {
  #|  @html.div(
  #|    style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,20rem),1fr));gap:1rem;min-width:0"],
  #|    [
  #|      ig_specimen("Bottom · start", "Labelled form", bottom_html),
  #|      ig_specimen("Right · center", "Focus restored", right_html),
  #|    ],
  #|  )
  #|})

///|
const IgHoverCardCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|fn hover_card_variant(
  #|  id : String,
  #|  side : @ui.PopupSide,
  #|  align : @ui.PopupAlign,
  #|  trigger_label : String,
  #|) -> @rabbita.Val[@html.Html] {
  #|  @ui.hover_card(
  #|    id~,
  #|    href="#rabbita-profile",
  #|    open_delay=120,
  #|    close_delay=80,
  #|    side~,
  #|    align~,
  #|    trigger_variant=@ui.Link,
  #|    trigger_label,
  #|    @html.div(style=["display:flex;flex-direction:column;gap:0.5rem"], [
  #|      @html.strong("Rabbita UI"),
  #|      @html.p(
  #|        style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0"],
  #|        "Native MoonBit components with incremental state.",
  #|      ),
  #|      @html.div(
  #|        style=["display:flex;flex-wrap:wrap;align-items:center;gap:0.75rem"],
  #|        [
  #|          @ui.badge(variant=@ui.Secondary, "Vega"),
  #|          @ui.badge(variant=@ui.Outline, "Inline"),
  #|        ],
  #|      ),
  #|    ]),
  #|  )
  #|}
  #|
  #|let top = hover_card_variant(
  #|  "showcase-hover-card-top",
  #|  @ui.Top,
  #|  @ui.Center,
  #|  "Top-center preview",
  #|)
  #|let left = hover_card_variant(
  #|  "showcase-hover-card-left",
  #|  @ui.Left,
  #|  @ui.End,
  #|  "Left-end preview",
  #|)
  #|
  #|top.view2(left, (top_html, left_html) => {
  #|  @html.div(
  #|    style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,20rem),1fr));gap:1rem;min-width:0"],
  #|    [
  #|      ig_specimen("Top · center", "Hover or focus", top_html),
  #|      ig_specimen("Left · end", "Hoverable content", left_html),
  #|    ],
  #|  )
  #|})

///|
const IgTooltipCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|fn circle_help_icon() -> @html.Html {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=["display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none"],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d="M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0ZM9.1 9a3 3 0 1 1 5.8 1c0 2-2.9 2-2.9 4M12 17h.01",
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|
  #|fn tooltip_variant(
  #|  id : String,
  #|  side : @ui.PopupSide,
  #|  align : @ui.PopupAlign,
  #|  size : @ui.ButtonSize,
  #|  label : String,
  #|) -> @rabbita.Val[@html.Html] {
  #|  @ui.tooltip(
  #|    id~,
  #|    delay=100,
  #|    side~,
  #|    align~,
  #|    show_arrow=true,
  #|    trigger_variant=@ui.Outline,
  #|    trigger_size=size,
  #|    trigger_attrs=@html.Attrs::build().aria_label(label),
  #|    circle_help_icon(),
  #|    label,
  #|  )
  #|}
  #|
  #|let top = tooltip_variant(
  #|  "showcase-tooltip-top",
  #|  @ui.Top,
  #|  @ui.Start,
  #|  @ui.IconSm,
  #|  "Top-start tooltip",
  #|)
  #|let right = tooltip_variant(
  #|  "showcase-tooltip-right",
  #|  @ui.Right,
  #|  @ui.Center,
  #|  @ui.Icon,
  #|  "Right-center tooltip",
  #|)
  #|let bottom = tooltip_variant(
  #|  "showcase-tooltip-bottom",
  #|  @ui.Bottom,
  #|  @ui.End,
  #|  @ui.IconLg,
  #|  "Bottom-end tooltip",
  #|)
  #|let left = tooltip_variant(
  #|  "showcase-tooltip-left",
  #|  @ui.Left,
  #|  @ui.Center,
  #|  @ui.Icon,
  #|  "Left-center tooltip",
  #|)
  #|
  #|top.view4(right, bottom, left, (top_html, right_html, bottom_html, left_html) => {
  #|  @html.div(
  #|    style=["display:grid;width:min(100%,44rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,18rem),1fr));gap:2rem 3rem;min-width:0"],
  #|    [
  #|      ig_specimen("Top · start", "Small icon", top_html),
  #|      ig_specimen("Right · center", "Default icon", right_html),
  #|      ig_specimen("Bottom · end", "Large icon", bottom_html),
  #|      ig_specimen("Left · center", "Default icon", left_html),
  #|    ],
  #|  )
  #|})

///|
const IgSheetCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|fn sheet_variant(
  #|  id : String,
  #|  side : @ui.SheetSide,
  #|  trigger_label : String,
  #|) -> @rabbita.Val[@html.Html] {
  #|  @ui.sheet(id~, scope => {
  #|    @html.fragment([
  #|      @ui.sheet_trigger(scope, variant=@ui.Outline, trigger_label),
  #|      @ui.sheet_content(scope, side~, [
  #|        @ui.sheet_header([
  #|          @ui.sheet_title(scope, trigger_label),
  #|          @ui.sheet_description(
  #|            scope,
  #|            "Placement changes while focus and dismissal behavior stay consistent.",
  #|          ),
  #|        ]),
  #|        @html.div(style=["display:flex;flex-direction:column;gap:1rem"], [
  #|          @ui.label(for_=id + "-email", "Notification email"),
  #|          @ui.input(id=id + "-email", value="team@example.com"),
  #|        ]),
  #|        @ui.sheet_footer(@ui.sheet_close(scope, "Save settings")),
  #|      ]),
  #|    ])
  #|  })
  #|}
  #|
  #|let top = sheet_variant(
  #|  "showcase-sheet-top",
  #|  @ui.SheetTop,
  #|  "Open top sheet",
  #|)
  #|let right = sheet_variant(
  #|  "showcase-sheet-right",
  #|  @ui.SheetRight,
  #|  "Open right sheet",
  #|)
  #|let bottom = sheet_variant(
  #|  "showcase-sheet-bottom",
  #|  @ui.SheetBottom,
  #|  "Open bottom sheet",
  #|)
  #|let left = sheet_variant(
  #|  "showcase-sheet-left",
  #|  @ui.SheetLeft,
  #|  "Open left sheet",
  #|)
  #|
  #|top.view4(right, bottom, left, (top_html, right_html, bottom_html, left_html) => {
  #|  @html.div(
  #|    style=["display:grid;width:min(100%,44rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,18rem),1fr));gap:2rem 3rem;min-width:0"],
  #|    [
  #|      ig_specimen("Top", "Modal", top_html),
  #|      ig_specimen("Right", "Modal", right_html),
  #|      ig_specimen("Bottom", "Modal", bottom_html),
  #|      ig_specimen("Left", "Modal", left_html),
  #|    ],
  #|  )
  #|})

///|
const IgSonnerCode : String =
  #|@ui.sonner(max_toasts=3, position="bottom-right", scope => {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-wrap:wrap;align-items:center;gap:0.5rem"],
  #|    [
  #|      @ui.button(
  #|        size=@ui.Sm,
  #|        on_click=scope.show(
  #|          title="Saved",
  #|          description="The draft remains in this workspace.",
  #|          variant=@ui.ToastDefault,
  #|        ),
  #|        "Default toast",
  #|      ),
  #|      @ui.button(
  #|        size=@ui.Sm,
  #|        variant=@ui.Secondary,
  #|        on_click=scope.show(
  #|          title="Published",
  #|          description="The latest UI preview is live.",
  #|          variant=@ui.ToastSuccess,
  #|        ),
  #|        "Success toast",
  #|      ),
  #|      @ui.button(
  #|        size=@ui.Sm,
  #|        variant=@ui.Destructive,
  #|        on_click=scope.show(
  #|          title="Could not sync",
  #|          description="Check the connection and try again.",
  #|          variant=@ui.ToastDestructive,
  #|        ),
  #|        "Error toast",
  #|      ),
  #|      @ui.button(
  #|        size=@ui.Sm,
  #|        variant=@ui.Ghost,
  #|        on_click=scope.dismiss_all(),
  #|        "Dismiss queue",
  #|      ),
  #|    ],
  #|  )
  #|})

///|
const IgToastCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|@html.div(
  #|  style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,20rem),1fr));gap:1rem;min-width:0"],
  #|  [
  #|    ig_specimen(
  #|      "Default",
  #|      "Neutral status",
  #|      @ui.toast(variant=@ui.ToastDefault, [
  #|        @ui.toast_title("Draft saved"),
  #|        @ui.toast_description("Your changes remain local."),
  #|        @ui.toast_action("View"),
  #|      ]),
  #|    ),
  #|    ig_specimen(
  #|      "Success",
  #|      "Positive status",
  #|      @ui.toast(variant=@ui.ToastSuccess, [
  #|        @ui.toast_title("Published"),
  #|        @ui.toast_description("The latest preview is live."),
  #|      ]),
  #|    ),
  #|    ig_specimen(
  #|      "Destructive",
  #|      "Error status",
  #|      @ui.toast(variant=@ui.ToastDestructive, [
  #|        @ui.toast_title("Could not sync"),
  #|        @ui.toast_description("Check the connection and try again."),
  #|      ]),
  #|    ),
  #|  ],
  #|)

///|
const IgMessageScrollerCode : String =
  #|fn stroke_icon(path : String) -> @html.Html {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=["display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none"],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d=path,
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|
  #|fn arrow_up_icon() -> @html.Html {
  #|  stroke_icon("m18 15-6-6-6 6")
  #|}
  #|
  #|fn arrow_down_icon() -> @html.Html {
  #|  stroke_icon("m6 9 6 6 6-6")
  #|}
  #|
  #|@ui.message_scroller(
  #|  id="showcase-message-scroller",
  #|  default_at_end=true,
  #|  scope => {
  #|    @html.div(style=["position:relative"], [
  #|      @ui.message_scroller_viewport(
  #|        scope~,
  #|        style=["height:13rem"],
  #|        @ui.message_scroller_content(
  #|          style=["display:flex;flex-direction:column;gap:0.625rem;padding:0.75rem"],
  #|          [
  #|            @ui.message_scroller_item(
  #|              @ui.message([
  #|                @ui.message_avatar(@ui.avatar(@ui.avatar_fallback("RA"))),
  #|                @ui.message_content([
  #|                  @ui.message_header("Rabbita · 09:41"),
  #|                  @ui.bubble_group(
  #|                    @ui.bubble(
  #|                      variant=@ui.BubbleSecondary,
  #|                      @ui.bubble_content(
  #|                        "The component catalogue is ready for review.",
  #|                      ),
  #|                    ),
  #|                  ),
  #|                ]),
  #|              ]),
  #|            ),
  #|            @ui.message_scroller_item(
  #|              @ui.message(align=@ui.AlignEnd, [
  #|                @ui.message_avatar(@ui.avatar(@ui.avatar_fallback("YO"))),
  #|                @ui.message_content([
  #|                  @ui.message_header("You · 09:42"),
  #|                  @ui.bubble_group(
  #|                    @ui.bubble(
  #|                      align=@ui.AlignEnd,
  #|                      @ui.bubble_content(
  #|                        "Great — keep state local and the API black-box.",
  #|                      ),
  #|                    ),
  #|                  ),
  #|                  @ui.message_footer("Delivered"),
  #|                ]),
  #|              ]),
  #|            ),
  #|            @ui.message_scroller_item(
  #|              @ui.message([
  #|                @ui.message_avatar(@ui.avatar(@ui.avatar_fallback("RA"))),
  #|                @ui.message_content(
  #|                  @ui.bubble_group(
  #|                    @ui.bubble(
  #|                      variant=@ui.BubbleMuted,
  #|                      @ui.bubble_content(
  #|                        "This scroller tracks both edges and exposes jump controls.",
  #|                      ),
  #|                    ),
  #|                  ),
  #|                ),
  #|              ]),
  #|            ),
  #|            @ui.message_scroller_item(
  #|              scroll_anchor=true,
  #|              @ui.message(align=@ui.AlignEnd, [
  #|                @ui.message_avatar(@ui.avatar(@ui.avatar_fallback("YO"))),
  #|                @ui.message_content(
  #|                  @ui.bubble_group(
  #|                    @ui.bubble(
  #|                      align=@ui.AlignEnd,
  #|                      @ui.bubble_content("Ship the showcase."),
  #|                    ),
  #|                  ),
  #|                ),
  #|              ]),
  #|            ),
  #|          ],
  #|        ),
  #|      ),
  #|      @html.div(
  #|        style=["position:absolute;right:0.625rem;bottom:0.625rem;display:flex;gap:0.375rem"],
  #|        [
  #|          @ui.message_scroller_button(
  #|            scope~,
  #|            direction=@ui.ScrollStart,
  #|            label="Jump to first message",
  #|            size=@ui.IconSm,
  #|            arrow_up_icon(),
  #|          ),
  #|          @ui.message_scroller_button(
  #|            scope~,
  #|            direction=@ui.ScrollEnd,
  #|            label="Jump to latest message",
  #|            size=@ui.IconSm,
  #|            arrow_down_icon(),
  #|          ),
  #|        ],
  #|      ),
  #|    ])
  #|  },
  #|)

///|
const IgResizableCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|let group = @ui.resizable_group(
  #|  id="showcase-resizable",
  #|  default_sizes=[26, 44, 30],
  #|  min_sizes=[16, 24, 18],
  #|  max_sizes=[52, 68, 54],
  #|  orientation=@ui.Horizontal,
  #|  style=["height:14rem;overflow:hidden;border:1px solid var(--rui-border);border-radius:var(--rui-radius)"],
  #|  scope => {
  #|    @html.fragment([
  #|      @ui.resizable_group_panel(
  #|        scope~,
  #|        index=0,
  #|        style=["display:flex;align-items:center;justify-content:center;padding:1.5rem;color:var(--rui-foreground);font-size:0.875rem;line-height:1.25rem;font-weight:500;text-align:center"],
  #|        "Files",
  #|      ),
  #|      @ui.resizable_group_handle(
  #|        scope~,
  #|        between=0,
  #|        with_handle=true,
  #|        aria_label="Resize files and editor",
  #|      ),
  #|      @ui.resizable_group_panel(
  #|        scope~,
  #|        index=1,
  #|        style=["display:flex;align-items:center;justify-content:center;padding:1.5rem;color:var(--rui-foreground);font-size:0.875rem;line-height:1.25rem;font-weight:500;text-align:center"],
  #|        "Editor",
  #|      ),
  #|      @ui.resizable_group_handle(
  #|        scope~,
  #|        between=1,
  #|        with_handle=true,
  #|        aria_label="Resize editor and preview",
  #|      ),
  #|      @ui.resizable_group_panel(
  #|        scope~,
  #|        index=2,
  #|        style=["display:flex;align-items:center;justify-content:center;padding:1.5rem;color:var(--rui-foreground);font-size:0.875rem;line-height:1.25rem;font-weight:500;text-align:center"],
  #|        "Preview",
  #|      ),
  #|    ])
  #|  },
  #|)
  #|let panel_group = @ui.resizable_panel_group(
  #|  id="showcase-resizable-panel-group",
  #|  default_size=42,
  #|  min=24,
  #|  max=72,
  #|  orientation=@ui.Vertical,
  #|  aria_label="Resize preview and console",
  #|  style=[
  #|    "height:14rem;overflow:hidden;border:1px solid var(--rui-border);border-radius:var(--rui-radius)",
  #|    "width:min(100%,32rem);height:14rem;margin-inline:auto",
  #|  ],
  #|  scope => {
  #|    @html.fragment([
  #|      @ui.resizable_panel(
  #|        scope~,
  #|        side=@ui.FirstPanel,
  #|        style=["display:flex;align-items:center;justify-content:center;padding:1.5rem;color:var(--rui-foreground);font-size:0.875rem;line-height:1.25rem;font-weight:500;text-align:center"],
  #|        "Preview",
  #|      ),
  #|      @ui.resizable_handle(
  #|        scope~,
  #|        with_handle=true,
  #|        aria_label="Resize preview and console",
  #|      ),
  #|      @ui.resizable_panel(
  #|        scope~,
  #|        side=@ui.SecondPanel,
  #|        style=["display:flex;align-items:center;justify-content:center;padding:1.5rem;color:var(--rui-foreground);font-size:0.875rem;line-height:1.25rem;font-weight:500;text-align:center"],
  #|        "Console",
  #|      ),
  #|    ])
  #|  },
  #|)
  #|
  #|group.view2(panel_group, (group_html, panel_html) => {
  #|  @html.div(
  #|    style=["display:grid;width:min(100%,50rem);min-width:0;margin-inline:auto;gap:2rem"],
  #|    [
  #|      ig_specimen(
  #|        "Multi-panel",
  #|        "Horizontal · resizable_group",
  #|        group_html,
  #|      ),
  #|      ig_specimen(
  #|        "Two-panel",
  #|        "Vertical · panel_group",
  #|        panel_html,
  #|      ),
  #|    ],
  #|  )
  #|})

///|
const IgScrollAreaCode : String =
  #|fn ig_specimen(label : String, note : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;align-items:flex-start;gap:0.125rem"],
  #|        [
  #|          @html.strong(style=["font-size:0.8125rem;line-height:1.25rem"], label),
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35;text-align:start"],
  #|            note,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(style=["min-width:0"], body),
  #|    ],
  #|  )
  #|}
  #|
  #|let vertical = @ui.scroll_area_with_scrollbar(
  #|  id="showcase-scroll-area",
  #|  orientation=@ui.Vertical,
  #|  style=["height:13rem;border:1px solid var(--rui-border);border-radius:var(--rui-radius)"],
  #|  @html.div(
  #|    style=["display:flex;flex-direction:column;gap:0.625rem;padding:0.875rem 1.25rem 0.875rem 0.875rem"],
  #|    [
  #|      @html.strong("Release checklist"),
  #|      @ui.separator(),
  #|      @html.span("Check semantic roles"),
  #|      @html.span("Check keyboard order"),
  #|      @html.span("Check light and dark themes"),
  #|      @html.span("Check long labels"),
  #|      @html.span("Check narrow containers"),
  #|      @html.span("Check reduced motion"),
  #|      @html.span("Check empty and error states"),
  #|      @html.span("Check server rendering"),
  #|      @html.span("Check native fallback"),
  #|      @html.span("Ready to publish"),
  #|    ],
  #|  ),
  #|)
  #|let horizontal = @ui.scroll_area_with_scrollbar(
  #|  id="showcase-scroll-area-horizontal",
  #|  orientation=@ui.Horizontal,
  #|  style=["width:100%;max-width:100%;height:5.5rem;border:1px solid var(--rui-border);border-radius:var(--rui-radius)"],
  #|  @html.div(
  #|    style=["display:flex;width:max-content;min-width:44rem;gap:0.625rem;padding:0.875rem 1.25rem 1.25rem 0.875rem"],
  #|    [
  #|      @ui.badge(variant=@ui.Secondary, "Keyboard"),
  #|      @ui.badge(variant=@ui.Secondary, "Pointer"),
  #|      @ui.badge(variant=@ui.Secondary, "Touch"),
  #|      @ui.badge(variant=@ui.Secondary, "RTL"),
  #|      @ui.badge(variant=@ui.Secondary, "Measured thumb"),
  #|      @ui.badge(variant=@ui.Secondary, "Native fallback"),
  #|    ],
  #|  ),
  #|)
  #|
  #|vertical.view2(horizontal, (vertical_html, horizontal_html) => {
  #|  @html.div(
  #|    style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,20rem),1fr));gap:1rem;min-width:0"],
  #|    [
  #|      ig_specimen("Vertical", "Measured thumb", vertical_html),
  #|      ig_specimen("Horizontal", "Measured thumb", horizontal_html),
  #|    ],
  #|  )
  #|})
