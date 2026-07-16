///|
#cfg(target="js")
extern "js" fn install_calendar_selection_test_window() =
  #| () => {
  #|   if (typeof globalThis.window === "undefined") {
  #|     globalThis.window = { requestAnimationFrame: () => 0 };
  #|   }
  #| }

///|
#warnings("-alert_unstable")
#cfg(target="js")
fn render_calendar_selection(
  builder : () -> @rabbita.Val[@html.Html],
) -> String {
  install_calendar_selection_test_window()
  ignore(@rabbita.new(builder))
  @rabbita.render_to_string(builder)
}

///|
#warnings("-alert_unstable")
#cfg(not(target="js"))
fn render_calendar_selection(
  builder : () -> @rabbita.Val[@html.Html],
) -> String {
  @rabbita.render_to_string(builder)
}

///|
test "range calendar renders a continuous range across outside days" {
  let start = @rabbita-ui.calendar_date(year=2026, month=7, day=31)
  let end = @rabbita-ui.calendar_date(year=2026, month=8, day=3)
  let notify : @cmd.Emit[@rabbita-ui.DateRange] = Emit(_ => @cmd.none)
  let html = render_calendar_selection(() => {
    @rabbita-ui.calendar_range(
      default_month=@rabbita-ui.calendar_date(year=2026, month=8, day=1),
      default_selected=@rabbita-ui.date_range(start~, end~),
      today=@rabbita-ui.calendar_date(year=2026, month=8, day=2),
      aria_label="Deployment window",
      on_select=notify,
      id="deployment-window",
      cell_style=["--range-cell-test:1"],
      day_style=["font-variant-numeric:tabular-nums"],
    )
  })
  assert_contains(html, "data-slot=\"calendar\"")
  assert_contains(html, "data-mode=\"range\"")
  assert_contains(html, "aria-label=\"Deployment window\"")
  assert_contains(html, "data-range-start=\"2026-07-31\"")
  assert_contains(html, "data-range-end=\"2026-08-03\"")
  assert_contains(html, "aria-multiselectable=\"true\"")
  assert_element_tag_contains(
    html, "data-day=\"2026-07-31\"", "data-range-start=\"\"",
  )
  assert_element_tag_contains(
    html, "data-day=\"2026-07-31\"", "data-outside-day=\"\"",
  )
  assert_element_tag_contains(
    html, "data-day=\"2026-08-01\"", "data-range-middle=\"\"",
  )
  assert_element_tag_contains(
    html, "data-day=\"2026-08-02\"", "aria-selected=\"true\"",
  )
  assert_element_tag_contains(
    html, "data-day=\"2026-08-02\"", "data-focused=\"\"",
  )
  assert_element_tag_contains(html, "data-day=\"2026-08-02\"", "tabindex=\"0\"")
  assert_element_tag_contains(
    html, "data-day=\"2026-08-03\"", "data-range-end=\"\"",
  )
  assert_contains(
    html, "linear-gradient(var(--rui-calendar-range-start-direction,to right)",
  )
  assert_contains(
    html, "linear-gradient(var(--rui-calendar-range-end-direction,to right)",
  )
  assert_contains(html, "--range-cell-test:1")
  assert_contains(html, "font-variant-numeric:tabular-nums")
  assert_not_contains(html, "data-selected-single=\"true\"")
}

///|
test "multiple calendar normalizes defaults and marks every selected date" {
  let first = @rabbita-ui.calendar_date(year=2026, month=7, day=4)
  let second = @rabbita-ui.calendar_date(year=2026, month=7, day=16)
  let outside = @rabbita-ui.calendar_date(year=2026, month=6, day=30)
  let notify : @cmd.Emit[Array[@rabbita-ui.CalendarDate]] = Emit(_ => @cmd.none)
  let html = render_calendar_selection(() => {
    @rabbita-ui.calendar_multiple(
      default_month=@rabbita-ui.calendar_date(year=2026, month=7, day=1),
      default_selected=[first, second, first, outside],
      today=second,
      aria_label="Available dates",
      on_select=notify,
      id="available-dates",
    )
  })
  assert_contains(html, "data-mode=\"multiple\"")
  assert_contains(html, "data-selected-count=\"3\"")
  assert_contains(html, "aria-multiselectable=\"true\"")
  assert_element_tag_contains(
    html, "data-day=\"2026-07-04\"", "data-selected-multiple=\"\"",
  )
  assert_element_tag_contains(html, "data-day=\"2026-07-04\"", "tabindex=\"0\"")
  assert_element_tag_contains(
    html, "data-day=\"2026-07-16\"", "aria-current=\"date\"",
  )
  assert_element_tag_contains(
    html, "data-day=\"2026-06-30\"", "data-outside-day=\"\"",
  )
  assert_element_tag_contains(
    html, "data-day=\"2026-06-30\"", "aria-selected=\"true\"",
  )
  assert_element_tag_contains(
    html, "data-day=\"2026-07-05\"", "aria-selected=\"false\"",
  )
  assert_not_contains(html, "data-selected-single=\"true\"")
  assert_not_contains(html, "data-range-middle=\"\"")
}

///|
test "selection variants preserve disabled and hidden outside-day semantics" {
  let html = render_calendar_selection(() => {
    @rabbita-ui.calendar_range(
      default_month=@rabbita-ui.calendar_date(year=2025, month=2, day=1),
      default_selected=@rabbita-ui.date_range(
        start=@rabbita-ui.calendar_date(year=2025, month=2, day=10),
      ),
      show_outside_days=false,
      disabled=true,
      aria_label="Unavailable range",
    )
  })
  assert_contains(html, "data-mode=\"range\"")
  assert_contains(html, "data-disabled=\"\"")
  assert_contains(html, "aria-disabled=\"true\"")
  assert_contains(html, "visibility:hidden")
  assert_contains(html, " disabled")
  assert_not_contains(html, "data-day=\"2025-01-26\"")
  assert_element_tag_contains(
    html, "data-day=\"2025-02-10\"", "data-range-start=\"\"",
  )
}
