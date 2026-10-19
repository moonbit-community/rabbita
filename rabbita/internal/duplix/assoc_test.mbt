///|
test "assoc preserves nested state without evaluating mixed inputs" {
  let (rows, set_rows) = @duplix.input(@vector.from_array([(1, 10)]))
  let (extra, set_extra) = @duplix.input(1)
  let computed : Array[Int32] = []
  let mut set_state : ((Int32) -> Unit)? = None
  let result = rows.assoc_by(
    (_, row) => {
      row
      .map2(extra, (row, extra) => {
        let value = row.1 + extra
        computed.push(value)
        value
      })
      .switch_by(
        _ => {
          let (state, write) = @duplix.input(1)
          set_state = Some(write)
          state
        },
        by=value => if value % 2 == 0 { "even" } else { "odd" },
      )
    },
    by=row => row.0,
  )
  @test.assert_eq(result.read().to_array(), [1])
  guard set_state is Some(write) else { fail("expected initialized state") }
  write(7)
  set_rows(@vector.from_array([(1, 11)]))
  set_extra(2)
  @test.assert_eq(result.read().to_array(), [7])
  @test.assert_eq(computed, [11, 13])
}

///|
test "assoc disposes removed rows before evaluating active branches" {
  let (rows, set_rows) = @duplix.input(@vector.from_array([(1, 10), (2, 100)]))
  let (extra, set_extra) = @duplix.input(1)
  let computed : Array[Int32] = []
  let disposed : Array[Int32] = []
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
  let computed : Array[Int32] = []
  let mut shared : @duplix.Node[Int32]? = None
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
  let joined = result.map2(branch, (values, value) => (values.to_array(), value))
  @test.assert_eq(joined.read(), ([11], 11))
  set_rows(@vector.from_array([(1, 20)]))
  set_extra(2)
  @test.assert_eq(branch.read(), 22)
  @test.assert_eq(joined.read(), ([22], 22))
  @test.assert_eq(computed, [11, 22])
}

///|
test "nested assoc evaluates each leaf once with current inputs" {
  let (rows, set_rows) = @duplix.input(
    @vector.from_array([(1, @vector.from_array([(2, 10)]))]),
  )
  let (extra, set_extra) = @duplix.input(1)
  let computed : Array[Int32] = []
  let result = rows.assoc((_, nested) => {
    nested.assoc((_, row) => {
      row.map2(extra, (row, extra) => {
        let value = row + extra
        computed.push(value)
        value
      })
    })
  })
  @test.assert_eq(result.read().to_array().map(values => values.to_array()), [
    [11],
  ])
  set_rows(@vector.from_array([(1, @vector.from_array([(2, 20)]))]))
  set_extra(2)
  @test.assert_eq(result.read().to_array().map(values => values.to_array()), [
    [22],
  ])
  @test.assert_eq(computed, [11, 22])
}

///|
test "assoc resolves a nested switch before evaluating its previous branch" {
  let (rows, set_rows) = @duplix.input(@vector.from_array([(1, 10)]))
  let (extra, set_extra) = @duplix.input(1)
  let computed : Array[String] = []
  let disposed : Array[String] = []
  let result = rows.assoc((_, row) => {
    row.switch_by(
      value => {
        let tag = if value < 20 { "home" } else { "detail" }
        @duplix.on_cleanup(() => disposed.push(tag))
        extra.map(extra => {
          computed.push(tag)
          extra
        })
      },
      by=value => if value < 20 { "home" } else { "detail" },
    )
  })
  @test.assert_eq(result.read().to_array(), [1])
  set_rows(@vector.from_array([(1, 20)]))
  set_extra(2)
  @test.assert_eq(result.read().to_array(), [2])
  @test.assert_eq(computed, ["home", "detail"])
  @test.assert_eq(disposed, ["home"])
}

///|
test "shared row reads do not replace a branch lifetime before reconciliation" {
  let (rows, set_rows) = @duplix.input(@vector.from_array([(1, 10)]))
  let captured : Array[@duplix.Node[Int32]] = []
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
