///|
using @html {a, button, div, iframe, li, nothing, option, pre, select, span, ul}

///|
using @rabbita {type Cmd, type Emit, type Html, type Val}

///|
struct Diagnostic {
  level : String
  path : String
  line : Int
  column : Int
  end_line : Int
  end_column : Int
  message : String
} derive(Eq)

///|
enum Msg {
  AssetsReady(Result[@js.Value, Error])
  ExamplesReady(Result[ExampleManifest, Error])
  SelectTab(SourceTab)
  FocusDiagnostic(Diagnostic)
  TogglePackageMenu
  ClosePackageMenu
  ExampleChanged(String)
  ExampleFileLoaded(Int, ExampleAsset, Result[String, Error])
  MbtChanged(String)
  HtmlChanged(String)
  CssChanged(String)
  MoonPkgChanged(String)
  ShareRequested
  ShareReady(Result[@js.Value, Error])
  RunRequested
  Run(Int)
  CompileReady(Int, Result[@js.Value, Error])
}

///|
enum SourceTab {
  Mbt
  Html
  Css
  MoonPkg
} derive(Eq)

///|
enum ExampleAsset {
  RepoSource(Int)
  RepoCss
  RepoMoonPkg
} derive(Eq)

///|
struct Model {
  active_tab : SourceTab
  mbt : String
  html : String
  css : String
  moon_pkg : String
  compiled_js : String?
  assets_ready : Bool
  asset_status : String
  asset_packages : Array[String]
  examples_ready : Bool
  examples : Array[Example]
  package_menu_open : Bool
  status : String
  log : String
  diagnostics : Array[Diagnostic]
  compiling : Bool
  run_id : Int
  example_id : String
  example_load : ExampleLoad?
} derive(Eq)

///|
struct Example {
  id : String
  label : String
  sources : Array[String]
  css : String
  moon_pkg : String
} derive(Eq, FromJson)

///|
struct ExampleManifest {
  examples : Array[Example]
} derive(FromJson)

///|
struct LoadedExample {
  mbt : String
  html : String
  css : String
  moon_pkg : String
} derive(Eq)

///|
struct ExampleLoad {
  token : Int
  example_id : String
  sources : Array[String?]
  css : String?
  moon_pkg : String?
} derive(Eq)

///|
fn initial_model() -> Model {
  let example_id = read_source("example", "counter")
  {
    active_tab: Mbt,
    mbt: read_source("mbt", ""),
    html: initial_html(),
    css: read_source("css", ""),
    moon_pkg: read_source("moon_pkg", ""),
    compiled_js: None,
    assets_ready: false,
    asset_status: "Loading compiler assets",
    asset_packages: [],
    examples_ready: false,
    examples: [],
    package_menu_open: false,
    status: "Loading examples",
    log: "",
    diagnostics: [],
    compiling: false,
    run_id: 0,
    example_id,
    example_load: None,
  }
}

///|
fn html_document(title : String) -> String {
  "<!doctype html>\n<html lang=\"en\">\n  <head>\n    <meta charset=\"UTF-8\" />\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />\n    <title>" +
  title +
  "</title>\n  </head>\n  <body>\n    <div id=\"app\"></div>\n  </body>\n</html>"
}

///|
fn initial_html() -> String {
  let html = read_source("html", "")
  if html.trim().to_owned() == "<div id=\"app\"></div>" {
    html_document("Playground")
  } else {
    html
  }
}

///|
fn split_lines(source : String) -> Array[String] {
  let out = Array::new()
  for line in source.split("\n") {
    let value = line.trim().to_owned()
    if value != "" {
      out.push(value)
    }
  }
  out
}

///|
fn diagnostics_from_result(value : @js.Value) -> Array[Diagnostic] {
  let count = js_diagnostic_count(value, "diagnostics")
  Array::makei(count, i => {
    level: js_diagnostic_string(value, "diagnostics", i, "level"),
    path: js_diagnostic_string(value, "diagnostics", i, "path"),
    line: js_diagnostic_int(value, "diagnostics", i, "line"),
    column: js_diagnostic_int(value, "diagnostics", i, "column"),
    end_line: js_diagnostic_int(value, "diagnostics", i, "endLine"),
    end_column: js_diagnostic_int(value, "diagnostics", i, "endColumn"),
    message: js_diagnostic_string(value, "diagnostics", i, "message"),
  })
}

///|
fn persist_cmd(model : Model) -> Cmd {
  @rabbita.attempt(_ => @rabbita.none, async fn() {
    save_source_promise(
      model.example_id,
      model.mbt,
      model.html,
      model.css,
      model.moon_pkg,
    ).wait()
  })
}

///|
fn render_cmd(html : String, css : String, js : String) -> Cmd {
  @rabbita.effect(fn() noraise { render_preview(html, css, js) })
}

///|
fn load_assets_cmd(emit : Emit[Msg]) -> Cmd {
  @rabbita.attempt(result => emit(AssetsReady(result)), async fn() {
    load_assets_promise().wait()
  })
}

///|
fn example_asset_url(path : String) -> String {
  resolve_asset_url("repo-examples/" + path + "?v=examples-3")
}

///|
fn has_editor_source(model : Model) -> Bool {
  model.mbt != "" || model.html != "" || model.css != "" || model.moon_pkg != ""
}

///|
fn ready_to_compile(model : Model) -> Bool {
  model.assets_ready &&
  model.examples_ready &&
  model.example_load is None &&
  model.mbt != "" &&
  model.moon_pkg != ""
}

///|
fn run_when_ready(emit : Emit[Msg], model : Model) -> (Cmd, Model) {
  if ready_to_compile(model) {
    let token = model.run_id + 1
    let next = {
      ..model,
      status: "Pending",
      log: "",
      diagnostics: [],
      run_id: token,
    }
    (emit(Run(token)), next)
  } else {
    (@rabbita.none, model)
  }
}

///|
fn join_blocks(items : Array[String]) -> String {
  let out = StringBuilder()
  for index, item in items {
    if index > 0 {
      out.write_string("\n\n")
    }
    out.write_string(item)
  }
  out.to_string()
}

///|
fn new_example_load(token : Int, example : Example) -> ExampleLoad {
  {
    token,
    example_id: example.id,
    sources: Array::makei(example.sources.length(), _ => None),
    css: None,
    moon_pkg: None,
  }
}

///|
fn update_example_load(
  load : ExampleLoad,
  asset : ExampleAsset,
  body : String,
) -> ExampleLoad {
  match asset {
    RepoSource(index) => {
      let sources = load.sources.copy()
      sources.set(index, Some(body))
      { ..load, sources, }
    }
    RepoCss => { ..load, css: Some(body), }
    RepoMoonPkg => { ..load, moon_pkg: Some(body), }
  }
}

///|
fn loaded_example_from_load(
  examples : Array[Example],
  load : ExampleLoad,
) -> LoadedExample? {
  guard load.css is Some(css) else { None }
  guard load.moon_pkg is Some(moon_pkg) else { None }
  guard example_by_id(examples, load.example_id) is Some(example) else { None }
  let parts : Array[String] = []
  for item in load.sources {
    guard item is Some(source) else { return None }
    parts.push(source)
  }
  Some({
    mbt: join_blocks(parts),
    html: html_document(example.label),
    css,
    moon_pkg,
  })
}

///|
fn compile_cmd(
  emit : Emit[Msg],
  token : Int,
  source : String,
  moon_pkg : String,
) -> Cmd {
  @rabbita.attempt(result => emit(CompileReady(token, result)), async fn() {
    compile_mbt_promise(source, moon_pkg).wait()
  })
}

///|
fn preview_refresh_cmd(model : Model) -> Cmd {
  match model.compiled_js {
    Some(js) => render_cmd(model.html, model.css, js)
    None => @rabbita.none
  }
}

///|
fn editor_sync_cmd(emit : Emit[Msg], model : Model) -> Cmd {
  let active = model.active_tab
  sync_code_editor(
    "code-editor-host",
    tab_id(active),
    tab_value(model),
    tab_lang(active),
    tab_input(emit, active),
  )
}

///|
fn editor_focus_diagnostic_cmd(
  emit : Emit[Msg],
  model : Model,
  diagnostic : Diagnostic,
) -> Cmd {
  focus_code_editor_range(
    "code-editor-host",
    tab_id(Mbt),
    model.mbt,
    tab_lang(Mbt),
    tab_input(emit, Mbt),
    diagnostic.line,
    diagnostic.column,
    diagnostic.end_line,
    diagnostic.end_column,
  )
}

///|
fn update(emit : Emit[Msg], msg : Msg, model : Model) -> (Cmd, Model) {
  match msg {
    SelectTab(tab) => {
      let next = { ..model, active_tab: tab, }
      (editor_sync_cmd(emit, next), next)
    }
    FocusDiagnostic(diagnostic) => {
      let next = { ..model, active_tab: Mbt, }
      (editor_focus_diagnostic_cmd(emit, next, diagnostic), next)
    }
    TogglePackageMenu =>
      (@rabbita.none, { ..model, package_menu_open: !model.package_menu_open, })
    ClosePackageMenu => (@rabbita.none, { ..model, package_menu_open: false, })
    ExampleChanged(id) =>
      match example_by_id(model.examples, id) {
        Some(example) => {
          let token = model.run_id + 1
          let next = {
            ..model,
            example_id: example.id,
            compiled_js: None,
            status: "Loading example",
            log: "",
            diagnostics: [],
            compiling: false,
            run_id: token,
            example_load: Some(new_example_load(token, example)),
          }
          (
            @rabbita.batch(
              [@rabbita.effect(fn() noraise { set_example_url(example.id) })] +
              example.sources.mapi((index, path) => {
                @http.get(example_asset_url(path)).expect_text(result => {
                  emit(ExampleFileLoaded(token, RepoSource(index), result))
                })
              }) +
              [
                @http.get(example_asset_url(example.css)).expect_text(result => {
                  emit(ExampleFileLoaded(token, RepoCss, result))
                }),
                @http.get(example_asset_url(example.moon_pkg)).expect_text(result => {
                  emit(ExampleFileLoaded(token, RepoMoonPkg, result))
                }),
              ],
            ),
            next,
          )
        }
        None =>
          (
            @rabbita.none,
            {
              ..model,
              status: "Example missing",
              log: "No playground example named \{id}",
              diagnostics: [],
              compiling: false,
              example_load: None,
            },
          )
      }
    ExampleFileLoaded(token, asset, result) =>
      if token != model.run_id {
        (@rabbita.none, model)
      } else {
        match result {
          Ok(body) =>
            match model.example_load {
              Some(load) if load.token == token => {
                let load = update_example_load(load, asset, body)
                match loaded_example_from_load(model.examples, load) {
                  Some(loaded) => {
                    let next = {
                      ..model,
                      mbt: loaded.mbt,
                      html: loaded.html,
                      css: loaded.css,
                      moon_pkg: loaded.moon_pkg,
                      compiled_js: None,
                      status: "Pending",
                      log: "",
                      diagnostics: [],
                      compiling: false,
                      example_load: None,
                    }
                    (
                      @rabbita.batch([
                        persist_cmd(next),
                        editor_sync_cmd(emit, next),
                        if next.assets_ready {
                          emit(Run(token))
                        } else {
                          @rabbita.none
                        },
                      ]),
                      next,
                    )
                  }
                  None =>
                    (@rabbita.none, { ..model, example_load: Some(load), })
                }
              }
              _ => (@rabbita.none, model)
            }
          Err(error) =>
            (
              @rabbita.none,
              {
                ..model,
                status: "Example missing",
                log: "\{error}",
                diagnostics: [],
                compiling: false,
                example_load: None,
              },
            )
        }
      }
    ExamplesReady(result) =>
      match result {
        Ok(manifest) =>
          match example_by_id(manifest.examples, model.example_id) {
            Some(example) => {
              let should_load_example = !has_shared_source() &&
                (has_example_param() || !has_editor_source(model))
              if should_load_example {
                let token = model.run_id + 1
                let next = {
                  ..model,
                  examples_ready: true,
                  examples: manifest.examples,
                  example_id: example.id,
                  compiled_js: None,
                  status: "Loading example",
                  log: "",
                  diagnostics: [],
                  compiling: false,
                  run_id: token,
                  example_load: Some(new_example_load(token, example)),
                }
                (
                  @rabbita.batch(
                    example.sources.mapi((index, path) => {
                      @http.get(example_asset_url(path)).expect_text(result => {
                        emit(
                          ExampleFileLoaded(token, RepoSource(index), result),
                        )
                      })
                    }) +
                    [
                      @http.get(example_asset_url(example.css)).expect_text(result => {
                        emit(ExampleFileLoaded(token, RepoCss, result))
                      }),
                      @http.get(example_asset_url(example.moon_pkg)).expect_text(result => {
                          emit(ExampleFileLoaded(token, RepoMoonPkg, result))
                        },
                      ),
                    ],
                  ),
                  next,
                )
              } else {
                let next = {
                  ..model,
                  examples_ready: true,
                  examples: manifest.examples,
                  example_id: example.id,
                }
                run_when_ready(emit, next)
              }
            }
            None =>
              (
                @rabbita.none,
                {
                  ..model,
                  examples_ready: true,
                  examples: manifest.examples,
                  status: "Example missing",
                  log: "No playground examples configured",
                  diagnostics: [],
                  compiling: false,
                  example_load: None,
                },
              )
          }
        Err(error) =>
          (
            @rabbita.none,
            {
              ..model,
              status: "Examples missing",
              log: "\{error}",
              diagnostics: [],
              compiling: false,
              example_load: None,
            },
          )
      }
    AssetsReady(result) =>
      match result {
        Ok(value) =>
          if js_result_ok(value) {
            let count = js_result_int(value, "count")
            let packages = split_lines(js_result_string(value, "packages"))
            let next = {
              ..model,
              assets_ready: true,
              asset_status: "\{count} packages available",
              asset_packages: packages,
            }
            run_when_ready(emit, next)
          } else {
            let message = js_result_string(value, "error")
            (
              @rabbita.none,
              {
                ..model,
                assets_ready: false,
                asset_status: "Compiler assets missing",
                asset_packages: [],
                status: "Assets missing",
                log: message,
                diagnostics: [],
              },
            )
          }
        Err(error) =>
          (
            @rabbita.none,
            {
              ..model,
              assets_ready: false,
              asset_status: "Compiler assets missing",
              asset_packages: [],
              status: "Assets missing",
              log: "\{error}",
              diagnostics: [],
            },
          )
      }
    CompileReady(token, result) =>
      if token != model.run_id {
        (@rabbita.none, model)
      } else {
        match result {
          Ok(value) =>
            if js_result_ok(value) {
              let js = js_result_string(value, "js")
              let elapsed = js_result_int(value, "elapsed")
              let next = {
                ..model,
                compiled_js: Some(js),
                status: "Rendered in \{elapsed}ms",
                log: "",
                diagnostics: [],
                compiling: false,
              }
              (render_cmd(next.html, next.css, js), next)
            } else {
              let message = js_result_string(value, "error")
              let diagnostics = diagnostics_from_result(value)
              (
                @rabbita.none,
                {
                  ..model,
                  status: "Compile failed",
                  log: message,
                  diagnostics,
                  compiling: false,
                },
              )
            }
          Err(error) =>
            (
              @rabbita.none,
              {
                ..model,
                status: "Compile failed",
                log: "\{error}",
                diagnostics: [],
                compiling: false,
              },
            )
        }
      }
    MbtChanged(source) => {
      let token = model.run_id + 1
      let next = {
        ..model,
        mbt: source,
        status: "Pending",
        log: "",
        diagnostics: [],
        compiling: false,
        run_id: token,
        example_load: None,
      }
      (
        @rabbita.batch([
          persist_cmd(next),
          @rabbita.delay(emit(Run(token)), 650),
        ]),
        next,
      )
    }
    HtmlChanged(source) => {
      let next = { ..model, html: source, example_load: None, }
      (@rabbita.batch([persist_cmd(next), preview_refresh_cmd(next)]), next)
    }
    CssChanged(source) => {
      let next = { ..model, css: source, example_load: None, }
      (@rabbita.batch([persist_cmd(next), preview_refresh_cmd(next)]), next)
    }
    MoonPkgChanged(source) => {
      let token = model.run_id + 1
      let next = {
        ..model,
        moon_pkg: source,
        status: "Pending",
        log: "",
        diagnostics: [],
        compiling: false,
        run_id: token,
        example_load: None,
      }
      (
        @rabbita.batch([
          persist_cmd(next),
          @rabbita.delay(emit(Run(token)), 650),
        ]),
        next,
      )
    }
    ShareRequested =>
      (
        @rabbita.attempt(result => emit(ShareReady(result)), async fn() {
          share_source_promise(
            model.example_id,
            model.mbt,
            model.html,
            model.css,
            model.moon_pkg,
          ).wait()
        }),
        model,
      )
    ShareReady(result) =>
      match result {
        Ok(value) =>
          if js_result_ok(value) {
            (
              @rabbita.none,
              { ..model, status: js_result_string(value, "status"), },
            )
          } else {
            (
              @rabbita.none,
              {
                ..model,
                status: "Share failed",
                log: js_result_string(value, "error"),
              },
            )
          }
        Err(error) =>
          (@rabbita.none, { ..model, status: "Share failed", log: "\{error}", })
      }
    RunRequested => {
      let token = model.run_id + 1
      let next = {
        ..model,
        status: "Pending",
        log: "",
        diagnostics: [],
        run_id: token,
        example_load: None,
      }
      (emit(Run(token)), next)
    }
    Run(token) =>
      if token != model.run_id {
        (@rabbita.none, model)
      } else {
        let next = {
          ..model,
          status: "Compiling",
          compiling: true,
          log: "",
          diagnostics: [],
        }
        (compile_cmd(emit, token, model.mbt, model.moon_pkg), next)
      }
  }
}

///|
fn tab_title(tab : SourceTab) -> String {
  match tab {
    Mbt => "main.mbt"
    Html => "index.html"
    Css => "style.css"
    MoonPkg => "moon.pkg"
  }
}

///|
fn tab_id(tab : SourceTab) -> String {
  match tab {
    Mbt => "mbt-editor"
    Html => "html-editor"
    Css => "css-editor"
    MoonPkg => "moon-pkg-editor"
  }
}

///|
fn tab_lang(tab : SourceTab) -> String {
  match tab {
    Mbt => "moonbit"
    Html => "html"
    Css => "css"
    MoonPkg => "moonbit"
  }
}

///|
fn tab_value(model : Model) -> String {
  match model.active_tab {
    Mbt => model.mbt
    Html => model.html
    Css => model.css
    MoonPkg => model.moon_pkg
  }
}

///|
fn example_by_id(examples : Array[Example], id : String) -> Example? {
  let mut selected : Example? = None
  for example in examples {
    if selected is None && example.id == id {
      selected = Some(example)
    }
  }
  match selected {
    Some(_) => selected
    None => if examples.is_empty() { None } else { Some(examples[0]) }
  }
}

///|
fn tab_input(emit : Emit[Msg], tab : SourceTab) -> (String) -> Cmd {
  match tab {
    Mbt => s => emit(MbtChanged(s))
    Html => s => emit(HtmlChanged(s))
    Css => s => emit(CssChanged(s))
    MoonPkg => s => emit(MoonPkgChanged(s))
  }
}

///|
struct BuildStateModel {
  status : String
  compiling : Bool
} derive(Eq)

///|
fn rebuild_button_state(model : BuildStateModel) -> String {
  if model.compiling || model.status == "Compiling" {
    "building"
  } else if model.status == "Pending" {
    "pending"
  } else {
    ""
  }
}

///|
fn rebuild_button_class(model : BuildStateModel) -> String {
  let state = rebuild_button_state(model)
  if state == "" {
    "plain-button primary rebuild-button"
  } else {
    "plain-button primary rebuild-button \{state}"
  }
}

///|
fn rebuild_button_icon(model : BuildStateModel) -> Html {
  if rebuild_button_state(model) == "" {
    let line_attrs = @svg.Attrs::build()
      .stroke_linecap("round")
      .stroke_linejoin("round")
    @svg.svg(
      class="button-icon rebuild-icon",
      width=14,
      height=14,
      view_box="0 0 24 24",
      [
        @svg.path(
          d="M21 12a9 9 0 1 1-2.64-6.36",
          fill="none",
          stroke="currentColor",
          stroke_width=2,
          attrs=line_attrs,
        ),
        @svg.polyline(
          points=[(21, 3), (21, 9), (15, 9)],
          fill="none",
          stroke="currentColor",
          stroke_width=2,
          stroke_linecap="round",
          attrs=@svg.Attrs::build().stroke_linejoin("round"),
        ),
      ],
    )
  } else {
    span(class="button-icon status-spinner", "")
  }
}

///|
fn rebuild_button_text(model : BuildStateModel) -> String {
  match rebuild_button_state(model) {
    "building" => "Building"
    "pending" => "Pending"
    _ => "Rebuild"
  }
}

///|
fn tab_button(emit : Emit[Msg], active : SourceTab, tab : SourceTab) -> Html {
  let selected = active == tab
  let class_name = if selected { "tab-button selected" } else { "tab-button" }
  button(class=class_name, on_click=emit(SelectTab(tab)), tab_title(tab))
}

///|
struct ExampleSelectModel {
  examples_ready : Bool
  examples : Array[Example]
  example_id : String
} derive(Eq)

///|
fn example_select(emit : Emit[Msg], model : ExampleSelectModel) -> Html {
  select(
    id="example-select",
    class="example-select",
    disabled=!model.examples_ready,
    on_change=value => emit(ExampleChanged(value)),
    if model.examples.is_empty() {
      [
        option(
          value="",
          selected=true,
          if model.examples_ready {
            "No examples"
          } else {
            "Loading examples"
          },
        ),
      ]
    } else {
      model.examples.map(example => {
        option(
          value=example.id,
          selected=model.example_id == example.id,
          example.label,
        )
      })
    },
  )
}

///|
fn package_docs_url(pkg : String) -> String {
  "https://mooncakes.io/docs/\{pkg}"
}

///|
struct PackageMenuModel {
  asset_packages : Array[String]
  asset_status : String
  package_menu_open : Bool
} derive(Eq)

///|
fn package_menu(emit : Emit[Msg], model : PackageMenuModel) -> Html {
  if model.asset_packages.is_empty() {
    span(class="asset-status", model.asset_status)
  } else {
    let class_name = if model.package_menu_open {
      "package-menu open"
    } else {
      "package-menu"
    }
    div(class=class_name, [
      button(
        type_="button",
        class="package-trigger",
        attrs=@html.Attrs::build().on_blur(_ => {
          @rabbita.delay(emit(ClosePackageMenu), 120)
        }),
        on_click=emit(TogglePackageMenu),
        [
          span(class="package-label", "Packages"),
          span(class="package-count", "\{model.asset_packages.length()}"),
        ],
      ),
      if model.package_menu_open {
        div(class="package-popover", [
          div(class="package-heading", model.asset_status),
          ul(
            class="package-list",
            model.asset_packages.map(pkg => {
              li(class="package-item", [
                a(
                  class="package-link",
                  href=package_docs_url(pkg),
                  target=Blank,
                  rel="noreferrer",
                  escape=true,
                  pkg,
                ),
              ])
            }),
          ),
        ])
      } else {
        nothing
      },
    ])
  }
}

///|
fn code_panel() -> Html {
  div(class="code-panel", [
    div(id="code-editor-host", class="code-editor-host", nothing),
  ])
}

///|
struct ResultBodyModel {
  status : String
  log : String
  diagnostics : Array[Diagnostic]
} derive(Eq)

///|
fn show_diagnostics(model : ResultBodyModel) -> Bool {
  (
    model.status == "Compile failed" ||
    model.status == "Assets missing" ||
    model.status == "Example missing"
  ) &&
  model.log != ""
}

///|
fn diagnostic_location(diagnostic : Diagnostic) -> String {
  if diagnostic.line > 0 && diagnostic.column > 0 {
    "\{diagnostic.path}:\{diagnostic.line}:\{diagnostic.column}"
  } else {
    diagnostic.path
  }
}

///|
fn diagnostic_row(emit : Emit[Msg], diagnostic : Diagnostic) -> Html {
  button(
    class="diagnostic-item \{diagnostic.level}",
    on_click=emit(FocusDiagnostic(diagnostic)),
    [
      span(class="diagnostic-location", diagnostic_location(diagnostic)),
      span(class="diagnostic-message", diagnostic.message),
    ],
  )
}

///|
fn diagnostics_output(emit : Emit[Msg], model : ResultBodyModel) -> Html {
  div(
    id="diagnostics-output",
    class="diagnostics-output",
    if model.diagnostics.is_empty() {
      [pre(class="diagnostics-plain", model.log)]
    } else {
      model.diagnostics.map(diagnostic => diagnostic_row(emit, diagnostic))
    },
  )
}

///|
fn result_body(emit : Emit[Msg], model : ResultBodyModel) -> Html {
  if show_diagnostics(model) {
    diagnostics_output(emit, model)
  } else {
    iframe(
      id="preview-frame",
      title="Compiled Rabbita result",
      sandbox="allow-scripts allow-forms allow-modals allow-popups",
    )
  }
}

///|
fn result_overlay(model : BuildStateModel) -> Html {
  let state = rebuild_button_state(model)
  let class_name = if state == "" {
    "result-overlay"
  } else {
    "result-overlay visible \{state}"
  }
  div(class=class_name, nothing)
}

///|
fn example_select_view(
  emit : Emit[Msg],
  model : Val[ExampleSelectModel],
) -> Val[Html] {
  model.map(model => example_select(emit, model))
}

///|
fn package_menu_view(
  emit : Emit[Msg],
  model : Val[PackageMenuModel],
) -> Val[Html] {
  model.map(model => package_menu(emit, model))
}

///|
fn build_button_view(
  emit : Emit[Msg],
  model : Val[BuildStateModel],
) -> Val[Html] {
  model.map(model => {
    button(
      id="rebuild-button",
      class=rebuild_button_class(model),
      disabled=model.compiling,
      on_click=emit(RunRequested),
      [rebuild_button_icon(model), span(rebuild_button_text(model))],
    )
  })
}

///|
fn tab_strip_view(emit : Emit[Msg], active_tab : Val[SourceTab]) -> Val[Html] {
  active_tab.map(active_tab => {
    div(class="tab-strip", [
      tab_button(emit, active_tab, Mbt),
      tab_button(emit, active_tab, Html),
      tab_button(emit, active_tab, Css),
      tab_button(emit, active_tab, MoonPkg),
    ])
  })
}

///|
fn result_view(
  emit : Emit[Msg],
  body : Val[ResultBodyModel],
  build : Val[BuildStateModel],
) -> Val[Html] {
  body
  .map(model => result_body(emit, model))
  .map2(build.map(model => result_overlay(model)), (body, overlay) => {
    div(class="result", [body, overlay])
  })
}

///|
fn view(emit : Emit[Msg], model : Val[Model]) -> Val[Html] {
  let example = model.map(model => {
    examples_ready: model.examples_ready,
    examples: model.examples,
    example_id: model.example_id,
  })
  let packages = model.map(model => {
    asset_packages: model.asset_packages,
    asset_status: model.asset_status,
    package_menu_open: model.package_menu_open,
  })
  let build = model.map(model => {
    status: model.status,
    compiling: model.compiling,
  })
  let result_body = model.map(model => {
    status: model.status,
    log: model.log,
    diagnostics: model.diagnostics,
  })
  let top_left = example_select_view(emit, example).map2(
    package_menu_view(emit, packages),
    (example, packages) => div(class="bar-group", [example, packages]),
  )
  let top_right = build_button_view(emit, build).map(rebuild_button => {
    div(class="bar-group", [
      button(
        class="plain-button",
        id="share-button",
        on_click=emit(ShareRequested),
        "Share",
      ),
      rebuild_button,
    ])
  })
  let top_bar = top_left.map2(top_right, (left, right) => {
    div(class="top-bar editor-status", [left, right])
  })
  let workbench = top_bar.map2(
    tab_strip_view(emit, model.map(model => model.active_tab)),
    (top_bar, tab_strip) => {
      div(class="workbench", [top_bar, tab_strip, code_panel()])
    },
  )
  workbench.map2(result_view(emit, result_body, build), (workbench, result) => {
    div(class="shell", [workbench, result])
  })
}

///|
fn initial_cmd(emit : Emit[Msg], model : Model) -> Cmd {
  let cmds = [
    load_assets_cmd(emit),
    @http.get(resolve_asset_url("examples.json?v=examples-3")).expect_json(result => {
      emit(ExamplesReady(result))
    }),
    editor_sync_cmd(emit, model),
  ]
  @rabbita.batch(cmds)
}

///|
#warnings("-alert_unstable")
fn main {
  fn app() {
    let (model, emit) = @rabbita.create_state_with_init(
      init=fn(emit) {
        let model = initial_model()
        (model, initial_cmd(emit, model))
      },
      update=fn(model, msg, emit) {
        let (cmd, model) = update(emit, msg, model)
        (model, cmd)
      },
    )
    view(emit, model)
  }
  @rabbita.new(app).mount("app")
}
