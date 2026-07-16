///|
#cfg(target="js")
extern "js" fn ffi_install_calendar_focus_fixture(
  active_calendar : Int,
) -> Unit =
  #| activeCalendar => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const isoDate = "2041-11-03"
  #|   const fixture = globalThis.__ruiCalendarFocusFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     focused: 0,
  #|   }
  #|   const makeDay = owner => ({
  #|     dataset: { day: isoDate },
  #|     disabled: false,
  #|     tabIndex: -1,
  #|     focus: () => { fixture.focused = owner },
  #|   })
  #|   const firstDay = makeDay(1)
  #|   const secondDay = makeDay(2)
  #|   const makeRoot = (id, day) => ({
  #|     id,
  #|     dataset: { slot: "calendar" },
  #|     querySelectorAll: selector => selector === '[data-slot="calendar-day-button"]'
  #|       ? [day]
  #|       : [],
  #|   })
  #|   const firstRoot = makeRoot("calendar-first", firstDay)
  #|   const secondRoot = makeRoot("calendar-second", secondDay)
  #|   fixture.firstDay = firstDay
  #|   fixture.secondDay = secondDay
  #|   fixture.firstRoot = firstRoot
  #|   fixture.secondRoot = secondRoot
  #|   const activeRoot = activeCalendar === 1
  #|     ? firstRoot
  #|     : activeCalendar === 2 ? secondRoot : null
  #|   globalThis.document = {
  #|     activeElement: activeRoot
  #|       ? { closest: selector => selector === '[data-slot="calendar"]' ? activeRoot : null }
  #|       : null,
  #|     getElementById: id => id === firstRoot.id
  #|       ? firstRoot
  #|       : id === secondRoot.id ? secondRoot : null,
  #|     querySelectorAll: selector => selector === '[data-slot="calendar"]'
  #|       ? [firstRoot, secondRoot]
  #|       : [],
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_calendar_focus_fixture_result() -> Int =
  #| () => globalThis.__ruiCalendarFocusFixture.focused

///|
#cfg(target="js")
extern "js" fn ffi_calendar_focus_fixture_tab_index(calendar : Int) -> Int =
  #| calendar => calendar === 1
  #|   ? globalThis.__ruiCalendarFocusFixture.firstDay.tabIndex
  #|   : globalThis.__ruiCalendarFocusFixture.secondDay.tabIndex

///|
#cfg(target="js")
extern "js" fn ffi_disable_calendar_focus_fixture_day(calendar : Int) -> Unit =
  #| calendar => {
  #|   const fixture = globalThis.__ruiCalendarFocusFixture
  #|   if (calendar === 1) fixture.firstDay.disabled = true
  #|   else fixture.secondDay.disabled = true
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_restore_calendar_focus_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiCalendarFocusFixture
  #|   if (!fixture) return
  #|   if (fixture.hadDocument) globalThis.document = fixture.document
  #|   else delete globalThis.document
  #|   delete globalThis.__ruiCalendarFocusFixture
  #| }

///|
#cfg(target="js")
test "calendar focus uses the requested root id with duplicate dates" {
  ffi_install_calendar_focus_fixture(0)
  ffi_focus_calendar_day("calendar-second", "2041-11-03")
  let focused = ffi_calendar_focus_fixture_result()
  let first_tab_index = ffi_calendar_focus_fixture_tab_index(1)
  let second_tab_index = ffi_calendar_focus_fixture_tab_index(2)
  ffi_restore_calendar_focus_fixture()
  assert_eq(focused, 2)
  assert_eq(first_tab_index, -1)
  assert_eq(second_tab_index, 0)
}

///|
#cfg(target="js")
test "calendar focus without an id refuses ambiguous fallback roots" {
  ffi_install_calendar_focus_fixture(0)
  ffi_focus_calendar_day("", "2041-11-03")
  let focused = ffi_calendar_focus_fixture_result()
  let first_tab_index = ffi_calendar_focus_fixture_tab_index(1)
  let second_tab_index = ffi_calendar_focus_fixture_tab_index(2)
  ffi_restore_calendar_focus_fixture()
  assert_eq(focused, 0)
  assert_eq(first_tab_index, -1)
  assert_eq(second_tab_index, -1)
}

///|
#cfg(target="js")
test "calendar focus without an id uses a unique matching fallback root" {
  ffi_install_calendar_focus_fixture(0)
  ffi_disable_calendar_focus_fixture_day(1)
  ffi_focus_calendar_day("", "2041-11-03")
  let focused = ffi_calendar_focus_fixture_result()
  let first_tab_index = ffi_calendar_focus_fixture_tab_index(1)
  let second_tab_index = ffi_calendar_focus_fixture_tab_index(2)
  ffi_restore_calendar_focus_fixture()
  assert_eq(focused, 2)
  assert_eq(first_tab_index, -1)
  assert_eq(second_tab_index, 0)
}

///|
#cfg(target="js")
test "calendar focus without an id prefers the active calendar" {
  ffi_install_calendar_focus_fixture(2)
  ffi_focus_calendar_day("", "2041-11-03")
  let focused = ffi_calendar_focus_fixture_result()
  let first_tab_index = ffi_calendar_focus_fixture_tab_index(1)
  let second_tab_index = ffi_calendar_focus_fixture_tab_index(2)
  ffi_restore_calendar_focus_fixture()
  assert_eq(focused, 2)
  assert_eq(first_tab_index, -1)
  assert_eq(second_tab_index, 0)
}
