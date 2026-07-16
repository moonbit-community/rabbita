///|
const DatePickerShowcaseGridStyle : String = "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,19rem),1fr));align-items:start;gap:1.5rem 2rem"

///|
const DatePickerShowcaseGroupStyle : String = "display:flex;min-width:0;flex-direction:column;gap:0.625rem"

///|
const DatePickerShowcaseSingleCode : String =
  #|fn single_date_picker_demo() -> @rabbita.Val[@html.Html] {
  #|  let today = @ui.calendar_date(year=2026, month=7, day=16)
  #|  let picker = @ui.date_picker(
  #|    id="forms-gallery-date-picker-single",
  #|    default_value=today,
  #|    today~,
  #|    presets=[
  #|      @ui.date_picker_preset(label="Today", value=today),
  #|      @ui.date_picker_preset(
  #|        label="Tomorrow",
  #|        value=@ui.calendar_date(year=2026, month=7, day=17),
  #|      ),
  #|      @ui.date_picker_preset(
  #|        label="Next week",
  #|        value=@ui.calendar_date(year=2026, month=7, day=23),
  #|      ),
  #|      @ui.date_picker_preset(
  #|        label="Release",
  #|        value=@ui.calendar_date(year=2026, month=8, day=4),
  #|      ),
  #|    ],
  #|    trigger_style=["width:100%"],
  #|  )
  #|  picker.view(picker => {
  #|    @html.div(style=["width:min(100%,22rem);margin-inline:auto"], [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem"],
  #|        [
  #|          @ui.label(
  #|            for_="forms-gallery-date-picker-single-trigger",
  #|            "Release date",
  #|          ),
  #|          picker,
  #|        ],
  #|      ),
  #|    ])
  #|  })
  #|}
  #|

///|
const DatePickerShowcaseRangeCode : String =
  #|fn date_range_picker_demo() -> @rabbita.Val[@html.Html] {
  #|  let picker = @ui.date_range_picker(
  #|    id="forms-gallery-date-picker-range",
  #|    default_value=@ui.date_range(
  #|      start=@ui.calendar_date(year=2026, month=7, day=20),
  #|      end=@ui.calendar_date(year=2026, month=8, day=9),
  #|    ),
  #|    today=@ui.calendar_date(year=2026, month=7, day=16),
  #|    trigger_style=["width:100%"],
  #|  )
  #|  picker.view(picker => {
  #|    @html.div(style=["width:min(100%,22rem);margin-inline:auto"], [
  #|      @html.div(
  #|        style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem"],
  #|        [
  #|          @ui.label(
  #|            for_="forms-gallery-date-picker-range-trigger",
  #|            "Release window",
  #|          ),
  #|          picker,
  #|        ],
  #|      ),
  #|    ])
  #|  })
  #|}
  #|

///|
const DatePickerShowcaseStatesCode : String =
  #|fn date_picker_states_demo() -> @rabbita.Val[@html.Html] {
  #|  let disabled = @ui.date_picker(
  #|    id="forms-gallery-date-picker-disabled",
  #|    disabled=true,
  #|    placeholder="No dates available",
  #|    trigger_style=["width:100%"],
  #|  )
  #|  let invalid = @ui.date_picker(
  #|    id="forms-gallery-date-picker-invalid",
  #|    invalid=true,
  #|    placeholder="Required date",
  #|    trigger_style=["width:100%"],
  #|  )
  #|  disabled.view2(invalid, (disabled, invalid) => {
  #|    @html.div(
  #|      style=[
  #|        "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,19rem),1fr));align-items:start;gap:1.5rem 2rem",
  #|      ],
  #|      [
  #|        @html.div(
  #|          style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem"],
  #|          [
  #|            @ui.label(
  #|              for_="forms-gallery-date-picker-disabled-trigger",
  #|              "Disabled",
  #|            ),
  #|            disabled,
  #|          ],
  #|        ),
  #|        @html.div(
  #|          style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem"],
  #|          [
  #|            @ui.label(
  #|              for_="forms-gallery-date-picker-invalid-trigger",
  #|              "Invalid",
  #|            ),
  #|            invalid,
  #|          ],
  #|        ),
  #|      ],
  #|    )
  #|  })
  #|}
  #|

///|
fn date_picker_showcase_group(
  label : String,
  trigger_id : String,
  picker : @html.Html,
) -> @html.Html {
  @html.div(style=[DatePickerShowcaseGroupStyle], [
    @ui.label(for_=trigger_id, label),
    picker,
  ])
}

///|
fn date_picker_showcase() -> @rabbita.Val[@html.Html] {
  let today = @ui.calendar_date(year=2026, month=7, day=16)
  let single = @ui.date_picker(
    id="forms-gallery-date-picker-single",
    default_value=today,
    today~,
    presets=[
      @ui.date_picker_preset(label="Today", value=today),
      @ui.date_picker_preset(
        label="Tomorrow",
        value=@ui.calendar_date(year=2026, month=7, day=17),
      ),
      @ui.date_picker_preset(
        label="Next week",
        value=@ui.calendar_date(year=2026, month=7, day=23),
      ),
      @ui.date_picker_preset(
        label="Release",
        value=@ui.calendar_date(year=2026, month=8, day=4),
      ),
    ],
    trigger_style=["width:100%"],
  )
  let range = @ui.date_range_picker(
    id="forms-gallery-date-picker-range",
    default_value=@ui.date_range(
      start=@ui.calendar_date(year=2026, month=7, day=20),
      end=@ui.calendar_date(year=2026, month=8, day=9),
    ),
    today~,
    trigger_style=["width:100%"],
  )
  let disabled = @ui.date_picker(
    id="forms-gallery-date-picker-disabled",
    disabled=true,
    placeholder="No dates available",
    trigger_style=["width:100%"],
  )
  let invalid = @ui.date_picker(
    id="forms-gallery-date-picker-invalid",
    invalid=true,
    placeholder="Required date",
    trigger_style=["width:100%"],
  )
  single.view4(range, disabled, invalid, (single, range, disabled, invalid) => {
    showcase_component_demos(
      "Date Picker",
      "Single dates, presets, and ranges own their popup and calendar state. Disabled and invalid variants keep the same public API.",
      [
        showcase_demo_section(
          "Single date with presets",
          "Preset actions and the calendar share one component-owned value and popup.",
          showcase_demo_stage(
            @html.div(
              style=["width:min(100%,22rem);margin-inline:auto"],
              date_picker_showcase_group(
                "Release date", "forms-gallery-date-picker-single-trigger", single,
              ),
            ),
            DatePickerShowcaseSingleCode,
            tall=true,
          ),
        ),
        showcase_demo_section(
          "Date range",
          "Two activations produce a normalized start and end while the trigger remains black-box.",
          showcase_demo_stage(
            @html.div(
              style=["width:min(100%,22rem);margin-inline:auto"],
              date_picker_showcase_group(
                "Release window", "forms-gallery-date-picker-range-trigger", range,
              ),
            ),
            DatePickerShowcaseRangeCode,
            tall=true,
          ),
        ),
        showcase_demo_section(
          "Unavailable and invalid",
          "Disabled and validation treatments keep the same trigger geometry and semantics.",
          showcase_demo_stage(
            @html.div(style=[DatePickerShowcaseGridStyle], [
              date_picker_showcase_group(
                "Disabled", "forms-gallery-date-picker-disabled-trigger", disabled,
              ),
              date_picker_showcase_group(
                "Invalid", "forms-gallery-date-picker-invalid-trigger", invalid,
              ),
            ]),
            DatePickerShowcaseStatesCode,
            variant=ShowcaseStagePlain,
          ),
        ),
      ],
    )
  })
}
