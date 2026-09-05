# An Introduction to Rabbita

Rabbita (formerly Rabbit-TEA) is a declarative, functional UI framework for MoonBit.

It is inspired by the Elm Architecture (TEA), which has significantly
influenced modern state management design in frontend development. Its impact
can be seen in libraries such as Redux and ecosystem variants like NgRx and
Vuex, as well as in projects beyond JavaScript, including:

- Iced (Rust, native GUI)
- Bubble Tea (Go, CLI)
- Lustre (Gleam)

Rabbita supports:

- Full HTML wrappers  
- Live reload and breakpoint debugging during development  
- HTTP request APIs  
- Server-side rendering (experimental)  
- Typed DOM APIs (partial, experimental)  
- Incremental UI updates
- Streaming DOM diff with keyed reconciliation

## Quick example

Here we implement a counter with component-local state. We start by defining
its `Model` and the `Msg` values that can update it:

```moonbit check
///|
struct Model {
  count : Int
} derive(Eq)

///|
enum Msg {
  Inc
  Dec
}
```

`Model` is the counter's plain state. It derives `Eq` so Rabbita can stop
propagating an update when the new model equals the old one. `Msg` describes
the two updates this component accepts.

The root component creates its state and derives HTML from it:

```moonbit check
///|
fn app() -> Val[Html] {
  // init : Model
  let init = { count: 0, }
  // model : Val[Model], emit : Emit[Msg]
  let (model, emit) = @rabbita.create_pure_state(init, update=fn(model, msg) {
    match msg {
      Inc => { count: model.count + 1, }
      Dec => { count: model.count - 1, }
    }
  })

  model.view(current_model => {
    div([
      h1("\{current_model.count}"),
      button(on_click=emit(Inc), "+"),
      button(on_click=emit(Dec), "-"),
    ])
  })
}
```

In this example:

- `app` is a component.
- `Val[T]` is a lazily evaluated `T` in incremental graph. Derived
  values only propagate changes when their dependencies' `Eq` values change.
- `init` is the initial `Model`.
- `create_pure_state` uses the pure update function and returns
  `Val[Model]`, a `Val` that yields a `Model`, together with
  `Emit[Msg]`.
- An `Emit[Msg]` turns a `Msg` into a `Cmd`. Here, `emit(Inc)` creates the
  command passed to `on_click`. `update` runs later when the button is clicked
  and Rabbita processes that command.
- `model.view(...)` derives a `Val[Html]` from `model`. Its callback receives a
  `Model` value.

The `app` component runs once when mounted to construct the incremental graph.
Processing a message does not run `app` again. When the value yielded by
`model` changes, Rabbita reevaluates the callback passed to `model.view`.
`model` remains a `Val[Model]`. The callback parameter `current_model` is the
resulting `Model` value for that evaluation.

The comments show types that MoonBit infers from `init`, the update function,
and the messages passed to `emit`. Explicit annotations are not required. The
component API remains statically typed, so an invalid model or message is
reported by the compiler.

```moonbit nocheck
///|
fn main {
  @rabbita.new(app).mount("main")
}
```

`new(app)` creates an application from the root component builder.
`mount("main")` runs that builder, evaluates the root `Val[Html]`, and inserts
the initial result into the DOM element whose id is `main`. The host page must
contain that element.

At this point the user sees:

![Counter UI](counter.png)

Clicking `+` follows this flow:

```text
click
  -> submit the command created by emit(Inc)
  -> update(Inc, old_model)
  -> propagate the updated Model through the incremental graph
  -> if the model changed, reevaluate dependent render callbacks on the next frame
  -> diff and patch the DOM
```

If `update` returns an equal model, propagation stops before the render
callback. Larger components can derive smaller `Val` values so changes only
reevaluate the views that depend on them. Use `create_state` instead of
`create_pure_state` when an update also needs to schedule commands or manage
subscriptions.
