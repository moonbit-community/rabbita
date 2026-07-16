///|
/// Static Lucide-compatible strokes used by the showcase. These are visual
/// assets only; component state and interaction remain inside the public UI
/// components being demonstrated.
fn showcase_stroke_icon(
  path : String,
  box_size? : String = "1rem",
) -> @html.Html {
  let line_attrs = @svg.Attrs::build()
    .stroke_linecap("round")
    .stroke_linejoin("round")
  @html.span(
    style=[
      "display:inline-flex;width:\{box_size};height:\{box_size};flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none",
    ],
    attrs=@html.Attrs::build().aria_hidden("true"),
    @svg.svg(
      width=24,
      height=24,
      view_box="0 0 24 24",
      style=["display:block;width:100%;height:100%"],
      [
        @svg.path(
          d=path,
          fill="none",
          stroke="currentColor",
          stroke_width=2,
          attrs=line_attrs,
        ),
      ],
    ),
  )
}

///|
fn showcase_close_icon() -> @html.Html {
  showcase_stroke_icon("M18 6 6 18M6 6l12 12")
}

///|
fn showcase_file_icon() -> @html.Html {
  showcase_stroke_icon(
    "M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6",
  )
}

///|
fn showcase_archive_icon() -> @html.Html {
  showcase_stroke_icon("M21 8v13H3V8M1 3h22v5H1zM10 12h4")
}

///|
fn showcase_separator_dot_icon() -> @html.Html {
  showcase_stroke_icon("M12 12h.01")
}

///|
fn showcase_check_icon() -> @html.Html {
  showcase_stroke_icon("M20 6 9 17l-5-5")
}

///|
fn showcase_copy_icon() -> @html.Html {
  showcase_stroke_icon(
    "M8 8h12a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H10a2 2 0 0 1-2-2ZM4 16a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2",
  )
}

///|
fn showcase_runtime_icon() -> @html.Html {
  showcase_stroke_icon(
    "M9 3v2M15 3v2M9 19v2M15 19v2M3 9h2M3 15h2M19 9h2M19 15h2M7 7h10v10H7z",
  )
}

///|
fn showcase_layout_icon() -> @html.Html {
  showcase_stroke_icon("M4 4h16v16H4zM4 9h16M9 9v11")
}

///|
fn showcase_plus_icon() -> @html.Html {
  showcase_stroke_icon("M12 5v14M5 12h14")
}

///|
fn showcase_panel_left_icon() -> @html.Html {
  showcase_stroke_icon("M3 3h18v18H3zM9 3v18")
}

///|
fn showcase_activity_icon() -> @html.Html {
  showcase_stroke_icon("M3 12h4l2-8 4 16 2-8h6")
}

///|
fn showcase_settings_icon() -> @html.Html {
  showcase_stroke_icon(
    "M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.38a2 2 0 0 0-.73-2.73l-.15-.09a2 2 0 0 1-1-1.74v-.51a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2zM12 15.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Z",
  )
}

///|
fn showcase_user_icon() -> @html.Html {
  showcase_stroke_icon(
    "M20 21a8 8 0 0 0-16 0M12 13a5 5 0 1 0 0-10 5 5 0 0 0 0 10Z",
  )
}

///|
fn showcase_credit_card_icon() -> @html.Html {
  showcase_stroke_icon(
    "M2 10h20M4 4h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2Z",
  )
}

///|
fn showcase_log_out_icon() -> @html.Html {
  showcase_stroke_icon(
    "m16 17 5-5-5-5M21 12H9M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4",
  )
}

///|
fn showcase_mail_icon() -> @html.Html {
  showcase_stroke_icon(
    "m22 7-8.991 5.727a2 2 0 0 1-2.009 0L2 7M4 4h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2Z",
  )
}

///|
fn showcase_message_square_icon() -> @html.Html {
  showcase_stroke_icon(
    "M21 15a4 4 0 0 1-4 4H7l-4 4V7a4 4 0 0 1 4-4h10a4 4 0 0 1 4 4Z",
  )
}

///|
fn showcase_bell_icon() -> @html.Html {
  showcase_stroke_icon(
    "M10.268 21a2 2 0 0 0 3.464 0M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326",
  )
}

///|
fn showcase_wallet_icon() -> @html.Html {
  showcase_stroke_icon(
    "M20 7V6a2 2 0 0 0-2-2H5a3 3 0 0 0 0 6h15v10H5a3 3 0 0 1-3-3V7M16 14h.01",
  )
}

///|
fn showcase_building_icon() -> @html.Html {
  showcase_stroke_icon(
    "M6 22V4a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v18M6 12H4a2 2 0 0 0-2 2v8h20v-8a2 2 0 0 0-2-2h-2M10 6h4M10 10h4M10 14h4M10 18h4",
  )
}

///|
fn showcase_alert_triangle_icon() -> @html.Html {
  showcase_stroke_icon(
    "M21.73 18 13.73 4a2 2 0 0 0-3.46 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3ZM12 9v4M12 17h.01",
    box_size="2rem",
  )
}

///|
fn showcase_circle_help_icon() -> @html.Html {
  showcase_stroke_icon(
    "M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0ZM9.1 9a3 3 0 1 1 5.8 1c0 2-2.9 2-2.9 4M12 17h.01",
  )
}

///|
fn showcase_arrow_up_icon() -> @html.Html {
  showcase_stroke_icon("m18 15-6-6-6 6")
}

///|
fn showcase_arrow_down_icon() -> @html.Html {
  showcase_stroke_icon("m6 9 6 6 6-6")
}

///|
fn showcase_bold_icon() -> @html.Html {
  showcase_stroke_icon("M6 4h8a4 4 0 0 1 0 8H6zM6 12h9a4 4 0 0 1 0 8H6z")
}

///|
fn showcase_italic_icon() -> @html.Html {
  showcase_stroke_icon("M19 4h-9M14 20H5M15 4 9 20")
}

///|
fn showcase_underline_icon() -> @html.Html {
  showcase_stroke_icon("M6 3v7a6 6 0 0 0 12 0V3M4 21h16")
}
