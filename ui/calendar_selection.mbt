///|
priv struct CalendarRangeModel {
  visible : CalendarDate
  selected : DateRange?
  focused : CalendarDate
} derive(Eq)

///|
priv struct CalendarMultipleModel {
  visible : CalendarDate
  selected : Array[CalendarDate]
  focused : CalendarDate
} derive(Eq)

///|
#cfg(target="js")
priv enum CalendarRangeMsg {
  CalendarRangeNavigate(Int)
  CalendarRangeChoose(CalendarDate)
  CalendarRangeSetFocused(CalendarDate)
  CalendarRangeMoveFocus(CalendarDate)
}

///|
#cfg(target="js")
priv enum CalendarMultipleMsg {
  CalendarMultipleNavigate(Int)
  CalendarMultipleChoose(CalendarDate)
  CalendarMultipleSetFocused(CalendarDate)
  CalendarMultipleMoveFocus(CalendarDate)
}

///|
fn calendar_selection_mode_name(mode : CalendarSelectionMode) -> String {
  match mode {
    CalendarSingleSelection => "single"
    CalendarRangeSelection => "range"
    CalendarMultipleSelection => "multiple"
  }
}

///|
fn calendar_contains_date(
  dates : Array[CalendarDate],
  target : CalendarDate,
) -> Bool {
  for date in dates {
    if date == target {
      return true
    }
  }
  false
}

///|
fn calendar_normalize_dates(dates : Array[CalendarDate]) -> Array[CalendarDate] {
  let normalized : Array[CalendarDate] = []
  for date in dates {
    if !calendar_contains_date(normalized, date) {
      normalized.push(date)
    }
  }
  normalized
}

///|
fn calendar_multiple_next_value(
  current : Array[CalendarDate],
  chosen : CalendarDate,
) -> Array[CalendarDate] {
  let next : Array[CalendarDate] = []
  let mut removed = false
  for date in current {
    if date == chosen {
      removed = true
    } else {
      next.push(date)
    }
  }
  if !removed {
    next.push(chosen)
  }
  next
}

///|
fn calendar_range_next_value(
  current : DateRange?,
  chosen : CalendarDate,
) -> DateRange {
  if current is Some(current) && current.end is None {
    date_range(start=current.start, end=chosen)
  } else {
    date_range(start=chosen)
  }
}

///|
fn calendar_range_initial_model(
  default_month : CalendarDate?,
  default_selected : DateRange?,
  today : CalendarDate?,
) -> CalendarRangeModel {
  let selected = default_selected.map(range => range.start)
  let calendar = calendar_initial_model(default_month, selected, today)
  {
    visible: calendar.visible,
    selected: default_selected,
    focused: calendar.focused,
  }
}

///|
fn calendar_multiple_initial_model(
  default_month : CalendarDate?,
  default_selected : Array[CalendarDate],
  today : CalendarDate?,
) -> CalendarMultipleModel {
  let selected = calendar_normalize_dates(default_selected)
  let calendar = calendar_initial_model(default_month, selected.get(0), today)
  { visible: calendar.visible, selected, focused: calendar.focused }
}

///|
fn render_calendar_range_model(
  model : CalendarRangeModel,
  today : CalendarDate?,
  show_outside_days : Bool,
  disabled : Bool,
  aria_label : String,
  on_previous : @cmd.Cmd?,
  on_next : @cmd.Cmd?,
  on_select : @cmd.Emit[CalendarDate]?,
  on_focus_change : @cmd.Emit[CalendarDate]?,
  on_focus_move : @cmd.Emit[CalendarDate]?,
  id : String?,
  class : String?,
  title : String?,
  hidden : Bool?,
  attrs : @html.Attrs?,
  previous_attrs : @html.Attrs?,
  next_attrs : @html.Attrs?,
  grid_attrs : @html.Attrs?,
  day_attrs : @html.Attrs?,
  style : Array[String],
  header_style : Array[String],
  caption_style : Array[String],
  nav_style : Array[String],
  previous_style : Array[String],
  next_style : Array[String],
  grid_style : Array[String],
  weekday_style : Array[String],
  cell_style : Array[String],
  day_style : Array[String],
) -> @html.Html {
  let range_start = model.selected.map(range => range.start)
  let range_end = if model.selected is Some(range) { range.end } else { None }
  render_calendar(
    month=model.visible,
    selection_mode=CalendarRangeSelection,
    range_start?,
    range_end?,
    today?,
    focused=model.focused,
    show_outside_days~,
    disabled~,
    aria_label~,
    on_previous?,
    on_next?,
    on_select?,
    on_focus_change?,
    on_focus_move?,
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
}

///|
fn render_calendar_multiple_model(
  model : CalendarMultipleModel,
  today : CalendarDate?,
  show_outside_days : Bool,
  disabled : Bool,
  aria_label : String,
  on_previous : @cmd.Cmd?,
  on_next : @cmd.Cmd?,
  on_select : @cmd.Emit[CalendarDate]?,
  on_focus_change : @cmd.Emit[CalendarDate]?,
  on_focus_move : @cmd.Emit[CalendarDate]?,
  id : String?,
  class : String?,
  title : String?,
  hidden : Bool?,
  attrs : @html.Attrs?,
  previous_attrs : @html.Attrs?,
  next_attrs : @html.Attrs?,
  grid_attrs : @html.Attrs?,
  day_attrs : @html.Attrs?,
  style : Array[String],
  header_style : Array[String],
  caption_style : Array[String],
  nav_style : Array[String],
  previous_style : Array[String],
  next_style : Array[String],
  grid_style : Array[String],
  weekday_style : Array[String],
  cell_style : Array[String],
  day_style : Array[String],
) -> @html.Html {
  render_calendar(
    month=model.visible,
    selection_mode=CalendarMultipleSelection,
    selected_dates=model.selected,
    today?,
    focused=model.focused,
    show_outside_days~,
    disabled~,
    aria_label~,
    on_previous?,
    on_next?,
    on_select?,
    on_focus_change?,
    on_focus_move?,
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
}

///|
#cfg(target="js")
fn calendar_range_update(
  root_id : String?,
  on_select : @cmd.Emit[DateRange]?,
  on_month_change : @cmd.Emit[CalendarDate]?,
  today : CalendarDate?,
  msg : CalendarRangeMsg,
  model : CalendarRangeModel,
) -> (CalendarRangeModel, @cmd.Cmd) {
  match msg {
    CalendarRangeNavigate(delta) => {
      let visible = calendar_shift_month(model.visible, delta)
      let selected = model.selected.map(range => range.start)
      let focused = calendar_focus_target(visible, selected, today)
      (
        { ..model, visible, focused },
        calendar_emit_command(on_month_change, visible),
      )
    }
    CalendarRangeChoose(date) => {
      let selected = calendar_range_next_value(model.selected, date)
      let visible = calendar_first_of_month(date)
      let commands : Array[@cmd.Cmd] = [
        calendar_emit_command(on_select, selected),
      ]
      if visible != model.visible {
        commands.push(calendar_emit_command(on_month_change, visible))
      }
      (
        { visible, selected: Some(selected), focused: date },
        @cmd.batch(commands),
      )
    }
    CalendarRangeSetFocused(date) => ({ ..model, focused: date }, @cmd.none)
    CalendarRangeMoveFocus(date) => {
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
#cfg(target="js")
fn calendar_multiple_update(
  root_id : String?,
  on_select : @cmd.Emit[Array[CalendarDate]]?,
  on_month_change : @cmd.Emit[CalendarDate]?,
  today : CalendarDate?,
  msg : CalendarMultipleMsg,
  model : CalendarMultipleModel,
) -> (CalendarMultipleModel, @cmd.Cmd) {
  match msg {
    CalendarMultipleNavigate(delta) => {
      let visible = calendar_shift_month(model.visible, delta)
      let focused = calendar_focus_target(visible, model.selected.get(0), today)
      (
        { ..model, visible, focused },
        calendar_emit_command(on_month_change, visible),
      )
    }
    CalendarMultipleChoose(date) => {
      let selected = calendar_multiple_next_value(model.selected, date)
      let visible = calendar_first_of_month(date)
      let commands : Array[@cmd.Cmd] = [
        calendar_emit_command(on_select, selected.copy()),
      ]
      if visible != model.visible {
        commands.push(calendar_emit_command(on_month_change, visible))
      }
      ({ visible, selected, focused: date }, @cmd.batch(commands))
    }
    CalendarMultipleSetFocused(date) => ({ ..model, focused: date }, @cmd.none)
    CalendarMultipleMoveFocus(date) => {
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
/// Stateful range-selection Calendar. The first activation starts a range;
/// the second normalizes and completes it. Activating again starts a new
/// range. Every change is reported through `on_select`.
#cfg(target="js")
pub fn calendar_range(
  default_month? : CalendarDate,
  default_selected? : DateRange,
  today? : CalendarDate,
  show_outside_days? : Bool = true,
  disabled? : Bool = false,
  aria_label? : String = "Calendar",
  on_select? : @cmd.Emit[DateRange],
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
  let initial = calendar_range_initial_model(
    default_month, default_selected, today,
  )
  let (model, emit) = @rabbita.create_state(initial, update=fn(_, msg, model) {
    calendar_range_update(id, on_select, on_month_change, today, msg, model)
  })
  let select = emit.map(date => CalendarRangeChoose(date))
  let set_focused = emit.map(date => CalendarRangeSetFocused(date))
  let move_focus = emit.map(date => CalendarRangeMoveFocus(date))
  model.view(model => {
    render_calendar_range_model(
      model,
      today,
      show_outside_days,
      disabled,
      aria_label,
      Some(emit(CalendarRangeNavigate(-1))),
      Some(emit(CalendarRangeNavigate(1))),
      Some(select),
      Some(set_focused),
      Some(move_focus),
      id,
      class,
      title,
      hidden,
      attrs,
      previous_attrs,
      next_attrs,
      grid_attrs,
      day_attrs,
      style,
      header_style,
      caption_style,
      nav_style,
      previous_style,
      next_style,
      grid_style,
      weekday_style,
      cell_style,
      day_style,
    )
  })
}

///|
/// Native/SSR fallback for [`calendar_range`].
#cfg(not(target="js"))
pub fn calendar_range(
  default_month? : CalendarDate,
  default_selected? : DateRange,
  today? : CalendarDate,
  show_outside_days? : Bool = true,
  disabled? : Bool = false,
  aria_label? : String = "Calendar",
  on_select? : @cmd.Emit[DateRange],
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
  let model = calendar_range_initial_model(
    default_month, default_selected, today,
  )
  let select : @cmd.Emit[CalendarDate] = Emit(_ => @cmd.none)
  @rabbita.Val::constant(
    render_calendar_range_model(
      model,
      today,
      show_outside_days,
      disabled,
      aria_label,
      Some(@cmd.none),
      Some(@cmd.none),
      Some(select),
      None,
      None,
      id,
      class,
      title,
      hidden,
      attrs,
      previous_attrs,
      next_attrs,
      grid_attrs,
      day_attrs,
      style,
      header_style,
      caption_style,
      nav_style,
      previous_style,
      next_style,
      grid_style,
      weekday_style,
      cell_style,
      day_style,
    ),
  )
}

///|
/// Stateful multiple-selection Calendar. Activating a date toggles it while
/// preserving all other selected dates. `on_select` receives a fresh array
/// after every toggle, including the empty selection.
#cfg(target="js")
pub fn calendar_multiple(
  default_month? : CalendarDate,
  default_selected? : Array[CalendarDate] = [],
  today? : CalendarDate,
  show_outside_days? : Bool = true,
  disabled? : Bool = false,
  aria_label? : String = "Calendar",
  on_select? : @cmd.Emit[Array[CalendarDate]],
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
  let initial = calendar_multiple_initial_model(
    default_month, default_selected, today,
  )
  let (model, emit) = @rabbita.create_state(initial, update=fn(_, msg, model) {
    calendar_multiple_update(id, on_select, on_month_change, today, msg, model)
  })
  let select = emit.map(date => CalendarMultipleChoose(date))
  let set_focused = emit.map(date => CalendarMultipleSetFocused(date))
  let move_focus = emit.map(date => CalendarMultipleMoveFocus(date))
  model.view(model => {
    render_calendar_multiple_model(
      model,
      today,
      show_outside_days,
      disabled,
      aria_label,
      Some(emit(CalendarMultipleNavigate(-1))),
      Some(emit(CalendarMultipleNavigate(1))),
      Some(select),
      Some(set_focused),
      Some(move_focus),
      id,
      class,
      title,
      hidden,
      attrs,
      previous_attrs,
      next_attrs,
      grid_attrs,
      day_attrs,
      style,
      header_style,
      caption_style,
      nav_style,
      previous_style,
      next_style,
      grid_style,
      weekday_style,
      cell_style,
      day_style,
    )
  })
}

///|
/// Native/SSR fallback for [`calendar_multiple`].
#cfg(not(target="js"))
pub fn calendar_multiple(
  default_month? : CalendarDate,
  default_selected? : Array[CalendarDate] = [],
  today? : CalendarDate,
  show_outside_days? : Bool = true,
  disabled? : Bool = false,
  aria_label? : String = "Calendar",
  on_select? : @cmd.Emit[Array[CalendarDate]],
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
  let model = calendar_multiple_initial_model(
    default_month, default_selected, today,
  )
  let select : @cmd.Emit[CalendarDate] = Emit(_ => @cmd.none)
  @rabbita.Val::constant(
    render_calendar_multiple_model(
      model,
      today,
      show_outside_days,
      disabled,
      aria_label,
      Some(@cmd.none),
      Some(@cmd.none),
      Some(select),
      None,
      None,
      id,
      class,
      title,
      hidden,
      attrs,
      previous_attrs,
      next_attrs,
      grid_attrs,
      day_attrs,
      style,
      header_style,
      caption_style,
      nav_style,
      previous_style,
      next_style,
      grid_style,
      weekday_style,
      cell_style,
      day_style,
    ),
  )
}
