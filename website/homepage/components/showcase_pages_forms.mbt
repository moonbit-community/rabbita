///|
fn showcase_input_page() -> @rabbita.Val[@html.Html] {
  let (input_name, set_input_name) = @rabbita.create_variable("Ada Lovelace")
  let (input_email, set_input_email) = @rabbita.create_variable(
    "ada@example.com",
  )
  let input_text_view = input_name.view(name => {
    @html.div(
      style=["width:min(100%,24rem);margin-inline:auto"],
      @rui.input(
        id="forms-gallery-input-name",
        name="standalone-display-name",
        value=name,
        placeholder="Ada Lovelace",
        on_input=set_input_name.map(value => _ => value),
      ),
    )
  })
  let input_email_view = input_email.view(email => {
    @html.div(
      style=["width:min(100%,24rem);margin-inline:auto"],
      @rui.input(
        id="forms-gallery-input-email",
        input_type=Email,
        value=email,
        invalid=email == "invalid",
        placeholder="ada@example.com",
        on_input=set_input_email.map(value => _ => value),
      ),
    )
  })
  let input_disabled = @html.div(
    style=["width:min(100%,24rem);margin-inline:auto"],
    @rui.input(
      id="forms-gallery-input-disabled",
      value="Inherited workspace",
      disabled=true,
    ),
  )
  input_text_view.view2(input_email_view, (text_html, email_html) => {
    forms_input_component(text_html, email_html, input_disabled)
  })
}

///|
fn showcase_textarea_page() -> @rabbita.Val[@html.Html] {
  let (textarea_note, set_textarea_note) = @rabbita.create_variable(
    "Ship the first programmable workspace.",
  )
  textarea_note.view(note => {
    let default_html = @html.div(
      style=["width:min(100%,24rem);margin-inline:auto"],
      @rui.textarea(
        id="forms-gallery-textarea-default",
        value=note,
        rows=4,
        placeholder="What should collaborators know?",
        on_input=set_textarea_note.map(value => _ => value),
      ),
    )
    let invalid_html = @html.div(
      style=["width:min(100%,24rem);margin-inline:auto"],
      @rui.textarea(
        id="forms-gallery-textarea-invalid",
        rows=4,
        invalid=true,
        placeholder="Explain what failed…",
      ),
    )
    let disabled_html = @html.div(
      style=["width:min(100%,24rem);margin-inline:auto"],
      @rui.textarea(
        id="forms-gallery-textarea-disabled",
        rows=4,
        value="Managed by your organization",
        disabled=true,
      ),
    )
    forms_textarea_component(default_html, invalid_html, disabled_html)
  })
}

///|
fn showcase_radio_group_page() -> @rabbita.Val[@html.Html] {
  let (plan, set_plan) = @rabbita.create_variable("monthly")
  let horizontal = @rui.radio_group(
    default_value="monthly",
    name="forms-gallery-billing",
    orientation=RadioHorizontal,
    aria_label="Billing cycle",
    on_value_change=set_plan.map(value => _ => value),
    scope => {
      @html.div(style=[RowStyle], [
        @html.div(style=[FormsGalleryChoiceStyle], [
          @rui.radio_group_item(
            scope~,
            value="monthly",
            id="forms-gallery-monthly",
            aria_label="Monthly",
          ),
          @rui.label(for_="forms-gallery-monthly", "Monthly"),
        ]),
        @html.div(style=[FormsGalleryChoiceStyle], [
          @rui.radio_group_item(
            scope~,
            value="annual",
            id="forms-gallery-annual",
            aria_label="Annual",
          ),
          @rui.label(for_="forms-gallery-annual", "Annual"),
        ]),
      ])
    },
  )
  let vertical = @rui.radio_group(
    default_value="automatic",
    name="forms-gallery-sync",
    orientation=RadioVertical,
    aria_label="Sync strategy",
    scope => {
      @html.div(style=[StackStyle, "gap:0.625rem"], [
        @html.div(style=[FormsGalleryChoiceStyle], [
          @rui.radio_group_item(
            scope~,
            value="automatic",
            id="forms-gallery-sync-automatic",
            aria_label="Automatic sync",
          ),
          @rui.label(for_="forms-gallery-sync-automatic", "Automatic"),
        ]),
        @html.div(style=[FormsGalleryChoiceStyle], [
          @rui.radio_group_item(
            scope~,
            value="manual",
            id="forms-gallery-sync-manual",
            aria_label="Manual sync",
          ),
          @rui.label(for_="forms-gallery-sync-manual", "Manual"),
        ]),
      ])
    },
  )
  let horizontal_stage = plan.view2(horizontal, (plan, horizontal_html) => {
    @html.div(
      style=[
        "display:flex;width:min(100%,32rem);margin-inline:auto;flex-direction:column;gap:1rem",
      ],
      [
        horizontal_html,
        @html.output(style=[MutedStyle], "Billing value: \{plan}"),
      ],
    )
  })
  let vertical_stage = vertical.view(vertical_html => {
    @html.div(style=["width:min(100%,32rem);margin-inline:auto"], vertical_html)
  })
  horizontal_stage.view2(vertical_stage, forms_radio_component)
}

///|
fn showcase_slider_page() -> @rabbita.Val[@html.Html] {
  let (density_value, set_density) = @rabbita.create_variable(64)
  let density_slider = @rui.slider(
    id="forms-gallery-density",
    default_value=64,
    min=0,
    max=100,
    step=4,
    aria_label="Interface density",
    on_value_change=set_density.map(value => _ => value),
  )
  let range_slider = @rui.slider_values(
    id="forms-gallery-budget-range",
    default_values=[28, 72],
    min=0,
    max=100,
    step=4,
    large_step=12,
    min_steps_between_values=3,
    aria_label="Budget range",
  )
  let vertical_slider = @rui.slider(
    id="forms-gallery-volume",
    default_value=68,
    orientation=Vertical,
    aria_label="Preview volume",
    style=["height:10rem"],
  )
  let default_stage = density_value.view2(density_slider, (
    density_value,
    density_html,
  ) => {
    @html.div(
      style=[
        "display:flex;width:min(100%,32rem);margin-inline:auto;flex-direction:column;gap:1rem",
      ],
      [
        @html.div(style=[ControlRowStyle], [
          @rui.label(for_="forms-gallery-density", "Interface density"),
          @html.output(style=[MutedStyle], "\{density_value}%"),
        ]),
        density_html,
      ],
    )
  })
  let range_stage = range_slider.view(range_html => {
    @html.div(style=["width:min(100%,32rem);margin-inline:auto"], range_html)
  })
  let vertical_stage = vertical_slider.view(vertical_html => {
    @html.div(
      style=[
        "display:flex;min-height:12rem;align-items:center;justify-content:center",
      ],
      vertical_html,
    )
  })
  default_stage.view3(range_stage, vertical_stage, forms_slider_component)
}

///|
fn showcase_field_page() -> @rabbita.Val[@html.Html] {
  let (form_state, set_form_state) = @rabbita.create_variable(
    (
      "Ada Lovelace", "ada@example.com", "analytical-engine", "Ship the first programmable workspace.",
      false,
    ),
  )
  form_state.view(state => {
    let (name, email, website, note, submitted) = state
    let email_invalid = email == "invalid"
    let field_composition = @rui.form(
      id="forms-gallery-profile-form",
      name="workspace-profile",
      on_submit=set_form_state(state => {
        (state.0, state.1, state.2, state.3, true)
      }),
      @rui.field_set([
        @rui.field_legend("Create a workspace"),
        @rui.field_group(style=[FormsGalleryFormGridStyle], [
          @rui.form_field(
            name="display-name",
            required=true,
            describedby="forms-gallery-name-description",
            [
              @rui.form_label(for_="forms-gallery-name", "Display name"),
              @rui.form_control(
                @rui.input(
                  id="forms-gallery-name",
                  name="display-name",
                  value=name,
                  required=true,
                  auto_complete="on",
                  placeholder="Ada Lovelace",
                  on_input=set_form_state.map(value => {
                    state => (value, state.1, state.2, state.3, false)
                  }),
                ),
              ),
              @rui.form_description(
                id="forms-gallery-name-description",
                "Shown to collaborators across the workspace.",
              ),
            ],
          ),
          @rui.form_field(
            name="email",
            invalid=email_invalid,
            required=true,
            describedby="forms-gallery-email-description",
            errormessage="forms-gallery-email-error",
            [
              @rui.form_label(for_="forms-gallery-email", "Email"),
              @rui.form_control(
                @rui.input(
                  input_type=Email,
                  id="forms-gallery-email",
                  name="email",
                  value=email,
                  required=true,
                  invalid=email_invalid,
                  auto_complete="on",
                  placeholder="ada@example.com",
                  on_input=set_form_state.map(value => {
                    state => (state.0, value, state.2, state.3, false)
                  }),
                ),
              ),
              @rui.form_description(
                id="forms-gallery-email-description",
                "Type “invalid” to preview the destructive state.",
              ),
              if email_invalid {
                @rui.form_message(
                  id="forms-gallery-email-error",
                  "Enter a valid email address.",
                )
              } else {
                @html.nothing
              },
            ],
          ),
          @rui.field([
            @rui.field_label(for_="forms-gallery-site", "Workspace URL"),
            @rui.input_group([
              @rui.input_group_addon(
                for_="forms-gallery-site",
                @rui.input_group_text("https://"),
              ),
              @rui.input_group_input(
                id="forms-gallery-site",
                name="workspace-url",
                value=website,
                placeholder="project-name",
                on_input=set_form_state.map(value => {
                  state => (state.0, state.1, value, state.3, false)
                }),
              ),
              @rui.input_group_addon(
                align=InputInlineEnd,
                @rui.input_group_text(".moonbit.app"),
              ),
            ]),
            @rui.field_description(
              "Input Group keeps prefixes and suffixes on one control surface.",
            ),
          ]),
          @rui.field([
            @rui.field_label(for_="forms-gallery-note", "Launch note"),
            @rui.textarea(
              id="forms-gallery-note",
              name="launch-note",
              value=note,
              rows=4,
              placeholder="What should collaborators know?",
              on_input=set_form_state.map(value => {
                state => (state.0, state.1, state.2, value, false)
              }),
            ),
            @rui.field_description(
              "Textarea remains a native, parent-controlled value.",
            ),
          ]),
        ]),
        @html.div(style=[ControlRowStyle], [
          @html.output(
            style=[MutedStyle],
            if submitted {
              "Saved locally — submit default was prevented."
            } else {
              "Edit a field, then submit the native form."
            },
          ),
          @rui.button(type_="submit", "Save workspace"),
        ]),
      ]),
    )
    forms_field_variants(field_composition)
  })
}

///|
fn showcase_forms_page(slug : String) -> @rabbita.Val[@html.Html] {
  match slug {
    "calendar" => calendar_showcase()
    "checkbox" => forms_checkbox_variants()
    "combobox" => forms_combobox_variants()
    "date-picker" => date_picker_showcase()
    "field" => showcase_field_page()
    "input" => showcase_input_page()
    "input-group" => forms_input_group_variants()
    "input-otp" => forms_otp_variants()
    "native-select" => showcase_static_page(forms_native_select_variants())
    "radio-group" => showcase_radio_group_page()
    "select" => forms_select_variants()
    "slider" => showcase_slider_page()
    "switch" => forms_switch_variants()
    "textarea" => showcase_textarea_page()
    _ => showcase_static_page(@html.nothing)
  }
}
