///|
fn resizable_group_fixture() -> Val[Html] {
  let (sizes, set_sizes) = @rabbita.create_variable("26,44,30")
  let group = @rui.resizable_group(
    id="fixture-resizable-group",
    default_sizes=[26, 44, 30],
    min_sizes=[16, 24, 18],
    max_sizes=[52, 68, 54],
    on_resize=set_sizes.map(values => {
      _ => values.map(value => value.to_string()).join(",")
    }),
    style=[
      "width:min(100%,42rem);height:10rem;border:1px solid \{fixture_section_border}",
    ],
    scope => {
      fragment([
        @rui.resizable_group_panel(
          scope~,
          index=0,
          id="fixture-resizable-files",
          style=[fixture_resizable_panel_style],
          "Files",
        ),
        @rui.resizable_group_handle(
          scope~,
          between=0,
          with_handle=true,
          aria_label="Resize files and editor",
        ),
        @rui.resizable_group_panel(
          scope~,
          index=1,
          id="fixture-resizable-editor",
          style=[fixture_resizable_panel_style],
          "Editor",
        ),
        @rui.resizable_group_handle(
          scope~,
          between=1,
          with_handle=true,
          aria_label="Resize editor and preview",
        ),
        @rui.resizable_group_panel(
          scope~,
          index=2,
          id="fixture-resizable-preview",
          style=[fixture_resizable_panel_style],
          "Preview",
        ),
      ])
    },
  )
  group.map2(sizes, fn(group, sizes) {
    @fixture.section("fixture-section-resizable-group", "Resizable Group", [
      group,
      @html.output(id="fixture-resizable-group-output", sizes),
    ])
  })
}
