///|
test "breadcrumb is semantic and composable" {
  let html = render(
    @rabbita-ui.breadcrumb(
      @rabbita-ui.breadcrumb_list([
        @rabbita-ui.breadcrumb_item(
          @rabbita-ui.breadcrumb_link(href="/docs", "Docs"),
        ),
        @rabbita-ui.breadcrumb_separator(),
        @rabbita-ui.breadcrumb_item(@rabbita-ui.breadcrumb_page("Components")),
      ]),
    ),
  )
  assert_contains(html, "<nav")
  assert_contains(html, "aria-label=\"breadcrumb\"")
  assert_contains(html, "data-slot=\"breadcrumb\"")
  assert_contains(html, "<ol")
  assert_contains(html, "data-slot=\"breadcrumb-list\"")
  assert_contains(html, "<a")
  assert_contains(html, "href=\"/docs\"")
  assert_contains(html, "data-slot=\"breadcrumb-link\"")
  assert_contains(
    html, "color:var(--rui-link-fg,var(--rui-link-base-fg,inherit))",
  )
  assert_contains(html, "role=\"presentation\"")
  assert_contains(html, "aria-hidden=\"true\"")
  assert_contains(html, "width:0.875rem")
  assert_contains(html, "aria-current=\"page\"")
  assert_contains(html, "aria-disabled=\"true\"")
  assert_contains(html, "data-state=\"current\"")
}

///|
test "breadcrumb allows custom separators and appends caller style" {
  let html = render(
    @rabbita-ui.breadcrumb_separator(children=@html.text("/"), style=[
      "color:rebeccapurple",
    ]),
  )
  assert_contains(html, ">/</li>")
  assert_contains(html, "color:inherit;color:rebeccapurple")
  assert_not_contains(html, "data-icon=\"inline-end\"")

  let link_html = render(
    @rabbita-ui.breadcrumb_link(
      href="/custom",
      style=["color:rebeccapurple"],
      "Custom",
    ),
  )
  assert_contains(
    link_html, "color:var(--rui-link-fg,var(--rui-link-base-fg,inherit));text-decoration:none",
  )
  assert_contains(link_html, "color:rebeccapurple")
}

///|
test "pagination uses native anchors and exposes active state" {
  let html = render(
    @rabbita-ui.pagination(
      @rabbita-ui.pagination_content([
        @rabbita-ui.pagination_item(
          @rabbita-ui.pagination_previous(href="?page=1"),
        ),
        @rabbita-ui.pagination_item(
          @rabbita-ui.pagination_link(href="?page=2", is_active=true, "2"),
        ),
        @rabbita-ui.pagination_item(@rabbita-ui.pagination_ellipsis()),
        @rabbita-ui.pagination_item(@rabbita-ui.pagination_next(href="?page=3")),
      ]),
    ),
  )
  assert_contains(html, "<nav")
  assert_contains(html, "role=\"navigation\"")
  assert_contains(html, "aria-label=\"pagination\"")
  assert_contains(html, "data-slot=\"pagination-content\"")
  assert_contains(html, "flex-wrap:nowrap")
  assert_not_contains(html, "flex-wrap:wrap")
  assert_contains(html, "data-slot=\"pagination-item\"")
  assert_contains(html, "href=\"?page=2\"")
  assert_contains(html, "data-slot=\"pagination-link\"")
  assert_contains(html, "data-active=\"true\"")
  assert_contains(html, "data-state=\"active\"")
  assert_contains(html, "aria-current=\"page\"")
  assert_contains(html, "aria-label=\"Go to previous page\"")
  assert_contains(html, "aria-label=\"Go to next page\"")
  assert_contains(html, "data-direction=\"previous\"")
  assert_contains(html, "data-direction=\"next\"")
  assert_contains(html, "width:1rem")
  assert_contains(html, ">Previous</span>")
  assert_contains(html, ">Next</span>")
  assert_contains(html, "data-variant=\"outline\"")
  assert_contains(html, "data-variant=\"ghost\"")
  assert_contains(
    html, "background:var(--rui-button-bg,var(--rui-button-base-bg,transparent))",
  )
  assert_contains(
    html, "color:var(--rui-button-fg,var(--rui-button-base-fg,currentColor))",
  )
  assert_contains(
    html, "box-shadow:var(--rui-button-shadow,var(--rui-button-base-shadow,none))",
  )
}

///|
test "pagination disabled links remain semantic and non-tabbable" {
  let html = render(
    @rabbita-ui.pagination(
      @rabbita-ui.pagination_content([
        @rabbita-ui.pagination_item(
          @rabbita-ui.pagination_previous(href="?page=1", disabled=true),
        ),
        @rabbita-ui.pagination_item(
          @rabbita-ui.pagination_link(href="?page=2", disabled=true, "2"),
        ),
        @rabbita-ui.pagination_item(
          @rabbita-ui.pagination_next(href="?page=3", disabled=true),
        ),
      ]),
    ),
  )
  assert_contains(html, "aria-disabled=\"true\"")
  assert_contains(html, "data-disabled=\"\"")
  assert_contains(html, "tabindex=\"-1\"")
  assert_contains(html, "cursor:not-allowed;pointer-events:none;opacity:0.5")
}

///|
test "navigation components preserve caller attrs" {
  let attrs = @html.Attrs::build().data_set("owner", "caller")
  ignore(@rabbita-ui.pagination_link(href="/", attrs~, "1"))
  let original = render(@html.span(attrs~, @html.nothing))
  assert_contains(original, "data-owner=\"caller\"")
  assert_not_contains(original, "data-slot")
  assert_not_contains(original, "data-state")
}
