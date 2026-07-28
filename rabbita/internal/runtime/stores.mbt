///|
#cfg(target="js")
using @cmd {type Cmd, type Emit}

///|
#cfg(target="js")
using @sub {type Sub}

///|
#cfg(target="js")
let global_stores : @slotmap.SlotMap[Store] = SlotMap()

///|
#cfg(target="js")
pub(all) struct Store {
  id : @slotmap.Id
  /// (Msg) -> Cmd
  on_update : (&Scheduler, @any.Any) -> Unit
}

///|
#cfg(target="js")
fn diff_subs(
  old_subs : Map[String, @sub.RunningSub],
  new_subs : Map[String, (Error, @sub.SubLoader)],
  scheduler : &@cmd.Scheduler,
) -> Map[String, @sub.RunningSub] {
  let sub_map : Map[String, @sub.RunningSub] = Map([])
  for key, sub in old_subs {
    if !new_subs.contains(key) {
      (sub.unload)(scheduler)
    } else {
      sub_map[key] = sub
    }
  }
  for key, sub in new_subs {
    let (payload, loader) = sub
    if !old_subs.contains(key) && loader(payload, scheduler) is Some(running) {
      sub_map[key] = running
    }
  }
  sub_map
}

///|
#cfg(target="js")
fn cleanup_store(
  id : @slotmap.Id,
  sub_map : Map[String, @sub.RunningSub],
  scheduler : &@cmd.Scheduler,
) -> Unit {
  global_stores.free(id)
  for _, sub in sub_map {
    (sub.unload)(scheduler)
  }
}

///|
#cfg(target="js")
pub fn[Model : Eq, Msg] Sandbox::create_state_machine(
  scheduler : Sandbox,
  initialize : (Emit[Msg]) -> (Model, Cmd),
  update : (Model, Msg, Emit[Msg]) -> (Model, Cmd),
  subscriptions? : (Model, Emit[Msg]) -> Sub,
) -> (@duplix.Node[Model], Emit[Msg]) {
  let id = global_stores.allocate()
  let emit = @cmd.make_emitter(id)
  let mut sub_map : Map[String, @sub.RunningSub] = Map([])

  fn handle_subs(scheduler : &Scheduler, model : Model) {
    if subscriptions is Some(subscriptions) {
      let new_subs = subscriptions(model, emit).to_map(
        @key.key,
        filter_global=false,
      )
      sub_map = diff_subs(sub_map, new_subs, scheduler)
    }
  }

  let (model, set_model) : (@duplix.Node[Model?], _) = @duplix.input(None)

  let (model_value, init_cmd) = initialize(emit)
  set_model(Some(model_value))

  fn on_update(scheduler : &Scheduler, msg : @any.Any) {
    let msg : Msg = msg.into()
    let old_model = model.read()
    let (new_model, cmd) = update(old_model.unwrap(), msg, emit)
    handle_subs(scheduler, new_model)
    set_model(Some(new_model))
    scheduler.add(cmd)
  }

  global_stores[id] = { id, on_update }
  @duplix.on_cleanup(() => cleanup_store(id, sub_map, scheduler))

  scheduler.add(init_cmd)
  handle_subs(scheduler, model.read().unwrap())
  (model.map(x => x.unwrap()), emit)
}

///|
#cfg(target="js")
pub fn[Model : Eq, Msg, Input : Eq] Sandbox::create_state_machine_with_input(
  scheduler : Sandbox,
  initialize : (Emit[Msg], Input) -> (Model, Cmd),
  update : (Model, Input, Msg, Emit[Msg]) -> (Model, Cmd),
  subscriptions? : (Model, Input, Emit[Msg]) -> Sub,
  input : @duplix.Node[Input],
) -> (@duplix.Node[Model], Emit[Msg]) {
  let id = global_stores.allocate()
  let emit = @cmd.make_emitter(id)
  let mut sub_map : Map[String, @sub.RunningSub] = Map([])

  fn handle_subs(scheduler : &Scheduler, model : Model) {
    if subscriptions is Some(subscriptions) {
      let input = input.read()
      let new_subs = subscriptions(model, input, emit).to_map(
        @key.key,
        filter_global=false,
      )
      sub_map = diff_subs(sub_map, new_subs, scheduler)
    }
  }

  let (model, set_model) : (@duplix.Node[Model?], _) = @duplix.input(None)

  let (model_value, init_cmd) = initialize(emit, input.read())
  set_model(Some(model_value))

  fn on_update(scheduler : &Scheduler, msg : @any.Any) {
    let msg : Msg = msg.into()
    let old_model = model.read()
    let input_val = input.read()
    let (new_model, cmd) = update(old_model.unwrap(), input_val, msg, emit)
    handle_subs(scheduler, new_model)
    set_model(Some(new_model))
    scheduler.add(cmd)
  }

  global_stores[id] = { id, on_update }
  @duplix.on_cleanup(() => cleanup_store(id, sub_map, scheduler))

  scheduler.add(init_cmd)
  handle_subs(scheduler, model.read().unwrap())
  (model.map(x => x.unwrap()), emit)
}
