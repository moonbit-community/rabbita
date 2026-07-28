///|
using @html {div, text, h1}

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
  div(style=["width: 600px", "margin: 40px auto"], [
    h1(style=["font-size: 2rem", "font-weight: 700", "text-align: center"], [
      text("\{model.count}"),
    ]),
    div(
      style=[
        "display: flex", "justify-content: center", "gap: 32px", "margin-top: 24px",
      ],
      [
        button("+", on_click=emit(Increment)),
        button("-", on_click=emit(Decrement)),
      ],
    ),
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

///|
pub fn button(value : String, on_click~ : @rabbita.Cmd) -> @rabbita.Html {
  let style = [
    "padding: 12px 16px", "background: #ffd6e7", "width: 96px", "border-radius: 10px",
    "user-select: none", "text-align: center", "cursor: pointer", "box-shadow: 0 4px 8px rgba(0,0,0,0.08)",
  ]
  div(on_click~, style~, [text(value)])
}
