///|
const FoundationsGalleryStyle : String = "display:flex;min-width:0;flex-direction:column;gap:4rem"

///|
const FoundationsSectionStyle : String = "display:flex;min-width:0;flex-direction:column;gap:4rem"

///|
const FoundationsControlGridStyle : String = "display:grid;width:min(100%,48rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,16rem),1fr));gap:clamp(1.5rem,4vw,3rem);align-items:center"

///|
const FoundationsCenteredRowStyle : String = "display:flex;min-width:0;flex-wrap:wrap;align-items:center;justify-content:center;gap:0.75rem"

///|
const FoundationsNarrowStackStyle : String = "display:flex;width:min(100%,28rem);margin-inline:auto;flex-direction:column;gap:1rem"

///|
const FoundationsSkeletonProfileStyle : String = "display:grid;width:min(100%,28rem);margin-inline:auto;grid-template-columns:auto minmax(0,1fr);gap:0.875rem;align-items:center"

///|
const FoundationsChartPlotStyle : String = "position:absolute;inset:1rem 0.75rem 1.5rem;display:grid;grid-template-columns:repeat(5,minmax(0,1fr));align-items:end;gap:0.625rem;border-bottom:1px solid var(--rui-border)"

///|
const FoundationsTableNumberStyle : String = "text-align:right;font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-variant-numeric:tabular-nums"

///|
const FoundationsButtonVariantsCode : String =
  #|@html.div(
  #|  style=[
  #|    "display:flex;min-width:0;flex-wrap:wrap;align-items:center;justify-content:center;gap:0.75rem",
  #|  ],
  #|  [
  #|  @ui.button("Deploy"),
  #|  @ui.button(variant=@ui.Secondary, "Duplicate"),
  #|  @ui.button(variant=@ui.Outline, "Preview"),
  #|  @ui.button(variant=@ui.Ghost, "More"),
  #|  @ui.button(variant=@ui.Destructive, "Remove"),
  #|  @ui.button(variant=@ui.Link, "Documentation"),
  #|  ],
  #|)
  #|

///|
const FoundationsButtonSizesCode : String =
  #|fn stroke_icon(path : String) -> @html.Html {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=[
  #|      "display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none",
  #|    ],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d=path,
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|
  #|fn button_sizes_demo() -> @html.Html {
  #|  @html.div(
  #|    style=[
  #|      "display:flex;min-width:0;flex-wrap:wrap;align-items:center;justify-content:center;gap:0.75rem",
  #|    ],
  #|    [
  #|      @ui.button(size=@ui.Lg, "Large"),
  #|      @ui.button(size=@ui.Default, "Default"),
  #|      @ui.button(size=@ui.Sm, "Small"),
  #|      @ui.button(size=@ui.Xs, "Extra small"),
  #|      @ui.button(
  #|        size=@ui.IconLg,
  #|        attrs=@html.Attrs::build().aria_label("Add large item"),
  #|        stroke_icon("M12 5v14M5 12h14"),
  #|      ),
  #|      @ui.button(
  #|        size=@ui.Icon,
  #|        attrs=@html.Attrs::build().aria_label("Open settings"),
  #|        stroke_icon("M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.38a2 2 0 0 0-.73-2.73l-.15-.09a2 2 0 0 1-1-1.74v-.51a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2zM12 15.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Z"),
  #|      ),
  #|      @ui.button(
  #|        size=@ui.IconSm,
  #|        attrs=@html.Attrs::build().aria_label("Change layout"),
  #|        stroke_icon("M4 4h16v16H4zM4 9h16M9 9v11"),
  #|      ),
  #|      @ui.button(
  #|        size=@ui.IconXs,
  #|        attrs=@html.Attrs::build().aria_label("Close"),
  #|        stroke_icon("M18 6 6 18M6 6l12 12"),
  #|      ),
  #|    ],
  #|  )
  #|}
  #|

///|
const FoundationsBadgeCode : String =
  #|@html.div(
  #|  style=[
  #|    "display:flex;min-width:0;flex-wrap:wrap;align-items:center;justify-content:center;gap:0.75rem",
  #|  ],
  #|  [
  #|  @ui.badge("Ready"),
  #|  @ui.badge(variant=@ui.Secondary, "Draft"),
  #|  @ui.badge(variant=@ui.Outline, "v0.2.0"),
  #|  @ui.badge(variant=@ui.Destructive, "Failed"),
  #|  @ui.badge(variant=@ui.Ghost, "Archived"),
  #|    @ui.badge_link(href="#forms", variant=@ui.Link, "Open forms"),
  #|  ],
  #|)
  #|

///|
const FoundationsButtonGroupHorizontalCode : String =
  #|@html.div(
  #|  style=[
  #|    "display:flex;min-width:0;flex-wrap:wrap;align-items:center;justify-content:center;gap:0.75rem",
  #|  ],
  #|  @ui.button_group(aria_label="Release actions", [
  #|    @ui.button(variant=@ui.Outline, "Preview"),
  #|    @ui.button(variant=@ui.Outline, "Publish"),
  #|    @ui.button_group_separator(),
  #|    @ui.button_group_text("v0.2"),
  #|  ]),
  #|)
  #|

///|
const FoundationsButtonGroupVerticalCode : String =
  #|fn stroke_icon(path : String) -> @html.Html {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=[
  #|      "display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none",
  #|    ],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d=path,
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|
  #|fn vertical_button_group_demo() -> @html.Html {
  #|  @html.div(
  #|    style=[
  #|      "display:flex;min-width:0;flex-wrap:wrap;align-items:center;justify-content:center;gap:0.75rem",
  #|    ],
  #|    @ui.button_group(
  #|      orientation=@ui.Vertical,
  #|      aria_label="Canvas zoom",
  #|      [
  #|        @ui.button(
  #|          variant=@ui.Outline,
  #|          size=@ui.IconSm,
  #|          attrs=@html.Attrs::build().aria_label("Zoom in"),
  #|          stroke_icon("M12 5v14M5 12h14"),
  #|        ),
  #|        @ui.button(
  #|          variant=@ui.Outline,
  #|          size=@ui.IconSm,
  #|          attrs=@html.Attrs::build().aria_label("Reset layout"),
  #|          stroke_icon("M4 4h16v16H4zM4 9h16M9 9v11"),
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|

///|
const FoundationsToggleCode : String =
  #|fn toggle_demo() -> @rabbita.Val[@html.Html] {
  #|  let pin = @ui.toggle(
  #|    variant=@ui.Outline,
  #|    size=@ui.Lg,
  #|    aria_label="Pin release",
  #|    "Pin release",
  #|  )
  #|  let watch = @ui.toggle(
  #|    variant=@ui.Default,
  #|    size=@ui.Sm,
  #|    aria_label="Watch release",
  #|    "Watch",
  #|  )
  #|  pin.view2(watch, (pin, watch) => {
  #|    @html.div(
  #|      style=[
  #|        "display:flex;min-width:0;flex-wrap:wrap;align-items:center;justify-content:center;gap:0.75rem",
  #|      ],
  #|      [pin, watch],
  #|    )
  #|  })
  #|}
  #|

///|
const FoundationsToggleGroupSingleCode : String =
  #|fn layout_toggle_group() -> @rabbita.Val[@html.Html] {
  #|  let group = @ui.toggle_group(
  #|    default_values=["grid"],
  #|    variant=@ui.Outline,
  #|    size=@ui.Sm,
  #|    aria_label="Preview layout",
  #|    scope => @html.fragment([
  #|      @ui.toggle_group_item(
  #|        scope~,
  #|        value="list",
  #|        aria_label="List",
  #|        "List",
  #|      ),
  #|      @ui.toggle_group_item(
  #|        scope~,
  #|        value="grid",
  #|        aria_label="Grid",
  #|        "Grid",
  #|      ),
  #|    ]),
  #|  )
  #|  group.view(group => {
  #|    @html.div(
  #|      style=[
  #|        "display:flex;min-width:0;flex-wrap:wrap;align-items:center;justify-content:center;gap:0.75rem",
  #|      ],
  #|      group,
  #|    )
  #|  })
  #|}
  #|

///|
const FoundationsToggleGroupMultipleCode : String =
  #|fn stroke_icon(path : String) -> @html.Html {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=[
  #|      "display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none",
  #|    ],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d=path,
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|
  #|fn formatting_toggle_group() -> @rabbita.Val[@html.Html] {
  #|  let group = @ui.toggle_group(
  #|    default_values=["bold"],
  #|    multiple=true,
  #|    variant=@ui.Default,
  #|    size=@ui.Lg,
  #|    aria_label="Text formatting",
  #|    scope => @html.fragment([
  #|      @ui.toggle_group_item(
  #|        scope~,
  #|        value="bold",
  #|        aria_label="Bold",
  #|        stroke_icon("M6 4h8a4 4 0 0 1 0 8H6zM6 12h9a4 4 0 0 1 0 8H6z"),
  #|      ),
  #|      @ui.toggle_group_item(
  #|        scope~,
  #|        value="italic",
  #|        aria_label="Italic",
  #|        stroke_icon("M19 4h-9M14 20H5M15 4 9 20"),
  #|      ),
  #|      @ui.toggle_group_item(
  #|        scope~,
  #|        value="underline",
  #|        aria_label="Underline",
  #|        stroke_icon("M6 3v7a6 6 0 0 0 12 0V3M4 21h16"),
  #|      ),
  #|    ]),
  #|  )
  #|  group.view(group => {
  #|    @html.div(
  #|      style=[
  #|        "display:flex;min-width:0;flex-wrap:wrap;align-items:center;justify-content:center;gap:0.75rem",
  #|      ],
  #|      group,
  #|    )
  #|  })
  #|}
  #|

///|
const FoundationsLabelCode : String =
  #|@html.div(
  #|  style=[
  #|    "display:grid;width:min(100%,48rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,16rem),1fr));gap:clamp(1.5rem,4vw,3rem);align-items:center",
  #|  ],
  #|  [
  #|    @ui.field([
  #|      @ui.label(for_="foundations-workspace-name", "Workspace name"),
  #|      @ui.input(
  #|        id="foundations-workspace-name",
  #|        placeholder="rabbit-tea",
  #|      ),
  #|    ]),
  #|    @ui.field([
  #|      @ui.label(
  #|        for_="foundations-managed-name",
  #|        disabled=true,
  #|        "Managed name",
  #|      ),
  #|      @ui.input(
  #|        id="foundations-managed-name",
  #|        disabled=true,
  #|        value="Production",
  #|      ),
  #|    ]),
  #|  ],
  #|)
  #|

///|
const FoundationsKbdCode : String =
  #|@html.div(
  #|  style=[
  #|    "display:flex;min-width:0;flex-wrap:wrap;align-items:center;justify-content:center;gap:0.75rem",
  #|  ],
  #|  [
  #|    @ui.kbd_group([@ui.kbd("Ctrl"), @ui.kbd("K")]),
  #|    @ui.kbd_group([@ui.kbd("Shift"), @ui.kbd("P")]),
  #|    @ui.kbd("Escape"),
  #|  ],
  #|)
  #|

///|
const FoundationsSpinnerCode : String =
  #|@html.div(
  #|  style=[
  #|    "display:flex;min-width:0;flex-wrap:wrap;align-items:center;justify-content:center;gap:0.75rem",
  #|  ],
  #|  [
  #|    @html.div(style=["display:flex;flex-wrap:wrap;align-items:center;gap:0.75rem"], [
  #|      @ui.spinner(label="Saving release"),
  #|      @html.span("Saving release metadata"),
  #|    ]),
  #|    @ui.button(disabled=true, [
  #|      @ui.spinner(label="Publishing"),
  #|      @html.span("Publishing"),
  #|    ]),
  #|  ],
  #|)
  #|

///|
const FoundationsSkeletonCode : String =
  #|@html.div(
  #|  style=[
  #|    "display:grid;width:min(100%,28rem);margin-inline:auto;grid-template-columns:auto minmax(0,1fr);gap:0.875rem;align-items:center",
  #|  ],
  #|  [
  #|    @ui.skeleton(style=["width:2.5rem;height:2.5rem;border-radius:9999px"]),
  #|    @html.div(style=["display:flex;flex-direction:column;gap:1rem", "gap:0.5rem"], [
  #|      @ui.skeleton(style=["width:42%;height:0.75rem"]),
  #|      @ui.skeleton(style=["width:100%;height:0.75rem"]),
  #|      @ui.skeleton(style=["width:72%;height:0.75rem"]),
  #|    ]),
  #|  ],
  #|)
  #|

///|
const FoundationsAlertCode : String =
  #|@html.div(
  #|  style=["display:flex;width:min(100%,28rem);margin-inline:auto;flex-direction:column;gap:1rem"],
  #|  [
  #|    @ui.alert([
  #|      @ui.alert_title("Deployment is ready"),
  #|      @ui.alert_description("The preview passed all required checks."),
  #|      @ui.alert_action(@ui.button(variant=@ui.Ghost, size=@ui.Xs, "View")),
  #|    ]),
  #|    @ui.alert(variant=@ui.Destructive, [
  #|      @ui.alert_title("Two checks need attention"),
  #|      @ui.alert_description("Update the package lock before publishing."),
  #|    ]),
  #|  ],
  #|)
  #|

///|
const FoundationsMessageCode : String =
  #|fn check_icon() -> @html.Html {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=[
  #|      "display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none",
  #|    ],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|      @svg.path(
  #|        d="M20 6 9 17l-5-5",
  #|        fill="none",
  #|        stroke="currentColor",
  #|        stroke_width=2,
  #|        attrs=line_attrs,
  #|      ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|
  #|fn message_demo() -> @html.Html {
  #|  @ui.message_group(
  #|    style=[
  #|      "display:flex;width:min(100%,42rem);min-width:0;margin-inline:auto;flex-direction:column;gap:1.5rem",
  #|    ],
  #|    [
  #|      @ui.message([
  #|        @ui.message_avatar(@ui.avatar(@ui.avatar_fallback("YO"))),
  #|        @ui.message_content([
  #|          @ui.message_header("You · 09:41"),
  #|          @ui.bubble_group([
  #|            @ui.bubble(@ui.bubble_content(
  #|              "The native package is ready. Can you review the component gallery?",
  #|            )),
  #|          ]),
  #|          @ui.message_footer("Delivered"),
  #|        ]),
  #|      ]),
  #|      @ui.message(align=@ui.AlignEnd, [
  #|        @ui.message_avatar(@ui.avatar(@ui.avatar_fallback("RA"))),
  #|        @ui.message_content([
  #|          @ui.message_header("Rabbita · 09:42"),
  #|          @ui.bubble_group([
  #|            @ui.bubble(variant=@ui.BubbleSecondary, [
  #|              @ui.bubble_content(
  #|                "Reviewed. The inline styles and native semantics are both visible.",
  #|              ),
  #|              @ui.bubble_reactions(
  #|                attrs=@html.Attrs::build().aria_label("3 approvals"),
  #|                [check_icon(), @html.span("3")],
  #|              ),
  #|            ]),
  #|          ]),
  #|        ]),
  #|      ]),
  #|    ],
  #|  )
  #|}
  #|

///|
const FoundationsBubbleCode : String =
  #|@html.div(
  #|  style=[
  #|    "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,22rem),1fr));gap:1rem;align-items:start",
  #|  ],
  #|  [
  #|    @ui.bubble_group(style=["gap:1rem"], [
  #|      @ui.bubble(align=@ui.AlignEnd, [
  #|        @ui.bubble_content("Default · current-user emphasis"),
  #|      ]),
  #|      @ui.bubble(variant=@ui.BubbleSecondary, [
  #|        @ui.bubble_content("Secondary · neutral conversation"),
  #|      ]),
  #|      @ui.bubble(variant=@ui.BubbleMuted, [
  #|        @ui.bubble_content("Muted · quiet supporting text"),
  #|      ]),
  #|      @ui.bubble(variant=@ui.BubbleTinted, [
  #|        @ui.bubble_content("Tinted · primary-derived surface"),
  #|      ]),
  #|    ]),
  #|    @ui.bubble_group(style=["gap:1rem"], [
  #|      @ui.bubble(variant=@ui.BubbleOutline, [
  #|        @ui.bubble_content_link(
  #|          href="#forms",
  #|          "Outline link · open form controls",
  #|        ),
  #|      ]),
  #|      @ui.bubble(variant=@ui.BubbleGhost, [
  #|        @ui.bubble_content(
  #|          "Ghost · unframed assistant content can span the complete row.",
  #|        ),
  #|      ]),
  #|      @ui.bubble(variant=@ui.BubbleDestructive, [
  #|        @ui.bubble_content(
  #|          "Destructive · an action failed and needs attention.",
  #|        ),
  #|      ]),
  #|    ]),
  #|  ],
  #|)
  #|

///|
const FoundationsChartCode : String =
  #|fn chart_bar(label : String, height : String, color : String) -> @html.Html {
  #|  @html.div(
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    style=[
  #|      "position:relative;height:\{height};min-height:1.25rem;border-radius:0.375rem 0.375rem 0 0;background:\{color}",
  #|    ],
  #|    @html.span(
  #|      style=[
  #|        "position:absolute;top:100%;left:50%;padding-top:0.375rem;color:var(--rui-muted-foreground);font-size:0.625rem;line-height:0.75rem;transform:translateX(-50%)",
  #|      ],
  #|      label,
  #|    ),
  #|  )
  #|}
  #|
  #|fn chart_demo() -> @html.Html {
  #|  @html.div(style=["display:flex;flex-direction:column;gap:1rem"], [
  #|    @html.div(
  #|      style=["display:flex;justify-content:flex-end"],
  #|      @ui.badge(variant=@ui.Outline, "+18.4%"),
  #|    ),
  #|    @ui.chart_style(
  #|      variables=[
  #|        ("stable", "oklch(0.56 0.18 258)"),
  #|        ("preview", "oklch(0.72 0.15 72)"),
  #|      ],
  #|      @html.div(
  #|        style=[
  #|          "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,14rem),1fr));gap:1rem;align-items:center",
  #|        ],
  #|        [
  #|          @ui.chart_container(
  #|            aria_label="Release downloads from Monday through Friday",
  #|            aspect="5 / 2",
  #|            style=[
  #|              "position:relative;display:block;min-height:12rem;border:1px solid var(--rui-border);border-radius:0.625rem;background:linear-gradient(to bottom,color-mix(in oklab,var(--rui-muted) 42%,transparent) 1px,transparent 1px);background-size:100% 25%",
  #|            ],
  #|            [
  #|              @html.div(
  #|                style=[
  #|                  "position:absolute;inset:1rem 0.75rem 1.5rem;display:grid;grid-template-columns:repeat(5,minmax(0,1fr));align-items:end;gap:0.625rem;border-bottom:1px solid var(--rui-border)",
  #|                ],
  #|                [
  #|                  chart_bar("Mon", "42%", "var(--color-stable)"),
  #|                  chart_bar("Tue", "58%", "var(--color-stable)"),
  #|                  chart_bar("Wed", "51%", "var(--color-preview)"),
  #|                  chart_bar("Thu", "76%", "var(--color-stable)"),
  #|                  chart_bar("Fri", "88%", "var(--color-stable)"),
  #|                ],
  #|              ),
  #|            ],
  #|          ),
  #|          @html.div(style=["display:flex;flex-direction:column;gap:1rem"], [
  #|            @ui.chart_tooltip(@ui.chart_tooltip_content([
  #|              @ui.chart_tooltip_label("Friday"),
  #|              @ui.chart_tooltip_item(
  #|                label="Stable",
  #|                value="8,842",
  #|                color="var(--color-stable)",
  #|              ),
  #|              @ui.chart_tooltip_item(
  #|                label="Preview",
  #|                value="1,204",
  #|                color="var(--color-preview)",
  #|                indicator=@ui.ChartDashed,
  #|              ),
  #|            ])),
  #|            @ui.chart_legend_content(
  #|              style=["justify-content:flex-start;padding:0"],
  #|              [
  #|                @ui.chart_legend_item(color="var(--color-stable)", "Stable"),
  #|                @ui.chart_legend_item(color="var(--color-preview)", "Preview"),
  #|              ],
  #|            ),
  #|          ]),
  #|        ],
  #|      ),
  #|    ),
  #|  ])
  #|}
  #|

///|
const FoundationsTableCode : String =
  #|@ui.table([
  #|  @ui.table_caption("Latest verified builds across supported targets"),
  #|  @ui.table_header(@ui.table_row([
  #|    @ui.table_head("Package"),
  #|    @ui.table_head("Target"),
  #|    @ui.table_head("Status"),
  #|    @ui.table_head(
  #|      style=["text-align:right;font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-variant-numeric:tabular-nums"],
  #|      "Tests",
  #|    ),
  #|  ])),
  #|  @ui.table_body([
  #|    @ui.table_row([
  #|      @ui.table_cell("rabbita-ui"),
  #|      @ui.table_cell("JavaScript"),
  #|      @ui.table_cell(@ui.badge("Passing")),
  #|      @ui.table_cell(
  #|        style=["text-align:right;font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-variant-numeric:tabular-nums"],
  #|        "Full suite",
  #|      ),
  #|    ]),
  #|    @ui.table_row([
  #|      @ui.table_cell("rabbita-ui"),
  #|      @ui.table_cell("Native"),
  #|      @ui.table_cell(@ui.badge(variant=@ui.Secondary, "Passing")),
  #|      @ui.table_cell(
  #|        style=["text-align:right;font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-variant-numeric:tabular-nums"],
  #|        "Full suite",
  #|      ),
  #|    ]),
  #|    @ui.table_row([
  #|      @ui.table_cell("showcase"),
  #|      @ui.table_cell("In-app browser"),
  #|      @ui.table_cell(@ui.badge(variant=@ui.Outline, "Replayed")),
  #|      @ui.table_cell(
  #|        style=["text-align:right;font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-variant-numeric:tabular-nums"],
  #|        "Key flows",
  #|      ),
  #|    ]),
  #|  ]),
  #|  @ui.table_footer(@ui.table_row([
  #|    @ui.table_cell(colspan=3, "Automated targets"),
  #|    @ui.table_cell(
  #|      style=["text-align:right;font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-variant-numeric:tabular-nums"],
  #|      "JS + native",
  #|    ),
  #|  ])),
  #|])
  #|

///|
fn foundations_chart_bar(
  label : String,
  height : String,
  color : String,
) -> @html.Html {
  @html.div(
    attrs=@html.Attrs::build().aria_hidden("true"),
    style=[
      "position:relative;height:\{height};min-height:1.25rem;border-radius:0.375rem 0.375rem 0 0;background:\{color}",
    ],
    @html.span(
      style=[
        "position:absolute;top:100%;left:50%;padding-top:0.375rem;color:var(--rui-muted-foreground);font-size:0.625rem;line-height:0.75rem;transform:translateX(-50%)",
      ],
      label,
    ),
  )
}

///|
fn foundations_single_demo(
  title : String,
  description : String,
  variant_title : String,
  variant_description : String,
  body : @html.Html,
  code : String,
  surface : Bool,
  tall : Bool,
) -> @html.Html {
  let variant = if surface { ShowcaseStageSurface } else { ShowcaseStagePlain }
  showcase_component_demos(title, description, [
    showcase_demo_section(
      variant_title,
      variant_description,
      showcase_demo_stage(body, code, variant~, tall~),
    ),
  ])
}

///|
fn foundations_button_demo() -> @html.Html {
  showcase_component_demos(
    "Button",
    "Action controls across the complete Vega variant and size set.",
    [
      showcase_demo_section(
        "Variants",
        "Default, secondary, outline, ghost, destructive, and link treatments.",
        showcase_demo_stage(
          @html.div(style=[FoundationsCenteredRowStyle], [
            @ui.button("Deploy"),
            @ui.button(variant=@ui.Secondary, "Duplicate"),
            @ui.button(variant=@ui.Outline, "Preview"),
            @ui.button(variant=@ui.Ghost, "More"),
            @ui.button(variant=@ui.Destructive, "Remove"),
            @ui.button(variant=@ui.Link, "Documentation"),
          ]),
          FoundationsButtonVariantsCode,
          variant=ShowcaseStageSurface,
        ),
      ),
      showcase_demo_section(
        "Sizes and icons",
        "Four text sizes and four icon-only sizes preserve the same interaction feedback.",
        showcase_demo_stage(
          @html.div(style=[FoundationsCenteredRowStyle], [
            @ui.button(size=@ui.Lg, "Large"),
            @ui.button(size=@ui.Default, "Default"),
            @ui.button(size=@ui.Sm, "Small"),
            @ui.button(size=@ui.Xs, "Extra small"),
            @ui.button(
              size=@ui.IconLg,
              attrs=@html.Attrs::build().aria_label("Add large item"),
              showcase_plus_icon(),
            ),
            @ui.button(
              size=@ui.Icon,
              attrs=@html.Attrs::build().aria_label("Open settings"),
              showcase_settings_icon(),
            ),
            @ui.button(
              size=@ui.IconSm,
              attrs=@html.Attrs::build().aria_label("Change layout"),
              showcase_layout_icon(),
            ),
            @ui.button(
              size=@ui.IconXs,
              attrs=@html.Attrs::build().aria_label("Close"),
              showcase_close_icon(),
            ),
          ]),
          FoundationsButtonSizesCode,
          variant=ShowcaseStageSurface,
        ),
      ),
    ],
  )
}

///|
fn foundations_badge_demo() -> @html.Html {
  foundations_single_demo(
    "Badge",
    "Compact status labels and a semantic link treatment.",
    "Variants and link",
    "Default, secondary, outline, destructive, ghost, and link treatments.",
    @html.div(style=[FoundationsCenteredRowStyle], [
      @ui.badge("Ready"),
      @ui.badge(variant=@ui.Secondary, "Draft"),
      @ui.badge(variant=@ui.Outline, "v0.2.0"),
      @ui.badge(variant=@ui.Destructive, "Failed"),
      @ui.badge(variant=@ui.Ghost, "Archived"),
      @ui.badge_link(href="#forms", variant=@ui.Link, "Open forms"),
    ]),
    FoundationsBadgeCode,
    true,
    false,
  )
}

///|
fn foundations_button_group_demo() -> @html.Html {
  showcase_component_demos(
    "Button Group",
    "Related actions merge borders and corners while keeping native button behavior.",
    [
      showcase_demo_section(
        "Horizontal",
        "Actions, a separator, and supporting text share one contiguous row.",
        showcase_demo_stage(
          @html.div(
            style=[FoundationsCenteredRowStyle],
            @ui.button_group(aria_label="Release actions", [
              @ui.button(variant=@ui.Outline, "Preview"),
              @ui.button(variant=@ui.Outline, "Publish"),
              @ui.button_group_separator(),
              @ui.button_group_text("v0.2"),
            ]),
          ),
          FoundationsButtonGroupHorizontalCode,
          variant=ShowcaseStageSurface,
        ),
      ),
      showcase_demo_section(
        "Vertical",
        "Icon actions stack without duplicating their adjoining borders.",
        showcase_demo_stage(
          @html.div(
            style=[FoundationsCenteredRowStyle],
            @ui.button_group(
              orientation=@ui.Vertical,
              aria_label="Canvas zoom",
              [
                @ui.button(
                  variant=@ui.Outline,
                  size=@ui.IconSm,
                  attrs=@html.Attrs::build().aria_label("Zoom in"),
                  showcase_plus_icon(),
                ),
                @ui.button(
                  variant=@ui.Outline,
                  size=@ui.IconSm,
                  attrs=@html.Attrs::build().aria_label("Reset layout"),
                  showcase_layout_icon(),
                ),
              ],
            ),
          ),
          FoundationsButtonGroupVerticalCode,
          variant=ShowcaseStageSurface,
        ),
      ),
    ],
  )
}

///|
fn foundations_toggle_demo(
  pin_html : @html.Html,
  watch_html : @html.Html,
) -> @html.Html {
  foundations_single_demo(
    "Toggle",
    "A black-box pressed control with default, outline, and size variants.",
    "Variants and sizes",
    "Both controls keep their pressed state inside the Toggle component.",
    @html.div(style=[FoundationsCenteredRowStyle], [pin_html, watch_html]),
    FoundationsToggleCode,
    true,
    false,
  )
}

///|
fn foundations_toggle_group_demo(
  density_html : @html.Html,
  formatting_html : @html.Html,
) -> @html.Html {
  showcase_component_demos(
    "Toggle Group",
    "Single- and multi-selection groups own selection and roving keyboard focus.",
    [
      showcase_demo_section(
        "Single selection",
        "Choose one preview layout from a compact outline group.",
        showcase_demo_stage(
          @html.div(style=[FoundationsCenteredRowStyle], density_html),
          FoundationsToggleGroupSingleCode,
          variant=ShowcaseStageSurface,
        ),
      ),
      showcase_demo_section(
        "Multiple selection",
        "Formatting actions can be combined independently.",
        showcase_demo_stage(
          @html.div(style=[FoundationsCenteredRowStyle], formatting_html),
          FoundationsToggleGroupMultipleCode,
          variant=ShowcaseStageSurface,
        ),
      ),
    ],
  )
}

///|
fn foundations_label_demo() -> @html.Html {
  foundations_single_demo(
    "Label",
    "Native labels preserve explicit control relationships and disabled styling.",
    "Default and disabled",
    "The label remains associated with its input in both availability states.",
    @html.div(style=[FoundationsControlGridStyle], [
      @ui.field([
        @ui.label(for_="foundations-workspace-name", "Workspace name"),
        @ui.input(id="foundations-workspace-name", placeholder="rabbit-tea"),
      ]),
      @ui.field([
        @ui.label(
          for_="foundations-managed-name",
          disabled=true,
          "Managed name",
        ),
        @ui.input(
          id="foundations-managed-name",
          disabled=true,
          value="Production",
        ),
      ]),
    ]),
    FoundationsLabelCode,
    true,
    false,
  )
}

///|
fn foundations_kbd_demo() -> @html.Html {
  foundations_single_demo(
    "Kbd",
    "Keyboard input is rendered as single keys or compact shortcut groups.",
    "Keys and shortcuts",
    "Long key names and multi-key commands share the same compact rhythm.",
    @html.div(style=[FoundationsCenteredRowStyle], [
      @ui.kbd_group([@ui.kbd("Ctrl"), @ui.kbd("K")]),
      @ui.kbd_group([@ui.kbd("Shift"), @ui.kbd("P")]),
      @ui.kbd("Escape"),
    ]),
    FoundationsKbdCode,
    true,
    false,
  )
}

///|
fn foundations_spinner_demo() -> @html.Html {
  foundations_single_demo(
    "Spinner",
    "A CSS-animated status indicator works inline or inside an action.",
    "Inline and action",
    "Motion follows reduced-motion preferences without runtime animation state.",
    @html.div(style=[FoundationsCenteredRowStyle], [
      @html.div(style=[RowStyle], [
        @ui.spinner(label="Saving release"),
        @html.span("Saving release metadata"),
      ]),
      @ui.button(disabled=true, [
        @ui.spinner(label="Publishing"),
        @html.span("Publishing"),
      ]),
    ]),
    FoundationsSpinnerCode,
    true,
    false,
  )
}

///|
fn foundations_skeleton_demo() -> @html.Html {
  foundations_single_demo(
    "Skeleton",
    "Pulse placeholders preserve the shape of content that is still loading.",
    "Profile placeholder",
    "Avatar and text placeholders form one borderless loading composition.",
    @html.div(style=[FoundationsSkeletonProfileStyle], [
      @ui.skeleton(style=["width:2.5rem;height:2.5rem;border-radius:9999px"]),
      @html.div(style=[StackStyle, "gap:0.5rem"], [
        @ui.skeleton(style=["width:42%;height:0.75rem"]),
        @ui.skeleton(style=["width:100%;height:0.75rem"]),
        @ui.skeleton(style=["width:72%;height:0.75rem"]),
      ]),
    ]),
    FoundationsSkeletonCode,
    true,
    false,
  )
}

///|
fn foundations_alert_demo() -> @html.Html {
  foundations_single_demo(
    "Alert",
    "Semantic live regions with default and destructive treatments.",
    "Default and destructive",
    "An optional action shares the same grid without changing alert semantics.",
    @html.div(style=[FoundationsNarrowStackStyle], [
      @ui.alert([
        @ui.alert_title("Deployment is ready"),
        @ui.alert_description("The preview passed all required checks."),
        @ui.alert_action(@ui.button(variant=@ui.Ghost, size=@ui.Xs, "View")),
      ]),
      @ui.alert(variant=@ui.Destructive, [
        @ui.alert_title("Two checks need attention"),
        @ui.alert_description("Update the package lock before publishing."),
      ]),
    ]),
    FoundationsAlertCode,
    false,
    false,
  )
}

///|
fn foundations_message_demo() -> @html.Html {
  foundations_single_demo(
    "Message",
    "Conversation rows compose avatar, alignment, metadata, and Bubble surfaces.",
    "Start and end alignment",
    "Sender and receiver rows keep avatars, headers, and delivery metadata aligned.",
    @ui.message_group(
      style=[
        "display:flex;width:min(100%,42rem);min-width:0;margin-inline:auto;flex-direction:column;gap:1.5rem",
      ],
      [
        @ui.message([
          @ui.message_avatar(@ui.avatar(@ui.avatar_fallback("YO"))),
          @ui.message_content([
            @ui.message_header("You · 09:41"),
            @ui.bubble_group([
              @ui.bubble(
                @ui.bubble_content(
                  "The native package is ready. Can you review the component gallery?",
                ),
              ),
            ]),
            @ui.message_footer("Delivered"),
          ]),
        ]),
        @ui.message(align=@ui.AlignEnd, [
          @ui.message_avatar(@ui.avatar(@ui.avatar_fallback("RA"))),
          @ui.message_content([
            @ui.message_header("Rabbita · 09:42"),
            @ui.bubble_group([
              @ui.bubble(variant=@ui.BubbleSecondary, [
                @ui.bubble_content(
                  "Reviewed. The inline styles and native semantics are both visible.",
                ),
                @ui.bubble_reactions(
                  attrs=@html.Attrs::build().aria_label("3 approvals"),
                  [showcase_check_icon(), @html.span("3")],
                ),
              ]),
            ]),
          ]),
        ]),
      ],
    ),
    FoundationsMessageCode,
    true,
    true,
  )
}

///|
fn foundations_bubble_demo() -> @html.Html {
  foundations_single_demo(
    "Bubble",
    "All seven Vega treatments share root-owned color, alignment, focus, hover, and press states.",
    "Variants",
    "Default, secondary, muted, tinted, outline, ghost, and destructive surfaces.",
    @html.div(style=[GridStyle, "align-items:start"], [
      @ui.bubble_group(style=["gap:1rem"], [
        @ui.bubble(align=@ui.AlignEnd, [
          @ui.bubble_content("Default · current-user emphasis"),
        ]),
        @ui.bubble(variant=@ui.BubbleSecondary, [
          @ui.bubble_content("Secondary · neutral conversation"),
        ]),
        @ui.bubble(variant=@ui.BubbleMuted, [
          @ui.bubble_content("Muted · quiet supporting text"),
        ]),
        @ui.bubble(variant=@ui.BubbleTinted, [
          @ui.bubble_content("Tinted · primary-derived surface"),
        ]),
      ]),
      @ui.bubble_group(style=["gap:1rem"], [
        @ui.bubble(variant=@ui.BubbleOutline, [
          @ui.bubble_content_link(
            href="#forms",
            "Outline link · open form controls",
          ),
        ]),
        @ui.bubble(variant=@ui.BubbleGhost, [
          @ui.bubble_content(
            "Ghost · unframed assistant content can span the complete row.",
          ),
        ]),
        @ui.bubble(variant=@ui.BubbleDestructive, [
          @ui.bubble_content(
            "Destructive · an action failed and needs attention.",
          ),
        ]),
      ]),
    ]),
    FoundationsBubbleCode,
    true,
    true,
  )
}

///|
fn foundations_chart_demo() -> @html.Html {
  foundations_single_demo(
    "Chart",
    "Chart primitives wrap application-owned marks, legends, and tooltip content.",
    "Container, tooltip, and legend",
    "Theme variables flow through the plot and its supporting content.",
    @html.div(style=[StackStyle], [
      @html.div(
        style=["display:flex;justify-content:flex-end"],
        @ui.badge(variant=@ui.Outline, "+18.4%"),
      ),
      @ui.chart_style(
        variables=[
          ("stable", "oklch(0.56 0.18 258)"),
          ("preview", "oklch(0.72 0.15 72)"),
        ],
        @html.div(
          style=[
            "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,14rem),1fr));gap:1rem;align-items:center",
          ],
          [
            @ui.chart_container(
              aria_label="Release downloads from Monday through Friday",
              aspect="5 / 2",
              style=[
                "position:relative;display:block;min-height:12rem;border:1px solid var(--rui-border);border-radius:0.625rem;background:linear-gradient(to bottom,color-mix(in oklab,var(--rui-muted) 42%,transparent) 1px,transparent 1px);background-size:100% 25%",
              ],
              [
                @html.div(style=[FoundationsChartPlotStyle], [
                  foundations_chart_bar("Mon", "42%", "var(--color-stable)"),
                  foundations_chart_bar("Tue", "58%", "var(--color-stable)"),
                  foundations_chart_bar("Wed", "51%", "var(--color-preview)"),
                  foundations_chart_bar("Thu", "76%", "var(--color-stable)"),
                  foundations_chart_bar("Fri", "88%", "var(--color-stable)"),
                ]),
              ],
            ),
            @html.div(style=[StackStyle], [
              @ui.chart_tooltip(
                @ui.chart_tooltip_content([
                  @ui.chart_tooltip_label("Friday"),
                  @ui.chart_tooltip_item(
                    label="Stable",
                    value="8,842",
                    color="var(--color-stable)",
                  ),
                  @ui.chart_tooltip_item(
                    label="Preview",
                    value="1,204",
                    color="var(--color-preview)",
                    indicator=@ui.ChartDashed,
                  ),
                ]),
              ),
              @ui.chart_legend_content(
                style=["justify-content:flex-start;padding:0"],
                [
                  @ui.chart_legend_item(color="var(--color-stable)", "Stable"),
                  @ui.chart_legend_item(color="var(--color-preview)", "Preview"),
                ],
              ),
            ]),
          ],
        ),
      ),
    ]),
    FoundationsChartCode,
    false,
    true,
  )
}

///|
fn foundations_table_demo() -> @html.Html {
  foundations_single_demo(
    "Table",
    "A native table with caption, header, body, and summary footer.",
    "Complete table",
    "A caption and footer preserve context around dense row data.",
    @ui.table([
      @ui.table_caption("Latest verified builds across supported targets"),
      @ui.table_header(
        @ui.table_row([
          @ui.table_head("Package"),
          @ui.table_head("Target"),
          @ui.table_head("Status"),
          @ui.table_head(style=[FoundationsTableNumberStyle], "Tests"),
        ]),
      ),
      @ui.table_body([
        @ui.table_row([
          @ui.table_cell("rabbita-ui"),
          @ui.table_cell("JavaScript"),
          @ui.table_cell(@ui.badge("Passing")),
          @ui.table_cell(style=[FoundationsTableNumberStyle], "Full suite"),
        ]),
        @ui.table_row([
          @ui.table_cell("rabbita-ui"),
          @ui.table_cell("Native"),
          @ui.table_cell(@ui.badge(variant=@ui.Secondary, "Passing")),
          @ui.table_cell(style=[FoundationsTableNumberStyle], "Full suite"),
        ]),
        @ui.table_row([
          @ui.table_cell("showcase"),
          @ui.table_cell("In-app browser"),
          @ui.table_cell(@ui.badge(variant=@ui.Outline, "Replayed")),
          @ui.table_cell(style=[FoundationsTableNumberStyle], "Key flows"),
        ]),
      ]),
      @ui.table_footer(
        @ui.table_row([
          @ui.table_cell(colspan=3, "Automated targets"),
          @ui.table_cell(style=[FoundationsTableNumberStyle], "JS + native"),
        ]),
      ),
    ]),
    FoundationsTableCode,
    false,
    true,
  )
}

///|
fn foundations_gallery_view(
  pin_html : @html.Html,
  watch_html : @html.Html,
  density_html : @html.Html,
  formatting_html : @html.Html,
  data_table_html : @html.Html,
) -> @html.Html {
  @html.div(style=[FoundationsGalleryStyle], [
    @html.section(style=[FoundationsSectionStyle], [
      foundations_button_demo(),
      foundations_badge_demo(),
      foundations_button_group_demo(),
      foundations_toggle_demo(pin_html, watch_html),
      foundations_toggle_group_demo(density_html, formatting_html),
      foundations_label_demo(),
      foundations_kbd_demo(),
      foundations_spinner_demo(),
      foundations_skeleton_demo(),
      foundations_identity_variants(),
    ]),
    @html.section(style=[FoundationsSectionStyle], [
      foundations_alert_demo(),
      foundations_message_demo(),
      foundations_bubble_demo(),
      foundations_chart_demo(),
      foundations_table_demo(),
      foundations_data_variants(data_table_html),
    ]),
  ])
}

///|
fn foundations_gallery() -> @rabbita.Val[@html.Html] {
  let pin_view = @ui.toggle(
    variant=@ui.Outline,
    size=@ui.Lg,
    aria_label="Pin release",
    "Pin release",
  )
  let watch_view = @ui.toggle(
    variant=@ui.Default,
    size=@ui.Sm,
    aria_label="Watch release",
    "Watch",
  )
  let density_view = @ui.toggle_group(
    default_values=["grid"],
    variant=@ui.Outline,
    size=@ui.Sm,
    aria_label="Preview layout",
    scope => {
      @html.fragment([
        @ui.toggle_group_item(scope~, value="list", aria_label="List", "List"),
        @ui.toggle_group_item(scope~, value="grid", aria_label="Grid", "Grid"),
      ])
    },
  )
  let formatting_view = @ui.toggle_group(
    default_values=["bold"],
    multiple=true,
    variant=@ui.Default,
    size=@ui.Lg,
    aria_label="Text formatting",
    scope => {
      @html.fragment([
        @ui.toggle_group_item(
          scope~,
          value="bold",
          aria_label="Bold",
          showcase_bold_icon(),
        ),
        @ui.toggle_group_item(
          scope~,
          value="italic",
          aria_label="Italic",
          showcase_italic_icon(),
        ),
        @ui.toggle_group_item(
          scope~,
          value="underline",
          aria_label="Underline",
          showcase_underline_icon(),
        ),
      ])
    },
  )
  let data_table_view = fdv_data_table_view()
  pin_view.view5(watch_view, density_view, formatting_view, data_table_view, (
    pin_html,
    watch_html,
    density_html,
    formatting_html,
    data_table_html,
  ) => {
    foundations_gallery_view(
      pin_html, watch_html, density_html, formatting_html, data_table_html,
    )
  })
}
