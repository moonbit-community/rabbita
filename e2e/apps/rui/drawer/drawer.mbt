///|
fn drawer_example(
  direction : @rui.DrawerDirection,
  name : String,
  swipe_area? : Int,
) -> Html {
  let id = "fixture-drawer-" + name
  fragment([
    @rui.button(
      variant=Outline,
      on_click=@dialog.show(id),
      "Open " + name + " drawer",
    ),
    @rui.drawer(
      id~,
      direction~,
      swipe_area?,
      attrs=@html.Attrs::build()
        .aria_labelledby(id + "-title")
        .aria_describedby(id + "-description"),
      [
        @rui.drawer_header([
          @rui.drawer_title(id=id + "-title", name + " drawer"),
          @rui.drawer_description(
            id=id + "-description",
            "Drag beside the drawer to dismiss, or close the drawer below.",
          ),
        ]),
        p(style=["margin:0"], "Drawer body"),
        @rui.drawer_footer(
          @html.form(
            method_="dialog",
            @rui.button(
              variant=Outline,
              type_="submit",
              value="saved",
              style=["width:100%"],
              "Close drawer",
            ),
          ),
        ),
      ],
    ),
  ])
}

///|
fn drawer_fixture() -> Val[Html] {
  @rabbita.Val::constant(
    @fixture.section("fixture-section-drawer", "Drawer", [
      drawer_example(DrawerTop, "top", swipe_area=50),
      drawer_example(DrawerRight, "right", swipe_area=50),
      drawer_example(DrawerBottom, "bottom", swipe_area=50),
      drawer_example(DrawerLeft, "left", swipe_area=50),
      drawer_example(DrawerRight, "disabled"),
      drawer_example(DrawerRight, "wide", swipe_area=80),
    ]),
  )
}
