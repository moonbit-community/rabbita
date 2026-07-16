///|
test "toast and Sonner share the single overridable Vega shadow" {
  assert_eq(
    ToastCardShadowStyle,
    "--rui-toast-base-shadow:0 4px 12px rgb(0 0 0 / 0.1)",
  )
  assert_true(
    ToastSurfaceStyle.contains(
      "box-shadow:var(--rui-toast-shadow,var(--rui-toast-base-shadow,",
    ),
  )
  assert_true(ToastViewportStyle.contains("box-shadow:none"))
  assert_true(ToastViewportStyle.contains("overflow:visible"))
}

///|
test "toast dismissal retains one closing entry until removal" {
  let entries : Array[ToastEntry] = [
    {
      id: 1,
      title: "One",
      description: None,
      variant: ToastDefault,
      closing: false,
      swipe_direction: 0,
    },
    {
      id: 2,
      title: "Two",
      description: Some("Details"),
      variant: ToastSuccess,
      closing: false,
      swipe_direction: 0,
    },
  ]
  let (closing, changed) = toast_mark_closing(entries, 1, 1)
  assert_true(changed)
  assert_true(closing[0].closing)
  assert_true(!closing[1].closing)
  assert_eq(closing[0].swipe_direction, 1)
  let (same, changed_again) = toast_mark_closing(closing, 1, -1)
  assert_true(!changed_again)
  assert_eq(same.length(), 2)
  assert_eq(same[0].id, 1)
  assert_true(same[0].closing)
  assert_eq(same[1].id, 2)
  assert_true(!same[1].closing)
  let remaining = toast_remove(closing, 1)
  assert_eq(remaining.length(), 1)
  assert_eq(remaining[0].id, 2)
  assert_eq(remaining[0].title, "Two")
}

///|
test "dismiss all schedules only entries not already closing" {
  let entries : Array[ToastEntry] = [
    {
      id: 1,
      title: "Closing",
      description: None,
      variant: ToastDefault,
      closing: true,
      swipe_direction: 0,
    },
    {
      id: 2,
      title: "Open",
      description: None,
      variant: ToastDestructive,
      closing: false,
      swipe_direction: 0,
    },
  ]
  let (closing, ids) = toast_mark_all_closing(entries)
  assert_true(closing[0].closing)
  assert_true(closing[1].closing)
  assert_eq(ids, [2])
}

///|
test "toast timers resume only after every overlapping pause source leaves" {
  let initial : ToastModel = {
    next_id: 3,
    entries: [],
    pause_sources: [],
    expired: [1, 2],
  }
  let (hovered, hover_resume) = toast_set_paused(initial, "hover-1", true)
  assert_eq(hovered.pause_sources, ["hover-1"])
  assert_eq(hover_resume, [])
  let (focused, focus_resume) = toast_set_paused(hovered, "focus-1", true)
  assert_eq(focused.pause_sources, ["hover-1", "focus-1"])
  assert_eq(focus_resume, [])
  let (still_paused, partial_resume) = toast_set_paused(
    focused, "hover-1", false,
  )
  assert_eq(still_paused.pause_sources, ["focus-1"])
  assert_eq(still_paused.expired, [1, 2])
  assert_eq(partial_resume, [])
  let (resumed, resume_ids) = toast_set_paused(still_paused, "focus-1", false)
  assert_eq(resumed.pause_sources, [])
  assert_eq(resumed.expired, [])
  assert_eq(resume_ids, [1, 2])
}

///|
test "removing a toast clears only that entry's hover and focus sources" {
  let remaining = toast_remove_entry_pause_sources(
    ["document", "hover-1", "focus-1", "hover-2"],
    1,
  )
  assert_eq(remaining, ["document", "hover-2"])
}
