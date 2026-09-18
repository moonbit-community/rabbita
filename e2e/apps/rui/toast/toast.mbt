///|
fn toast_fixture() -> Val[Html] {
  let toaster = @rui.sonner(max_toasts=3, position="bottom-right", scope => {
    div(style=["display:flex;flex-wrap:wrap;gap:0.5rem"], [
      @rui.button(
        size=Sm,
        on_click=scope.show(
          title="Saved",
          description="The draft is kept.",
          variant=ToastDefault,
        ),
        "Show toast",
      ),
      @rui.button(
        size=Sm,
        variant=Secondary,
        on_click=scope.show(
          title="Published",
          description="The preview is live.",
          variant=ToastSuccess,
        ),
        "Show success toast",
      ),
      @rui.button(
        size=Sm,
        variant=Ghost,
        on_click=scope.dismiss_all(),
        "Dismiss all toasts",
      ),
    ])
  })
  toaster.map(toaster_html => {
    @fixture.section("fixture-section-toast", "Toast", [toaster_html])
  })
}
