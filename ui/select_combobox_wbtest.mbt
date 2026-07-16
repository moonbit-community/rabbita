///|
test "select typeahead skips disabled options and cycles enabled matches" {
  let options = [
    select_option(value="aaron", label="Aaron", disabled=true),
    select_option(value="apple", label="Apple"),
    select_option(value="avocado", label="Avocado"),
  ]
  assert_eq(select_typeahead_index(options, -1, "a"), 1)
  assert_eq(select_typeahead_index(options, 1, "a"), 2)
  assert_eq(select_typeahead_index(options, 2, "z"), -1)
  assert_eq(select_typeahead_search("", "A"), "a")
  assert_eq(select_typeahead_search("a", "A"), "a")
  assert_eq(select_typeahead_search("a", "p"), "ap")
}

///|
test "combobox derives selected input and treats that label as an unfiltered query" {
  let options = [
    combobox_option(value="apple", label="Apple"),
    combobox_option(value="banana", label="Banana"),
  ]
  assert_eq(combobox_selected_input_value(options, ["banana"], false), "Banana")
  assert_eq(combobox_filter_query(options, ["banana"], false, "Banana"), "")
  assert_eq(
    combobox_filter_query(options, ["banana"], false, "Bananax"),
    "Bananax",
  )
  assert_eq(combobox_selected_input_value(options, ["banana"], true), "")
}

///|
test "combobox virtual navigation starts at an edge and skips disabled matches" {
  let options = [
    combobox_option(value="disabled", label="Disabled", disabled=true),
    combobox_option(value="apple", label="Apple"),
    combobox_option(value="banana", label="Banana"),
  ]
  assert_eq(combobox_next_match(options, "", -1, 1), 1)
  assert_eq(combobox_next_match(options, "", -1, -1), 2)
  assert_eq(combobox_next_match(options, "app", -1, 1), 1)
  assert_eq(combobox_next_match(options, "missing", -1, 1), -1)
}

///|
test "listbox native layer changes before focus restoration" {
  let calls : Array[String] = []
  ui_listbox_run_open_sequence(
    () => calls.push("show-popover"),
    Some(() => calls.push("focus-control")),
  )
  assert_eq(calls.length(), 2)
  assert_eq(calls[0], "show-popover")
  assert_eq(calls[1], "focus-control")

  calls.clear()
  ui_listbox_run_open_sequence(() => calls.push("hide-popover"), None)
  assert_eq(calls.length(), 1)
  assert_eq(calls[0], "hide-popover")
}

///|
#cfg(target="js")
extern "js" fn ffi_install_select_trigger_fixture(root_id : String) -> Unit =
  #| rootId => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const trigger = { id: "caller-owned-trigger", dataset: { slot: "select-trigger" } }
  #|   const content = { id: "caller-owned-content", dataset: {} }
  #|   const root = { querySelectorAll: () => [trigger, content] }
  #|   globalThis.__ruiSelectTriggerFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     content,
  #|   }
  #|   globalThis.document = {
  #|     getElementById: id => id === `${rootId}-root`
  #|       ? root
  #|       : id === content.id ? content : null,
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_select_trigger_fixture_id() -> String =
  #| () => globalThis.__ruiSelectTriggerFixture.content.dataset.triggerId || ""

///|
#cfg(target="js")
extern "js" fn ffi_restore_select_trigger_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiSelectTriggerFixture
  #|   if (!fixture) return
  #|   if (fixture.hadDocument) globalThis.document = fixture.document
  #|   else delete globalThis.document
  #|   delete globalThis.__ruiSelectTriggerFixture
  #| }

///|
#cfg(target="js")
test "select resolves a caller-owned trigger id from its component root" {
  let root_id = "independent-select"
  ffi_install_select_trigger_fixture(root_id)
  ffi_sync_select_trigger_id(root_id, "caller-owned-content")
  let trigger_id = ffi_select_trigger_fixture_id()
  ffi_restore_select_trigger_fixture()
  assert_eq(trigger_id, "caller-owned-trigger")
}

///|
#cfg(target="js")
extern "js" fn ffi_install_combobox_press_fixture(root_id : String) -> Unit =
  #| rootId => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const fixture = globalThis.__ruiComboboxPressFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     listeners: {},
  #|     dispatches: [],
  #|     prevented: 0,
  #|   }
  #|   const root = {
  #|     dataset: { state: "closed" },
  #|     addEventListener: (type, listener) => { fixture.listeners[type] = listener },
  #|     contains: target => target?.root === root,
  #|   }
  #|   fixture.root = root
  #|   globalThis.document = {
  #|     getElementById: id => id === `${rootId}-root` ? root : null,
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_fire_combobox_press_fixture(
  event_type : String,
  slot : String,
) -> Unit =
  #| (eventType, slot) => {
  #|   const fixture = globalThis.__ruiComboboxPressFixture
  #|   const target = {
  #|     dataset: { slot },
  #|     root: fixture.root,
  #|     closest: selector => selector.includes(`[data-slot="${slot}"]`)
  #|       ? target
  #|       : null,
  #|   }
  #|   fixture.listeners[eventType]?.({
  #|     target,
  #|     preventDefault: () => { fixture.prevented += 1 },
  #|   })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_combobox_press_fixture_dispatches() -> Int =
  #| () => globalThis.__ruiComboboxPressFixture.dispatches.length

///|
#cfg(target="js")
extern "js" fn ffi_combobox_press_fixture_last_dispatch() -> Int =
  #| () => globalThis.__ruiComboboxPressFixture.dispatches.at(-1) ?? -1

///|
#cfg(target="js")
extern "js" fn ffi_combobox_press_fixture_prevented() -> Int =
  #| () => globalThis.__ruiComboboxPressFixture.prevented

///|
#cfg(target="js")
extern "js" fn ffi_combobox_press_fixture_record_dispatch(kind : Int) -> Unit =
  #| kind => { globalThis.__ruiComboboxPressFixture.dispatches.push(kind) }

///|
#cfg(target="js")
extern "js" fn ffi_restore_combobox_press_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiComboboxPressFixture
  #|   if (!fixture) return
  #|   if (fixture.hadDocument) globalThis.document = fixture.document
  #|   else delete globalThis.document
  #|   delete globalThis.__ruiComboboxPressFixture
  #| }

///|
#cfg(target="js")
test "combobox opens after input release and preserves item press focus" {
  let root_id = "press-combobox"
  ffi_install_combobox_press_fixture(root_id)
  ffi_bind_combobox_events(root_id, kind => {
    ffi_combobox_press_fixture_record_dispatch(kind)
  })
  ffi_fire_combobox_press_fixture("mousedown", "combobox-input")
  let input_down_dispatches = ffi_combobox_press_fixture_dispatches()
  ffi_fire_combobox_press_fixture("click", "combobox-input")
  let input_click_dispatches = ffi_combobox_press_fixture_dispatches()
  let input_click_kind = ffi_combobox_press_fixture_last_dispatch()
  ffi_fire_combobox_press_fixture("mousedown", "combobox-item")
  let item_press_prevented = ffi_combobox_press_fixture_prevented()
  ffi_fire_combobox_press_fixture("click", "combobox-item")
  let final_dispatches = ffi_combobox_press_fixture_dispatches()
  ffi_restore_combobox_press_fixture()

  assert_eq(input_down_dispatches, 0)
  assert_eq(input_click_dispatches, 1)
  assert_eq(input_click_kind, 0)
  assert_eq(item_press_prevented, 1)
  assert_eq(final_dispatches, 1)
}
