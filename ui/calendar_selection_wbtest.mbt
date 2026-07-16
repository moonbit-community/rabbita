///|
test "range calendar selection starts, completes in order, then restarts" {
  let later = calendar_date(year=2026, month=7, day=18)
  let earlier = calendar_date(year=2026, month=7, day=10)
  let started = calendar_range_next_value(None, later)
  assert_eq(started.start, later)
  assert_eq(started.end, None)

  let completed = calendar_range_next_value(Some(started), earlier)
  assert_eq(completed.start, earlier)
  assert_eq(completed.end, Some(later))

  let restart = calendar_date(year=2026, month=8, day=2)
  let restarted = calendar_range_next_value(Some(completed), restart)
  assert_eq(restarted.start, restart)
  assert_eq(restarted.end, None)
}

///|
test "multiple calendar defaults are copied, deduplicated, and toggle cleanly" {
  let first = calendar_date(year=2026, month=7, day=4)
  let second = calendar_date(year=2026, month=7, day=16)
  let third = calendar_date(year=2026, month=8, day=1)
  let requested = [first, second, first]
  let initial = calendar_multiple_initial_model(None, requested, None)
  requested.push(third)
  assert_eq(initial.selected, [first, second])
  assert_eq(initial.visible, calendar_date(year=2026, month=7, day=1))
  assert_eq(initial.focused, first)

  let removed = calendar_multiple_next_value(initial.selected, first)
  assert_eq(removed, [second])
  let added = calendar_multiple_next_value(removed, third)
  assert_eq(added, [second, third])
  let emptied = calendar_multiple_next_value(
    calendar_multiple_next_value([], first),
    first,
  )
  assert_eq(emptied, [])
}

///|
#cfg(target="js")
test "range calendar update owns partial and completed selection state" {
  let later = calendar_date(year=2026, month=7, day=18)
  let earlier = calendar_date(year=2026, month=7, day=10)
  let initial = calendar_range_initial_model(
    Some(calendar_date(year=2026, month=7, day=1)),
    None,
    None,
  )
  let (started, _) = calendar_range_update(
    Some("release-window"),
    None,
    None,
    None,
    CalendarRangeChoose(later),
    initial,
  )
  assert_eq(started.selected, Some(date_range(start=later)))
  assert_eq(started.focused, later)

  let (completed, _) = calendar_range_update(
    Some("release-window"),
    None,
    None,
    None,
    CalendarRangeChoose(earlier),
    started,
  )
  assert_eq(completed.selected, Some(date_range(start=earlier, end=later)))
  assert_eq(completed.visible, calendar_date(year=2026, month=7, day=1))
  assert_eq(completed.focused, earlier)
}

///|
#cfg(target="js")
test "multiple calendar update toggles and follows outside-month choices" {
  let july = calendar_date(year=2026, month=7, day=1)
  let outside = calendar_date(year=2026, month=8, day=2)
  let initial = calendar_multiple_initial_model(Some(july), [], None)
  let (selected, _) = calendar_multiple_update(
    Some("available-dates"),
    None,
    None,
    None,
    CalendarMultipleChoose(outside),
    initial,
  )
  assert_eq(selected.selected, [outside])
  assert_eq(selected.visible, calendar_date(year=2026, month=8, day=1))
  assert_eq(selected.focused, outside)

  let (removed, _) = calendar_multiple_update(
    Some("available-dates"),
    None,
    None,
    None,
    CalendarMultipleChoose(outside),
    selected,
  )
  assert_eq(removed.selected, [])
  assert_eq(removed.focused, outside)

  let june = calendar_date(year=2026, month=6, day=30)
  let (moved, _) = calendar_multiple_update(
    Some("available-dates"),
    None,
    None,
    None,
    CalendarMultipleMoveFocus(june),
    removed,
  )
  assert_eq(moved.visible, calendar_date(year=2026, month=6, day=1))
  assert_eq(moved.focused, june)
}

///|
#cfg(target="js")
test "selection updates report new values and outside-month changes" {
  let july = calendar_date(year=2026, month=7, day=1)
  let outside = calendar_date(year=2026, month=8, day=2)
  let range_seen : Ref[DateRange?] = Ref(None)
  let month_seen : Ref[CalendarDate?] = Ref(None)
  let range_notify : @cmd.Emit[DateRange] = Emit(value => {
    range_seen.val = Some(value)
    @cmd.none
  })
  let month_notify : @cmd.Emit[CalendarDate] = Emit(value => {
    month_seen.val = Some(value)
    @cmd.none
  })
  let range_initial = calendar_range_initial_model(Some(july), None, None)
  let (range_next, _) = calendar_range_update(
    None,
    Some(range_notify),
    Some(month_notify),
    None,
    CalendarRangeChoose(outside),
    range_initial,
  )
  assert_eq(range_seen.val, range_next.selected)
  assert_eq(month_seen.val, Some(calendar_date(year=2026, month=8, day=1)))

  let multiple_seen : Ref[Array[CalendarDate]] = Ref([])
  let multiple_notify : @cmd.Emit[Array[CalendarDate]] = Emit(values => {
    multiple_seen.val = values
    @cmd.none
  })
  let multiple_initial = calendar_multiple_initial_model(Some(july), [], None)
  let (multiple_next, _) = calendar_multiple_update(
    None,
    Some(multiple_notify),
    None,
    None,
    CalendarMultipleChoose(outside),
    multiple_initial,
  )
  assert_eq(multiple_seen.val, [outside])
  assert_eq(multiple_next.selected, [outside])

  // The callback receives its own array, not the component's state storage.
  multiple_seen.val.push(july)
  assert_eq(multiple_next.selected, [outside])
}
