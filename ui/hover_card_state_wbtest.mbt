///|
#cfg(target="js")
fn hover_card_test_model(open : Bool) -> HoverCardModel {
  {
    open,
    trigger_hovered: false,
    trigger_focused: false,
    content_hovered: false,
    content_focused: false,
    generation: 0,
  }
}

///|
#cfg(target="js")
fn hover_card_test_update(
  current : HoverCardModel,
  message : HoverCardMsg,
) -> HoverCardModel {
  let (next, _) = hover_card_update(
    "test-hover-card",
    None,
    @cmd.Emit(_ => @cmd.none),
    message,
    current,
  )
  next
}

///|
#cfg(target="js")
test "hover card delayed work is invalidated by the next interaction" {
  let waiting = hover_card_test_update(
    hover_card_test_model(false),
    HoverCardDomEvent(0, 600),
  )
  let open_generation = waiting.generation
  let left = hover_card_test_update(waiting, HoverCardDomEvent(1, 0))
  let stale_open = hover_card_test_update(
    left,
    HoverCardOpenAfter(open_generation),
  )
  assert_true(!stale_open.open)

  let hovering_trigger : HoverCardModel = {
    ..hover_card_test_model(true),
    trigger_hovered: true,
  }
  let waiting_close = hover_card_test_update(
    hovering_trigger,
    HoverCardDomEvent(1, 300),
  )
  let close_generation = waiting_close.generation
  let hovering_content = hover_card_test_update(
    waiting_close,
    HoverCardDomEvent(4, 0),
  )
  let stale_close = hover_card_test_update(
    hovering_content,
    HoverCardCloseAfter(close_generation),
  )
  assert_true(stale_close.open)
  assert_true(stale_close.content_hovered)
}

///|
#cfg(target="js")
test "hover card focus sources and native dismissal remain synchronized" {
  let trigger_focused = hover_card_test_update(
    hover_card_test_model(false),
    HoverCardDomEvent(2, 0),
  )
  assert_true(trigger_focused.open)
  let content_focused = hover_card_test_update(
    trigger_focused,
    HoverCardDomEvent(6, 0),
  )
  let trigger_blurred = hover_card_test_update(
    content_focused,
    HoverCardDomEvent(3, 0),
  )
  assert_true(trigger_blurred.open)
  assert_true(trigger_blurred.content_focused)
  let content_blurred = hover_card_test_update(
    trigger_blurred,
    HoverCardDomEvent(7, 0),
  )
  assert_true(!content_blurred.open)

  let active : HoverCardModel = {
    open: true,
    trigger_hovered: true,
    trigger_focused: true,
    content_hovered: true,
    content_focused: true,
    generation: 9,
  }
  let native_closed = hover_card_test_update(
    active,
    HoverCardNativeChanged(false),
  )
  assert_true(!native_closed.open)
  assert_true(!native_closed.trigger_hovered)
  assert_true(!native_closed.trigger_focused)
  assert_true(!native_closed.content_hovered)
  assert_true(!native_closed.content_focused)
  assert_eq(native_closed.generation, 10)
}
