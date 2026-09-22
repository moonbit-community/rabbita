// Whitebox tests run within the package scope.
// Use them to validate internal helpers or invariants.
// Keep them focused; public behavior belongs in `_test.mbt`.

///|
fn has_dirty_parent(child : DirtyFlag, parent : DirtyFlag) -> Bool {
  child.parents.any(x => x.id == parent.id)
}

///|
fn dirty_parent_count(child : DirtyFlag, parent : DirtyFlag) -> Int {
  let mut count = 0
  for candidate in child.parents {
    if candidate.id == parent.id {
      count += 1
    }
  }
  count
}

///|
fn[A] child_count(parent : Node[A], child_id : Int) -> Int {
  let mut count = 0
  for child in parent.childs {
    if child.get_id() == child_id {
      count += 1
    }
  }
  count
}

///|
test "map2 records only child to parent dirty edges" {
  let (x, _) = input(1)
  let (y, _) = input(2)
  let sum = x.map2(y, (x, y) => x + y)

  inspect(sum.read(), content="3")
  assert_true(has_dirty_parent(x.dirty_flag, sum.dirty_flag))
  assert_true(has_dirty_parent(y.dirty_flag, sum.dirty_flag))
  assert_true(!has_dirty_parent(sum.dirty_flag, x.dirty_flag))
  assert_true(!has_dirty_parent(sum.dirty_flag, y.dirty_flag))
}

///|
test "bind detaches previous dynamic dirty parent" {
  let (use_left, set_use_left) = input(true)
  let (left_input, _) = input(1)
  let (right_input, _) = input(10)
  let left = left_input.map(x => x + 100)
  let right = right_input.map(x => x + 1000)
  let bound = use_left.bind(enabled => if enabled { left } else { right })

  inspect(bound.read(), content="101")
  assert_true(has_dirty_parent(left.dirty_flag, bound.dirty_flag))
  assert_true(!has_dirty_parent(right.dirty_flag, bound.dirty_flag))

  set_use_left(false)
  inspect(bound.read(), content="1010")
  assert_true(!has_dirty_parent(left.dirty_flag, bound.dirty_flag))
  assert_true(has_dirty_parent(right.dirty_flag, bound.dirty_flag))
}

///|
test "bind keeps static selector dirty parent when selector was dynamic child" {
  let (selector, set_selector) = input(1)
  let (fallback, _) = input(10)
  let bound = selector.bind(x => if x == 1 { selector } else { fallback })

  inspect(bound.read(), content="1")
  assert_true(has_dirty_parent(selector.dirty_flag, bound.dirty_flag))

  set_selector(2)
  inspect(bound.read(), content="10")
  assert_true(has_dirty_parent(selector.dirty_flag, bound.dirty_flag))
  assert_true(has_dirty_parent(fallback.dirty_flag, bound.dirty_flag))
}

///|
test "bind selector branch should not duplicate selector dependency" {
  let (selector, _) = input(1)
  let (fallback, _) = input(10)
  let parent = selector.bind(value => {
    if value == 1 {
      selector
    } else {
      fallback
    }
  })

  inspect(parent.read(), content="1")
  debug_inspect(
    [
      dirty_parent_count(selector.dirty_flag, parent.dirty_flag),
      child_count(parent, selector.id),
    ],
    content="[1, 1]",
  )
}

///|
test "bind selector branch can switch away and back" {
  let (selector, set_selector) = input(1)
  let (fallback, set_fallback) = input(10)
  let parent = selector.bind(value => {
    if value == 1 {
      selector
    } else {
      fallback
    }
  })

  inspect(parent.read(), content="1")
  inspect(child_count(parent, selector.id), content="1")

  set_selector(2)
  inspect(parent.read(), content="10")
  assert_true(has_dirty_parent(fallback.dirty_flag, parent.dirty_flag))
  inspect(child_count(parent, selector.id), content="1")
  inspect(child_count(parent, fallback.id), content="1")

  set_selector(1)
  inspect(parent.read(), content="1")
  assert_true(!has_dirty_parent(fallback.dirty_flag, parent.dirty_flag))
  inspect(child_count(parent, selector.id), content="1")
  inspect(child_count(parent, fallback.id), content="0")

  set_selector(2)
  inspect(parent.read(), content="10")
  assert_true(has_dirty_parent(fallback.dirty_flag, parent.dirty_flag))
  set_fallback(11)
  inspect(parent.read(), content="11")
  assert_true(has_dirty_parent(fallback.dirty_flag, parent.dirty_flag))
  set_fallback(12)
  inspect(parent.read(), content="12")
}

///|
enum WbRoute {
  WbHome
  WbDetail
} derive(Eq)

///|
pub extend WbRoute with Eq::{equal, not_equal}

///|
impl @common.Enumerate for WbRoute with fn tag(self) {
  match self {
    WbHome => "home"
    WbDetail => "detail"
  }
}

///|
test "switch removes disposed branch scope from owner scope" {
  let mut home_disposes = 0
  let mut detail_disposes = 0
  let (owner, selected, set_route) = with_scope(owner => {
    let (route, set_route) = input(WbHome)
    let (home, _) = input(1)
    let (detail, _) = input(10)
    let selected = route.switch(route => {
      match route {
        WbHome => {
          on_cleanup(() => home_disposes = home_disposes + 1)
          home
        }
        WbDetail => {
          on_cleanup(() => detail_disposes = detail_disposes + 1)
          detail
        }
      }
    })
    (owner, selected, set_route)
  })

  inspect(global_scopes[owner.0].sub_scopes.length(), content="0")
  inspect(selected.read(), content="1")
  inspect(global_scopes[owner.0].sub_scopes.length(), content="1")

  set_route(WbDetail)
  inspect(selected.read(), content="10")
  inspect(home_disposes, content="1")
  inspect(detail_disposes, content="0")
  inspect(global_scopes[owner.0].sub_scopes.length(), content="1")

  set_route(WbHome)
  inspect(selected.read(), content="1")
  inspect(home_disposes, content="1")
  inspect(detail_disposes, content="1")
  inspect(global_scopes[owner.0].sub_scopes.length(), content="1")
}

///|
test "assoc removes disposed entry scopes from owner scope" {
  let mut dispose_runs = 0
  let (owner, values, set_source) = with_scope(owner => {
    let (source, set_source) = input(@vector.from_array([(1, 10), (2, 20)]))
    let values = source.assoc((key, value) => {
      on_cleanup(() => dispose_runs = dispose_runs + 1)
      value.map1(v => key * 100 + v)
    })
    (owner, values, set_source)
  })

  inspect(global_scopes[owner.0].sub_scopes.length(), content="0")
  debug_inspect(values.read(), content="<Vector: [110, 220]>")
  inspect(global_scopes[owner.0].sub_scopes.length(), content="2")

  set_source(@vector.from_array([(2, 20)]))
  debug_inspect(values.read(), content="<Vector: [220]>")
  inspect(dispose_runs, content="1")
  inspect(global_scopes[owner.0].sub_scopes.length(), content="1")

  set_source(@vector.from_array([]))
  debug_inspect(values.read(), content="<Vector: []>")
  inspect(dispose_runs, content="2")
  inspect(global_scopes[owner.0].sub_scopes.length(), content="0")
}

///|
test "scope dispose runs registered cleanup" {
  let mut cleanup_runs = 0
  let scope = with_scope(scope => {
    on_cleanup(() => cleanup_runs = cleanup_runs + 1)
    scope
  })

  inspect(cleanup_runs, content="0")
  scope.cleanup()
  inspect(cleanup_runs, content="1")
  assert_true(global_scopes.get(scope.0) is None)
}

///|
test "scope dispose keeps unrelated sibling scope alive" {
  let mut cleanup_runs = 0
  let (left, right) = with_scope(_owner => {
    let left = with_scope(scope => {
      on_cleanup(() => cleanup_runs = cleanup_runs + 1)
      scope
    })
    let right = with_scope(scope => {
      on_cleanup(() => cleanup_runs = cleanup_runs + 10)
      scope
    })
    (left, right)
  })

  left.cleanup()
  inspect(cleanup_runs, content="1")
  assert_true(global_scopes.get(left.0) is None)
  assert_true(global_scopes.get(right.0) is Some(_))

  right.cleanup()
  inspect(cleanup_runs, content="11")
  assert_true(global_scopes.get(right.0) is None)
}

///|
test "scope dispose recurses into sub scopes and runs cleanups" {
  let cleanup_log : Array[String] = []
  let parent = with_scope(parent => {
    on_cleanup(() => cleanup_log.push("parent"))
    ignore(
      with_scope(child => {
        on_cleanup(() => cleanup_log.push("child"))
        child
      }),
    )
    parent
  })

  parent.cleanup()
  debug_inspect(cleanup_log, content="[\"child\", \"parent\"]")
  assert_true(global_scopes.get(parent.0) is None)
}
