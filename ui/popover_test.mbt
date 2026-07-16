///|
fn popover_test_icon(path : String) -> @html.Html {
  @html.span(
    attrs=@html.Attrs::build().aria_hidden("true"),
    @svg.svg(width=16, height=16, view_box="0 0 24 24", [
      @svg.path(
        d=path,
        fill="none",
        stroke="currentColor",
        stroke_width=2,
        attrs=@svg.Attrs::build()
          .stroke_linecap("round")
          .stroke_linejoin("round"),
      ),
    ]),
  )
}

///|
test "popover exposes native top-layer dialog semantics and CSS anchoring" {
  let attrs = @html.Attrs::build().data_set("owner", "caller")
  let html = render(
    @rabbita-ui.popover_content(
      id="account-popover",
      trigger_id="account-popover-trigger",
      open=true,
      side=Right,
      align=Start,
      side_offset=8,
      align_offset=2,
      title_id="account-popover-title",
      description_id="account-popover-description",
      attrs~,
      style=["width:24rem", "background:rebeccapurple"],
      [
        @rabbita-ui.popover_header([
          @rabbita-ui.popover_title(id="account-popover-title", "Account"),
          @rabbita-ui.popover_description(
            id="account-popover-description",
            "Manage the current account.",
          ),
        ]),
        @rabbita-ui.popover_close_button(target_id="account-popover", "Done"),
      ],
    ),
  )
  assert_contains(html, "id=\"account-popover\"")
  assert_contains(html, "popover=\"auto\"")
  assert_contains(html, "role=\"dialog\"")
  assert_contains(html, "tabindex=\"-1\"")
  assert_contains(html, "data-modal=\"false\"")
  assert_contains(html, "data-initial-focus=\"true\"")
  assert_contains(html, "data-restore-focus=\"true\"")
  assert_contains(html, "aria-labelledby=\"account-popover-title\"")
  assert_contains(html, "aria-describedby=\"account-popover-description\"")
  assert_contains(html, "data-state=\"open\"")
  assert_contains(html, "data-open=\"\"")
  assert_contains(html, "data-side=\"right\"")
  assert_contains(html, "data-align=\"start\"")
  assert_contains(html, "data-side-offset=\"8\"")
  assert_contains(html, "data-align-offset=\"2\"")
  assert_contains(html, "position-anchor:--rui-anchor_")
  assert_contains(html, "position-area:right span-y-end")
  assert_contains(
    html, "position-try-fallbacks:flip-block,flip-inline,flip-block flip-inline",
  )
  assert_not_contains(html, "-10000px")
  assert_contains(html, "data-slot=\"popover-header\"")
  assert_contains(html, "data-slot=\"popover-title\"")
  assert_contains(html, "data-slot=\"popover-description\"")
  assert_contains(html, "data-slot=\"popover-close\"")
  assert_contains(html, "width:24rem;background:rebeccapurple")

  let original = render(@html.div(attrs~, @html.nothing))
  assert_contains(original, "data-owner=\"caller\"")
  assert_not_contains(original, "data-slot")
  assert_not_contains(original, "data-state")
}

///|
test "modal popover uses native dialog focus containment" {
  let html = render(
    @rabbita-ui.popover_content(
      id="modal-popover",
      trigger_id="modal-popover-trigger",
      open=true,
      modal=true,
      initial_focus_id="modal-popover-name",
      final_focus_id="after-modal-popover",
      @html.input(id="modal-popover-name", value="Ada"),
    ),
  )
  assert_contains(html, "<dialog")
  assert_contains(html, "id=\"modal-popover\"")
  assert_contains(html, "closedby=\"any\"")
  assert_contains(html, "role=\"dialog\"")
  assert_contains(html, "aria-modal=\"true\"")
  assert_contains(html, "data-modal=\"true\"")
  assert_contains(html, "data-initial-focus-id=\"modal-popover-name\"")
  assert_contains(html, "data-final-focus-id=\"after-modal-popover\"")
  assert_not_contains(html, "popover=\"auto\"")
}

///|
test "popover trigger links its dialog and accepts caller style overrides" {
  let html = render(
    @rabbita-ui.popover_trigger(
      target_id="command-popover",
      open=true,
      variant=Secondary,
      size=Sm,
      style=["background:rebeccapurple"],
      "Commands",
    ),
  )
  assert_contains(html, "type=\"button\"")
  assert_contains(html, "aria-haspopup=\"dialog\"")
  assert_contains(html, "aria-expanded=\"true\"")
  assert_contains(html, "aria-controls=\"command-popover\"")
  assert_contains(html, "data-slot=\"popover-trigger\"")
  assert_contains(html, "data-variant=\"secondary\"")
  assert_contains(html, "data-size=\"sm\"")
  assert_contains(html, "id=\"command-popover-trigger\"")
  assert_contains(html, "anchor-name:--rui-anchor_")
  assert_contains(html, "background:rebeccapurple")
}

///|
test "popover anchor supplies the content positioning reference" {
  let attrs = @html.Attrs::build().data_set("owner", "caller")
  let html = render(
    @html.div([
      @rabbita-ui.popover_anchor(
        id="custom-popover-anchor",
        attrs~,
        style=["min-width:10rem"],
        @rabbita-ui.popover_trigger(
          target_id="custom-popover",
          id="custom-popover-trigger",
          "Custom trigger",
        ),
      ),
      @rabbita-ui.popover_content(
        id="custom-popover",
        trigger_id="custom-popover-anchor",
        "Anchored content",
      ),
    ]),
  )
  assert_contains(html, "id=\"custom-popover-anchor\"")
  assert_contains(html, "data-slot=\"popover-anchor\"")
  assert_contains(html, "position:relative;display:inline-flex")
  assert_contains(html, "anchor-name:--rui-anchor_")
  assert_contains(html, "min-width:10rem")
  assert_contains(html, "data-trigger-id=\"custom-popover-anchor\"")
  assert_contains(html, "id=\"custom-popover-trigger\"")

  let original = render(@html.span(attrs~, @html.nothing))
  assert_contains(original, "data-owner=\"caller\"")
  assert_not_contains(original, "data-slot")
}

///|
test "popover owns and renders its initial incremental state" {
  let html = render_incremental(() => {
    @rabbita-ui.popover(
      id="filters-popover",
      default_open=true,
      side=Bottom,
      align=End,
      title_id="filters-title",
      trigger_style=["min-width:8rem"],
      content_style=["width:20rem"],
      "Filters",
      @rabbita-ui.popover_title(id="filters-title", "Filters"),
    )
  })
  assert_contains(html, "id=\"filters-popover-trigger\"")
  assert_contains(html, "id=\"filters-popover\"")
  assert_contains(html, "aria-expanded=\"true\"")
  assert_contains(html, "data-state=\"open\"")
  assert_contains(html, "data-side=\"bottom\"")
  assert_contains(html, "data-align=\"end\"")
  assert_contains(html, "min-width:8rem")
  assert_contains(html, "width:20rem")

  // These commands form the black-box imperative control surface.
  ignore(@rabbita-ui.popover_open("filters-popover"))
  ignore(@rabbita-ui.popover_close("filters-popover"))
  ignore(@rabbita-ui.popover_toggle("filters-popover"))
}

///|
test "disabled popover normalizes an open default to closed" {
  let html = render_incremental(() => {
    @rabbita-ui.popover(
      id="disabled-popover",
      default_open=true,
      disabled=true,
      "Unavailable",
      "Cannot open",
    )
  })
  assert_contains(html, "disabled")
  assert_contains(html, "aria-disabled=\"true\"")
  assert_contains(html, "aria-expanded=\"false\"")
  assert_contains(html, "data-state=\"closed\"")
  assert_not_contains(html, "data-state=\"open\"")
}

///|
test "tooltip provider and parts expose Vega and native semantics" {
  let provider = render(
    @rabbita-ui.tooltip_provider(
      delay=350,
      close_delay=75,
      style=["--rui-tooltip-test:1"],
      "Shared tooltip configuration",
    ),
  )
  assert_contains(provider, "data-slot=\"tooltip-provider\"")
  assert_contains(provider, "data-delay=\"350\"")
  assert_contains(provider, "data-close-delay=\"75\"")
  assert_contains(provider, "data-timeout=\"400\"")
  assert_contains(provider, "display:contents")
  assert_contains(provider, "--rui-tooltip-test:1")

  let trigger = render(
    @rabbita-ui.tooltip_trigger(
      content_id="save-tooltip",
      open=true,
      size=IconSm,
      attrs=@html.Attrs::build().aria_label("Save"),
      popover_test_icon(
        "M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2ZM17 21v-8H7v8M7 3v5h8",
      ),
    ),
  )
  assert_contains(trigger, "data-slot=\"tooltip-trigger\"")
  assert_contains(trigger, "aria-describedby=\"save-tooltip\"")
  assert_contains(trigger, "data-state=\"open\"")
  assert_contains(trigger, "aria-label=\"Save\"")
  assert_contains(trigger, "id=\"save-tooltip-trigger\"")
  assert_contains(trigger, "anchor-name:--rui-anchor_")

  let content = render(
    @rabbita-ui.tooltip_content(
      id="save-tooltip",
      trigger_id="save-tooltip-trigger",
      open=true,
      side=Left,
      align=End,
      style=["background:rebeccapurple"],
      arrow_style=["background:rebeccapurple"],
      "Save changes",
    ),
  )
  assert_contains(content, "popover=\"manual\"")
  assert_contains(content, "role=\"tooltip\"")
  assert_contains(content, "data-slot=\"tooltip-content\"")
  assert_contains(content, "data-initial-focus=\"false\"")
  assert_contains(content, "data-restore-focus=\"false\"")
  assert_contains(content, "data-slot=\"tooltip-content-body\"")
  assert_contains(content, "data-slot=\"tooltip-arrow\"")
  assert_contains(content, "aria-hidden=\"true\"")
  assert_contains(content, "data-side=\"left\"")
  assert_contains(content, "position-anchor:--rui-anchor_")
  assert_contains(content, "position-area:left span-y-start")
  assert_contains(content, "data-align=\"end\"")
  assert_contains(content, "background:rebeccapurple")
}

///|
test "tooltip provider normalizes delays and exposes instant phase timeout" {
  let html = render(
    @rabbita-ui.tooltip_provider(
      delay=-10,
      close_delay=-20,
      timeout=650,
      "Tooltips",
    ),
  )
  assert_contains(html, "data-delay=\"0\"")
  assert_contains(html, "data-close-delay=\"0\"")
  assert_contains(html, "data-timeout=\"650\"")
}

///|
test "tooltip root owns incremental open state and behavior options" {
  let attrs = @html.Attrs::build().data_set("owner", "caller")
  let html = render_incremental(() => {
    @rabbita-ui.tooltip(
      id="copy-tooltip",
      default_open=true,
      delay=120,
      close_delay=30,
      close_on_click=false,
      hoverable=false,
      side=Bottom,
      attrs~,
      trigger_style=["color:rebeccapurple"],
      content_style=["max-width:12rem"],
      "Copy",
      "Copy to clipboard",
    )
  })
  assert_contains(html, "id=\"copy-tooltip-root\"")
  assert_contains(html, "id=\"copy-tooltip-trigger\"")
  assert_contains(html, "id=\"copy-tooltip\"")
  assert_contains(html, "data-slot=\"tooltip\"")
  assert_contains(html, "data-delay=\"120\"")
  assert_contains(html, "data-close-delay=\"30\"")
  assert_contains(html, "data-close-on-click=\"false\"")
  assert_contains(html, "data-hoverable=\"false\"")
  assert_contains(html, "aria-describedby=\"copy-tooltip\"")
  assert_contains(html, "role=\"tooltip\"")
  assert_contains(html, "data-state=\"open\"")
  assert_contains(html, "color:rebeccapurple")
  assert_contains(html, "max-width:12rem")

  let original = render(@html.div(attrs~, @html.nothing))
  assert_contains(original, "data-owner=\"caller\"")
  assert_not_contains(original, "data-slot")
  assert_not_contains(original, "data-state")

  ignore(@rabbita-ui.tooltip_open("copy-tooltip"))
  ignore(@rabbita-ui.tooltip_close("copy-tooltip"))
  ignore(@rabbita-ui.tooltip_toggle("copy-tooltip"))
}

///|
test "closed tooltip omits the trigger description relationship and arrow" {
  let trigger = render(
    @rabbita-ui.tooltip_trigger(content_id="closed-tooltip", open=false, "Help"),
  )
  assert_not_contains(trigger, "aria-describedby")
  assert_contains(trigger, "data-state=\"closed\"")

  let content = render(
    @rabbita-ui.tooltip_content(
      id="closed-tooltip",
      trigger_id="closed-tooltip-trigger",
      show_arrow=false,
      "Hidden help",
    ),
  )
  assert_contains(content, "data-state=\"closed\"")
  assert_not_contains(content, "data-slot=\"tooltip-arrow\"")
  assert_contains(content, "visibility:hidden")
  assert_contains(content, "opacity:0")
  assert_contains(content, "pointer-events:none")
}
