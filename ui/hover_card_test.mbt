///|
#cfg(target="js")
extern "js" fn install_hover_card_test_window() =
  #| () => {
  #|   if (typeof globalThis.window === "undefined") {
  #|     globalThis.window = { requestAnimationFrame: () => 0 };
  #|   }
  #| }

///|
#warnings("-alert_unstable")
#cfg(target="js")
fn render_incremental_hover_card(
  builder : () -> @rabbita.Val[@html.Html],
) -> String {
  install_hover_card_test_window()
  ignore(@rabbita.new(builder))
  @rabbita.render_to_string(builder)
}

///|
#warnings("-alert_unstable")
#cfg(not(target="js"))
fn render_incremental_hover_card(
  builder : () -> @rabbita.Val[@html.Html],
) -> String {
  @rabbita.render_to_string(builder)
}

///|
test "hover card trigger is a native link" {
  let html = render(
    @rabbita-ui.hover_card_trigger(
      content_id="profile-card",
      href="/people/ada",
      open=true,
      open_delay=125,
      close_delay=45,
      variant=Link,
      size=Sm,
      rel="author",
      style=["color:rebeccapurple"],
      "Ada Lovelace",
    ),
  )
  assert_contains(html, "<a")
  assert_contains(html, "href=\"/people/ada\"")
  assert_contains(html, "rel=\"author\"")
  assert_contains(html, "data-slot=\"hover-card-trigger\"")
  assert_contains(html, "data-state=\"open\"")
  assert_contains(html, "data-popup-open=\"\"")
  assert_contains(html, "data-delay=\"125\"")
  assert_contains(html, "data-close-delay=\"45\"")
  assert_contains(html, "data-variant=\"link\"")
  assert_contains(html, "data-size=\"sm\"")
  assert_contains(html, "aria-expanded=\"true\"")
  assert_contains(html, "aria-controls=\"profile-card\"")
  assert_contains(html, "text-decoration-line:underline")
  assert_contains(html, "color:rebeccapurple")
  assert_contains(html, ">Ada Lovelace</a>")
}

///|
test "hover card content exposes native light-dismiss and Vega surface" {
  let attrs = @html.Attrs::build().data_set("owner", "caller")
  let html = render(
    @rabbita-ui.hover_card_content(
      id="profile-card",
      trigger_id="profile-card-trigger",
      open=true,
      side=Right,
      align=Start,
      side_offset=9,
      align_offset=3,
      aria_labelledby="profile-title",
      aria_describedby="profile-summary",
      attrs~,
      style=["width:20rem", "background:rebeccapurple"],
      @html.div("Profile preview"),
    ),
  )
  assert_contains(html, "id=\"profile-card\"")
  assert_contains(html, "popover=\"auto\"")
  assert_contains(html, "tabindex=\"-1\"")
  assert_contains(html, "data-initial-focus=\"false\"")
  assert_contains(html, "data-restore-focus=\"false\"")
  assert_contains(html, "data-slot=\"hover-card-content\"")
  assert_contains(html, "data-state=\"open\"")
  assert_contains(html, "data-side=\"right\"")
  assert_contains(html, "data-align=\"start\"")
  assert_contains(html, "data-side-offset=\"9\"")
  assert_contains(html, "data-align-offset=\"3\"")
  assert_contains(html, "aria-labelledby=\"profile-title\"")
  assert_contains(html, "aria-describedby=\"profile-summary\"")
  assert_contains(html, "width:16rem")
  assert_contains(html, "border:1px solid var(--rui-border")
  assert_contains(html, "padding:1rem")
  assert_contains(html, "box-shadow:0 4px 6px -1px")
  assert_contains(html, "width:20rem;background:rebeccapurple")

  let original = render(@html.div(attrs~, @html.nothing))
  assert_contains(original, "data-owner=\"caller\"")
  assert_not_contains(original, "data-slot")
  assert_not_contains(original, "data-state")
}

///|
test "closed hover card remains hidden without event binding" {
  let html = render(
    @rabbita-ui.hover_card_content(
      id="closed-profile-card",
      trigger_id="closed-profile-card-trigger",
      open=false,
      "Hidden profile preview",
    ),
  )
  assert_contains(html, "data-state=\"closed\"")
  assert_contains(html, "visibility:hidden")
  assert_contains(html, "opacity:0")
  assert_contains(html, "pointer-events:none")
}

///|
test "hover card owns incremental open delay and positioning state" {
  let attrs = @html.Attrs::build().data_set("owner", "caller")
  let html = render_incremental_hover_card(() => {
    @rabbita-ui.hover_card(
      id="next-profile",
      href="/nextjs",
      default_open=true,
      open_delay=180,
      close_delay=70,
      hoverable=false,
      side=Top,
      align=End,
      side_offset=8,
      align_offset=2,
      aria_labelledby="next-title",
      aria_describedby="next-summary",
      attrs~,
      style=["--hover-card-test:1"],
      trigger_style=["color:rebeccapurple"],
      content_style=["width:18rem"],
      "@nextjs",
      @html.div([
        @html.strong(id="next-title", "Next.js"),
        @html.p(id="next-summary", "The React Framework for the Web"),
      ]),
    )
  })
  assert_contains(html, "id=\"next-profile-root\"")
  assert_contains(html, "id=\"next-profile-trigger\"")
  assert_contains(html, "id=\"next-profile\"")
  assert_contains(html, "href=\"/nextjs\"")
  assert_contains(html, "data-slot=\"hover-card\"")
  assert_contains(html, "data-slot=\"hover-card-trigger\"")
  assert_contains(html, "data-slot=\"hover-card-content\"")
  assert_contains(html, "data-open-delay=\"180\"")
  assert_contains(html, "data-delay=\"180\"")
  assert_contains(html, "data-close-delay=\"70\"")
  assert_contains(html, "data-hoverable=\"false\"")
  assert_contains(html, "data-state=\"open\"")
  assert_contains(html, "aria-expanded=\"true\"")
  assert_contains(html, "aria-controls=\"next-profile\"")
  assert_contains(html, "aria-labelledby=\"next-title\"")
  assert_contains(html, "aria-describedby=\"next-summary\"")
  assert_contains(html, "data-side=\"top\"")
  assert_contains(html, "data-align=\"end\"")
  assert_contains(html, "data-side-offset=\"8\"")
  assert_contains(html, "data-align-offset=\"2\"")
  assert_contains(html, "popover=\"auto\"")
  assert_contains(html, "--hover-card-test:1")
  assert_contains(html, "color:rebeccapurple")
  assert_contains(html, "width:18rem")

  let original = render(@html.div(attrs~, @html.nothing))
  assert_contains(original, "data-owner=\"caller\"")
  assert_not_contains(original, "data-slot")
  assert_not_contains(original, "data-state")
}

///|
test "disabled hover card normalizes its initial state and delays" {
  let html = render_incremental_hover_card(() => {
    @rabbita-ui.hover_card(
      id="disabled-profile",
      href="/unavailable",
      default_open=true,
      disabled=true,
      open_delay=-1,
      close_delay=-10,
      "Unavailable profile",
      "Cannot preview this profile",
    )
  })
  assert_contains(html, "data-disabled=\"\"")
  assert_contains(html, "aria-disabled=\"true\"")
  assert_contains(html, "tabindex=\"-1\"")
  assert_contains(html, "aria-expanded=\"false\"")
  assert_contains(html, "data-open-delay=\"0\"")
  assert_contains(html, "data-close-delay=\"0\"")
  assert_contains(html, "data-state=\"closed\"")
  assert_not_contains(html, "data-popup-open")
}
