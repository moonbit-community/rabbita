///|
extern "js" fn load_shiki() -> @js.Promise =
  #| (async () => {
  #|   const [
  #|     { createHighlighterCore },
  #|     { createJavaScriptRegexEngine },
  #|   ] = await Promise.all([
  #|     import('https://esm.sh/shiki@3.23.0/core'),
  #|     import('https://esm.sh/shiki@3.23.0/engine/javascript'),
  #|   ])
  #|
  #|   return createHighlighterCore({
  #|     langs: [],
  #|     themes: [],
  #|     engine: createJavaScriptRegexEngine(),
  #|   })
  #| })

///|
extern "js" fn load_langs(
  highlighter : @js.Value,
  langs : FixedArray[String],
) -> @js.Promise =
  #| (hl, langs) =>
  #|   hl.loadLanguage(
  #|     ...langs.map(lang =>
  #|       import(/* @vite-ignore */ ('https://esm.sh/shiki@3.23.0/langs/' + lang))
  #|     )
  #|   )

///|
extern "js" fn load_themes(
  highlighter : @js.Value,
  themes : FixedArray[String],
) -> @js.Promise =
  #| (hl, themes) =>
  #|   hl.loadTheme(
  #|     ...themes.map(theme =>
  #|       import(/* @vite-ignore */ ('https://esm.sh/shiki@3.23.0/themes/' + theme))
  #|     )
  #|   )

///|
extern "js" fn code_to_html(
  highlighter : @js.Value,
  code : String,
  lang : String,
  theme : String,
) -> String =
  #| (hl, code, lang, theme) => {
  #|   try {
  #|     return hl.codeToHtml(code, { lang, theme })
  #|   } catch (e) {
  #|     console.warn(`[shiki] highlight failed: lang=${lang}, theme=${theme}`, e)
  #|     return ""
  #|   }
  #| }

///|
extern "js" fn install_static_code_element(highlighter : @js.Value) -> Unit =
  #| highlighter => {
  #|   if (!globalThis.customElements) return
  #|   const stateKey = Symbol.for('yoorkin.shiki.static-code')
  #|   const state = globalThis[stateKey] ??= {
  #|     highlighter,
  #|     observer: null,
  #|     pending: new Set(),
  #|     scheduled: false,
  #|   }
  #|   state.highlighter = highlighter
  #|
  #|   const styles = `
  #|     :host { display: block; min-width: 0; }
  #|     .shiki {
  #|       box-sizing: border-box;
  #|       min-width: max-content;
  #|       margin: 0;
  #|       background: transparent !important;
  #|       padding: var(--yoorkin-shiki-padding, 1.125rem 0);
  #|       font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
  #|       font-size: var(--yoorkin-shiki-font-size, 0.8125rem);
  #|       line-height: var(--yoorkin-shiki-line-height, 1.75);
  #|       tab-size: 2;
  #|       white-space: pre;
  #|     }
  #|     code { display: grid; counter-reset: yoorkin-shiki-line; }
  #|     .line {
  #|       display: block;
  #|       min-height: 1lh;
  #|       padding: 0 4rem 0 0;
  #|       counter-increment: yoorkin-shiki-line;
  #|     }
  #|     .line::before {
  #|       content: counter(yoorkin-shiki-line);
  #|       display: inline-block;
  #|       box-sizing: border-box;
  #|       width: 4rem;
  #|       padding-right: 1.5rem;
  #|       color: var(--rui-muted-foreground, currentColor);
  #|       text-align: right;
  #|       opacity: 0.65;
  #|       user-select: none;
  #|     }
  #|   `
  #|
  #|   const highlight = element => {
  #|     if (!element.isConnected) return
  #|     const lang = element.dataset.lang || ''
  #|     const lightTheme = element.dataset.lightTheme || ''
  #|     const darkTheme = element.dataset.darkTheme || ''
  #|     const code = (element.textContent || '').replace(/\r?\n$/, '')
  #|     const sourceKey = `${lang}\0${lightTheme}\0${darkTheme}\0${code}`
  #|     if (
  #|       element.dataset.shikiHighlighted !== undefined &&
  #|       element.__yoorkinShikiSourceKey === sourceKey
  #|     ) return
  #|     try {
  #|       const html = state.highlighter.codeToHtml(code, {
  #|         lang,
  #|         themes: { light: lightTheme, dark: darkTheme },
  #|         defaultColor: 'light-dark()',
  #|       })
  #|       const shadow = element.shadowRoot || element.attachShadow({ mode: 'open' })
  #|       shadow.innerHTML = `<style>${styles}</style>${html}`
  #|       element.__yoorkinShikiSourceKey = sourceKey
  #|       element.dataset.shikiHighlighted = ''
  #|     } catch (error) {
  #|       console.warn(
  #|         `[shiki] dual-theme highlight failed: lang=${lang}, themes=${lightTheme}/${darkTheme}`,
  #|         error,
  #|       )
  #|     }
  #|   }
  #|
  #|   const schedule = element => {
  #|     state.pending.add(element)
  #|     if (state.scheduled) return
  #|     state.scheduled = true
  #|     const run = deadline => {
  #|       state.scheduled = false
  #|       for (const pending of state.pending) {
  #|         state.pending.delete(pending)
  #|         highlight(pending)
  #|         if (!deadline.didTimeout && deadline.timeRemaining() < 4) break
  #|       }
  #|       if (state.pending.size > 0) schedule(state.pending.values().next().value)
  #|     }
  #|     if (globalThis.requestIdleCallback) {
  #|       globalThis.requestIdleCallback(run, { timeout: 250 })
  #|     } else {
  #|       globalThis.setTimeout(() => run({ didTimeout: true, timeRemaining: () => 0 }), 0)
  #|     }
  #|   }
  #|
  #|   if (!state.observer && globalThis.IntersectionObserver) {
  #|     state.observer = new IntersectionObserver(entries => {
  #|       for (const entry of entries) {
  #|         if (!entry.isIntersecting) continue
  #|         state.observer.unobserve(entry.target)
  #|         schedule(entry.target)
  #|       }
  #|     }, { rootMargin: '900px 0px' })
  #|   }
  #|
  #|   if (!customElements.get('yoorkin-shiki-code')) {
  #|     customElements.define('yoorkin-shiki-code', class extends HTMLElement {
  #|       static get observedAttributes() {
  #|         return ['data-lang', 'data-light-theme', 'data-dark-theme']
  #|       }
  #|
  #|       connectedCallback() {
  #|         if (!this.__yoorkinShikiObserver) {
  #|           this.__yoorkinShikiObserver = new MutationObserver(() => highlight(this))
  #|           this.__yoorkinShikiObserver.observe(this, {
  #|             childList: true,
  #|             characterData: true,
  #|             subtree: true,
  #|           })
  #|         }
  #|         if (state.observer) state.observer.observe(this)
  #|         else schedule(this)
  #|       }
  #|
  #|       attributeChangedCallback(_name, previous, next) {
  #|         if (this.isConnected && previous !== next) highlight(this)
  #|       }
  #|
  #|       disconnectedCallback() {
  #|         state.observer?.unobserve(this)
  #|         state.pending.delete(this)
  #|         this.__yoorkinShikiObserver?.disconnect()
  #|         this.__yoorkinShikiObserver = null
  #|       }
  #|     })
  #|   }
  #| }

///|
using @rabbita {type Cmd}

///|
extern "js" fn is_highlighter(x : @js.Value) -> Bool =
  #| (x) => !!x
  #|   && typeof x.codeToHtml === 'function'
  #|   && typeof x.loadLanguage === 'function'
  #|   && typeof x.loadTheme === 'function'

///|
priv struct Singleton {
  highlighter : @js.Value
  loaded_langs : Set[String]
  loaded_themes : Set[String]
  config : Config?
}

///|
impl Eq for Singleton with fn equal(a, b) {
  a.loaded_langs == b.loaded_langs &&
  a.loaded_themes == b.loaded_themes &&
  a.config == b.config
}

///|
let global_shiki_hl : Ref[Singleton?] = Ref(None)

///|
#cfg(target="js")
fn async_run(f : async () -> Unit noraise) -> Unit = "%async.run"

///|
pub fn initialize(
  langs~ : FixedArray[String],
  themes~ : FixedArray[String],
) -> Unit {
  async_run(() => {
    try {
      let singleton = match global_shiki_hl.val {
        Some(s) => s
        None => {
          let highlighter = load_shiki().wait()
          guard is_highlighter(highlighter) else {
            fail("shiki highlighter init failed: invalid object")
          }
          let singleton = {
            highlighter,
            loaded_langs: Set([]),
            loaded_themes: Set([]),
            config: None,
          }
          global_shiki_hl.val = Some(singleton)
          singleton
        }
      }
      try load_langs(singleton.highlighter, langs).wait() |> ignore catch {
        e => fail("shiki load langs failed: \{e}")
      }
      for lang in langs {
        singleton.loaded_langs.add(lang)
      }

      try load_themes(singleton.highlighter, themes).wait() |> ignore catch {
        e => fail("shiki load themes failed: \{e}")
      }
      for theme in themes {
        singleton.loaded_themes.add(theme)
      }
      install_static_code_element(singleton.highlighter)
    } catch {
      e => println(e)
    }
  })
}

///|
/// Load a reusable Shiki highlighter before constructing static HTML.
///
/// This is useful for renderers whose component tree must stay synchronous:
/// await this once at the application boundary, then call `static_code` from
/// any number of otherwise ordinary `Html` functions.
pub async fn initialize_static(
  langs~ : FixedArray[String],
  themes~ : FixedArray[String],
) -> Unit {
  let singleton = match global_shiki_hl.val {
    Some(s) => s
    None => {
      let highlighter = load_shiki().wait()
      guard is_highlighter(highlighter) else {
        fail("shiki highlighter init failed: invalid object")
      }
      let singleton = {
        highlighter,
        loaded_langs: Set([]),
        loaded_themes: Set([]),
        config: None,
      }
      global_shiki_hl.val = Some(singleton)
      singleton
    }
  }
  try load_langs(singleton.highlighter, langs).wait() |> ignore catch {
    e => fail("shiki load langs failed: \{e}")
  }
  for lang in langs {
    singleton.loaded_langs.add(lang)
  }
  try load_themes(singleton.highlighter, themes).wait() |> ignore catch {
    e => fail("shiki load themes failed: \{e}")
  }
  for theme in themes {
    singleton.loaded_themes.add(theme)
  }
  install_static_code_element(singleton.highlighter)
}

///|
/// Render source with two preloaded Shiki themes. The generated foreground
/// colors use CSS `light-dark()`, so a containing `color-scheme` switch updates
/// existing code blocks without rebuilding the Rabbita tree.
#warnings("-alert_xss_vulnerable")
pub fn static_code(
  code : String,
  lang~ : String,
  light_theme~ : String,
  dark_theme~ : String,
) -> @html.Html {
  let attrs = @html.Attrs::build()
    .data_set("shiki-code", "")
    .data_set("lang", lang)
    .data_set("light-theme", light_theme)
    .data_set("dark-theme", dark_theme)
  @html.node(
    "yoorkin-shiki-code",
    attrs,
    @html.pre(@html.code(@html.text(code))),
  )
}

///|
fn load_shiki_highlight(
  lang : String,
  theme : String,
  inject : @rabbita.Emit[Result[Singleton, Error]],
) -> Cmd {
  @rabbita.attempt(inject.0, async fn() {
    let singleton = match global_shiki_hl.val {
      Some(s) => s
      None => {
        let highlighter = load_shiki().wait()
        guard is_highlighter(highlighter) else {
          fail("shiki highlighter init failed: invalid object")
        }
        let singleton = {
          highlighter,
          loaded_langs: Set([]),
          loaded_themes: Set([]),
          config: Some({ lang, theme, }),
        }
        global_shiki_hl.val = Some(singleton)
        singleton
      }
    }
    if !singleton.loaded_langs.contains(lang) {
      try load_langs(singleton.highlighter, [lang]).wait() |> ignore catch {
        e => fail("shiki load langs failed: \{e}")
      }
    }
    if !singleton.loaded_themes.contains(theme) {
      try load_themes(singleton.highlighter, [theme]).wait() |> ignore catch {
        e => fail("shiki load themes failed: \{e}")
      }
    }
    singleton
    // code_to_html(singleton.highlighter, code, lang, theme)
  })
}

///|
struct Config {
  lang : String
  theme : String
} derive(Eq)

///|
impl @rabbita.Enumerate for Config with fn tag(self : Config) {
  "\{self.lang}, \{self.theme}"
}

///|
#warnings("-alert_xss_vulnerable")
pub fn shiki_code(
  code : Val[String],
  lang~ : Val[String],
  theme~ : Val[String],
) -> Val[Html] {
  let config = lang.map2(theme, (lang, theme) => { lang, theme, })
  let hl = config.switch(config => {
    @rabbita.create_resource(inject => {
      load_shiki_highlight(config.lang, config.theme, inject)
    })
  })

  code.map3(config, hl, (code, config, x) => {
    match x {
      Loaded(hl) => {
        let str = code_to_html(hl.highlighter, code, config.lang, config.theme)
        @html.code(attrs=@html.Attrs::build().inner_html(str), @html.nothing)
      }
      Pending => @html.div(@html.pre(code))
      Failed(_) => @html.div(@html.pre(code))
    }
  })
}

///|
using @rabbita {type Html, type Val}
