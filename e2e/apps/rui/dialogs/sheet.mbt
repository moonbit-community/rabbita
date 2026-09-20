///|
fn sheet_fixture() -> Html {
  @fixture.section("fixture-section-sheet", "Sheet", [
    @rui.button(
      variant=Outline,
      on_click=@dialog.show("fixture-sheet-right"),
      "Open settings sheet",
    ),
    @rui.sheet(
      id="fixture-sheet-right",
      attrs=@html.Attrs::build()
        .aria_labelledby("fixture-sheet-right-title")
        .aria_describedby("fixture-sheet-right-description"),
      [
        @rui.sheet_header([
          @rui.sheet_title(id="fixture-sheet-right-title", "Fixture settings"),
          @rui.sheet_description(
            id="fixture-sheet-right-description",
            "Edit settings in a side sheet.",
          ),
        ]),
        @html.form(method_="dialog", [
          div(style=["display:grid;gap:0.5rem"], [
            @rui.label(for_="fixture-sheet-email", "Notification email"),
            @rui.input(id="fixture-sheet-email", value="team@example.com"),
          ]),
          @rui.sheet_footer(
            @rui.button(type_="submit", value="saved", "Save sheet"),
          ),
        ]),
      ],
    ),
    sheet_edge_fixture("bottom", SheetBottom),
    sheet_edge_fixture("top", SheetTop),
    sheet_edge_fixture("left", SheetLeft),
  ])
}

///|
fn sheet_edge_fixture(edge : String, side : @rui.SheetSide) -> Html {
  let id = "fixture-sheet-" + edge
  fragment([
    @rui.button(
      variant=Outline,
      on_click=@dialog.show(id),
      "Open " + edge + " sheet",
    ),
    @rui.sheet(
      id~,
      side~,
      attrs=@html.Attrs::build()
        .aria_labelledby(id + "-title")
        .aria_describedby(id + "-description"),
      [
        @rui.sheet_header([
          @rui.sheet_title(id=id + "-title", edge + " fixture sheet"),
          @rui.sheet_description(id=id + "-description", "An edge sheet."),
        ]),
        @rui.sheet_footer(
          @html.form(
            method_="dialog",
            @rui.button(type_="submit", "Close " + edge + " sheet"),
          ),
        ),
      ],
    ),
  ])
}
