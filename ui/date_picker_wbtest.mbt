///|
#cfg(target="js")
test "single date picker selection commits and closes in one state update" {
  let initial = date_picker_initial_model(
    true,
    false,
    Some(calendar_date(year=2026, month=7, day=1)),
    None,
    None,
  )
  let chosen = calendar_date(year=2026, month=7, day=16)
  let (next, _) = date_picker_update(
    "release-date",
    false,
    None,
    None,
    None,
    DatePickerChoose(chosen),
    initial,
  )
  assert_false(next.open)
  assert_eq(next.value, Some(chosen))
  assert_eq(next.visible, calendar_date(year=2026, month=7, day=1))
  assert_eq(next.focused, chosen)
}

///|
test "range selection starts, completes, normalizes, then restarts" {
  let later = calendar_date(year=2026, month=7, day=18)
  let earlier = calendar_date(year=2026, month=7, day=10)
  let (started, started_complete) = date_range_picker_next_value(None, later)
  assert_false(started_complete)
  assert_eq(started.start, later)
  assert_eq(started.end, None)

  let (completed, completed_now) = date_range_picker_next_value(
    Some(started),
    earlier,
  )
  assert_true(completed_now)
  assert_eq(completed.start, earlier)
  assert_eq(completed.end, Some(later))

  let restart = calendar_date(year=2026, month=8, day=2)
  let (restarted, restarted_complete) = date_range_picker_next_value(
    Some(completed),
    restart,
  )
  assert_false(restarted_complete)
  assert_eq(restarted.start, restart)
  assert_eq(restarted.end, None)
}

///|
test "two-month range window stays stable for selection and keyboard focus" {
  let january = calendar_date(year=2026, month=1, day=1)
  let february_day = calendar_date(year=2026, month=2, day=9)
  let march_day = calendar_date(year=2026, month=3, day=2)
  assert_eq(date_range_picker_visible_for_date(january, february_day), january)
  assert_eq(
    date_range_picker_focus_calendar_id("range", january, february_day),
    "range-calendar-next",
  )
  assert_eq(
    date_range_picker_visible_for_date(january, march_day),
    calendar_date(year=2026, month=3, day=1),
  )
  assert_eq(
    date_range_picker_focus_calendar_id("range", march_day, march_day),
    "range-calendar",
  )
}
