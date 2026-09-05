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
      Some({ unload: _ => on_unload(), update_tagger: _ => (), })
    }),
  )
}

///|
#cfg(target="js")
struct StoreTestHost {
  task_queue : Queue[(@cmd.Op, @cmd.Extension)]
  stores : @slotmap.SlotMap[Store]
  mut draining : Bool
  mut async_tasks : Int
  mut unhandled_tasks : Int
}

///|
#cfg(target="js")
fn StoreTestHost::new() -> StoreTestHost {
  {
    task_queue: Queue([]),
    stores: SlotMap(),
    draining: false,
    async_tasks: 0,
    unhandled_tasks: 0,
  }
}

///|
#cfg(target="js")
fn StoreTestHost::drain(self : Self) -> Unit {
  guard !self.draining else { return }
  self.draining = true
  while self.task_queue.pop() is Some((op, extension)) {
    if handle_message(self, extension) {
      continue
    }
    try @cmd.invoke(@key.key, op, extension, self) catch {
      Unhandled => self.unhandled_tasks += 1
    } noraise {
      None => ()
      Ready(cmd) => @cmd.Scheduler::queue_command(self, cmd)
      Async(_) => self.async_tasks += 1
      AfterLayout(f) => @cmd.Scheduler::queue_command(self, f())
      LegacyEffect(_, f) => f(self)
    }
  }
  self.draining = false
}

///|
#cfg(target="js")
impl @cmd.Context for StoreTestHost with fn get_origin(_self) {
  "http://localhost"
}

///|
#cfg(target="js")
impl @cmd.Context for StoreTestHost with fn inject_url_changed(_self, _url) {
  @cmd.none
}

///|
#cfg(target="js")
impl @cmd.Context for StoreTestHost with fn inject_url_request(_self, _url) {
  @cmd.none
}

///|
#cfg(target="js")
impl @cmd.Scheduler for StoreTestHost with fn queue_command(self, cmd) {
  for task in @cmd.flatten(@key.key, cmd) {
    self.task_queue.push(task)
  }
  self.drain()
}

///|
#cfg(target="js")
impl @cmd.Scheduler for StoreTestHost with fn set_url_changed_injector(
  _self,
  _injector,
) {
  ignore((_self, _injector))
}

///|
#cfg(target="js")
impl @cmd.Scheduler for StoreTestHost with fn set_url_request_injector(
  _self,
  _injector,
) {
  ignore((_self, _injector))
}

///|
#cfg(target="js")
impl Host for StoreTestHost with fn flush(_self) {
  ignore(_self)
}

///|
#cfg(target="js")
impl Host for StoreTestHost with fn cleanup(_self) {
  ignore(_self)
}

///|
#cfg(target="js")
impl Host for StoreTestHost with fn get_stores(self) {
  self.stores
}

///|
#cfg(target="js")
fn with_store_test_host(run : (StoreTestHost) -> Unit raise) -> Unit raise {
  let host = StoreTestHost::new()
  ambient_host.protect(host, () => run(host))
  if host.async_tasks != 0 {
    fail("store test unexpectedly scheduled an async task")
  }
  if host.unhandled_tasks != 0 {
    fail("store test encountered an unhandled command")
  }
}

///|
#cfg(target="js")
test "state machine unloads subscriptions when its component scope is disposed" {
  with_store_test_host(_ => {
    let mut unloads = 0
    let subscription = cleanup_test_sub(() => unloads += 1)
    let (branch, set_branch) = @duplix.input(CleanupBranch::Active)
    let state = branch.switch(branch => {
      match branch {
        Active => {
          let (model, _) : (@duplix.Node[Int], @cmd.Emit[Unit]) = create_state_machine(
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
  })
}

///|
#cfg(target="js")
test "state machine with input unloads subscriptions when disposed" {
  with_store_test_host(_ => {
    let mut unloads = 0
    let subscription = cleanup_test_sub(() => unloads += 1)
    let (input, _) = @duplix.input("input")
    let (branch, set_branch) = @duplix.input(CleanupBranch::Active)
    let state = branch.switch(branch => {
      match branch {
        Active => {
          let (model, _) : (@duplix.Node[Int], @cmd.Emit[Unit]) = create_state_machine_with_input(
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
  })
}
