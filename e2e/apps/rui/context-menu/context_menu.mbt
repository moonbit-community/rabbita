///|
fn context_menu_fixture() -> Val[Html] {
  let (action, set_action) = @rabbita.create_variable("none")
  let menu = @rui.context_menu(
    id="fixture-context-menu",
    default_checked_values=["grid"],
    default_radio_values=[("layout", "canvas")],
    scope => {
      fragment([
        @rui.context_menu_trigger(
          scope,
          tabindex=0,
          style=[
            "display:flex;width:18rem;height:8rem;align-items:center;justify-content:center;border:1px dashed var(--rui-border);border-radius:0.625rem",
          ],
          "Right-click fixture canvas",
        ),
        @rui.context_menu_portal([
          @rui.context_menu_content(scope, aria_label="Fixture canvas menu", [
            @rui.context_menu_group(aria_label="Actions", [
              @rui.context_menu_label("Actions"),
              @rui.context_menu_item(
                scope,
                on_select=set_action(_ => "duplicated"),
                "Duplicate fixture",
              ),
              @rui.context_menu_item(scope, disabled=true, "Unavailable action"),
              @rui.context_menu_checkbox_item(
                scope,
                value="grid",
                close_on_select=false,
                "Show grid",
              ),
            ]),
            @rui.context_menu_separator(),
            @rui.context_menu_radio_group(scope, value="layout", radio => {
              fragment([
                @rui.context_menu_radio_item(
                  radio,
                  value="canvas",
                  close_on_select=false,
                  "Canvas layout",
                ),
                @rui.context_menu_radio_item(
                  radio,
                  value="editor",
                  close_on_select=false,
                  "Editor layout",
                ),
              ])
            }),
            @rui.context_menu_sub(scope, value="move", sub => {
              fragment([
                @rui.context_menu_sub_trigger(sub, "Move fixture"),
                @rui.context_menu_sub_content(sub, [
                  @rui.context_menu_group(aria_label="Destination", [
                    @rui.context_menu_item(scope, "Design system"),
                    @rui.context_menu_item(scope, "Experiments"),
                  ]),
                ]),
              ])
            }),
          ]),
        ]),
      ])
    },
  )
  menu.map2(action, fn(menu, action) {
    @fixture.section("fixture-section-context-menu", "Context menu", [
      menu,
      @html.output(id="fixture-context-menu-output", action),
    ])
  })
}
