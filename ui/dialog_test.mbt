///|
#cfg(target="native")
#warnings("-alert_unstable")
fn render_dialog_component(builder : () -> @rabbita.Val[@html.Html]) -> String {
  @rabbita.render_to_string(builder)
}

///|
fn dialog_assert_contains(actual : String, expected : String) -> Unit raise {
  if !actual.contains(expected) {
    fail("expected dialog HTML to contain `\{expected}`; got `\{actual}`")
  }
}

///|
fn dialog_assert_not_contains(
  actual : String,
  unexpected : String,
) -> Unit raise {
  if actual.contains(unexpected) {
    fail("expected dialog HTML not to contain `\{unexpected}`; got `\{actual}`")
  }
}

///|
fn dialog_test_warning_icon() -> @html.Html {
  @html.span(
    attrs=@html.Attrs::build().aria_hidden("true"),
    @svg.svg(width=32, height=32, view_box="0 0 24 24", [
      @svg.path(
        d="M21.73 18 13.73 4a2 2 0 0 0-3.46 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3ZM12 9v4M12 17h.01",
        fill="none",
        stroke="currentColor",
        stroke_width=2,
        attrs=@svg.Attrs::build()
          .stroke_linecap("round")
          .stroke_linejoin("round"),
      ),
    ]),
  )
}

///|
#cfg(target="js")
#warnings("-alert_unstable")
test "dialog static compound parts render on JS" {
  let html = @rabbita.render_to_string(() => {
    @rabbita.Val::constant(
      @html.div([
        @rabbita-ui.dialog_portal([@rabbita-ui.dialog_header("Dialog header")]),
        @rabbita-ui.dialog_footer("Dialog footer"),
        @rabbita-ui.alert_dialog_portal([
          @rabbita-ui.alert_dialog_header([
            @rabbita-ui.alert_dialog_media(
              attrs=@html.Attrs::build().data_set("owner", "media"),
              dialog_test_warning_icon(),
            ),
            @html.span("Alert header"),
          ]),
        ]),
        @rabbita-ui.alert_dialog_footer("Alert footer"),
      ]),
    )
  })
  dialog_assert_contains(html, "data-slot=\"dialog-header\"")
  dialog_assert_contains(html, "data-slot=\"dialog-footer\"")
  dialog_assert_contains(html, "data-slot=\"alert-dialog-header\"")
  dialog_assert_contains(html, "data-slot=\"alert-dialog-media\"")
  dialog_assert_contains(html, "data-owner=\"media\"")
  dialog_assert_contains(html, "data-slot=\"alert-dialog-footer\"")
  dialog_assert_not_contains(html, "data-slot=\"dialog-portal\"")
  dialog_assert_not_contains(html, "data-slot=\"alert-dialog-portal\"")
}

///|
#cfg(target="native")
test "dialog composes native semantics and shadcn slots" {
  let html = render_dialog_component(() => {
    @rabbita-ui.dialog(id="account-dialog", default_open=true, scope => {
      @html.div([
        @rabbita-ui.dialog_trigger(
          scope,
          attrs=@html.Attrs::build().data_set("owner", "trigger"),
          "Edit profile",
        ),
        @rabbita-ui.dialog_portal([
          @rabbita-ui.dialog_content(
            scope,
            style=["width:40rem"],
            overlay_attrs=@html.Attrs::build().data_set("owner", "overlay"),
            native_attrs=@html.Attrs::build().data_set("owner", "native"),
            [
              @rabbita-ui.dialog_header([
                @rabbita-ui.dialog_title(scope, "Edit profile"),
                @rabbita-ui.dialog_description(
                  scope, "Make changes to your profile.",
                ),
              ]),
              @rabbita-ui.dialog_footer(@rabbita-ui.dialog_close(scope, "Done")),
            ],
          ),
        ]),
      ])
    })
  })
  dialog_assert_contains(html, "<dialog")
  dialog_assert_contains(html, "id=\"account-dialog\"")
  dialog_assert_contains(html, "open")
  dialog_assert_contains(html, "closedby=\"any\"")
  dialog_assert_contains(html, "aria-modal=\"true\"")
  dialog_assert_contains(html, "aria-labelledby=\"account-dialog-title\"")
  dialog_assert_contains(
    html, "aria-describedby=\"account-dialog-description\"",
  )
  dialog_assert_contains(html, "data-slot=\"dialog-trigger\"")
  dialog_assert_contains(html, "aria-expanded=\"true\"")
  dialog_assert_contains(html, "data-slot=\"dialog-overlay\"")
  dialog_assert_contains(html, "data-slot=\"dialog-positioner\"")
  dialog_assert_contains(html, "data-slot=\"dialog-content\"")
  dialog_assert_contains(html, "data-slot=\"dialog-header\"")
  dialog_assert_contains(html, "data-slot=\"dialog-title\"")
  dialog_assert_contains(html, "id=\"account-dialog-title\"")
  dialog_assert_contains(html, "data-slot=\"dialog-description\"")
  dialog_assert_contains(html, "id=\"account-dialog-description\"")
  dialog_assert_contains(html, "data-slot=\"dialog-footer\"")
  dialog_assert_contains(html, "data-slot=\"dialog-close\"")
  dialog_assert_contains(html, "data-rui-close-icon=\"\"")
  dialog_assert_contains(html, "data-state=\"open\"")
  dialog_assert_contains(html, "<svg")
  dialog_assert_not_contains(html, ">×<")
  dialog_assert_contains(html, "transition:display 200ms,overlay 200ms")
  dialog_assert_contains(html, "transition-behavior:allow-discrete")
  dialog_assert_contains(html, "transition:opacity 200ms ease")
  dialog_assert_contains(
    html, "transition:opacity 200ms ease,transform 200ms ease",
  )
  dialog_assert_contains(html, "--rui-dialog-overlay-opacity:1")
  dialog_assert_contains(html, "--rui-dialog-content-opacity:1")
  dialog_assert_contains(
    html, "opacity:var(--rui-close-opacity,var(--rui-close-base-opacity,0.7))",
  )
  dialog_assert_contains(
    html, "background:var(--rui-close-bg,var(--rui-button-bg,var(--rui-button-base-bg,transparent)))",
  )
  dialog_assert_contains(
    html, "box-shadow:var(--rui-close-shadow,var(--rui-button-shadow,var(--rui-button-base-shadow,none)))",
  )
  dialog_assert_contains(html, "pointer-events:auto")
  dialog_assert_contains(html, "width:40rem")
  dialog_assert_contains(html, "data-owner=\"overlay\"")
  dialog_assert_contains(html, "data-owner=\"native\"")
  dialog_assert_not_contains(html, "data-slot=\"dialog-portal\"")
}

///|
#cfg(target="native")
test "non-modal dialog leaves the page interactive without an overlay" {
  let html = render_dialog_component(() => {
    @rabbita-ui.dialog(id="nonmodal-dialog", default_open=true, modal=false, scope => {
      @html.div([
        @rabbita-ui.dialog_trigger(scope, "Open inspector"),
        @rabbita-ui.dialog_content(
          scope,
          @html.button(id="nonmodal-first-control", "Inspect"),
        ),
      ])
    })
  })
  dialog_assert_contains(html, "<dialog")
  dialog_assert_contains(html, "id=\"nonmodal-dialog\"")
  dialog_assert_contains(html, "open")
  dialog_assert_contains(html, "closedby=\"none\"")
  dialog_assert_contains(html, "data-modal=\"false\"")
  dialog_assert_contains(html, "data-close-on-outside=\"true\"")
  dialog_assert_contains(html, "data-close-on-escape=\"true\"")
  dialog_assert_contains(html, "pointer-events:none")
  dialog_assert_contains(html, "data-slot=\"dialog-content\"")
  dialog_assert_not_contains(html, "aria-modal")
  dialog_assert_not_contains(html, "data-slot=\"dialog-overlay\"")
}

///|
#cfg(target="native")
test "closed dialog SSR omits open state" {
  let html = render_dialog_component(() => {
    @rabbita-ui.dialog(id="closed-dialog", scope => {
      @html.div([
        @rabbita-ui.dialog_trigger(scope, "Open"),
        @rabbita-ui.dialog_content(
          scope,
          show_close=false,
          described=false,
          @rabbita-ui.dialog_title(scope, "Closed"),
        ),
      ])
    })
  })
  dialog_assert_contains(html, "data-state=\"closed\"")
  dialog_assert_contains(html, "aria-expanded=\"false\"")
  dialog_assert_contains(html, "--rui-dialog-overlay-opacity:0")
  dialog_assert_contains(html, "--rui-dialog-content-opacity:0")
  dialog_assert_contains(
    html, "--rui-dialog-content-transform:translateY(-0.5rem) scale(0.95)",
  )
  dialog_assert_not_contains(html, "aria-describedby")
  dialog_assert_not_contains(html, "aria-label=\"Close\"")
}

///|
#cfg(target="native")
test "dialog and alert overlays are independently composable" {
  let dialog_html = render_dialog_component(() => {
    @rabbita-ui.dialog(id="standalone-dialog-parts", default_open=true, scope => {
      @rabbita-ui.dialog_portal([
        @rabbita-ui.dialog_overlay(
          scope,
          close_on_overlay=false,
          id="standalone-dialog-overlay",
          attrs=@html.Attrs::build().data_set("owner", "dialog-overlay"),
          style=["opacity:0.75"],
        ),
        @html.span(attrs=@html.Attrs::build().data_set("portal-child", ""), "D"),
      ])
    })
  })
  dialog_assert_contains(dialog_html, "id=\"standalone-dialog-overlay\"")
  dialog_assert_contains(dialog_html, "data-slot=\"dialog-overlay\"")
  dialog_assert_contains(dialog_html, "data-state=\"open\"")
  dialog_assert_contains(dialog_html, "data-owner=\"dialog-overlay\"")
  dialog_assert_contains(dialog_html, "opacity:0.75")
  dialog_assert_contains(dialog_html, "data-portal-child=\"\"")
  dialog_assert_not_contains(dialog_html, "data-slot=\"dialog-portal\"")
  dialog_assert_not_contains(dialog_html, "<dialog")
  let alert_html = render_dialog_component(() => {
    @rabbita-ui.alert_dialog(id="standalone-alert-parts", default_open=true, scope => {
      @rabbita-ui.alert_dialog_portal([
        @rabbita-ui.alert_dialog_overlay(
          scope,
          id="standalone-alert-overlay",
          attrs=@html.Attrs::build().data_set("owner", "alert-overlay"),
        ),
        @html.span(attrs=@html.Attrs::build().data_set("portal-child", ""), "A"),
      ])
    })
  })
  dialog_assert_contains(alert_html, "id=\"standalone-alert-overlay\"")
  dialog_assert_contains(alert_html, "data-slot=\"alert-dialog-overlay\"")
  dialog_assert_contains(alert_html, "data-state=\"open\"")
  dialog_assert_contains(alert_html, "data-owner=\"alert-overlay\"")
  dialog_assert_contains(alert_html, "data-portal-child=\"\"")
  dialog_assert_not_contains(alert_html, "data-slot=\"alert-dialog-portal\"")
  dialog_assert_not_contains(alert_html, "<dialog")
}

///|
#cfg(target="native")
test "alert dialog requires deliberate action and exposes alert semantics" {
  let html = render_dialog_component(() => {
    @rabbita-ui.alert_dialog(id="delete-dialog", scope => {
      @html.div([
        @rabbita-ui.alert_dialog_trigger(scope, "Delete project"),
        @rabbita-ui.alert_dialog_portal([
          @rabbita-ui.alert_dialog_content(scope, style=["max-width:28rem"], [
            @rabbita-ui.alert_dialog_header([
              @rabbita-ui.alert_dialog_media(
                attrs=@html.Attrs::build().data_set("owner", "warning-icon"),
                dialog_test_warning_icon(),
              ),
              @rabbita-ui.alert_dialog_title(scope, "Are you sure?"),
              @rabbita-ui.alert_dialog_description(
                scope, "This action cannot be undone.",
              ),
            ]),
            @rabbita-ui.alert_dialog_footer([
              @rabbita-ui.alert_dialog_cancel(scope, "Cancel"),
              @rabbita-ui.alert_dialog_action(scope, "Continue"),
            ]),
          ]),
        ]),
      ])
    })
  })
  dialog_assert_contains(html, "role=\"alertdialog\"")
  dialog_assert_contains(html, "aria-modal=\"true\"")
  dialog_assert_contains(html, "data-modal=\"true\"")
  dialog_assert_contains(html, "data-close-on-outside=\"false\"")
  dialog_assert_contains(html, "closedby=\"closerequest\"")
  dialog_assert_contains(html, "data-slot=\"alert-dialog-trigger\"")
  dialog_assert_contains(html, "data-slot=\"alert-dialog-overlay\"")
  dialog_assert_contains(html, "data-slot=\"alert-dialog-content\"")
  dialog_assert_contains(html, "data-slot=\"alert-dialog-title\"")
  dialog_assert_contains(html, "data-slot=\"alert-dialog-description\"")
  dialog_assert_contains(html, "data-slot=\"alert-dialog-media\"")
  dialog_assert_contains(html, "data-owner=\"warning-icon\"")
  dialog_assert_contains(html, "width:4rem;height:4rem")
  dialog_assert_contains(html, "data-slot=\"alert-dialog-cancel\"")
  dialog_assert_contains(html, "autofocus")
  dialog_assert_contains(html, "data-slot=\"alert-dialog-action\"")
  dialog_assert_contains(html, "--rui-dialog-overlay-opacity:0")
  dialog_assert_contains(html, "--rui-dialog-content-opacity:0")
  dialog_assert_contains(html, "pointer-events:auto")
  dialog_assert_contains(html, "width:min(100%,32rem)")
  dialog_assert_contains(html, "max-width:28rem")
  dialog_assert_not_contains(html, "aria-label=\"Close\"")
  dialog_assert_not_contains(html, "data-slot=\"alert-dialog-portal\"")
}

///|
#cfg(target="native")
test "dialog parts copy caller attrs" {
  let shared = @html.Attrs::build().data_set("owner", "caller")
  ignore(
    render_dialog_component(() => {
      @rabbita-ui.dialog(id="copy-dialog", scope => {
        @rabbita-ui.dialog_content(
          scope,
          attrs=shared,
          @rabbita-ui.dialog_title(scope, "Copy"),
        )
      })
    }),
  )
  let original = render_dialog_component(() => {
    @rabbita.Val::constant(@html.div(attrs=shared, @html.nothing))
  })
  dialog_assert_contains(original, "data-owner=\"caller\"")
  dialog_assert_not_contains(original, "data-slot")
  dialog_assert_not_contains(original, "data-state")
}
