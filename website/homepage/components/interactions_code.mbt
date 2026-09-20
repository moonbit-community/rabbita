///|
const IgBreadcrumbDefaultCode : String =
  #|@rui.breadcrumb(
  #|  @rui.breadcrumb_list([
  #|    @rui.breadcrumb_item(@rui.breadcrumb_link(href="#interactions", "UI")),
  #|    @rui.breadcrumb_separator(),
  #|    @rui.breadcrumb_item(
  #|      @rui.breadcrumb_link(href="#navigation", "Patterns"),
  #|    ),
  #|    @rui.breadcrumb_separator(),
  #|    @rui.breadcrumb_item(@rui.breadcrumb_page("Navigation")),
  #|  ]),
  #|)

///|
const IgBreadcrumbCondensedCode : String =
  #|@rui.breadcrumb(
  #|  @rui.breadcrumb_list([
  #|    @rui.breadcrumb_item(@rui.breadcrumb_link(href="#interactions", "Home")),
  #|    @rui.breadcrumb_separator(),
  #|    @rui.breadcrumb_item(@rui.breadcrumb_ellipsis()),
  #|    @rui.breadcrumb_separator(),
  #|    @rui.breadcrumb_item(@rui.breadcrumb_page("Current page")),
  #|  ]),
  #|)

///|
const IgPaginationDefaultCode : String =
  #|@rui.pagination(
  #|  @rui.pagination_content([
  #|    @rui.pagination_item(@rui.pagination_previous(href="#page-1")),
  #|    @rui.pagination_item(
  #|      @rui.pagination_link(href="#page-1", is_active=true, "1"),
  #|    ),
  #|    @rui.pagination_item(@rui.pagination_link(href="#page-2", "2")),
  #|    @rui.pagination_item(@rui.pagination_ellipsis()),
  #|    @rui.pagination_item(@rui.pagination_next(href="#page-2")),
  #|  ]),
  #|)

///|
const IgPaginationCompactCode : String =
  #|@rui.pagination(
  #|  aria_label="Compact pagination",
  #|  @rui.pagination_content([
  #|    @rui.pagination_item(@rui.pagination_previous(href="#page-1")),
  #|    @rui.pagination_item(
  #|      @rui.pagination_link(
  #|        href="#page-1",
  #|        is_active=true,
  #|        size=@rui.Sm,
  #|        "1",
  #|      ),
  #|    ),
  #|    @rui.pagination_item(
  #|      @rui.pagination_link(href="#page-2", size=@rui.Sm, "2"),
  #|    ),
  #|    @rui.pagination_item(@rui.pagination_next(href="#page-2")),
  #|  ]),
  #|)

///|
const IgAccordionSingleCode : String =
  #|@rui.accordion(
  #|  id="showcase-accordion",
  #|  type_=@rui.Single,
  #|  collapsible=true,
  #|  default_value="keyboard",
  #|  items=[
  #|    @rui.accordion_entry(
  #|      value="keyboard",
  #|      label="Keyboard interaction",
  #|      content=@html.p(
  #|        style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0"],
  #|        "Tab reaches each trigger; Enter and Space toggle its panel.",
  #|      ),
  #|    ),
  #|    @rui.accordion_entry(
  #|      value="state",
  #|      label="Owned state",
  #|      content=@html.p(
  #|        style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0"],
  #|        "The black-box root owns its expanded value through Rabbita.",
  #|      ),
  #|    ),
  #|    @rui.accordion_entry(
  #|      value="markup",
  #|      label="Native markup",
  #|      content=@html.p(
  #|        style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0"],
  #|        "Details and summary preserve useful behavior without JavaScript.",
  #|      ),
  #|    ),
  #|  ],
  #|)

///|
const IgAccordionMultipleCode : String =
  #|@rui.accordion(
  #|  id="showcase-accordion-multiple",
  #|  type_=@rui.Multiple,
  #|  default_values=["motion", "focus"],
  #|  items=[
  #|    @rui.accordion_entry(
  #|      value="motion",
  #|      label="Motion",
  #|      content=@html.p(
  #|        style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0"],
  #|        "Each expanded panel animates independently.",
  #|      ),
  #|    ),
  #|    @rui.accordion_entry(
  #|      value="focus",
  #|      label="Keyboard focus",
  #|      content=@html.p(
  #|        style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0"],
  #|        "Arrow keys move between enabled triggers.",
  #|      ),
  #|    ),
  #|    @rui.accordion_entry(
  #|      value="locked",
  #|      label="Unavailable section",
  #|      disabled=true,
  #|      content=@html.p("This panel cannot be opened."),
  #|    ),
  #|  ],
  #|)

///|
const IgCollapsibleOrderCode : String =
  #|@rui.collapsible(
  #|  id="showcase-collapsible-order",
  #|  default_open=true,
  #|  style=["width:min(100%,28rem);margin-inline:auto;border:1px solid var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-card);box-shadow:0 1px 2px rgb(0 0 0 / 0.04)"],
  #|  trigger_style=["min-height:3.75rem;padding:0.75rem 1rem;border:0;border-radius:calc(var(--rui-radius) - 1px);background:var(--rui-accordion-bg,transparent);text-decoration:none"],
  #|  content_body_style=["padding:0 1rem 1rem;color:var(--rui-foreground);font-size:0.875rem"],
  #|  trigger=@html.span(
  #|    style=["display:flex;min-width:0;align-items:center;justify-content:space-between;gap:0.75rem;text-align:start"],
  #|    [
  #|      @html.span(style=["display:grid;min-width:0;gap:0.125rem"], [
  #|        @html.strong("Order #4189"),
  #|        @html.span(
  #|          style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"],
  #|          "July 16 · 2 items",
  #|        ),
  #|      ]),
  #|      @rui.badge(variant=@rui.Secondary, "Paid"),
  #|    ],
  #|  ),
  #|  content=@html.div(style=["display:grid;gap:0.625rem"], [
  #|    @html.div(style=["display:flex;justify-content:space-between;gap:1rem"], [
  #|      @html.span("UI component license"),
  #|      @html.strong("$49.00"),
  #|    ]),
  #|    @html.div(style=["display:flex;justify-content:space-between;gap:1rem"], [
  #|      @html.span("Icon pack"),
  #|      @html.strong("$16.00"),
  #|    ]),
  #|    @html.hr(style=["width:100%;height:1px;border:0;background:var(--rui-border);margin:0.125rem 0"]),
  #|    @html.div(style=["display:flex;justify-content:space-between;gap:1rem"], [
  #|      @html.strong("Total"),
  #|      @html.strong("$65.00"),
  #|    ]),
  #|  ]),
  #|)

///|
const IgCollapsibleBasicCode : String =
  #|@rui.collapsible(
  #|  id="showcase-collapsible-basic",
  #|  style=["width:min(100%,26rem);margin-inline:auto"],
  #|  trigger_style=["min-height:2.5rem;padding:0.5rem 0.625rem;border:1px solid var(--rui-accordion-border,transparent);border-radius:var(--rui-radius);background:var(--rui-accordion-bg,transparent);text-decoration:none"],
  #|  content_body_style=["padding:0.25rem 0.625rem 0.75rem"],
  #|  trigger="Can I use this in my project?",
  #|  content=@html.p(
  #|    style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0"],
  #|    "Yes. The component owns its state, ARIA relationship, and keyboard activation.",
  #|  ),
  #|)

///|
const IgCollapsibleSettingsCode : String = IgMenuStrokeIconCode +
  (
    #|
    #|fn showcase_settings_icon() -> @html.Html {
    #|  showcase_stroke_icon("M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.38a2 2 0 0 0-.73-2.73l-.15-.09a2 2 0 0 1-1-1.74v-.51a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2zM12 15.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Z")
    #|}
    #|
    #|@rui.collapsible(
    #|  id="showcase-collapsible-settings",
    #|  style=["width:min(100%,28rem);margin-inline:auto;border:1px solid var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-card);box-shadow:0 1px 2px rgb(0 0 0 / 0.04)"],
    #|  trigger_style=["min-height:3.75rem;padding:0.75rem 1rem;border:0;border-radius:calc(var(--rui-radius) - 1px);background:var(--rui-accordion-bg,transparent);text-decoration:none"],
    #|  content_body_style=["padding:0 1rem 1rem;color:var(--rui-foreground);font-size:0.875rem"],
    #|  trigger=@html.span(style=["display:flex;min-width:0;align-items:center;gap:0.75rem;text-align:start"], [
    #|    showcase_settings_icon(),
    #|    @html.span(style=["display:grid;min-width:0;gap:0.125rem"], [
    #|      @html.strong("Advanced settings"),
    #|      @html.span(
    #|        style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"],
    #|        "Configure the generated workspace",
    #|      ),
    #|    ]),
    #|  ]),
    #|  content=@html.div(style=["display:grid;gap:0.875rem"], [
    #|    @html.div(style=["display:grid;gap:0.375rem"], [
    #|      @rui.label(for_="collapsible-workspace-name", "Workspace name"),
    #|      @rui.input(id="collapsible-workspace-name", value="Rabbit Tea"),
    #|    ]),
    #|    @html.div(style=["display:grid;gap:0.375rem"], [
    #|      @rui.label(for_="collapsible-release-channel", "Release channel"),
    #|      @rui.input(id="collapsible-release-channel", value="Stable"),
    #|    ]),
    #|  ]),
    #|)
  )

///|
const IgCollapsibleFileTreeCode : String = IgMenuStrokeIconCode +
  (
    #|
    #|fn tree_file_icon() -> @html.Html {
    #|  showcase_stroke_icon("M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6")
    #|}
    #|
    #|fn tree_folder_icon(open : Bool) -> @html.Html {
    #|  if open {
    #|    showcase_stroke_icon("M6 14l1.5-4h12.8a1.5 1.5 0 0 1 1.42 2l-2.1 6.2A2 2 0 0 1 17.72 20H5a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2")
    #|  } else {
    #|    showcase_stroke_icon("M3 6a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2Z")
    #|  }
    #|}
    #|
    #|fn tree_chevron_icon() -> @html.Html {
    #|  showcase_stroke_icon("m9 18 6-6-6-6", box_size="0.875rem")
    #|}
    #|
    #|fn tree_leaf(name : String) -> @html.Html {
    #|  @html.div(
    #|    style=["display:flex;min-height:2rem;min-width:0;align-items:center;gap:0.5rem;padding:0.25rem 0.375rem;color:var(--rui-foreground);font-size:0.875rem;line-height:1.25rem"],
    #|    [
    #|      tree_file_icon(),
    #|      @html.span(
    #|        style=["min-width:0;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"],
    #|        name,
    #|      ),
    #|    ],
    #|  )
    #|}
    #|
    #|fn tree_folder(
    #|  open_paths : Array[String],
    #|  set_path_open : @rabbita.Emit[(String, Bool)],
    #|  path : String,
    #|  name : String,
    #|  children : Array[@html.Html],
    #|) -> @html.Html {
    #|  let open = open_paths.contains(path)
    #|  let trigger_id = "showcase-file-tree-" + path + "-trigger"
    #|  let content_id = "showcase-file-tree-" + path + "-content"
    #|  let on_open_change = set_path_open.map(next => (path, next))
    #|  @rui.collapsible_root(
    #|    open~,
    #|    attrs=@html.Attrs::build().data_set("path", path),
    #|    [
    #|      @rui.collapsible_trigger(
    #|        open~,
    #|        controls=content_id,
    #|        show_indicator=false,
    #|        on_open_change~,
    #|        id=trigger_id,
    #|        style=["min-height:2rem;padding:0.25rem 0.375rem;border:1px solid var(--rui-accordion-border,transparent);border-radius:calc(var(--rui-radius) - 0.25rem);background:var(--rui-accordion-bg,transparent);font-weight:400;text-decoration:none"],
    #|        @html.span(
    #|          style=["display:flex;min-width:0;align-items:center;gap:0.5rem"],
    #|          [
    #|            @html.span(
    #|              style=["display:inline-flex;flex:none;transition:transform 150ms ease;transform:\{if open { "rotate(90deg)" } else { "rotate(0deg)" }}"],
    #|              tree_chevron_icon(),
    #|            ),
    #|            tree_folder_icon(open),
    #|            @html.span(
    #|              style=["min-width:0;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"],
    #|              name,
    #|            ),
    #|          ],
    #|        ),
    #|      ),
    #|      @rui.collapsible_content(
    #|        open~,
    #|        labelledby=trigger_id,
    #|        id=content_id,
    #|        body_style=["padding:0;color:var(--rui-foreground);font-size:0.875rem"],
    #|        @html.div(
    #|          style=["display:flex;min-width:0;flex-direction:column;padding-inline-start:1.125rem"],
    #|          children,
    #|        ),
    #|      ),
    #|    ],
    #|  )
    #|}
    #|
    #|let view_tabs = @rui.tabs(
    #|  id="showcase-file-tree-tabs",
    #|  default_value="explorer",
    #|  aria_label="File tree view",
    #|  style=["gap:0"],
    #|  list_style=["width:100%"],
    #|  content_style=["display:none"],
    #|  items=[
    #|    @rui.tab_entry(
    #|      value="explorer",
    #|      label="Explorer",
    #|      content=@html.nothing,
    #|    ),
    #|    @rui.tab_entry(
    #|      value="outline",
    #|      label="Outline",
    #|      content=@html.nothing,
    #|    ),
    #|  ],
    #|)
    #|let (open_paths, set_open_paths) = @rabbita.create_variable([
    #|  "components", "components/ui", "lib",
    #|])
    #|let set_path_open = set_open_paths.map(change => current => {
    #|  let (path, open) = change
    #|  if open {
    #|    if current.contains(path) {
    #|      current
    #|    } else {
    #|      let next = current.copy()
    #|      next.push(path)
    #|      next
    #|    }
    #|  } else {
    #|    current.filter(item => item != path)
    #|  }
    #|})
    #|open_paths.view2(view_tabs, (open_paths, tabs_html) => {
    #|  let components_ui = tree_folder(
    #|    open_paths,
    #|    set_path_open,
    #|    "components/ui",
    #|    "ui",
    #|    [
    #|      tree_leaf("button.mbt"),
    #|      tree_leaf("card.mbt"),
    #|      tree_leaf("dialog.mbt"),
    #|      tree_leaf("input.mbt"),
    #|      tree_leaf("select.mbt"),
    #|      tree_leaf("table.mbt"),
    #|    ],
    #|  )
    #|  let components = tree_folder(
    #|    open_paths,
    #|    set_path_open,
    #|    "components",
    #|    "components",
    #|    [
    #|      components_ui,
    #|      tree_leaf("login-form.mbt"),
    #|      tree_leaf("register-form.mbt"),
    #|    ],
    #|  )
    #|  let lib = tree_folder(open_paths, set_path_open, "lib", "lib", [
    #|    tree_leaf("utils.mbt"),
    #|    tree_leaf("cn.mbt"),
    #|    tree_leaf("api.mbt"),
    #|  ])
    #|  let hooks = tree_folder(open_paths, set_path_open, "hooks", "hooks", [
    #|    tree_leaf("use-media-query.mbt"),
    #|    tree_leaf("use-debounce.mbt"),
    #|    tree_leaf("use-local-storage.mbt"),
    #|  ])
    #|  let types = tree_folder(open_paths, set_path_open, "types", "types", [
    #|    tree_leaf("index.d.mbt"),
    #|    tree_leaf("api.d.mbt"),
    #|  ])
    #|  let public_images = tree_folder(
    #|    open_paths,
    #|    set_path_open,
    #|    "public/images",
    #|    "images",
    #|    [tree_leaf("workspace.png")],
    #|  )
    #|  let public = tree_folder(open_paths, set_path_open, "public", "public", [
    #|    tree_leaf("favicon.ico"),
    #|    tree_leaf("logo.svg"),
    #|    public_images,
    #|  ])
    #|  @rui.card(
    #|    size=@rui.Sm,
    #|    style=["width:min(100%,16rem);margin-inline:auto;gap:0.5rem"],
    #|    [
    #|      @rui.card_header(tabs_html),
    #|      @rui.card_content(
    #|        @html.div(
    #|          style=["display:flex;min-width:0;flex-direction:column;gap:0.25rem"],
    #|          [
    #|            components,
    #|            lib,
    #|            hooks,
    #|            types,
    #|            public,
    #|            tree_leaf("app.mbt"),
    #|            tree_leaf("layout.mbt"),
    #|            tree_leaf("globals.css"),
    #|            tree_leaf("moon.pkg"),
    #|            tree_leaf("moon.mod"),
    #|            tree_leaf("README.md"),
    #|            tree_leaf(".gitignore"),
    #|          ],
    #|        ),
    #|      ),
    #|    ],
    #|  )
    #|})
  )

///|
const IgTabsDefaultCode : String =
  #|@rui.tabs(
  #|  id="showcase-tabs",
  #|  default_value="preview",
  #|  orientation=@rui.TabsHorizontal,
  #|  aria_label="Component workflow",
  #|  items=[
  #|    @rui.tab_entry(
  #|      value="preview",
  #|      label="Preview",
  #|      content=@html.div(style=["position:relative;min-width:0;padding-block:1rem"], [
  #|        @html.strong("Ready to interact"),
  #|        @html.p(
  #|          style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0.375rem 0 0"],
  #|          "The selected panel is linked to its trigger.",
  #|        ),
  #|      ]),
  #|    ),
  #|    @rui.tab_entry(
  #|      value="source",
  #|      label="Source",
  #|      content=@html.div(style=["position:relative;min-width:0;padding-block:1rem"], [
  #|        @html.strong("Copy when you need control"),
  #|        @html.p(
  #|          style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0.375rem 0 0"],
  #|          "Otherwise consume the component as a black box.",
  #|        ),
  #|      ]),
  #|    ),
  #|    @rui.tab_entry(
  #|      value="accessibility",
  #|      label="A11y",
  #|      content=@html.div(style=["position:relative;min-width:0;padding-block:1rem"], [
  #|        @html.strong("Roving focus"),
  #|        @html.p(
  #|          style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0.375rem 0 0"],
  #|          "Use Left and Right to move across tabs.",
  #|        ),
  #|      ]),
  #|    ),
  #|  ],
  #|)

///|
const IgTabsLineCode : String =
  #|@rui.tabs(
  #|  id="showcase-tabs-line",
  #|  default_value="account",
  #|  list_variant=@rui.TabsLine,
  #|  aria_label="Account sections",
  #|  items=[
  #|    @rui.tab_entry(
  #|      value="account",
  #|      label="Account",
  #|      content=@html.div(style=["position:relative;min-width:0;padding-block:1rem"], [
  #|        @html.strong("Account profile"),
  #|        @html.p(
  #|          style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0.375rem 0 0"],
  #|          "The active line follows the selected tab.",
  #|        ),
  #|      ]),
  #|    ),
  #|    @rui.tab_entry(
  #|      value="security",
  #|      label="Security",
  #|      content=@html.div(
  #|        style=["position:relative;min-width:0;padding-block:1rem"],
  #|        "Security settings",
  #|      ),
  #|    ),
  #|    @rui.tab_entry(
  #|      value="notifications",
  #|      label="Notifications",
  #|      content=@html.div(
  #|        style=["position:relative;min-width:0;padding-block:1rem"],
  #|        "Notification preferences",
  #|      ),
  #|    ),
  #|  ],
  #|)

///|
const IgTabsVerticalCode : String =
  #|@rui.tabs(
  #|  id="showcase-tabs-vertical",
  #|  default_value="general",
  #|  orientation=@rui.TabsVertical,
  #|  aria_label="Vertical settings tabs",
  #|  items=[
  #|    @rui.tab_entry(
  #|      value="general",
  #|      label="General",
  #|      content=@html.div(style=["position:relative;min-width:0;padding-block:1rem"], [
  #|        @html.strong("General settings"),
  #|        @html.p(
  #|          style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0.375rem 0 0"],
  #|          "Up and Down move focus in a vertical list.",
  #|        ),
  #|      ]),
  #|    ),
  #|    @rui.tab_entry(
  #|      value="members",
  #|      label="Members",
  #|      content=@html.div(
  #|        style=["position:relative;min-width:0;padding-block:1rem"],
  #|        "Member access settings",
  #|      ),
  #|    ),
  #|    @rui.tab_entry(
  #|      value="billing",
  #|      label="Billing",
  #|      content=@html.div(
  #|        style=["position:relative;min-width:0;padding-block:1rem"],
  #|        "Billing settings",
  #|      ),
  #|    ),
  #|  ],
  #|)

///|
const IgTabsDisabledCode : String =
  #|@rui.tabs(
  #|  id="showcase-tabs-disabled",
  #|  default_value="home",
  #|  aria_label="Disabled tab example",
  #|  items=[
  #|    @rui.tab_entry(
  #|      value="home",
  #|      label="Home",
  #|      content=@html.div(
  #|        style=["position:relative;min-width:0;padding-block:1rem"],
  #|        "Home content",
  #|      ),
  #|    ),
  #|    @rui.tab_entry(
  #|      value="disabled",
  #|      label="Disabled",
  #|      disabled=true,
  #|      content=@html.div(
  #|        style=["position:relative;min-width:0;padding-block:1rem"],
  #|        "Unavailable",
  #|      ),
  #|    ),
  #|  ],
  #|)

///|
const IgTabsIconsCode : String =
  #|fn showcase_stroke_icon(
  #|  path : String,
  #|  box_size? : String = "1rem",
  #|) -> @html.Html {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=[
  #|      "display:inline-flex;width:\{box_size};height:\{box_size};flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none",
  #|    ],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d=path,
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|
  #|fn showcase_layout_icon() -> @html.Html {
  #|  showcase_stroke_icon("M4 4h16v16H4zM4 9h16M9 9v11")
  #|}
  #|
  #|fn showcase_code_icon() -> @html.Html {
  #|  showcase_stroke_icon("m16 18 6-6-6-6M8 6l-6 6 6 6")
  #|}
  #|
  #|@rui.tabs(
  #|  id="showcase-tabs-icons",
  #|  default_value="preview",
  #|  aria_label="View mode",
  #|  items=[
  #|    @rui.tab_entry(
  #|      value="preview",
  #|      label="Preview",
  #|      icon=showcase_layout_icon(),
  #|      content=@html.div(
  #|        style=["position:relative;min-width:0;padding-block:1rem"],
  #|        "Preview content",
  #|      ),
  #|    ),
  #|    @rui.tab_entry(
  #|      value="code",
  #|      label="Code",
  #|      icon=showcase_code_icon(),
  #|      content=@html.div(
  #|        style=["position:relative;min-width:0;padding-block:1rem"],
  #|        "Code content",
  #|      ),
  #|    ),
  #|  ],
  #|)

///|
const IgCarouselHorizontalCode : String =
  #|@rui.carousel(
  #|  id="showcase-carousel",
  #|  count=3,
  #|  loop_=true,
  #|  orientation=@rui.CarouselHorizontal,
  #|  aria_label="Rabbita UI highlights",
  #|  style=["width:min(calc(100% - 6rem),32rem);margin-inline:auto"],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.carousel_items(scope~, items=[
  #|        @html.div(
  #|          style=["display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px solid var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);font-size:1rem;font-weight:600"],
  #|          "Inline styles",
  #|        ),
  #|        @html.div(
  #|          style=["display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px solid var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);font-size:1rem;font-weight:600"],
  #|          "Incremental state",
  #|        ),
  #|        @html.div(
  #|          style=["display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px solid var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);font-size:1rem;font-weight:600"],
  #|          "Native semantics",
  #|        ),
  #|      ]),
  #|      @rui.carousel_previous(scope~),
  #|      @rui.carousel_next(scope~),
  #|    ])
  #|  },
  #|)

///|
const IgCarouselVerticalCode : String =
  #|@rui.carousel(
  #|  id="showcase-carousel-vertical",
  #|  count=3,
  #|  default_index=1,
  #|  orientation=@rui.CarouselVertical,
  #|  aria_label="Vertical Rabbita UI highlights",
  #|  style=["width:min(calc(100% - 6rem),32rem);margin:3rem auto"],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.carousel_items(scope~, items=[
  #|        @html.div(
  #|          style=["display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px solid var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);font-size:1rem;font-weight:600", "height:var(--rui-carousel-height,12rem)"],
  #|          "First slide",
  #|        ),
  #|        @html.div(
  #|          style=["display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px solid var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);font-size:1rem;font-weight:600", "height:var(--rui-carousel-height,12rem)"],
  #|          "Selected slide",
  #|        ),
  #|        @html.div(
  #|          style=["display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px solid var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);font-size:1rem;font-weight:600", "height:var(--rui-carousel-height,12rem)"],
  #|          "Last slide",
  #|        ),
  #|      ]),
  #|      @rui.carousel_previous(scope~),
  #|      @rui.carousel_next(scope~),
  #|    ])
  #|  },
  #|)

///|
const IgNavigationMenuViewportCode : String =
  #|@rui.navigation_menu(
  #|  id="showcase-navigation-menu",
  #|  aria_label="Showcase navigation",
  #|  scope => {
  #|    @html.div(style=["min-height:10rem"], [
  #|      @rui.navigation_menu_list(scope, [
  #|        @rui.navigation_menu_item(scope, value="platform", item => {
  #|          @html.fragment([
  #|            @rui.navigation_menu_trigger(item, "Platform"),
  #|            @rui.navigation_menu_indicator(item),
  #|            @rui.navigation_menu_content(
  #|              item,
  #|              style=["box-sizing:border-box;display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,8rem),1fr));gap:0.5rem;width:min(30rem,calc(100vw - 2rem));padding:0.25rem"],
  #|              [
  #|                @rui.navigation_menu_link(
  #|                  href="#components",
  #|                  active=true,
  #|                  style=["display:flex;min-height:4.5rem;flex-direction:column;justify-content:center;gap:0.25rem"],
  #|                  [
  #|                    @html.strong("Components"),
  #|                    @html.span(
  #|                      style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"],
  #|                      "Black-box defaults",
  #|                    ),
  #|                  ],
  #|                ),
  #|                @rui.navigation_menu_link(
  #|                  href="#patterns",
  #|                  style=["display:flex;min-height:4.5rem;flex-direction:column;justify-content:center;gap:0.25rem"],
  #|                  [
  #|                    @html.strong("Patterns"),
  #|                    @html.span(
  #|                      style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"],
  #|                      "Compound composition",
  #|                    ),
  #|                  ],
  #|                ),
  #|              ],
  #|            ),
  #|          ])
  #|        }),
  #|        @rui.navigation_menu_item(scope, value="resources", item => {
  #|          @html.fragment([
  #|            @rui.navigation_menu_trigger(item, "Resources"),
  #|            @rui.navigation_menu_indicator(item),
  #|            @rui.navigation_menu_content(
  #|              item,
  #|              style=["box-sizing:border-box;display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,8rem),1fr));gap:0.5rem;width:min(30rem,calc(100vw - 2rem));padding:0.25rem"],
  #|              [
  #|                @rui.navigation_menu_link(
  #|                  href="#api",
  #|                  style=["display:flex;min-height:4.5rem;flex-direction:column;justify-content:center;gap:0.25rem"],
  #|                  [
  #|                    @html.strong("API reference"),
  #|                    @html.span(
  #|                      style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"],
  #|                      "Typed MoonBit surface",
  #|                    ),
  #|                  ],
  #|                ),
  #|                @rui.navigation_menu_link(
  #|                  href="#examples",
  #|                  style=["display:flex;min-height:4.5rem;flex-direction:column;justify-content:center;gap:0.25rem"],
  #|                  [
  #|                    @html.strong("Examples"),
  #|                    @html.span(
  #|                      style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"],
  #|                      "Working interactions",
  #|                    ),
  #|                  ],
  #|                ),
  #|              ],
  #|            ),
  #|          ])
  #|        }),
  #|      ]),
  #|      @rui.navigation_menu_viewport(scope, @html.nothing),
  #|    ])
  #|  },
  #|)

///|
const IgNavigationMenuInlineCode : String =
  #|@rui.navigation_menu(
  #|  id="showcase-navigation-menu-inline",
  #|  viewport=false,
  #|  aria_label="Inline navigation menu",
  #|  scope => {
  #|    @rui.navigation_menu_list(scope, [
  #|      @rui.navigation_menu_item(scope, value="learn", item => {
  #|        @html.fragment([
  #|          @rui.navigation_menu_trigger(item, "Learn"),
  #|          @rui.navigation_menu_content(
  #|            item,
  #|            style=["box-sizing:border-box;display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,8rem),1fr));gap:0.5rem;width:min(30rem,calc(100vw - 2rem));padding:0.25rem"],
  #|            [
  #|              @rui.navigation_menu_link(
  #|                href="#guide",
  #|                active=true,
  #|                style=["display:flex;min-height:4.5rem;flex-direction:column;justify-content:center;gap:0.25rem"],
  #|                [
  #|                  @html.strong("Guide"),
  #|                  @html.span(
  #|                    style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"],
  #|                    "Active destination",
  #|                  ),
  #|                ],
  #|              ),
  #|              @rui.navigation_menu_link(
  #|                href="#examples",
  #|                style=["display:flex;min-height:4.5rem;flex-direction:column;justify-content:center;gap:0.25rem"],
  #|                [
  #|                  @html.strong("Examples"),
  #|                  @html.span(
  #|                    style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"],
  #|                    "Inline content",
  #|                  ),
  #|                ],
  #|              ),
  #|            ],
  #|          ),
  #|        ])
  #|      }),
  #|      @rui.navigation_menu_item(scope, value="disabled", item => {
  #|        @rui.navigation_menu_trigger(item, disabled=true, "Unavailable")
  #|      }),
  #|    ])
  #|  },
  #|)

///|
const IgSidebarSharedCode : String =
  #|fn stroke_icon(path : String) -> @html.Html {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=["display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none"],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d=path,
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|
  #|fn layout_icon() -> @html.Html {
  #|  stroke_icon("M4 4h16v16H4zM4 9h16M9 9v11")
  #|}
  #|
  #|fn panel_left_icon() -> @html.Html {
  #|  stroke_icon("M3 3h18v18H3zM9 3v18")
  #|}
  #|
  #|fn activity_icon() -> @html.Html {
  #|  stroke_icon("M3 12h4l2-8 4 16 2-8h6")
  #|}
  #|
  #|fn folder_icon() -> @html.Html {
  #|  stroke_icon(
  #|    "M3 6a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2Z",
  #|  )
  #|}
  #|
  #|fn settings_icon() -> @html.Html {
  #|  stroke_icon(
  #|    "M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.38a2 2 0 0 0-.73-2.73l-.15-.09a2 2 0 0 1-1-1.74v-.51a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2zM12 15.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Z",
  #|  )
  #|}
  #|
  #|fn user_icon() -> @html.Html {
  #|  stroke_icon("M20 21a8 8 0 0 0-16 0M12 13a5 5 0 1 0 0-10 5 5 0 0 0 0 10Z")
  #|}
  #|
  #|fn sidebar_navigation(
  #|  scope : @rui.SidebarScope,
  #|  side : @rui.SidebarSide,
  #|  menu_size : @rui.SidebarMenuButtonSize,
  #|  mobile : Bool,
  #|  interactive : Bool,
  #|) -> @html.Html {
  #|  let close_command = if mobile {
  #|    @rui.sidebar_close_mobile(scope)
  #|  } else {
  #|    @rui.sidebar_collapse(scope)
  #|  }
  #|  @html.fragment([
  #|    @rui.sidebar_header(
  #|      @rui.sidebar_input(
  #|        aria_label="Filter workspace navigation",
  #|        placeholder="Filter…",
  #|      ),
  #|    ),
  #|    @rui.sidebar_content(
  #|      @rui.sidebar_group([
  #|        @rui.sidebar_group_label(scope~, "Workspace"),
  #|        if interactive {
  #|          @rui.sidebar_group_action(
  #|            aria_label=if mobile {
  #|              "Close sidebar"
  #|            } else {
  #|              "Collapse sidebar"
  #|            },
  #|            on_click=close_command,
  #|            if side == @rui.SidebarRight {
  #|              stroke_icon("M3 3h18v18H3zM15 3v18")
  #|            } else {
  #|              panel_left_icon()
  #|            },
  #|          )
  #|        } else {
  #|          @html.nothing
  #|        },
  #|        @rui.sidebar_group_content(
  #|          @rui.sidebar_menu([
  #|            @rui.sidebar_menu_item([
  #|              @rui.sidebar_menu_button(
  #|                href="#overview",
  #|                is_active=true,
  #|                size=menu_size,
  #|                [layout_icon(), @html.span("Overview")],
  #|              ),
  #|              if interactive {
  #|                @rui.sidebar_menu_action(
  #|                  show_on_hover=true,
  #|                  aria_label=if mobile {
  #|                    "Close sidebar"
  #|                  } else {
  #|                    "Collapse sidebar"
  #|                  },
  #|                  on_click=close_command,
  #|                  panel_left_icon(),
  #|                )
  #|              } else {
  #|                @html.nothing
  #|              },
  #|            ]),
  #|            @rui.sidebar_menu_item([
  #|              @rui.sidebar_menu_button(href="#activity", size=menu_size, [
  #|                activity_icon(),
  #|                @html.span("Activity"),
  #|              ]),
  #|              @rui.sidebar_menu_badge("6"),
  #|            ]),
  #|            @rui.sidebar_menu_item([
  #|              @rui.sidebar_menu_button(href="#projects", size=menu_size, [
  #|                folder_icon(),
  #|                @html.span("Projects and longer workspace names"),
  #|              ]),
  #|              @rui.sidebar_menu_sub([
  #|                @rui.sidebar_menu_sub_item(
  #|                  @rui.sidebar_menu_sub_button(href="#reports", "Reports"),
  #|                ),
  #|                @rui.sidebar_menu_sub_item(
  #|                  @rui.sidebar_menu_sub_button(href="#roadmap", "Roadmap"),
  #|                ),
  #|              ]),
  #|            ]),
  #|            @rui.sidebar_menu_item(
  #|              @rui.sidebar_menu_button(
  #|                href="#settings",
  #|                size=menu_size,
  #|                disabled=true,
  #|                [settings_icon(), @html.span("Unavailable")],
  #|              ),
  #|            ),
  #|          ]),
  #|        ),
  #|      ]),
  #|    ),
  #|    @rui.sidebar_separator(),
  #|    @rui.sidebar_footer(
  #|      @rui.sidebar_menu(
  #|        @rui.sidebar_menu_item(
  #|          @rui.sidebar_menu_button(
  #|            href="#account",
  #|            size=menu_size,
  #|            variant=if menu_size == @rui.SidebarMenuLg {
  #|              @rui.SidebarMenuButtonOutline
  #|            } else {
  #|              @rui.SidebarMenuButtonDefault
  #|            },
  #|            if menu_size == @rui.SidebarMenuLg {
  #|              [
  #|                user_icon(),
  #|                @html.span(
  #|                  style=["display:grid;min-width:0;line-height:1.1"],
  #|                  [
  #|                    @html.strong("Yorkin"),
  #|                    @html.span(
  #|                      style=["color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.35"],
  #|                      "yorkin@example.com",
  #|                    ),
  #|                  ],
  #|                ),
  #|              ]
  #|            } else {
  #|              [user_icon(), @html.span("Account")]
  #|            },
  #|          ),
  #|        ),
  #|      ),
  #|    ),
  #|  ])
  #|}
  #|
  #|fn sidebar_loading_navigation() -> @html.Html {
  #|  @html.fragment([
  #|    @rui.sidebar_header(
  #|      @rui.sidebar_menu(
  #|        @rui.sidebar_menu_item(@rui.sidebar_menu_skeleton(show_icon=true)),
  #|      ),
  #|    ),
  #|    @rui.sidebar_content(
  #|      @rui.sidebar_group([
  #|        @rui.sidebar_group_label("Workspace"),
  #|        @rui.sidebar_group_content(
  #|          @rui.sidebar_menu([
  #|            @rui.sidebar_menu_item(@rui.sidebar_menu_skeleton(show_icon=true)),
  #|            @rui.sidebar_menu_item(@rui.sidebar_menu_skeleton(show_icon=true)),
  #|            @rui.sidebar_menu_item(@rui.sidebar_menu_skeleton(show_icon=true)),
  #|            @rui.sidebar_menu_item(@rui.sidebar_menu_skeleton(show_icon=true)),
  #|          ]),
  #|        ),
  #|      ]),
  #|    ),
  #|    @rui.sidebar_separator(),
  #|    @rui.sidebar_footer(
  #|      @rui.sidebar_menu(
  #|        @rui.sidebar_menu_item(@rui.sidebar_menu_skeleton(show_icon=true)),
  #|      ),
  #|    ),
  #|  ])
  #|}
  #|
  #|fn sidebar_workspace_content(
  #|  scope : @rui.SidebarScope,
  #|  id : String,
  #|  mobile : Bool,
  #|  interactive : Bool,
  #|  icon : @html.Html,
  #|) -> @html.Html {
  #|  @html.fragment([
  #|    @html.div(
  #|      style=["display:flex;flex-wrap:wrap;align-items:center;gap:0.75rem"],
  #|      [
  #|        if interactive {
  #|          @rui.sidebar_trigger(
  #|            scope,
  #|            mobile~,
  #|            controls=id,
  #|            aria_label=if mobile {
  #|              "Open mobile sidebar"
  #|            } else {
  #|              "Toggle sidebar"
  #|            },
  #|            icon,
  #|          )
  #|        } else {
  #|          @html.nothing
  #|        },
  #|        @html.strong("Workspace overview"),
  #|      ],
  #|    ),
  #|    @html.div(
  #|      style=["display:flex;min-height:0;flex:1;align-items:center;justify-content:center;padding:1rem"],
  #|      @html.p(
  #|        style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;max-width:18rem;margin:0;text-align:center"],
  #|        if mobile {
  #|          "Open the mobile sheet, then close it with the overlay, Escape, or its navigation action."
  #|        } else if interactive {
  #|          "Use the trigger or sidebar rail; the provider owns every state change."
  #|        } else {
  #|          "This persistent sidebar remains visible and does not expose a collapse control."
  #|        },
  #|      ),
  #|    ),
  #|  ])
  #|}

///|
const IgSidebarDefaultCode : String =
  #|@rui.sidebar_provider(
  #|  default_collapsed=false,
  #|  style=["--rui-sidebar-width:15rem;height:24rem;min-height:24rem;overflow:hidden"],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.sidebar(
  #|        scope,
  #|        id="showcase-sidebar-default",
  #|        side=@rui.SidebarLeft,
  #|        variant=@rui.SidebarDefault,
  #|        collapsible=@rui.SidebarOffcanvas,
  #|        mobile=false,
  #|        [
  #|          sidebar_navigation(
  #|            scope, @rui.SidebarLeft, @rui.SidebarMenuDefault, false, true,
  #|          ),
  #|          @rui.sidebar_rail(scope),
  #|        ],
  #|      ),
  #|      @html.div(
  #|        style=["box-sizing:border-box;display:flex;min-width:0;flex:1;flex-direction:column;padding:0.75rem"],
  #|        sidebar_workspace_content(
  #|          scope,
  #|          "showcase-sidebar-default",
  #|          false,
  #|          true,
  #|          panel_left_icon(),
  #|        ),
  #|      ),
  #|    ])
  #|  },
  #|)

///|
const IgSidebarFixedCode : String =
  #|@rui.sidebar_provider(
  #|  default_collapsed=false,
  #|  style=["--rui-sidebar-width:15rem;height:24rem;min-height:24rem;overflow:hidden"],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.sidebar(
  #|        scope,
  #|        id="showcase-sidebar-fixed",
  #|        side=@rui.SidebarLeft,
  #|        variant=@rui.SidebarDefault,
  #|        collapsible=@rui.SidebarFixed,
  #|        mobile=false,
  #|        [
  #|          sidebar_navigation(
  #|            scope, @rui.SidebarLeft, @rui.SidebarMenuSm, false, false,
  #|          ),
  #|          @html.nothing,
  #|        ],
  #|      ),
  #|      @html.div(
  #|        style=["box-sizing:border-box;display:flex;min-width:0;flex:1;flex-direction:column;padding:0.75rem"],
  #|        sidebar_workspace_content(
  #|          scope,
  #|          "showcase-sidebar-fixed",
  #|          false,
  #|          false,
  #|          panel_left_icon(),
  #|        ),
  #|      ),
  #|    ])
  #|  },
  #|)

///|
const IgSidebarIconCode : String =
  #|@rui.sidebar_provider(
  #|  default_collapsed=true,
  #|  style=["--rui-sidebar-width:15rem;height:24rem;min-height:24rem;overflow:hidden"],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.sidebar(
  #|        scope,
  #|        id="showcase-sidebar-icon",
  #|        side=@rui.SidebarLeft,
  #|        variant=@rui.SidebarDefault,
  #|        collapsible=@rui.SidebarIcon,
  #|        mobile=false,
  #|        [
  #|          sidebar_navigation(
  #|            scope, @rui.SidebarLeft, @rui.SidebarMenuDefault, false, true,
  #|          ),
  #|          @rui.sidebar_rail(scope),
  #|        ],
  #|      ),
  #|      @html.div(
  #|        style=["box-sizing:border-box;display:flex;min-width:0;flex:1;flex-direction:column;padding:0.75rem"],
  #|        sidebar_workspace_content(
  #|          scope,
  #|          "showcase-sidebar-icon",
  #|          false,
  #|          true,
  #|          panel_left_icon(),
  #|        ),
  #|      ),
  #|    ])
  #|  },
  #|)

///|
const IgSidebarLoadingCode : String =
  #|@rui.sidebar_provider(
  #|  default_collapsed=false,
  #|  style=["--rui-sidebar-width:15rem;height:24rem;min-height:24rem;overflow:hidden"],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.sidebar(
  #|        scope,
  #|        id="showcase-sidebar-loading",
  #|        side=@rui.SidebarLeft,
  #|        variant=@rui.SidebarDefault,
  #|        collapsible=@rui.SidebarFixed,
  #|        mobile=false,
  #|        sidebar_loading_navigation(),
  #|      ),
  #|      @html.div(
  #|        style=["box-sizing:border-box;display:flex;min-width:0;flex:1;flex-direction:column;padding:0.75rem"],
  #|        sidebar_workspace_content(
  #|          scope,
  #|          "showcase-sidebar-loading",
  #|          false,
  #|          false,
  #|          panel_left_icon(),
  #|        ),
  #|      ),
  #|    ])
  #|  },
  #|)

///|
const IgSidebarFloatingCode : String =
  #|@rui.sidebar_provider(
  #|  default_collapsed=false,
  #|  style=["--rui-sidebar-width:15rem;height:24rem;min-height:24rem;overflow:hidden"],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.sidebar(
  #|        scope,
  #|        id="showcase-sidebar-floating",
  #|        side=@rui.SidebarLeft,
  #|        variant=@rui.SidebarFloating,
  #|        collapsible=@rui.SidebarIcon,
  #|        mobile=false,
  #|        [
  #|          sidebar_navigation(
  #|            scope, @rui.SidebarLeft, @rui.SidebarMenuLg, false, true,
  #|          ),
  #|          @rui.sidebar_rail(scope),
  #|        ],
  #|      ),
  #|      @html.div(
  #|        style=["box-sizing:border-box;display:flex;min-width:0;flex:1;flex-direction:column;padding:0.75rem"],
  #|        sidebar_workspace_content(
  #|          scope,
  #|          "showcase-sidebar-floating",
  #|          false,
  #|          true,
  #|          panel_left_icon(),
  #|        ),
  #|      ),
  #|    ])
  #|  },
  #|)

///|
const IgSidebarInsetCode : String =
  #|@rui.sidebar_provider(
  #|  default_collapsed=false,
  #|  style=["--rui-sidebar-width:15rem;height:24rem;min-height:24rem;overflow:hidden"],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.sidebar(
  #|        scope,
  #|        id="showcase-sidebar-inset",
  #|        side=@rui.SidebarLeft,
  #|        variant=@rui.SidebarInset,
  #|        collapsible=@rui.SidebarOffcanvas,
  #|        mobile=false,
  #|        [
  #|          sidebar_navigation(
  #|            scope, @rui.SidebarLeft, @rui.SidebarMenuDefault, false, true,
  #|          ),
  #|          @rui.sidebar_rail(scope),
  #|        ],
  #|      ),
  #|      @rui.sidebar_inset(
  #|        style=["box-sizing:border-box;display:flex;min-width:0;flex:1;flex-direction:column;padding:0.75rem"],
  #|        sidebar_workspace_content(
  #|          scope,
  #|          "showcase-sidebar-inset",
  #|          false,
  #|          true,
  #|          panel_left_icon(),
  #|        ),
  #|      ),
  #|    ])
  #|  },
  #|)

///|
const IgSidebarRightCode : String =
  #|fn panel_right_icon() -> @html.Html {
  #|  stroke_icon("M3 3h18v18H3zM15 3v18")
  #|}
  #|
  #|@rui.sidebar_provider(
  #|  default_collapsed=false,
  #|  style=["--rui-sidebar-width:15rem;height:24rem;min-height:24rem;overflow:hidden"],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.sidebar(
  #|        scope,
  #|        id="showcase-sidebar-right",
  #|        side=@rui.SidebarRight,
  #|        variant=@rui.SidebarDefault,
  #|        collapsible=@rui.SidebarIcon,
  #|        mobile=false,
  #|        [
  #|          sidebar_navigation(
  #|            scope, @rui.SidebarRight, @rui.SidebarMenuDefault, false, true,
  #|          ),
  #|          @rui.sidebar_rail(scope),
  #|        ],
  #|      ),
  #|      @html.div(
  #|        style=["box-sizing:border-box;display:flex;min-width:0;flex:1;flex-direction:column;padding:0.75rem"],
  #|        sidebar_workspace_content(
  #|          scope,
  #|          "showcase-sidebar-right",
  #|          false,
  #|          true,
  #|          panel_right_icon(),
  #|        ),
  #|      ),
  #|    ])
  #|  },
  #|)

///|
const IgSidebarResizeCode : String =
  #|@rui.sidebar_provider(
  #|  default_collapsed=false,
  #|  style=["--rui-sidebar-width:15rem;height:24rem;min-height:24rem;overflow:hidden"],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.sidebar(
  #|        scope,
  #|        id="showcase-sidebar-resize",
  #|        side=@rui.SidebarLeft,
  #|        variant=@rui.SidebarDefault,
  #|        collapsible=@rui.SidebarIcon,
  #|        mobile=false,
  #|        [
  #|          sidebar_navigation(
  #|            scope, @rui.SidebarLeft, @rui.SidebarMenuDefault, false, true,
  #|          ),
  #|          @rui.sidebar_rail(
  #|            scope,
  #|            min_width=192,
  #|            max_width=352,
  #|          ),
  #|        ],
  #|      ),
  #|      @html.div(
  #|        style=["box-sizing:border-box;display:flex;min-width:0;flex:1;flex-direction:column;padding:0.75rem"],
  #|        sidebar_workspace_content(
  #|          scope,
  #|          "showcase-sidebar-resize",
  #|          false,
  #|          true,
  #|          panel_left_icon(),
  #|        ),
  #|      ),
  #|    ])
  #|  },
  #|)

///|
const IgSidebarMobileCode : String =
  #|@rui.sidebar_provider(
  #|  default_collapsed=false,
  #|  style=["--rui-sidebar-width:15rem;height:24rem;min-height:24rem;overflow:hidden"],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.sidebar(
  #|        scope,
  #|        id="showcase-sidebar-mobile",
  #|        side=@rui.SidebarLeft,
  #|        variant=@rui.SidebarDefault,
  #|        collapsible=@rui.SidebarOffcanvas,
  #|        mobile=true,
  #|        [
  #|          sidebar_navigation(
  #|            scope, @rui.SidebarLeft, @rui.SidebarMenuDefault, true, true,
  #|          ),
  #|          @html.nothing,
  #|        ],
  #|      ),
  #|      @html.div(
  #|        style=["box-sizing:border-box;display:flex;min-width:0;flex:1;flex-direction:column;padding:0.75rem"],
  #|        sidebar_workspace_content(
  #|          scope,
  #|          "showcase-sidebar-mobile",
  #|          true,
  #|          true,
  #|          panel_left_icon(),
  #|        ),
  #|      ),
  #|    ])
  #|  },
  #|)

///|
fn ig_sidebar_code(call : String) -> String {
  IgSidebarSharedCode + "\n\n" + call
}

///|
const IgAlertDialogDefaultCode : String =
  #|@html.fragment([
  #|  @rui.button(
  #|    variant=@rui.Outline,
  #|    on_click=@dialog.show("showcase-alert-dialog-default"),
  #|    "Archive project",
  #|  ),
  #|  @rui.alert_dialog(
  #|    id="showcase-alert-dialog-default",
  #|    attrs=@html.Attrs::build()
  #|      .aria_labelledby("showcase-alert-dialog-default-title")
  #|      .aria_describedby("showcase-alert-dialog-default-description"),
  #|    [
  #|      @rui.alert_dialog_header([
  #|        @rui.alert_dialog_title(
  #|          id="showcase-alert-dialog-default-title",
  #|          "Archive this project?",
  #|        ),
  #|        @rui.alert_dialog_description(
  #|          id="showcase-alert-dialog-default-description",
  #|          "You can restore an archived project later from workspace settings.",
  #|        ),
  #|      ]),
  #|      @html.form(
  #|        method_="dialog",
  #|        @rui.alert_dialog_footer([
  #|          @rui.alert_dialog_cancel("Cancel"),
  #|          @rui.alert_dialog_action("Archive"),
  #|        ]),
  #|      ),
  #|    ],
  #|  ),
  #|])

///|
const IgAlertDialogDestructiveCode : String =
  #|fn alert_triangle_icon() -> @html.Html {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=["display:inline-flex;width:2rem;height:2rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none"],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d="M21.73 18 13.73 4a2 2 0 0 0-3.46 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3ZM12 9v4M12 17h.01",
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|
  #|@html.fragment([
  #|  @rui.button(
  #|    variant=@rui.Destructive,
  #|    on_click=@dialog.show("showcase-alert-dialog"),
  #|    "Delete snapshot",
  #|  ),
  #|  @rui.alert_dialog(
  #|    id="showcase-alert-dialog",
  #|    attrs=@html.Attrs::build()
  #|      .aria_labelledby("showcase-alert-dialog-title")
  #|      .aria_describedby("showcase-alert-dialog-description"),
  #|    [
  #|      @rui.alert_dialog_header([
  #|        @rui.alert_dialog_media(alert_triangle_icon()),
  #|        @rui.alert_dialog_title(
  #|          id="showcase-alert-dialog-title",
  #|          "Delete this snapshot?",
  #|        ),
  #|        @rui.alert_dialog_description(
  #|          id="showcase-alert-dialog-description",
  #|          "This removes the saved state permanently.",
  #|        ),
  #|      ]),
  #|      @html.form(
  #|        method_="dialog",
  #|        @rui.alert_dialog_footer([
  #|          @rui.alert_dialog_cancel("Cancel"),
  #|          @rui.alert_dialog_action("Delete"),
  #|        ]),
  #|      ),
  #|    ],
  #|  ),
  #|])

///|
const IgDialogSharedCode : String =
  #|fn dialog_variant(
  #|  id : String,
  #|  modal : Bool,
  #|  trigger_variant : @rui.ButtonVariant,
  #|  trigger_label : String,
  #|) -> @rabbita.Val[@html.Html] {
  #|  @rabbita.Val::constant(
  #|    @html.fragment([
  #|      @rui.button(
  #|        variant=trigger_variant,
  #|        on_click=@dialog.show(id, modal~),
  #|        trigger_label,
  #|      ),
  #|      @rui.dialog(
  #|        id~,
  #|        attrs=@html.Attrs::build()
  #|          .aria_labelledby(id + "-title")
  #|          .aria_describedby(id + "-description"),
  #|        [
  #|          @rui.dialog_header([
  #|            @rui.dialog_title(id=id + "-title", trigger_label),
  #|            @rui.dialog_description(
  #|              id=id + "-description",
  #|              if modal {
  #|                "Focus stays inside this modal surface until it closes."
  #|              } else {
  #|                "This non-modal surface leaves the surrounding page available."
  #|              },
  #|            ),
  #|          ]),
  #|          @html.form(
  #|            method_="dialog",
  #|            [
  #|              @html.div(style=["display:flex;flex-direction:column;gap:1rem"], [
  #|                @rui.label(for_=id + "-name", "Display name"),
  #|                @rui.input(id=id + "-name", value="Rabbita team"),
  #|              ]),
  #|              @rui.dialog_footer(@rui.button(type_="submit", "Save changes")),
  #|            ],
  #|          ),
  #|        ],
  #|      ),
  #|    ]),
  #|  )
  #|}
  #|

///|
const IgDialogModalCallCode : String =
  #|dialog_variant(
  #|  "showcase-dialog-modal",
  #|  true,
  #|  @rui.Outline,
  #|  "Edit profile",
  #|)

///|
const IgDialogNonModalCallCode : String =
  #|dialog_variant(
  #|  "showcase-dialog-nonmodal",
  #|  false,
  #|  @rui.Secondary,
  #|  "Open non-modal",
  #|)

///|
fn ig_dialog_code(call : String) -> String {
  IgDialogSharedCode + "\n\n" + call
}

///|
const IgDrawerSharedCode : String =
  #|fn drawer_variant(
  #|  id : String,
  #|  direction : @rui.DrawerDirection,
  #|  trigger_label : String,
  #|) -> @html.Html {
  #|  @html.fragment([
  #|    @rui.button(variant=@rui.Outline, on_click=@dialog.show(id), trigger_label),
  #|    @rui.drawer(
  #|      id~,
  #|      direction~,
  #|      swipe_area=50,
  #|      attrs=@html.Attrs::build()
  #|        .aria_labelledby(id + "-title")
  #|        .aria_describedby(id + "-description"),
  #|      [
  #|        @rui.drawer_header([
  #|          @rui.drawer_title(id=id + "-title", trigger_label),
  #|          @rui.drawer_description(
  #|            id=id + "-description",
  #|            "Drag beside the drawer to dismiss, or use the close button below.",
  #|          ),
  #|        ]),
  #|        @html.div(style=["border:1px solid var(--rui-border);border-radius:0.5rem;padding:1rem;text-align:center"], "All checks passed"),
  #|        @rui.drawer_footer(
  #|          @html.form(
  #|            method_="dialog",
  #|            @rui.button(
  #|              variant=@rui.Outline,
  #|              type_="submit",
  #|              style=["width:100%"],
  #|              "Close",
  #|            ),
  #|          ),
  #|        ),
  #|      ],
  #|    ),
  #|  ])
  #|}

///|
const IgDrawerTopCallCode : String =
  #|drawer_variant(
  #|  "showcase-drawer-top",
  #|  @rui.DrawerTop,
  #|  "Open top drawer",
  #|)

///|
const IgDrawerRightCallCode : String =
  #|drawer_variant(
  #|  "showcase-drawer-right",
  #|  @rui.DrawerRight,
  #|  "Open right drawer",
  #|)

///|
const IgDrawerBottomCallCode : String =
  #|drawer_variant(
  #|  "showcase-drawer-bottom",
  #|  @rui.DrawerBottom,
  #|  "Open bottom drawer",
  #|)

///|
const IgDrawerLeftCallCode : String =
  #|drawer_variant(
  #|  "showcase-drawer-left",
  #|  @rui.DrawerLeft,
  #|  "Open left drawer",
  #|)

///|
fn ig_drawer_code(call : String) -> String {
  IgDrawerSharedCode + "\n\n" + call
}

///|
const IgMenuStrokeIconCode : String =
  #|fn showcase_stroke_icon(
  #|  path : String,
  #|  box_size? : String = "1rem",
  #|) -> @html.Html {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=["display:inline-flex;width:\{box_size};height:\{box_size};flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none"],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d=path,
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}

///|
fn ig_menu_code(icon_helpers : String, component : String) -> String {
  IgMenuStrokeIconCode + "\n\n" + icon_helpers + "\n\n" + component
}

///|
const IgContextMenuActionsIconsCode : String =
  #|fn showcase_copy_icon() -> @html.Html {
  #|  showcase_stroke_icon("M8 8h12a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H10a2 2 0 0 1-2-2ZM4 16a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2")
  #|}
  #|
  #|fn showcase_settings_icon() -> @html.Html {
  #|  showcase_stroke_icon("M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.38a2 2 0 0 0-.73-2.73l-.15-.09a2 2 0 0 1-1-1.74v-.51a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2zM12 15.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Z")
  #|}
  #|
  #|fn showcase_file_icon() -> @html.Html {
  #|  showcase_stroke_icon("M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6")
  #|}
  #|
  #|fn showcase_archive_icon() -> @html.Html {
  #|  showcase_stroke_icon("M21 8v13H3V8M1 3h22v5H1zM10 12h4")
  #|}

///|
const IgContextMenuActionsCode : String =
  #|@rui.context_menu(
  #|  id="showcase-context-menu-actions",
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.context_menu_trigger(
  #|        scope,
  #|        style=["display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px dashed var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);color:var(--rui-muted-foreground);font-size:0.8125rem;text-align:center;user-select:none"],
  #|        "Right-click for canvas actions",
  #|      ),
  #|      @rui.context_menu_portal([
  #|        @rui.context_menu_content(scope, aria_label="Canvas actions", [
  #|          @rui.context_menu_group(aria_label="Canvas", [
  #|            @rui.context_menu_label("Canvas"),
  #|            @rui.context_menu_item(scope, [
  #|              showcase_copy_icon(),
  #|              @html.span("Duplicate"),
  #|              @rui.context_menu_shortcut("⌘D"),
  #|            ]),
  #|            @rui.context_menu_item(scope, [
  #|              showcase_settings_icon(),
  #|              @html.span("Rename"),
  #|            ]),
  #|            @rui.context_menu_item(scope, [
  #|              showcase_file_icon(),
  #|              @html.span("Export"),
  #|              @rui.context_menu_shortcut("⇧⌘E"),
  #|            ]),
  #|            @rui.context_menu_item(scope, disabled=true, [
  #|              showcase_archive_icon(),
  #|              @html.span("Paste"),
  #|            ]),
  #|          ]),
  #|        ]),
  #|      ]),
  #|    ])
  #|  },
  #|)

///|
const IgContextMenuSubmenuIconsCode : String =
  #|fn showcase_settings_icon() -> @html.Html {
  #|  showcase_stroke_icon("M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.38a2 2 0 0 0-.73-2.73l-.15-.09a2 2 0 0 1-1-1.74v-.51a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2zM12 15.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Z")
  #|}
  #|
  #|fn showcase_archive_icon() -> @html.Html {
  #|  showcase_stroke_icon("M21 8v13H3V8M1 3h22v5H1zM10 12h4")
  #|}
  #|
  #|fn showcase_layout_icon() -> @html.Html {
  #|  showcase_stroke_icon("M4 4h16v16H4zM4 9h16M9 9v11")
  #|}
  #|
  #|fn showcase_activity_icon() -> @html.Html {
  #|  showcase_stroke_icon("M3 12h4l2-8 4 16 2-8h6")
  #|}
  #|
  #|fn showcase_close_icon() -> @html.Html {
  #|  showcase_stroke_icon("M18 6 6 18M6 6l12 12")
  #|}

///|
const IgContextMenuSubmenuCode : String =
  #|@rui.context_menu(
  #|  id="showcase-context-menu-submenu",
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.context_menu_trigger(
  #|        scope,
  #|        style=["display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px dashed var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);color:var(--rui-muted-foreground);font-size:0.8125rem;text-align:center;user-select:none"],
  #|        "Right-click for project options",
  #|      ),
  #|      @rui.context_menu_portal([
  #|        @rui.context_menu_content(scope, aria_label="Project options", [
  #|          @rui.context_menu_item(scope, [
  #|            showcase_settings_icon(),
  #|            @html.span("Project settings"),
  #|          ]),
  #|          @rui.context_menu_sub(scope, value="move", sub => {
  #|            @html.fragment([
  #|              @rui.context_menu_sub_trigger(sub, [
  #|                showcase_archive_icon(),
  #|                @html.span("Move to"),
  #|              ]),
  #|              @rui.context_menu_sub_content(sub, [
  #|                @rui.context_menu_group(aria_label="Destination", [
  #|                  @rui.context_menu_label("Destination"),
  #|                  @rui.context_menu_item(scope, [
  #|                    showcase_layout_icon(),
  #|                    @html.span("Design system"),
  #|                  ]),
  #|                  @rui.context_menu_item(scope, [
  #|                    showcase_activity_icon(),
  #|                    @html.span("Experiments"),
  #|                  ]),
  #|                ]),
  #|              ]),
  #|            ])
  #|          }),
  #|          @rui.context_menu_separator(),
  #|          @rui.context_menu_item(scope, destructive=true, [
  #|            showcase_close_icon(),
  #|            @html.span("Delete project"),
  #|          ]),
  #|        ]),
  #|      ]),
  #|    ])
  #|  },
  #|)

///|
const IgContextMenuCheckboxIconsCode : String =
  #|fn showcase_layout_icon() -> @html.Html {
  #|  showcase_stroke_icon("M4 4h16v16H4zM4 9h16M9 9v11")
  #|}
  #|
  #|fn showcase_panel_left_icon() -> @html.Html {
  #|  showcase_stroke_icon("M3 3h18v18H3zM9 3v18")
  #|}
  #|
  #|fn showcase_activity_icon() -> @html.Html {
  #|  showcase_stroke_icon("M3 12h4l2-8 4 16 2-8h6")
  #|}
  #|

///|
const IgContextMenuCheckboxCode : String =
  #|@rui.context_menu(
  #|  id="showcase-context-menu-checkbox",
  #|  default_checked_values=["grid", "activity"],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.context_menu_trigger(
  #|        scope,
  #|        style=["display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px dashed var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);color:var(--rui-muted-foreground);font-size:0.8125rem;text-align:center;user-select:none"],
  #|        "Right-click for visibility controls",
  #|      ),
  #|      @rui.context_menu_portal([
  #|        @rui.context_menu_content(scope, aria_label="Visibility controls", [
  #|          @rui.context_menu_group(aria_label="Visibility", [
  #|            @rui.context_menu_label("Visibility"),
  #|            @rui.context_menu_checkbox_item(scope, value="grid", [
  #|              showcase_layout_icon(),
  #|              @html.span("Show grid"),
  #|            ]),
  #|            @rui.context_menu_checkbox_item(scope, value="sidebar", [
  #|              showcase_panel_left_icon(),
  #|              @html.span("Show sidebar"),
  #|            ]),
  #|            @rui.context_menu_checkbox_item(scope, value="activity", [
  #|              showcase_activity_icon(),
  #|              @html.span("Show activity"),
  #|            ]),
  #|          ]),
  #|        ]),
  #|      ]),
  #|    ])
  #|  },
  #|)

///|
const IgContextMenuRadioIconsCode : String =
  #|fn showcase_layout_icon() -> @html.Html {
  #|  showcase_stroke_icon("M4 4h16v16H4zM4 9h16M9 9v11")
  #|}
  #|
  #|fn showcase_file_icon() -> @html.Html {
  #|  showcase_stroke_icon("M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6")
  #|}
  #|
  #|fn showcase_activity_icon() -> @html.Html {
  #|  showcase_stroke_icon("M3 12h4l2-8 4 16 2-8h6")
  #|}

///|
const IgContextMenuRadioCode : String =
  #|@rui.context_menu(
  #|  id="showcase-context-menu-radio",
  #|  default_radio_values=[("layout", "canvas")],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.context_menu_trigger(
  #|        scope,
  #|        style=["display:flex;min-height:8rem;align-items:center;justify-content:center;border:1px dashed var(--rui-border);border-radius:var(--rui-radius);background:var(--rui-muted);color:var(--rui-muted-foreground);font-size:0.8125rem;text-align:center;user-select:none"],
  #|        "Right-click for layout controls",
  #|      ),
  #|      @rui.context_menu_portal([
  #|        @rui.context_menu_content(scope, aria_label="Layout controls", [
  #|          @rui.context_menu_group(aria_label="Layout", [
  #|            @rui.context_menu_label("Layout"),
  #|            @rui.context_menu_radio_group(scope, value="layout", radio => {
  #|              @html.fragment([
  #|                @rui.context_menu_radio_item(radio, value="canvas", [
  #|                  showcase_layout_icon(),
  #|                  @html.span("Canvas"),
  #|                ]),
  #|                @rui.context_menu_radio_item(radio, value="editor", [
  #|                  showcase_file_icon(),
  #|                  @html.span("Editor"),
  #|                ]),
  #|                @rui.context_menu_radio_item(radio, value="focus", [
  #|                  showcase_activity_icon(),
  #|                  @html.span("Focus"),
  #|                ]),
  #|              ])
  #|            }),
  #|          ]),
  #|        ]),
  #|      ]),
  #|    ])
  #|  },
  #|)

///|
const IgCommandInlineCode : String =
  #|@rui.command(
  #|  id="showcase-command",
  #|  style=["max-width:none;border:1px solid var(--rui-border);border-radius:var(--rui-radius);box-shadow:none"],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.command_input(scope~, placeholder="Search actions…"),
  #|      @rui.command_list(scope~, [
  #|        @rui.command_empty(scope~, "No matching actions."),
  #|        @rui.command_group(scope~, heading="Workspace", [
  #|          @rui.command_item(
  #|            scope~,
  #|            value="Open dashboard",
  #|            keywords=["home"],
  #|            [@html.span("Open dashboard"), @rui.command_shortcut("⌘D")],
  #|          ),
  #|          @rui.command_item(scope~, value="Create project", keywords=["new"], [
  #|            @html.span("Create project"),
  #|            @rui.command_shortcut("⌘N"),
  #|          ]),
  #|          @rui.command_separator(),
  #|          @rui.command_item(
  #|            scope~,
  #|            value="Settings",
  #|            keywords=["preferences"],
  #|            "Settings",
  #|          ),
  #|        ]),
  #|      ]),
  #|    ])
  #|  },
  #|)

///|
const IgCommandDialogCode : String =
  #|@rui.command_dialog(
  #|  id="showcase-command-dialog",
  #|  aria_label="Command palette",
  #|  trigger=scope => {
  #|    @rui.command_dialog_trigger(scope~, variant=@rui.Outline, "Open palette")
  #|  },
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.command_input(scope~, placeholder="Type a command…"),
  #|      @rui.command_list(scope~, [
  #|        @rui.command_empty(scope~, "No matching commands."),
  #|        @rui.command_group(scope~, heading="Navigation", [
  #|          @rui.command_item(scope~, value="Go to overview", "Go to overview"),
  #|          @rui.command_item(scope~, value="Open settings", "Open settings"),
  #|          @rui.command_item(
  #|            scope~,
  #|            value="Unavailable command",
  #|            disabled=true,
  #|            "Unavailable command",
  #|          ),
  #|        ]),
  #|      ]),
  #|    ])
  #|  },
  #|)

///|
const IgDropdownMenuBasicCode : String =
  #|@rui.dropdown_menu(
  #|  id="showcase-dropdown-menu-basic",
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.dropdown_menu_trigger(scope, variant=@rui.Outline, "Workspace menu"),
  #|      @rui.dropdown_menu_portal([
  #|        @rui.dropdown_menu_content(scope, side=@rui.Bottom, align=@rui.Start, [
  #|          @rui.dropdown_menu_group(aria_label="Workspace", [
  #|            @rui.dropdown_menu_label("Workspace"),
  #|            @rui.dropdown_menu_item(scope, [
  #|              @html.span("New tab"),
  #|              @rui.dropdown_menu_shortcut("⌘T"),
  #|            ]),
  #|            @rui.dropdown_menu_item(scope, "Invite member"),
  #|            @rui.dropdown_menu_item(scope, "Move workspace"),
  #|            @rui.dropdown_menu_item(
  #|              scope,
  #|              disabled=true,
  #|              "Duplicate workspace",
  #|            ),
  #|          ]),
  #|        ]),
  #|      ]),
  #|    ])
  #|  },
  #|)

///|
const IgDropdownMenuIconsIconsCode : String =
  #|fn showcase_user_icon() -> @html.Html {
  #|  showcase_stroke_icon("M20 21a8 8 0 0 0-16 0M12 13a5 5 0 1 0 0-10 5 5 0 0 0 0 10Z")
  #|}
  #|
  #|fn showcase_credit_card_icon() -> @html.Html {
  #|  showcase_stroke_icon("M2 10h20M4 4h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2Z")
  #|}
  #|
  #|fn showcase_settings_icon() -> @html.Html {
  #|  showcase_stroke_icon("M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.38a2 2 0 0 0-.73-2.73l-.15-.09a2 2 0 0 1-1-1.74v-.51a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2zM12 15.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Z")
  #|}
  #|
  #|fn showcase_log_out_icon() -> @html.Html {
  #|  showcase_stroke_icon("m16 17 5-5-5-5M21 12H9M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4")
  #|}

///|
const IgDropdownMenuIconsCode : String =
  #|@rui.dropdown_menu(
  #|  id="showcase-dropdown-menu-icons",
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.dropdown_menu_trigger(scope, variant=@rui.Outline, "Account"),
  #|      @rui.dropdown_menu_portal([
  #|        @rui.dropdown_menu_content(
  #|          scope,
  #|          side=@rui.Bottom,
  #|          align=@rui.Start,
  #|          style=["min-width:12rem"],
  #|          [
  #|            @rui.dropdown_menu_item(scope, [
  #|              showcase_user_icon(),
  #|              @html.span("Profile"),
  #|            ]),
  #|            @rui.dropdown_menu_item(scope, [
  #|              showcase_credit_card_icon(),
  #|              @html.span("Billing"),
  #|            ]),
  #|            @rui.dropdown_menu_item(scope, [
  #|              showcase_settings_icon(),
  #|              @html.span("Settings"),
  #|            ]),
  #|            @rui.dropdown_menu_separator(),
  #|            @rui.dropdown_menu_item(scope, destructive=true, [
  #|              showcase_log_out_icon(),
  #|              @html.span("Log out"),
  #|            ]),
  #|          ],
  #|        ),
  #|      ]),
  #|    ])
  #|  },
  #|)

///|
const IgDropdownMenuCheckboxIconsCode : String =
  #|fn showcase_mail_icon() -> @html.Html {
  #|  showcase_stroke_icon("m22 7-8.991 5.727a2 2 0 0 1-2.009 0L2 7M4 4h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2Z")
  #|}
  #|
  #|fn showcase_message_square_icon() -> @html.Html {
  #|  showcase_stroke_icon("M21 15a4 4 0 0 1-4 4H7l-4 4V7a4 4 0 0 1 4-4h10a4 4 0 0 1 4 4Z")
  #|}
  #|
  #|fn showcase_bell_icon() -> @html.Html {
  #|  showcase_stroke_icon("M10.268 21a2 2 0 0 0 3.464 0M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326")
  #|}
  #|

///|
const IgDropdownMenuCheckboxCode : String =
  #|@rui.dropdown_menu(
  #|  id="showcase-dropdown-menu-checkbox",
  #|  default_checked_values=["email", "push"],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.dropdown_menu_trigger(scope, variant=@rui.Outline, "Notifications"),
  #|      @rui.dropdown_menu_portal([
  #|        @rui.dropdown_menu_content(scope, style=["min-width:14rem"], [
  #|          @rui.dropdown_menu_group(aria_label="Notifications", [
  #|            @rui.dropdown_menu_label("Notifications"),
  #|            @rui.dropdown_menu_checkbox_item(scope, value="email", [
  #|              showcase_mail_icon(),
  #|              @html.span("Email"),
  #|            ]),
  #|            @rui.dropdown_menu_checkbox_item(scope, value="sms", [
  #|              showcase_message_square_icon(),
  #|              @html.span("SMS"),
  #|            ]),
  #|            @rui.dropdown_menu_checkbox_item(scope, value="push", [
  #|              showcase_bell_icon(),
  #|              @html.span("Push notifications"),
  #|            ]),
  #|          ]),
  #|        ]),
  #|      ]),
  #|    ])
  #|  },
  #|)

///|
const IgDropdownMenuRadioIconsCode : String =
  #|fn showcase_credit_card_icon() -> @html.Html {
  #|  showcase_stroke_icon("M2 10h20M4 4h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2Z")
  #|}
  #|
  #|fn showcase_wallet_icon() -> @html.Html {
  #|  showcase_stroke_icon("M20 7V6a2 2 0 0 0-2-2H5a3 3 0 0 0 0 6h15v10H5a3 3 0 0 1-3-3V7M16 14h.01")
  #|}
  #|
  #|fn showcase_building_icon() -> @html.Html {
  #|  showcase_stroke_icon("M6 22V4a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v18M6 12H4a2 2 0 0 0-2 2v8h20v-8a2 2 0 0 0-2-2h-2M10 6h4M10 10h4M10 14h4M10 18h4")
  #|}

///|
const IgDropdownMenuRadioCode : String =
  #|@rui.dropdown_menu(
  #|  id="showcase-dropdown-menu-radio",
  #|  default_radio_values=[("payment", "card")],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.dropdown_menu_trigger(scope, variant=@rui.Outline, "Payment method"),
  #|      @rui.dropdown_menu_portal([
  #|        @rui.dropdown_menu_content(scope, style=["min-width:14rem"], [
  #|          @rui.dropdown_menu_group(aria_label="Payment method", [
  #|            @rui.dropdown_menu_label("Payment method"),
  #|            @rui.dropdown_menu_radio_group(scope, value="payment", radio => {
  #|              @html.fragment([
  #|                @rui.dropdown_menu_radio_item(radio, value="card", [
  #|                  showcase_credit_card_icon(),
  #|                  @html.span("Credit card"),
  #|                ]),
  #|                @rui.dropdown_menu_radio_item(radio, value="wallet", [
  #|                  showcase_wallet_icon(),
  #|                  @html.span("PayPal"),
  #|                ]),
  #|                @rui.dropdown_menu_radio_item(radio, value="bank", [
  #|                  showcase_building_icon(),
  #|                  @html.span("Bank transfer"),
  #|                ]),
  #|              ])
  #|            }),
  #|          ]),
  #|        ]),
  #|      ]),
  #|    ])
  #|  },
  #|)

///|
const IgDropdownMenuSubmenuCode : String =
  #|@rui.dropdown_menu(
  #|  id="showcase-dropdown-menu-submenu",
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.dropdown_menu_trigger(
  #|        scope,
  #|        variant=@rui.Secondary,
  #|        size=@rui.Sm,
  #|        "Top-end menu",
  #|      ),
  #|      @rui.dropdown_menu_portal([
  #|        @rui.dropdown_menu_content(
  #|          scope,
  #|          side=@rui.Top,
  #|          align=@rui.End,
  #|          style=["min-width:12rem"],
  #|          [
  #|            @rui.dropdown_menu_item(scope, [
  #|              @html.span("Open workspace"),
  #|              @rui.dropdown_menu_shortcut("⌘O"),
  #|            ]),
  #|            @rui.dropdown_menu_sub(scope, value="share", sub => {
  #|              @html.fragment([
  #|                @rui.dropdown_menu_sub_trigger(sub, "Share"),
  #|                @rui.dropdown_menu_sub_content(sub, [
  #|                  @rui.dropdown_menu_group(aria_label="Share workspace", [
  #|                    @rui.dropdown_menu_label("Share workspace"),
  #|                    @rui.dropdown_menu_item(scope, "Copy link"),
  #|                    @rui.dropdown_menu_item(scope, "Invite people"),
  #|                  ]),
  #|                ]),
  #|              ])
  #|            }),
  #|            @rui.dropdown_menu_item(scope, disabled=true, "Unavailable"),
  #|          ],
  #|        ),
  #|      ]),
  #|    ])
  #|  },
  #|)

///|
const IgDropdownMenuMultiLevelIconsCode : String =
  #|fn showcase_file_icon() -> @html.Html {
  #|  showcase_stroke_icon("M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6")
  #|}
  #|
  #|fn showcase_folder_icon() -> @html.Html {
  #|  showcase_stroke_icon("M3 6a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2Z")
  #|}
  #|
  #|fn showcase_folder_open_icon() -> @html.Html {
  #|  showcase_stroke_icon("M6 14l1.5-4h12.8a1.5 1.5 0 0 1 1.42 2l-2.1 6.2A2 2 0 0 1 17.72 20H5a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2")
  #|}
  #|
  #|fn showcase_layout_icon() -> @html.Html {
  #|  showcase_stroke_icon("M4 4h16v16H4zM4 9h16M9 9v11")
  #|}
  #|
  #|fn showcase_activity_icon() -> @html.Html {
  #|  showcase_stroke_icon("M3 12h4l2-8 4 16 2-8h6")
  #|}
  #|
  #|fn showcase_archive_icon() -> @html.Html {
  #|  showcase_stroke_icon("M21 8v13H3V8M1 3h22v5H1zM10 12h4")
  #|}

///|
const IgDropdownMenuMultiLevelCode : String =
  #|@rui.dropdown_menu(
  #|  id="showcase-dropdown-menu-multilevel",
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.dropdown_menu_trigger(scope, variant=@rui.Outline, "Organize file"),
  #|      @rui.dropdown_menu_portal([
  #|        @rui.dropdown_menu_content(scope, style=["min-width:13rem"], [
  #|          @rui.dropdown_menu_item(scope, [
  #|            showcase_file_icon(),
  #|            @html.span("Rename"),
  #|          ]),
  #|          @rui.dropdown_menu_sub(scope, value="move", destination => {
  #|            @html.fragment([
  #|              @rui.dropdown_menu_sub_trigger(destination, [
  #|                showcase_folder_icon(),
  #|                @html.span("Move to"),
  #|              ]),
  #|              @rui.dropdown_menu_sub_content(
  #|                destination,
  #|                style=["min-width:12rem"],
  #|                [
  #|                  @rui.dropdown_menu_label("Destination"),
  #|                  @rui.dropdown_menu_item(scope, [
  #|                    showcase_folder_icon(),
  #|                    @html.span("Inbox"),
  #|                  ]),
  #|                  @rui.dropdown_menu_sub(scope, value="projects", project => {
  #|                    @html.fragment([
  #|                      @rui.dropdown_menu_sub_trigger(project, [
  #|                        showcase_folder_open_icon(),
  #|                        @html.span("Projects"),
  #|                      ]),
  #|                      @rui.dropdown_menu_sub_content(
  #|                        project,
  #|                        style=["min-width:13rem"],
  #|                        [
  #|                          @rui.dropdown_menu_group(
  #|                            aria_label="Project destination",
  #|                            [
  #|                              @rui.dropdown_menu_label("Project destination"),
  #|                              @rui.dropdown_menu_item(scope, [
  #|                                showcase_layout_icon(),
  #|                                @html.span("Design system"),
  #|                              ]),
  #|                              @rui.dropdown_menu_item(scope, [
  #|                                showcase_activity_icon(),
  #|                                @html.span("Experiments"),
  #|                              ]),
  #|                            ],
  #|                          ),
  #|                        ],
  #|                      ),
  #|                    ])
  #|                  }),
  #|                ],
  #|              ),
  #|            ])
  #|          }),
  #|          @rui.dropdown_menu_separator(),
  #|          @rui.dropdown_menu_item(scope, destructive=true, [
  #|            showcase_archive_icon(),
  #|            @html.span("Archive"),
  #|          ]),
  #|        ]),
  #|      ]),
  #|    ])
  #|  },
  #|)

///|
const IgMenubarCommandsIconsCode : String =
  #|fn showcase_plus_icon() -> @html.Html {
  #|  showcase_stroke_icon("M12 5v14M5 12h14")
  #|}
  #|
  #|fn showcase_file_icon() -> @html.Html {
  #|  showcase_stroke_icon("M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6")
  #|}
  #|
  #|fn showcase_archive_icon() -> @html.Html {
  #|  showcase_stroke_icon("M21 8v13H3V8M1 3h22v5H1zM10 12h4")
  #|}
  #|
  #|fn showcase_circle_help_icon() -> @html.Html {
  #|  showcase_stroke_icon("M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0ZM9.1 9a3 3 0 1 1 5.8 1c0 2-2.9 2-2.9 4M12 17h.01")
  #|}

///|
const IgMenubarCommandsCode : String =
  #|@rui.menubar(id="showcase-menubar-commands", scope => {
  #|  @html.fragment([
  #|    @rui.menubar_menu(scope, value="file", menu => {
  #|      @html.fragment([
  #|        @rui.menubar_trigger(menu, "File"),
  #|        @rui.menubar_portal([
  #|          @rui.menubar_content(menu, [
  #|            @rui.menubar_group(aria_label="Project commands", [
  #|              @rui.menubar_label("Project"),
  #|              @rui.menubar_item(menu, [
  #|                showcase_plus_icon(),
  #|                @html.span("New project"),
  #|                @rui.menubar_shortcut("⌘N"),
  #|              ]),
  #|              @rui.menubar_item(menu, [
  #|                showcase_file_icon(),
  #|                @html.span("Open…"),
  #|                @rui.menubar_shortcut("⌘O"),
  #|              ]),
  #|              @rui.menubar_item(menu, disabled=true, [
  #|                showcase_archive_icon(),
  #|                @html.span("Import"),
  #|              ]),
  #|            ]),
  #|          ]),
  #|        ]),
  #|      ])
  #|    }),
  #|    @rui.menubar_menu(scope, value="help", menu => {
  #|      @html.fragment([
  #|        @rui.menubar_trigger(menu, "Help"),
  #|        @rui.menubar_portal([
  #|          @rui.menubar_content(menu, [
  #|            @rui.menubar_group(aria_label="Help", [
  #|              @rui.menubar_label("Help"),
  #|              @rui.menubar_item(menu, [
  #|                showcase_circle_help_icon(),
  #|                @html.span("Keyboard shortcuts"),
  #|                @rui.menubar_shortcut("?"),
  #|              ]),
  #|            ]),
  #|          ]),
  #|        ]),
  #|      ])
  #|    }),
  #|  ])
  #|})

///|
const IgMenubarSubmenuIconsCode : String =
  #|fn showcase_settings_icon() -> @html.Html {
  #|  showcase_stroke_icon("M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.38a2 2 0 0 0-.73-2.73l-.15-.09a2 2 0 0 1-1-1.74v-.51a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2zM12 15.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Z")
  #|}
  #|
  #|fn showcase_layout_icon() -> @html.Html {
  #|  showcase_stroke_icon("M4 4h16v16H4zM4 9h16M9 9v11")
  #|}
  #|
  #|fn showcase_file_icon() -> @html.Html {
  #|  showcase_stroke_icon("M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6")
  #|}
  #|
  #|fn showcase_activity_icon() -> @html.Html {
  #|  showcase_stroke_icon("M3 12h4l2-8 4 16 2-8h6")
  #|}
  #|
  #|fn showcase_close_icon() -> @html.Html {
  #|  showcase_stroke_icon("M18 6 6 18M6 6l12 12")
  #|}

///|
const IgMenubarSubmenuCode : String =
  #|@rui.menubar(id="showcase-menubar-submenu", scope => {
  #|  @html.fragment([
  #|    @rui.menubar_menu(scope, value="project", menu => {
  #|      @html.fragment([
  #|        @rui.menubar_trigger(menu, "Project"),
  #|        @rui.menubar_portal([
  #|          @rui.menubar_content(menu, [
  #|            @rui.menubar_item(menu, [
  #|              showcase_settings_icon(),
  #|              @html.span("Project settings"),
  #|            ]),
  #|            @rui.menubar_sub(menu, value="recent", sub => {
  #|              @html.fragment([
  #|                @rui.menubar_sub_trigger(sub, [
  #|                  showcase_layout_icon(),
  #|                  @html.span("Recent projects"),
  #|                ]),
  #|                @rui.menubar_sub_content(sub, [
  #|                  @rui.menubar_group(aria_label="Recent projects", [
  #|                    @rui.menubar_label("Recent projects"),
  #|                    @rui.menubar_item(menu, [
  #|                      showcase_file_icon(),
  #|                      @html.span("Design system"),
  #|                    ]),
  #|                    @rui.menubar_item(menu, [
  #|                      showcase_activity_icon(),
  #|                      @html.span("Experiments"),
  #|                    ]),
  #|                  ]),
  #|                ]),
  #|              ])
  #|            }),
  #|            @rui.menubar_separator(),
  #|            @rui.menubar_item(menu, destructive=true, [
  #|              showcase_close_icon(),
  #|              @html.span("Close project"),
  #|            ]),
  #|          ]),
  #|        ]),
  #|      ])
  #|    }),
  #|  ])
  #|})

///|
const IgMenubarCheckboxIconsCode : String =
  #|fn showcase_panel_left_icon() -> @html.Html {
  #|  showcase_stroke_icon("M3 3h18v18H3zM9 3v18")
  #|}
  #|
  #|fn showcase_activity_icon() -> @html.Html {
  #|  showcase_stroke_icon("M3 12h4l2-8 4 16 2-8h6")
  #|}
  #|
  #|fn showcase_layout_icon() -> @html.Html {
  #|  showcase_stroke_icon("M4 4h16v16H4zM4 9h16M9 9v11")
  #|}
  #|

///|
const IgMenubarCheckboxCode : String =
  #|@rui.menubar(
  #|  id="showcase-menubar-checkbox",
  #|  default_checked_values=["sidebar", "activity"],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.menubar_menu(scope, value="view", menu => {
  #|        @html.fragment([
  #|          @rui.menubar_trigger(menu, "View"),
  #|          @rui.menubar_portal([
  #|            @rui.menubar_content(menu, [
  #|              @rui.menubar_group(aria_label="Panels", [
  #|                @rui.menubar_label("Panels"),
  #|                @rui.menubar_checkbox_item(menu, value="sidebar", [
  #|                  showcase_panel_left_icon(),
  #|                  @html.span("Sidebar"),
  #|                ]),
  #|                @rui.menubar_checkbox_item(menu, value="activity", [
  #|                  showcase_activity_icon(),
  #|                  @html.span("Activity bar"),
  #|                ]),
  #|                @rui.menubar_checkbox_item(menu, value="status", [
  #|                  showcase_layout_icon(),
  #|                  @html.span("Status bar"),
  #|                ]),
  #|              ]),
  #|            ]),
  #|          ]),
  #|        ])
  #|      }),
  #|    ])
  #|  },
  #|)

///|
const IgMenubarRadioIconsCode : String =
  #|fn showcase_file_icon() -> @html.Html {
  #|  showcase_stroke_icon("M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6")
  #|}
  #|
  #|fn showcase_layout_icon() -> @html.Html {
  #|  showcase_stroke_icon("M4 4h16v16H4zM4 9h16M9 9v11")
  #|}
  #|
  #|fn showcase_activity_icon() -> @html.Html {
  #|  showcase_stroke_icon("M3 12h4l2-8 4 16 2-8h6")
  #|}

///|
const IgMenubarRadioCode : String =
  #|@rui.menubar(
  #|  id="showcase-menubar-radio",
  #|  default_radio_values=[("workspace", "editor")],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.menubar_menu(scope, value="workspace", menu => {
  #|        @html.fragment([
  #|          @rui.menubar_trigger(menu, "Workspace"),
  #|          @rui.menubar_portal([
  #|            @rui.menubar_content(menu, [
  #|              @rui.menubar_group(aria_label="Workspace mode", [
  #|                @rui.menubar_label("Workspace mode"),
  #|                @rui.menubar_radio_group(menu, value="workspace", radio => {
  #|                  @html.fragment([
  #|                    @rui.menubar_radio_item(radio, value="editor", [
  #|                      showcase_file_icon(),
  #|                      @html.span("Editor"),
  #|                    ]),
  #|                    @rui.menubar_radio_item(radio, value="canvas", [
  #|                      showcase_layout_icon(),
  #|                      @html.span("Canvas"),
  #|                    ]),
  #|                    @rui.menubar_radio_item(radio, value="focus", [
  #|                      showcase_activity_icon(),
  #|                      @html.span("Focus"),
  #|                    ]),
  #|                  ])
  #|                }),
  #|              ]),
  #|            ]),
  #|          ]),
  #|        ])
  #|      }),
  #|    ])
  #|  },
  #|)

///|
const IgPopoverSharedCode : String =
  #|fn popover_variant(
  #|  id : String,
  #|  side : @rui.PopupSide,
  #|  align : @rui.PopupAlign,
  #|  trigger_label : String,
  #|) -> @rabbita.Val[@html.Html] {
  #|  let title_id = id + "-title"
  #|  let description_id = id + "-description"
  #|  @rui.popover(
  #|    id~,
  #|    side~,
  #|    align~,
  #|    title_id~,
  #|    description_id~,
  #|    trigger_variant=@rui.Outline,
  #|    trigger_label,
  #|    @html.div(
  #|      style=["display:flex;flex-direction:column;gap:0.75rem"],
  #|      [
  #|        @rui.popover_header([
  #|          @rui.popover_title(id=title_id, trigger_label),
  #|          @rui.popover_description(
  #|            id=description_id,
  #|            "Anchored content stays labelled at this placement.",
  #|          ),
  #|        ]),
  #|        @rui.input(
  #|          value="320 px",
  #|          attrs=@html.Attrs::build().aria_label("Preferred width"),
  #|        ),
  #|        @rui.popover_close_button(target_id=id, size=@rui.Sm, "Apply"),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|

///|
const IgPopoverBottomStartCallCode : String =
  #|popover_variant(
  #|  "showcase-popover-bottom",
  #|  @rui.Bottom,
  #|  @rui.Start,
  #|  "Bottom-start popover",
  #|)

///|
const IgPopoverRightCenterCallCode : String =
  #|popover_variant(
  #|  "showcase-popover-right",
  #|  @rui.Right,
  #|  @rui.Center,
  #|  "Right-center popover",
  #|)

///|
fn ig_popover_code(call : String) -> String {
  IgPopoverSharedCode + "\n\n" + call
}

///|
const IgHoverCardSharedCode : String =
  #|fn hover_card_variant(
  #|  id : String,
  #|  side : @rui.PopupSide,
  #|  align : @rui.PopupAlign,
  #|  trigger_label : String,
  #|) -> @rabbita.Val[@html.Html] {
  #|  @rui.hover_card(
  #|    id~,
  #|    href="#rabbita-profile",
  #|    open_delay=120,
  #|    close_delay=80,
  #|    side~,
  #|    align~,
  #|    trigger_variant=@rui.Link,
  #|    trigger_label,
  #|    @html.div(style=["display:flex;flex-direction:column;gap:0.5rem"], [
  #|      @html.strong("Rabbita UI"),
  #|      @html.p(
  #|        style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35;margin:0"],
  #|        "Native MoonBit components with incremental state.",
  #|      ),
  #|      @html.div(
  #|        style=["display:flex;flex-wrap:wrap;align-items:center;gap:0.75rem"],
  #|        [
  #|          @rui.badge(variant=@rui.Secondary, "Vega"),
  #|          @rui.badge(variant=@rui.Outline, "Inline"),
  #|        ],
  #|      ),
  #|    ]),
  #|  )
  #|}
  #|

///|
const IgHoverCardTopCenterCallCode : String =
  #|hover_card_variant(
  #|  "showcase-hover-card-top",
  #|  @rui.Top,
  #|  @rui.Center,
  #|  "Top-center preview",
  #|)

///|
const IgHoverCardLeftEndCallCode : String =
  #|hover_card_variant(
  #|  "showcase-hover-card-left",
  #|  @rui.Left,
  #|  @rui.End,
  #|  "Left-end preview",
  #|)

///|
fn ig_hover_card_code(call : String) -> String {
  IgHoverCardSharedCode + "\n\n" + call
}

///|
const IgTooltipSharedCode : String =
  #|fn circle_help_icon() -> @html.Html {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=["display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none"],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d="M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0ZM9.1 9a3 3 0 1 1 5.8 1c0 2-2.9 2-2.9 4M12 17h.01",
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|
  #|fn tooltip_variant(
  #|  id : String,
  #|  side : @rui.PopupSide,
  #|  align : @rui.PopupAlign,
  #|  size : @rui.ButtonSize,
  #|  label : String,
  #|) -> @rabbita.Val[@html.Html] {
  #|  @rui.tooltip(
  #|    id~,
  #|    delay=100,
  #|    side~,
  #|    align~,
  #|    show_arrow=true,
  #|    trigger_variant=@rui.Outline,
  #|    trigger_size=size,
  #|    trigger_attrs=@html.Attrs::build().aria_label(label),
  #|    circle_help_icon(),
  #|    label,
  #|  )
  #|}
  #|

///|
const IgTooltipTopStartCallCode : String =
  #|tooltip_variant(
  #|  "showcase-tooltip-top",
  #|  @rui.Top,
  #|  @rui.Start,
  #|  @rui.IconSm,
  #|  "Top-start tooltip",
  #|)

///|
const IgTooltipRightCenterCallCode : String =
  #|tooltip_variant(
  #|  "showcase-tooltip-right",
  #|  @rui.Right,
  #|  @rui.Center,
  #|  @rui.Icon,
  #|  "Right-center tooltip",
  #|)

///|
const IgTooltipBottomEndCallCode : String =
  #|tooltip_variant(
  #|  "showcase-tooltip-bottom",
  #|  @rui.Bottom,
  #|  @rui.End,
  #|  @rui.IconLg,
  #|  "Bottom-end tooltip",
  #|)

///|
const IgTooltipLeftCenterCallCode : String =
  #|tooltip_variant(
  #|  "showcase-tooltip-left",
  #|  @rui.Left,
  #|  @rui.Center,
  #|  @rui.Icon,
  #|  "Left-center tooltip",
  #|)

///|
fn ig_tooltip_code(call : String) -> String {
  IgTooltipSharedCode + "\n\n" + call
}

///|
const IgSheetSharedCode : String =
  #|fn sheet_variant(
  #|  id : String,
  #|  side : @rui.SheetSide,
  #|  trigger_label : String,
  #|) -> @html.Html {
  #|  @html.fragment([
  #|    @rui.button(variant=@rui.Outline, on_click=@dialog.show(id), trigger_label),
  #|    @rui.sheet(
  #|      id~,
  #|      side~,
  #|      attrs=@html.Attrs::build()
  #|        .aria_labelledby(id + "-title")
  #|        .aria_describedby(id + "-description"),
  #|      [
  #|        @rui.sheet_header([
  #|          @rui.sheet_title(id=id + "-title", trigger_label),
  #|          @rui.sheet_description(
  #|            id=id + "-description",
  #|            "Placement changes while focus and dismissal behavior stay consistent.",
  #|          ),
  #|        ]),
  #|        @html.form(method_="dialog", [
  #|          @html.div(style=["display:flex;flex-direction:column;gap:1rem"], [
  #|            @rui.label(for_=id + "-email", "Notification email"),
  #|            @rui.input(id=id + "-email", value="team@example.com"),
  #|          ]),
  #|          @rui.sheet_footer(@rui.button(type_="submit", "Save settings")),
  #|        ]),
  #|      ],
  #|    ),
  #|  ])
  #|}

///|
const IgSheetTopCallCode : String =
  #|sheet_variant(
  #|  "showcase-sheet-top",
  #|  @rui.SheetTop,
  #|  "Open top sheet",
  #|)

///|
const IgSheetRightCallCode : String =
  #|sheet_variant(
  #|  "showcase-sheet-right",
  #|  @rui.SheetRight,
  #|  "Open right sheet",
  #|)

///|
const IgSheetBottomCallCode : String =
  #|sheet_variant(
  #|  "showcase-sheet-bottom",
  #|  @rui.SheetBottom,
  #|  "Open bottom sheet",
  #|)

///|
const IgSheetLeftCallCode : String =
  #|sheet_variant(
  #|  "showcase-sheet-left",
  #|  @rui.SheetLeft,
  #|  "Open left sheet",
  #|)

///|
fn ig_sheet_code(call : String) -> String {
  IgSheetSharedCode + "\n\n" + call
}

///|
const IgSonnerDefaultCode : String =
  #|@rui.sonner(max_toasts=3, position="bottom-right", scope => {
  #|  @rui.button(
  #|    size=@rui.Sm,
  #|    on_click=scope.show(
  #|      title="Saved",
  #|      description="The draft remains in this workspace.",
  #|      variant=@rui.ToastDefault,
  #|    ),
  #|    "Default toast",
  #|  )
  #|})

///|
const IgSonnerSuccessCode : String =
  #|@rui.sonner(max_toasts=3, position="bottom-right", scope => {
  #|  @rui.button(
  #|    size=@rui.Sm,
  #|    variant=@rui.Secondary,
  #|    on_click=scope.show(
  #|      title="Published",
  #|      description="The latest UI preview is live.",
  #|      variant=@rui.ToastSuccess,
  #|    ),
  #|    "Success toast",
  #|  )
  #|})

///|
const IgSonnerDestructiveCode : String =
  #|@rui.sonner(max_toasts=3, position="bottom-right", scope => {
  #|  @rui.button(
  #|    size=@rui.Sm,
  #|    variant=@rui.Destructive,
  #|    on_click=scope.show(
  #|      title="Could not sync",
  #|      description="Check the connection and try again.",
  #|      variant=@rui.ToastDestructive,
  #|    ),
  #|    "Error toast",
  #|  )
  #|})

///|
const IgSonnerQueueCode : String =
  #|@rui.sonner(max_toasts=3, position="bottom-right", scope => {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-wrap:wrap;align-items:center;gap:0.5rem"],
  #|    [
  #|      @rui.button(
  #|        size=@rui.Sm,
  #|        on_click=scope.show(
  #|          title="Queued",
  #|          description="This notification joins the bounded queue.",
  #|          variant=@rui.ToastDefault,
  #|        ),
  #|        "Add toast",
  #|      ),
  #|      @rui.button(
  #|        size=@rui.Sm,
  #|        variant=@rui.Ghost,
  #|        on_click=scope.dismiss_all(),
  #|        "Dismiss queue",
  #|      ),
  #|    ],
  #|  )
  #|})

///|
const IgToastDefaultCode : String =
  #|@rui.toast(variant=@rui.ToastDefault, [
  #|  @rui.toast_title("Draft saved"),
  #|  @rui.toast_description("Your changes remain local."),
  #|  @rui.toast_action("View"),
  #|])

///|
const IgToastSuccessCode : String =
  #|@rui.toast(variant=@rui.ToastSuccess, [
  #|  @rui.toast_title("Published"),
  #|  @rui.toast_description("The latest preview is live."),
  #|])

///|
const IgToastDestructiveCode : String =
  #|@rui.toast(variant=@rui.ToastDestructive, [
  #|  @rui.toast_title("Could not sync"),
  #|  @rui.toast_description("Check the connection and try again."),
  #|])

///|
const IgMessageScrollerCode : String =
  #|fn stroke_icon(path : String) -> @html.Html {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=["display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none"],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d=path,
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|
  #|fn arrow_up_icon() -> @html.Html {
  #|  stroke_icon("m18 15-6-6-6 6")
  #|}
  #|
  #|fn arrow_down_icon() -> @html.Html {
  #|  stroke_icon("m6 9 6 6 6-6")
  #|}
  #|
  #|@rui.message_scroller(
  #|  id="showcase-message-scroller",
  #|  default_at_end=true,
  #|  scope => {
  #|    @html.div(style=["position:relative"], [
  #|      @rui.message_scroller_viewport(
  #|        scope~,
  #|        style=["height:13rem"],
  #|        @rui.message_scroller_content(
  #|          style=["display:flex;flex-direction:column;gap:0.625rem;padding:0.75rem"],
  #|          [
  #|            @rui.message_scroller_item(
  #|              @rui.message([
  #|                @rui.message_avatar(@rui.avatar(@rui.avatar_fallback("RA"))),
  #|                @rui.message_content([
  #|                  @rui.message_header("Rabbita · 09:41"),
  #|                  @rui.bubble_group(
  #|                    @rui.bubble(
  #|                      variant=@rui.BubbleSecondary,
  #|                      @rui.bubble_content(
  #|                        "The component catalogue is ready for review.",
  #|                      ),
  #|                    ),
  #|                  ),
  #|                ]),
  #|              ]),
  #|            ),
  #|            @rui.message_scroller_item(
  #|              @rui.message(align=@rui.AlignEnd, [
  #|                @rui.message_avatar(@rui.avatar(@rui.avatar_fallback("YO"))),
  #|                @rui.message_content([
  #|                  @rui.message_header("You · 09:42"),
  #|                  @rui.bubble_group(
  #|                    @rui.bubble(
  #|                      align=@rui.AlignEnd,
  #|                      @rui.bubble_content(
  #|                        "Great — keep state local and the API black-box.",
  #|                      ),
  #|                    ),
  #|                  ),
  #|                  @rui.message_footer("Delivered"),
  #|                ]),
  #|              ]),
  #|            ),
  #|            @rui.message_scroller_item(
  #|              @rui.message([
  #|                @rui.message_avatar(@rui.avatar(@rui.avatar_fallback("RA"))),
  #|                @rui.message_content(
  #|                  @rui.bubble_group(
  #|                    @rui.bubble(
  #|                      variant=@rui.BubbleMuted,
  #|                      @rui.bubble_content(
  #|                        "This scroller tracks both edges and exposes jump controls.",
  #|                      ),
  #|                    ),
  #|                  ),
  #|                ),
  #|              ]),
  #|            ),
  #|            @rui.message_scroller_item(
  #|              scroll_anchor=true,
  #|              @rui.message(align=@rui.AlignEnd, [
  #|                @rui.message_avatar(@rui.avatar(@rui.avatar_fallback("YO"))),
  #|                @rui.message_content(
  #|                  @rui.bubble_group(
  #|                    @rui.bubble(
  #|                      align=@rui.AlignEnd,
  #|                      @rui.bubble_content("Ship the showcase."),
  #|                    ),
  #|                  ),
  #|                ),
  #|              ]),
  #|            ),
  #|          ],
  #|        ),
  #|      ),
  #|      @html.div(
  #|        style=["position:absolute;right:0.625rem;bottom:0.625rem;display:flex;gap:0.375rem"],
  #|        [
  #|          @rui.message_scroller_button(
  #|            scope~,
  #|            direction=@rui.ScrollStart,
  #|            label="Jump to first message",
  #|            size=@rui.IconSm,
  #|            arrow_up_icon(),
  #|          ),
  #|          @rui.message_scroller_button(
  #|            scope~,
  #|            direction=@rui.ScrollEnd,
  #|            label="Jump to latest message",
  #|            size=@rui.IconSm,
  #|            arrow_down_icon(),
  #|          ),
  #|        ],
  #|      ),
  #|    ])
  #|  },
  #|)

///|
const IgResizableHorizontalCode : String =
  #|@rui.resizable_group(
  #|  id="showcase-resizable",
  #|  default_sizes=[26, 44, 30],
  #|  min_sizes=[16, 24, 18],
  #|  max_sizes=[52, 68, 54],
  #|  orientation=@rui.Horizontal,
  #|  style=["height:14rem;overflow:hidden;border:1px solid var(--rui-border);border-radius:var(--rui-radius)"],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.resizable_group_panel(
  #|        scope~,
  #|        index=0,
  #|        style=["display:flex;align-items:center;justify-content:center;padding:1.5rem;color:var(--rui-foreground);font-size:0.875rem;line-height:1.25rem;font-weight:500;text-align:center"],
  #|        "Files",
  #|      ),
  #|      @rui.resizable_group_handle(
  #|        scope~,
  #|        between=0,
  #|        with_handle=true,
  #|        aria_label="Resize files and editor",
  #|      ),
  #|      @rui.resizable_group_panel(
  #|        scope~,
  #|        index=1,
  #|        style=["display:flex;align-items:center;justify-content:center;padding:1.5rem;color:var(--rui-foreground);font-size:0.875rem;line-height:1.25rem;font-weight:500;text-align:center"],
  #|        "Editor",
  #|      ),
  #|      @rui.resizable_group_handle(
  #|        scope~,
  #|        between=1,
  #|        with_handle=true,
  #|        aria_label="Resize editor and preview",
  #|      ),
  #|      @rui.resizable_group_panel(
  #|        scope~,
  #|        index=2,
  #|        style=["display:flex;align-items:center;justify-content:center;padding:1.5rem;color:var(--rui-foreground);font-size:0.875rem;line-height:1.25rem;font-weight:500;text-align:center"],
  #|        "Preview",
  #|      ),
  #|    ])
  #|  },
  #|)

///|
const IgResizableVerticalCode : String =
  #|@rui.resizable_panel_group(
  #|  id="showcase-resizable-panel-group",
  #|  default_size=42,
  #|  min=24,
  #|  max=72,
  #|  orientation=@rui.Vertical,
  #|  aria_label="Resize preview and console",
  #|  style=[
  #|    "height:14rem;overflow:hidden;border:1px solid var(--rui-border);border-radius:var(--rui-radius)",
  #|    "width:min(100%,32rem);height:14rem;margin-inline:auto",
  #|  ],
  #|  scope => {
  #|    @html.fragment([
  #|      @rui.resizable_panel(
  #|        scope~,
  #|        side=@rui.FirstPanel,
  #|        style=["display:flex;align-items:center;justify-content:center;padding:1.5rem;color:var(--rui-foreground);font-size:0.875rem;line-height:1.25rem;font-weight:500;text-align:center"],
  #|        "Preview",
  #|      ),
  #|      @rui.resizable_handle(
  #|        scope~,
  #|        with_handle=true,
  #|        aria_label="Resize preview and console",
  #|      ),
  #|      @rui.resizable_panel(
  #|        scope~,
  #|        side=@rui.SecondPanel,
  #|        style=["display:flex;align-items:center;justify-content:center;padding:1.5rem;color:var(--rui-foreground);font-size:0.875rem;line-height:1.25rem;font-weight:500;text-align:center"],
  #|        "Console",
  #|      ),
  #|    ])
  #|  },
  #|)

///|
const IgScrollAreaVerticalCode : String =
  #|@rui.scroll_area_with_scrollbar(
  #|  id="showcase-scroll-area",
  #|  orientation=@rui.Vertical,
  #|  style=["height:13rem;border:1px solid var(--rui-border);border-radius:var(--rui-radius)"],
  #|  @html.div(
  #|    style=["display:flex;flex-direction:column;gap:0.625rem;padding:0.875rem 1.25rem 0.875rem 0.875rem"],
  #|    [
  #|      @html.strong("Release checklist"),
  #|      @rui.separator(),
  #|      @html.span("Check semantic roles"),
  #|      @html.span("Check keyboard order"),
  #|      @html.span("Check light and dark themes"),
  #|      @html.span("Check long labels"),
  #|      @html.span("Check narrow containers"),
  #|      @html.span("Check reduced motion"),
  #|      @html.span("Check empty and error states"),
  #|      @html.span("Check server rendering"),
  #|      @html.span("Check native fallback"),
  #|      @html.span("Ready to publish"),
  #|    ],
  #|  ),
  #|)

///|
const IgScrollAreaHorizontalCode : String =
  #|@rui.scroll_area_with_scrollbar(
  #|  id="showcase-scroll-area-horizontal",
  #|  orientation=@rui.Horizontal,
  #|  style=["width:100%;max-width:100%;height:5.5rem;border:1px solid var(--rui-border);border-radius:var(--rui-radius)"],
  #|  @html.div(
  #|    style=["display:flex;width:max-content;min-width:44rem;gap:0.625rem;padding:0.875rem 1.25rem 1.25rem 0.875rem"],
  #|    [
  #|      @rui.badge(variant=@rui.Secondary, "Keyboard"),
  #|      @rui.badge(variant=@rui.Secondary, "Pointer"),
  #|      @rui.badge(variant=@rui.Secondary, "Touch"),
  #|      @rui.badge(variant=@rui.Secondary, "RTL"),
  #|      @rui.badge(variant=@rui.Secondary, "Measured thumb"),
  #|      @rui.badge(variant=@rui.Secondary, "Native fallback"),
  #|    ],
  #|  ),
  #|)
