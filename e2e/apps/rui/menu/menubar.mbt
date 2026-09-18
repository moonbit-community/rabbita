///|
fn menubar_fixture() -> Val[Html] {
  let bar = @rui.menubar(
    id="fixture-menubar",
    aria_label="Fixture application menu",
    scope => {
      fragment([
        @rui.menubar_menu(scope, value="file", menu => {
          fragment([
            @rui.menubar_trigger(menu, "File"),
            @rui.menubar_portal([
              @rui.menubar_content(menu, [
                @rui.menubar_group(aria_label="Project commands", [
                  @rui.menubar_label("Project"),
                  @rui.menubar_item(menu, "New project"),
                  @rui.menubar_item(menu, "Open…"),
                  @rui.menubar_item(menu, disabled=true, "Import"),
                ]),
              ]),
            ]),
          ])
        }),
        @rui.menubar_menu(scope, value="help", menu => {
          fragment([
            @rui.menubar_trigger(menu, "Help"),
            @rui.menubar_portal([
              @rui.menubar_content(menu, [
                @rui.menubar_group(aria_label="Help", [
                  @rui.menubar_label("Help"),
                  @rui.menubar_item(menu, "Keyboard shortcuts"),
                ]),
              ]),
            ]),
          ])
        }),
      ])
    },
  )
  bar.map(bar_html => {
    @fixture.section("fixture-section-menubar", "Menubar", [bar_html])
  })
}
