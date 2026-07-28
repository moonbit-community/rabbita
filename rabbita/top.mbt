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
  { sandbox, init_cmd: None, builder }
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
  { sandbox, init_cmd: None, builder }
}

///|
/// Configure routing callbacks for this app.
///
/// - `url_changed` is triggered for browser history navigation and when
///   `push_url` / `replace_url` commands are used.
/// - `url_request` is triggered when captured links `@html.a()` are clicked.
///
/// If the app is already mounted, a `url_changed` command for the current URL
/// will be enqueued immediately.
#cfg(target="js")
#deprecated("use subscriptions and @sub.on_url_changed/@sub.on_url_request instead")
pub fn App::with_route(
  self : Self,
  url_changed? : Emit[@url.Url],
  url_request? : Emit[@url.UrlRequest],
) -> Unit {
  if url_changed is Some(msg) {
    for _, sub in @sub.on_url_changed(msg).to_map(@key.key, filter_global=false) {
      let (payload, loader) = sub
      let _ = loader(payload, self.sandbox)
    }
  }
  if url_request is Some(msg) {
    for _, sub in @sub.on_url_request(msg).to_map(@key.key, filter_global=false) {
      let (payload, loader) = sub
      let _ = loader(payload, self.sandbox)
    }
  }
}

///|
/// Registers a one-shot command to be queued when `mount` runs.
/// This API is still evolving and may change in future releases.
#cfg(target="js")
#internal(unstable, "Experimental API")
pub fn App::with_init(self : Self, cmd : Cmd) -> Unit {
  self.init_cmd = Some(cmd)
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
  if self.init_cmd is Some(cmd) {
    self.sandbox.add(cmd)
    self.init_cmd = None
  }

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
  mut init_cmd : Cmd?
}

///|
/// Render a component into an HTML string.
///
/// This is the server-side rendering entrypoint for Rabbita. It evaluates
/// the component once and serializes the resulting virtual DOM into static
/// HTML.
///
/// Hydration is currently not supported. If you later call `mount` on the
/// client, Rabbita will do a fresh client-side render instead of attaching to
/// the existing server-rendered DOM.
///
/// ## Example
///
/// ```mbt check
/// test "render html to string" {
///   inspect(
///     @rabbita.render_to_string(() => {
///       @rabbita.Val::constant(@html.ul(["todo1", "todo2"].map(x => @html.li(x))))
///     }),
///     content=(
///       #|<ul><li>todo1</li><li>todo2</li></ul>
///     ),
///   )
/// }
/// ```
#internal(unstable, "Experimental API")
pub fn render_to_string(builder : () -> Val[Html]) -> String {
  @runtime.server_side_render(() => builder().0.read().0)
}
