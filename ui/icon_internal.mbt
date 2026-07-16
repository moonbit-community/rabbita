///|
/// Internal Lucide-compatible stroke icon used by controls that must not rely
/// on font glyph metrics. The surrounding span owns accessibility hiding and
/// a stable one-rem layout box; callers provide the icon's semantic label on
/// the interactive control itself.
fn ui_stroke_icon(path : String) -> @html.Html {
  @html.span(
    style=[
      UiBoxSizing,
      "display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;pointer-events:none",
    ],
    attrs=@html.Attrs::build().aria_hidden("true"),
    @svg.svg(
      width=16,
      height=16,
      view_box="0 0 24 24",
      style=["display:block;width:100%;height:100%"],
      [
        @svg.path(
          d=path,
          fill="none",
          stroke="currentColor",
          stroke_width=2,
          attrs=@svg.Attrs::build()
            .stroke_linecap("round")
            .stroke_linejoin("round"),
        ),
      ],
    ),
  )
}

///|
fn ui_check_icon() -> @html.Html {
  ui_stroke_icon("M20 6 9 17l-5-5")
}

///|
fn ui_chevron_right_icon() -> @html.Html {
  ui_stroke_icon("m9 18 6-6-6-6")
}

///|
fn ui_chevron_left_icon() -> @html.Html {
  ui_stroke_icon("m15 18-6-6 6-6")
}

///|
fn ui_x_icon() -> @html.Html {
  ui_stroke_icon("M18 6 6 18M6 6l12 12")
}

///|
fn ui_chevron_down_icon() -> @html.Html {
  ui_stroke_icon("m6 9 6 6 6-6")
}

///|
fn ui_chevron_up_icon() -> @html.Html {
  ui_stroke_icon("m18 15-6-6-6 6")
}

///|
fn ui_minus_icon() -> @html.Html {
  ui_stroke_icon("M5 12h14")
}

///|
fn ui_search_icon() -> @html.Html {
  ui_stroke_icon("m21 21-4.3-4.3M19 11a8 8 0 1 1-16 0 8 8 0 0 1 16 0Z")
}

///|
fn ui_calendar_icon() -> @html.Html {
  ui_stroke_icon(
    "M8 2v4M16 2v4M3 10h18M5 4h14a2 2 0 0 1 2 2v13a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2Z",
  )
}
