///|
#cfg(target="js")
pub using @cmd {perform, attempt, effect, delay}

///|
pub using @cmd {none, batch}

///|
pub type Cmd = @cmd.Cmd

///|
pub type Html = @html.Html

///|
/// Creates an application from a root component builder.
///
/// The builder runs when the app is mounted and must return its root
/// incremental HTML value. Use `Val::map`, `Val::switch`, and `Val::assoc` to
/// express subsequent changes, then call `App::mount` to attach the app to a
/// DOM element.
#cfg(target="js")
pub fn new(builder : () -> Val[Html]) -> App {
  let sandbox = @runtime.Sandbox::new()
  ambient_graph.val = Some(Graph(sandbox))
  { sandbox, builder }
}

///|
/// Creates an application using an Elm-style model, update, and view.
///
/// This is a convenience wrapper around `create_state` and `new`. Each emitted
/// message updates the model, schedules the returned command, and refreshes the
/// optional subscriptions.
#cfg(target="js")
pub fn[Model : Eq, Msg] elmish(
  model~ : Model,
  view~ : (Model, Emit[Msg]) -> Html,
  update~ : (Model, Msg, Emit[Msg]) -> (Model, Cmd),
  subscriptions? : (Model, Emit[Msg]) -> @sub.Sub,
) -> App {
  fn builder() {
    let (model, emit) = create_state(model, update~, subscriptions?)
    model.map(model => view(model, emit))
  }
  let sandbox = @runtime.Sandbox::new()
  ambient_graph.val = Some(Graph(sandbox))
  { sandbox, builder }
}

///|
/// Mount the app into the DOM element identified by `element_id`.
///
/// This initializes the runtime and schedules the first render flush.
/// If routing is configured, the current URL is also emitted on mount.
#cfg(target="js")
pub fn App::mount(self : Self, element_id : String) -> Unit {
  self.sandbox.mount = element_id
  @dom.document()
  .get_element_by_id(element_id)
  .unwrap()
  .set_inner_html("<div></div>")

  let vnode = (self.builder)()

  self.sandbox.initialize(vnode.0.map(html => html.0))
  self.sandbox.flush()
}

///|
/// A running Rabbita application.
#cfg(target="js")
struct App {
  sandbox : @runtime.Sandbox
  builder : () -> Val[Html]
}
