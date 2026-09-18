///|
fn semantic_navigation_fixture() -> Html {
  @fixture.section(
    "fixture-section-semantic-navigation",
    "Navigation Semantics",
    [
      @rui.breadcrumb(
        aria_label="Fixture breadcrumb",
        @rui.breadcrumb_list([
          @rui.breadcrumb_item(
            @rui.breadcrumb_link(href="#fixture-main", "Fixtures"),
          ),
          @rui.breadcrumb_separator(),
          @rui.breadcrumb_item(@rui.breadcrumb_page("Semantic components")),
        ]),
      ),
      @rui.pagination(
        aria_label="Fixture pagination",
        @rui.pagination_content([
          @rui.pagination_item(
            @rui.pagination_previous(href="#fixture-main", disabled=true),
          ),
          @rui.pagination_item(
            @rui.pagination_link(
              href="#fixture-main",
              is_active=true,
              aria_label="Fixture page 1",
              "1",
            ),
          ),
          @rui.pagination_item(@rui.pagination_ellipsis()),
          @rui.pagination_item(
            @rui.pagination_next(href="#fixture-section-semantic-data"),
          ),
        ]),
      ),
      @rui.badge(variant=Secondary, "Semantic badge"),
      @rui.badge_link(
        href="#fixture-main",
        disabled=true,
        aria_label="Unavailable fixture badge",
        "Unavailable",
      ),
      @rui.marker(variant=MarkerBorder, [
        @rui.marker_icon("●"),
        @rui.marker_content("Fixture milestone"),
      ]),
    ],
  )
}
