///|
const CalendarShowcaseSingleCode : String =
  #|@ui.calendar(
  #|  id="forms-gallery-calendar-single",
  #|  default_month=@ui.calendar_date(year=2026, month=7, day=1),
  #|  default_selected=@ui.calendar_date(year=2026, month=7, day=15),
  #|  today=@ui.calendar_date(year=2026, month=7, day=16),
  #|  aria_label="Choose a launch date",
  #|  style=["margin-inline:auto"],
  #|)
  #|

///|
const CalendarShowcaseRangeCode : String =
  #|@ui.calendar_range(
  #|  id="forms-gallery-calendar-range",
  #|  default_month=@ui.calendar_date(year=2026, month=7, day=1),
  #|  default_selected=@ui.date_range(
  #|    start=@ui.calendar_date(year=2026, month=7, day=10),
  #|    end=@ui.calendar_date(year=2026, month=7, day=17),
  #|  ),
  #|  today=@ui.calendar_date(year=2026, month=7, day=16),
  #|  aria_label="Choose a release window",
  #|  style=["margin-inline:auto"],
  #|)
  #|

///|
const CalendarShowcaseMultipleCode : String =
  #|@ui.calendar_multiple(
  #|  id="forms-gallery-calendar-multiple",
  #|  default_month=@ui.calendar_date(year=2026, month=7, day=1),
  #|  default_selected=[
  #|    @ui.calendar_date(year=2026, month=7, day=8),
  #|    @ui.calendar_date(year=2026, month=7, day=16),
  #|    @ui.calendar_date(year=2026, month=7, day=23),
  #|  ],
  #|  today=@ui.calendar_date(year=2026, month=7, day=16),
  #|  aria_label="Choose available dates",
  #|  style=["margin-inline:auto"],
  #|)
  #|

///|
fn calendar_showcase() -> @rabbita.Val[@html.Html] {
  let today = @ui.calendar_date(year=2026, month=7, day=16)
  let single = @ui.calendar(
    id="forms-gallery-calendar-single",
    default_month=@ui.calendar_date(year=2026, month=7, day=1),
    default_selected=@ui.calendar_date(year=2026, month=7, day=15),
    today~,
    aria_label="Choose a launch date",
    style=["margin-inline:auto"],
  )
  let range = @ui.calendar_range(
    id="forms-gallery-calendar-range",
    default_month=@ui.calendar_date(year=2026, month=7, day=1),
    default_selected=@ui.date_range(
      start=@ui.calendar_date(year=2026, month=7, day=10),
      end=@ui.calendar_date(year=2026, month=7, day=17),
    ),
    today~,
    aria_label="Choose a release window",
    style=["margin-inline:auto"],
  )
  let multiple = @ui.calendar_multiple(
    id="forms-gallery-calendar-multiple",
    default_month=@ui.calendar_date(year=2026, month=7, day=1),
    default_selected=[
      @ui.calendar_date(year=2026, month=7, day=8),
      today,
      @ui.calendar_date(year=2026, month=7, day=23),
    ],
    today~,
    aria_label="Choose available dates",
    style=["margin-inline:auto"],
  )
  single.view3(range, multiple, (single, range, multiple) => {
    showcase_component_demos(
      "Calendar",
      "Single, range, and multiple selection keep month navigation, keyboard focus, and selected values inside the component.",
      [
        showcase_demo_section(
          "Single selection",
          "Choose one date while the calendar owns its visible month and selection.",
          showcase_demo_stage(
            single,
            CalendarShowcaseSingleCode,
            variant=ShowcaseStageSurface,
            tall=true,
          ),
        ),
        showcase_demo_section(
          "Range selection",
          "The first activation starts a range; the second completes and normalizes it.",
          showcase_demo_stage(
            range,
            CalendarShowcaseRangeCode,
            variant=ShowcaseStageSurface,
            tall=true,
          ),
        ),
        showcase_demo_section(
          "Multiple selection",
          "Toggle independent dates without moving the selection state into the showcase.",
          showcase_demo_stage(
            multiple,
            CalendarShowcaseMultipleCode,
            variant=ShowcaseStageSurface,
            tall=true,
          ),
        ),
      ],
    )
  })
}
