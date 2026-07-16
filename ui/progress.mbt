///|
priv enum ProgressState {
  Indeterminate
  Progressing
  Complete
}

///|
const ProgressBaseStyle : String = "display:flex;width:100%;min-width:0;flex-wrap:wrap;align-items:center;gap:0.75rem"

///|
const ProgressTrackStyle : String = "position:relative;display:flex;width:100%;height:0.5rem;align-items:center;overflow-x:hidden;border-radius:9999px;background:color-mix(in oklab,var(--rui-primary,oklch(0.205 0 0)) 20%,transparent)"

///|
const ProgressIndicatorStyle : String = "height:100%;flex:none;background:var(--rui-primary,oklch(0.205 0 0));transition:width 150ms ease"

///|
const ProgressIndeterminateStyle : String = "position:absolute;inset-block:0;inset-inline-start:-40%;inline-size:40%;animation:rui-progress-indeterminate 1.4s ease-in-out infinite"

///|
const ProgressIndeterminateCss : String =
  #|@keyframes rui-progress-indeterminate {
  #|  from { inset-inline-start:-40%; }
  #|  to { inset-inline-start:100%; }
  #|}
  #|@media (prefers-reduced-motion:reduce) {
  #|  [data-slot="progress-indicator"][data-state="indeterminate"] {
  #|    animation:none !important;
  #|    inset-inline-start:30%;
  #|  }
  #|}
  #|

///|
#warnings("-alert_xss_vulnerable")
fn progress_indeterminate_stylesheet() -> @html.Html {
  // Static library CSS is required for keyframes; no caller input reaches it.
  let attrs = @html.Attrs::build()
    .data_set("rui-style", "progress-indeterminate")
    .inner_html(ProgressIndeterminateCss)
  @html.style_tag(attrs~, ([] : Array[@html.Html]))
}

///|
const ProgressLabelStyle : String = "font-size:0.875rem;line-height:1.25rem;font-weight:500"

///|
const ProgressValueStyle : String = "margin-inline-start:auto;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem;line-height:1.25rem;font-variant-numeric:tabular-nums"

///|
fn progress_effective_max(min : Int, max : Int) -> Int {
  if max < min {
    min
  } else {
    max
  }
}

///|
fn progress_clamped_value(value : Int, min : Int, max : Int) -> Int {
  let max = progress_effective_max(min, max)
  if max == min {
    min
  } else if value < min {
    min
  } else if value > max {
    max
  } else {
    value
  }
}

///|
fn progress_percentage(value : Int, min : Int, max : Int) -> Int {
  let max = progress_effective_max(min, max)
  if max == min {
    100
  } else {
    let clamped = progress_clamped_value(value, min, max)
    (clamped - min) * 100 / (max - min)
  }
}

///|
fn progress_state(value : Int?, min : Int, max : Int) -> ProgressState {
  if value is Some(value) {
    let max = progress_effective_max(min, max)
    if progress_clamped_value(value, min, max) == max {
      Complete
    } else {
      Progressing
    }
  } else {
    Indeterminate
  }
}

///|
fn progress_state_attrs(
  attrs : @html.Attrs?,
  state : ProgressState,
  slot : String,
) -> @html.Attrs {
  let element_attrs = ui_attrs(attrs).data_set("slot", slot)
  match state {
    Indeterminate =>
      element_attrs
      .data_set("state", "indeterminate")
      .data_set("indeterminate", "")
    Progressing =>
      element_attrs.data_set("state", "progressing").data_set("progressing", "")
    Complete =>
      element_attrs.data_set("state", "complete").data_set("complete", "")
  }
}

///|
fn progress_indicator_width(value : Int?, min : Int, max : Int) -> String {
  if value is Some(value) {
    "width:\{progress_percentage(value, min, max)}%"
  } else {
    ProgressIndeterminateStyle
  }
}

///|
fn progress_aria_text(value : Int?, min : Int, max : Int) -> String {
  if value is Some(value) {
    "\{progress_percentage(value, min, max)}%"
  } else {
    "indeterminate progress"
  }
}

///|
fn progress_display_text(value : Int?, min : Int, max : Int) -> String {
  if value is Some(value) {
    "\{progress_percentage(value, min, max)}%"
  } else {
    ""
  }
}

///|
/// Render an ARIA progress group and append Vega's track and
/// indicator automatically after optional label/value children.
///
/// Determinate values are clamped to `min...max`. A `max` below `min` is
/// normalized to `min`. `None` renders the indeterminate state and omits
/// `aria-valuenow`.
pub fn progress(
  value? : Int,
  min? : Int = 0,
  max? : Int = 100,
  aria_label? : String,
  aria_value_text? : String,
  labelledby? : String,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children? : Array[@html.Html] = [],
) -> @html.Html {
  let state = progress_state(value, min, max)
  let effective_max = progress_effective_max(min, max)
  let element_attrs = progress_state_attrs(attrs, state, "progress")
    .role("progressbar")
    .aria_valuemin("\{min}")
    .aria_valuemax("\{effective_max}")
  if value is Some(value) {
    ignore(
      element_attrs.aria_valuenow("\{progress_clamped_value(value, min, max)}"),
    )
  }
  if aria_label is Some(aria_label) {
    ignore(element_attrs.aria_label(aria_label))
  }
  if labelledby is Some(labelledby) {
    ignore(element_attrs.aria_labelledby(labelledby))
  }
  ignore(
    element_attrs.aria_valuetext(
      aria_value_text.unwrap_or(progress_aria_text(value, min, max)),
    ),
  )
  let root_children : Array[@html.Html] = []
  for child in children {
    root_children.push(child)
  }
  root_children.push(
    progress_track(value?, min~, max~, [progress_indicator(value?, min~, max~)]),
  )
  @html.div(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, ProgressBaseStyle],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=element_attrs,
    root_children,
  )
}

///|
pub fn[C : @html.IsChildren] progress_track(
  value? : Int,
  min? : Int = 0,
  max? : Int = 100,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, ProgressTrackStyle], style),
    id?,
    class?,
    title?,
    hidden?,
    attrs=progress_state_attrs(
      attrs,
      progress_state(value, min, max),
      "progress-track",
    ),
    children,
  )
}

///|
pub fn progress_indicator(
  value? : Int,
  min? : Int = 0,
  max? : Int = 100,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let indicator = @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        ProgressIndicatorStyle,
        progress_indicator_width(value, min, max),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=progress_state_attrs(
      attrs,
      progress_state(value, min, max),
      "progress-indicator",
    ),
    @html.nothing,
  )
  if value is Some(_) {
    indicator
  } else {
    @html.fragment([progress_indeterminate_stylesheet(), indicator])
  }
}

///|
/// Render a progress label. Pass the same `id` to `progress(labelledby=...)`
/// because a stateless Rabbita function cannot register the label implicitly.
pub fn[C : @html.IsChildren] progress_label(
  value? : Int,
  min? : Int = 0,
  max? : Int = 100,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = progress_state_attrs(
    attrs,
    progress_state(value, min, max),
    "progress-label",
  ).role("presentation")
  @html.span(
    style=ui_styles([UiBoxSizing, ProgressLabelStyle], style),
    id?,
    class?,
    title?,
    hidden?,
    attrs=element_attrs,
    children,
  )
}

///|
/// Render the formatted percentage, or an empty span for indeterminate state.
/// `text` overrides the default formatting while preserving `aria-hidden`.
pub fn progress_value(
  value? : Int,
  min? : Int = 0,
  max? : Int = 100,
  text? : String,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = progress_state_attrs(
    attrs,
    progress_state(value, min, max),
    "progress-value",
  ).aria_hidden("true")
  @html.span(
    style=ui_styles([UiBoxSizing, ProgressValueStyle], style),
    id?,
    class?,
    title?,
    hidden?,
    attrs=element_attrs,
    text.unwrap_or(progress_display_text(value, min, max)),
  )
}
