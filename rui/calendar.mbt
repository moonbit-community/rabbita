///|
/// A normalized proleptic-Gregorian date used by `calendar`.
///
/// Construction is intentionally opaque so every value stays inside the
/// supported year range and always names a real day.
struct CalendarDate {
  year : Int
  month : Int
  day : Int
} derive(Debug, Eq)

///|
priv struct CalendarModel {
  visible : CalendarDate
  selected : CalendarDate?
  focused : CalendarDate
} derive(Eq)

///|
priv enum CalendarSelectionMode {
  CalendarSingleSelection
  CalendarRangeSelection
  CalendarMultipleSelection
}

///|
#cfg(target="js")
priv enum CalendarMsg {
  CalendarNavigate(Int)
  CalendarChoose(CalendarDate)
  CalendarSetFocused(CalendarDate)
  CalendarMoveFocus(CalendarDate)
}

///|
const CalendarRootStyle : String = "display:block;width:15.5rem;max-width:100%;border-radius:var(--rui-radius,0.625rem);background:var(--rui-background,oklch(1 0 0));padding:0.75rem;color:var(--rui-foreground,oklch(0.145 0 0));--rui-calendar-cell-radius:calc(var(--rui-radius,0.625rem) - 0.125rem)"

///|
const CalendarHeaderStyle : String = "position:relative;display:flex;height:2rem;width:100%;align-items:center;justify-content:center;margin-bottom:1rem"

///|
const CalendarCaptionStyle : String = "display:flex;height:2rem;align-items:center;justify-content:center;padding-inline:2rem;font-size:0.875rem;line-height:1.25rem;font-weight:500;user-select:none"

///|
const CalendarNavStyle : String = "position:absolute;inset:0;display:flex;align-items:center;justify-content:space-between;gap:0.25rem;pointer-events:none"

///|
const CalendarNavButtonStyle : String = "display:inline-flex;width:2rem;height:2rem;align-items:center;justify-content:center;--rui-calendar-base-bg:transparent;--rui-calendar-base-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-calendar-base-border:transparent;--rui-calendar-base-shadow:none;border:1px solid transparent;border-color:var(--rui-calendar-border,var(--rui-calendar-base-border,transparent));border-radius:calc(var(--rui-radius,0.625rem) - 0.25rem);margin:0;padding:0;background:var(--rui-calendar-bg,var(--rui-calendar-base-bg,transparent));color:var(--rui-calendar-fg,var(--rui-calendar-base-fg,var(--rui-foreground,oklch(0.145 0 0))));box-shadow:var(--rui-calendar-shadow,var(--rui-calendar-base-shadow,none));cursor:pointer;appearance:none;-webkit-appearance:none;pointer-events:auto;outline-offset:2px"

///|
const CalendarGridStyle : String = "width:100%;border-collapse:separate;border-spacing:0 0.5rem;table-layout:fixed;margin-block:-0.5rem"

///|
const CalendarWeekdayStyle : String = "width:2rem;height:2rem;padding:0;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.8rem;line-height:1rem;font-weight:400;text-align:center;vertical-align:middle;user-select:none"

///|
const CalendarCellStyle : String = "position:relative;width:2rem;height:2rem;padding:0;text-align:center;vertical-align:middle"

///|
const CalendarCellRangeStartStyle : String = "background:linear-gradient(var(--rui-calendar-range-start-direction,to right),transparent 50%,var(--rui-accent,oklch(0.97 0 0)) 50%)"

///|
const CalendarCellRangeMiddleStyle : String = "background:var(--rui-accent,oklch(0.97 0 0))"

///|
const CalendarCellRangeEndStyle : String = "background:linear-gradient(var(--rui-calendar-range-end-direction,to right),var(--rui-accent,oklch(0.97 0 0)) 50%,transparent 50%)"

///|
const CalendarCellRangeRowStartStyle : String = "border-start-start-radius:var(--rui-calendar-cell-radius);border-end-start-radius:var(--rui-calendar-cell-radius)"

///|
const CalendarCellRangeRowEndStyle : String = "border-start-end-radius:var(--rui-calendar-cell-radius);border-end-end-radius:var(--rui-calendar-cell-radius)"

///|
const CalendarDayStyle : String = "display:inline-flex;width:2rem;height:2rem;align-items:center;justify-content:center;--rui-calendar-base-bg:transparent;--rui-calendar-base-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-calendar-base-border:transparent;--rui-calendar-base-shadow:none;border:1px solid transparent;border-color:var(--rui-calendar-border,var(--rui-calendar-base-border,transparent));border-radius:var(--rui-calendar-cell-radius,calc(var(--rui-radius,0.625rem) - 0.125rem));margin:0;padding:0;background:var(--rui-calendar-bg,var(--rui-calendar-base-bg,transparent));color:var(--rui-calendar-fg,var(--rui-calendar-base-fg,var(--rui-foreground,oklch(0.145 0 0))));box-shadow:var(--rui-calendar-shadow,var(--rui-calendar-base-shadow,none));font-size:0.875rem;line-height:1rem;font-weight:400;text-align:center;cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline-offset:2px"

///|
const CalendarDaySelectedStyle : String = "--rui-calendar-base-border:var(--rui-primary,oklch(0.205 0 0));--rui-calendar-base-bg:var(--rui-primary,oklch(0.205 0 0));--rui-calendar-base-fg:var(--rui-primary-foreground,oklch(0.985 0 0))"

///|
const CalendarDayRangeMiddleStyle : String = "--rui-calendar-base-border:var(--rui-accent,oklch(0.97 0 0));--rui-calendar-base-bg:var(--rui-accent,oklch(0.97 0 0));--rui-calendar-base-fg:var(--rui-accent-foreground,oklch(0.205 0 0));border-radius:0"

///|
const CalendarDayTodayStyle : String = "--rui-calendar-base-bg:var(--rui-accent,oklch(0.97 0 0));--rui-calendar-base-fg:var(--rui-accent-foreground,oklch(0.205 0 0));font-weight:500"

///|
const CalendarDayOutsideStyle : String = "--rui-calendar-base-fg:var(--rui-muted-foreground,oklch(0.556 0 0));opacity:0.55"

///|
const CalendarOutsidePlaceholderStyle : String = "display:block;width:2rem;height:2rem;visibility:hidden"

///|
fn calendar_clamp(value : Int, minimum : Int, maximum : Int) -> Int {
  if value < minimum {
    minimum
  } else if value > maximum {
    maximum
  } else {
    value
  }
}

///|
fn calendar_is_leap_year(year : Int) -> Bool {
  year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)
}

///|
fn calendar_days_in_month(year : Int, month : Int) -> Int {
  match month {
    2 => if calendar_is_leap_year(year) { 29 } else { 28 }
    4 | 6 | 9 | 11 => 30
    _ => 31
  }
}

///|
fn calendar_first_of_month(date : CalendarDate) -> CalendarDate {
  { year: date.year, month: date.month, day: 1 }
}

///|
/// Construct a valid date. Years are clamped to `1..9999`, months to
/// `1..12`, and the day to the selected month's valid range.
pub fn calendar_date(year~ : Int, month~ : Int, day~ : Int) -> CalendarDate {
  let year = calendar_clamp(year, 1, 9999)
  let month = calendar_clamp(month, 1, 12)
  let day = calendar_clamp(day, 1, calendar_days_in_month(year, month))
  { year, month, day }
}

///|
pub fn CalendarDate::year(self : CalendarDate) -> Int {
  self.year
}

///|
pub fn CalendarDate::month(self : CalendarDate) -> Int {
  self.month
}

///|
pub fn CalendarDate::day(self : CalendarDate) -> Int {
  self.day
}

///|
fn calendar_pad_two(value : Int) -> String {
  if value < 10 {
    "0\{value}"
  } else {
    value.to_string()
  }
}

///|
fn calendar_pad_year(value : Int) -> String {
  if value < 10 {
    "000\{value}"
  } else if value < 100 {
    "00\{value}"
  } else if value < 1000 {
    "0\{value}"
  } else {
    value.to_string()
  }
}

///|
/// Return the stable `YYYY-MM-DD` representation used by data attributes.
pub fn CalendarDate::to_iso_string(self : CalendarDate) -> String {
  let year = calendar_pad_year(self.year)
  let month = calendar_pad_two(self.month)
  let day = calendar_pad_two(self.day)
  "\{year}-\{month}-\{day}"
}

///|
fn calendar_month_name(month : Int) -> String {
  match month {
    1 => "January"
    2 => "February"
    3 => "March"
    4 => "April"
    5 => "May"
    6 => "June"
    7 => "July"
    8 => "August"
    9 => "September"
    10 => "October"
    11 => "November"
    _ => "December"
  }
}

///|
fn calendar_weekday_short(weekday : Int) -> String {
  match weekday {
    0 => "Su"
    1 => "Mo"
    2 => "Tu"
    3 => "We"
    4 => "Th"
    5 => "Fr"
    _ => "Sa"
  }
}

///|
fn calendar_weekday_long(weekday : Int) -> String {
  match weekday {
    0 => "Sunday"
    1 => "Monday"
    2 => "Tuesday"
    3 => "Wednesday"
    4 => "Thursday"
    5 => "Friday"
    _ => "Saturday"
  }
}

///|
fn calendar_positive_mod(value : Int, divisor : Int) -> Int {
  let remainder = value % divisor
  if remainder < 0 {
    remainder + divisor
  } else {
    remainder
  }
}

///|
fn calendar_weekday(date : CalendarDate) -> Int {
  let month_offset = match date.month {
    1 => 0
    2 => 3
    3 => 2
    4 => 5
    5 => 0
    6 => 3
    7 => 5
    8 => 1
    9 => 4
    10 => 6
    11 => 2
    _ => 4
  }
  let year = if date.month < 3 { date.year - 1 } else { date.year }
  calendar_positive_mod(
    year + year / 4 - year / 100 + year / 400 + month_offset + date.day,
    7,
  )
}

///|
fn calendar_shift_month(date : CalendarDate, delta : Int) -> CalendarDate {
  if delta < 0 {
    if date.month == 1 {
      calendar_date(year=date.year - 1, month=12, day=1)
    } else {
      calendar_date(year=date.year, month=date.month - 1, day=1)
    }
  } else if date.month == 12 {
    calendar_date(year=date.year + 1, month=1, day=1)
  } else {
    calendar_date(year=date.year, month=date.month + 1, day=1)
  }
}

///|
fn calendar_same_month(left : CalendarDate, right : CalendarDate) -> Bool {
  left.year == right.year && left.month == right.month
}

///|
fn calendar_compare_dates(left : CalendarDate, right : CalendarDate) -> Int {
  if left.year != right.year {
    left.year.compare(right.year)
  } else if left.month != right.month {
    left.month.compare(right.month)
  } else {
    left.day.compare(right.day)
  }
}

///|
fn calendar_previous_day(date : CalendarDate) -> CalendarDate {
  if date.day > 1 {
    calendar_date(year=date.year, month=date.month, day=date.day - 1)
  } else if date.year == 1 && date.month == 1 {
    date
  } else {
    let previous = calendar_shift_month(date, -1)
    calendar_date(
      year=previous.year,
      month=previous.month,
      day=calendar_days_in_month(previous.year, previous.month),
    )
  }
}

///|
fn calendar_next_day(date : CalendarDate) -> CalendarDate {
  let last = calendar_days_in_month(date.year, date.month)
  if date.day < last {
    calendar_date(year=date.year, month=date.month, day=date.day + 1)
  } else if date.year == 9999 && date.month == 12 {
    date
  } else {
    calendar_shift_month(date, 1)
  }
}

///|
fn calendar_shift_days(date : CalendarDate, delta : Int) -> CalendarDate {
  let mut next = date
  let mut remaining = if delta < 0 { -delta } else { delta }
  while remaining > 0 {
    next = if delta < 0 {
      calendar_previous_day(next)
    } else {
      calendar_next_day(next)
    }
    remaining = remaining - 1
  }
  next
}

///|
fn calendar_shift_month_preserving_day(
  date : CalendarDate,
  delta : Int,
) -> CalendarDate {
  let shifted = calendar_shift_month(date, delta)
  calendar_date(year=shifted.year, month=shifted.month, day=date.day)
}

///|
fn calendar_shift_year(date : CalendarDate, delta : Int) -> CalendarDate {
  calendar_date(year=date.year + delta, month=date.month, day=date.day)
}

///|
fn calendar_cell_date(month : CalendarDate, cell : Int) -> (CalendarDate, Bool) {
  let first_weekday = calendar_weekday(calendar_first_of_month(month))
  let current_days = calendar_days_in_month(month.year, month.month)
  let day = cell - first_weekday + 1
  if day < 1 {
    let previous = calendar_shift_month(month, -1)
    let previous_days = calendar_days_in_month(previous.year, previous.month)
    (
      calendar_date(
        year=previous.year,
        month=previous.month,
        day=previous_days + day,
      ),
      true,
    )
  } else if day > current_days {
    let next = calendar_shift_month(month, 1)
    (
      calendar_date(year=next.year, month=next.month, day=day - current_days),
      true,
    )
  } else {
    (calendar_date(year=month.year, month=month.month, day~), false)
  }
}

///|
fn calendar_date_label(date : CalendarDate) -> String {
  let month = calendar_month_name(date.month)
  "\{month} \{date.day}, \{date.year}"
}

///|
fn calendar_initial_model(
  default_month : CalendarDate?,
  default_selected : CalendarDate?,
  today : CalendarDate?,
) -> CalendarModel {
  let visible = if default_month is Some(date) {
    calendar_first_of_month(date)
  } else if default_selected is Some(date) {
    calendar_first_of_month(date)
  } else if today is Some(date) {
    calendar_first_of_month(date)
  } else {
    calendar_date(year=1970, month=1, day=1)
  }
  let focused = calendar_focus_target(visible, default_selected, today)
  { visible, selected: default_selected, focused }
}

///|
fn calendar_focus_target(
  visible : CalendarDate,
  selected : CalendarDate?,
  today : CalendarDate?,
) -> CalendarDate {
  if selected is Some(date) && calendar_same_month(date, visible) {
    date
  } else if today is Some(date) && calendar_same_month(date, visible) {
    date
  } else {
    calendar_first_of_month(visible)
  }
}

///|
#cfg(target="js")
fn[T] calendar_emit_command(emit : @cmd.Emit[T]?, value : T) -> @cmd.Cmd {
  if emit is Some(emit) {
    emit(value)
  } else {
    @cmd.none
  }
}

///|
#cfg(target="js")
fn calendar_event_is_rtl(event : @dom.KeyboardEvent) -> Bool {
  if event.target().to_element() is Some(target) {
    ui_element_is_rtl(target)
  } else {
    false
  }
}

///|
#cfg(target="js")
fn focus_calendar_day(root_id : String, iso_date : String) -> Unit {
  let calendar_selector = "[data-slot=\"calendar\"]"
  let day_selector = "[data-slot=\"calendar-day-button\"]"
  fn is_calendar(root : @dom.Element) -> Bool {
    root.get_attribute("data-slot").unwrap_or("") == "calendar" &&
    root.get_is_connected()
  }

  fn days_in(root : @dom.Element) -> Array[@dom.Element] {
    root.query_selector_all(day_selector)
  }

  fn target_in(root : @dom.Element) -> @dom.Element? {
    for day in days_in(root) {
      if day.get_attribute("data-day").unwrap_or("") == iso_date &&
        ui_element_is_enabled(day) {
        return Some(day)
      }
    }
    None
  }

  fn focus_in(root : @dom.Element) -> Bool {
    let days = days_in(root)
    guard target_in(root) is Some(target) else { return false }
    for day in days {
      ui_set_element_tab_index(
        day,
        if day.is_same_node(target.as_node()) {
          0
        } else {
          -1
        },
      )
    }
    ui_focus_element(target)
    true
  }

  if root_id != "" {
    if ui_element_by_id(root_id) is Some(root) && is_calendar(root) {
      ignore(focus_in(root))
    }
    return
  }
  let document = @dom.document()
  if document.get_active_element() is Some(active) &&
    active.closest(calendar_selector) is Some(root) &&
    is_calendar(root) &&
    focus_in(root) {
    return
  }
  let matching : Array[@dom.Element] = []
  let roots = document.query_selector_all(calendar_selector)
  for index in 0..<roots.get_length().to_int() {
    if roots.item(index.to_double()).to_option() is Some(node) &&
      node.to_element() is Some(root) &&
      is_calendar(root) &&
      target_in(root) is Some(_) {
      matching.push(root)
    }
  }
  if matching.length() == 1 {
    ignore(focus_in(matching[0]))
  }
}

///|
#cfg(target="js")
fn calendar_focus_day_cmd(root_id : String?, date : CalendarDate) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, _ => {
    focus_calendar_day(root_id.unwrap_or(""), date.to_iso_string())
  })
}

///|
#cfg(not(target="js"))
fn calendar_focus_day_cmd(root_id : String?, date : CalendarDate) -> @cmd.Cmd {
  ignore((root_id, date))
  @cmd.none
}

///|
#cfg(target="js")
fn calendar_key_target(
  date : CalendarDate,
  event : @dom.KeyboardEvent,
) -> CalendarDate? {
  let key = event.key()
  let shift = event.shift_key()
  let rtl = calendar_event_is_rtl(event)
  match key {
    "ArrowLeft" =>
      Some(
        if shift {
          calendar_shift_month_preserving_day(date, if rtl { 1 } else { -1 })
        } else {
          calendar_shift_days(date, if rtl { 1 } else { -1 })
        },
      )
    "ArrowRight" =>
      Some(
        if shift {
          calendar_shift_month_preserving_day(date, if rtl { -1 } else { 1 })
        } else {
          calendar_shift_days(date, if rtl { -1 } else { 1 })
        },
      )
    "ArrowUp" =>
      Some(
        if shift {
          calendar_shift_year(date, -1)
        } else {
          calendar_shift_days(date, -7)
        },
      )
    "ArrowDown" =>
      Some(
        if shift {
          calendar_shift_year(date, 1)
        } else {
          calendar_shift_days(date, 7)
        },
      )
    "PageUp" =>
      Some(
        if shift {
          calendar_shift_year(date, -1)
        } else {
          calendar_shift_month_preserving_day(date, -1)
        },
      )
    "PageDown" =>
      Some(
        if shift {
          calendar_shift_year(date, 1)
        } else {
          calendar_shift_month_preserving_day(date, 1)
        },
      )
    "Home" => Some(calendar_shift_days(date, -calendar_weekday(date)))
    "End" => Some(calendar_shift_days(date, 6 - calendar_weekday(date)))
    _ => None
  }
}

///|
#cfg(target="js")
fn calendar_bind_day_interaction(
  attrs : @html.Attrs,
  root_id : String?,
  date : CalendarDate,
  focused : Bool,
  on_focus_change : @cmd.Emit[CalendarDate]?,
  on_focus_move : @cmd.Emit[CalendarDate]?,
) -> Unit {
  ignore(attrs.tabindex(if focused { 0 } else { -1 }))
  if on_focus_change is Some(emit) {
    ignore(attrs.on_focus(_ => emit(date)))
  }
  ignore(
    attrs.on_keydown(event => {
      if calendar_key_target(date, event) is Some(next) {
        event.prevent_default()
        event.stop_propagation()
        if on_focus_move is Some(emit) {
          @cmd.batch([emit(next), calendar_focus_day_cmd(root_id, next)])
        } else {
          calendar_focus_day_cmd(root_id, next)
        }
      } else {
        @cmd.none
      }
    }),
  )
}

///|
#cfg(not(target="js"))
fn calendar_bind_day_interaction(
  attrs : @html.Attrs,
  root_id : String?,
  date : CalendarDate,
  focused : Bool,
  on_focus_change : @cmd.Emit[CalendarDate]?,
  on_focus_move : @cmd.Emit[CalendarDate]?,
) -> Unit {
  ignore((root_id, date, on_focus_change, on_focus_move))
  ignore(attrs.tabindex(if focused { 0 } else { -1 }))
}

///|
fn calendar_nav_button(
  direction : String,
  label : String,
  disabled : Bool,
  command : @cmd.Cmd?,
  attrs : @html.Attrs?,
  style : Array[String],
) -> @html.Html {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "calendar-\{direction}")
    .data_set("direction", direction)
    .aria_label(label)
    .aria_disabled(ui_bool(disabled))
  if disabled {
    ignore(element_attrs.data_set("disabled", ""))
  } else if command is Some(command) {
    ignore(element_attrs.on_click(_ => command))
  }
  let chevron = if direction == "previous" {
    ui_chevron_left_icon()
  } else {
    ui_chevron_right_icon()
  }
  @html.button(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        CalendarNavButtonStyle,
        ui_disabled_style(disabled),
      ],
      style,
    ),
    type_="button",
    disabled~,
    attrs=element_attrs,
    chevron,
  )
}

///|
fn calendar_day_button_impl(
  root_id : String?,
  date~ : CalendarDate,
  selected? : Bool = false,
  multiple? : Bool = false,
  range_start? : Bool = false,
  range_end? : Bool = false,
  range_middle? : Bool = false,
  today? : Bool = false,
  outside? : Bool = false,
  disabled? : Bool = false,
  focused? : Bool = false,
  on_select? : @cmd.Emit[CalendarDate],
  on_focus_change? : @cmd.Emit[CalendarDate],
  on_focus_move? : @cmd.Emit[CalendarDate],
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let iso_date = date.to_iso_string()
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "calendar-day-button")
    .data_set("day", iso_date)
    .data_set("selected", ui_bool(selected))
    .data_set("outside", ui_bool(outside))
    .aria_label(calendar_date_label(date))
    .aria_selected(ui_bool(selected))
    .aria_disabled(ui_bool(disabled))
  if selected && !range_start && !range_end && !range_middle {
    if multiple {
      ignore(element_attrs.data_set("selected-multiple", ""))
    } else {
      ignore(element_attrs.data_set("selected-single", "true"))
    }
  }
  if range_start {
    ignore(element_attrs.data_set("range-start", ""))
  }
  if range_end {
    ignore(element_attrs.data_set("range-end", ""))
  }
  if range_middle {
    ignore(element_attrs.data_set("range-middle", ""))
  }
  if today {
    ignore(element_attrs.data_set("today", "").aria_current("date"))
  }
  if focused && !disabled {
    ignore(element_attrs.data_set("focused", ""))
  }
  if outside {
    ignore(element_attrs.data_set("outside-day", ""))
  }
  if disabled {
    ignore(element_attrs.data_set("disabled", ""))
  } else if on_select is Some(emit) {
    ignore(element_attrs.on_click(_ => emit(date)))
  }
  calendar_bind_day_interaction(
    element_attrs,
    root_id,
    date,
    focused && !disabled,
    if disabled {
      None
    } else {
      on_focus_change
    },
    if disabled {
      None
    } else {
      on_focus_move
    },
  )
  @html.button(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        CalendarDayStyle,
        if outside {
          CalendarDayOutsideStyle
        } else {
          ""
        },
        if today && !selected {
          CalendarDayTodayStyle
        } else {
          ""
        },
        if selected {
          if range_middle {
            CalendarDayRangeMiddleStyle
          } else {
            CalendarDaySelectedStyle
          }
        } else {
          ""
        },
        ui_disabled_style(disabled),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    type_="button",
    disabled~,
    attrs=element_attrs,
    date.day.to_string(),
  )
}

///|
/// Render the native day button used by the Calendar state renderer.
///
/// Dates remain native buttons while the component supplies the roving tab
/// stop and DayPicker-compatible arrow, Home/End, and PageUp/PageDown movement.
pub fn calendar_day_button(
  date~ : CalendarDate,
  selected? : Bool = false,
  today? : Bool = false,
  outside? : Bool = false,
  disabled? : Bool = false,
  focused? : Bool = false,
  on_select? : @cmd.Emit[CalendarDate],
  on_focus_change? : @cmd.Emit[CalendarDate],
  on_focus_move? : @cmd.Emit[CalendarDate],
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  calendar_day_button_impl(
    None,
    date~,
    selected~,
    multiple=false,
    range_start=false,
    range_end=false,
    range_middle=false,
    today~,
    outside~,
    disabled~,
    focused~,
    on_select?,
    on_focus_change?,
    on_focus_move?,
    id?,
    class?,
    title?,
    attrs?,
    style~,
  )
}

///|
fn calendar_weekday_header(weekday : Int, style : Array[String]) -> @html.Html {
  @html.th(
    style=ui_styles([UiBoxSizing, CalendarWeekdayStyle], style),
    abbr=calendar_weekday_long(weekday),
    scope=Col,
    attrs=@html.Attrs::build()
      .data_set("slot", "calendar-weekday")
      .data_set("weekday", weekday.to_string()),
    calendar_weekday_short(weekday),
  )
}

///|
fn calendar_day_cell(
  root_id : String?,
  month : CalendarDate,
  cell : Int,
  selection_mode : CalendarSelectionMode,
  selected_date : CalendarDate?,
  selected_dates : Array[CalendarDate]?,
  range_start : CalendarDate?,
  range_end : CalendarDate?,
  today_date : CalendarDate?,
  focused_date : CalendarDate,
  show_outside_days : Bool,
  hide_outside_before : Bool,
  hide_outside_after : Bool,
  disabled : Bool,
  on_select : @cmd.Emit[CalendarDate]?,
  on_focus_change : @cmd.Emit[CalendarDate]?,
  on_focus_move : @cmd.Emit[CalendarDate]?,
  day_attrs : @html.Attrs?,
  cell_style : Array[String],
  day_style : Array[String],
) -> @html.Html {
  let (date, outside) = calendar_cell_date(month, cell)
  let outside_before = outside && calendar_compare_dates(date, month) < 0
  let outside_visible = show_outside_days &&
    !(outside_before && hide_outside_before) &&
    !(!outside_before && outside && hide_outside_after)
  let date_visible = !outside || outside_visible
  let is_range_start = date_visible && range_start == Some(date)
  let is_range_end = date_visible && range_end == Some(date)
  let is_range_middle = date_visible &&
    (if range_start is Some(start) && range_end is Some(end) {
      calendar_compare_dates(date, start) > 0 &&
      calendar_compare_dates(date, end) < 0
    } else {
      false
    })
  let is_multiple_selected = if selected_dates is Some(dates) {
    calendar_contains_date(dates, date)
  } else {
    false
  }
  let is_selected = date_visible &&
    (
      selected_date == Some(date) ||
      is_multiple_selected ||
      is_range_start ||
      is_range_end ||
      is_range_middle
    )
  let is_today = today_date == Some(date)
  let is_focused = focused_date == date
  let cell_attrs = @html.Attrs::build()
    .data_set("slot", "calendar-day")
    .data_set("outside", ui_bool(outside))
    .data_set("selected", ui_bool(is_selected))
  if is_range_start {
    ignore(cell_attrs.data_set("range-start", ""))
  }
  if is_range_end {
    ignore(cell_attrs.data_set("range-end", ""))
  }
  if is_range_middle {
    ignore(cell_attrs.data_set("range-middle", ""))
  }
  let range_cell_style = if is_range_middle {
    if cell % 7 == 0 {
      CalendarCellRangeMiddleStyle + ";" + CalendarCellRangeRowStartStyle
    } else if cell % 7 == 6 {
      CalendarCellRangeMiddleStyle + ";" + CalendarCellRangeRowEndStyle
    } else {
      CalendarCellRangeMiddleStyle
    }
  } else if is_range_start && !is_range_end && range_end is Some(_) {
    CalendarCellRangeStartStyle
  } else if is_range_end && !is_range_start {
    CalendarCellRangeEndStyle
  } else {
    ""
  }
  @html.td(
    style=ui_styles(
      [UiBoxSizing, CalendarCellStyle, range_cell_style],
      cell_style,
    ),
    attrs=cell_attrs,
    if outside && !outside_visible {
      @html.span(
        style=[UiBoxSizing, CalendarOutsidePlaceholderStyle],
        attrs=@html.Attrs::build().aria_hidden("true"),
        @html.nothing,
      )
    } else {
      let attrs = day_attrs
      calendar_day_button_impl(
        root_id,
        date~,
        selected=is_selected,
        multiple=selection_mode is CalendarMultipleSelection,
        range_start=is_range_start,
        range_end=is_range_end,
        range_middle=is_range_middle,
        today=is_today,
        outside~,
        disabled~,
        focused=is_focused,
        on_select?,
        on_focus_change?,
        on_focus_move?,
        attrs?,
        style=day_style,
      )
    },
  )
}

///|
/// Render one fully composed Calendar state for the incremental wrapper.
///
/// The table and button semantics work without a client runtime. `attrs` and
/// every part-level attribute set are cloned before component data is added.
fn render_calendar(
  month~ : CalendarDate,
  selection_mode? : CalendarSelectionMode = CalendarSingleSelection,
  selected? : CalendarDate,
  selected_dates? : Array[CalendarDate],
  range_start? : CalendarDate,
  range_end? : CalendarDate,
  today? : CalendarDate,
  focused? : CalendarDate,
  show_outside_days? : Bool = true,
  hide_outside_before? : Bool = false,
  hide_outside_after? : Bool = false,
  disabled? : Bool = false,
  aria_label? : String = "Calendar",
  on_previous? : @cmd.Cmd,
  on_next? : @cmd.Cmd,
  on_select? : @cmd.Emit[CalendarDate],
  on_focus_change? : @cmd.Emit[CalendarDate],
  on_focus_move? : @cmd.Emit[CalendarDate],
  show_previous? : Bool = true,
  show_next? : Bool = true,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  previous_attrs? : @html.Attrs,
  next_attrs? : @html.Attrs,
  grid_attrs? : @html.Attrs,
  day_attrs? : @html.Attrs,
  style? : Array[String] = [],
  header_style? : Array[String] = [],
  caption_style? : Array[String] = [],
  nav_style? : Array[String] = [],
  previous_style? : Array[String] = [],
  next_style? : Array[String] = [],
  grid_style? : Array[String] = [],
  weekday_style? : Array[String] = [],
  cell_style? : Array[String] = [],
  day_style? : Array[String] = [],
) -> @html.Html {
  let month = calendar_first_of_month(month)
  let focused = focused.unwrap_or(calendar_focus_target(month, selected, today))
  let caption = "\{calendar_month_name(month.month)} \{month.year}"
  let caption_id = id.map(id => "\{id}-caption")
  let previous_disabled = disabled || (month.year == 1 && month.month == 1)
  let next_disabled = disabled || (month.year == 9999 && month.month == 12)
  let root_attrs = ui_attrs(attrs)
    .data_set("slot", "calendar")
    .data_set("mode", calendar_selection_mode_name(selection_mode))
    .data_set("month", month.to_iso_string())
    .role("group")
    .aria_label(aria_label)
    .aria_disabled(ui_bool(disabled))
  if range_start is Some(start) {
    ignore(root_attrs.data_set("range-start", start.to_iso_string()))
  }
  if range_end is Some(end) {
    ignore(root_attrs.data_set("range-end", end.to_iso_string()))
  }
  if selected_dates is Some(dates) {
    ignore(root_attrs.data_set("selected-count", dates.length().to_string()))
  }
  if disabled {
    ignore(root_attrs.data_set("disabled", ""))
  }
  let table_attrs = ui_attrs(grid_attrs)
    .data_set("slot", "calendar-grid")
    .role("grid")
  if selection_mode is CalendarRangeSelection ||
    selection_mode is CalendarMultipleSelection {
    ignore(table_attrs.aria_multiselectable("true"))
  }
  if caption_id is Some(caption_id) {
    ignore(table_attrs.aria_labelledby(caption_id))
  } else {
    ignore(table_attrs.aria_label(caption))
  }
  let weekdays = Array::makei(7, weekday => {
    calendar_weekday_header(weekday, weekday_style)
  })
  let weeks = Array::makei(6, week => {
    let days = Array::makei(7, weekday => {
      calendar_day_cell(
        id,
        month,
        week * 7 + weekday,
        selection_mode,
        selected,
        selected_dates,
        range_start,
        range_end,
        today,
        focused,
        show_outside_days,
        hide_outside_before,
        hide_outside_after,
        disabled,
        on_select,
        on_focus_change,
        on_focus_move,
        day_attrs,
        cell_style,
        day_style,
      )
    })
    @html.tr(
      attrs=@html.Attrs::build()
        .data_set("slot", "calendar-week")
        .data_set("week", week.to_string()),
      days,
    )
  })
  let caption_node = {
    let id = caption_id
    @html.span(
      style=ui_styles([UiBoxSizing, CalendarCaptionStyle], caption_style),
      id?,
      attrs=@html.Attrs::build().data_set("slot", "calendar-caption"),
      caption,
    )
  }
  let nav_items : Array[@html.Html] = []
  if show_previous {
    nav_items.push(
      calendar_nav_button(
        "previous", "Go to previous month", previous_disabled, on_previous, previous_attrs,
        previous_style,
      ),
    )
  }
  if show_next {
    nav_items.push(
      calendar_nav_button(
        "next", "Go to next month", next_disabled, on_next, next_attrs, next_style,
      ),
    )
  }
  @html.div(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, CalendarRootStyle],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=root_attrs,
    [
      @html.div(
        style=ui_styles([UiBoxSizing, CalendarHeaderStyle], header_style),
        attrs=@html.Attrs::build().data_set("slot", "calendar-header"),
        [
          caption_node,
          @html.div(
            style=ui_styles([UiBoxSizing, CalendarNavStyle], nav_style),
            attrs=@html.Attrs::build()
              .data_set("slot", "calendar-nav")
              .aria_label("Month navigation"),
            nav_items,
          ),
        ],
      ),
      @html.table(
        style=ui_styles([UiBoxSizing, CalendarGridStyle], grid_style),
        attrs=table_attrs,
        [@html.thead(@html.tr(weekdays)), @html.tbody(weeks)],
      ),
    ],
  )
}

///|
#cfg(target="js")
fn calendar_update(
  root_id : String?,
  on_select : @cmd.Emit[CalendarDate]?,
  on_month_change : @cmd.Emit[CalendarDate]?,
  today : CalendarDate?,
  msg : CalendarMsg,
  model : CalendarModel,
) -> (CalendarModel, @cmd.Cmd) {
  match msg {
    CalendarNavigate(delta) => {
      let visible = calendar_shift_month(model.visible, delta)
      let focused = calendar_focus_target(visible, model.selected, today)
      (
        { ..model, visible, focused },
        calendar_emit_command(on_month_change, visible),
      )
    }
    CalendarChoose(date) => {
      let visible = calendar_first_of_month(date)
      let commands : Array[@cmd.Cmd] = [calendar_emit_command(on_select, date)]
      if visible != model.visible {
        commands.push(calendar_emit_command(on_month_change, visible))
      }
      ({ visible, selected: Some(date), focused: date }, @cmd.batch(commands))
    }
    CalendarSetFocused(date) => ({ ..model, focused: date }, @cmd.none)
    CalendarMoveFocus(date) => {
      let visible = calendar_first_of_month(date)
      let commands : Array[@cmd.Cmd] = [calendar_focus_day_cmd(root_id, date)]
      if visible != model.visible {
        commands.push(calendar_emit_command(on_month_change, visible))
      }
      ({ ..model, visible, focused: date }, @cmd.batch(commands))
    }
  }
}

///|
/// Stateful single-date calendar with Rabbita-owned visible-month and
/// selection state.
///
/// When no initial month, selected date, or `today` is supplied, the stable
/// SSR fallback is January 1970. Supplying `today` both selects the initial
/// visible month and enables the current-day treatment.
#cfg(target="js")
pub fn calendar(
  default_month? : CalendarDate,
  default_selected? : CalendarDate,
  today? : CalendarDate,
  show_outside_days? : Bool = true,
  disabled? : Bool = false,
  aria_label? : String = "Calendar",
  on_select? : @cmd.Emit[CalendarDate],
  on_month_change? : @cmd.Emit[CalendarDate],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  previous_attrs? : @html.Attrs,
  next_attrs? : @html.Attrs,
  grid_attrs? : @html.Attrs,
  day_attrs? : @html.Attrs,
  style? : Array[String] = [],
  header_style? : Array[String] = [],
  caption_style? : Array[String] = [],
  nav_style? : Array[String] = [],
  previous_style? : Array[String] = [],
  next_style? : Array[String] = [],
  grid_style? : Array[String] = [],
  weekday_style? : Array[String] = [],
  cell_style? : Array[String] = [],
  day_style? : Array[String] = [],
) -> @rabbita.Val[@html.Html] {
  let initial = calendar_initial_model(default_month, default_selected, today)
  let (model, emit) = @rabbita.create_state(initial, update=fn(model, msg, _) {
    calendar_update(id, on_select, on_month_change, today, msg, model)
  })
  let select = emit.map(date => CalendarChoose(date))
  let set_focused = emit.map(date => CalendarSetFocused(date))
  let move_focus = emit.map(date => CalendarMoveFocus(date))
  model.view(model => {
    let selected = model.selected
    render_calendar(
      month=model.visible,
      selected?,
      today?,
      focused=model.focused,
      show_outside_days~,
      disabled~,
      aria_label~,
      on_previous=emit(CalendarNavigate(-1)),
      on_next=emit(CalendarNavigate(1)),
      on_select=select,
      on_focus_change=set_focused,
      on_focus_move=move_focus,
      id?,
      class?,
      title?,
      hidden?,
      attrs?,
      previous_attrs?,
      next_attrs?,
      grid_attrs?,
      day_attrs?,
      style~,
      header_style~,
      caption_style~,
      nav_style~,
      previous_style~,
      next_style~,
      grid_style~,
      weekday_style~,
      cell_style~,
      day_style~,
    )
  })
}

///|
/// Native/SSR fallback for `calendar`; renders the same requested initial
/// month and selection as a constant incremental value.
#cfg(not(target="js"))
pub fn calendar(
  default_month? : CalendarDate,
  default_selected? : CalendarDate,
  today? : CalendarDate,
  show_outside_days? : Bool = true,
  disabled? : Bool = false,
  aria_label? : String = "Calendar",
  on_select? : @cmd.Emit[CalendarDate],
  on_month_change? : @cmd.Emit[CalendarDate],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  previous_attrs? : @html.Attrs,
  next_attrs? : @html.Attrs,
  grid_attrs? : @html.Attrs,
  day_attrs? : @html.Attrs,
  style? : Array[String] = [],
  header_style? : Array[String] = [],
  caption_style? : Array[String] = [],
  nav_style? : Array[String] = [],
  previous_style? : Array[String] = [],
  next_style? : Array[String] = [],
  grid_style? : Array[String] = [],
  weekday_style? : Array[String] = [],
  cell_style? : Array[String] = [],
  day_style? : Array[String] = [],
) -> @rabbita.Val[@html.Html] {
  ignore((on_select, on_month_change))
  let model = calendar_initial_model(default_month, default_selected, today)
  let select : @cmd.Emit[CalendarDate] = Emit(_ => @cmd.none)
  let selected = model.selected
  @rabbita.Val::constant(
    render_calendar(
      month=model.visible,
      selected?,
      today?,
      focused=model.focused,
      show_outside_days~,
      disabled~,
      aria_label~,
      on_previous=@cmd.none,
      on_next=@cmd.none,
      on_select=select,
      id?,
      class?,
      title?,
      hidden?,
      attrs?,
      previous_attrs?,
      next_attrs?,
      grid_attrs?,
      day_attrs?,
      style~,
      header_style~,
      caption_style~,
      nav_style~,
      previous_style~,
      next_style~,
      grid_style~,
      weekday_style~,
      cell_style~,
      day_style~,
    ),
  )
}
