///|
#cfg(target="js")
extern "js" fn install_date_picker_test_window() =
  #| () => {
  #|   if (typeof globalThis.window === "undefined") {
  #|     globalThis.window = { requestAnimationFrame: () => 0 }
  #|   }
  #| }

///|
#warnings("-alert_unstable")
#cfg(target="js")
fn render_incremental_date_picker(
  builder : () -> @rabbita.Val[@html.Html],
) -> String {
  install_date_picker_test_window()
  ignore(@rabbita.new(builder))
  @rabbita.render_to_string(builder)
}

///|
#warnings("-alert_unstable")
#cfg(not(target="js"))
fn render_incremental_date_picker(
  builder : () -> @rabbita.Val[@html.Html],
) -> String {
  @rabbita.render_to_string(builder)
}

///|
test "date range is opaque, inspectable, and normalizes reversed boundaries" {
  let earlier = @rabbita-ui.calendar_date(year=2026, month=7, day=10)
  let later = @rabbita-ui.calendar_date(year=2026, month=7, day=18)
  let normalized = @rabbita-ui.date_range(start=later, end=earlier)
  assert_eq(normalized.start(), earlier)
  assert_eq(normalized.end(), Some(later))

  let partial = @rabbita-ui.date_range(start=earlier)
  assert_eq(partial.start(), earlier)
  assert_eq(partial.end(), None)
}

///|
test "single date picker renders a CSS-anchored interactive composition" {
  let attrs = @html.Attrs::build().data_set("owner", "caller")
  let selected = @rabbita-ui.calendar_date(year=2026, month=7, day=16)
  let html = render_incremental_date_picker(() => {
    @rabbita-ui.date_picker(
      id="release-date",
      default_value=selected,
      today=selected,
      default_open=true,
      invalid=true,
      side=Bottom,
      align=Start,
      presets=[
        @rabbita-ui.date_picker_preset(label="Today", value=selected),
        @rabbita-ui.date_picker_preset(
          label="Launch day",
          value=@rabbita-ui.calendar_date(year=2026, month=8, day=1),
        ),
      ],
      format_value=date => "Selected \{date.to_iso_string()}",
      attrs~,
      style=["background:rebeccapurple"],
      trigger_style=["width:20rem"],
      content_style=["min-width:20rem"],
      calendar_style=["background:linen"],
      day_style=["font-variant-numeric:tabular-nums"],
      preset_style=["min-height:2.5rem"],
    )
  })
  assert_contains(html, "data-slot=\"date-picker\"")
  assert_contains(html, "id=\"release-date-root\"")
  assert_contains(html, "data-state=\"open\"")
  assert_contains(html, "data-value=\"2026-07-16\"")
  assert_contains(html, "data-owner=\"caller\"")
  assert_contains(html, "background:rebeccapurple")
  assert_contains(html, "data-slot=\"date-picker-trigger\"")
  assert_contains(html, "data-variant=\"outline\"")
  assert_contains(html, "data-size=\"default\"")
  assert_contains(html, "id=\"release-date-trigger\"")
  assert_contains(html, "aria-haspopup=\"dialog\"")
  assert_contains(html, "aria-expanded=\"true\"")
  assert_contains(html, "aria-controls=\"release-date\"")
  assert_contains(html, "aria-invalid=\"true\"")
  assert_contains(html, "Selected 2026-07-16")
  assert_contains(html, "width:20rem")
  assert_contains(html, "<svg")
  assert_contains(html, "id=\"release-date\"")
  assert_contains(html, "popover=\"auto\"")
  assert_contains(html, "role=\"dialog\"")
  assert_contains(html, "data-trigger-id=\"release-date-trigger\"")
  assert_contains(html, "position-anchor:--rui-anchor_")
  assert_contains(html, "position-area:bottom span-x-end")
  assert_contains(html, "data-slot=\"date-picker-content\"")
  assert_contains(html, "min-width:20rem")
  assert_contains(html, "data-slot=\"date-picker-presets\"")
  assert_contains(html, "data-slot=\"date-picker-preset\"")
  assert_contains(html, "data-preset-value=\"2026-07-16\"")
  assert_contains(html, "data-preset-value=\"2026-08-01\"")
  assert_contains(html, "min-height:2.5rem")
  assert_contains(html, "data-slot=\"calendar\"")
  assert_contains(html, "id=\"release-date-calendar\"")
  assert_contains(html, "aria-label=\"Date picker calendar\"")
  assert_contains(html, "data-day=\"2026-07-16\"")
  assert_contains(html, "data-selected-single=\"true\"")
  assert_contains(html, "background:linen")
  assert_contains(html, "font-variant-numeric:tabular-nums")

  let original = render(@html.div(attrs~, @html.nothing))
  assert_contains(original, "data-owner=\"caller\"")
  assert_not_contains(original, "data-slot=\"date-picker\"")
  assert_not_contains(original, "data-state=\"open\"")
}

///|
test "date picker placeholder and disabled state normalize an open default" {
  let html = render_incremental_date_picker(() => {
    @rabbita-ui.date_picker(
      id="disabled-date",
      default_open=true,
      disabled=true,
      placeholder="Choose birthday",
    )
  })
  assert_contains(html, "data-slot=\"date-picker\"")
  assert_contains(html, "data-state=\"closed\"")
  assert_contains(html, "data-disabled=\"true\"")
  assert_contains(html, "data-placeholder=\"true\"")
  assert_contains(html, "aria-expanded=\"false\"")
  assert_contains(html, "aria-disabled=\"true\"")
  assert_contains(html, " disabled")
  assert_contains(html, ">Choose birthday</span>")
  assert_contains(html, "color:var(--rui-muted-foreground,oklch(0.556 0 0))")
  assert_not_contains(html, "data-state=\"open\"")
}

///|
test "date range picker exposes default boundaries and range day semantics" {
  let start = @rabbita-ui.calendar_date(year=2026, month=7, day=10)
  let end = @rabbita-ui.calendar_date(year=2026, month=7, day=15)
  let html = render_incremental_date_picker(() => {
    @rabbita-ui.date_range_picker(
      id="sprint-range",
      default_value=@rabbita-ui.date_range(start~, end~),
      default_open=true,
      format_value=range => {
        let finish = range
          .end()
          .map(date => date.to_iso_string())
          .unwrap_or("…")
        "\{range.start().to_iso_string()} / \{finish}"
      },
      style=["outline:1px solid rebeccapurple"],
      trigger_style=["width:22rem"],
      content_style=["box-shadow:none"],
      day_style=["letter-spacing:0.01em"],
    )
  })
  assert_contains(html, "data-slot=\"date-range-picker\"")
  assert_contains(html, "data-state=\"open\"")
  assert_contains(html, "data-range-start=\"2026-07-10\"")
  assert_contains(html, "data-range-end=\"2026-07-15\"")
  assert_contains(html, "2026-07-10 / 2026-07-15")
  assert_contains(html, "outline:1px solid rebeccapurple")
  assert_contains(html, "width:22rem")
  assert_contains(html, "box-shadow:none")
  assert_contains(html, "data-slot=\"date-range-picker-content\"")
  assert_contains(html, "aria-label=\"Date range picker calendar\"")
  assert_contains(html, "data-mode=\"range\"")
  assert_contains(html, "aria-multiselectable=\"true\"")
  assert_contains(html, "data-day=\"2026-07-10\"")
  assert_contains(html, "data-range-start=\"\"")
  assert_contains(html, "data-day=\"2026-07-15\"")
  assert_contains(html, "data-range-end=\"\"")
  assert_contains(html, "data-day=\"2026-07-12\"")
  assert_contains(html, "data-range-middle=\"\"")
  assert_contains(html, "aria-selected=\"true\"")
  assert_contains(
    html, "linear-gradient(var(--rui-calendar-range-start-direction,to right)",
  )
  assert_contains(
    html, "linear-gradient(var(--rui-calendar-range-end-direction,to right)",
  )
  assert_contains(
    html, "--rui-calendar-base-bg:var(--rui-accent,oklch(0.97 0 0))",
  )
  assert_contains(html, "border-radius:0")
  assert_contains(html, "letter-spacing:0.01em")
  assert_not_contains(html, "data-selected-single=\"true\"")
}

///|
test "date range picker popup renders the shadcn-style two-month surface" {
  let january = @rabbita-ui.calendar_date(year=2026, month=1, day=1)
  let start = @rabbita-ui.calendar_date(year=2026, month=1, day=20)
  let end = @rabbita-ui.calendar_date(year=2026, month=2, day=9)
  let html = render_incremental_date_picker(() => {
    @rabbita-ui.date_range_picker(
      id="range-popup",
      default_month=january,
      default_value=@rabbita-ui.date_range(start~, end~),
      default_open=true,
    )
  })
  assert_contains(html, "data-slot=\"popover-content\"")
  assert_contains(html, "role=\"dialog\"")
  assert_contains(html, "data-trigger-id=\"range-popup-trigger\"")
  assert_contains(html, "data-side=\"bottom\"")
  assert_contains(html, "data-align=\"start\"")
  assert_contains(html, "data-side-offset=\"4\"")
  assert_contains(
    html, "width:var(--rui-date-range-picker-width,32rem);min-width:0;max-width:calc(100vw - 1rem);max-height:var(--rui-date-range-picker-max-height,none);position-try-order:most-height;gap:0;overflow-x:hidden;overflow-y:var(--rui-date-range-picker-overflow-y,hidden);padding:0",
  )
  assert_contains(html, "data-date-range-picker-popup=\"\"")
  assert_contains(html, "box-shadow:0 4px 6px -1px")
  assert_contains(html, "data-slot=\"date-range-picker-content\"")
  assert_contains(
    html, "display:flex;width:100%;min-width:0;max-width:100%;flex-wrap:wrap;align-items:flex-start;justify-content:center;gap:1rem",
  )
  assert_contains(html, "id=\"range-popup-calendar\"")
  assert_contains(html, "data-month=\"2026-01-01\"")
  assert_contains(html, "id=\"range-popup-calendar-next\"")
  assert_contains(html, "data-month=\"2026-02-01\"")
  assert_eq(html.split("data-slot=\"calendar\"").count(), 3)
  assert_eq(html.split("aria-label=\"Go to previous month\"").count(), 2)
  assert_eq(html.split("aria-label=\"Go to next month\"").count(), 2)
  assert_eq(html.split("data-day=\"2026-01-31\"").count(), 2)
  assert_eq(html.split("data-day=\"2026-02-01\"").count(), 2)
  assert_contains(
    html, "border-start-start-radius:var(--rui-calendar-cell-radius)",
  )
  assert_contains(
    html, "border-start-end-radius:var(--rui-calendar-cell-radius)",
  )
}

///|
test "partial date range remains a real initial selection" {
  let start = @rabbita-ui.calendar_date(year=1990, month=4, day=7)
  let html = render_incremental_date_picker(() => {
    @rabbita-ui.date_range_picker(
      id="partial-range",
      default_value=@rabbita-ui.date_range(start~),
      placeholder="Birthday window",
    )
  })
  assert_contains(html, "data-range-start=\"1990-04-07\"")
  assert_not_contains(html, "data-range-end=\"")
  assert_contains(html, ">April 7, 1990</span>")
  assert_contains(html, "data-range-start=\"\"")
  assert_contains(html, "aria-selected=\"true\"")
}
