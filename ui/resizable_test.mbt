///|
#cfg(target="js")
extern "js" fn install_resizable_test_window() =
  #| () => {
  #|   if (typeof globalThis.window === "undefined") {
  #|     globalThis.window = { requestAnimationFrame: () => 0 };
  #|   }
  #| }

///|
#warnings("-alert_unstable")
#cfg(target="js")
fn render_incremental_resizable(
  builder : () -> @rabbita.Val[@html.Html],
) -> String {
  install_resizable_test_window()
  ignore(@rabbita.new(builder))
  @rabbita.render_to_string(builder)
}

///|
#warnings("-alert_unstable")
#cfg(not(target="js"))
fn render_incremental_resizable(
  builder : () -> @rabbita.Val[@html.Html],
) -> String {
  @rabbita.render_to_string(builder)
}

///|
fn resizable_id_occurs_once(html : String, id : String) -> Bool {
  let token = "id=\"\{id}\""
  let first = html.find(token)
  first is Some(_) && first == html.rev_find(token)
}

///|
test "generic resizable renders three panels and two unique handles" {
  let html = render_incremental_resizable(() => {
    @rabbita-ui.resizable_group(
      id="workspace-layout",
      default_sizes=[20, 30, 50],
      min_sizes=[10, 20, 25],
      max_sizes=[50, 60, 70],
      aria_label="Resize workspace panes",
      scope => {
        [
          @rabbita-ui.resizable_group_panel(scope~, index=0, "Navigation"),
          @rabbita-ui.resizable_group_handle(
            scope~,
            between=0,
            with_handle=true,
          ),
          @rabbita-ui.resizable_group_panel(scope~, index=1, "Editor"),
          @rabbita-ui.resizable_group_handle(
            scope~,
            between=1,
            with_handle=true,
          ),
          @rabbita-ui.resizable_group_panel(scope~, index=2, "Inspector"),
        ]
      },
    )
  })
  assert_contains(html, "data-slot=\"resizable-panel-group\"")
  assert_contains(html, "data-sizes=\"20,30,50\"")
  assert_contains(html, "data-panel-count=\"3\"")
  assert_contains(html, "data-orientation=\"horizontal\"")
  assert_contains(html, "flex-direction:row")
  assert_contains(html, "data-between=\"0\"")
  assert_contains(html, "data-between=\"1\"")
  assert_contains(html, "data-index=\"0\" data-size=\"20\"")
  assert_contains(html, "data-index=\"1\" data-size=\"30\"")
  assert_contains(html, "data-index=\"2\" data-size=\"50\"")
  assert_contains(
    html, "box-sizing:border-box;min-width:0;min-height:0;overflow:auto;flex:0 0 20%",
  )
  assert_contains(html, "data-slot=\"resizable-control\"")
  assert_contains(html, "data-slot=\"resizable-handle-line\"")
  assert_contains(html, "data-slot=\"resizable-handle-hit-area\"")
  assert_contains(html, "data-slot=\"resizable-handle-grip\"")
  assert_contains(html, "width:0.25rem;height:1.5rem")
  assert_contains(html, "border-radius:9999px")
  assert_not_contains(html, "width:0.75rem;height:1rem")
  assert_contains(html, "aria-label=\"Resize workspace panes\"")
  assert_contains(html, "aria-orientation=\"horizontal\"")
  assert_contains(html, "writing-mode:horizontal-tb")
  assert_contains(html, "touch-action:none")
  assert_true(resizable_id_occurs_once(html, "workspace-layout"))
  assert_true(resizable_id_occurs_once(html, "workspace-layout-panel-0"))
  assert_true(resizable_id_occurs_once(html, "workspace-layout-panel-1"))
  assert_true(resizable_id_occurs_once(html, "workspace-layout-panel-2"))
  assert_true(resizable_id_occurs_once(html, "workspace-layout-handle-0"))
  assert_true(resizable_id_occurs_once(html, "workspace-layout-handle-0-input"))
  assert_true(resizable_id_occurs_once(html, "workspace-layout-handle-1"))
  assert_true(resizable_id_occurs_once(html, "workspace-layout-handle-1-input"))
}

///|
test "generic vertical resizable aligns layout range and separator axes" {
  let html = render_incremental_resizable(() => {
    @rabbita-ui.resizable_group(
      id="stack-layout",
      default_sizes=[25, 35, 40],
      orientation=@rabbita-ui.Vertical,
      scope => {
        [
          @rabbita-ui.resizable_group_panel(scope~, index=0, "Top"),
          @rabbita-ui.resizable_group_handle(scope~, between=0),
          @rabbita-ui.resizable_group_panel(scope~, index=1, "Middle"),
          @rabbita-ui.resizable_group_handle(scope~, between=1),
          @rabbita-ui.resizable_group_panel(scope~, index=2, "Bottom"),
        ]
      },
    )
  })
  assert_contains(html, "data-sizes=\"25,35,40\"")
  assert_contains(html, "data-orientation=\"vertical\"")
  assert_contains(html, "flex-direction:column")
  assert_contains(html, "role=\"separator\" aria-orientation=\"horizontal\"")
  assert_contains(html, "data-slot=\"resizable-control\"")
  assert_contains(html, "aria-orientation=\"vertical\"")
  assert_contains(html, "writing-mode:vertical-lr")
  assert_contains(html, "cursor:row-resize")
  assert_contains(html, "data-orientation=\"horizontal\"")
  assert_true(resizable_id_occurs_once(html, "stack-layout-handle-0"))
  assert_true(resizable_id_occurs_once(html, "stack-layout-handle-1"))
}

///|
test "legacy two panel API keeps its sizing and control contract" {
  let html = render_incremental_resizable(() => {
    @rabbita-ui.resizable_panel_group(
      id="compat-split",
      default_size=47,
      min=12,
      max=82,
      scope => {
        [
          @rabbita-ui.resizable_panel(
            scope~,
            side=@rabbita-ui.FirstPanel,
            "Primary",
          ),
          @rabbita-ui.resizable_handle(scope~, with_handle=true),
          @rabbita-ui.resizable_panel(
            scope~,
            side=@rabbita-ui.SecondPanel,
            "Secondary",
          ),
        ]
      },
    )
  })
  assert_contains(html, "id=\"compat-split\"")
  assert_contains(html, "data-size=\"47\"")
  assert_contains(html, "data-sizes=\"47,53\"")
  assert_contains(html, "data-side=\"first\" data-size=\"47\"")
  assert_contains(html, "data-side=\"second\" data-size=\"53\"")
  assert_contains(
    html, "box-sizing:border-box;min-width:0;min-height:0;overflow:auto;flex:0 0 47%",
  )
  assert_contains(html, "id=\"compat-split-handle\"")
  assert_not_contains(html, "id=\"compat-split-handle-0\"")
}
