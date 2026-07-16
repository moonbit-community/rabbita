///|
#warnings("-alert_unstable")
fn audit_render(html : @html.Html) -> String {
  @rabbita.render_to_string(() => @rabbita.Val::constant(html))
}

///|
fn audit_contains(actual : String, expected : String) -> Unit raise {
  if !actual.contains(expected) {
    fail("expected rendered HTML to contain `\{expected}`; got `\{actual}`")
  }
}

///|
fn audit_not_contains(actual : String, unexpected : String) -> Unit raise {
  if actual.contains(unexpected) {
    fail(
      "expected rendered HTML not to contain `\{unexpected}`; got `\{actual}`",
    )
  }
}

///|
fn audit_test_icon(path : String) -> @html.Html {
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
test "native as-child link paths retain semantics and disabled state" {
  let html = audit_render(
    @html.div([
      @rabbita-ui.badge_link(
        href="/status",
        variant=@rabbita-ui.Outline,
        disabled=true,
        aria_label="Unavailable status",
        "Status",
      ),
      @rabbita-ui.item_link(
        href="/workspace",
        variant=@rabbita-ui.ItemMuted,
        size=@rabbita-ui.ItemSm,
        disabled=true,
        aria_label="Unavailable workspace",
        @rabbita-ui.item_content([
          @rabbita-ui.item_title("Workspace"),
          @rabbita-ui.item_description(
            "A deliberately long description that exercises wrapping and the two-line clamp.",
          ),
        ]),
      ),
      @rabbita-ui.attachment(
        @rabbita-ui.attachment_trigger_link(
          href="/files/specification",
          disabled=true,
          aria_label="Unavailable specification",
          "Open",
        ),
      ),
      @rabbita-ui.bubble(
        variant=@rabbita-ui.BubbleSecondary,
        @rabbita-ui.bubble_content_link(
          href="/reply",
          disabled=true,
          aria_label="Unavailable reply",
          "Reply",
        ),
      ),
      @rabbita-ui.marker_link(
        href="/activity",
        variant=@rabbita-ui.MarkerSeparator,
        disabled=true,
        aria_label="Unavailable activity",
        @rabbita-ui.marker_content("Activity"),
      ),
    ]),
  )
  audit_contains(html, "<a")
  audit_contains(html, "href=\"/status\"")
  audit_contains(html, "href=\"/workspace\"")
  audit_contains(html, "href=\"/files/specification\"")
  audit_contains(html, "href=\"/reply\"")
  audit_contains(html, "href=\"/activity\"")
  audit_contains(html, "aria-disabled=\"true\"")
  audit_contains(html, "tabindex=\"-1\"")
  audit_contains(html, "data-disabled=\"\"")
  audit_contains(html, "data-slot=\"badge\" data-variant=\"outline\"")
  audit_contains(
    html, "data-slot=\"item\" data-variant=\"muted\" data-size=\"sm\"",
  )
  audit_contains(html, "data-slot=\"attachment-trigger\"")
  audit_contains(html, "data-slot=\"bubble-content\"")
  audit_contains(html, "data-slot=\"marker\" data-variant=\"separator\"")
  audit_contains(html, "cursor:not-allowed;pointer-events:none;opacity:0.5")
}

///|
test "interactive bubble button follows parent variant and native button state" {
  let html = audit_render(
    @rabbita-ui.bubble(
      variant=@rabbita-ui.BubbleDestructive,
      align=@rabbita-ui.AlignEnd,
      @rabbita-ui.bubble_content_button(
        disabled=true,
        aria_label="Retry unavailable",
        "Retry",
      ),
    ),
  )
  audit_contains(html, "data-slot=\"bubble\"")
  audit_contains(html, "data-variant=\"destructive\"")
  audit_contains(html, "data-align=\"end\"")
  audit_contains(html, "--rui-bubble-bg:var(--rui-destructive-subtle")
  audit_contains(html, "<button")
  audit_contains(html, "type=\"button\"")
  audit_contains(html, "disabled")
  audit_contains(html, "aria-disabled=\"true\"")
  audit_contains(
    html, "background:var(--rui-bubble-bg,var(--rui-primary,oklch(0.205 0 0)))",
  )

  let standalone = audit_render(
    @rabbita-ui.bubble_content_button(aria_label="Retry", "Retry"),
  )
  audit_not_contains(standalone, "--rui-bubble-bg:")
  audit_not_contains(standalone, "--rui-bubble-border:")
}

///|
test "message and bubble recipes cover Vega variants alignment and reactions" {
  let html = audit_render(
    @rabbita-ui.message(
      align=@rabbita-ui.AlignEnd,
      @rabbita-ui.message_content([
        @rabbita-ui.message_header(
          "A long sender label that must stay inside a narrow message row",
        ),
        @rabbita-ui.bubble_group([
          @rabbita-ui.bubble(
            @rabbita-ui.bubble_content(
              "abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz",
            ),
          ),
          @rabbita-ui.bubble(
            variant=@rabbita-ui.BubbleSecondary,
            @rabbita-ui.bubble_content("Secondary"),
          ),
          @rabbita-ui.bubble(
            variant=@rabbita-ui.BubbleMuted,
            @rabbita-ui.bubble_content("Muted"),
          ),
          @rabbita-ui.bubble(
            variant=@rabbita-ui.BubbleTinted,
            @rabbita-ui.bubble_content("Tinted"),
          ),
          @rabbita-ui.bubble(
            variant=@rabbita-ui.BubbleOutline,
            @rabbita-ui.bubble_content("Outline"),
          ),
          @rabbita-ui.bubble(
            variant=@rabbita-ui.BubbleGhost,
            @rabbita-ui.bubble_content("Ghost"),
          ),
          @rabbita-ui.bubble(
            variant=@rabbita-ui.BubbleDestructive,
            align=@rabbita-ui.AlignEnd,
            [
              @rabbita-ui.bubble_content("Destructive"),
              @rabbita-ui.bubble_reactions(
                side=@rabbita-ui.ReactionTop,
                align=@rabbita-ui.AlignStart,
                audit_test_icon("M20 6 9 17l-5-5"),
              ),
              @rabbita-ui.bubble_reactions(
                side=@rabbita-ui.ReactionBottom,
                align=@rabbita-ui.AlignEnd,
                @html.span("2"),
              ),
            ],
          ),
        ]),
        @rabbita-ui.message_footer("Delivered"),
      ]),
    ),
  )
  audit_contains(html, "--rui-message-content-align:flex-end")
  audit_contains(html, "align-self:var(--rui-message-content-align,flex-start)")
  audit_contains(html, "overflow-wrap:break-word;word-break:normal")
  audit_contains(html, "data-variant=\"default\"")
  audit_contains(html, "data-variant=\"secondary\"")
  audit_contains(html, "data-variant=\"muted\"")
  audit_contains(html, "data-variant=\"tinted\"")
  audit_contains(html, "data-variant=\"outline\"")
  audit_contains(html, "data-variant=\"ghost\"")
  audit_contains(html, "data-variant=\"destructive\"")
  audit_contains(html, "max-width:100%")
  audit_contains(html, "light-dark(oklch(from var(--rui-primary")
  audit_contains(html, "--rui-bubble-content-align:flex-end")
  audit_contains(html, "data-side=\"top\" data-align=\"start\"")
  audit_contains(html, "top:0;inset-inline-start:0.75rem")
  audit_contains(html, "data-side=\"bottom\" data-align=\"end\"")
  audit_contains(html, "bottom:0;inset-inline-end:0.75rem")

  let avatar = audit_render(@rabbita-ui.message_avatar("Y"))
  audit_contains(avatar, "min-height:2rem;aspect-ratio:1")
  let themed = audit_render(@rabbita-ui.theme(@html.nothing))
  audit_contains(themed, "[data-slot=\"bubble-reactions\"]:has(button)")
  audit_contains(
    themed, ":is(a,button)[data-slot=\"bubble-content\"]:not(:disabled):not([aria-disabled=\"true\"]):active",
  )
  audit_contains(
    themed, "color-mix(in oklch,var(--rui-secondary,oklch(0.97 0 0)) 95%,var(--rui-foreground",
  )
}

///|
test "button and button-group children expose per-edge merge variables" {
  let html = audit_render(
    @rabbita-ui.button_group([
      @rabbita-ui.button(
        size=@rabbita-ui.IconXs,
        attrs=@html.Attrs::build().aria_label("Previous item"),
        audit_test_icon("m15 18-6-6 6-6"),
      ),
      @rabbita-ui.button_group_text("of 3"),
      @rabbita-ui.button(size=@rabbita-ui.Lg, "Next"),
    ]),
  )
  audit_contains(html, "data-slot=\"button-group\"")
  audit_contains(
    html, "border-top-width:var(--rui-control-border-top-width,var(--rui-control-border-width,1px))",
  )
  audit_contains(
    html, "border-left-width:var(--rui-control-border-left-width,var(--rui-control-border-width,1px))",
  )
  audit_contains(
    html, "border-top-left-radius:var(--rui-control-radius-top-left,var(--rui-control-radius",
  )
  audit_contains(
    html, "border-bottom-right-radius:var(--rui-control-radius-bottom-right,var(--rui-control-radius",
  )
  audit_contains(html, "--rui-button-icon-size:0.75rem")
  audit_contains(html, "--rui-button-padding-inline:1.5rem")
}

///|
test "separator, spinner, and skeleton cover semantic and motion branches" {
  let invalid_ratio = audit_render(
    @rabbita-ui.aspect_ratio(ratio=0.0, "Preview"),
  )
  audit_contains(invalid_ratio, "aspect-ratio:1")

  let decorative = audit_render(@rabbita-ui.separator())
  audit_contains(decorative, "role=\"none\"")
  audit_not_contains(decorative, "aria-orientation")

  let semantic = audit_render(
    @rabbita-ui.separator(orientation=@rabbita-ui.Vertical, decorative=false),
  )
  audit_contains(semantic, "role=\"separator\"")
  audit_contains(semantic, "aria-orientation=\"vertical\"")

  let spinner_html = audit_render(@rabbita-ui.spinner(label="Loading data"))
  audit_contains(spinner_html, "role=\"status\"")
  audit_contains(spinner_html, "aria-label=\"Loading data\"")
  audit_contains(spinner_html, "width=\"16\"")
  audit_contains(spinner_html, "height=\"16\"")
  audit_contains(spinner_html, "viewBox=\"0 0 24 24\"")
  audit_contains(spinner_html, "animation:rui-spin 0.8s linear infinite")
  audit_not_contains(spinner_html, "animateTransform")

  let skeleton_html = audit_render(@rabbita-ui.skeleton())
  audit_contains(skeleton_html, "data-slot=\"skeleton\"")
  audit_contains(skeleton_html, "animation:rui-pulse 2s")
}

///|
test "attachment size orientation and state variables propagate to parts" {
  let html = audit_render(
    @html.div([
      @rabbita-ui.attachment(
        state=@rabbita-ui.AttachmentIdle,
        size=@rabbita-ui.AttachmentXs,
        orientation=@rabbita-ui.AttachmentHorizontal,
        @rabbita-ui.attachment_media("File"),
      ),
      @rabbita-ui.attachment(
        state=@rabbita-ui.AttachmentError,
        size=@rabbita-ui.AttachmentSm,
        orientation=@rabbita-ui.AttachmentVertical,
        [
          @rabbita-ui.attachment_media(
            variant=@rabbita-ui.AttachmentImage,
            "Preview",
          ),
          @rabbita-ui.attachment_content(
            @rabbita-ui.attachment_description("Upload failed"),
          ),
        ],
      ),
      @rabbita-ui.attachment(
        state=@rabbita-ui.AttachmentProcessing,
        @rabbita-ui.attachment_content(
          @rabbita-ui.attachment_title("Processing file"),
        ),
      ),
    ]),
  )
  audit_contains(html, "data-state=\"idle\"")
  audit_contains(html, "data-size=\"xs\"")
  audit_contains(html, "data-orientation=\"horizontal\"")
  audit_contains(html, "--rui-attachment-media-size:1.75rem")
  audit_contains(html, "border-style:dashed")
  audit_contains(html, "data-state=\"error\"")
  audit_contains(html, "data-size=\"sm\"")
  audit_contains(html, "data-orientation=\"vertical\"")
  audit_contains(html, "--rui-attachment-media-width:100%")
  audit_contains(html, "--rui-attachment-icon-size:1.5rem")
  audit_contains(html, "--rui-attachment-image-opacity:0.6")
  audit_contains(html, "--rui-attachment-description-fg:color-mix")
  audit_contains(html, "--rui-attachment-title-animation:rui-shimmer 1.6s")
  audit_contains(html, "animation:var(--rui-attachment-title-animation,none)")
  audit_contains(
    html, "padding-block:var(--rui-attachment-padding-block,0);padding-inline:var(--rui-attachment-padding-inline,0)",
  )

  let themed = audit_render(@rabbita-ui.theme(@html.nothing))
  audit_contains(
    themed, "[data-slot=\"attachment\"]:has(> [data-slot=\"attachment-content\"])",
  )
  audit_contains(
    themed, "--rui-attachment-padding-block:var(--rui-attachment-content-padding-block,0)",
  )
  audit_contains(
    themed, "[data-slot=\"attachment\"]:has(> [data-slot=\"attachment-media\"]):not(:has(> [data-slot=\"attachment-content\"]))",
  )
}

///|
test "alert and card optional tracks do not reserve empty columns" {
  let html = audit_render(
    @html.div([
      @rabbita-ui.alert([
        @rabbita-ui.alert_title("Notice"),
        @rabbita-ui.alert_description("Description"),
      ]),
      @rabbita-ui.card(
        @rabbita-ui.card_header([
          @rabbita-ui.card_title("Title"),
          @rabbita-ui.card_description("Description"),
        ]),
      ),
    ]),
  )
  audit_contains(
    html, "grid-template-columns:var(--rui-alert-columns,0 minmax(0,1fr) auto)",
  )
  audit_contains(html, "column-gap:var(--rui-alert-column-gap,0)")
  audit_contains(
    html, "grid-template-columns:var(--rui-card-header-columns,minmax(0,1fr))",
  )
  audit_contains(html, "column-gap:var(--rui-card-header-column-gap,0)")

  let themed = audit_render(
    @rabbita-ui.theme(
      @rabbita-ui.alert(
        @svg.svg(view_box="0 0 24 24", [@svg.path(d="M12 2v20")]),
      ),
    ),
  )
  audit_contains(themed, "[data-slot=\"alert\"]:has(> svg)")
  audit_contains(themed, "--rui-alert-columns:auto minmax(0,1fr) auto")
  audit_contains(
    themed, "[data-slot=\"card-header\"]:has(> [data-slot=\"card-action\"])",
  )
  audit_contains(themed, "@keyframes rui-shimmer")
}

///|
test "logical-direction and long-content recipes remain narrow-safe" {
  let html = audit_render(
    @rabbita-ui.direction(
      direction=@rabbita-ui.Rtl,
      @html.div([
        @rabbita-ui.item_link(
          href="/rtl",
          @rabbita-ui.item_description(
            "A very long unbroken identifier abcdefghijklmnopqrstuvwxyz0123456789",
          ),
        ),
        @rabbita-ui.message(
          align=@rabbita-ui.AlignEnd,
          @rabbita-ui.message_content("Message"),
        ),
        @rabbita-ui.table(
          @rabbita-ui.table_body(
            @rabbita-ui.table_row(
              @rabbita-ui.table_cell(
                "A long cell that may need horizontal scroll",
              ),
            ),
          ),
        ),
      ]),
    ),
  )
  audit_contains(html, "dir=\"rtl\"")
  audit_contains(html, "text-align:start")
  audit_contains(html, "min-width:0")
  audit_contains(html, "-webkit-line-clamp:2")
  audit_contains(html, "--rui-message-content-align:flex-end")
  audit_contains(html, "overflow-x:auto")
}
