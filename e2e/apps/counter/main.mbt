///|
using @rabbita {type Html, type Val}

///|
using @html {button, div, h1}

///|
priv enum Msg {
  Increment
  Decrement
}

///|
fn app() -> Val[Html] {
  let (count, emit) = @rabbita.create_pure_state(0, update=fn(count, message) {
    match message {
      Increment => count + 1
      Decrement => count - 1
    }
  })
  let actions = div(class="actions") <| [
    button(on_click=emit(Decrement), "-"),
    button(on_click=emit(Increment), "+"),
  ]
  count.view(count => {
    div(class="app") <| [
      h1("\{count}"),
      actions,
    ]
  })
}

///|
fn main {
  @rabbita.new(app).mount("app")
}
