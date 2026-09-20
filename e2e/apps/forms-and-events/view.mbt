///|
using @rabbita {type Html, type Val}

///|
using @html {button, div, form, h1, input, label, option, p, select}

///|
fn app() -> Val[Html] {
  let initial : Model = {
    text: "initial",
    changed: "",
    choice: "red",
    submits: 0,
    focused: false,
    keydowns: 0,
    decorated: false,
    locked: false,
    checked: false,
    handler_a: 0,
    handler_b: 0,
  }
  let (model, emit) = @rabbita.create_pure_state(initial, update~)
  let properties = property_removal_fixture()
  model.view2(properties, (model, properties) => {
    let field_attrs = @html.Attrs::build()
      .on_focus(_ => emit(Focused))
      .on_blur(_ => emit(Blurred))
      .on_keydown(_ => emit(KeyDown))
    let composed_attrs = @html.Attrs::build()
      .on_click(_ => emit(HandlerA))
      .on_click(_ => emit(HandlerB))
    div <| [
      h1("Forms and events"),
      form(on_submit=emit(Submitted), [
        label(for_="name-input", "Name"),
        input(
          id="name-input",
          value=model.text,
          on_input=emit.map(value => InputChanged(value)),
          on_change=emit.map(value => ChangeCommitted(value)),
          attrs=field_attrs,
        ),
        label(for_="color-select", "Color"),
        select(
          id="color-select",
          on_change=emit.map(value => ChoiceChanged(value)),
          [
            option(value="red", selected=model.choice == "red", "Red"),
            option(value="blue", selected=model.choice == "blue", "Blue"),
          ],
        ),
        button(type_="submit", "Submit form"),
      ]),
      p(id="input-value", "input: \{model.text}"),
      p(id="change-value", "change: \{model.changed}"),
      p(id="choice-value", "choice: \{model.choice}"),
      p(id="submit-count", "submits: \{model.submits}"),
      p(id="focus-state", if model.focused { "focused" } else { "blurred" }),
      p(id="keydown-count", "keydowns: \{model.keydowns}"),
      button(on_click=emit(ResetValue), "Reset controlled value"),
      button(on_click=emit(ToggleDecoration), "Toggle title attribute"),
      button(
        id="decorated-button",
        title?=if model.decorated { Some("decorated") } else { None },
        "Decorated target",
      ),
      button(on_click=emit(ToggleLocked), "Toggle disabled"),
      button(id="controlled-button", disabled=model.locked, "Controlled button"),
      button(on_click=emit(ToggleChecked), "Toggle checked"),
      label(for_="controlled-checkbox", "Controlled checkbox"),
      input(
        id="controlled-checkbox",
        input_type=Checkbox,
        checked=model.checked,
      ),
      button(attrs=composed_attrs, "Run composed handlers"),
      p(id="handler-a", "handler a: \{model.handler_a}"),
      p(id="handler-b", "handler b: \{model.handler_b}"),
      properties,
    ]
  })
}
