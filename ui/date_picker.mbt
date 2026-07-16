///|
/// A caller-defined quick choice rendered inside [`date_picker`].
struct DatePickerPreset {
  label : String
  value : CalendarDate
} derive(Debug, Eq)

///|
pub fn date_picker_preset(
  label~ : String,
  value~ : CalendarDate,
) -> DatePickerPreset {
  { label, value }
}

///|
/// An opaque range value. `end()` is `None` while the user is choosing the
/// second boundary.
struct DateRange {
  start : CalendarDate
  end : CalendarDate?
} derive(Debug, Eq)

///|
/// Construct a normalized date range. If `end` precedes `start`, the two
/// boundaries are exchanged.
pub fn date_range(start~ : CalendarDate, end? : CalendarDate) -> DateRange {
  if end is Some(end) && calendar_compare_dates(end, start) < 0 {
    { start: end, end: Some(start) }
  } else {
    { start, end }
  }
}

///|
pub fn DateRange::start(self : DateRange) -> CalendarDate {
  self.start
}

///|
pub fn DateRange::end(self : DateRange) -> CalendarDate? {
  self.end
}

///|
priv struct DatePickerModel {
  open : Bool
  visible : CalendarDate
  value : CalendarDate?
  focused : CalendarDate
} derive(Eq)

///|
priv struct DateRangePickerModel {
  open : Bool
  visible : CalendarDate
  value : DateRange?
  focused : CalendarDate
} derive(Eq)

///|
#cfg(target="js")
priv enum DatePickerMsg {
  DatePickerToggle
  DatePickerNativeChanged(Bool)
  DatePickerNavigate(Int)
  DatePickerChoose(CalendarDate)
  DatePickerSetFocused(CalendarDate)
  DatePickerMoveFocus(CalendarDate)
}

///|
#cfg(target="js")
priv enum DateRangePickerMsg {
  DateRangePickerToggle
  DateRangePickerNativeChanged(Bool)
  DateRangePickerNavigate(Int)
  DateRangePickerChoose(CalendarDate)
  DateRangePickerSetFocused(CalendarDate)
  DateRangePickerMoveFocus(CalendarDate)
}

///|
const DatePickerRootStyle : String = "position:relative;display:inline-flex;width:fit-content;max-width:100%;min-width:0"

///|
const DatePickerTriggerStyle : String = "width:17.5rem;max-width:100%;justify-content:flex-start;gap:0.5rem;font-weight:400;text-align:left"

///|
const DatePickerTriggerLabelStyle : String = "min-width:0;flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"

///|
const DatePickerPlaceholderStyle : String = "color:var(--rui-muted-foreground,oklch(0.556 0 0))"

///|
const DatePickerContentStyle : String = "width:15.5rem;min-width:0;max-width:calc(100vw - 1rem);gap:0;overflow:hidden;padding:0;box-shadow:0 4px 6px -1px rgb(0 0 0 / 0.1),0 2px 4px -2px rgb(0 0 0 / 0.1),0 0 0 1px color-mix(in oklab,var(--rui-foreground,oklch(0.145 0 0)) 10%,transparent)"

///|
const DateRangePickerContentStyle : String = "width:var(--rui-date-range-picker-width,32rem);min-width:0;max-width:calc(100vw - 1rem);max-height:var(--rui-date-range-picker-max-height,none);position-try-order:most-height;gap:0;overflow-x:hidden;overflow-y:var(--rui-date-range-picker-overflow-y,hidden);padding:0;box-shadow:0 4px 6px -1px rgb(0 0 0 / 0.1),0 2px 4px -2px rgb(0 0 0 / 0.1),0 0 0 1px color-mix(in oklab,var(--rui-foreground,oklch(0.145 0 0)) 10%,transparent)"

///|
const DatePickerContentInnerStyle : String = "display:flex;min-width:0;flex-direction:column"

///|
const DateRangePickerContentInnerStyle : String = "display:flex;width:100%;min-width:0;max-width:100%;flex-wrap:wrap;align-items:flex-start;justify-content:center;gap:1rem"

///|
const DatePickerPresetsStyle : String = "display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:0.25rem;border-bottom:1px solid var(--rui-border,oklch(0.922 0 0));padding:0.5rem"

///|
const DatePickerPresetStyle : String = "width:100%;justify-content:flex-start"

///|
const DatePickerCalendarStyle : String = "width:15.5rem;min-width:0;max-width:100%;border-radius:0"

///|
const DateRangePickerCalendarStyle : String = "width:15.5rem;min-width:0;max-width:100%;flex:0 1 15.5rem;border-radius:0"

///|
fn date_picker_part_styles(
  base : String,
  overrides : Array[String],
) -> Array[String] {
  let styles = [base]
  for custom_style in overrides {
    styles.push(custom_style)
  }
  styles
}

///|
fn date_picker_initial_model(
  default_open : Bool,
  disabled : Bool,
  default_month : CalendarDate?,
  default_value : CalendarDate?,
  today : CalendarDate?,
) -> DatePickerModel {
  let calendar = calendar_initial_model(default_month, default_value, today)
  {
    open: default_open && !disabled,
    visible: calendar.visible,
    value: default_value,
    focused: calendar.focused,
  }
}

///|
fn date_range_picker_initial_model(
  default_open : Bool,
  disabled : Bool,
  default_month : CalendarDate?,
  default_value : DateRange?,
  today : CalendarDate?,
) -> DateRangePickerModel {
  let selected = default_value.map(value => value.start)
  let calendar = calendar_initial_model(default_month, selected, today)
  {
    open: default_open && !disabled,
    visible: calendar.visible,
    value: default_value,
    focused: calendar.focused,
  }
}

///|
fn date_picker_label(
  value : CalendarDate?,
  placeholder : String,
  format_value : ((CalendarDate) -> String)?,
) -> String {
  if value is Some(value) {
    if format_value is Some(format) {
      format(value)
    } else {
      calendar_date_label(value)
    }
  } else {
    placeholder
  }
}

///|
fn date_range_picker_default_label(value : DateRange) -> String {
  let start = calendar_date_label(value.start)
  if value.end is Some(end) {
    "\{start} – \{calendar_date_label(end)}"
  } else {
    start
  }
}

///|
fn date_range_picker_label(
  value : DateRange?,
  placeholder : String,
  format_value : ((DateRange) -> String)?,
) -> String {
  if value is Some(value) {
    if format_value is Some(format) {
      format(value)
    } else {
      date_range_picker_default_label(value)
    }
  } else {
    placeholder
  }
}

///|
fn date_picker_trigger(
  id : String,
  open : Bool,
  has_value : Bool,
  disabled : Bool,
  invalid : Bool,
  aria_label : String?,
  label : String,
  on_toggle : @cmd.Cmd?,
  attrs : @html.Attrs?,
  style : Array[String],
) -> @html.Html {
  let trigger_id = "\{id}-trigger"
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "date-picker-trigger")
    .data_set("variant", "outline")
    .data_set("size", "default")
    .data_set("state", if open { "open" } else { "closed" })
    .data_set("placeholder", ui_bool(!has_value))
    .aria_haspopup("dialog")
    .aria_expanded(ui_bool(open))
    .aria_controls(id)
    .aria_disabled(ui_bool(disabled))
  if aria_label is Some(aria_label) {
    ignore(element_attrs.aria_label(aria_label))
  }
  if open {
    ignore(element_attrs.data_set("open", ""))
  }
  if disabled {
    ignore(element_attrs.data_set("disabled", ""))
  } else if on_toggle is Some(command) {
    ignore(element_attrs.on_click_after(_ => command))
  }
  if invalid {
    ignore(element_attrs.data_set("invalid", "").aria_invalid("true"))
  }
  @html.button(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        ButtonBaseStyle,
        button_variant_style(Outline),
        button_size_style(Default),
        DatePickerTriggerStyle,
        if invalid {
          InputInvalidStyle
        } else {
          ""
        },
        ui_disabled_style(disabled),
        popup_anchor_style(trigger_id),
      ],
      style,
    ),
    id=trigger_id,
    type_="button",
    disabled~,
    attrs=element_attrs,
    [
      ui_calendar_icon(),
      @html.span(
        style=ui_styles(
          [
            UiBoxSizing,
            DatePickerTriggerLabelStyle,
            if has_value {
              ""
            } else {
              DatePickerPlaceholderStyle
            },
          ],
          [],
        ),
        label,
      ),
    ],
  )
}

///|
fn date_picker_presets(
  presets : Array[DatePickerPreset],
  disabled : Bool,
  choose : @cmd.Emit[CalendarDate]?,
  style : Array[String],
) -> @html.Html {
  if presets.length() == 0 {
    @html.nothing
  } else {
    let items = presets.map(preset => {
      let command = choose.map(choose => choose(preset.value))
      button(
        variant=Ghost,
        size=Sm,
        disabled~,
        on_click?=command,
        attrs=@html.Attrs::build().data_set(
          "preset-value",
          preset.value.to_iso_string(),
        ),
        style=date_picker_part_styles(DatePickerPresetStyle, style),
        slot="date-picker-preset",
        preset.label,
      )
    })
    @html.div(
      style=[UiBoxSizing, DatePickerPresetsStyle],
      attrs=@html.Attrs::build()
        .data_set("slot", "date-picker-presets")
        .aria_label("Date presets"),
      items,
    )
  }
}

///|
fn date_picker_root_attrs(
  attrs : @html.Attrs?,
  slot : String,
  open : Bool,
  disabled : Bool,
  invalid : Bool,
) -> @html.Attrs {
  let root_attrs = ui_attrs(attrs)
    .data_set("slot", slot)
    .data_set("state", if open { "open" } else { "closed" })
    .data_set("disabled", ui_bool(disabled))
    .data_set("invalid", ui_bool(invalid))
  if open {
    ignore(root_attrs.data_set("open", ""))
  }
  root_attrs
}

///|
fn render_date_picker(
  id : String,
  model : DatePickerModel,
  today : CalendarDate?,
  show_outside_days : Bool,
  placeholder : String,
  disabled : Bool,
  invalid : Bool,
  aria_label : String?,
  side : PopupSide,
  align : PopupAlign,
  side_offset : Int,
  align_offset : Int,
  presets : Array[DatePickerPreset],
  format_value : ((CalendarDate) -> String)?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  trigger_attrs : @html.Attrs?,
  trigger_style : Array[String],
  content_attrs : @html.Attrs?,
  content_style : Array[String],
  calendar_attrs : @html.Attrs?,
  calendar_style : Array[String],
  day_attrs : @html.Attrs?,
  day_style : Array[String],
  preset_style : Array[String],
  on_toggle : @cmd.Cmd?,
  on_navigate : @cmd.Emit[Int]?,
  on_choose : @cmd.Emit[CalendarDate]?,
  on_focus_change : @cmd.Emit[CalendarDate]?,
  on_focus_move : @cmd.Emit[CalendarDate]?,
) -> @html.Html {
  let label = date_picker_label(model.value, placeholder, format_value)
  let root_attrs = date_picker_root_attrs(
    attrs,
    "date-picker",
    model.open,
    disabled,
    invalid,
  )
  if model.value is Some(value) {
    ignore(root_attrs.data_set("value", value.to_iso_string()))
  }
  let previous = on_navigate.map(navigate => navigate(-1))
  let next = on_navigate.map(navigate => navigate(1))
  let calendar_id = "\{id}-calendar"
  let selected = model.value
  @html.span(
    style=ui_styles([UiBoxSizing, DatePickerRootStyle], style),
    id="\{id}-root",
    class?,
    title?,
    attrs=root_attrs,
    [
      date_picker_trigger(
        id,
        model.open,
        model.value is Some(_),
        disabled,
        invalid,
        aria_label,
        label,
        on_toggle,
        trigger_attrs,
        trigger_style,
      ),
      popover_content(
        id~,
        trigger_id="\{id}-trigger",
        open=model.open,
        initial_focus=true,
        restore_focus=true,
        final_focus_id="\{id}-trigger",
        side~,
        align~,
        side_offset~,
        align_offset~,
        attrs?=content_attrs,
        style=date_picker_part_styles(DatePickerContentStyle, content_style),
        @html.div(
          style=[UiBoxSizing, DatePickerContentInnerStyle],
          attrs=@html.Attrs::build().data_set("slot", "date-picker-content"),
          [
            date_picker_presets(presets, disabled, on_choose, preset_style),
            render_calendar(
              month=model.visible,
              selected?,
              today?,
              focused=model.focused,
              show_outside_days~,
              disabled~,
              aria_label="Date picker calendar",
              on_previous?=previous,
              on_next?=next,
              on_select?=on_choose,
              on_focus_change?,
              on_focus_move?,
              id=calendar_id,
              attrs?=calendar_attrs,
              day_attrs?,
              style=date_picker_part_styles(
                DatePickerCalendarStyle,
                calendar_style,
              ),
              day_style~,
            ),
          ],
        ),
      ),
    ],
  )
}

///|
fn render_date_range_picker(
  id : String,
  model : DateRangePickerModel,
  today : CalendarDate?,
  show_outside_days : Bool,
  placeholder : String,
  disabled : Bool,
  invalid : Bool,
  aria_label : String?,
  side : PopupSide,
  align : PopupAlign,
  side_offset : Int,
  align_offset : Int,
  format_value : ((DateRange) -> String)?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  trigger_attrs : @html.Attrs?,
  trigger_style : Array[String],
  content_attrs : @html.Attrs?,
  content_style : Array[String],
  calendar_attrs : @html.Attrs?,
  calendar_style : Array[String],
  day_attrs : @html.Attrs?,
  day_style : Array[String],
  on_toggle : @cmd.Cmd?,
  on_navigate : @cmd.Emit[Int]?,
  on_choose : @cmd.Emit[CalendarDate]?,
  on_focus_change : @cmd.Emit[CalendarDate]?,
  on_focus_move : @cmd.Emit[CalendarDate]?,
) -> @html.Html {
  let label = date_range_picker_label(model.value, placeholder, format_value)
  let root_attrs = date_picker_root_attrs(
    attrs,
    "date-range-picker",
    model.open,
    disabled,
    invalid,
  )
  let range_start = model.value.map(value => value.start)
  let range_end = if model.value is Some(value) { value.end } else { None }
  if range_start is Some(start) {
    ignore(root_attrs.data_set("range-start", start.to_iso_string()))
  }
  if range_end is Some(end) {
    ignore(root_attrs.data_set("range-end", end.to_iso_string()))
  }
  let previous = on_navigate.map(navigate => navigate(-1))
  let next = on_navigate.map(navigate => navigate(1))
  let following_month = calendar_shift_month(model.visible, 1)
  let range_calendar_style = date_picker_part_styles(
    DateRangePickerCalendarStyle,
    calendar_style,
  )
  let range_content_attrs = ui_attrs(content_attrs).data_set(
    "date-range-picker-popup", "",
  )
  @html.span(
    style=ui_styles([UiBoxSizing, DatePickerRootStyle], style),
    id="\{id}-root",
    class?,
    title?,
    attrs=root_attrs,
    [
      date_picker_trigger(
        id,
        model.open,
        model.value is Some(_),
        disabled,
        invalid,
        aria_label,
        label,
        on_toggle,
        trigger_attrs,
        trigger_style,
      ),
      popover_content(
        id~,
        trigger_id="\{id}-trigger",
        open=model.open,
        initial_focus=true,
        restore_focus=true,
        final_focus_id="\{id}-trigger",
        side~,
        align~,
        side_offset~,
        align_offset~,
        attrs=range_content_attrs,
        style=date_picker_part_styles(
          DateRangePickerContentStyle,
          content_style,
        ),
        @html.div(
          style=[UiBoxSizing, DateRangePickerContentInnerStyle],
          attrs=@html.Attrs::build().data_set(
            "slot", "date-range-picker-content",
          ),
          [
            render_calendar(
              month=model.visible,
              selection_mode=CalendarRangeSelection,
              range_start?,
              range_end?,
              today?,
              focused=model.focused,
              show_outside_days~,
              hide_outside_after=true,
              disabled~,
              aria_label="Date range picker calendar",
              on_previous?=previous,
              on_select?=on_choose,
              on_focus_change?,
              on_focus_move?,
              show_next=false,
              id="\{id}-calendar",
              attrs?=calendar_attrs,
              day_attrs?,
              style=range_calendar_style,
              nav_style=["justify-content:flex-start"],
              day_style~,
            ),
            render_calendar(
              month=following_month,
              selection_mode=CalendarRangeSelection,
              range_start?,
              range_end?,
              today?,
              focused=model.focused,
              show_outside_days~,
              hide_outside_before=true,
              disabled~,
              aria_label="Date range picker following calendar",
              on_next?=next,
              on_select?=on_choose,
              on_focus_change?,
              on_focus_move?,
              show_previous=false,
              id="\{id}-calendar-next",
              attrs?=calendar_attrs,
              day_attrs?,
              style=range_calendar_style,
              nav_style=["justify-content:flex-end"],
              day_style~,
            ),
          ],
        ),
      ),
    ],
  )
}

///|
#cfg(target="js")
fn[T] date_picker_notify(emit : @cmd.Emit[T]?, value : T) -> @cmd.Cmd {
  if emit is Some(emit) {
    emit(value)
  } else {
    @cmd.none
  }
}

///|
#cfg(target="js")
fn date_picker_update(
  id : String,
  disabled : Bool,
  today : CalendarDate?,
  on_value_change : @cmd.Emit[CalendarDate]?,
  on_open_change : @cmd.Emit[Bool]?,
  message : DatePickerMsg,
  current : DatePickerModel,
) -> (DatePickerModel, @cmd.Cmd) {
  match message {
    DatePickerToggle =>
      if disabled {
        (current, @cmd.none)
      } else {
        let open = !current.open
        (
          { ..current, open, },
          @cmd.batch([
            floating_set_open_cmd(id, open),
            date_picker_notify(on_open_change, open),
          ]),
        )
      }
    DatePickerNativeChanged(open) =>
      if open == current.open {
        (current, @cmd.none)
      } else {
        ({ ..current, open, }, date_picker_notify(on_open_change, open))
      }
    DatePickerNavigate(delta) => {
      let visible = calendar_shift_month(current.visible, delta)
      let focused = calendar_focus_target(visible, current.value, today)
      ({ ..current, visible, focused }, @cmd.none)
    }
    DatePickerChoose(value) => {
      let visible = calendar_first_of_month(value)
      (
        { open: false, visible, value: Some(value), focused: value },
        @cmd.batch([
          date_picker_notify(on_value_change, value),
          floating_set_open_cmd(id, false),
          if current.open {
            date_picker_notify(on_open_change, false)
          } else {
            @cmd.none
          },
        ]),
      )
    }
    DatePickerSetFocused(value) => ({ ..current, focused: value }, @cmd.none)
    DatePickerMoveFocus(value) => {
      let visible = calendar_first_of_month(value)
      (
        { ..current, visible, focused: value },
        calendar_focus_day_cmd(Some("\{id}-calendar"), value),
      )
    }
  }
}

///|
fn date_range_picker_next_value(
  current : DateRange?,
  chosen : CalendarDate,
) -> (DateRange, Bool) {
  let complete = current is Some(range) && range.end is None
  (calendar_range_next_value(current, chosen), complete)
}

///|
fn date_range_picker_visible_for_date(
  visible : CalendarDate,
  date : CalendarDate,
) -> CalendarDate {
  let visible = calendar_first_of_month(visible)
  let following = calendar_shift_month(visible, 1)
  if calendar_same_month(date, visible) || calendar_same_month(date, following) {
    visible
  } else {
    calendar_first_of_month(date)
  }
}

///|
fn date_range_picker_focus_calendar_id(
  id : String,
  visible : CalendarDate,
  date : CalendarDate,
) -> String {
  if calendar_same_month(date, calendar_shift_month(visible, 1)) {
    "\{id}-calendar-next"
  } else {
    "\{id}-calendar"
  }
}

///|
#cfg(target="js")
fn date_range_picker_update(
  id : String,
  disabled : Bool,
  today : CalendarDate?,
  on_value_change : @cmd.Emit[DateRange]?,
  on_open_change : @cmd.Emit[Bool]?,
  message : DateRangePickerMsg,
  current : DateRangePickerModel,
) -> (DateRangePickerModel, @cmd.Cmd) {
  match message {
    DateRangePickerToggle =>
      if disabled {
        (current, @cmd.none)
      } else {
        let open = !current.open
        (
          { ..current, open, },
          @cmd.batch([
            floating_set_open_cmd(id, open),
            date_picker_notify(on_open_change, open),
          ]),
        )
      }
    DateRangePickerNativeChanged(open) =>
      if open == current.open {
        (current, @cmd.none)
      } else {
        ({ ..current, open, }, date_picker_notify(on_open_change, open))
      }
    DateRangePickerNavigate(delta) => {
      let visible = calendar_shift_month(current.visible, delta)
      let selected = current.value.map(value => value.start)
      let focused = calendar_focus_target(visible, selected, today)
      ({ ..current, visible, focused }, @cmd.none)
    }
    DateRangePickerChoose(chosen) => {
      let (value, complete) = date_range_picker_next_value(
        current.value,
        chosen,
      )
      let visible = date_range_picker_visible_for_date(current.visible, chosen)
      let open = !complete
      (
        { open, visible, value: Some(value), focused: chosen },
        @cmd.batch([
          date_picker_notify(on_value_change, value),
          if complete {
            floating_set_open_cmd(id, false)
          } else {
            @cmd.none
          },
          if complete && current.open {
            date_picker_notify(on_open_change, false)
          } else {
            @cmd.none
          },
        ]),
      )
    }
    DateRangePickerSetFocused(value) =>
      ({ ..current, focused: value }, @cmd.none)
    DateRangePickerMoveFocus(value) => {
      let visible = date_range_picker_visible_for_date(current.visible, value)
      let focus_calendar_id = date_range_picker_focus_calendar_id(
        id, visible, value,
      )
      (
        { ..current, visible, focused: value },
        calendar_focus_day_cmd(Some(focus_calendar_id), value),
      )
    }
  }
}

///|
/// Stateful single-date picker composed from the package's native Calendar
/// and CSS-anchored Popover primitives. Selecting a date updates the trigger,
/// calls `on_value_change`, and closes the popup.
#cfg(target="js")
pub fn date_picker(
  id~ : String,
  default_value? : CalendarDate,
  default_month? : CalendarDate,
  today? : CalendarDate,
  default_open? : Bool = false,
  show_outside_days? : Bool = true,
  placeholder? : String = "Pick a date",
  disabled? : Bool = false,
  invalid? : Bool = false,
  aria_label? : String,
  side? : PopupSide = Bottom,
  align? : PopupAlign = Start,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  presets? : Array[DatePickerPreset] = [],
  format_value? : (CalendarDate) -> String,
  on_value_change? : @cmd.Emit[CalendarDate],
  on_open_change? : @cmd.Emit[Bool],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  trigger_attrs? : @html.Attrs,
  trigger_style? : Array[String] = [],
  content_attrs? : @html.Attrs,
  content_style? : Array[String] = [],
  calendar_attrs? : @html.Attrs,
  calendar_style? : Array[String] = [],
  day_attrs? : @html.Attrs,
  day_style? : Array[String] = [],
  preset_style? : Array[String] = [],
) -> @rabbita.Val[@html.Html] {
  let initial = date_picker_initial_model(
    default_open, disabled, default_month, default_value, today,
  )
  let (model, emit) = @rabbita.create_state_with_init(
    init=emit => {
      (
        initial,
        @cmd.batch([
          floating_bind_sync_cmd(
            id,
            emit.map(open => DatePickerNativeChanged(open)),
          ),
          if initial.open {
            floating_set_open_cmd(id, true)
          } else {
            @cmd.none
          },
        ]),
      )
    },
    update=(_, message, current) => {
      date_picker_update(
        id, disabled, today, on_value_change, on_open_change, message, current,
      )
    },
  )
  let navigate = emit.map(delta => DatePickerNavigate(delta))
  let choose = emit.map(value => DatePickerChoose(value))
  let focus = emit.map(value => DatePickerSetFocused(value))
  let move_focus = emit.map(value => DatePickerMoveFocus(value))
  model.view(model => {
    render_date_picker(
      id,
      model,
      today,
      show_outside_days,
      placeholder,
      disabled,
      invalid,
      aria_label,
      side,
      align,
      side_offset,
      align_offset,
      presets,
      format_value,
      class,
      title,
      attrs,
      style,
      trigger_attrs,
      trigger_style,
      content_attrs,
      content_style,
      calendar_attrs,
      calendar_style,
      day_attrs,
      day_style,
      preset_style,
      Some(emit(DatePickerToggle)),
      Some(navigate),
      Some(choose),
      Some(focus),
      Some(move_focus),
    )
  })
}

///|
/// Native/SSR fallback for [`date_picker`].
#cfg(not(target="js"))
pub fn date_picker(
  id~ : String,
  default_value? : CalendarDate,
  default_month? : CalendarDate,
  today? : CalendarDate,
  default_open? : Bool = false,
  show_outside_days? : Bool = true,
  placeholder? : String = "Pick a date",
  disabled? : Bool = false,
  invalid? : Bool = false,
  aria_label? : String,
  side? : PopupSide = Bottom,
  align? : PopupAlign = Start,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  presets? : Array[DatePickerPreset] = [],
  format_value? : (CalendarDate) -> String,
  on_value_change? : @cmd.Emit[CalendarDate],
  on_open_change? : @cmd.Emit[Bool],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  trigger_attrs? : @html.Attrs,
  trigger_style? : Array[String] = [],
  content_attrs? : @html.Attrs,
  content_style? : Array[String] = [],
  calendar_attrs? : @html.Attrs,
  calendar_style? : Array[String] = [],
  day_attrs? : @html.Attrs,
  day_style? : Array[String] = [],
  preset_style? : Array[String] = [],
) -> @rabbita.Val[@html.Html] {
  ignore((on_value_change, on_open_change))
  let initial = date_picker_initial_model(
    default_open, disabled, default_month, default_value, today,
  )
  let choose : @cmd.Emit[CalendarDate] = Emit(_ => @cmd.none)
  @rabbita.Val::constant(
    render_date_picker(
      id,
      initial,
      today,
      show_outside_days,
      placeholder,
      disabled,
      invalid,
      aria_label,
      side,
      align,
      side_offset,
      align_offset,
      presets,
      format_value,
      class,
      title,
      attrs,
      style,
      trigger_attrs,
      trigger_style,
      content_attrs,
      content_style,
      calendar_attrs,
      calendar_style,
      day_attrs,
      day_style,
      preset_style,
      None,
      None,
      Some(choose),
      None,
      None,
    ),
  )
}

///|
/// Stateful date-range picker. The first click starts a range and emits a
/// `DateRange` whose `end()` is `None`; the second click normalizes its
/// boundaries, emits the completed range, and closes the popup. Clicking after
/// a completed range starts a new selection.
#cfg(target="js")
pub fn date_range_picker(
  id~ : String,
  default_value? : DateRange,
  default_month? : CalendarDate,
  today? : CalendarDate,
  default_open? : Bool = false,
  show_outside_days? : Bool = true,
  placeholder? : String = "Pick a date range",
  disabled? : Bool = false,
  invalid? : Bool = false,
  aria_label? : String,
  side? : PopupSide = Bottom,
  align? : PopupAlign = Start,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  format_value? : (DateRange) -> String,
  on_value_change? : @cmd.Emit[DateRange],
  on_open_change? : @cmd.Emit[Bool],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  trigger_attrs? : @html.Attrs,
  trigger_style? : Array[String] = [],
  content_attrs? : @html.Attrs,
  content_style? : Array[String] = [],
  calendar_attrs? : @html.Attrs,
  calendar_style? : Array[String] = [],
  day_attrs? : @html.Attrs,
  day_style? : Array[String] = [],
) -> @rabbita.Val[@html.Html] {
  let initial = date_range_picker_initial_model(
    default_open, disabled, default_month, default_value, today,
  )
  let (model, emit) = @rabbita.create_state_with_init(
    init=emit => {
      (
        initial,
        @cmd.batch([
          floating_bind_sync_cmd(
            id,
            emit.map(open => DateRangePickerNativeChanged(open)),
          ),
          if initial.open {
            floating_set_open_cmd(id, true)
          } else {
            @cmd.none
          },
        ]),
      )
    },
    update=(_, message, current) => {
      date_range_picker_update(
        id, disabled, today, on_value_change, on_open_change, message, current,
      )
    },
  )
  let navigate = emit.map(delta => DateRangePickerNavigate(delta))
  let choose = emit.map(value => DateRangePickerChoose(value))
  let focus = emit.map(value => DateRangePickerSetFocused(value))
  let move_focus = emit.map(value => DateRangePickerMoveFocus(value))
  model.view(model => {
    render_date_range_picker(
      id,
      model,
      today,
      show_outside_days,
      placeholder,
      disabled,
      invalid,
      aria_label,
      side,
      align,
      side_offset,
      align_offset,
      format_value,
      class,
      title,
      attrs,
      style,
      trigger_attrs,
      trigger_style,
      content_attrs,
      content_style,
      calendar_attrs,
      calendar_style,
      day_attrs,
      day_style,
      Some(emit(DateRangePickerToggle)),
      Some(navigate),
      Some(choose),
      Some(focus),
      Some(move_focus),
    )
  })
}

///|
/// Native/SSR fallback for [`date_range_picker`].
#cfg(not(target="js"))
pub fn date_range_picker(
  id~ : String,
  default_value? : DateRange,
  default_month? : CalendarDate,
  today? : CalendarDate,
  default_open? : Bool = false,
  show_outside_days? : Bool = true,
  placeholder? : String = "Pick a date range",
  disabled? : Bool = false,
  invalid? : Bool = false,
  aria_label? : String,
  side? : PopupSide = Bottom,
  align? : PopupAlign = Start,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  format_value? : (DateRange) -> String,
  on_value_change? : @cmd.Emit[DateRange],
  on_open_change? : @cmd.Emit[Bool],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  trigger_attrs? : @html.Attrs,
  trigger_style? : Array[String] = [],
  content_attrs? : @html.Attrs,
  content_style? : Array[String] = [],
  calendar_attrs? : @html.Attrs,
  calendar_style? : Array[String] = [],
  day_attrs? : @html.Attrs,
  day_style? : Array[String] = [],
) -> @rabbita.Val[@html.Html] {
  ignore((on_value_change, on_open_change))
  let initial = date_range_picker_initial_model(
    default_open, disabled, default_month, default_value, today,
  )
  let choose : @cmd.Emit[CalendarDate] = Emit(_ => @cmd.none)
  @rabbita.Val::constant(
    render_date_range_picker(
      id,
      initial,
      today,
      show_outside_days,
      placeholder,
      disabled,
      invalid,
      aria_label,
      side,
      align,
      side_offset,
      align_offset,
      format_value,
      class,
      title,
      attrs,
      style,
      trigger_attrs,
      trigger_style,
      content_attrs,
      content_style,
      calendar_attrs,
      calendar_style,
      day_attrs,
      day_style,
      None,
      None,
      Some(choose),
      None,
      None,
    ),
  )
}
