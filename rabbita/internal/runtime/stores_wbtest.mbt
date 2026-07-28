///|
#cfg(target="js")
enum CleanupBranch {
  Active
  Inactive
} derive(Eq)

///|
#cfg(target="js")
impl @common.Enumerate for CleanupBranch with fn tag(self) {
  match self {
    Active => "active"
    Inactive => "inactive"
  }
}

///|
#cfg(target="js")
suberror CleanupPayload {
  CleanupPayload(String)
}

///|
#cfg(target="js")
fn cleanup_test_sub(on_unload : () -> Unit) -> @sub.Sub {
  @sub.custom_sub(
    "cleanup-test",
    Local,
    CleanupPayload("cleanup-test"),
    SubLoader((_, _) => {
      Some({ unload: _ => on_unload(), update_tagger: _ => () })
    }),
  )
}

///|
#cfg(target="js")
fn cleanup_test_sandbox() -> Sandbox {
  let sandbox = Sandbox::new()
  // State initialization drains an empty command and would otherwise schedule
  // a browser paint. These tests only exercise store lifecycle behavior.
  sandbox.paint_scheduled = true
  sandbox
}

///|
#cfg(target="js")
test "state machine unloads subscriptions when its component scope is disposed" {
  let sandbox = cleanup_test_sandbox()
  let mut unloads = 0
  let subscription = cleanup_test_sub(() => unloads += 1)
  let (branch, set_branch) = @duplix.input(CleanupBranch::Active)
  let state = branch.switch(branch => {
    match branch {
      Active => {
        let (model, _) : (@duplix.Node[Int], @cmd.Emit[Unit]) = sandbox.create_state_machine(
          _ => (0, @cmd.none),
          (model, _, _) => (model, @cmd.none),
          subscriptions=(_, _) => subscription,
        )
        model
      }
      Inactive => @duplix.constant(0)
    }
  })

  inspect(state.read(), content="0")
  inspect(unloads, content="0")
  set_branch(Inactive)
  inspect(state.read(), content="0")
  inspect(unloads, content="1")
}

///|
#cfg(target="js")
test "state machine with input unloads subscriptions when disposed" {
  let sandbox = cleanup_test_sandbox()
  let mut unloads = 0
  let subscription = cleanup_test_sub(() => unloads += 1)
  let (input, _) = @duplix.input("input")
  let (branch, set_branch) = @duplix.input(CleanupBranch::Active)
  let state = branch.switch(branch => {
    match branch {
      Active => {
        let (model, _) : (@duplix.Node[Int], @cmd.Emit[Unit]) = sandbox.create_state_machine_with_input(
          (_, _) => (0, @cmd.none),
          (model, _, _, _) => (model, @cmd.none),
          subscriptions=(_, _, _) => subscription,
          input,
        )
        model
      }
      Inactive => @duplix.constant(0)
    }
  })

  inspect(state.read(), content="0")
  inspect(unloads, content="0")
  set_branch(Inactive)
  inspect(state.read(), content="0")
  inspect(unloads, content="1")
}
