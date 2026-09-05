///|
let rabbit_logo_pattern_index = 7

///|
fn reset_animation(model : Model) -> Model {
  ignore(model)
  {
    frame_count: 0,
    last_frame_ms: 0.0,
    logo: logo_static_pattern(rabbit_logo_pattern_index),
    logo_pattern_index: rabbit_logo_pattern_index,
  }
}

///|
fn step_animation_frame(timestamp : Double, model : Model) -> Model {
  let delta_ms = if model.last_frame_ms == 0.0 {
    16.0
  } else {
    timestamp - model.last_frame_ms
  }
  if logo_is_moving(model.logo) {
    let next_logo = logo_step(delta_ms, model.logo)
    {
      frame_count: model.frame_count + 1,
      last_frame_ms: timestamp,
      logo: next_logo,
      logo_pattern_index: model.logo_pattern_index,
    }
  } else {
    { ..model, frame_count: model.frame_count + 1, last_frame_ms: timestamp, }
  }
}

///|
fn animation_pattern_indices() -> Array[Int] {
  [0, 1, 2, 3, 4, 5, 6, 7]
}

///|
fn set_animation_pattern(index : Int, model : Model) -> Model {
  if index == model.logo_pattern_index {
    model
  } else {
    {
      ..model,
      logo_pattern_index: index,
      logo: logo_set_pattern_by_index(index, model.logo),
    }
  }
}

///|
fn animation_pattern_button(
  emit : @rabbita.Emit[Msg],
  active_index : Int,
  index : Int,
) -> @rabbita.Html {
  let class = if active_index == index { "tab active" } else { "tab" }
  @html.button(
    class~,
    on_click=emit(SelectPattern(index)),
    logo_pattern_name(index),
  )
}

///|
fn animation_actions(
  emit : @rabbita.Emit[Msg],
  active_index : Int,
) -> Array[@rabbita.Html] {
  animation_pattern_indices().map(index => {
    animation_pattern_button(emit, active_index, index)
  })
}
