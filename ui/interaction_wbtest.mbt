///|
#cfg(target="js")
extern "js" fn ffi_install_dialog_escape_fixture(id : String) -> Unit =
  #| id => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const listeners = {}
  #|   const fixture = globalThis.__ruiEscapeFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     HTMLDialogElement: globalThis.HTMLDialogElement,
  #|     hadHTMLDialogElement: own("HTMLDialogElement"),
  #|     dialogStack: globalThis.__ruiDialogStack,
  #|     hadDialogStack: own("__ruiDialogStack"),
  #|     floatingStack: globalThis.__ruiFloatingStack,
  #|     hadFloatingStack: own("__ruiFloatingStack"),
  #|     requested: 0,
  #|     prevented: false,
  #|     listeners,
  #|   }
  #|   class FakeDialog {
  #|     constructor() {
  #|       this.id = id
  #|       this.open = true
  #|       this.isConnected = true
  #|       this.dataset = {
  #|         modal: "true",
  #|         closeOnEscape: "true",
  #|         restoreFocus: "true",
  #|       }
  #|     }
  #|     addEventListener() {}
  #|   }
  #|   const dialog = new FakeDialog()
  #|   fixture.dialog = dialog
  #|   globalThis.HTMLDialogElement = FakeDialog
  #|   globalThis.__ruiDialogStack = [id]
  #|   globalThis.__ruiFloatingStack = []
  #|   globalThis.document = {
  #|     activeElement: null,
  #|     body: {},
  #|     getElementById: value => value === id ? dialog : null,
  #|     querySelector: () => null,
  #|     addEventListener: (type, callback) => { listeners[type] = callback },
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_fire_dialog_escape_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiEscapeFixture
  #|   const event = {
  #|     key: "Escape",
  #|     defaultPrevented: false,
  #|     preventDefault() {
  #|       this.defaultPrevented = true
  #|       fixture.prevented = true
  #|     },
  #|     stopPropagation() {},
  #|   }
  #|   fixture.listeners.keydown(event)
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_dialog_escape_fixture_requested() -> Int =
  #| () => globalThis.__ruiEscapeFixture?.requested ?? 0

///|
#cfg(target="js")
extern "js" fn ffi_escape_fixture_prevented() -> Bool =
  #| () => Boolean(globalThis.__ruiEscapeFixture?.prevented)

///|
#cfg(target="js")
extern "js" fn ffi_mark_dialog_escape_fixture_requested() -> Unit =
  #| () => { globalThis.__ruiEscapeFixture.requested += 1 }

///|
#cfg(target="js")
extern "js" fn ffi_install_floating_escape_fixture(id : String) -> Unit =
  #| id => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const listeners = {}
  #|   const popupListeners = {}
  #|   const fixture = globalThis.__ruiEscapeFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     HTMLDialogElement: globalThis.HTMLDialogElement,
  #|     hadHTMLDialogElement: own("HTMLDialogElement"),
  #|     dialogStack: globalThis.__ruiDialogStack,
  #|     hadDialogStack: own("__ruiDialogStack"),
  #|     floatingStack: globalThis.__ruiFloatingStack,
  #|     hadFloatingStack: own("__ruiFloatingStack"),
  #|     hidden: 0,
  #|     prevented: false,
  #|     listeners,
  #|   }
  #|   class FakeDialog {}
  #|   let open = true
  #|   const popup = {
  #|     id,
  #|     isConnected: true,
  #|     dataset: { restoreFocus: "false", slot: "popover-content" },
  #|     matches: selector => selector === ":popover-open" && open,
  #|     closest: () => null,
  #|     addEventListener: (type, callback) => { popupListeners[type] = callback },
  #|     hidePopover: () => {
  #|       open = false
  #|       fixture.hidden += 1
  #|       popupListeners.toggle?.({ oldState: "open", newState: "closed" })
  #|     },
  #|   }
  #|   fixture.popup = popup
  #|   globalThis.HTMLDialogElement = FakeDialog
  #|   globalThis.__ruiDialogStack = []
  #|   globalThis.__ruiFloatingStack = []
  #|   globalThis.document = {
  #|     activeElement: null,
  #|     body: {},
  #|     getElementById: value => value === id ? popup : null,
  #|     addEventListener: (type, callback) => { listeners[type] = callback },
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_fire_floating_escape_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiEscapeFixture
  #|   const event = {
  #|     key: "Escape",
  #|     defaultPrevented: false,
  #|     preventDefault() {
  #|       this.defaultPrevented = true
  #|       fixture.prevented = true
  #|     },
  #|     stopPropagation() {},
  #|   }
  #|   fixture.listeners.keydown(event)
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_floating_escape_fixture_hidden() -> Int =
  #| () => globalThis.__ruiEscapeFixture?.hidden ?? 0

///|
#cfg(target="js")
extern "js" fn ffi_install_fallback_floating_fixture(id : String) -> Unit =
  #| id => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const listeners = {}
  #|   const popupListeners = {}
  #|   const fixture = globalThis.__ruiEscapeFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     HTMLDialogElement: globalThis.HTMLDialogElement,
  #|     hadHTMLDialogElement: own("HTMLDialogElement"),
  #|     dialogStack: globalThis.__ruiDialogStack,
  #|     hadDialogStack: own("__ruiDialogStack"),
  #|     floatingStack: globalThis.__ruiFloatingStack,
  #|     hadFloatingStack: own("__ruiFloatingStack"),
  #|     hidden: 0,
  #|     stopped: 0,
  #|     prevented: false,
  #|     listeners,
  #|   }
  #|   class FakeDialog {}
  #|   const popup = {
  #|     id,
  #|     isConnected: true,
  #|     __ruiFloatingOpen: true,
  #|     dataset: { restoreFocus: "false", slot: "popover-content" },
  #|     matches: () => false,
  #|     closest: () => null,
  #|     contains: () => false,
  #|     addEventListener: (type, callback) => { popupListeners[type] = callback },
  #|     __ruiFloatingStopPositioning: () => { fixture.stopped += 1 },
  #|   }
  #|   fixture.popup = popup
  #|   globalThis.HTMLDialogElement = FakeDialog
  #|   globalThis.__ruiDialogStack = []
  #|   globalThis.__ruiFloatingStack = []
  #|   globalThis.document = {
  #|     activeElement: null,
  #|     body: {},
  #|     getElementById: value => value === id ? popup : null,
  #|     addEventListener: (type, callback) => { listeners[type] = callback },
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_fallback_floating_fixture_stack_length() -> Int =
  #| () => globalThis.__ruiFloatingStack?.length ?? 0

///|
#cfg(target="js")
extern "js" fn ffi_fallback_floating_fixture_stopped() -> Int =
  #| () => globalThis.__ruiEscapeFixture?.stopped ?? 0

///|
#cfg(target="js")
extern "js" fn ffi_install_layered_escape_fixture(
  dialog_id : String,
  popup_id : String,
) -> Unit =
  #| (dialogId, popupId) => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const listeners = {}
  #|   const popupListeners = {}
  #|   const fixture = globalThis.__ruiEscapeFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     HTMLDialogElement: globalThis.HTMLDialogElement,
  #|     hadHTMLDialogElement: own("HTMLDialogElement"),
  #|     dialogStack: globalThis.__ruiDialogStack,
  #|     hadDialogStack: own("__ruiDialogStack"),
  #|     floatingStack: globalThis.__ruiFloatingStack,
  #|     hadFloatingStack: own("__ruiFloatingStack"),
  #|     requested: 0,
  #|     hidden: 0,
  #|     prevented: false,
  #|     listeners,
  #|   }
  #|   class FakeDialog {
  #|     constructor() {
  #|       this.id = dialogId
  #|       this.open = true
  #|       this.isConnected = true
  #|       this.dataset = {
  #|         modal: "true",
  #|         closeOnEscape: "true",
  #|         restoreFocus: "true",
  #|       }
  #|     }
  #|     addEventListener() {}
  #|   }
  #|   let popupOpen = true
  #|   const dialog = new FakeDialog()
  #|   const popup = {
  #|     id: popupId,
  #|     isConnected: true,
  #|     dataset: { restoreFocus: "false", slot: "popover-content" },
  #|     matches: selector => selector === ":popover-open" && popupOpen,
  #|     closest: () => null,
  #|     addEventListener: (type, callback) => { popupListeners[type] = callback },
  #|     hidePopover: () => {
  #|       popupOpen = false
  #|       fixture.hidden += 1
  #|       popupListeners.toggle?.({ oldState: "open", newState: "closed" })
  #|     },
  #|   }
  #|   fixture.dialog = dialog
  #|   fixture.popup = popup
  #|   globalThis.HTMLDialogElement = FakeDialog
  #|   globalThis.__ruiDialogStack = [dialogId]
  #|   globalThis.__ruiFloatingStack = []
  #|   globalThis.document = {
  #|     activeElement: null,
  #|     body: {},
  #|     getElementById: value => value === dialogId
  #|       ? dialog
  #|       : value === popupId ? popup : null,
  #|     querySelector: selector => selector === ":popover-open" && popupOpen
  #|       ? popup
  #|       : null,
  #|     addEventListener: (type, callback) => {
  #|       const callbacks = listeners[type] ||= []
  #|       callbacks.push(callback)
  #|     },
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_fire_layered_escape_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiEscapeFixture
  #|   const event = {
  #|     key: "Escape",
  #|     defaultPrevented: false,
  #|     preventDefault() {
  #|       this.defaultPrevented = true
  #|       fixture.prevented = true
  #|     },
  #|     stopPropagation() {},
  #|   }
  #|   for (const callback of fixture.listeners.keydown || []) callback(event)
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_restore_escape_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiEscapeFixture
  #|   if (!fixture) return
  #|   const restore = (key, had, value) => {
  #|     if (had) globalThis[key] = value
  #|     else delete globalThis[key]
  #|   }
  #|   restore("document", fixture.hadDocument, fixture.document)
  #|   restore(
  #|     "HTMLDialogElement",
  #|     fixture.hadHTMLDialogElement,
  #|     fixture.HTMLDialogElement,
  #|   )
  #|   restore(
  #|     "__ruiDialogStack",
  #|     fixture.hadDialogStack,
  #|     fixture.dialogStack,
  #|   )
  #|   restore(
  #|     "__ruiFloatingStack",
  #|     fixture.hadFloatingStack,
  #|     fixture.floatingStack,
  #|   )
  #|   delete globalThis.__ruiEscapeFixture
  #| }

///|
#cfg(target="js")
test "Escape explicitly requests closing the top modal dialog" {
  ffi_install_dialog_escape_fixture("escape-dialog")
  ffi_bind_dialog_layer(
    "escape-dialog", ffi_mark_dialog_escape_fixture_requested,
  )
  ffi_fire_dialog_escape_fixture()
  let requested = ffi_dialog_escape_fixture_requested()
  let prevented = ffi_escape_fixture_prevented()
  ffi_restore_escape_fixture()
  assert_eq(requested, 1)
  assert_true(prevented)
}

///|
#cfg(target="js")
test "Escape explicitly hides the top native popover" {
  ffi_install_floating_escape_fixture("escape-popover")
  ffi_bind_floating_sync("escape-popover", _ => ())
  ffi_fire_floating_escape_fixture()
  let hidden = ffi_floating_escape_fixture_hidden()
  let prevented = ffi_escape_fixture_prevented()
  ffi_restore_escape_fixture()
  assert_eq(hidden, 1)
  assert_true(prevented)
}

///|
#cfg(target="js")
test "fallback floating layer stays in the stack and closes through one lifecycle" {
  ffi_install_fallback_floating_fixture("fallback-popover")
  let mut closed = 0
  ffi_bind_floating_sync("fallback-popover", open => if !open { closed += 1 })
  let open_stack = ffi_fallback_floating_fixture_stack_length()
  ffi_fire_floating_escape_fixture()
  let closed_stack = ffi_fallback_floating_fixture_stack_length()
  let stopped = ffi_fallback_floating_fixture_stopped()
  let prevented = ffi_escape_fixture_prevented()
  ffi_restore_escape_fixture()
  assert_eq(open_stack, 1)
  assert_eq(closed_stack, 0)
  assert_eq(closed, 1)
  assert_eq(stopped, 1)
  assert_true(prevented)
}

///|
#cfg(target="js")
test "Escape closes only the floating layer above a modal dialog" {
  ffi_install_layered_escape_fixture("layered-dialog", "layered-popover")
  ffi_bind_dialog_layer(
    "layered-dialog", ffi_mark_dialog_escape_fixture_requested,
  )
  ffi_bind_floating_sync("layered-popover", _ => ())
  ffi_fire_layered_escape_fixture()
  let requested = ffi_dialog_escape_fixture_requested()
  let hidden = ffi_floating_escape_fixture_hidden()
  ffi_restore_escape_fixture()
  assert_eq(requested, 0)
  assert_eq(hidden, 1)
}
