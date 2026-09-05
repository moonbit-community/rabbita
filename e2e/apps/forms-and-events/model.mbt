///|
priv struct Model {
  text : String
  changed : String
  choice : String
  submits : Int
  focused : Bool
  keydowns : Int
  decorated : Bool
  locked : Bool
  checked : Bool
  handler_a : Int
  handler_b : Int
} derive(Eq)

///|
priv enum Msg {
  InputChanged(String)
  ChangeCommitted(String)
  ChoiceChanged(String)
  Submitted
  Focused
  Blurred
  KeyDown
  ToggleDecoration
  ToggleLocked
  ToggleChecked
  ResetValue
  HandlerA
  HandlerB
}

///|
fn update(model : Model, message : Msg) -> Model {
  match message {
    InputChanged(value) => { ..model, text: value, }
    ChangeCommitted(value) => { ..model, changed: value, }
    ChoiceChanged(value) => { ..model, choice: value, }
    Submitted => { ..model, submits: model.submits + 1, }
    Focused => { ..model, focused: true, }
    Blurred => { ..model, focused: false, }
    KeyDown => { ..model, keydowns: model.keydowns + 1, }
    ToggleDecoration => { ..model, decorated: !model.decorated, }
    ToggleLocked => { ..model, locked: !model.locked, }
    ToggleChecked => { ..model, checked: !model.checked, }
    ResetValue => { ..model, text: "reset", }
    HandlerA => { ..model, handler_a: model.handler_a + 1, }
    HandlerB => { ..model, handler_b: model.handler_b + 1, }
  }
}
