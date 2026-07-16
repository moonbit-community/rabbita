///|
#cfg(target="js")
extern "js" fn install_incremental_cc_test_window() =
  #| () => {
  #|   if (typeof globalThis.window === "undefined") {
  #|     globalThis.window = { requestAnimationFrame: () => 0 };
  #|   }
  #| }

///|
#warnings("-alert_unstable")
#cfg(target="js")
fn render_incremental_cc(builder : () -> @rabbita.Val[@html.Html]) -> String {
  install_incremental_cc_test_window()
  ignore(@rabbita.new(builder))
  @rabbita.render_to_string(builder)
}

///|
#warnings("-alert_unstable")
#cfg(not(target="js"))
fn render_incremental_cc(builder : () -> @rabbita.Val[@html.Html]) -> String {
  @rabbita.render_to_string(builder)
}

///|
test "calendar date construction normalizes invalid fields" {
  let date = @rabbita-ui.calendar_date(year=2024, month=2, day=31)
  assert_eq(date.year(), 2024)
  assert_eq(date.month(), 2)
  assert_eq(date.day(), 29)
  assert_eq(date.to_iso_string(), "2024-02-29")
}

///|
test "calendar black-box renders a semantic selected month" {
  let attrs = @html.Attrs::build().data_set("owner", "caller")
  let day_attrs = @html.Attrs::build().data_set("day-owner", "caller")
  let html = render_incremental_cc(() => {
    @rabbita-ui.calendar(
      default_month=@rabbita-ui.calendar_date(year=2026, month=7, day=1),
      default_selected=@rabbita-ui.calendar_date(year=2026, month=7, day=15),
      today=@rabbita-ui.calendar_date(year=2026, month=7, day=16),
      id="release-calendar",
      aria_label="Release calendar",
      attrs~,
      day_attrs~,
      style=["background:rebeccapurple"],
      day_style=["border-radius:2px"],
    )
  })
  assert_contains(html, "data-slot=\"calendar\"")
  assert_contains(html, "role=\"group\"")
  assert_contains(html, "aria-label=\"Release calendar\"")
  assert_contains(html, "id=\"release-calendar-caption\"")
  assert_contains(html, ">July 2026</span>")
  assert_contains(html, "<table")
  assert_contains(html, "data-slot=\"calendar-grid\"")
  assert_contains(html, "role=\"grid\"")
  assert_contains(html, "aria-labelledby=\"release-calendar-caption\"")
  assert_contains(html, "scope=\"col\"")
  assert_contains(html, "abbr=\"Sunday\"")
  assert_contains(html, "data-day=\"2026-06-28\"")
  assert_contains(html, "data-outside-day=\"\"")
  assert_contains(html, "data-day=\"2026-07-15\"")
  assert_contains(html, "data-selected-single=\"true\"")
  assert_contains(html, "data-focused=\"\"")
  assert_contains(html, "tabindex=\"0\"")
  assert_contains(html, "tabindex=\"-1\"")
  assert_contains(html, "aria-selected=\"true\"")
  assert_contains(html, "data-day=\"2026-07-16\"")
  assert_contains(html, "aria-current=\"date\"")
  assert_contains(html, "aria-label=\"Go to previous month\"")
  assert_contains(html, "aria-label=\"Go to next month\"")
  assert_contains(html, "<svg")
  assert_contains(html, "width=\"16\"")
  assert_contains(html, "height=\"16\"")
  assert_not_contains(html, "width:0.4375rem")
  assert_contains(html, "data-day-owner=\"caller\"")
  assert_contains(html, "background:rebeccapurple")
  assert_contains(html, "border-radius:2px")
  assert_contains(
    html, "background:var(--rui-calendar-bg,var(--rui-calendar-base-bg,transparent))",
  )
  assert_contains(
    html, "border-color:var(--rui-calendar-border,var(--rui-calendar-base-border,transparent))",
  )
  assert_contains(
    html, "box-shadow:var(--rui-calendar-shadow,var(--rui-calendar-base-shadow,none))",
  )
  assert_element_tag_contains(
    html, "data-day=\"2026-07-15\"", "--rui-calendar-base-bg:var(--rui-primary",
  )
  assert_element_tag_contains(
    html, "data-day=\"2026-07-16\"", "--rui-calendar-base-bg:var(--rui-accent",
  )

  let original = render(@html.div(attrs~, @html.nothing))
  assert_contains(original, "data-owner=\"caller\"")
  assert_not_contains(original, "data-slot")
  assert_not_contains(original, "role=\"group\"")
  let original_day = render(@html.div(attrs=day_attrs, @html.nothing))
  assert_contains(original_day, "data-day-owner=\"caller\"")
  assert_not_contains(original_day, "data-day=")
}

///|
test "calendar owns initial month and can hide outside dates" {
  let month = @rabbita-ui.calendar_date(year=2025, month=2, day=18)
  let selected = @rabbita-ui.calendar_date(year=2025, month=2, day=28)
  let html = render_incremental_cc(() => {
    @rabbita-ui.calendar(
      default_month=month,
      default_selected=selected,
      show_outside_days=false,
    )
  })
  assert_contains(html, ">February 2025</span>")
  assert_contains(html, "data-month=\"2025-02-01\"")
  assert_contains(html, "data-day=\"2025-02-28\"")
  assert_contains(html, "data-selected-single=\"true\"")
  assert_contains(html, "visibility:hidden")
  assert_not_contains(html, "data-day=\"2025-01-26\"")
}

///|
test "carousel black-box exposes compound scope and slide state" {
  let attrs = @html.Attrs::build().data_set("owner", "caller")
  let item_attrs = @html.Attrs::build().data_set("item-owner", "caller")
  let html = render_incremental_cc(() => {
    @rabbita-ui.carousel(
      default_index=1,
      count=3,
      id="stories",
      aria_label="Customer stories",
      attrs~,
      style=["max-width:30rem"],
      scope => {
        [
          @rabbita-ui.carousel_content(scope~, track_style=["gap:0.25rem"], [
            @rabbita-ui.carousel_item(
              scope~,
              index=0,
              attrs=item_attrs,
              @html.p("First"),
            ),
            @rabbita-ui.carousel_item(
              scope~,
              index=1,
              attrs=item_attrs,
              @html.p("Second"),
            ),
            @rabbita-ui.carousel_item(
              scope~,
              index=2,
              attrs=item_attrs,
              @html.p("Third"),
            ),
          ]),
          @rabbita-ui.carousel_previous(scope~),
          @rabbita-ui.carousel_next(scope~),
        ]
      },
    )
  })
  assert_contains(html, "data-slot=\"carousel\"")
  assert_contains(html, "role=\"region\"")
  assert_contains(html, "aria-roledescription=\"carousel\"")
  assert_contains(html, "aria-label=\"Customer stories\"")
  assert_contains(html, "data-active-index=\"1\"")
  assert_contains(html, "data-count=\"3\"")
  assert_contains(html, "data-max-snap-index=\"2\"")
  assert_contains(html, "data-slot=\"carousel-content\"")
  assert_contains(html, "data-slot=\"carousel-track\"")
  assert_contains(html, "--rui-carousel-ltr-offset:-100%")
  assert_contains(html, "--rui-carousel-rtl-offset:100%")
  assert_contains(
    html, "transform:translate3d(var(--rui-carousel-offset,var(--rui-carousel-ltr-offset)),0,0)",
  )
  assert_contains(html, "data-swipe=\"true\"")
  assert_contains(
    html, "touch-action:var(--rui-carousel-touch-action,pan-y pinch-zoom)",
  )
  assert_contains(html, "margin-inline-start:-1rem")
  assert_contains(html, "padding-inline-start:1rem")
  assert_contains(html, "gap:0.25rem")
  assert_contains(html, "data-index=\"1\"")
  assert_contains(html, "data-state=\"active\"")
  assert_contains(html, "aria-current=\"true\"")
  assert_contains(html, "data-state=\"inactive\"")
  assert_not_contains(html, " inert")
  assert_contains(html, "aria-label=\"Previous slide\"")
  assert_contains(html, "aria-label=\"Next slide\"")
  assert_contains(html, "data-icon=\"previous\"")
  assert_contains(html, "data-icon=\"next\"")
  assert_contains(html, "width:1rem;height:1rem")
  assert_contains(html, "--rui-carousel-control-inline-offset,-3rem")
  assert_contains(
    html, "inset-inline-start:var(--rui-carousel-control-inline-offset",
  )
  assert_contains(
    html, "inset-inline-end:var(--rui-carousel-control-inline-offset",
  )
  assert_contains(html, "aria-live=\"polite\"")
  assert_contains(html, ">Slide 2 of 3</span>")
  assert_contains(html, "data-item-owner=\"caller\"")
  assert_contains(html, "max-width:30rem")

  let original = render(@html.div(attrs~, @html.nothing))
  assert_contains(original, "data-owner=\"caller\"")
  assert_not_contains(original, "data-slot")
  assert_not_contains(original, "role=\"region\"")
  let original_item = render(@html.div(attrs=item_attrs, @html.nothing))
  assert_contains(original_item, "data-item-owner=\"caller\"")
  assert_not_contains(original_item, "data-index")
}

///|
test "carousel boundary controls and wrap-around use native buttons" {
  let bounded = render_incremental_cc(() => {
    @rabbita-ui.carousel(default_index=0, count=2, scope => {
      [@rabbita-ui.carousel_previous(scope~), @rabbita-ui.carousel_next(scope~)]
    })
  })
  assert_contains(bounded, "data-slot=\"carousel-previous\"")
  assert_contains(bounded, "data-direction=\"previous\"")
  assert_contains(bounded, "data-variant=\"outline\"")
  assert_contains(bounded, "data-size=\"icon-sm\"")
  assert_contains(
    bounded, "background:var(--rui-button-bg,var(--rui-button-base-bg,transparent))",
  )
  assert_contains(
    bounded, "box-shadow:var(--rui-button-shadow,var(--rui-button-base-shadow,none))",
  )
  assert_contains(bounded, "data-state=\"disabled\"")
  assert_contains(bounded, " disabled")
  assert_contains(bounded, "data-slot=\"carousel-next\"")
  assert_contains(bounded, "data-state=\"enabled\"")

  let custom_control = render_incremental_cc(() => {
    @rabbita-ui.carousel(default_index=1, count=3, scope => {
      @rabbita-ui.carousel_previous(scope~, style=["inset-inline-start:-1rem"])
    })
  })
  assert_contains(
    custom_control, "inset-inline-start:var(--rui-carousel-control-inline-offset,-3rem)",
  )
  assert_contains(custom_control, "inset-inline-start:-1rem")

  let wrapped = render_incremental_cc(() => {
    @rabbita-ui.carousel(
      default_index=2,
      count=3,
      loop_=true,
      orientation=@rabbita-ui.CarouselVertical,
      scope => {
        [
          @rabbita-ui.carousel_items(scope~, items=[
            @html.p("A"),
            @html.p("B"),
            @html.p("C"),
          ]),
          @rabbita-ui.carousel_previous(scope~),
          @rabbita-ui.carousel_next(scope~),
        ]
      },
    )
  })
  assert_contains(wrapped, "data-orientation=\"vertical\"")
  assert_contains(wrapped, "--rui-carousel-block-offset:-200%")
  assert_contains(
    wrapped, "transform:translate3d(0,var(--rui-carousel-offset,var(--rui-carousel-block-offset)),0)",
  )
  assert_contains(wrapped, "--rui-carousel-height,12rem")
  assert_contains(wrapped, "top:var(--rui-carousel-control-block-offset,-3rem)")
  assert_contains(
    wrapped, "bottom:var(--rui-carousel-control-block-offset,-3rem)",
  )
  assert_contains(wrapped, "data-direction=\"next\"")
  assert_not_contains(wrapped, "data-state=\"disabled\"")
}

///|
test "carousel owns its initial active slide" {
  let html = render_incremental_cc(() => {
    @rabbita-ui.carousel(count=3, default_index=2, aria_label="Highlights", scope => {
      [
        @rabbita-ui.carousel_items(scope~, items=[
          @html.p("One"),
          @html.p("Two"),
          @html.p("Three"),
        ]),
        @rabbita-ui.carousel_previous(scope~),
        @rabbita-ui.carousel_next(scope~),
      ]
    })
  })
  assert_contains(html, "aria-label=\"Highlights\"")
  assert_contains(html, "data-active-index=\"2\"")
  assert_contains(html, "--rui-carousel-ltr-offset:-200%")
  assert_contains(html, ">Slide 3 of 3</span>")
}
