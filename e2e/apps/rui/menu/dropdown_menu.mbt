///|
fn dropdown_menu_fixture() -> Val[Html] {
  let menu = @rui.dropdown_menu(id="fixture-dropdown-menu", scope => {
    fragment([
      @rui.dropdown_menu_trigger(scope, variant=Outline, "Workspace menu"),
      @rui.dropdown_menu_portal([
        @rui.dropdown_menu_content(scope, side=Bottom, align=Start, [
          @rui.dropdown_menu_group(aria_label="Workspace", [
            @rui.dropdown_menu_label("Workspace"),
            @rui.dropdown_menu_item(scope, "New tab"),
            @rui.dropdown_menu_item(scope, "Invite member"),
            @rui.dropdown_menu_item(scope, disabled=true, "Duplicate workspace"),
          ]),
        ]),
      ]),
    ])
  })
  menu.map(menu_html => {
    @fixture.section("fixture-section-dropdown-menu", "Dropdown menu", [
      menu_html,
    ])
  })
}
