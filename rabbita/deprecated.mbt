///|
#deprecated("Use a `() -> Val[Html]` component. Nested `Cell::view()` composition is no longer supported; use `Val::map`, `Val::switch`, or `Val::assoc` instead.", skip_current_package=true)
pub type Cell = () -> Val[Html]

///|
#cfg(target="js")
priv struct DeprecatedModel[Model](Model)

///|
#cfg(target="js")
impl[Model] Eq for DeprecatedModel[Model] with fn equal(_, _) {
  false
}

///|
#cfg(target="js")
fn[Model, Msg] make_deprecated_cell(
  model~ : Model,
  update~ : (Emit[Msg], Msg, Model) -> (Cmd, Model),
  view~ : (Emit[Msg], Model) -> Html,
  subscriptions? : (Emit[Msg], Model) -> @sub.Sub,
) -> (Emit[Msg], Cell) {
  let actual_emit : Ref[Emit[Msg]?] = Ref(None)
  let pending : @queue.Queue[Msg] = @queue.Queue([])
  let emit : Emit[Msg] = @cmd.make_legacy_emitter((scheduler, msg) => {
    match actual_emit.val {
      Some(actual_emit) => scheduler.add(actual_emit(msg))
      None => pending.push(msg)
    }
  })

  fn compat_update(
    _ : Emit[Msg],
    msg : Msg,
    model : DeprecatedModel[Model],
  ) -> (DeprecatedModel[Model], Cmd) {
    let (cmd, model) = update(emit, msg, model.0)
    (DeprecatedModel(model), cmd)
  }

  let builder : Cell = () => {
    let (model, new_emit) = match subscriptions {
      Some(subscriptions) =>
        create_state(DeprecatedModel(model), update=compat_update, subscriptions=(
          _,
          model,
        ) => subscriptions(emit, model.0))
      None => create_state(DeprecatedModel(model), update=compat_update)
    }
    actual_emit.val = Some(new_emit)
    let scheduler = ambient_graph.val.unwrap().sandbox
    while pending.pop() is Some(msg) {
      scheduler.add(new_emit(msg))
    }
    model.map(model => view(emit, model.0))
  }
  (emit, builder)
}

///|
#cfg(not(target="js"))
fn[Model, Msg] make_deprecated_cell(
  model~ : Model,
  update~ : (Emit[Msg], Msg, Model) -> (Cmd, Model),
  view~ : (Emit[Msg], Model) -> Html,
  subscriptions? : (Emit[Msg], Model) -> @sub.Sub,
) -> (Emit[Msg], Cell) {
  ignore(update)
  ignore(subscriptions)
  let emit : Emit[Msg] = @cmd.make_legacy_emitter((_, _) => ())
  (emit, () => Val::constant(view(emit, model)))
}

///|
/// Compatibility wrapper for the former effectful Cell constructor.
///
/// New code should call `create_state` inside a component and map the returned
/// model to `Html`. The new update callback returns `(Model, Cmd)` instead of
/// `(Cmd, Model)`.
#deprecated("Use `create_state` inside a `() -> Val[Html]` component; return `(Model, Cmd)` from `update`, then map the model to `Html`.", skip_current_package=true)
pub fn[Model, Msg] cell(
  model~ : Model,
  update~ : (Emit[Msg], Msg, Model) -> (Cmd, Model),
  view~ : (Emit[Msg], Model) -> Html,
  subscriptions? : (Emit[Msg], Model) -> @sub.Sub,
) -> Cell {
  make_deprecated_cell(model~, update~, view~, subscriptions?).1
}

///|
/// Compatibility wrapper for the former effectful Cell constructor that also
/// exposed its emitter.
#deprecated("Use `create_state` inside a component and pass its returned `Emit` explicitly where it is needed.", skip_current_package=true)
pub fn[Model, Msg] cell_with_emit(
  model~ : Model,
  update~ : (Emit[Msg], Msg, Model) -> (Cmd, Model),
  view~ : (Emit[Msg], Model) -> Html,
  subscriptions? : (Emit[Msg], Model) -> @sub.Sub,
) -> (Emit[Msg], Cell) {
  make_deprecated_cell(model~, update~, view~, subscriptions?)
}

///|
/// Compatibility wrapper for the former pure Cell constructor.
#deprecated("Use `create_pure_state` inside a `() -> Val[Html]` component, then map the model to `Html`.", skip_current_package=true)
pub fn[Model, Msg] simple_cell(
  model~ : Model,
  update~ : (Msg, Model) -> Model,
  view~ : (Emit[Msg], Model) -> Html,
) -> Cell {
  make_deprecated_cell(
    model~,
    update=(_, msg, model) => (none, update(msg, model)),
    view~,
  ).1
}

///|
/// Compatibility wrapper for the former pure Cell constructor that also
/// exposed its emitter.
#deprecated("Use `create_pure_state` inside a component and pass its returned `Emit` explicitly where it is needed.", skip_current_package=true)
pub fn[Model, Msg] simple_cell_with_emit(
  model~ : Model,
  update~ : (Msg, Model) -> Model,
  view~ : (Emit[Msg], Model) -> Html,
  subscriptions? : (Emit[Msg], Model) -> @sub.Sub,
) -> (Emit[Msg], Cell) {
  make_deprecated_cell(
    model~,
    update=(_, msg, model) => (none, update(msg, model)),
    view~,
    subscriptions?,
  )
}

///|
/// Compatibility wrapper for the former static Cell constructor.
#deprecated("Use a component returning `Val::constant(html)` instead.", skip_current_package=true)
pub fn static_cell(html : Html) -> Cell {
  () => Val::constant(html)
}

///|
test "deprecated static cell renders on the server" {
  let root : Cell = static_cell(@html.div("static"))
  inspect(render_to_string(root), content="<div>static</div>")
}

///|
#cfg(not(target="js"))
test "deprecated stateful cell renders its initial model on the server" {
  let root : Cell = cell(
    model=7,
    update=(_, _ : Unit, model) => (none, model + 1),
    view=(_, model) => @html.div("\{model}"),
  )
  inspect(render_to_string(root), content="<div>7</div>")
}
