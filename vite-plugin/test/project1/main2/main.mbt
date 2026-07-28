///|
pub(all) enum Message {
  /// adsfadsf
  /// adsadsfasdf
  /// adsfasdf
  Increment
  /// asdfasdf
  /// asdfasdfasdf
  /// adfadsfasd
  Decrement
  // Ubc(Int, Bool)
}

///|
struct Model {
  count : Int
} derive(Eq)

///|
fn update(model : Model, msg : Message) -> Model {
  match msg {
    Increment => { count: model.count + 1 }
    Decrement => {
      let next = model.count - 1
      { count: if next < 0 { 0 } else { next } }
    }
  }
}

///|
fn view(emit : @rabbita.Emit[Message], model : Model) -> @rabbita.Html {
  div(class="w-[600px] h-[100px] m-10", [
    h1(class="text-2xl font-bold text-center select-none", [
      text("\{model.count}"),
    ]),
    div(class="flex justify-center gap-8 m-8", [
      @views.button("+", on_click=emit(Increment)),
      @views.button("-", on_click=emit(Decrement)),
    ]),
  ])
}

///|
/// NOTE: This program is only available in the js backend, 
/// see README.md to getting started.
fn main {
  let app = @rabbita.new(() => {
    let (model, emit) = @rabbita.create_pure_state({ count: 0 }, update~)
    model.map(model => view(emit, model))
  })
  app.mount("app")
}
