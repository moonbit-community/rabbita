///|
extern "js" fn compile_mbt_promise(
  source : String,
  moon_pkg : String,
) -> @js.Promise[@js.Value] =
  #| (source, moonPkg) => {
  #|   const started = performance.now()
  #|   return import('./support/compiler.js?v=assets-4')
  #|     .then(async ({ compileMbtToJs }) => {
  #|       const result = await compileMbtToJs(source, moonPkg)
  #|       const elapsed = Math.round(performance.now() - started)
  #|       if (result.ok) {
  #|         return {
  #|           ok: true,
  #|           js: result.js,
  #|           packageCount: result.packageCount,
  #|           coreInterfaceCount: result.coreInterfaceCount,
  #|           elapsed,
  #|         }
  #|       }
  #|       return {
  #|         ok: false,
  #|         error: result.diagnostics || 'Compilation failed without diagnostics.',
  #|         diagnostics: result.diagnosticItems || [],
  #|       }
  #|     })
  #|     .catch((error) => ({
  #|       ok: false,
  #|       error: error?.stack || error?.message || String(error),
  #|       diagnostics: [],
  #|     }))
  #| }

///|
extern "js" fn load_assets_promise() -> @js.Promise[@js.Value] =
  #| () => {
  #|   return import('./support/compiler.js?v=assets-4')
  #|     .then(async ({ loadManifest }) => {
  #|       const manifest = await loadManifest()
  #|       const packages = Object.keys(manifest.packages).sort()
  #|       return { ok: true, count: packages.length, packages: packages.join('\n') }
  #|     })
  #|     .catch((error) => ({
  #|       ok: false,
  #|       error: error?.message || String(error),
  #|     }))
  #| }

///|
extern "js" fn resolve_asset_url(path : String) -> String =
  #| (path) => new URL(path, document.baseURI).href

///|
extern "js" fn js_result_ok(value : @js.Value) -> Bool =
  #| (value) => value.ok === true

///|
extern "js" fn js_result_string(value : @js.Value, key : String) -> String =
  #| (value, key) => typeof value[key] === 'string' ? value[key] : ''

///|
extern "js" fn js_result_int(value : @js.Value, key : String) -> Int =
  #| (value, key) => Number.isFinite(value[key]) ? value[key] | 0 : 0

///|
extern "js" fn js_diagnostic_count(value : @js.Value, key : String) -> Int =
  #| (value, key) => Array.isArray(value[key]) ? value[key].length : 0

///|
extern "js" fn js_diagnostic_string(
  value : @js.Value,
  key : String,
  index : Int,
  field : String,
) -> String =
  #| (value, key, index, field) => {
  #|   const item = Array.isArray(value[key]) ? value[key][index] : undefined
  #|   return item && typeof item[field] === 'string' ? item[field] : ''
  #| }

///|
extern "js" fn js_diagnostic_int(
  value : @js.Value,
  key : String,
  index : Int,
  field : String,
) -> Int =
  #| (value, key, index, field) => {
  #|   const item = Array.isArray(value[key]) ? value[key][index] : undefined
  #|   return item && Number.isFinite(item[field]) ? item[field] | 0 : 0
  #| }

///|
extern "js" fn render_preview(html : String, css : String, js : String) -> Unit =
  #| (html, css, js) => {
  #|   const frame = document.getElementById('preview-frame')
  #|   if (!frame) return
  #|   const escapeScript = (source) => source.replaceAll('</script', '<\\/script')
  #|   const escapeStyle = (source) => source.replaceAll('</style', '<\\/style')
  #|   const styleTag = `<style>${escapeStyle(css)}</style>`
  #|   const bridge = `
  #| (() => {
  #|   const send = (kind, args) => {
  #|     parent.postMessage({
  #|       source: 'rabbita-pure-preview',
  #|       kind,
  #|       args: Array.from(args, (item) => {
  #|         if (item instanceof Error) return item.stack || item.message
  #|         if (typeof item === 'string') return item
  #|         try { return JSON.stringify(item) } catch { return String(item) }
  #|       }),
  #|     }, '*')
  #|   }
  #|   for (const level of ['log', 'warn', 'error']) {
  #|     const original = console[level].bind(console)
  #|     console[level] = (...args) => {
  #|       original(...args)
  #|       send(level, args)
  #|     }
  #|   }
  #|   window.addEventListener('error', (event) => {
  #|     send('error', [event.error || event.message])
  #|   })
  #|   window.addEventListener('unhandledrejection', (event) => {
  #|     send('error', [event.reason || 'Unhandled promise rejection'])
  #|   })
  #| })();
  #| `
  #|   const scriptTags = `
  #| <script>${escapeScript(bridge)}</script>
  #| <script type="module">${escapeScript(js)}</script>`
  #|   if (/<html[\s>]/i.test(html)) {
  #|     let doc = /^\s*<!doctype/i.test(html) ? html : `<!doctype html>\n${html}`
  #|     if (/<\/head>/i.test(doc)) {
  #|       doc = doc.replace(/<\/head>/i, `${styleTag}\n</head>`)
  #|     } else {
  #|       doc = doc.replace(/<html[^>]*>/i, `$&\n<head>\n${styleTag}\n</head>`)
  #|     }
  #|     if (/<\/body>/i.test(doc)) {
  #|       doc = doc.replace(/<\/body>/i, `${scriptTags}\n</body>`)
  #|     } else {
  #|       doc = `${doc}\n${scriptTags}`
  #|     }
  #|     frame.srcdoc = doc
  #|     return
  #|   }
  #|   frame.srcdoc = `<!doctype html>
  #| <html lang="en">
  #| <head>
  #|   <meta charset="UTF-8" />
  #|   <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  #|   ${styleTag}
  #| </head>
  #| <body>
  #| ${html}
  #| ${scriptTags}
  #| </body>
  #| </html>`
  #| }

///|
extern "js" fn read_source(field : String, fallback : String) -> String =
  #| (field, fallback) => globalThis.RabbitaPlaygroundShare.readSource(field, fallback)

///|
extern "js" fn has_shared_source() -> Bool =
  #| () => globalThis.RabbitaPlaygroundShare.hasSharedSource()

///|
extern "js" fn has_example_param() -> Bool =
  #| () => globalThis.RabbitaPlaygroundShare.hasExampleParam()

///|
extern "js" fn set_example_url(example : String) -> Unit =
  #| (example) => globalThis.RabbitaPlaygroundShare.setExampleUrl(example)

///|
extern "js" fn save_source_promise(
  example : String,
  mbt : String,
  html : String,
  css : String,
  moon_pkg : String,
) -> @js.Promise[@js.Value] =
  #| (example, mbt, html, css, moonPkg) =>
  #|   globalThis.RabbitaPlaygroundShare.saveSource(example, mbt, html, css, moonPkg)

///|
extern "js" fn share_source_promise(
  example : String,
  mbt : String,
  html : String,
  css : String,
  moon_pkg : String,
) -> @js.Promise[@js.Value] =
  #| (example, mbt, html, css, moonPkg) =>
  #|   globalThis.RabbitaPlaygroundShare.shareSource(example, mbt, html, css, moonPkg)
