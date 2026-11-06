///|
fn focus_after_dismiss_fixture() -> Val[Html] {
  let (mounted, set_mounted) = @rabbita.create_variable(false)
  let menu = @rui.dropdown_menu(
    id="fixture-focus-menu",
    default_open=true,
    scope => {
      fragment([
        @rui.dropdown_menu_trigger(scope, "Focus menu"),
        @rui.dropdown_menu_portal([
          @rui.dropdown_menu_content(
            scope,
            aria_label="Focus menu",
            attrs=@html.Attrs::build().data_set("final-focus-id", "focus-origin"),
            style=["transition:none"],
            [
              @rui.dropdown_menu_group(aria_label="Focus", [
                @rui.dropdown_menu_item(scope, "First focus item"),
              ]),
            ],
          ),
        ]),
      ])
    },
  )
  mounted.map2(menu, fn(mounted, menu_html) {
    @fixture.section("fixture-section-focus-menu", "Focus menu", [
      @html.button(id="focus-origin", "Focus origin"),
      @html.button(
        id="mount-focus-menu",
        on_click=set_mounted(_ => true),
        "Mount focus menu",
      ),
      if mounted { menu_html } else { @html.nothing },
    ])
  })
}
