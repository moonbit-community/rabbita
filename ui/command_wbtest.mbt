///|
#cfg(target="js")
fn command_test_update(
  message : CommandMessage,
  current : CommandModel,
) -> CommandModel {
  let (next, _) = command_update(
    @cmd.Emit(_ => @cmd.none),
    "command-root",
    Some("command-dialog"),
    true,
    true,
    None,
    None,
    None,
    None,
    message,
    current,
  )
  next
}

///|
#cfg(target="js")
extern "js" fn ffi_reset_command_event_fixture() -> Unit =
  #| () => {
  #|   globalThis.__ruiCommandEventFixture = { trace: [], overlayCloses: 0 }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_note_command_caller_keydown() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiCommandEventFixture ||= {
  #|     trace: [],
  #|     overlayCloses: 0,
  #|   }
  #|   fixture.trace.push("caller")
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_note_command_internal_keydown() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiCommandEventFixture ||= {
  #|     trace: [],
  #|     overlayCloses: 0,
  #|   }
  #|   fixture.trace.push("internal")
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_command_event_trace() -> String =
  #| () => globalThis.__ruiCommandEventFixture?.trace?.join(",") || ""

///|
#cfg(target="js")
extern "js" fn ffi_note_command_overlay_close() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiCommandEventFixture ||= {
  #|     trace: [],
  #|     overlayCloses: 0,
  #|   }
  #|   fixture.overlayCloses += 1
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_command_overlay_closes() -> Int =
  #| () => globalThis.__ruiCommandEventFixture?.overlayCloses || 0

///|
#cfg(target="js")
extern "js" fn ffi_fire_command_keydown(
  attrs : @html.Attrs,
  key : String,
) -> Bool =
  #| (attrs, key) => {
  #|   const props = attrs?.handlers ? attrs : attrs?._0
  #|   const entry = props?.handlers?.entries?.find(
  #|     item => item && item.key === "keydown",
  #|   )
  #|   if (!entry) return false
  #|   const hadKeyboardEvent = Object.prototype.hasOwnProperty.call(
  #|     globalThis,
  #|     "KeyboardEvent",
  #|   )
  #|   const previousKeyboardEvent = globalThis.KeyboardEvent
  #|   class FakeKeyboardEvent {
  #|     constructor(value) {
  #|       this.key = value
  #|       this.altKey = false
  #|       this.ctrlKey = false
  #|       this.metaKey = false
  #|       this.isComposing = false
  #|       this.defaultPrevented = false
  #|     }
  #|     preventDefault() { this.defaultPrevented = true }
  #|   }
  #|   globalThis.KeyboardEvent = FakeKeyboardEvent
  #|   const event = new FakeKeyboardEvent(key)
  #|   let scheduler
  #|   const run = command => {
  #|     if (!command) return
  #|     if (command.$tag === 0) {
  #|       for (const child of command._0 || []) run(child)
  #|     } else if (command.$tag === 1) {
  #|       command._1(scheduler)
  #|     } else if (command.$tag === 3) {
  #|       command._0(scheduler)
  #|     }
  #|   }
  #|   scheduler = {
  #|     self: null,
  #|     method_table: { method_3: (_self, command) => run(command) },
  #|   }
  #|   try {
  #|     entry.value(event, scheduler)
  #|     return event.defaultPrevented
  #|   } finally {
  #|     if (hadKeyboardEvent) globalThis.KeyboardEvent = previousKeyboardEvent
  #|     else delete globalThis.KeyboardEvent
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_fire_command_dialog_overlay_click(
  html : @html.Html,
  nested_floating : Bool,
) -> Bool =
  #| (html, nestedFloating) => {
  #|   const mapGet = (map, key) => map?.entries?.find(
  #|     item => item && item.key === key,
  #|   )?.value
  #|   const findOverlay = node => {
  #|     if (!node) return null
  #|     if (node.$tag === 0) {
  #|       if (mapGet(node._1?.attrs, "data-slot") === "command-dialog-overlay") {
  #|         return node
  #|       }
  #|       if (node._2?.$tag === 0) {
  #|         for (const child of node._2._0 || []) {
  #|           const found = findOverlay(child)
  #|           if (found) return found
  #|         }
  #|       }
  #|     } else if (node.$tag === 2) {
  #|       for (const child of node._0 || []) {
  #|         const found = findOverlay(child)
  #|         if (found) return found
  #|       }
  #|     } else if (node.$tag === 3) {
  #|       return findOverlay(node._1())
  #|     }
  #|     return null
  #|   }
  #|   const root = html?.$tag === undefined && html?._0?.$tag !== undefined
  #|     ? html._0
  #|     : html
  #|   const overlay = findOverlay(root)
  #|   const entry = overlay
  #|     ? overlay._1?.handlers?.entries?.find(
  #|         item => item && item.key === "click",
  #|       )
  #|     : null
  #|   if (!entry) return false
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const hadDocument = own("document")
  #|   const previousDocument = globalThis.document
  #|   const hadMouseEvent = own("MouseEvent")
  #|   const previousMouseEvent = globalThis.MouseEvent
  #|   const hadFloatingStack = own("__ruiFloatingStack")
  #|   const previousFloatingStack = globalThis.__ruiFloatingStack
  #|   const hadOutsidePress = own("__ruiDialogOutsidePressHadFloating")
  #|   const previousOutsidePress = globalThis.__ruiDialogOutsidePressHadFloating
  #|   class FakeMouseEvent {}
  #|   globalThis.MouseEvent = FakeMouseEvent
  #|   globalThis.__ruiFloatingStack = []
  #|   globalThis.__ruiDialogOutsidePressHadFloating = false
  #|   globalThis.document = {
  #|     querySelector: selector => selector === ":popover-open" && nestedFloating
  #|       ? {}
  #|       : null,
  #|     getElementById: () => null,
  #|   }
  #|   let scheduler
  #|   const run = command => {
  #|     if (!command) return
  #|     if (command.$tag === 0) {
  #|       for (const child of command._0 || []) run(child)
  #|     } else if (command.$tag === 1) {
  #|       command._1(scheduler)
  #|     } else if (command.$tag === 3) {
  #|       command._0(scheduler)
  #|     }
  #|   }
  #|   scheduler = {
  #|     self: null,
  #|     method_table: { method_3: (_self, command) => run(command) },
  #|   }
  #|   try {
  #|     entry.value(new FakeMouseEvent(), scheduler)
  #|     return true
  #|   } finally {
  #|     if (hadDocument) globalThis.document = previousDocument
  #|     else delete globalThis.document
  #|     if (hadMouseEvent) globalThis.MouseEvent = previousMouseEvent
  #|     else delete globalThis.MouseEvent
  #|     if (hadFloatingStack) globalThis.__ruiFloatingStack = previousFloatingStack
  #|     else delete globalThis.__ruiFloatingStack
  #|     if (hadOutsidePress) {
  #|       globalThis.__ruiDialogOutsidePressHadFloating = previousOutsidePress
  #|     } else {
  #|       delete globalThis.__ruiDialogOutsidePressHadFloating
  #|     }
  #|   }
  #| }

///|
#cfg(target="js")
test "command root composes caller keydown with keyboard navigation" {
  let scope = command_scope(
    "command-keydown",
    None,
    { query: "", active: -1, open: true, generation: 0 },
    [],
    false,
    command_default_filter,
    true,
    false,
    true,
    @cmd.Emit(_ => {
      ffi_note_command_internal_keydown()
      @cmd.none
    }),
    None,
    None,
    None,
    Ref("command-keydown-list"),
  )
  let caller_attrs = @html.Attrs::build().on_keydown(_ => {
    ffi_note_command_caller_keydown()
    @cmd.none
  })
  let attrs = command_keyboard_attrs(scope, Some(caller_attrs))
  ffi_reset_command_event_fixture()
  assert_true(ffi_fire_command_keydown(attrs, "ArrowDown"))
  assert_eq(ffi_command_event_trace(), "caller,internal")
}

///|
#cfg(target="js")
test "command dialog overlay preserves a nested floating layer" {
  let emit = @cmd.Emit(message => {
    match message {
      CommandRequestClose =>
        @cmd.custom_cmd(_ => ffi_note_command_overlay_close())
      _ => @cmd.none
    }
  })
  let html = command_dialog_view(
    "layered-command",
    { query: "", active: -1, open: true, generation: 0 },
    command_default_filter,
    true,
    true,
    emit,
    Some(true),
    None,
    None,
    "Commands",
    true,
    None,
    None,
    None,
    [],
    None,
    [],
    None,
    [],
    None,
    _ => @html.nothing,
  )
  ffi_reset_command_event_fixture()
  assert_true(ffi_fire_command_dialog_overlay_click(html, true))
  assert_eq(ffi_command_overlay_closes(), 0)
  assert_true(ffi_fire_command_dialog_overlay_click(html, false))
  assert_eq(ffi_command_overlay_closes(), 1)
}

///|
#cfg(target="js")
test "command dialog close state survives its exit window and stale finalize" {
  let open : CommandModel = {
    query: "set",
    active: 2,
    open: true,
    generation: 4,
  }
  let closing = command_test_update(CommandRequestClose, open)
  assert_true(!closing.open)
  assert_eq(closing.query, "set")
  assert_eq(closing.active, 2)
  assert_eq(closing.generation, 5)
  let reopened = command_test_update(CommandOpen, closing)
  assert_true(reopened.open)
  assert_eq(reopened.query, "")
  assert_eq(reopened.active, -1)
  assert_eq(reopened.generation, 6)
  let after_stale_finalize = command_test_update(
    CommandFinalizeClose(5),
    reopened,
  )
  assert_true(after_stale_finalize.open)
  assert_eq(after_stale_finalize.generation, 6)
}

///|
#cfg(target="js")
test "command selection enters closed state before native removal" {
  let open : CommandModel = {
    query: "dash",
    active: 0,
    open: true,
    generation: 8,
  }
  let closing = command_test_update(CommandSelect("Dashboard", @cmd.none), open)
  assert_true(!closing.open)
  assert_eq(closing.query, "")
  assert_eq(closing.active, -1)
  assert_eq(closing.generation, 9)
  let idempotent = command_test_update(CommandRequestClose, closing)
  assert_eq(idempotent.generation, 9)
  assert_true(!idempotent.open)
}
