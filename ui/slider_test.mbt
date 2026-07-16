///|
#cfg(target="js")
extern "js" fn install_slider_incremental_test_window() =
  #| () => {
  #|   if (typeof globalThis.window === "undefined") {
  #|     globalThis.window = { requestAnimationFrame: () => 0 }
  #|   }
  #| }

///|
#warnings("-alert_unstable")
#cfg(target="js")
fn render_incremental_slider(
  builder : () -> @rabbita.Val[@html.Html],
) -> String {
  install_slider_incremental_test_window()
  ignore(@rabbita.new(builder))
  @rabbita.render_to_string(builder)
}

///|
#warnings("-alert_unstable")
#cfg(not(target="js"))
fn render_incremental_slider(
  builder : () -> @rabbita.Val[@html.Html],
) -> String {
  @rabbita.render_to_string(builder)
}

///|
fn slider_assert_contains(actual : String, expected : String) -> Unit raise {
  if !actual.contains(expected) {
    fail(
      "expected rendered slider HTML to contain `\{expected}`; got `\{actual}`",
    )
  }
}

///|
fn slider_assert_not_contains(
  actual : String,
  unexpected : String,
) -> Unit raise {
  if actual.contains(unexpected) {
    fail(
      "expected rendered slider HTML not to contain `\{unexpected}`; got `\{actual}`",
    )
  }
}

///|
test "two-thumb slider renders unique native controls and a bounded range" {
  let notify : @cmd.Emit[Array[Int]] = @cmd.Emit(_ => @cmd.none)
  let html = render_incremental_slider(() => {
    @rabbita-ui.slider_values(
      id="two-band",
      default_values=[83, 24],
      min=10,
      max=90,
      step=5,
      large_step=13,
      min_steps_between_values=2,
      aria_label="Price band",
      on_value_change=notify,
      on_value_commit=notify,
    )
  })
  slider_assert_contains(html, "id=\"two-band-root\"")
  slider_assert_contains(html, "data-value=\"25,85\"")
  slider_assert_contains(html, "data-thumb-count=\"2\"")
  slider_assert_contains(html, "data-large-step=\"13\"")
  slider_assert_contains(html, "id=\"two-band-thumb-0\"")
  slider_assert_contains(html, "id=\"two-band-thumb-1\"")
  slider_assert_contains(html, "data-orientation=\"horizontal\"")
  slider_assert_contains(html, "data-disabled=\"false\"")
  slider_assert_contains(
    html, "--rui-slider-thumb-base-shadow:0 1px 2px rgb(0 0 0 / 0.1)",
  )
  slider_assert_contains(
    html, "background:var(--rui-slider-thumb,var(--rui-background,oklch(1 0 0)))",
  )
  slider_assert_contains(
    html, "box-shadow:var(--rui-slider-thumb-shadow,var(--rui-slider-thumb-base-shadow,0 1px 2px rgb(0 0 0 / 0.1)))",
  )
  slider_assert_contains(
    html, "background:transparent;cursor:pointer;appearance:none;-webkit-appearance:none",
  )
  slider_assert_contains(html, "data-index=\"0\"")
  slider_assert_contains(html, "data-index=\"1\"")
  slider_assert_contains(html, "id=\"two-band-input-0\"")
  slider_assert_contains(html, "id=\"two-band-input-1\"")
  slider_assert_contains(html, "aria-label=\"Price band 1\"")
  slider_assert_contains(html, "aria-label=\"Price band 2\"")
  slider_assert_contains(html, "data-start=\"25\"")
  slider_assert_contains(html, "data-end=\"85\"")
}

///|
test "three-thumb and empty sliders keep every thumb operable" {
  let notify : @cmd.Emit[Array[Int]] = @cmd.Emit(values => {
    ignore(values)
    @cmd.none
  })
  let three = render_incremental_slider(() => {
    @rabbita-ui.slider_values(
      id="tri-band",
      default_values=[79, 17, 52],
      min=10,
      max=90,
      step=5,
      min_steps_between_values=1,
      on_value_change=notify,
      on_value_commit=notify,
    )
  })
  slider_assert_contains(three, "data-value=\"15,50,80\"")
  slider_assert_contains(three, "data-thumb-count=\"3\"")
  slider_assert_contains(three, "id=\"tri-band-thumb-2\"")
  slider_assert_contains(three, "id=\"tri-band-input-2\"")

  let empty = render_incremental_slider(() => {
    @rabbita-ui.slider_values(
      id="empty-band",
      default_values=[],
      min=10,
      max=90,
      step=5,
    )
  })
  slider_assert_contains(empty, "data-value=\"10\"")
  slider_assert_contains(empty, "data-thumb-count=\"1\"")
  slider_assert_contains(empty, "id=\"empty-band-input-0\"")
}

///|
test "single slider preserves its public input id and accepts inherited RTL" {
  let html = render_incremental_slider(() => {
    @rabbita-ui.slider(
      id="legacy-level",
      default_value=37,
      large_step=13,
      aria_label="Legacy level",
      attrs=@html.Attrs::build().dir("rtl"),
    )
  })
  slider_assert_contains(html, "id=\"legacy-level-root\"")
  slider_assert_contains(html, "id=\"legacy-level\"")
  slider_assert_not_contains(html, "id=\"legacy-level-input-0\"")
  slider_assert_contains(html, "data-value=\"37\"")
  slider_assert_contains(html, "data-large-step=\"13\"")
  slider_assert_contains(html, "aria-label=\"Legacy level\"")
  slider_assert_contains(html, "dir=\"rtl\"")
  slider_assert_contains(html, "inset-inline-start")
}
