using @rabbita { type Val, type Html }
using @html { button, div, h1 }

enum Msg {
  Inc
  Dec
}

fn app() -> Val[Html] {
  let (model, emit) = @rabbita.create_pure_state(
    0,
    update=fn(model, msg) {
      match msg {
        Inc => model + 1
        Dec => model - 1
      }
    },
  )

  model.view(model => div(class="app") <| [
    h1("\{model}"),
    div(class="actions") <| [
      button(on_click=emit(Dec), "-"),
      button(on_click=emit(Inc), "+"),
    ],
  ])
}

fn main {
  @rabbita.new(app).mount("app")
}
