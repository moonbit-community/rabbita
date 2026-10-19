///|
test "assoc preserves nested state without evaluating mixed inputs" {
  let (rows, set_rows) = @duplix.input(@vector.from_array([(1, 10)]))
  let (extra, set_extra) = @duplix.input(1)
  let computed : Array[Int] = []
  let built : Array[String] = []
  let disposed : Array[String] = []
  let mut set_state : ((Int) -> Unit)? = None
  let result = rows.assoc_by(
    (_, row) => row.map2(extra, (row, extra) => {
      let value = row.1 + extra
      computed.push(value)
      value
    }).switch_by(
      value => {
        let tag = if value % 2 == 0 { "even" } else { "odd" }
        built.push(tag)
        @duplix.on_cleanup(() => disposed.push(tag))
        let (state, write) = @duplix.input(1)
        set_state = Some(write)
        state
      },
      by=value => if value % 2 == 0 { "even" } else { "odd" },
    ),
    by=row => row.0,
  )
  @test.assert_eq(result.read().to_array(), [1])
  guard set_state is Some(write) else { fail("expected initialized state") }
  write(7)
  set_rows(@vector.from_array([(1, 11)]))
  set_extra(2)
  @test.assert_eq(result.read().to_array(), [7])
  @test.assert_eq(computed, [11, 13])
  @test.assert_eq(built, ["odd"])
  @test.assert_eq(disposed, [])
}

///|
test "assoc disposes removed rows before evaluating active branches" {
  let (rows, set_rows) = @duplix.input(
    @vector.from_array([(1, 10), (2, 100)]),
  )
  let (extra, set_extra) = @duplix.input(1)
  let computed : Array[Int] = []
  let disposed : Array[Int] = []
  let result = rows.assoc((key, row) => {
    @duplix.on_cleanup(() => disposed.push(key))
    row.map2(extra, (row, extra) => {
      computed.push(key)
      row + extra
    })
  })
  @test.assert_eq(result.read().to_array(), [11, 101])
  computed.clear()
  set_rows(@vector.from_array([(2, 101)]))
  set_extra(2)
  @test.assert_eq(result.read().to_array(), [103])
  @test.assert_eq(computed, [2])
  @test.assert_eq(disposed, [1])
  set_extra(3)
  @test.assert_eq(result.read().to_array(), [104])
  @test.assert_eq(computed, [2, 2])
  @test.assert_eq(disposed, [1])
}

///|
test "shared assoc branch observes its source before the collection is pulled" {
  let (rows, set_rows) = @duplix.input(@vector.from_array([(1, 10)]))
  let (extra, set_extra) = @duplix.input(1)
  let computed : Array[Int] = []
  let mut shared : @duplix.Node[Int]? = None
  let result = rows.assoc((_, row) => {
    let branch = row.map2(extra, (row, extra) => {
      let value = row + extra
      computed.push(value)
      value
    })
    shared = Some(branch)
    branch
  })
  @test.assert_eq(result.read().to_array(), [11])
  guard shared is Some(branch) else { fail("expected initialized branch") }
  // The right dependency is pulled first by the stack-based evaluator.
  let joined = result.map2(branch, (values, value) => (values.to_array(), value))
  @test.assert_eq(joined.read(), ([11], 11))
  set_rows(@vector.from_array([(1, 20)]))
  set_extra(2)
  @test.assert_eq(joined.read(), ([22], 22))
  @test.assert_eq(computed, [11, 22])
}

///|
test "nested assoc evaluates each leaf once with current inputs" {
  let (rows, set_rows) = @duplix.input(
    @vector.from_array([(1, @vector.from_array([(2, 10)]))]),
  )
  let (extra, set_extra) = @duplix.input(1)
  let computed : Array[Int] = []
  let result = rows.assoc((_, nested) =>
    nested.assoc((_, row) =>
      row.map2(extra, (row, extra) => {
        let value = row + extra
        computed.push(value)
        value
      })))
  @test.assert_eq(result.read().to_array().map(values => values.to_array()), [[11]])
  set_rows(@vector.from_array([(1, @vector.from_array([(2, 20)]))]))
  set_extra(2)
  @test.assert_eq(result.read().to_array().map(values => values.to_array()), [[22]])
  @test.assert_eq(computed, [11, 22])
}

///|
test "assoc resolves a nested switch before evaluating its previous branch" {
  let (rows, set_rows) = @duplix.input(@vector.from_array([(1, 10)]))
  let (extra, set_extra) = @duplix.input(1)
  let computed : Array[String] = []
  let disposed : Array[String] = []
  let result = rows.assoc((_, row) => row.switch_by(
    value => {
      let tag = if value < 20 { "home" } else { "detail" }
      @duplix.on_cleanup(() => disposed.push(tag))
      extra.map(extra => {
        computed.push(tag)
        extra
      })
    },
    by=value => if value < 20 { "home" } else { "detail" },
  ))
  @test.assert_eq(result.read().to_array(), [1])
  set_rows(@vector.from_array([(1, 20)]))
  set_extra(2)
  @test.assert_eq(result.read().to_array(), [2])
  @test.assert_eq(computed, ["home", "detail"])
  @test.assert_eq(disposed, ["home"])
}

///|
test "removed row projections retain their last value across key reuse" {
  let (rows, set_rows) = @duplix.input(@vector.from_array([(1, 10)]))
  let captured : Array[@duplix.Node[Int]] = []
  let result = rows.assoc((_, row) => {
    captured.push(row)
    @duplix.constant(0)
  })
  @test.assert_eq(result.read().to_array(), [0])
  // The returned branch does not read the row projection.
  set_rows(@vector.from_array([(1, 20)]))
  @test.assert_eq(result.read().to_array(), [0])
  set_rows(@vector.from_array([]))
  @test.assert_eq(result.read().to_array(), [])
  @test.assert_eq(captured[0].read(), 20)
  set_rows(@vector.from_array([(1, 30)]))
  @test.assert_eq(result.read().to_array(), [0])
  @test.assert_eq(captured[0].read(), 20)
  @test.assert_eq(captured[1].read(), 30)
}

///|
test "shared row reads do not replace a branch lifetime before reconciliation" {
  let (rows, set_rows) = @duplix.input(@vector.from_array([(1, 10)]))
  let captured : Array[@duplix.Node[Int]] = []
  let result = rows.assoc((_, row) => {
    captured.push(row)
    row
  })
  @test.assert_eq(result.read().to_array(), [10])
  set_rows(@vector.from_array([]))
  @test.assert_eq(captured[0].read(), 10)
  // The collection has not observed the removal, so its branch stays alive.
  set_rows(@vector.from_array([(1, 30)]))
  @test.assert_eq(result.read().to_array(), [30])
  @test.assert_eq(captured.length(), 1)
  @test.assert_eq(captured[0].read(), 30)
}

///|
priv struct AssocFrame {
  rows : Array[(Int, Int)]
  extra : Int
  states : Array[(Int, Int)]
  disposals : Map[Int, Int]
}

///|
test "assoc batches preserve branch lifetimes and cutoff across collection edits" {
  let frames : Array[AssocFrame] = [
    { rows: [(1, 10), (2, 100)], extra: 1, states: [(1, 1), (2, 1)], disposals: Map([]) },
    { rows: [(1, 11), (2, 101)], extra: 2, states: [(1, 1), (2, 1)], disposals: Map([]) },
    { rows: [(2, 101), (1, 11)], extra: 2, states: [(2, 1), (1, 1)], disposals: Map([]) },
    { rows: [(2, 101)], extra: 3, states: [(2, 2)], disposals: { 1: 1, 2: 1 } },
    { rows: [(3, 30), (2, 101)], extra: 3, states: [(3, 1), (2, 2)], disposals: { 1: 1, 2: 1 } },
    { rows: [(3, 31), (2, 102)], extra: 4, states: [(3, 1), (2, 2)], disposals: { 1: 1, 2: 1 } },
    { rows: [], extra: 5, states: [], disposals: { 1: 1, 2: 2, 3: 1 } },
    { rows: [(2, 102), (1, 11)], extra: 5, states: [(2, 3), (1, 2)], disposals: { 1: 1, 2: 2, 3: 1 } },
    { rows: [(1, 12), (2, 103)], extra: 4, states: [(1, 2), (2, 3)], disposals: { 1: 1, 2: 2, 3: 1 } },
  ]
  for external_first in [false, true] {
    let (rows, set_rows) = @duplix.input(@vector.from_array([]))
    let (extra, set_extra) = @duplix.input(0)
    let builds : Map[Int, Int] = Map([])
    let disposals : Map[Int, Int] = Map([])
    let computed : Map[Int, (Int, Int)] = Map([])
    let result = rows.assoc((key, row) => row.map2(extra, (row, extra) => {
      let count = computed.get(key).map_or(1, entry => entry.1 + 1)
      computed[key] = (row + extra, count)
      (row + extra) % 2
    }).switch_by(
      _ => {
        let generation = builds.get(key).unwrap_or(0) + 1
        builds[key] = generation
        @duplix.on_cleanup(() => {
          disposals[key] = disposals.get(key).unwrap_or(0) + 1
        })
        @duplix.constant((key, generation))
      },
      by=parity => if parity == 0 { "even" } else { "odd" },
    ))
    let mut previous_rows : Map[Int, Int] = Map([])
    let mut previous_extra = 0
    for frame in frames {
      if external_first {
        set_extra(frame.extra)
        set_rows(@vector.from_array(frame.rows))
        ignore(rows.read())
      } else {
        set_rows(@vector.from_array(frame.rows))
        set_extra(frame.extra)
        ignore(extra.read())
      }
      let expected_computations : Map[Int, (Int, Int)] = Map([])
      for row in frame.rows {
        let (key, value) = row
        if previous_rows.get(key) != Some(value) || previous_extra != frame.extra {
          expected_computations[key] = (value + frame.extra, 1)
        }
      }
      @test.assert_eq(result.read().to_array(), frame.states)
      @test.assert_eq(disposals, frame.disposals)
      @test.assert_eq(computed, expected_computations)
      computed.clear()
      @test.assert_eq(result.read().to_array(), frame.states)
      @test.assert_eq(computed.length(), 0)
      set_rows(@vector.from_array(frame.rows))
      set_extra(frame.extra)
      @test.assert_eq(result.read().to_array(), frame.states)
      @test.assert_eq(computed.length(), 0)
      @test.assert_eq(disposals, frame.disposals)
      previous_rows = Map::from_array(frame.rows)
      previous_extra = frame.extra
    }
  }
}
