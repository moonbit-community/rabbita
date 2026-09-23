///|
const FoundationsCenteredRowStyle : String = "display:flex;min-width:0;flex-wrap:wrap;align-items:center;justify-content:center;gap:0.75rem"

///|
const FoundationsNarrowStackStyle : String = "display:flex;width:min(100%,28rem);margin-inline:auto;flex-direction:column;gap:1rem"

///|
const FoundationsChartPlotStyle : String = "position:absolute;inset:1rem 0.75rem 1.5rem;display:grid;grid-template-columns:repeat(5,minmax(0,1fr));align-items:end;gap:0.625rem;border-bottom:1px solid var(--rui-border)"

///|
const FoundationsTableNumberStyle : String = "text-align:right;font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-variant-numeric:tabular-nums"

///|
const FoundationsStrokeIconCode : String =
  #|fn stroke_icon(path : String) -> @html.Html {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=["display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none"],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [@svg.path(
  #|        d=path,
  #|        fill="none",
  #|        stroke="currentColor",
  #|        stroke_width=2,
  #|        attrs=line_attrs,
  #|      )],
  #|    ),
  #|  )
  #|}
  #|

///|
const FoundationsButtonDefaultCode : String =
  #|@rui.button("Deploy")
  #|

///|
const FoundationsButtonSecondaryCode : String =
  #|@rui.button(variant=@rui.Secondary, "Duplicate")
  #|

///|
const FoundationsButtonOutlineCode : String =
  #|@rui.button(variant=@rui.Outline, "Preview")
  #|

///|
const FoundationsButtonGhostCode : String =
  #|@rui.button(variant=@rui.Ghost, "More")
  #|

///|
const FoundationsButtonDestructiveCode : String =
  #|@rui.button(variant=@rui.Destructive, "Remove")
  #|

///|
const FoundationsButtonLinkCode : String =
  #|@rui.button(variant=@rui.Link, "Documentation")
  #|

///|
const FoundationsButtonLargeCode : String =
  #|@rui.button(size=@rui.Lg, "Large")
  #|

///|
const FoundationsButtonDefaultSizeCode : String =
  #|@rui.button(size=@rui.Default, "Default")
  #|

///|
const FoundationsButtonSmallCode : String =
  #|@rui.button(size=@rui.Sm, "Small")
  #|

///|
const FoundationsButtonExtraSmallCode : String =
  #|@rui.button(size=@rui.Xs, "Extra small")
  #|

///|
const FoundationsButtonIconLargeCode : String = FoundationsStrokeIconCode +
  (
    #|@rui.button(
    #|  size=@rui.IconLg,
    #|  attrs=@html.Attrs::build().aria_label("Add large item"),
    #|  stroke_icon("M12 5v14M5 12h14"),
    #|)
    #|
  )

///|
const FoundationsButtonIconCode : String = FoundationsStrokeIconCode +
  (
    #|@rui.button(
    #|  size=@rui.Icon,
    #|  attrs=@html.Attrs::build().aria_label("Open settings"),
    #|  stroke_icon("M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.38a2 2 0 0 0-.73-2.73l-.15-.09a2 2 0 0 1-1-1.74v-.51a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2zM12 15.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Z"),
    #|)
    #|
  )

///|
const FoundationsButtonIconSmallCode : String = FoundationsStrokeIconCode +
  (
    #|@rui.button(
    #|  size=@rui.IconSm,
    #|  attrs=@html.Attrs::build().aria_label("Change layout"),
    #|  stroke_icon("M4 4h16v16H4zM4 9h16M9 9v11"),
    #|)
    #|
  )

///|
const FoundationsButtonIconExtraSmallCode : String = FoundationsStrokeIconCode +
  (
    #|@rui.button(
    #|  size=@rui.IconXs,
    #|  attrs=@html.Attrs::build().aria_label("Close"),
    #|  stroke_icon("M18 6 6 18M6 6l12 12"),
    #|)
    #|
  )

///|
const FoundationsBadgeDefaultCode : String =
  #|@rui.badge("Ready")
  #|

///|
const FoundationsBadgeSecondaryCode : String =
  #|@rui.badge(variant=@rui.Secondary, "Draft")
  #|

///|
const FoundationsBadgeOutlineCode : String =
  #|@rui.badge(variant=@rui.Outline, "v0.2.0")
  #|

///|
const FoundationsBadgeDestructiveCode : String =
  #|@rui.badge(variant=@rui.Destructive, "Failed")
  #|

///|
const FoundationsBadgeGhostCode : String =
  #|@rui.badge(variant=@rui.Ghost, "Archived")
  #|

///|
const FoundationsBadgeLinkCode : String =
  #|@rui.badge_link(href="#forms", variant=@rui.Link, "Open forms")
  #|

///|
const FoundationsButtonGroupHorizontalCode : String =
  #|@html.div(
  #|  style=[
  #|    "display:flex;min-width:0;flex-wrap:wrap;align-items:center;justify-content:center;gap:0.75rem",
  #|  ],
  #|  @rui.button_group(aria_label="Release actions", [
  #|    @rui.button(variant=@rui.Outline, "Preview"),
  #|    @rui.button(variant=@rui.Outline, "Publish"),
  #|    @rui.button_group_separator(),
  #|    @rui.button_group_text("v0.2"),
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
  #|    @rui.button_group(
  #|      orientation=@rui.Vertical,
  #|      aria_label="Canvas zoom",
  #|      [
  #|        @rui.button(
  #|          variant=@rui.Outline,
  #|          size=@rui.IconSm,
  #|          attrs=@html.Attrs::build().aria_label("Zoom in"),
  #|          stroke_icon("M12 5v14M5 12h14"),
  #|        ),
  #|        @rui.button(
  #|          variant=@rui.Outline,
  #|          size=@rui.IconSm,
  #|          attrs=@html.Attrs::build().aria_label("Reset layout"),
  #|          stroke_icon("M4 4h16v16H4zM4 9h16M9 9v11"),
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|

///|
const FoundationsToggleOutlineLargeCode : String =
  #|@rui.toggle(
  #|  variant=@rui.Outline,
  #|  size=@rui.Lg,
  #|  aria_label="Pin release",
  #|  "Pin release",
  #|)
  #|

///|
const FoundationsToggleDefaultSmallCode : String =
  #|@rui.toggle(
  #|  variant=@rui.Default,
  #|  size=@rui.Sm,
  #|  aria_label="Watch release",
  #|  "Watch",
  #|)
  #|

///|
const FoundationsToggleGroupSingleCode : String =
  #|fn layout_toggle_group() -> @rabbita.Val[@html.Html] {
  #|  let group = @rui.toggle_group(
  #|    default_values=["grid"],
  #|    variant=@rui.Outline,
  #|    size=@rui.Sm,
  #|    aria_label="Preview layout",
  #|    scope => @html.fragment([
  #|      @rui.toggle_group_item(
  #|        scope~,
  #|        value="list",
  #|        aria_label="List",
  #|        "List",
  #|      ),
  #|      @rui.toggle_group_item(
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
  #|  let group = @rui.toggle_group(
  #|    default_values=["bold"],
  #|    multiple=true,
  #|    variant=@rui.Default,
  #|    size=@rui.Lg,
  #|    aria_label="Text formatting",
  #|    scope => @html.fragment([
  #|      @rui.toggle_group_item(
  #|        scope~,
  #|        value="bold",
  #|        aria_label="Bold",
  #|        stroke_icon("M6 4h8a4 4 0 0 1 0 8H6zM6 12h9a4 4 0 0 1 0 8H6z"),
  #|      ),
  #|      @rui.toggle_group_item(
  #|        scope~,
  #|        value="italic",
  #|        aria_label="Italic",
  #|        stroke_icon("M19 4h-9M14 20H5M15 4 9 20"),
  #|      ),
  #|      @rui.toggle_group_item(
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
const FoundationsLabelDefaultCode : String =
  #|@rui.field([
  #|  @rui.label(for_="workspace-name", "Workspace name"),
  #|  @rui.input(id="workspace-name", placeholder="rabbit-tea"),
  #|])
  #|

///|
const FoundationsLabelDisabledCode : String =
  #|@rui.field([
  #|  @rui.label(for_="managed-name", disabled=true, "Managed name"),
  #|  @rui.input(id="managed-name", disabled=true, value="Production"),
  #|])
  #|

///|
const FoundationsKbdKeyCode : String =
  #|@rui.kbd("Escape")
  #|

///|
const FoundationsKbdShortcutCode : String =
  #|@rui.kbd_group([@rui.kbd("Ctrl"), @rui.kbd("K")])
  #|

///|
const FoundationsSpinnerInlineCode : String =
  #|@html.div(style=["display:flex;flex-wrap:wrap;align-items:center;gap:0.75rem"], [
  #|  @rui.spinner(label="Saving release"),
  #|  @html.span("Saving release metadata"),
  #|])
  #|

///|
const FoundationsSpinnerButtonCode : String =
  #|@rui.button(disabled=true, [
  #|  @rui.spinner(label="Publishing"),
  #|  @html.span("Publishing"),
  #|])
  #|

///|
const FoundationsAlertDefaultCode : String =
  #|@rui.alert([
  #|  @rui.alert_title("Deployment is ready"),
  #|  @rui.alert_description("The preview passed all required checks."),
  #|  @rui.alert_action(@rui.button(variant=@rui.Ghost, size=@rui.Xs, "View")),
  #|])
  #|

///|
const FoundationsAlertDestructiveCode : String =
  #|@rui.alert(variant=@rui.Destructive, [
  #|  @rui.alert_title("Two checks need attention"),
  #|  @rui.alert_description("Update the package lock before publishing."),
  #|])
  #|

///|
const FoundationsMessageStartCode : String =
  #|@rui.message_group(
  #|  style=[
  #|    "display:flex;width:min(100%,42rem);min-width:0;margin-inline:auto;flex-direction:column",
  #|  ],
  #|  [
  #|    @rui.message([
  #|      @rui.message_avatar(@rui.avatar(@rui.avatar_fallback("YO"))),
  #|      @rui.message_content([
  #|        @rui.message_header("You · 09:41"),
  #|        @rui.bubble_group([
  #|          @rui.bubble(@rui.bubble_content(
  #|            "The native package is ready. Can you review the component gallery?",
  #|          )),
  #|        ]),
  #|        @rui.message_footer("Delivered"),
  #|      ]),
  #|    ]),
  #|  ],
  #|)
  #|

///|
const FoundationsMessageEndCode : String =
  #|@rui.message_group(
  #|  style=[
  #|    "display:flex;width:min(100%,42rem);min-width:0;margin-inline:auto;flex-direction:column",
  #|  ],
  #|  [
  #|    @rui.message(align=@rui.AlignEnd, [
  #|      @rui.message_avatar(@rui.avatar(@rui.avatar_fallback("RA"))),
  #|      @rui.message_content([
  #|        @rui.message_header("Rabbita · 09:42"),
  #|        @rui.bubble_group([
  #|          @rui.bubble(variant=@rui.BubbleSecondary, [
  #|            @rui.bubble_content(
  #|              "Reviewed. The inline styles and native semantics are both visible.",
  #|            ),
  #|          ]),
  #|        ]),
  #|      ]),
  #|    ]),
  #|  ],
  #|)
  #|

///|
const FoundationsBubbleDefaultCode : String =
  #|@rui.bubble(align=@rui.AlignEnd, [
  #|  @rui.bubble_content("Default · current-user emphasis"),
  #|])
  #|

///|
const FoundationsBubbleSecondaryCode : String =
  #|@rui.bubble(variant=@rui.BubbleSecondary, [
  #|  @rui.bubble_content("Secondary · neutral conversation"),
  #|])
  #|

///|
const FoundationsBubbleMutedCode : String =
  #|@rui.bubble(variant=@rui.BubbleMuted, [
  #|  @rui.bubble_content("Muted · quiet supporting text"),
  #|])
  #|

///|
const FoundationsBubbleTintedCode : String =
  #|@rui.bubble(variant=@rui.BubbleTinted, [
  #|  @rui.bubble_content("Tinted · primary-derived surface"),
  #|])
  #|

///|
const FoundationsBubbleOutlineCode : String =
  #|@rui.bubble(variant=@rui.BubbleOutline, [
  #|  @rui.bubble_content_link(href="#forms", "Open form controls"),
  #|])
  #|

///|
const FoundationsBubbleGhostCode : String =
  #|@rui.bubble(variant=@rui.BubbleGhost, [
  #|  @rui.bubble_content("Ghost · unframed assistant content."),
  #|])
  #|

///|
const FoundationsBubbleDestructiveCode : String =
  #|@rui.bubble(variant=@rui.BubbleDestructive, [
  #|  @rui.bubble_content("Destructive · an action failed."),
  #|])
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
  #|      @rui.badge(variant=@rui.Outline, "+18.4%"),
  #|    ),
  #|    @rui.chart_style(
  #|      variables=[
  #|        ("stable", "oklch(0.56 0.18 258)"),
  #|        ("preview", "oklch(0.72 0.15 72)"),
  #|      ],
  #|      @html.div(
  #|        style=[
  #|          "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,14rem),1fr));gap:1rem;align-items:center",
  #|        ],
  #|        [
  #|          @rui.chart_container(
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
  #|            @rui.chart_tooltip(@rui.chart_tooltip_content([
  #|              @rui.chart_tooltip_label("Friday"),
  #|              @rui.chart_tooltip_item(
  #|                label="Stable",
  #|                value="8,842",
  #|                color="var(--color-stable)",
  #|              ),
  #|              @rui.chart_tooltip_item(
  #|                label="Preview",
  #|                value="1,204",
  #|                color="var(--color-preview)",
  #|                indicator=@rui.ChartDashed,
  #|              ),
  #|            ])),
  #|            @rui.chart_legend_content(
  #|              style=["justify-content:flex-start;padding:0"],
  #|              [
  #|                @rui.chart_legend_item(color="var(--color-stable)", "Stable"),
  #|                @rui.chart_legend_item(color="var(--color-preview)", "Preview"),
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
  #|@rui.table([
  #|  @rui.table_caption("Latest verified builds across supported targets"),
  #|  @rui.table_header(@rui.table_row([
  #|    @rui.table_head("Package"),
  #|    @rui.table_head("Target"),
  #|    @rui.table_head("Status"),
  #|    @rui.table_head(
  #|      style=["text-align:right;font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-variant-numeric:tabular-nums"],
  #|      "Tests",
  #|    ),
  #|  ])),
  #|  @rui.table_body([
  #|    @rui.table_row([
  #|      @rui.table_cell("rui"),
  #|      @rui.table_cell("JavaScript"),
  #|      @rui.table_cell(@rui.badge("Passing")),
  #|      @rui.table_cell(
  #|        style=["text-align:right;font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-variant-numeric:tabular-nums"],
  #|        "Full suite",
  #|      ),
  #|    ]),
  #|    @rui.table_row([
  #|      @rui.table_cell("rui"),
  #|      @rui.table_cell("Native"),
  #|      @rui.table_cell(@rui.badge(variant=@rui.Secondary, "Passing")),
  #|      @rui.table_cell(
  #|        style=["text-align:right;font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-variant-numeric:tabular-nums"],
  #|        "Full suite",
  #|      ),
  #|    ]),
  #|    @rui.table_row([
  #|      @rui.table_cell("showcase"),
  #|      @rui.table_cell("In-app browser"),
  #|      @rui.table_cell(@rui.badge(variant=@rui.Outline, "Replayed")),
  #|      @rui.table_cell(
  #|        style=["text-align:right;font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-variant-numeric:tabular-nums"],
  #|        "Key flows",
  #|      ),
  #|    ]),
  #|  ]),
  #|  @rui.table_footer(@rui.table_row([
  #|    @rui.table_cell(colspan=3, "Automated targets"),
  #|    @rui.table_cell(
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
fn foundations_centered_section(
  title : String,
  description : String,
  body : @html.Html,
  code : String,
  surface? : Bool = true,
) -> ShowcaseDemoEntry {
  let variant = if surface { ShowcaseStageSurface } else { ShowcaseStagePlain }
  showcase_demo_section(
    title,
    description,
    showcase_demo_stage(
      @html.div(style=[FoundationsCenteredRowStyle], body),
      code,
      variant~,
    ),
  )
}

///|
fn foundations_button_demo() -> @html.Html {
  showcase_component_demos(
    "Button",
    "Action controls across the compact shadcn/ui Nova variants and sizes.",
    [
      foundations_centered_section(
        "Default",
        "Primary action.",
        @rui.button("Deploy"),
        FoundationsButtonDefaultCode,
      ),
      foundations_centered_section(
        "Secondary",
        "Lower-emphasis action.",
        @rui.button(variant=Secondary, "Duplicate"),
        FoundationsButtonSecondaryCode,
      ),
      foundations_centered_section(
        "Outline",
        "Bordered action.",
        @rui.button(variant=Outline, "Preview"),
        FoundationsButtonOutlineCode,
      ),
      foundations_centered_section(
        "Ghost",
        "Unframed action.",
        @rui.button(variant=Ghost, "More"),
        FoundationsButtonGhostCode,
      ),
      foundations_centered_section(
        "Destructive",
        "Destructive action.",
        @rui.button(variant=Destructive, "Remove"),
        FoundationsButtonDestructiveCode,
      ),
      foundations_centered_section(
        "Link",
        "Action styled as a link.",
        @rui.button(variant=Link, "Documentation"),
        FoundationsButtonLinkCode,
      ),
      foundations_centered_section(
        "Large",
        "Large text button.",
        @rui.button(size=Lg, "Large"),
        FoundationsButtonLargeCode,
      ),
      foundations_centered_section(
        "Default size",
        "Default text-button size.",
        @rui.button(size=Default, "Default"),
        FoundationsButtonDefaultSizeCode,
      ),
      foundations_centered_section(
        "Small",
        "Small text button.",
        @rui.button(size=Sm, "Small"),
        FoundationsButtonSmallCode,
      ),
      foundations_centered_section(
        "Extra small",
        "Extra-small text button.",
        @rui.button(size=Xs, "Extra small"),
        FoundationsButtonExtraSmallCode,
      ),
      foundations_centered_section(
        "Large icon",
        "Large icon-only button.",
        @rui.button(
          size=IconLg,
          attrs=@html.Attrs::build().aria_label("Add large item"),
          showcase_plus_icon(),
        ),
        FoundationsButtonIconLargeCode,
      ),
      foundations_centered_section(
        "Default icon",
        "Default icon-only button.",
        @rui.button(
          size=Icon,
          attrs=@html.Attrs::build().aria_label("Open settings"),
          showcase_settings_icon(),
        ),
        FoundationsButtonIconCode,
      ),
      foundations_centered_section(
        "Small icon",
        "Small icon-only button.",
        @rui.button(
          size=IconSm,
          attrs=@html.Attrs::build().aria_label("Change layout"),
          showcase_layout_icon(),
        ),
        FoundationsButtonIconSmallCode,
      ),
      foundations_centered_section(
        "Extra-small icon",
        "Extra-small icon-only button.",
        @rui.button(
          size=IconXs,
          attrs=@html.Attrs::build().aria_label("Close"),
          showcase_close_icon(),
        ),
        FoundationsButtonIconExtraSmallCode,
      ),
    ],
  )
}

///|
fn foundations_badge_demo() -> @html.Html {
  showcase_component_demos(
    "Badge",
    "Compact status labels and a semantic link treatment.",
    [
      foundations_centered_section(
        "Default",
        "Primary status label.",
        @rui.badge("Ready"),
        FoundationsBadgeDefaultCode,
      ),
      foundations_centered_section(
        "Secondary",
        "Lower-emphasis status label.",
        @rui.badge(variant=Secondary, "Draft"),
        FoundationsBadgeSecondaryCode,
      ),
      foundations_centered_section(
        "Outline",
        "Bordered status label.",
        @rui.badge(variant=Outline, "v0.2.0"),
        FoundationsBadgeOutlineCode,
      ),
      foundations_centered_section(
        "Destructive",
        "Failure status label.",
        @rui.badge(variant=Destructive, "Failed"),
        FoundationsBadgeDestructiveCode,
      ),
      foundations_centered_section(
        "Ghost",
        "Quiet status label.",
        @rui.badge(variant=Ghost, "Archived"),
        FoundationsBadgeGhostCode,
      ),
      foundations_centered_section(
        "Link",
        "Navigable badge.",
        @rui.badge_link(href="#forms", variant=Link, "Open forms"),
        FoundationsBadgeLinkCode,
      ),
    ],
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
            @rui.button_group(aria_label="Release actions", [
              @rui.button(variant=Outline, "Preview"),
              @rui.button(variant=Outline, "Publish"),
              @rui.button_group_separator(),
              @rui.button_group_text("v0.2"),
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
            @rui.button_group(orientation=Vertical, aria_label="Canvas zoom", [
              @rui.button(
                variant=Outline,
                size=IconSm,
                attrs=@html.Attrs::build().aria_label("Zoom in"),
                showcase_plus_icon(),
              ),
              @rui.button(
                variant=Outline,
                size=IconSm,
                attrs=@html.Attrs::build().aria_label("Reset layout"),
                showcase_layout_icon(),
              ),
            ]),
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
  showcase_component_demos(
    "Toggle",
    "A black-box pressed control with default, outline, and size variants.",
    [
      foundations_centered_section(
        "Outline large",
        "A large outlined toggle owns its pressed state.",
        pin_html,
        FoundationsToggleOutlineLargeCode,
      ),
      foundations_centered_section(
        "Default small",
        "A small default toggle owns its pressed state.",
        watch_html,
        FoundationsToggleDefaultSmallCode,
      ),
    ],
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
  showcase_component_demos(
    "Label",
    "Native labels preserve explicit control relationships and disabled styling.",
    [
      showcase_demo_section(
        "Default",
        "The label remains explicitly associated with its input.",
        showcase_demo_stage(
          @html.div(
            style=["width:min(100%,24rem);margin-inline:auto"],
            @rui.field([
              @rui.label(for_="workspace-name", "Workspace name"),
              @rui.input(id="workspace-name", placeholder="rabbit-tea"),
            ]),
          ),
          FoundationsLabelDefaultCode,
          variant=ShowcaseStageSurface,
        ),
      ),
      showcase_demo_section(
        "Disabled",
        "Disabled styling applies to both label and associated input.",
        showcase_demo_stage(
          @html.div(
            style=["width:min(100%,24rem);margin-inline:auto"],
            @rui.field([
              @rui.label(for_="managed-name", disabled=true, "Managed name"),
              @rui.input(id="managed-name", disabled=true, value="Production"),
            ]),
          ),
          FoundationsLabelDisabledCode,
          variant=ShowcaseStageSurface,
        ),
      ),
    ],
  )
}

///|
fn foundations_kbd_demo() -> @html.Html {
  showcase_component_demos(
    "Kbd",
    "Keyboard input is rendered as single keys or compact shortcut groups.",
    [
      foundations_centered_section(
        "Key",
        "A single named key.",
        @rui.kbd("Escape"),
        FoundationsKbdKeyCode,
      ),
      foundations_centered_section(
        "Shortcut",
        "A compact multi-key shortcut.",
        @rui.kbd_group([@rui.kbd("Ctrl"), @rui.kbd("K")]),
        FoundationsKbdShortcutCode,
      ),
    ],
  )
}

///|
fn foundations_spinner_demo() -> @html.Html {
  showcase_component_demos(
    "Spinner",
    "A CSS-animated status indicator works inline or inside an action.",
    [
      foundations_centered_section(
        "Inline",
        "An inline status indicator with visible context.",
        @html.div(style=[RowStyle], [
          @rui.spinner(label="Saving release"),
          @html.span("Saving release metadata"),
        ]),
        FoundationsSpinnerInlineCode,
      ),
      foundations_centered_section(
        "In a button",
        "A spinner inside a disabled pending action.",
        @rui.button(disabled=true, [
          @rui.spinner(label="Publishing"),
          @html.span("Publishing"),
        ]),
        FoundationsSpinnerButtonCode,
      ),
    ],
  )
}

///|
fn foundations_alert_demo() -> @html.Html {
  showcase_component_demos(
    "Alert",
    "Semantic live regions with default and destructive treatments.",
    [
      showcase_demo_section(
        "Default",
        "An optional action shares the same alert grid.",
        showcase_demo_stage(
          @html.div(
            style=[FoundationsNarrowStackStyle],
            @rui.alert([
              @rui.alert_title("Deployment is ready"),
              @rui.alert_description("The preview passed all required checks."),
              @rui.alert_action(@rui.button(variant=Ghost, size=Xs, "View")),
            ]),
          ),
          FoundationsAlertDefaultCode,
          variant=ShowcaseStagePlain,
        ),
      ),
      showcase_demo_section(
        "Destructive",
        "A destructive live region calls out a failure.",
        showcase_demo_stage(
          @html.div(
            style=[FoundationsNarrowStackStyle],
            @rui.alert(variant=Destructive, [
              @rui.alert_title("Two checks need attention"),
              @rui.alert_description(
                "Update the package lock before publishing.",
              ),
            ]),
          ),
          FoundationsAlertDestructiveCode,
          variant=ShowcaseStagePlain,
        ),
      ),
    ],
  )
}

///|
fn foundations_message_demo() -> @html.Html {
  showcase_component_demos(
    "Message",
    "Conversation rows compose avatar, alignment, metadata, and Bubble surfaces.",
    [
      showcase_demo_section(
        "Start aligned",
        "Avatar, header, bubble, and footer align to the start.",
        showcase_demo_stage(
          @rui.message_group(
            style=[
              "display:flex;width:min(100%,42rem);min-width:0;margin-inline:auto;flex-direction:column",
            ],
            [
              @rui.message([
                @rui.message_avatar(@rui.avatar(@rui.avatar_fallback("YO"))),
                @rui.message_content([
                  @rui.message_header("You · 09:41"),
                  @rui.bubble_group([
                    @rui.bubble(
                      @rui.bubble_content(
                        "The native package is ready. Can you review the component gallery?",
                      ),
                    ),
                  ]),
                  @rui.message_footer("Delivered"),
                ]),
              ]),
            ],
          ),
          FoundationsMessageStartCode,
          variant=ShowcaseStageSurface,
          tall=true,
        ),
      ),
      showcase_demo_section(
        "End aligned",
        "Avatar, header, and bubble align to the end.",
        showcase_demo_stage(
          @rui.message_group(
            style=[
              "display:flex;width:min(100%,42rem);min-width:0;margin-inline:auto;flex-direction:column",
            ],
            [
              @rui.message(align=AlignEnd, [
                @rui.message_avatar(@rui.avatar(@rui.avatar_fallback("RA"))),
                @rui.message_content([
                  @rui.message_header("Rabbita · 09:42"),
                  @rui.bubble_group([
                    @rui.bubble(variant=BubbleSecondary, [
                      @rui.bubble_content(
                        "Reviewed. The inline styles and native semantics are both visible.",
                      ),
                    ]),
                  ]),
                ]),
              ]),
            ],
          ),
          FoundationsMessageEndCode,
          variant=ShowcaseStageSurface,
          tall=true,
        ),
      ),
    ],
  )
}

///|
fn foundations_bubble_demo() -> @html.Html {
  showcase_component_demos(
    "Bubble",
    "All seven Nova treatments share root-owned color, alignment, focus, hover, and press states.",
    [
      foundations_centered_section(
        "Default",
        "Current-user emphasis.",
        @rui.bubble(align=AlignEnd, [
          @rui.bubble_content("Default · current-user emphasis"),
        ]),
        FoundationsBubbleDefaultCode,
      ),
      foundations_centered_section(
        "Secondary",
        "Neutral conversation surface.",
        @rui.bubble(variant=BubbleSecondary, [
          @rui.bubble_content("Secondary · neutral conversation"),
        ]),
        FoundationsBubbleSecondaryCode,
      ),
      foundations_centered_section(
        "Muted",
        "Quiet supporting surface.",
        @rui.bubble(variant=BubbleMuted, [
          @rui.bubble_content("Muted · quiet supporting text"),
        ]),
        FoundationsBubbleMutedCode,
      ),
      foundations_centered_section(
        "Tinted",
        "Primary-derived surface.",
        @rui.bubble(variant=BubbleTinted, [
          @rui.bubble_content("Tinted · primary-derived surface"),
        ]),
        FoundationsBubbleTintedCode,
      ),
      foundations_centered_section(
        "Outline link",
        "Bordered navigable content.",
        @rui.bubble(variant=BubbleOutline, [
          @rui.bubble_content_link(href="#forms", "Open form controls"),
        ]),
        FoundationsBubbleOutlineCode,
      ),
      foundations_centered_section(
        "Ghost",
        "Unframed assistant content.",
        @rui.bubble(variant=BubbleGhost, [
          @rui.bubble_content("Ghost · unframed assistant content."),
        ]),
        FoundationsBubbleGhostCode,
      ),
      foundations_centered_section(
        "Destructive",
        "Failed action content.",
        @rui.bubble(variant=BubbleDestructive, [
          @rui.bubble_content("Destructive · an action failed."),
        ]),
        FoundationsBubbleDestructiveCode,
      ),
    ],
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
        @rui.badge(variant=Outline, "+18.4%"),
      ),
      @rui.chart_style(
        variables=[
          ("stable", "oklch(0.56 0.18 258)"),
          ("preview", "oklch(0.72 0.15 72)"),
        ],
        @html.div(
          style=[
            "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,14rem),1fr));gap:1rem;align-items:center",
          ],
          [
            @rui.chart_container(
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
              @rui.chart_tooltip(
                @rui.chart_tooltip_content([
                  @rui.chart_tooltip_label("Friday"),
                  @rui.chart_tooltip_item(
                    label="Stable",
                    value="8,842",
                    color="var(--color-stable)",
                  ),
                  @rui.chart_tooltip_item(
                    label="Preview",
                    value="1,204",
                    color="var(--color-preview)",
                    indicator=ChartDashed,
                  ),
                ]),
              ),
              @rui.chart_legend_content(
                style=["justify-content:flex-start;padding:0"],
                [
                  @rui.chart_legend_item(color="var(--color-stable)", "Stable"),
                  @rui.chart_legend_item(
                    color="var(--color-preview)",
                    "Preview",
                  ),
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
    @rui.table([
      @rui.table_caption("Latest verified builds across supported targets"),
      @rui.table_header(
        @rui.table_row([
          @rui.table_head("Package"),
          @rui.table_head("Target"),
          @rui.table_head("Status"),
          @rui.table_head(style=[FoundationsTableNumberStyle], "Tests"),
        ]),
      ),
      @rui.table_body([
        @rui.table_row([
          @rui.table_cell("rui"),
          @rui.table_cell("JavaScript"),
          @rui.table_cell(@rui.badge("Passing")),
          @rui.table_cell(style=[FoundationsTableNumberStyle], "Full suite"),
        ]),
        @rui.table_row([
          @rui.table_cell("rui"),
          @rui.table_cell("Native"),
          @rui.table_cell(@rui.badge(variant=Secondary, "Passing")),
          @rui.table_cell(style=[FoundationsTableNumberStyle], "Full suite"),
        ]),
        @rui.table_row([
          @rui.table_cell("showcase"),
          @rui.table_cell("In-app browser"),
          @rui.table_cell(@rui.badge(variant=Outline, "Replayed")),
          @rui.table_cell(style=[FoundationsTableNumberStyle], "Key flows"),
        ]),
      ]),
      @rui.table_footer(
        @rui.table_row([
          @rui.table_cell(colspan=3, "Automated targets"),
          @rui.table_cell(style=[FoundationsTableNumberStyle], "JS + native"),
        ]),
      ),
    ]),
    FoundationsTableCode,
    false,
    true,
  )
}
