///|
fn drawer_fixture() -> Val[Html] {
  let drawer = @rui.drawer(id="fixture-drawer", scope => {
    fragment([
      @rui.drawer_trigger(scope, variant=Outline, "Open drawer"),
      @rui.drawer_portal([
        @rui.drawer_content(
          scope,
          direction=DrawerRight,
          show_handle=true,
          show_close=true,
          close_label="Close drawer",
          [
            @rui.drawer_header([
              @rui.drawer_title(scope, "Drawer title"),
              @rui.drawer_description(scope, "Drawer description."),
            ]),
            p(style=["margin:0"], "Drawer body"),
            @rui.drawer_footer(@rui.drawer_close(scope, "Close drawer")),
          ],
        ),
      ]),
    ])
  })
  drawer.map(drawer_html => {
    @fixture.section("fixture-section-drawer", "Drawer", [drawer_html])
  })
}
