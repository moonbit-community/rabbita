///|
fn sheet_fixture() -> Val[Html] {
  let right = @rui.sheet(id="fixture-sheet-right", scope => {
    fragment([
      @rui.sheet_trigger(scope, variant=Outline, "Open settings sheet"),
      @rui.sheet_content(scope, side=SheetRight, [
        @rui.sheet_header([
          @rui.sheet_title(scope, "Fixture settings"),
          @rui.sheet_description(scope, "Edit settings in a side sheet."),
        ]),
        div(style=["display:grid;gap:0.5rem"], [
          @rui.label(for_="fixture-sheet-email", "Notification email"),
          @rui.input(id="fixture-sheet-email", value="team@example.com"),
        ]),
        @rui.sheet_footer(@rui.sheet_close(scope, "Save sheet")),
      ]),
    ])
  })
  let bottom = @rui.sheet(id="fixture-sheet-bottom", scope => {
    fragment([
      @rui.sheet_trigger(scope, variant=Outline, "Open bottom sheet"),
      @rui.sheet_content(scope, side=SheetBottom, [
        @rui.sheet_header([
          @rui.sheet_title(scope, "Bottom fixture sheet"),
          @rui.sheet_description(scope, "This sheet enters from below."),
        ]),
        @rui.sheet_footer(@rui.sheet_close(scope, "Close bottom sheet")),
      ]),
    ])
  })
  right.map2(bottom, fn(right, bottom) {
    @fixture.section("fixture-section-sheet", "Sheet", [right, bottom])
  })
}
