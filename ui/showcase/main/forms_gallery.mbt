///|
priv struct FormsGalleryModel {
  name : String
  email : String
  website : String
  note : String
  black_box_plan : String
  slider_value : Int
  submitted : Bool
} derive(Eq)

///|
priv enum FormsGalleryMsg {
  FormsGalleryNameChanged(String)
  FormsGalleryEmailChanged(String)
  FormsGalleryWebsiteChanged(String)
  FormsGalleryNoteChanged(String)
  FormsGalleryBlackBoxPlanChanged(String)
  FormsGallerySliderChanged(Int)
  FormsGallerySubmitted
}

///|
fn forms_gallery_update(
  msg : FormsGalleryMsg,
  model : FormsGalleryModel,
) -> FormsGalleryModel {
  match msg {
    FormsGalleryNameChanged(name) => { ..model, name, submitted: false }
    FormsGalleryEmailChanged(email) => { ..model, email, submitted: false }
    FormsGalleryWebsiteChanged(website) =>
      { ..model, website, submitted: false }
    FormsGalleryNoteChanged(note) => { ..model, note, submitted: false }
    FormsGalleryBlackBoxPlanChanged(black_box_plan) =>
      { ..model, black_box_plan, }
    FormsGallerySliderChanged(slider_value) => { ..model, slider_value, }
    FormsGallerySubmitted => { ..model, submitted: true }
  }
}

///|
const FormsGallerySectionStyle : String = "grid-column:1 / -1;display:flex;min-width:0;flex-direction:column"

///|
const FormsGalleryComponentsStyle : String = "display:flex;min-width:0;flex-direction:column;gap:4rem"

///|
const FormsGalleryFormGridStyle : String = "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,18rem),1fr));gap:1.25rem"

///|
const FormsGalleryChoiceStyle : String = "display:flex;align-items:center;gap:0.625rem"

///|
const FormsGallerySpecimenStyle : String = "min-width:0"

///|
const FormsInputCode : String =
  #|let item = (title, note, body) => @html.div(
  #|  style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|  [
  #|    @html.div(
  #|      style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem", "gap:0.25rem"],
  #|      [
  #|        @html.h5(style=["margin:0;font-size:0.9375rem;line-height:1.375rem;font-weight:650;letter-spacing:-0.015em"], title),
  #|        @html.p(style=["margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], note),
  #|      ],
  #|    ),
  #|    @html.div(style=["min-width:0"], body),
  #|  ],
  #|)
  #|let (name, set_name) = @rabbita.create_variable("Ada Lovelace")
  #|let (email, set_email) = @rabbita.create_variable("ada@example.com")
  #|name.view2(email, (name, email) => {
  #|  let email_invalid = email == "invalid"
  #|  @html.div(
  #|    style=["display:grid;width:min(100%,48rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,13rem),1fr));gap:clamp(1.5rem,4vw,2.5rem);align-items:start"],
  #|    [
  #|      item("Text", "A parent-controlled text value.", @ui.input(
  #|        id="forms-gallery-input-name",
  #|        name="standalone-display-name",
  #|        value=name,
  #|        placeholder="Ada Lovelace",
  #|        on_input=set_name.map(value => _ => value),
  #|      )),
  #|      item("Email", "Type “invalid” to preview the destructive state.", @ui.input(
  #|        id="forms-gallery-input-email",
  #|        input_type=@html.Email,
  #|        value=email,
  #|        invalid=email_invalid,
  #|        placeholder="ada@example.com",
  #|        on_input=set_email.map(value => _ => value),
  #|      )),
  #|      item("Disabled", "Inherited values stay readable but unavailable.", @ui.input(
  #|        id="forms-gallery-input-disabled",
  #|        value="Inherited workspace",
  #|        disabled=true,
  #|      )),
  #|    ],
  #|  )
  #|})
  #|

///|
const FormsTextareaCode : String =
  #|let item = (title, note, body) => @html.div(
  #|  style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|  [
  #|    @html.div(
  #|      style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem", "gap:0.25rem"],
  #|      [
  #|        @html.h5(style=["margin:0;font-size:0.9375rem;line-height:1.375rem;font-weight:650;letter-spacing:-0.015em"], title),
  #|        @html.p(style=["margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], note),
  #|      ],
  #|    ),
  #|    @html.div(style=["min-width:0"], body),
  #|  ],
  #|)
  #|let (note, set_note) = @rabbita.create_variable(
  #|  "Ship the first programmable workspace.",
  #|)
  #|note.view(note => @html.div(
  #|  style=["display:grid;width:min(100%,48rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,13rem),1fr));gap:clamp(1.5rem,4vw,2.5rem);align-items:start"],
  #|  [
  #|    item("Default", "A parent-controlled launch note.", @ui.textarea(
  #|      id="forms-gallery-textarea-default",
  #|      value=note,
  #|      rows=4,
  #|      placeholder="What should collaborators know?",
  #|      on_input=set_note.map(value => _ => value),
  #|    )),
  #|    item("Invalid", "Validation styling keeps the multiline input editable.", @ui.textarea(
  #|      id="forms-gallery-textarea-invalid",
  #|      rows=4,
  #|      invalid=true,
  #|      placeholder="Explain what failed…",
  #|    )),
  #|    item("Disabled", "Managed copy remains readable.", @ui.textarea(
  #|      id="forms-gallery-textarea-disabled",
  #|      rows=4,
  #|      value="Managed by your organization",
  #|      disabled=true,
  #|    )),
  #|  ],
  #|))
  #|

///|
const FormsRadioGroupCode : String =
  #|let (plan, set_plan) = @rabbita.create_variable("monthly")
  #|let horizontal = @ui.radio_group(
  #|  default_value="monthly",
  #|  name="forms-gallery-billing",
  #|  orientation=@ui.RadioHorizontal,
  #|  aria_label="Billing cycle",
  #|  on_value_change=set_plan.map(value => _ => value),
  #|  scope => @html.div(
  #|    style=["display:flex;flex-wrap:wrap;align-items:center;gap:0.75rem"],
  #|    [
  #|      @html.div(style=["display:flex;align-items:center;gap:0.625rem"], [
  #|        @ui.radio_group_item(
  #|          scope~,
  #|          value="monthly",
  #|          id="forms-gallery-monthly",
  #|          aria_label="Monthly",
  #|        ),
  #|        @ui.label(for_="forms-gallery-monthly", "Monthly"),
  #|      ]),
  #|      @html.div(style=["display:flex;align-items:center;gap:0.625rem"], [
  #|        @ui.radio_group_item(
  #|          scope~,
  #|          value="annual",
  #|          id="forms-gallery-annual",
  #|          aria_label="Annual",
  #|        ),
  #|        @ui.label(for_="forms-gallery-annual", "Annual"),
  #|      ]),
  #|    ],
  #|  ),
  #|)
  #|let vertical = @ui.radio_group(
  #|  default_value="automatic",
  #|  name="forms-gallery-sync",
  #|  orientation=@ui.RadioVertical,
  #|  aria_label="Sync strategy",
  #|  scope => @html.div(
  #|    style=["display:flex;flex-direction:column;gap:1rem", "gap:0.625rem"],
  #|    [
  #|      @html.div(style=["display:flex;align-items:center;gap:0.625rem"], [
  #|        @ui.radio_group_item(
  #|          scope~,
  #|          value="automatic",
  #|          id="forms-gallery-sync-automatic",
  #|          aria_label="Automatic sync",
  #|        ),
  #|        @ui.label(for_="forms-gallery-sync-automatic", "Automatic"),
  #|      ]),
  #|      @html.div(style=["display:flex;align-items:center;gap:0.625rem"], [
  #|        @ui.radio_group_item(
  #|          scope~,
  #|          value="manual",
  #|          id="forms-gallery-sync-manual",
  #|          aria_label="Manual sync",
  #|        ),
  #|        @ui.label(for_="forms-gallery-sync-manual", "Manual"),
  #|      ]),
  #|    ],
  #|  ),
  #|)
  #|plan.view3(horizontal, vertical, (plan, horizontal_html, vertical_html) => {
  #|  let groups = @html.div(
  #|    style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,18rem),1fr));gap:1.25rem"],
  #|    [
  #|      @html.div(style=["display:flex;flex-direction:column;gap:1rem", "gap:0.625rem"], [
  #|        @html.div(style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], "Horizontal"),
  #|        horizontal_html,
  #|      ]),
  #|      @html.div(style=["display:flex;flex-direction:column;gap:1rem", "gap:0.625rem"], [
  #|        @html.div(style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], "Vertical"),
  #|        vertical_html,
  #|      ]),
  #|    ],
  #|  )
  #|  @html.div(
  #|    style=["display:flex;flex-direction:column;gap:1rem", "width:min(100%,50rem);margin-inline:auto"],
  #|    [
  #|      groups,
  #|      @html.output(
  #|        style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"],
  #|        "Billing value: \{plan}",
  #|      ),
  #|    ],
  #|  )
  #|})
  #|

///|
const FormsSliderCode : String =
  #|let (density_value, set_density) = @rabbita.create_variable(64)
  #|let density = @ui.slider(
  #|  id="forms-gallery-density",
  #|  default_value=64,
  #|  min=0,
  #|  max=100,
  #|  step=4,
  #|  aria_label="Interface density",
  #|  on_value_change=set_density.map(value => _ => value),
  #|)
  #|let range = @ui.slider_values(
  #|  id="forms-gallery-budget-range",
  #|  default_values=[28, 72],
  #|  min=0,
  #|  max=100,
  #|  step=4,
  #|  large_step=12,
  #|  min_steps_between_values=3,
  #|  aria_label="Budget range",
  #|)
  #|let vertical = @ui.slider(
  #|  id="forms-gallery-volume",
  #|  default_value=68,
  #|  orientation=@ui.Vertical,
  #|  aria_label="Preview volume",
  #|  style=["height:10rem"],
  #|)
  #|density_value.view4(density, range, vertical, (
  #|  density_value,
  #|  density_html,
  #|  range_html,
  #|  vertical_html,
  #|) => {
  #|  let controls = @html.div(
  #|    style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,18rem),1fr));gap:1.25rem"],
  #|    [
  #|      @html.div(
  #|        style=["min-width:0", "display:flex;flex-direction:column;gap:1rem"],
  #|        [
  #|          @html.div(style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], "Horizontal"),
  #|          density_html,
  #|        ],
  #|      ),
  #|      @html.div(
  #|        style=["min-width:0", "display:flex;flex-direction:column;gap:1rem"],
  #|        [
  #|          @html.div(
  #|            style=["display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem"],
  #|            [
  #|              @html.span(style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], "Range"),
  #|              @html.span(style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], "Two thumbs"),
  #|            ],
  #|          ),
  #|          range_html,
  #|        ],
  #|      ),
  #|      @html.div(
  #|        style=["min-width:0", "display:flex;flex-direction:column;gap:1rem", "align-items:center"],
  #|        [
  #|          @html.div(style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], "Vertical"),
  #|          vertical_html,
  #|        ],
  #|      ),
  #|    ],
  #|  )
  #|  @html.div(
  #|    style=["display:flex;flex-direction:column;gap:1rem", "width:min(100%,50rem);margin-inline:auto"],
  #|    [
  #|      @html.div(
  #|        style=["display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem"],
  #|        [
  #|          @ui.label(for_="forms-gallery-density", "Interface density"),
  #|          @html.output(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"],
  #|            "\{density_value}%",
  #|          ),
  #|        ],
  #|      ),
  #|      controls,
  #|    ],
  #|  )
  #|})
  #|

///|
fn forms_gallery() -> @rabbita.Val[@html.Html] {
  let (model, emit) = @rabbita.create_pure_state(
    {
      name: "Ada Lovelace",
      email: "ada@example.com",
      website: "analytical-engine",
      note: "Ship the first programmable workspace.",
      black_box_plan: "monthly",
      slider_value: 64,
      submitted: false,
    },
    update=forms_gallery_update,
  )
  let radio_horizontal_view = @ui.radio_group(
    default_value="monthly",
    name="forms-gallery-billing",
    orientation=@ui.RadioHorizontal,
    aria_label="Billing cycle",
    on_value_change=emit.map(value => FormsGalleryBlackBoxPlanChanged(value)),
    scope => {
      @html.div(style=[RowStyle], [
        @html.div(style=[FormsGalleryChoiceStyle], [
          @ui.radio_group_item(
            scope~,
            value="monthly",
            id="forms-gallery-monthly",
            aria_label="Monthly",
          ),
          @ui.label(for_="forms-gallery-monthly", "Monthly"),
        ]),
        @html.div(style=[FormsGalleryChoiceStyle], [
          @ui.radio_group_item(
            scope~,
            value="annual",
            id="forms-gallery-annual",
            aria_label="Annual",
          ),
          @ui.label(for_="forms-gallery-annual", "Annual"),
        ]),
      ])
    },
  )
  let radio_vertical_view = @ui.radio_group(
    default_value="automatic",
    name="forms-gallery-sync",
    orientation=@ui.RadioVertical,
    aria_label="Sync strategy",
    scope => {
      @html.div(style=[StackStyle, "gap:0.625rem"], [
        @html.div(style=[FormsGalleryChoiceStyle], [
          @ui.radio_group_item(
            scope~,
            value="automatic",
            id="forms-gallery-sync-automatic",
            aria_label="Automatic sync",
          ),
          @ui.label(for_="forms-gallery-sync-automatic", "Automatic"),
        ]),
        @html.div(style=[FormsGalleryChoiceStyle], [
          @ui.radio_group_item(
            scope~,
            value="manual",
            id="forms-gallery-sync-manual",
            aria_label="Manual sync",
          ),
          @ui.label(for_="forms-gallery-sync-manual", "Manual"),
        ]),
      ])
    },
  )
  let radio_view = radio_horizontal_view.view2(radio_vertical_view, (
    horizontal_html,
    vertical_html,
  ) => {
    @html.div(style=[FormsGalleryFormGridStyle], [
      @html.div(style=[StackStyle, "gap:0.625rem"], [
        @html.div(style=[MutedStyle], "Horizontal"),
        horizontal_html,
      ]),
      @html.div(style=[StackStyle, "gap:0.625rem"], [
        @html.div(style=[MutedStyle], "Vertical"),
        vertical_html,
      ]),
    ])
  })
  let calendar_view = calendar_showcase()
  let date_picker_view = date_picker_showcase()
  let dates_view = calendar_view.view2(date_picker_view, (
    calendar_html,
    date_picker_html,
  ) => @html.div(style=["display:contents"], [calendar_html, date_picker_html]))
  let density_slider_view = @ui.slider(
    id="forms-gallery-density",
    default_value=64,
    min=0,
    max=100,
    step=4,
    aria_label="Interface density",
    on_value_change=emit.map(value => FormsGallerySliderChanged(value)),
  )
  let range_slider_view = @ui.slider_values(
    id="forms-gallery-budget-range",
    default_values=[28, 72],
    min=0,
    max=100,
    step=4,
    large_step=12,
    min_steps_between_values=3,
    aria_label="Budget range",
  )
  let vertical_slider_view = @ui.slider(
    id="forms-gallery-volume",
    default_value=68,
    orientation=@ui.Vertical,
    aria_label="Preview volume",
    style=["height:10rem"],
  )
  let slider_view = density_slider_view.view3(
    range_slider_view,
    vertical_slider_view,
    (density_html, range_html, vertical_html) => {
      @html.div(style=[FormsGalleryFormGridStyle], [
        @html.div(style=[FormsGallerySpecimenStyle, StackStyle], [
          @html.div(style=[MutedStyle], "Horizontal"),
          density_html,
        ]),
        @html.div(style=[FormsGallerySpecimenStyle, StackStyle], [
          @html.div(style=[ControlRowStyle], [
            @html.span(style=[MutedStyle], "Range"),
            @html.span(style=[MutedStyle], "Two thumbs"),
          ]),
          range_html,
        ]),
        @html.div(
          style=[FormsGallerySpecimenStyle, StackStyle, "align-items:center"],
          [@html.div(style=[MutedStyle], "Vertical"), vertical_html],
        ),
      ])
    },
  )
  let core_view = model.view4(radio_view, dates_view, slider_view, (
    model,
    radio_html,
    dates_html,
    slider_html,
  ) => {
    let email_invalid = model.email == "invalid"
    let field_composition = @ui.form(
      id="forms-gallery-profile-form",
      name="workspace-profile",
      on_submit=emit(FormsGallerySubmitted),
      @ui.field_set([
        @ui.field_legend("Create a workspace"),
        @ui.field_group(style=[FormsGalleryFormGridStyle], [
          @ui.form_field(
            name="display-name",
            required=true,
            describedby="forms-gallery-name-description",
            [
              @ui.form_label(for_="forms-gallery-name", "Display name"),
              @ui.form_control(
                @ui.input(
                  id="forms-gallery-name",
                  name="display-name",
                  value=model.name,
                  required=true,
                  auto_complete=@html.On,
                  placeholder="Ada Lovelace",
                  on_input=emit.map(value => FormsGalleryNameChanged(value)),
                ),
              ),
              @ui.form_description(
                id="forms-gallery-name-description",
                "Shown to collaborators across the workspace.",
              ),
            ],
          ),
          @ui.form_field(
            name="email",
            invalid=email_invalid,
            required=true,
            describedby="forms-gallery-email-description",
            errormessage="forms-gallery-email-error",
            [
              @ui.form_label(for_="forms-gallery-email", "Email"),
              @ui.form_control(
                @ui.input(
                  input_type=@html.Email,
                  id="forms-gallery-email",
                  name="email",
                  value=model.email,
                  required=true,
                  invalid=email_invalid,
                  auto_complete=@html.On,
                  placeholder="ada@example.com",
                  on_input=emit.map(value => FormsGalleryEmailChanged(value)),
                ),
              ),
              @ui.form_description(
                id="forms-gallery-email-description",
                "Type “invalid” to preview the destructive state.",
              ),
              if email_invalid {
                @ui.form_message(
                  id="forms-gallery-email-error",
                  "Enter a valid email address.",
                )
              } else {
                @html.nothing
              },
            ],
          ),
          @ui.field([
            @ui.field_label(for_="forms-gallery-site", "Workspace URL"),
            @ui.input_group([
              @ui.input_group_addon(
                for_="forms-gallery-site",
                @ui.input_group_text("https://"),
              ),
              @ui.input_group_input(
                id="forms-gallery-site",
                name="workspace-url",
                value=model.website,
                placeholder="project-name",
                on_input=emit.map(value => FormsGalleryWebsiteChanged(value)),
              ),
              @ui.input_group_addon(
                align=@ui.InputInlineEnd,
                @ui.input_group_text(".moonbit.app"),
              ),
            ]),
            @ui.field_description(
              "Input Group keeps prefixes and suffixes on one control surface.",
            ),
          ]),
          @ui.field([
            @ui.field_label(for_="forms-gallery-note", "Launch note"),
            @ui.textarea(
              id="forms-gallery-note",
              name="launch-note",
              value=model.note,
              rows=4,
              placeholder="What should collaborators know?",
              on_input=emit.map(value => FormsGalleryNoteChanged(value)),
            ),
            @ui.field_description(
              "Textarea remains a native, parent-controlled value.",
            ),
          ]),
        ]),
        @html.div(style=[ControlRowStyle], [
          @html.output(
            style=[MutedStyle],
            if model.submitted {
              "Saved locally — submit default was prevented."
            } else {
              "Edit a field, then submit the native form."
            },
          ),
          @ui.button(type_="submit", "Save workspace"),
        ]),
      ]),
    )
    @html.section(id="forms-gallery", style=[FormsGallerySectionStyle], [
      @html.div(style=[FormsGalleryComponentsStyle], [
        showcase_component_demos(
          "Input",
          "Text, email, validation, and disabled variants use the native input while sharing the same control surface.",
          [
            showcase_demo_section(
              "Types and validation",
              "The enabled examples remain live; type “invalid” in the email field to reveal validation styling.",
              showcase_demo_stage(
                @html.div(style=[FormsVariantsGridStyle], [
                  forms_variant_item(
                    "Text",
                    "A parent-controlled text value.",
                    @ui.input(
                      id="forms-gallery-input-name",
                      name="standalone-display-name",
                      value=model.name,
                      placeholder="Ada Lovelace",
                      on_input=emit.map(value => FormsGalleryNameChanged(value)),
                    ),
                  ),
                  forms_variant_item(
                    "Email",
                    "Type “invalid” to preview the destructive state.",
                    @ui.input(
                      id="forms-gallery-input-email",
                      input_type=@html.Email,
                      value=model.email,
                      invalid=email_invalid,
                      placeholder="ada@example.com",
                      on_input=emit.map(value => FormsGalleryEmailChanged(value)),
                    ),
                  ),
                  forms_variant_item(
                    "Disabled",
                    "Inherited values stay readable but unavailable.",
                    @ui.input(
                      id="forms-gallery-input-disabled",
                      value="Inherited workspace",
                      disabled=true,
                    ),
                  ),
                ]),
                FormsInputCode,
                variant=ShowcaseStageSurface,
                stage_style="--rui-showcase-stage-min-height:16rem",
              ),
            ),
          ],
        ),
        showcase_component_demos(
          "Textarea",
          "Default, validation, and disabled variants preserve native multiline editing and resizing behavior.",
          [
            showcase_demo_section(
              "Validation and availability",
              "The default value remains editable while invalid and disabled variants expose their public styling.",
              showcase_demo_stage(
                @html.div(style=[FormsVariantsGridStyle], [
                  forms_variant_item(
                    "Default",
                    "A parent-controlled launch note.",
                    @ui.textarea(
                      id="forms-gallery-textarea-default",
                      value=model.note,
                      rows=4,
                      placeholder="What should collaborators know?",
                      on_input=emit.map(value => FormsGalleryNoteChanged(value)),
                    ),
                  ),
                  forms_variant_item(
                    "Invalid",
                    "Validation styling keeps the multiline input editable.",
                    @ui.textarea(
                      id="forms-gallery-textarea-invalid",
                      rows=4,
                      invalid=true,
                      placeholder="Explain what failed…",
                    ),
                  ),
                  forms_variant_item(
                    "Disabled",
                    "Managed copy remains readable.",
                    @ui.textarea(
                      id="forms-gallery-textarea-disabled",
                      rows=4,
                      value="Managed by your organization",
                      disabled=true,
                    ),
                  ),
                ]),
                FormsTextareaCode,
                variant=ShowcaseStagePlain,
                stage_style="--rui-showcase-stage-min-height:18rem",
              ),
            ),
          ],
        ),
        forms_field_variants(field_composition),
        showcase_component_demos(
          "Radio Group",
          "Horizontal and vertical orientations retain component-owned selection and native radio semantics.",
          [
            showcase_demo_section(
              "Orientations",
              "Choose a billing cycle horizontally or a sync strategy vertically.",
              showcase_demo_stage(
                @html.div(
                  style=[StackStyle, "width:min(100%,50rem);margin-inline:auto"],
                  [
                    radio_html,
                    @html.output(
                      style=[MutedStyle],
                      "Billing value: \{model.black_box_plan}",
                    ),
                  ],
                ),
                FormsRadioGroupCode,
                variant=ShowcaseStageSurface,
                stage_style="--rui-showcase-stage-min-height:17rem",
              ),
            ),
          ],
        ),
        showcase_component_demos(
          "Slider",
          "Horizontal, range, and vertical controls remain independently interactive.",
          [
            showcase_demo_section(
              "Values and orientations",
              "Use a single value, constrained range, or vertical orientation without moving state into the showcase.",
              showcase_demo_stage(
                @html.div(
                  style=[StackStyle, "width:min(100%,50rem);margin-inline:auto"],
                  [
                    @html.div(style=[ControlRowStyle], [
                      @ui.label(
                        for_="forms-gallery-density",
                        "Interface density",
                      ),
                      @html.output(style=[MutedStyle], "\{model.slider_value}%"),
                    ]),
                    slider_html,
                  ],
                ),
                FormsSliderCode,
                variant=ShowcaseStagePlain,
                stage_style="--rui-showcase-stage-min-height:21rem",
              ),
            ),
          ],
        ),
        dates_html,
      ]),
    ])
  })
  core_view
}
