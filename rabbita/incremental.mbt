///|
pub using @common {trait Enumerate}

///|
using @vector {type Vector}

///|
#cfg(target="js")
let ambient_graph : Ref[Graph?] = Ref(None)

///|
/// A lazily evaluated value in Rabbita's incremental graph.
///
/// Derived values are recomputed on demand after one of their dependencies
/// changes.
struct Val[A](@duplix.Node[A])

///|
#cfg(target="js")
priv struct Graph {
  sandbox : @runtime.Sandbox
}

///|
#cfg(target="js")
fn Graph::Graph(sandbox : @runtime.Sandbox) -> Self {
  { sandbox, }
}

///|
/// Creates an incremental value by applying `f` to `a`.
///
/// The function is reevaluated when the value of `a` changes.
pub fn[A : Eq, B] Val::map(a : Val[A], f : (A) -> B) -> Val[B] {
  a.0.map1(f)
}

///|
/// Creates an incremental value that always contains `a`.
pub fn[A] Val::constant(a : A) -> Val[A] {
  @duplix.constant(a)
}

///|
/// Creates an incremental value derived from two inputs.
///
/// The function is reevaluated when either input value changes.
pub fn[A : Eq, B : Eq, C] Val::map2(
  a : Val[A],
  b : Val[B],
  f : (A, B) -> C,
) -> Val[C] {
  a.0.map2(b.0, f)
}

///|
/// Creates an incremental value derived from three inputs.
///
/// The function is reevaluated when any input value changes.
pub fn[A : Eq, B : Eq, C : Eq, D] Val::map3(
  a : Val[A],
  b : Val[B],
  c : Val[C],
  f : (A, B, C) -> D,
) -> Val[D] {
  a.0.map3(b.0, c.0, f)
}

///|
/// Creates an incremental value derived from four inputs.
///
/// The function is reevaluated when any input value changes.
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E] Val::map4(
  a : Val[A],
  b : Val[B],
  c : Val[C],
  d : Val[D],
  f : (A, B, C, D) -> E,
) -> Val[E] {
  a.0.map4(b.0, c.0, d.0, f)
}

///|
/// Creates an incremental value derived from five inputs.
///
/// The function is reevaluated when any input value changes.
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E : Eq, F] Val::map5(
  a : Val[A],
  b : Val[B],
  c : Val[C],
  d : Val[D],
  e : Val[E],
  f : (A, B, C, D, E) -> F,
) -> Val[F] {
  a.0.map5(b.0, c.0, d.0, e.0, f)
}

///|
/// Creates an incremental value derived from six inputs.
///
/// The function is reevaluated when any input value changes.
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E : Eq, F : Eq, G] Val::map6(
  a : Val[A],
  b : Val[B],
  c : Val[C],
  d : Val[D],
  e : Val[E],
  f : Val[F],
  g : (A, B, C, D, E, F) -> G,
) -> Val[G] {
  a.0.map6(b.0, c.0, d.0, e.0, f.0, g)
}

///|
/// Creates an incremental value derived from seven inputs.
///
/// The function is reevaluated when any input value changes.
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E : Eq, F : Eq, G : Eq, H] Val::map7(
  a : Val[A],
  b : Val[B],
  c : Val[C],
  d : Val[D],
  e : Val[E],
  f : Val[F],
  g : Val[G],
  h : (A, B, C, D, E, F, G) -> H,
) -> Val[H] {
  a.0.map7(b.0, c.0, d.0, e.0, f.0, g.0, h)
}

///|
/// Creates an incremental value derived from eight inputs.
///
/// The function is reevaluated when any input value changes.
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E : Eq, F : Eq, G : Eq, H : Eq, I] Val::map8(
  a : Val[A],
  b : Val[B],
  c : Val[C],
  d : Val[D],
  e : Val[E],
  f : Val[F],
  g : Val[G],
  h : Val[H],
  i : (A, B, C, D, E, F, G, H) -> I,
) -> Val[I] {
  a.0.map8(b.0, c.0, d.0, e.0, f.0, g.0, h.0, i)
}

///|
/// Creates an incremental value derived from nine inputs.
///
/// The function is reevaluated when any input value changes.
pub fn[
  A : Eq,
  B : Eq,
  C : Eq,
  D : Eq,
  E : Eq,
  F : Eq,
  G : Eq,
  H : Eq,
  I : Eq,
  J,
] Val::map9(
  a : Val[A],
  b : Val[B],
  c : Val[C],
  d : Val[D],
  e : Val[E],
  f : Val[F],
  g : Val[G],
  h : Val[H],
  i : Val[I],
  j : (A, B, C, D, E, F, G, H, I) -> J,
) -> Val[J] {
  a.0.map9(b.0, c.0, d.0, e.0, f.0, g.0, h.0, i.0, j)
}

///|
/// Creates an HTML view derived from one incremental value.
///
/// The render function is reevaluated when `a` changes.
pub fn[A : Eq] Val::view(a : Val[A], render : (A) -> Html) -> Val[Html] {
  a.0.map(render)
}

///|
/// Creates an HTML view derived from two incremental values.
///
/// The render function is reevaluated when either input changes.
pub fn[A : Eq, B : Eq] Val::view2(
  a : Val[A],
  b : Val[B],
  render : (A, B) -> Html,
) -> Val[Html] {
  a.0.map2(b.0, render)
}

///|
/// Creates an HTML view derived from three incremental values.
///
/// The render function is reevaluated when any input changes.
pub fn[A : Eq, B : Eq, C : Eq] Val::view3(
  a : Val[A],
  b : Val[B],
  c : Val[C],
  render : (A, B, C) -> Html,
) -> Val[Html] {
  a.0.map3(b.0, c.0, render)
}

///|
/// Creates an HTML view derived from four incremental values.
///
/// The render function is reevaluated when any input changes.
pub fn[A : Eq, B : Eq, C : Eq, D : Eq] Val::view4(
  a : Val[A],
  b : Val[B],
  c : Val[C],
  d : Val[D],
  render : (A, B, C, D) -> Html,
) -> Val[Html] {
  a.0.map4(b.0, c.0, d.0, render)
}

///|
/// Creates an HTML view derived from five incremental values.
///
/// The render function is reevaluated when any input changes.
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E : Eq] Val::view5(
  a : Val[A],
  b : Val[B],
  c : Val[C],
  d : Val[D],
  e : Val[E],
  render : (A, B, C, D, E) -> Html,
) -> Val[Html] {
  a.0.map5(b.0, c.0, d.0, e.0, render)
}

///|
/// Creates an HTML view derived from six incremental values.
///
/// The render function is reevaluated when any input changes.
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E : Eq, F : Eq] Val::view6(
  a : Val[A],
  b : Val[B],
  c : Val[C],
  d : Val[D],
  e : Val[E],
  f : Val[F],
  render : (A, B, C, D, E, F) -> Html,
) -> Val[Html] {
  a.0.map6(b.0, c.0, d.0, e.0, f.0, render)
}

///|
/// Creates an HTML view derived from seven incremental values.
///
/// The render function is reevaluated when any input changes.
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E : Eq, F : Eq, G : Eq] Val::view7(
  a : Val[A],
  b : Val[B],
  c : Val[C],
  d : Val[D],
  e : Val[E],
  f : Val[F],
  g : Val[G],
  render : (A, B, C, D, E, F, G) -> Html,
) -> Val[Html] {
  a.0.map7(b.0, c.0, d.0, e.0, f.0, g.0, render)
}

///|
/// Creates an HTML view derived from eight incremental values.
///
/// The render function is reevaluated when any input changes.
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E : Eq, F : Eq, G : Eq, H : Eq] Val::view8(
  a : Val[A],
  b : Val[B],
  c : Val[C],
  d : Val[D],
  e : Val[E],
  f : Val[F],
  g : Val[G],
  h : Val[H],
  render : (A, B, C, D, E, F, G, H) -> Html,
) -> Val[Html] {
  a.0.map8(b.0, c.0, d.0, e.0, f.0, g.0, h.0, render)
}

///|
/// Creates an HTML view derived from nine incremental values.
///
/// The render function is reevaluated when any input changes.
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E : Eq, F : Eq, G : Eq, H : Eq, I : Eq] Val::view9(
  a : Val[A],
  b : Val[B],
  c : Val[C],
  d : Val[D],
  e : Val[E],
  f : Val[F],
  g : Val[G],
  h : Val[H],
  i : Val[I],
  render : (A, B, C, D, E, F, G, H, I) -> Html,
) -> Val[Html] {
  a.0.map9(b.0, c.0, d.0, e.0, f.0, g.0, h.0, i.0, render)
}

///|
/// Creates component-local state with a pure update function.
///
/// Call this while building a component. The returned emitter creates commands
/// that apply messages with `update`, and the returned value tracks the current
/// model.
///
/// # Example
///
/// ```mbt nocheck
/// priv enum Msg {
///   Inc
///   Dec
/// }
///
/// fn counter() -> Val[Html] {
///   let (count, emit) = @rabbita.create_pure_state(0, update=fn(count, msg) {
///     match msg {
///       Inc => count + 1
///       Dec => count - 1
///     }
///   })
///   count.view(count => {
///     @html.div([
///       @html.button(on_click=emit(Dec), "-"),
///       @html.span(count.to_string()),
///       @html.button(on_click=emit(Inc), "+"),
///     ])
///   })
/// }
/// ```
#cfg(target="js")
pub fn[Model : Eq, Msg] create_pure_state(
  model : Model,
  update~ : (Model, Msg) -> Model,
) -> (Val[Model], Emit[Msg]) {
  let graph = ambient_graph.val.unwrap()
  let (node, emit) = graph.sandbox.create_state_machine(_ => (model, none), (
    model,
    msg,
    _,
  ) => (update(model, msg), none))
  (node, emit)
}

///|
/// Creates component-local state whose updates may schedule commands.
///
/// Call this while building a component. The returned emitter creates commands
/// that deliver messages to `update`; subscriptions are refreshed after each
/// processed message.
///
/// # Example
///
/// ```mbt nocheck
/// priv enum CounterMsg {
///   Increment
///   IncrementLater
/// }
///
/// fn counter() -> Val[Html] {
///   let (count, emit) = @rabbita.create_state(0, update=fn(count, msg, emit) {
///     match msg {
///       Increment => (count + 1, @rabbita.none)
///       IncrementLater => (count, @rabbita.delay(emit(Increment), 1000))
///     }
///   })
///   count.view(count => {
///     @html.button(on_click=emit(IncrementLater), count.to_string())
///   })
/// }
/// ```
#cfg(target="js")
pub fn[Model : Eq, Msg] create_state(
  model : Model,
  update~ : (Model, Msg, Emit[Msg]) -> (Model, Cmd),
  subscriptions? : (Model, Emit[Msg]) -> @sub.Sub,
) -> (Val[Model], Emit[Msg]) {
  let graph = ambient_graph.val.unwrap()
  let (node, emit) = graph.sandbox.create_state_machine(
    _ => (model, none),
    update,
    subscriptions?,
  )
  (Val(node), emit)
}

///|
/// Incrementally maps ordered keyed values into a vector.
///
/// Pass a named component to `assoc`; do not render inline. Keys must be unique;
/// each key owns one branch whose `Val` tracks updates, and removing it disposes
/// the branch. Output follows vector order, but keys are not attached to `Html`.
///
/// # Example
///
/// ```mbt nocheck
/// fn todo_item(id : Int, title : Val[String]) -> Val[Html] {
///   title.view(title => @html.li("\{id}: \{title}"))
/// }
///
/// fn todo_list(todos : Val[Vector[(Int, String)]]) -> Val[Html] {
///   let rows = todos.assoc(todo_item)
///   rows.view(rows => @html.ul(rows))
/// }
/// ```
pub fn[K : Hash + Eq, V : Eq, C : Eq] Val::assoc(
  a : Val[Vector[(K, V)]],
  f : (K, Val[V]) -> Val[C],
) -> Val[Vector[C]] {
  a.0.assoc((k, v) => f(k, v).0)
}

///|
/// Incrementally maps values using keys derived by `by`.
///
/// Derived keys must be unique and stable. Output follows source vector order.
pub fn[K : Hash + Eq, V : Eq, C : Eq] Val::assoc_by(
  a : Val[Vector[V]],
  f : (K, Val[V]) -> Val[C],
  by~ : (V) -> K,
) -> Val[Vector[C]] {
  a.0.assoc_by((k, v) => f(k, v).0, by~)
}

///|
/// Selects and caches an incremental branch for each enumeration tag.
///
/// Immediately match the tag in the `enumerate` callback and dispatch each case
/// to its own component; do not render inline. Branches are cached with their
/// state and subscriptions. Use `Val::switch` for disposable branches.
///
/// # Example
///
/// ```mbt nocheck
/// priv enum Tab {
///   First
///   Second
/// } derive(Eq)
///
/// impl @rabbita.Enumerate for Tab with fn tag(self) {
///   match self {
///     First => "first"
///     Second => "second"
///   }
/// }
///
/// fn first_tab() -> Val[Html] {
///   Val::constant(@html.h1("First"))
/// }
///
/// fn second_tab() -> Val[Html] {
///   Val::constant(@html.h1("Second"))
/// }
///
/// fn tab_content(tab : Val[Tab]) -> Val[Html] {
///   tab.enumerate(tab => {
///     match tab {
///       First => first_tab()
///       Second => second_tab()
///     }
///   })
/// }
/// ```
pub fn[E : Enumerate + Eq, C : Eq] Val::enumerate(
  a : Val[E],
  f : (E) -> Val[C],
) -> Val[C] {
  a.0.enumerate(e => f(e).0)
}

///|
/// Selects and caches branches using the tag returned by `by`.
///
/// Values with the same tag reuse the branch created for its first value.
pub fn[E : Eq, C : Eq] Val::enumerate_by(
  a : Val[E],
  f : (E) -> Val[C],
  by~ : (E) -> String,
) -> Val[C] {
  a.0.enumerate_by(e => f(e).0, by~)
}

///|
/// Selects one incremental branch using the input's enumeration tag.
///
/// Immediately match the tag in the `switch` callback and dispatch each case to
/// its own component; do not render inline. Changing the tag disposes the active
/// component, so returning to an old tag creates a fresh one.
///
/// # Example
///
/// ```mbt nocheck
/// priv enum Page {
///   Home
///   Settings
/// } derive(Eq)
///
/// impl @rabbita.Enumerate for Page with fn tag(self) {
///   match self {
///     Home => "home"
///     Settings => "settings"
///   }
/// }
///
/// fn home_page() -> Val[Html] {
///   Val::constant(@html.h1("Home"))
/// }
///
/// fn settings_page() -> Val[Html] {
///   Val::constant(@html.h1("Settings"))
/// }
///
/// fn page_content(page : Val[Page]) -> Val[Html] {
///   page.switch(page => {
///     match page {
///       Home => home_page()
///       Settings => settings_page()
///     }
///   })
/// }
/// ```
pub fn[E : Enumerate + Eq, C : Eq] Val::switch(
  a : Val[E],
  f : (E) -> Val[C],
) -> Val[C] {
  a.0.switch(e => f(e).0)
}

///|
/// Selects a disposable branch using the tag returned by `by`.
///
/// Values with the same tag keep the current branch; changing it disposes the
/// branch before creating the next one.
pub fn[E : Eq, C : Eq] Val::switch_by(
  a : Val[E],
  f : (E) -> Val[C],
  by~ : (E) -> String,
) -> Val[C] {
  a.0.switch_by(e => f(e).0, by~)
}

///|
/// Creates component-local state with an emitter-aware initializer.
///
/// `init` supplies the initial model and a command to schedule. Later messages
/// are handled by `update`, as with `create_state`. Call this while building a
/// component.
///
/// # Example
///
/// ```mbt nocheck
/// priv enum Msg {
///   Inc
///   Dec
/// }
///
/// fn delayed_counter() -> Val[Html] {
///   let (count, emit) = @rabbita.create_state_with_init(
///     init=fn(emit) { (0, @rabbita.delay(emit(Inc), 1000)) },
///     update=fn(count, msg, _) {
///       match msg {
///         Inc => (count + 1, @rabbita.none)
///         Dec => (count - 1, @rabbita.none)
///       }
///     },
///   )
///   count.view(count => {
///     @html.div([
///       @html.button(on_click=emit(Dec), "-"),
///       @html.span(count.to_string()),
///       @html.button(on_click=emit(Inc), "+"),
///     ])
///   })
/// }
/// ```
#cfg(target="js")
pub fn[Model : Eq, Msg] create_state_with_init(
  init~ : (Emit[Msg]) -> (Model, Cmd),
  update~ : (Model, Msg, Emit[Msg]) -> (Model, Cmd),
  subscriptions? : (Model, Emit[Msg]) -> @sub.Sub,
) -> (Val[Model], Emit[Msg]) {
  let graph = ambient_graph.val.unwrap()
  let (node, emit) = graph.sandbox.create_state_machine(
    init,
    update,
    subscriptions?,
  )
  (node, emit)
}

///|
/// Creates component-local state whose callbacks receive an incremental input.
///
/// The current input is passed to `init`, `update`, and `subscriptions` when
/// those callbacks run. Changing the input alone does not send a message, run
/// `update`, or refresh subscriptions. Call this while building a component.
///
/// # Example
///
/// Each click increments or decrements by the current value of `step`.
///
/// ```mbt nocheck
/// priv enum Msg {
///   Inc
///   Dec
/// }
///
/// fn stepped_counter(step : Val[Int]) -> Val[Html] {
///   let (count, emit) = @rabbita.create_state_with_input(
///     input=step,
///     init=fn(_, _) { (0, @rabbita.none) },
///     update=fn(count, step, msg, _) {
///       match msg {
///         Inc => (count + step, @rabbita.none)
///         Dec => (count - step, @rabbita.none)
///       }
///     },
///   )
///   count.view(count => {
///     @html.div([
///       @html.button(on_click=emit(Dec), "-"),
///       @html.span(count.to_string()),
///       @html.button(on_click=emit(Inc), "+"),
///     ])
///   })
/// }
/// ```
#cfg(target="js")
pub fn[Model : Eq, Msg, Input : Eq] create_state_with_input(
  init~ : (Emit[Msg], Input) -> (Model, Cmd),
  update~ : (Model, Input, Msg, Emit[Msg]) -> (Model, Cmd),
  subscriptions? : (Model, Input, Emit[Msg]) -> @sub.Sub,
  input~ : Val[Input],
) -> (Val[Model], Emit[Msg]) {
  let graph = ambient_graph.val.unwrap()
  let (node, emit) = graph.sandbox.create_state_machine_with_input(
    init,
    update,
    subscriptions?,
    input.0,
  )
  (node, emit)
}

///|
/// Creates component-local state updated by transformation functions.
///
/// The returned emitter turns a model transformation into a `Cmd`. When that
/// command is scheduled, the transformation is applied to the current model
/// and its result becomes the new model. Call this while building a component.
///
/// # Example
///
/// ```mbt nocheck
/// fn toggle() -> Val[Html] {
///   let (open, set_open) = @rabbita.create_variable(false)
///   open.view(is_open => {
///     @html.button(
///       on_click=set_open(v => !v),
///       if is_open {
///         "Close"
///       } else {
///         "Open"
///       },
///     )
///   })
/// }
/// ```
#cfg(target="js")
pub fn[Model : Eq] create_variable(
  init : Model,
) -> (Val[Model], Emit[(Model) -> Model]) {
  fn update(model, f) {
    f(model)
  }
  create_pure_state(init, update~)
}

///|
/// The lifecycle state of an asynchronous resource.
///
/// For incremental equality, `Pending` equals `Pending`, loaded values compare
/// by their payloads, and all `Failed` values compare equal regardless of the
/// contained error.
#cfg(target="js")
pub enum Status[T] {
  Pending
  Loaded(T)
  Failed(Error)
}

///|
#cfg(target="js")
pub impl[T : Eq] Eq for Status[T] with fn equal(a, b) {
  match (a, b) {
    (Pending, Pending) | (Failed(_), Failed(_)) => true
    (Loaded(a), Loaded(b)) => a == b
    _ => false
  }
}

///|
/// An incremental asynchronous resource state.
#cfg(target="js")
pub type Resource[T] = Val[Status[T]]

///|
/// Starts an asynchronous resource command and tracks its result.
///
/// The resource starts as `Pending`, then becomes `Loaded` or `Failed` when the
/// emitter passed to `f` receives a result. Call this while building a
/// component.
///
/// # Example
///
/// ```mbt nocheck
/// fn chapter() -> Val[Html] {
///   // Import "moonbit-community/rabbita/http" as @http in moon.pkg.
///   let chapter = @rabbita.create_resource(inject => {
///     @http.get("/chapter.md").expect_text(inject)
///   })
///   chapter.view(status => {
///     match status {
///       Pending => @html.p("Loading...")
///       Loaded(text) => @html.pre(text)
///       Failed(_) => @html.p("Failed to load chapter")
///     }
///   })
/// }
/// ```
#cfg(target="js")
pub fn[T : Eq] create_resource(
  f : (Emit[Result[T, Error]]) -> Cmd,
) -> Resource[T] {
  let (status, _) : (Resource[T], _) = create_state_with_init(
    init=fn(inject) { (Pending, f(inject)) },
    update=fn(_, msg, _) {
      match msg {
        Ok(r) => (Loaded(r), none)
        Err(e) => (Failed(e), none)
      }
    },
  )
  status
}
