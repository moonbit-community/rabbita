///|
using @html {div, text}

///|
pub(all) enum Msg {
  Noop
}

///|
fn view(emit : @rabbita.Emit[Msg], _ : Unit) -> @rabbita.Html {
  ignore(emit)
  div([text("local project4 app-a")])
}

///|
fn main {
  let app = @rabbita.new(() => {
    let (model, emit) = @rabbita.create_pure_state(
      (),
      update=fn(_, _ : Msg) { () },
    )
    model.map(model => view(emit, model))
  })
  app.mount("app")
}
