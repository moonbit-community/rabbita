# Components and the Incremental Graph

A Rabbita component is an ordinary MoonBit function that describes a reusable
part of the UI. A pure view component takes ordinary values and returns `Html`.
A graph-building component creates state or derives `Val` values and returns a
`Val[Html]`.

There is no separate `Component` type. “Component” describes how code is
organized, not a distinct runtime value.

## Understand `Val` and the incremental graph

A `Val[T]` represents a `T` in the incremental graph. `map` derives another
`Val` from its evaluated value, while `view` derives a `Val[Html]`. The `map2`
through `map9` and `view2` through `view9` methods do the same for several
direct inputs without creating intermediate tuples.

`Val::constant(value)` creates a `Val` that always evaluates to `value`. Use it
when an API expects a `Val[T]`, but that value does not need to change as the
graph updates.

This component owns a counter state machine. `create_pure_state` returns the
state as `count : Val[Int]` and an emitter for `CounterMsg` commands.

```moonbit check
///|
enum CounterMsg {
  Increment
  Decrement
}

///|
fn counter(title : String) -> Val[Html] {
  let (count, emit) = @rabbita.create_pure_state(0, update=fn(count, msg) {
    match msg {
      Increment => count + 1
      Decrement => count - 1
    }
  })
  count.view(count => {
    section([
      h2(title),
      button(on_click=emit(Decrement), "-"),
      span(count.to_string()),
      button(on_click=emit(Increment), "+"),
    ])
  })
}
```

A parent component can build two independent counters and combine their
`Val[Html]` results:

```moonbit check
///|
fn app() -> Val[Html] {
  let left = counter("Left")
  let right = counter("Right")
  left.view2(right, (left, right) => main_([left, right]))
}
```

Mount the graph-building component as the application root:

```moonbit nocheck
///|
fn main {
  @rabbita.new(app).mount("main")
}
```

At mount, `app` calls `counter` twice and constructs this graph:

```text
left count  -> left view  --+
                            +-> app view2 -> root Val[Html]
right count -> right view --+
```

Rabbita evaluates changes on demand. A state update marks dependent nodes as
dirty, then the root `Val[Html]` is evaluated on the rendering frame. A derived
callback runs when its result is first needed and again when an input changes.
Its new result is compared with the previous result using `Eq`.

Clicking the left counter reevaluates the left `view` callback and the final
`view2` callback. The right `view` callback and the bodies of `app` and `counter`
do not run again for that update.

If a state update produces an equal model, dependent callbacks do not run. A
derived callback must run before Rabbita can compare its new result, but an
equal result stops propagation beyond that node.

Deriving smaller values lets equality stop work closer to the changed field:

```moonbit check
///|
struct Dashboard {
  count : Int
  status : String
} derive(Eq)

///|
fn dashboard(model : Val[Dashboard]) -> Val[Html] {
  let count = model
    .map(model => model.count)
    .view(count => p("Count: \{count}"))

  let status = model
    .map(model => model.status)
    .view(status => p("Status: \{status}"))

  count.view2(status, (count, status) => div([count, status]))
}
```

If only `status` changes, the `count` projection is checked and still produces
the same `Int`. The `view` callback that renders the count is therefore skipped.
A single large `model.view(...)` would instead rerun one callback and construct
all of the dashboard `Html` for every model change.

When a render unit needs more than nine independent inputs, split it into
smaller components or intermediate derived values.

`Eq` must describe every change that downstream code can observe. Prefer
immutable state and create a new value for each update. In particular, prefer
an immutable `Vector` for ordered collections. Mutating the same `Array` or
`Map` instance in place can leave no reliable old value for equality to
compare.

## Parent and child communication

Keep shared state in the closest common parent and local state in the child. For
a graph-building child, pass construction-time configuration as plain values
and changing inputs as `Val[T]`. Pure view components receive ordinary values
when the surrounding render callback calls them.

A child sends information to its parent through labeled parameters. Use `Cmd`
for an action without a value and `Emit[T]` for an action carrying a value:

```moonbit check
///|
fn child(
  text : Val[String],
  on_reset~ : Cmd,
  on_change~ : Emit[String],
) -> Val[Html] {
  let (visible, set_visible) = @rabbita.create_variable(true)
  text.view2(visible, (text, visible) => {
    div([
      if visible {
        p(text)
      } else {
        nothing
      },
      button(
        on_click=set_visible(value => !value),
        if visible {
          "Hide"
        } else {
          "Show"
        },
      ),
      button(on_click=on_change("Changed by child"), "submit"),
      button(on_click=on_reset, "reset"),
    ])
  })
}

///|
enum ParentMsg {
  ResetText
  SetText(String)
}

///|
fn parent() -> Val[Html] {
  let (text, emit) = @rabbita.create_pure_state("Initial value", update=fn(
    _,
    msg,
  ) {
    match msg {
      ResetText => "Initial value"
      SetText(text) => text
    }
  })
  child(
    text,
    on_reset=emit(ResetText),
    on_change=emit.map(text => SetText(text)),
  )
}
```

Here `text` belongs to `parent`, `visible` belongs to `child`, and actions flow
back through `on_reset` and `on_change`.

If a child owns local state but its update or subscriptions need the latest
input from its parent, use `create_state_with_input`. Changing that input alone
does not send a message, run the update callback, or refresh subscriptions.

## Dynamic subgraphs

An ordinary component call does not create an independently owned lifecycle.
Use the following combinators when a child branch must be preserved or disposed
independently of the surrounding render callback.

### Keyed collections

Use `assoc` or `assoc_by` when an ordered collection contains stateful child
components. Always pass a named component function. Each stable key owns one
branch, while the supplied `Val` carries later value changes into that branch.
The item's expansion flag is component-local state, so it uses `create_variable`.

```moonbit check
///|
struct Todo {
  id : Int
  title : String
  details : String
} derive(Eq)

///|
fn todo_item(id : Int, todo : Val[Todo]) -> Val[Html] {
  let (expanded, set_expanded) = @rabbita.create_variable(false)
  todo.view2(expanded, (todo, expanded) => {
    li([
      span("\{id}: \{todo.title}"),
      button(on_click=set_expanded(value => !value), "details"),
      if expanded {
        p(todo.details)
      } else {
        nothing
      },
    ])
  })
}

///|
fn todo_list(todos : Val[Vector[Todo]]) -> Val[Html] {
  let rows = todos.assoc_by(todo_item, by=todo => todo.id)
  rows.view(rows => ul(rows))
}
```

Keys must be unique and stable. The result follows the source `Vector` order.
Updating a value with the same key updates the `Val[Todo]` without rerunning the
branch component body, so `expanded` is preserved. Reordering also preserves
the branch. These keys identify incremental branches only. They are not attached
to the resulting `Html` values.

### Tagged branches

`enumerate` and `switch` select a component branch from a stable tag. Implement
`Enumerate` when an enum naturally defines those tags:

```moonbit check
///|
enum Panel {
  Overview
  Preferences
} derive(Eq)

///|
impl @rabbita.Enumerate for Panel with fn tag(self) {
  match self {
    Overview => "overview"
    Preferences => "preferences"
  }
}

///|
fn overview_panel() -> Val[Html] {
  Val::constant(h1("Overview"))
}

///|
fn preferences_panel() -> Val[Html] {
  Val::constant(h1("Preferences"))
}

///|
fn cached_panel(panel : Val[Panel]) -> Val[Html] {
  panel.enumerate(panel => {
    match panel {
      Overview => overview_panel()
      Preferences => preferences_panel()
    }
  })
}

///|
fn disposable_panel(panel : Val[Panel]) -> Val[Html] {
  panel.switch(panel => {
    match panel {
      Overview => overview_panel()
      Preferences => preferences_panel()
    }
  })
}
```

| API | Branch identity | Lifecycle |
| --- | --- | --- |
| `assoc` / `assoc_by` | A unique key | Removing the key disposes the branch |
| `enumerate` / `enumerate_by` | Every observed tag | Observed branches remain cached |
| `switch` / `switch_by` | The active tag | Changing tags replaces the branch |

Use `enumerate` for a small, bounded set of tabs and `switch` for pages or
dialogs. Avoid `enumerate` for an unbounded set of tags.

The selector callback runs only when its branch is created. A later value with
the same tag does not call it again, so that callback argument is not a live
component input. If a tagged value contains changing data, derive a separate
`Val` for that data and pass it to the named component. Immediately match the
tag and dispatch each case to a named component, as above. Do not put rendering
or state logic in the selector callback. An `if` or `match` inside `view` simply
chooses which `Html` to return each time the callback runs. Use `enumerate` or
`switch` when each case needs its own component state or subscriptions.

## Compared with fine-grained reactivity and implicit tracking

The incremental graph limits which callbacks produce new `Html`. The virtual
DOM turns those results into DOM updates while keeping views declarative.
Virtual DOM diffing is not usually the dominant factor in application
performance. Network requests, payloads, caching, and backend work often matter
more. If profiling identifies rendering as significant, split large views into
smaller components or use `@html.lazy(hash, render)` for an expensive subtree.
The hash must cover every input that affects the rendered `Html`.

Rabbita declares dependencies at `map` and `view` call sites instead of
inferring them from reads during rendering. A `Val` cannot be read as an
ordinary value, so a reactive read cannot accidentally happen outside a
tracking context and leave the UI stale. Passing dependencies explicitly adds
some plumbing, but keeps graph edges and branch lifetimes visible.
