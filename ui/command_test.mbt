///|
#cfg(target="js")
extern "js" fn install_command_test_window() =
  #| () => {
  #|   if (typeof globalThis.window === "undefined") {
  #|     globalThis.window = { requestAnimationFrame: () => 0 };
  #|   }
  #|   if (typeof globalThis.document === "undefined") {
  #|     globalThis.document = { getElementById: () => null };
  #|   }
  #| }

///|
#warnings("-alert_unstable")
#cfg(target="js")
fn render_command_value(builder : () -> @rabbita.Val[@html.Html]) -> String {
  install_command_test_window()
  ignore(@rabbita.new(builder))
  @rabbita.render_to_string(builder)
}

///|
#warnings("-alert_unstable")
#cfg(not(target="js"))
fn render_command_value(builder : () -> @rabbita.Val[@html.Html]) -> String {
  @rabbita.render_to_string(builder)
}

///|
fn command_test_contains(actual : String, expected : String) -> Unit raise {
  if !actual.contains(expected) {
    fail("expected command HTML to contain `\{expected}`; got `\{actual}`")
  }
}

///|
fn command_test_not_contains(
  actual : String,
  unexpected : String,
) -> Unit raise {
  if actual.contains(unexpected) {
    fail(
      "expected command HTML not to contain `\{unexpected}`; got `\{actual}`",
    )
  }
}

///|
#cfg(target="native")
fn command_test_dialog_open(html : String) -> Unit raise {
  command_test_contains(html, " open")
}

///|
#cfg(target="js")
fn command_test_dialog_open(html : String) -> Unit raise {
  // JS opens the top-layer dialog through showModal after render, so the
  // serialized virtual tree carries state rather than an `open` attribute.
  command_test_contains(
    html, "data-slot=\"command-dialog-native\" data-state=\"open\"",
  )
}

///|
test "command filters compound items and exposes active descendant semantics" {
  let html = render_command_value(() => {
    @rabbita-ui.command(id="workspace-command", default_query="theme", scope => {
      @html.fragment([
        @rabbita-ui.command_input(scope~, style=["background:rebeccapurple"]),
        @rabbita-ui.command_list(scope~, [
          @rabbita-ui.command_empty(scope~, "No results found."),
          @rabbita-ui.command_group(scope~, heading="Actions", [
            @rabbita-ui.command_item(
              scope~,
              value="Open calendar",
              keywords=["schedule"],
              "Open calendar",
            ),
            @rabbita-ui.command_item(
              scope~,
              value="Change theme",
              keywords=["appearance", "colors"],
              [@html.span("Change theme"), @rabbita-ui.command_shortcut("⌘T")],
            ),
            @rabbita-ui.command_separator(),
            @rabbita-ui.command_item(
              scope~,
              value="Emoji picker",
              disabled=true,
              "Emoji picker",
            ),
          ]),
        ]),
      ])
    })
  })
  command_test_contains(html, "id=\"workspace-command\"")
  command_test_contains(html, "data-slot=\"command\"")
  command_test_contains(html, "data-filtered-count=\"1\"")
  command_test_contains(html, "data-slot=\"command-input-wrapper\"")
  command_test_contains(html, "data-slot=\"command-input-icon\"")
  command_test_contains(html, "<svg")
  command_test_not_contains(html, ">⌕<")
  command_test_contains(html, "data-slot=\"command-input\"")
  command_test_contains(html, "role=\"combobox\"")
  command_test_contains(html, "aria-autocomplete=\"list\"")
  command_test_contains(html, "aria-controls=\"workspace-command-list\"")
  command_test_contains(
    html, "aria-activedescendant=\"workspace-command-item-1\"",
  )
  command_test_contains(html, "value=\"theme\"")
  command_test_contains(html, "background:rebeccapurple")
  command_test_contains(html, "data-slot=\"command-list\"")
  command_test_contains(html, "role=\"listbox\"")
  command_test_contains(html, "data-slot=\"command-empty\"")
  command_test_contains(html, "data-state=\"hidden\"")
  command_test_contains(html, "data-slot=\"command-group\"")
  command_test_contains(html, "role=\"group\"")
  command_test_contains(html, "data-slot=\"command-group-heading\"")
  command_test_contains(html, ">Actions</div>")
  command_test_contains(html, "data-slot=\"command-item\"")
  command_test_contains(
    html, "background:var(--rui-menu-item-bg,var(--rui-menu-item-base-bg,transparent))",
  )
  command_test_contains(html, "--rui-menu-item-base-bg:var(--rui-accent")
  command_test_contains(html, "id=\"workspace-command-item-1\"")
  command_test_contains(html, "role=\"option\"")
  command_test_contains(html, "aria-selected=\"true\"")
  command_test_contains(html, "data-command-index=\"1\"")
  command_test_contains(html, "data-slot=\"command-separator\"")
  command_test_contains(html, "data-slot=\"command-shortcut\"")
  command_test_contains(html, "aria-disabled=\"true\"")
  command_test_contains(html, "display:none")
}

///|
test "command empty is correct even when declared before its items" {
  let html = render_command_value(() => {
    @rabbita-ui.command(id="empty-command", default_query="missing", scope => {
      @html.fragment([
        @rabbita-ui.command_input(scope~),
        @rabbita-ui.command_list(scope~, [
          @rabbita-ui.command_empty(scope~, "Nothing matched."),
          @rabbita-ui.command_group(
            scope~,
            @rabbita-ui.command_item(scope~, value="Settings", "Settings"),
          ),
        ]),
      ])
    })
  })
  command_test_contains(html, "data-filtered-count=\"0\"")
  command_test_contains(
    html, "data-slot=\"command-empty\" data-state=\"visible\"",
  )
  command_test_contains(html, ">Nothing matched.</div>")
  command_test_not_contains(html, "aria-activedescendant")
}

///|
test "command does not mutate caller attrs" {
  let attrs = @html.Attrs::build().data_set("owner", "caller")
  ignore(
    render_command_value(() => {
      @rabbita-ui.command(id="copy-command", attrs~, scope => {
        @rabbita-ui.command_list(
          scope~,
          @rabbita-ui.command_item(scope~, value="Copy", "Copy"),
        )
      })
    }),
  )
  let original = render_command_value(() => {
    @rabbita.Val::constant(@html.div(attrs~, @html.nothing))
  })
  command_test_contains(original, "data-owner=\"caller\"")
  command_test_not_contains(original, "data-slot")
  command_test_not_contains(original, "data-state")
}

///|
test "command dialog composes trigger and native modal semantics" {
  let html = render_command_value(() => {
    @rabbita-ui.command_dialog(
      id="global-command",
      default_open=true,
      aria_label="Global command menu",
      overlay_attrs=@html.Attrs::build().data_set("owner", "overlay"),
      trigger=scope => {
        @rabbita-ui.command_dialog_trigger(scope~, "Open command menu")
      },
      scope => {
        @html.fragment([
          @rabbita-ui.command_input(scope~),
          @rabbita-ui.command_list(scope~, [
            @rabbita-ui.command_empty(scope~, "No commands."),
            @rabbita-ui.command_group(
              scope~,
              heading="Navigation",
              @rabbita-ui.command_item(scope~, value="Dashboard", "Dashboard"),
            ),
          ]),
        ])
      },
    )
  })
  command_test_contains(html, "data-slot=\"command-dialog-trigger\"")
  command_test_contains(html, "aria-haspopup=\"dialog\"")
  command_test_contains(html, "aria-controls=\"global-command\"")
  command_test_contains(html, "aria-expanded=\"true\"")
  command_test_contains(html, "<dialog")
  command_test_contains(html, "id=\"global-command\"")
  command_test_dialog_open(html)
  command_test_contains(html, "closedby=\"any\"")
  command_test_contains(html, "aria-modal=\"true\"")
  command_test_contains(html, "aria-label=\"Global command menu\"")
  command_test_contains(html, "data-slot=\"command-dialog-overlay\"")
  command_test_contains(html, "data-owner=\"overlay\"")
  command_test_contains(html, "data-slot=\"command-dialog-positioner\"")
  command_test_contains(html, "data-slot=\"command-dialog-content\"")
  command_test_contains(html, "id=\"global-command-command\"")
  command_test_contains(html, "pointer-events:auto")
  command_test_contains(
    html, "transition:opacity 200ms ease,transform 200ms ease",
  )
  command_test_contains(html, "--rui-dialog-overlay-opacity:1")
  command_test_contains(html, "--rui-dialog-content-opacity:1")
}

///|
test "closed command dialog retains exit-motion state without opening native dialog" {
  let html = render_command_value(() => {
    @rabbita-ui.command_dialog(id="closed-command", scope => {
      @rabbita-ui.command_list(
        scope~,
        @rabbita-ui.command_item(scope~, value="Settings", "Settings"),
      )
    })
  })
  command_test_contains(html, "data-slot=\"command-dialog-native\"")
  command_test_contains(html, "data-state=\"closed\"")
  command_test_contains(html, "--rui-dialog-overlay-opacity:0")
  command_test_contains(html, "--rui-dialog-content-opacity:0")
  command_test_contains(
    html, "--rui-dialog-content-transform:translateY(-0.5rem) scale(0.95)",
  )
  command_test_not_contains(html, "aria-expanded=\"true\"")
}

///|
test "command ARIA references honor custom list and item ids" {
  let html = render_command_value(() => {
    @rabbita-ui.command(id="custom-id-command", scope => {
      @html.fragment([
        @rabbita-ui.command_input(scope~),
        @rabbita-ui.command_list(
          scope~,
          id="actual-command-list",
          @rabbita-ui.command_item(
            scope~,
            value="Settings",
            id="actual-command-item",
            "Settings",
          ),
        ),
      ])
    })
  })
  command_test_contains(html, "aria-controls=\"actual-command-list\"")
  command_test_contains(html, "aria-activedescendant=\"actual-command-item\"")
  command_test_contains(html, "id=\"actual-command-list\"")
  command_test_contains(html, "id=\"actual-command-item\"")
  command_test_not_contains(html, "aria-controls=\"custom-id-command-list\"")
}
