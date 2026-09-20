///|
#cfg(not(target="js"))
#warnings("-alert_experimental")
async test "SSR renders themed dialog markup and escapes user content" {
  let app = @rabbita.new(() => {
    @rabbita.Val::constant(
      @html.html([
        @html.head(@html.title("RUI SSR")),
        @html.body(
          @rui.theme(
            @rui.dialog(id="profile", open=true, [
              @rui.dialog_title("Profile <preview>"),
              @rui.input(name="name", value="Rui & friends"),
              @rui.button(disabled=true, "Save"),
            ]),
          ),
        ),
      ]),
    )
  })
  let rendered = app.render(url="https://example.com/profile")
  assert_true(rendered.has_prefix("<!DOCTYPE html><html>"))
  assert_true(rendered.contains("--rui-background:"))
  assert_true(rendered.contains("<dialog"))
  assert_true(rendered.contains(" open>"))
  assert_true(rendered.contains("closedby=\"any\""))
  assert_true(rendered.contains("Profile &lt;preview&gt;"))
  assert_true(rendered.contains("value=\"Rui &amp; friends\""))
  assert_true(rendered.contains(" disabled>"))
  assert_true(rendered.contains("method=\"dialog\""))
  assert_true(rendered.contains("id=\"__rabbita_transcript\""))
}

///|
#cfg(not(target="js"))
#warnings("-alert_experimental")
async test "SSR preserves checkbox defaults without dispatching callbacks" {
  let changes = Ref(0)
  for checked in [false, true] {
    let app = @rabbita.new(() => {
      @rui.checkbox(
        default_checked=checked,
        aria_label="Subscribe",
        on_checked_change=@cmd.Emit(_ => {
          changes.val += 1
          @cmd.none
        }),
      ).map(content => {
        @html.html([@html.head([@html.title("RUI SSR")]), @html.body(content)])
      })
    })
    let rendered = app.render(url="https://example.com/")
    assert_true(rendered.contains("role=\"checkbox\""))
    assert_true(rendered.contains("aria-label=\"Subscribe\""))
    assert_true(rendered.contains("aria-checked=\"\{checked}\""))
  }
  assert_eq(changes.val, 0)
}

///|
#cfg(not(target="js"))
#warnings("-alert_experimental")
async test "SSR preserves select value and form field" {
  let app = @rabbita.new(() => {
    @rui.select(id="language", name="language", default_value="moonbit", options=[
      @rui.select_option(value="rust", label="Rust"),
      @rui.select_option(value="moonbit", label="MoonBit"),
    ]).map(content => {
      @html.html([@html.head([@html.title("RUI SSR")]), @html.body(content)])
    })
  })
  let rendered = app.render(url="https://example.com/")
  assert_true(rendered.contains("role=\"combobox\""))
  assert_true(rendered.contains("aria-expanded=\"false\""))
  assert_true(rendered.contains(">MoonBit<"))
  assert_true(rendered.contains("name=\"language\""))
  assert_true(rendered.contains("value=\"moonbit\""))
}

///|
#cfg(not(target="js"))
#warnings("-alert_experimental")
async test "SSR renders compound menubar with its initial open menu" {
  let app = @rabbita.new(() => {
    @rui.menubar(id="menu", default_value="file", scope => {
      @rui.menubar_menu(scope, value="file", menu => {
        [
          @rui.menubar_trigger(menu, "File"),
          @rui.menubar_content(menu, @rui.menubar_item(menu, "New project")),
        ]
      })
    }).map(content => {
      @html.html([@html.head([@html.title("RUI SSR")]), @html.body(content)])
    })
  })
  let rendered = app.render(url="https://example.com/")
  assert_true(rendered.contains("role=\"menubar\""))
  assert_true(rendered.contains("data-value=\"file\""))
  assert_true(rendered.contains("aria-expanded=\"true\""))
  assert_true(rendered.contains("role=\"menu\""))
  assert_true(rendered.contains("role=\"menuitem\""))
  assert_true(rendered.contains(">New project<"))
}
