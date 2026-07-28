using @rabbita { type Val, type Html, create_pure_state, new }
using @html {div, h1, button}

enum Msg {
  Inc
  Dec
}

fn main {
  fn app() -> Val[Html] {
    let (model, emit) = create_pure_state(
      0,
      update=(model, msg) =>
        match msg {
          Inc => model + 1
          Dec => model - 1
        },
    )
    model.map(model => div <| [
      h1("\{model}"),
      button(on_click=emit(Inc), "+"),
      button(on_click=emit(Dec), "-"),
    ])
  }
  new(app).mount("app")
}
