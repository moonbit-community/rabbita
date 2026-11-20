///|
#cfg(target="js")
test "focus generation invalidates an earlier focus task" {
  let id = "menu-focus-generation-test"
  let first = menu_focus_generation(id)
  menu_invalidate_focus(id)
  let second = menu_focus_generation(id)
  assert_false(second == first)
  menu_invalidate_focus(id)
  assert_false(menu_focus_generation(id) == second)
}
