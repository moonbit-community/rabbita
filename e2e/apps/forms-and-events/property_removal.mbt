///|
fn property_removal_fixture() -> Val[Html] {
  let (phase, set_phase) = @rabbita.create_variable(0)
  let (revision, set_revision) = @rabbita.create_variable(0)
  phase.view2(revision, (phase, revision) => {
    let flag = if phase == 2 { None } else { Some(phase != 1) }
    let value = if phase == 2 {
      None
    } else {
      Some(
        match phase {
          0 => "initial"
          1 => ""
          _ => "updated"
        },
      )
    }
    let select_attrs = @html.Attrs::build()
    let custom_attrs = @html.Attrs::build().id("property-probe")
    if value is Some(value) {
      ignore(select_attrs.value_prop(value))
      ignore(custom_attrs.value_prop(value))
    }
    if flag is Some(flag) {
      ignore(custom_attrs.checked(flag))
    }
    @html.section([
      @html.h2("Optional DOM properties"),
      button(on_click=set_phase(_ => 0), "Set initial properties"),
      button(on_click=set_phase(_ => 3), "Set updated properties"),
      button(on_click=set_phase(_ => 1), "Set empty properties"),
      button(on_click=set_phase(_ => 2), "Omit properties"),
      button(
        on_click=set_revision(revision => revision + 1),
        "Rerender properties",
      ),
      p(id="property-revision", "revision: \{revision}"),
      button(id="optional-button", disabled?=flag, "Optional button"),
      label(for_="optional-checkbox", "Optional checkbox"),
      input(id="optional-checkbox", input_type=Checkbox, checked?=flag),
      label(for_="optional-input", "Optional text"),
      input(id="optional-input", value?, required?=flag),
      label(for_="optional-textarea", "Optional textarea"),
      @html.textarea(id="optional-textarea", value?, ([] : Array[Html])),
      label(for_="optional-select", "Optional selection"),
      select(id="optional-select", attrs=select_attrs, [
        option(value="", "Choose a value"),
        option(value="initial", "Initial"),
        option(value="updated", "Updated"),
      ]),
      label(for_="optional-multiple", "Optional multiple selection"),
      select(id="optional-multiple", multiple?=flag, [
        option(value="first", "First"),
        option(value="second", "Second"),
      ]),
      div(id="optional-hidden", hidden?=flag, "Optional hidden content"),
      @html.video(
        id="optional-video",
        controls?=flag,
        autoplay?=flag,
        loop_?=flag,
        muted?=flag,
        ([] : Array[Html]),
      ),
      @html.node("property-probe", custom_attrs, ([] : Array[Html])),
    ])
  })
}
