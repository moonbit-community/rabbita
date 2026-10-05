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
    // Properties whose DOM name is camelCase where the attribute is not.
    let submit_attrs = @html.Attrs::build()
    let form_attrs = @html.Attrs::build().id("optional-form")
    let image_attrs = @html.Attrs::build()
    let video_attrs = @html.Attrs::build()
    if flag is Some(flag) {
      ignore(custom_attrs.checked(flag))
      ignore(submit_attrs.formnovalidate(flag))
      ignore(form_attrs.novalidate(flag))
      ignore(image_attrs.ismap(flag))
      ignore(video_attrs.playsinline(flag))
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
      button(
        id="optional-button",
        disabled?=flag,
        attrs=submit_attrs,
        "Optional button",
      ),
      label(for_="optional-checkbox", "Optional checkbox"),
      input(id="optional-checkbox", input_type=Checkbox, checked?=flag),
      label(for_="optional-input", "Optional text"),
      input(id="optional-input", value?, required?=flag, read_only?=flag),
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
        attrs=video_attrs,
        ([] : Array[Html]),
      ),
      @html.node("form", form_attrs, ([] : Array[Html])),
      @html.img(id="optional-image", attrs=image_attrs),
      @html.iframe(id="optional-frame", allowfullscreen?=flag),
      @html.node("property-probe", custom_attrs, ([] : Array[Html])),
    ])
  })
}
