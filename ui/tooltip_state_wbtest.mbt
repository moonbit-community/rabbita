///|
#cfg(target="js")
fn tooltip_test_model(open : Bool) -> TooltipModel {
  {
    open,
    trigger_hovered: false,
    trigger_focused: false,
    content_hovered: false,
    generation: 0,
  }
}

///|
#cfg(target="js")
fn tooltip_test_update(
  current : TooltipModel,
  message : TooltipMsg,
  close_on_click? : Bool = true,
) -> TooltipModel {
  let (next, _) = tooltip_update(
    "test-tooltip",
    close_on_click,
    None,
    @cmd.Emit(_ => @cmd.none),
    message,
    current,
  )
  next
}

///|
#cfg(target="js")
test "tooltip stale delayed open is cancelled when pointer leaves" {
  let waiting = tooltip_test_update(
    tooltip_test_model(false),
    TooltipDomEvent(0, 100),
  )
  assert_true(waiting.trigger_hovered)
  assert_true(!waiting.open)
  let generation = waiting.generation
  let left = tooltip_test_update(waiting, TooltipDomEvent(1, 0))
  assert_true(!left.trigger_hovered)
  assert_true(left.generation > generation)
  let stale = tooltip_test_update(left, TooltipOpenAfter(generation))
  assert_true(!stale.open)
}

///|
#cfg(target="js")
test "tooltip focus and hoverable content independently keep it open" {
  let focused = tooltip_test_update(
    tooltip_test_model(false),
    TooltipDomEvent(2, 0),
  )
  assert_true(focused.open)
  assert_true(focused.trigger_focused)
  let pointer_left = tooltip_test_update(focused, TooltipDomEvent(1, 0))
  assert_true(pointer_left.open)
  let blurred = tooltip_test_update(pointer_left, TooltipDomEvent(3, 0))
  assert_true(!blurred.open)

  let hovering_trigger : TooltipModel = {
    ..tooltip_test_model(true),
    trigger_hovered: true,
  }
  let waiting_close = tooltip_test_update(
    hovering_trigger,
    TooltipDomEvent(1, 80),
  )
  let closing_generation = waiting_close.generation
  let hovering_content = tooltip_test_update(
    waiting_close,
    TooltipDomEvent(5, 0),
  )
  let stale_close = tooltip_test_update(
    hovering_content,
    TooltipCloseAfter(closing_generation),
  )
  assert_true(stale_close.open)
  assert_true(stale_close.content_hovered)
  let content_left = tooltip_test_update(stale_close, TooltipDomEvent(6, 0))
  assert_true(!content_left.open)
}

///|
#cfg(target="js")
test "tooltip click policy and native close reset every active source" {
  let active : TooltipModel = {
    open: true,
    trigger_hovered: true,
    trigger_focused: true,
    content_hovered: true,
    generation: 7,
  }
  let retained = tooltip_test_update(
    active,
    TooltipDomEvent(4, 0),
    close_on_click=false,
  )
  assert_true(retained.open)
  assert_true(retained.trigger_hovered)
  let dismissed = tooltip_test_update(active, TooltipDomEvent(4, 0))
  assert_true(!dismissed.open)
  assert_true(!dismissed.trigger_hovered)
  assert_true(!dismissed.trigger_focused)
  assert_true(!dismissed.content_hovered)
  let native_closed = tooltip_test_update(active, TooltipNativeChanged(false))
  assert_true(!native_closed.open)
  assert_true(!native_closed.trigger_hovered)
  assert_true(!native_closed.trigger_focused)
  assert_true(!native_closed.content_hovered)
  assert_eq(native_closed.generation, 8)
}
