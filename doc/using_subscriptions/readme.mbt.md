# Using Subscriptions

`subscriptions` is a declarative API for long lived external signals. 
Unlike `Cmd`, which runs once, `Sub` can keep sending messages over time.

Use `subscriptions` when your app needs to keep listening to timers, window size, 
scroll, keyboard, mouse, page visibility, or animation frames. Rabbita 
reevaluates the `subscriptions` function after each update, and the returned 
value declares which subscriptions should be active for the current `Model`: a 
subscription becomes active when it appears, stays active while it keeps 
appearing, and is removed when it disappears.

## Basic shape

In this example, `on_resize` keeps the current viewport size in the `Model`.

```moonbit check
///|
enum Msg {
  ViewportChanged(@common.Viewport)
}

///|
struct Model {
  width : Double
  height : Double
} derive(Eq)

///|
fn subscriptions(model : Model, emit : Emit[Msg]) -> @sub.Sub {
  ignore(model)
  @sub.on_resize(v => emit(ViewportChanged(v)))
}

///|
fn app() -> Val[Html] {
  let (model, _) = @rabbita.create_state(
    { width: 0, height: 0, },
    subscriptions~,
    update=fn(_, msg, _) {
      let model = match msg {
        ViewportChanged(viewport) =>
          { width: viewport.width, height: viewport.height, }
      }
      (model, none)
    },
  )
  model.map(model => {
    div([
      h1("viewport"),
      p("width = \{model.width}"),
      p("height = \{model.height}"),
    ])
  })
}
```

## Multiple subscriptions

Use `@sub.batch(...)` when more than one subscription should be active at the same time.

```moonbit check
///|
enum EventMsg {
  Resized(@common.Viewport)
  HiddenChanged(Bool)
}

///|
fn event_subscriptions(emit : Emit[EventMsg], _ : Int) -> @sub.Sub {
  @sub.batch([
    @sub.on_resize(v => emit(Resized(v))),
    @sub.on_visibility_change(h => emit(HiddenChanged(h))),
  ])
}
```

If nothing should be active, return `@sub.none`.

## Common builtins

The builtins you will use most often are:

| API | Use case |
| --- | --- |
| `@sub.every(ms, cmd)` | Timers |
| `@sub.on_resize(...)` | Window size changes |
| `@sub.on_scroll(...)` | Page scrolling |
| `@sub.on_key_down(...)` | Key down events |
| `@sub.on_key_up(...)` | Key up events |
| `@sub.on_mouse_move(...)` | Mouse movement |
| `@sub.on_visibility_change(...)` | Page visibility changes |
| `@sub.on_animation_frame(...)` | Animation frame updates |

Route related subscriptions are covered in the Router chapter. Check the [API docs](https://mooncakes.io/docs/moonbit-community/rabbita/sub#Sub) for more builtins.
