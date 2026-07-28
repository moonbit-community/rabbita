# Subscriptions

The `sub` package models **long-lived external signals** that should feed back
into your TEA update loop.

Unlike `Cmd`, which runs once, a `Sub` stays installed until your app stops
returning it.

## Basic shape

In Rabbita, subscriptions are usually returned from the `subscriptions`
callback of `create_state`.

```mbt nocheck
///|
fn subscriptions(model : Model, emit : Emit[Msg]) -> @sub.Sub {
  if model.running {
    @sub.every(1000, emit(Tick))
  } else {
    @sub.none
  }
}
```

## Building subscriptions

Use `none` when nothing should be active:

```moonbit nocheck
///|
test "sub none" {
  let _ : Sub = @sub.none
}
```

Use `batch` to combine multiple subscriptions:

```moonbit nocheck
///|
test "sub batch" {
  let _ : Sub = @sub.batch([none, every(1000, @cmd.none)])
}
```

## Emitting messages

Event-based subscriptions usually work with `emit.map(...)`, just like
HTML event handlers.

```mbt nocheck
///|
enum Msg {
  Resized(ViewPort)
  MouseMoved(Mouse)
}

///|
fn subscriptions(_model : Model, emit : Emit[Msg]) -> @sub.Sub {
  @sub.batch([
    @sub.on_resize(v => emit(Resized(v))),
    @sub.on_mouse_move(m => emit(MouseMoved(m))),
  ])
}
```
