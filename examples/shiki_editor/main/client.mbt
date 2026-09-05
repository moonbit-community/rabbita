///|
using @html {div, h1, option, p, select, textarea, nothing}

///|
using @rabbita {type Emit, type Html, type Val}

///|
let language_items : Array[(String, String)] = [
  ("javascript", "JavaScript"),
  ("typescript", "TypeScript"),
  ("json", "JSON"),
  ("bash", "Bash"),
  ("css", "CSS"),
  ("html", "HTML"),
  ("moonbit", "MoonBit"),
]

///|
let light_theme_items : Array[(String, String)] = [
  ("catppuccin-latte", "Catppuccin Latte"),
  ("everforest-light", "Everforest Light"),
  ("github-light", "GitHub Light"),
  ("github-light-default", "GitHub Light Default"),
  ("github-light-high-contrast", "GitHub Light High Contrast"),
  ("kanagawa-lotus", "Kanagawa Lotus"),
  ("light-plus", "Light Plus"),
  ("material-theme-lighter", "Material Theme Lighter"),
  ("min-light", "Min Light"),
  ("one-light", "One Light"),
  ("rose-pine-dawn", "Rose Pine Dawn"),
  ("slack-ochin", "Slack Ochin"),
  ("snazzy-light", "Snazzy Light"),
  ("solarized-light", "Solarized Light"),
  ("vitesse-light", "Vitesse Light"),
]

///|
let dark_theme_items : Array[(String, String)] = [
  ("andromeeda", "Andromeeda"),
  ("aurora-x", "Aurora X"),
  ("ayu-dark", "Ayu Dark"),
  ("catppuccin-frappe", "Catppuccin Frappe"),
  ("catppuccin-macchiato", "Catppuccin Macchiato"),
  ("catppuccin-mocha", "Catppuccin Mocha"),
  ("dark-plus", "Dark Plus"),
  ("dracula", "Dracula"),
  ("dracula-soft", "Dracula Soft"),
  ("everforest-dark", "Everforest Dark"),
  ("github-dark", "GitHub Dark"),
  ("github-dark-default", "GitHub Dark Default"),
  ("github-dark-dimmed", "GitHub Dark Dimmed"),
  ("github-dark-high-contrast", "GitHub Dark High Contrast"),
  ("houston", "Houston"),
  ("kanagawa-dragon", "Kanagawa Dragon"),
  ("kanagawa-wave", "Kanagawa Wave"),
  ("laserwave", "LaserWave"),
  ("material-theme", "Material Theme"),
  ("material-theme-darker", "Material Theme Darker"),
  ("material-theme-ocean", "Material Theme Ocean"),
  ("material-theme-palenight", "Material Theme Palenight"),
  ("min-dark", "Min Dark"),
  ("monokai", "Monokai"),
  ("night-owl", "Night Owl"),
  ("nord", "Nord"),
  ("one-dark-pro", "One Dark Pro"),
  ("poimandres", "Poimandres"),
  ("red", "Red"),
  ("rose-pine", "Rose Pine"),
  ("rose-pine-moon", "Rose Pine Moon"),
  ("slack-dark", "Slack Dark"),
  ("solarized-dark", "Solarized Dark"),
  ("synthwave-84", "Synthwave 84"),
  ("tokyo-night", "Tokyo Night"),
  ("vesper", "Vesper"),
  ("vitesse-black", "Vitesse Black"),
  ("vitesse-dark", "Vitesse Dark"),
]

///|
fn all_theme_ids() -> Array[String] {
  [
    ..light_theme_items.map(item => item.0),
    ..dark_theme_items.map(item => item.0),
  ]
}

///|
fn ensure_overlay_sync(input_id : String, preview_id : String) -> Unit {
  let input = @dom.document().get_element_by_id(input_id).to_option()
  let preview = @dom.document().get_element_by_id(preview_id).to_option()
  guard (input, preview) is (Some(input), Some(preview)) else { return }
  fn sync_overlay_scroll() {
    preview.set_scroll_top(input.get_scroll_top())
    preview.set_scroll_left(input.get_scroll_left())
  }
  sync_overlay_scroll()
  input.add_event_listener("scroll", _ => sync_overlay_scroll())
}

///|
fn replace_string(value : String) -> (String) -> String {
  _ => value
}

///|
fn stack_class(theme : String) -> String {
  match theme {
    "catppuccin-latte"
    | "everforest-light"
    | "github-light"
    | "github-light-default"
    | "github-light-high-contrast"
    | "kanagawa-lotus"
    | "light-plus"
    | "material-theme-lighter"
    | "min-light"
    | "one-light"
    | "rose-pine-dawn"
    | "slack-ochin"
    | "snazzy-light"
    | "solarized-light"
    | "vitesse-light" => "editor-stack light-theme"
    _ => "editor-stack dark-theme"
  }
}

///|
struct ControlsState {
  lang : String
  theme : String
} derive(Eq)

///|
fn controls_view(
  lang : Val[String],
  set_lang : Emit[(String) -> String],
  theme : Val[String],
  set_theme : Emit[(String) -> String],
) -> Val[Html] {
  lang.map2(theme, (lang, theme) => {
    let model : ControlsState = { lang, theme, }
    div(class="controls", [
      div(class="control", [
        p(class="control-label", "Language"),
        select(
          id="lang-select",
          class="control-select",
          on_change=set_lang.map(replace_string),
          language_items.map(p => {
            option(value=p.0, selected=model.lang == p.0, p.1)
          }),
        ),
      ]),
      div(class="control", [
        p(class="control-label", "Theme"),
        select(
          id="theme-select",
          class="control-select",
          on_change=set_theme.map(replace_string),
          [
            ..light_theme_items.map(p => {
              option(value=p.0, selected=model.theme == p.0, p.1)
            }),
            option(disabled=true, "----------"),
            ..dark_theme_items.map(p => {
              option(value=p.0, selected=model.theme == p.0, p.1)
            }),
          ],
        ),
      ]),
    ])
  })
}

///|
fn highlighted_view(
  code : Val[String],
  lang : Val[String],
  theme : Val[String],
) -> Val[Html] {
  @shiki.shiki_code(code, lang~, theme~)
}

///|
fn editor_view(
  code : Val[String],
  set_code : Emit[(String) -> String],
  lang : Val[String],
  theme : Val[String],
) -> Val[Html] {
  let highlighted = highlighted_view(code, lang, theme)
  code.map3(theme, highlighted, (code, theme, highlighted) => {
    div(class="editor-card", [
      div(class=stack_class(theme), [
        div(id="code-preview", class="preview-layer", [highlighted]),
        textarea(
          id="code-input",
          class="input-layer",
          value=code,
          on_input=set_code.map(replace_string),
          nothing,
        ),
      ]),
    ])
  })
}

///|
fn shiki_editor() -> Val[Html] {
  let (code, set_code) = @rabbita.create_variable(initial_code)
  let (lang, set_lang) = @rabbita.create_variable("moonbit")
  let (theme, set_theme) = @rabbita.create_variable("github-light")
  let controls = controls_view(lang, set_lang, theme, set_theme)
  let editor = editor_view(code, set_code, lang, theme)
  controls.map2(editor, (controls, editor) => {
    div(class="shiki-playground", [
      div(class="editor-header", [
        h1(class="title", "Shiki Editor in Rabbita"),
        p(class="subtitle", "Type directly in the highlighted area."),
      ]),
      controls,
      editor,
      p(class="footer-note", "Powered by MoonBit"),
    ])
  })
}

///|
let initial_code =
  #|fn main {
  #|  println("for-in loop:")
  #|  let array = [1, 2, 3]
  #|  for element in array {
  #|    println("element: \{element}")
  #|  }
  #|
  #|  println("for-in loop with index:")
  #|  for i, element in array {
  #|    println("index: \{i}, element: \{element}")
  #|  }
  #|  
  #|  println("for-in loop for map:")
  #|  let map = { "key1": 1, "key2": 2, "key3": 3 }
  #|  for k, v in map {
  #|    println("key: \{k}, value: \{v}")
  #|  }
  #|}

///|
#warnings("-alert_unstable")
fn main {
  @shiki.initialize(
    langs=FixedArray::from_array(language_items.map(item => item.0)),
    themes=FixedArray::from_array(all_theme_ids()),
  )
  @rabbita.new(shiki_editor).mount("app")
  ensure_overlay_sync("code-input", "code-preview")
}
