///|
using @html {div, h1}

///|
using @rabbita {type Cmd, type Emit, type Html, type Val}

///|
enum Msg {
  SelectPattern(Int)
  AnimationFrameTick(Double)
}

///|
struct Model {
  frame_count : Int
  last_frame_ms : Double
  logo : LogoModel
  logo_pattern_index : Int
} derive(Eq)

///|
fn update(model : Model, msg : Msg, _ : Emit[Msg]) -> (Model, Cmd) {
  match msg {
    SelectPattern(index) => (set_animation_pattern(index, model), @rabbita.none)
    AnimationFrameTick(timestamp) =>
      (step_animation_frame(timestamp, model), @rabbita.none)
  }
}

///|
fn subscriptions(_ : Model, emit : Emit[Msg]) -> @sub.Sub {
  @sub.on_animation_frame(emit.map(timestamp => AnimationFrameTick(timestamp)))
}

///|
fn view(emit : Emit[Msg], model : Val[Model]) -> Val[Html] {
  let logo = model.map(model => logo_view(model.logo))
  let actions = model.map(model => {
    animation_actions(emit, model.logo_pattern_index)
  })
  logo.map2(actions, (logo, actions) => {
    div(class="page") <| [
      h1(class="title", "Rabbita Animation"),
      div(class="stage") <| [
        logo,
      ],
      div(class="actions") <| actions,
    ]
  })
}

///|
#cfg(target="js")
fn main {
  let initial_model = reset_animation({
    frame_count: 0,
    last_frame_ms: 0.0,
    logo: logo_start(),
    logo_pattern_index: 0,
  })
  fn app() {
    let (model, emit) = @rabbita.create_state(
      initial_model,
      update~,
      subscriptions~,
    )
    view(emit, model)
  }
  @rabbita.new(app).mount("app")
}
