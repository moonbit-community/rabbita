///|
using @html {
  a,
  blockquote,
  button,
  code,
  del,
  div,
  em,
  footer,
  fragment,
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  header,
  hr,
  img,
  li,
  main_,
  nav,
  nothing,
  ol,
  p,
  pre,
  section,
  span,
  strong,
  table,
  tbody,
  td,
  text,
  th,
  thead,
  tr,
  ul,
}

///|
using @rabbita {type Html, type Val, type Cmd, batch, none}

///|
enum Theme {
  System
  Light
  Dark
} derive(Eq)

///|
enum Page {
  Home
  Tour(TourModel)
  Components(String)
} derive(Eq)

///|
impl @rabbita.Enumerate for Page with fn tag(self) {
  match self {
    Home => "home"
    Tour(_) => "tour"
    Components(slug) => "components:" + slug
  }
}

///|
enum Msg {
  UrlChanged(@url.Url)
  UrlRequest(@url.UrlRequest)
}

///|
struct Model {
  page : Page
} derive(Eq)

///|
let github_url : String = "https://github.com/moonbit-community/rabbita"

///|
let docs_url : String = "https://mooncakes.io/docs/moonbit-community/rabbita/"

///|
let template_url : String = "https://github.com/moonbit-community/rabbita-template"

///|
let code_counter : String =
  #|fn main {
  #|  enum Msg {
  #|    Click
  #|  }
  #|  fn app() {
  #|    let (count, inject) = @rabbita.create_pure_state(
  #|      0,
  #|      update=(count, msg) => {
  #|        match msg {
  #|          Click => count + 1
  #|        }
  #|      },
  #|    )
  #|    count.map(count => {
  #|      button(on_click=inject(Click), "You clicked \{count} times")
  #|    })
  #|  }
  #|  new(app).mount("app")
  #|}

///|
let code_ssr : String =
  #|test "render html to string" {
  #|  enum Msg {}
  #|  struct Model {
  #|    todos : Array[String]
  #|  }
  #|  let page = @rabbita.simple_cell(
  #|    model={ todos: ["todo1", "todo2"] },
  #|    update=(_ : Msg, model) => model,
  #|    view=(_, model) => ul(model.todos.map(x => li(x))),
  #|  )
  #|  inspect(
  #|    @rabbita.render_to_string(page),
  #|    content=(
  #|      #|<ul><li>todo1</li><li>todo2</li></ul>
  #|    ),
  #|  )
  #|}

// ─── Comparison code samples ──────────────────────────────────────────────

///|
let cmp_js_match : String =
  #|function getLabel(status) {
  #|  if (status === 'active') {
  #|    return 'Active';
  #|  } else if (status === 'pending') {
  #|    return 'Pending';
  #|  } else {
  #|    return 'Unknown';
  #|  }
  #|}

///|
let cmp_mb_match : String =
  #|fn get_label(status : Status) -> String {
  #|  match status {
  #|    Active  => "Active"
  #|    Pending => "Pending"
  #|  }
  #|}

///|
let cmp_js_expr : String =
  #|const label = (() => {
  #|  if (isLoggedIn) {
  #|    return 'Welcome back!';
  #|  } else {
  #|    return 'Please sign in.';
  #|  }
  #|})()

///|
let cmp_mb_expr : String =
  #|let label = if is_logged_in {
  #|  "Welcome back!"
  #|} else {
  #|  "Please sign in."
  #|}

///|
let cmp_js_update : String =
  #|const next = {
  #|  ...model,
  #|  count: model.count + 1,
  #|}

///|
let cmp_mb_update : String =
  #|let next = {
  #|  ..model,
  #|  count: model.count + 1,
  #|}

///|
struct CmpEntry {
  label : String
  desc : String
  js_src : String
  mb_src : String
}

///|
let cmp_entries : Array[CmpEntry] = [
  {
    label: "Pattern matching",
    desc: "Exhaustive by default. No fallthrough, no forgotten cases.",
    js_src: cmp_js_match,
    mb_src: cmp_mb_match,
  },
  {
    label: "if / match as expressions",
    desc: "Control flow returns values directly. No IIFE wrappers, no ternary pyramids.",
    js_src: cmp_js_expr,
    mb_src: cmp_mb_expr,
  },
  {
    label: "Record update",
    desc: "Pure, concise, type-checked. Only the fields you change.",
    js_src: cmp_js_update,
    mb_src: cmp_mb_update,
  },
]

// ─── Feature Icons ────────────────────────────────────────────────────────

///|
/// Arrow with source dot — represents a single-direction flow
fn icon_flow() -> Html {
  @svg.svg(view_box="0 0 24 24", width=24, height=24, class="feat-icon", [
    @svg.circle(cx=4, cy=12, r=2, fill="currentColor"),
    @svg.path(
      d="M 8 12 L 20 12 M 15 7 L 20 12 L 15 17",
      fill="none",
      stroke="currentColor",
      stroke_width=2,
    ),
  ])
}

///|
/// Shield with checkmark — represents type safety
fn icon_shield() -> Html {
  @svg.svg(view_box="0 0 24 24", width=24, height=24, class="feat-icon", [
    @svg.path(
      d="M 12 3 L 4 7 V 12 C 4 17 8 21 12 22 C 16 21 20 17 20 12 V 7 Z",
      fill="none",
      stroke="currentColor",
      stroke_width=2,
    ),
    @svg.path(
      d="M 9 12 L 11 14 L 15 10",
      fill="none",
      stroke="currentColor",
      stroke_width=2,
    ),
  ])
}

///|
/// Stacked layers — represents modular, composable cells
fn icon_layers() -> Html {
  @svg.svg(view_box="0 0 24 24", width=24, height=24, class="feat-icon", [
    @svg.path(
      d="M 12 2 L 2 7 L 12 12 L 22 7 Z",
      fill="none",
      stroke="currentColor",
      stroke_width=2,
    ),
    @svg.path(
      d="M 2 12 L 12 17 L 22 12",
      fill="none",
      stroke="currentColor",
      stroke_width=2,
    ),
    @svg.path(
      d="M 2 17 L 12 22 L 22 17",
      fill="none",
      stroke="currentColor",
      stroke_width=2,
    ),
  ])
}

///|
/// Package box — represents small bundle size
fn icon_box() -> Html {
  @svg.svg(view_box="0 0 24 24", width=24, height=24, class="feat-icon", [
    @svg.path(
      d="M 5 8 L 12 4 L 19 8 L 19 16 L 12 20 L 5 16 Z",
      fill="none",
      stroke="currentColor",
      stroke_width=2,
    ),
    @svg.path(
      d="M 5 8 L 12 12 L 19 8",
      fill="none",
      stroke="currentColor",
      stroke_width=2,
    ),
    @svg.line(x1=12, y1=12, x2=12, y2=20, stroke="currentColor", stroke_width=2),
  ])
}

// ─── Theme Toggle Icons ───────────────────────────────────────────────────

///|
/// Sun — shown when theme is Light
fn icon_sun() -> Html {
  @svg.svg(view_box="0 0 24 24", width=20, height=20, class="theme-icon", [
    @svg.circle(
      cx=12,
      cy=12,
      r=4,
      fill="none",
      stroke="currentColor",
      stroke_width=2,
    ),
    @svg.path(
      d="M 12 2 V 5 M 12 19 V 22 M 4.22 4.22 L 6.34 6.34 M 17.66 17.66 L 19.78 19.78 M 2 12 H 5 M 19 12 H 22 M 4.22 19.78 L 6.34 17.66 M 17.66 6.34 L 19.78 4.22",
      fill="none",
      stroke="currentColor",
      stroke_width=2,
    ),
  ])
}

///|
/// Crescent moon — shown when theme is Dark
fn icon_moon() -> Html {
  @svg.svg(view_box="0 0 24 24", width=20, height=20, class="theme-icon", [
    @svg.path(
      d="M 21 12.79 A 9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79 Z",
      fill="none",
      stroke="currentColor",
      stroke_width=2,
    ),
  ])
}

///|
/// Half-filled circle — left half filled (dark), right half empty (light)
fn icon_auto() -> Html {
  @svg.svg(view_box="0 0 24 24", width=20, height=20, class="theme-icon", [
    @svg.circle(
      cx=12,
      cy=12,
      r=9,
      fill="none",
      stroke="currentColor",
      stroke_width=2,
    ),
    @svg.path(d="M 12 3 A 9 9 0 0 0 12 21 Z", fill="currentColor"),
  ])
}

///|
fn theme_icon(theme : Theme) -> Html {
  match theme {
    System => icon_auto()
    Light => icon_sun()
    Dark => icon_moon()
  }
}

///|
extern "js" fn prefers_dark_color_scheme() -> Bool =
  #| () => globalThis.matchMedia?.('(prefers-color-scheme: dark)').matches ?? false

// ─── Navigation ───────────────────────────────────────────────────────────

///|
/// Diagonal arrow — external link indicator
fn icon_ext_link() -> Html {
  @svg.svg(view_box="0 0 12 12", width=10, height=10, class="nav-ext-icon", [
    @svg.path(
      d="M 2 10 L 10 2 M 5.5 2 H 10 V 6.5",
      fill="none",
      stroke="currentColor",
      stroke_width=2,
      attrs=@svg.Attrs::build().stroke_linecap("round").stroke_linejoin("round"),
    ),
  ])
}

///|
fn hamburger(is_open : Bool) -> Html {
  div(class=if is_open { "hamburger is-open" } else { "hamburger" }, [
    div(class="bar", nothing),
    div(class="bar", nothing),
    div(class="bar", nothing),
  ])
}

///|
enum NavPage {
  NavHome
  NavTour
  NavComponents
} derive(Eq)

///|
struct NavModel {
  theme : Theme
  current : NavPage
} derive(Eq)

///|
fn nav_link_attrs(is_current : Bool) -> @html.Attrs {
  let attrs = @html.Attrs::build()
  if is_current {
    ignore(attrs.aria_current("page"))
  }
  attrs
}

///|
fn site_nav(model : Val[NavModel], on_cycle_theme : Cmd) -> Val[Html] {
  let (menu_open, set_menu_open) = @rabbita.create_variable(false)
  model.map2(menu_open, (model, menu_open) => {
    let is_home = model.current == NavHome
    let is_tour = model.current == NavTour
    let is_components = model.current == NavComponents
    let home_cls = if is_home {
      "nav-link nav-link--active"
    } else {
      "nav-link"
    }
    let tour_cls = if is_tour {
      "nav-link nav-link--active"
    } else {
      "nav-link"
    }
    let components_cls = if is_components {
      "nav-link nav-link--active"
    } else {
      "nav-link"
    }
    let home_m = if is_home {
      "mobile-link mobile-link--active"
    } else {
      "mobile-link"
    }
    let tour_m = if is_tour {
      "mobile-link mobile-link--active"
    } else {
      "mobile-link"
    }
    let components_m = if is_components {
      "mobile-link mobile-link--active"
    } else {
      "mobile-link"
    }
    let theme_label = match model.theme {
      System => "Theme: system"
      Light => "Theme: light"
      Dark => "Theme: dark"
    }
    header(class="site-header", [
      nav(
        class="navbar",
        attrs=@html.Attrs::build().aria_label("Primary navigation"),
        [
          a(class="nav-logo", href=github_url, "Rabbita"),
          div(class="nav-links", [
            a(
              href=site_base_url(),
              class=home_cls,
              attrs=nav_link_attrs(is_home),
              "Home",
            ),
            a(
              href=tour_base_url(),
              class=tour_cls,
              attrs=nav_link_attrs(is_tour),
              "Tour",
            ),
            a(
              href=components_base_url(),
              class=components_cls,
              attrs=nav_link_attrs(is_components),
              "Components",
            ),
            a(
              href=playground_url(),
              class="nav-link nav-link--ext",
              escape=true,
              [text("Playground"), icon_ext_link()],
            ),
            a(href=docs_url, target=Blank, class="nav-link nav-link--ext", [
              text("Docs"),
              icon_ext_link(),
            ]),
            a(href=github_url, target=Blank, class="nav-link nav-link--ext", [
              text("GitHub"),
              icon_ext_link(),
            ]),
          ]),
          div(class="nav-actions", [
            button(
              class="theme-toggle",
              title=theme_label,
              attrs=@html.Attrs::build().aria_label(theme_label),
              on_click=on_cycle_theme,
              [theme_icon(model.theme)],
            ),
            button(
              class="nav-toggle",
              title=if menu_open { "Close menu" } else { "Open menu" },
              attrs=@html.Attrs::build()
                .aria_label(if menu_open { "Close menu" } else { "Open menu" })
                .aria_controls("mobile-navigation")
                .aria_expanded(if menu_open { "true" } else { "false" }),
              on_click=set_menu_open(open => !open),
              [hamburger(menu_open)],
            ),
          ]),
        ],
      ),
      if menu_open {
        div(id="mobile-navigation", class="mobile-menu", [
          a(
            href=site_base_url(),
            class=home_m,
            attrs=nav_link_attrs(is_home).on_click(_ => {
              set_menu_open(_ => false)
            }),
            "Home",
          ),
          a(
            href=tour_base_url(),
            class=tour_m,
            attrs=nav_link_attrs(is_tour).on_click(_ => {
              set_menu_open(_ => false)
            }),
            "Tour",
          ),
          a(
            href=components_base_url(),
            class=components_m,
            attrs=nav_link_attrs(is_components).on_click(_ => {
              set_menu_open(_ => false)
            }),
            "Components",
          ),
          a(
            href=playground_url(),
            class="mobile-link mobile-link--ext",
            escape=true,
            [text("Playground"), icon_ext_link()],
          ),
          a(href=docs_url, target=Blank, class="mobile-link mobile-link--ext", [
            text("Docs"),
            icon_ext_link(),
          ]),
          a(
            href=github_url,
            target=Blank,
            class="mobile-link mobile-link--ext",
            [text("GitHub"), icon_ext_link()],
          ),
        ])
      } else {
        nothing
      },
    ])
  })
}

// ─── Hero ─────────────────────────────────────────────────────────────────

///|
struct HeroTabEntry {
  label : String
  src : String
}

///|
let hero_tabs : Array[HeroTabEntry] = [
  { label: "Counter", src: code_counter },
  { label: "SSR", src: code_ssr },
]

///|
struct HeroViewModel {
  hero_tab : Int
} derive(Eq)

///|
impl @rabbita.Enumerate for HeroViewModel with fn tag(self) {
  self.hero_tab.to_string()
}

///|
fn dual_block(src : String, lang : String) -> Val[Html] {
  let src = Val::constant(src)
  let lang = Val::constant(lang)
  let light_code = @shiki.shiki_code(
    src,
    lang~,
    theme=Val::constant("github-light"),
  )
  let dark_code = @shiki.shiki_code(
    src,
    lang~,
    theme=Val::constant("github-dark-default"),
  )
  light_code.map2(dark_code, (light, dark) => {
    div(class="code-dual", [
      div(class="code-light", [light]),
      div(class="code-dark", [dark]),
    ])
  })
}

///|
fn hero() -> Val[Html] {
  let (model, set_model) = @rabbita.create_variable({ hero_tab: 0 })
  model.switch(model => {
    let src = hero_tabs[model.hero_tab].src
    let code_block = dual_block(src, "moonbit")

    code_block.map(code_block => {
      section(class="hero", [
        div(class="hero-grid", [
          div(class="hero-left", [
            h1(class="hero-title", [
              span(class="hero-accent", "Confidence"),
              text(" at every scale."),
            ]),
            p(
              class="hero-desc",
              "A web UI framework for MoonBit. Declarative, typed, and functional.",
            ),
            div(class="hero-actions", [
              a(
                class="btn-primary",
                href=template_url,
                target=Blank,
                "Get Started",
              ),
              a(class="btn-secondary", href=github_url, target=Blank, "GitHub"),
            ]),
          ]),
          div(class="hero-right", [
            div(
              class="hero-tabs",
              hero_tabs.mapi(fn(i, t) {
                let cls = if i == model.hero_tab {
                  "hero-tab hero-tab--active"
                } else {
                  "hero-tab"
                }
                button(
                  class=cls,
                  on_click=set_model(_ => { hero_tab: i }),
                  t.label,
                )
              }),
            ),
            div(class="hero-code", code_block),
          ]),
        ]),
      ])
    })
  })
}

// ─── Features ─────────────────────────────────────────────────────────────

///|
fn feature_card(icon : Html, title : String, desc : String) -> Html {
  div(class="feature-card", [
    div(class="feature-icon", [icon]),
    h3(class="feature-title", title),
    p(class="feature-desc", desc),
  ])
}

///|
fn features() -> Html {
  section(class="features", [
    div(class="features-inner", [
      h2(class="section-title", "Why Rabbita?"),
      div(class="features-grid", [
        feature_card(
          icon_flow(),
          "Predictable",
          "Single, explicit update path for state changes. Side effects are managed through Cmd types.",
        ),
        feature_card(
          icon_shield(),
          "Strict Types",
          "Descriptive APIs with no Any sprawl, no stringly-typed values. Leverage the full power of MoonBit's type system.",
        ),
        feature_card(
          icon_layers(),
          "Modular",
          "Split your app into reusable Cells. Only dirty cells trigger re-renders. Cell lifecycle is explicit.",
        ),
        feature_card(
          icon_box(),
          "Tiny Footprint",
          "~15 KB min+gzip including streaming VDOM diff and the MoonBit stdlib with aggressive dead-code elimination.",
        ),
      ]),
    ]),
  ])
}

// ─── Comparison ───────────────────────────────────────────────────────────

///|
fn cmp_card(js_src : String, mb_src : String) -> Val[Html] {
  let js_block = dual_block(js_src, "javascript")
  let mb_block = dual_block(mb_src, "moonbit")
  js_block.map2(mb_block, (js_block, mb_block) => {
    div(class="cmp-card", [
      div(class="cmp-cols", [
        div(class="cmp-col", [
          div(class="cmp-lang-label", "JavaScript"),
          js_block,
        ]),
        div(class="cmp-col", [div(class="cmp-lang-label", "MoonBit"), mb_block]),
      ]),
      div(class="cmp-progress-track", [div(class="cmp-progress-fill", nothing)]),
    ])
  })
}

///|
struct ComparisonViewModel {
  cmp_idx : Int
  cmp_anim : Bool
} derive(Eq)

///|
enum ComparisonMsg {
  SelectComparison(Int)
  NextComparison
}

///|
impl @rabbita.Enumerate for ComparisonViewModel with fn tag(self) {
  "\{self.cmp_idx}:\{self.cmp_anim}"
}

///|
fn comparison() -> Val[Html] {
  let (model, inject) = @rabbita.create_state_with_init(
    init=fn(inject) {
      (
        { cmp_idx: 0, cmp_anim: false },
        @rabbita.delay(inject(NextComparison), 12000),
      )
    },
    update=fn(model, msg, inject) {
      match msg {
        SelectComparison(i) => ({ cmp_idx: i, cmp_anim: !model.cmp_anim }, none)
        NextComparison =>
          (
            {
              cmp_anim: !model.cmp_anim,
              cmp_idx: (model.cmp_idx + 1) % cmp_entries.length(),
            },
            @rabbita.delay(inject(NextComparison), 12000),
          )
      }
    },
  )
  model.switch(model => {
    let entry = cmp_entries[model.cmp_idx]
    let card = cmp_card(entry.js_src, entry.mb_src)
    card.map(card => {
      section(class="comparison", [
        div(class="comparison-inner", [
          h2(class="section-title", "MoonBit feels right"),
          div(class="cmp-widget", [
            div(
              class="cmp-tabs",
              cmp_entries.mapi(fn(i, e) {
                let cls = if i == model.cmp_idx {
                  "cmp-tab cmp-tab--active"
                } else {
                  "cmp-tab"
                }
                button(class=cls, on_click=inject(SelectComparison(i)), e.label)
              }),
            ),
            div(
              class=if model.cmp_anim {
                "cmp-anim-wrap anim-a"
              } else {
                "cmp-anim-wrap anim-b"
              },
              [card],
            ),
            p(class="cmp-nav-desc", entry.desc),
          ]),
        ]),
      ])
    })
  })
}

// ─── Showcase ─────────────────────────────────────────────────────────────

///|
fn showcase_card(
  url : String,
  img_src : String,
  title : String,
  desc : String,
) -> Html {
  a(class="showcase-card", href=url, target=Blank, [
    div(class="showcase-thumb", [
      img(class="showcase-thumb-img", src=img_src, alt=title),
    ]),
    div(class="showcase-info", [
      span(class="showcase-title", title),
      span(class="showcase-desc", desc),
    ]),
  ])
}

///|
fn showcase() -> Html {
  section(class="showcase", [
    div(class="showcase-inner", [
      h2(class="section-title", "Built with Rabbita"),
      p(
        class="section-desc",
        "Real websites running in production on the MoonBit ecosystem.",
      ),
      div(class="showcase-grid", [
        showcase_card(
          "https://moonbit-community.github.io/rabbita/", "rabbita.jpeg", "rabbita",
          "The official Rabbita framework site — this page.",
        ),
        showcase_card(
          "https://mooncakes.io", "mooncakesio.jpeg", "mooncakes.io", "The MoonBit package registry and documentation hub.",
        ),
        showcase_card(
          "https://www.bingque.com/", "bingque.jpeg", "Bingque", "Learn AI concepts faster with guided practice and long-term skill building.",
        ),
        a(
          class="showcase-card showcase-card--submit",
          href=github_url + "/issues",
          target=Blank,
          [
            div(class="showcase-thumb showcase-thumb--submit", [
              div(class="showcase-thumb-placeholder", nothing),
              span(class="showcase-submit-plus", "+"),
            ]),
            div(class="showcase-info", [
              span(class="showcase-title", "Your project here"),
              span(class="showcase-desc", "Using Rabbita? Submit yours →"),
            ]),
          ],
        ),
      ]),
    ]),
  ])
}

// ─── Quick Start ──────────────────────────────────────────────────────────

///|
/// Two overlapping rectangles — clipboard copy
fn icon_copy() -> Html {
  @svg.svg(view_box="0 0 24 24", width=15, height=15, class="qs-copy-icon", [
    @svg.rect(
      x=9,
      y=9,
      width=13,
      height=13,
      rx=2,
      fill="none",
      stroke="currentColor",
      stroke_width=2,
    ),
    @svg.path(
      d="M 5 15 H 4 C 3 15 2 14 2 13 V 4 C 2 3 3 2 4 2 H 13 C 14 2 15 3 15 4 V 5",
      fill="none",
      stroke="currentColor",
      stroke_width=2,
    ),
  ])
}

///|
/// Checkmark — shown after successful copy
fn icon_check() -> Html {
  @svg.svg(view_box="0 0 24 24", width=15, height=15, class="qs-copy-icon", [
    @svg.path(
      d="M 5 12 L 10 17 L 19 7",
      fill="none",
      stroke="currentColor",
      stroke_width=2,
      attrs=@svg.Attrs::build().stroke_linecap("round").stroke_linejoin("round"),
    ),
  ])
}

///|
fn qs_step(num : String, title : String, cmd : String) -> Val[Html] {
  let (copied, set_copied) = @rabbita.create_variable(false)
  copied.map(copied => {
    div(class="qs-step", [
      div(class="qs-step-head", [
        span(class="qs-step-num", num),
        span(class="qs-step-title", title),
      ]),
      div(class="qs-step-code-wrap", [
        pre(class="install-block qs-step-code", [code(cmd)]),
        button(
          class=if copied {
            "qs-copy-btn qs-copy-btn--done"
          } else {
            "qs-copy-btn"
          },
          on_click=batch([
            @clipboard.copy(Text(cmd)),
            set_copied(_ => true),
            @rabbita.delay(set_copied(_ => false), 1500),
          ]),
          [if copied { icon_check() } else { icon_copy() }],
        ),
      ]),
    ])
  })
}

///|
fn quickstart() -> Val[Html] {
  let install = qs_step(
    "1", "Install Warren", "moon install moonbit-community/warren",
  )
  let create = qs_step("2", "Create the app", "warren new my-app\ncd my-app")
  let run = qs_step("3", "Start the dev server", "warren dev")
  install.map3(create, run, (install, create, run) => {
    section(class="quickstart", [
      div(class="quickstart-inner", [
        h2(class="section-title", "Quick Start"),
        p(class="section-desc", "From zero to a running app in three steps."),
        div(class="qs-steps", [install, create, run]),
        div(class="quickstart-cta", [
          a(class="btn-primary", href=docs_url, target=Blank, "Read the Docs"),
          a(
            class="btn-secondary",
            href=template_url,
            target=Blank,
            "Get Template",
          ),
        ]),
      ]),
    ])
  })
}

// ─── Footer ───────────────────────────────────────────────────────────────

///|
fn site_footer() -> Html {
  footer(class="site-footer", [
    div(class="footer-inner", [
      span(class="footer-copy", "© 2026 moonbit-community · Apache 2.0"),
      div(class="footer-links", [
        a(href=github_url, target=Blank, class="footer-link", "GitHub"),
        a(href=docs_url, target=Blank, class="footer-link", "Docs"),
        a(
          href="https://www.moonbitlang.com/",
          target=Blank,
          class="footer-link",
          "MoonBit",
        ),
      ]),
    ]),
  ])
}

// ─── Home ─────────────────────────────────────────────────────────────────

///|
fn home() -> Val[Html] {
  let hero_section = hero()
  let comparison_section = comparison()
  let quickstart_section = quickstart()
  hero_section.map3(comparison_section, quickstart_section, (
    hero_section,
    comparison_section,
    quickstart_section,
  ) => {
    main_(class="site-main", [
      hero_section,
      features(),
      comparison_section,
      showcase(),
      quickstart_section,
    ])
  })
}

// ─── App ──────────────────────────────────────────────────────────────────

///|
fn app() -> Val[Html] {
  let menu = @rabbita.create_resource(inject => {
    @http.get(site_base_url() + "doc/menu.json").expect_json(inject)
  })
  let chapters = menu.map(menu => {
    match menu {
      Loaded(chapters) => chapters
      Pending | Failed(_) => tour_chapters
    }
  })
  let (model, _) = @rabbita.create_state_with_input(
    input=chapters,
    init=fn(_, _) { ({ page: Home }, none) },
    update=fn(model, chapters, msg, _) {
      let (cmd, model) = match msg {
        UrlRequest(req) =>
          match req {
            Internal(url) => (@nav.push_url(url.to_string()), model)
            External(url) => (@nav.load(url), model)
          }
        UrlChanged(url) =>
          if is_components_url(url.path) {
            let scroll_cmd = match url.fragment {
              Some(frag) => scroll_to_heading(frag)
              None => @nav.scroll_to_top()
            }
            (
              scroll_cmd,
              { page: Components(component_slug_from_path(url.path)) },
            )
          } else if is_tour_url(chapters, url.path) {
            let idx = chapter_idx_from_path(chapters, url.path)
            let scroll_cmd = match url.fragment {
              Some(frag) => scroll_to_heading(frag)
              None => @nav.scroll_to_top()
            }
            (scroll_cmd, { page: Tour({ chapter_idx: idx }) })
          } else {
            let cmd = match url.fragment {
              Some(frag) => scroll_to_heading(frag)
              None => @nav.scroll_to_top()
            }
            (cmd, { page: Home })
          }
      }
      (model, cmd)
    },
    subscriptions=fn(_, _, inject) {
      @sub.batch([
        @sub.on_url_changed(url => inject(UrlChanged(url))),
        @sub.on_url_request(req => inject(UrlRequest(req))),
      ])
    },
  )

  let (theme, set_theme) = @rabbita.create_variable(System)
  let page = model.map(model => model.page)
  let nav_model = theme.map2(page, (theme, page) => {
    let current = match page {
      Home => NavHome
      Tour(_) => NavTour
      Components(_) => NavComponents
    }
    { theme, current }
  })
  let site_class_name = theme.map2(page, (theme, page) => {
    let theme_class = match theme {
      System => "site"
      Light => "site light"
      Dark => "site dark"
    }
    match page {
      Components(_) => theme_class + " site--components"
      Home | Tour(_) => theme_class
    }
  })
  let header_html = site_nav(
    nav_model,
    set_theme(theme => {
      match theme {
        System => Dark
        Dark => Light
        Light => System
      }
    }),
  )
  let components_dark = theme.map(theme => {
    match theme {
      System => prefers_dark_color_scheme()
      Light => false
      Dark => true
    }
  })
  let page_html = page.switch(current => {
    match current {
      Home => home()
      Components(slug) => @components.components_page(components_dark, slug)
      Tour(_) =>
        tour(
          page.map2(chapters, (page, chapters) => {
            let tour = match page {
              Tour(model) => model
              Home | Components(_) => init_tour
            }
            { chapters, tour }
          }),
        )
    }
  })
  site_class_name.map3(header_html, page_html, (
    site_class_name,
    header_html,
    page_html,
  ) => div(class=site_class_name, [header_html, page_html, site_footer()]))
}

///|
/// NOTE: This program is only available in the js backend,
/// see README.md to get started.
#warnings("-alert_unstable")
fn main {
  @shiki.initialize(langs=["moonbit"], themes=[
    "github-light", "github-dark-default",
  ])
  @rabbita.new(app).mount("app")
}
