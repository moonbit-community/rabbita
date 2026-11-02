///|
fn tooltip_fixture() -> Html {
  let tip = @rui.tooltip(
    id="fixture-tooltip",
    delay=80,
    close_delay=0,
    show_arrow=true,
    trigger_variant=Outline,
    "Hover for tooltip",
    "Tooltip body content",
  )
  @fixture.section("fixture-section-tooltip", "Tooltip", [tip])
}

///|
fn tooltip_lifecycle_fixture() -> Val[Html] {
  let (mounted, set_mounted) = @rabbita.create_variable(false)
  // Construct the HTML before mounting it, then reuse it across DOM removals.
  let tip = @rui.tooltip(
    id="fixture-late-tooltip",
    "Late tooltip trigger",
    "Late tooltip content",
  )
  mounted.view(mounted => {
    @fixture.section("fixture-section-tooltip-lifecycle", "Tooltip lifecycle", [
      @html.button(
        on_click=set_mounted(value => !value),
        if mounted {
          "Unmount tooltip"
        } else {
          "Mount tooltip"
        },
      ),
      if mounted {
        tip
      } else {
        @html.nothing
      },
    ])
  })
}

///|
fn tooltip_options_fixture() -> Html {
  @fixture.section("fixture-section-tooltip-options", "Tooltip options", [
    @rui.tooltip_provider(delay=160, close_delay=80, [
      @rui.tooltip(
        id="fixture-provider-tooltip",
        "Provider trigger",
        "Provider content",
      ),
    ]),
    @rui.tooltip(
      id="fixture-disabled-tooltip",
      disabled=true,
      "Disabled trigger",
      "Disabled content",
    ),
  ])
}

///|
fn tooltip_placement_fixture() -> Html {
  @fixture.section("fixture-section-tooltip-placement", "Tooltip placement", [
    @html.div(style=["display:flex;gap:4rem;padding:5rem"], [
      @rui.tooltip(
        id="fixture-tip-top",
        side=Top,
        align=Start,
        "Top trigger",
        "Top content",
      ),
      @rui.tooltip(
        id="fixture-tip-right",
        side=Right,
        "Right trigger",
        "Right content",
      ),
      @rui.tooltip(
        id="fixture-tip-bottom",
        side=Bottom,
        align=End,
        "Bottom trigger",
        "Bottom content",
      ),
      @rui.tooltip(
        id="fixture-tip-left",
        side=Left,
        "Left trigger",
        "Left content",
      ),
    ]),
  ])
}
