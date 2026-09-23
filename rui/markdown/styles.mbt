///|
const MarkdownCss : String =
  #|.rui-markdown { box-sizing:border-box; width:100%; min-width:0; color:var(--rui-foreground,oklch(0.145 0 0)); font-family:var(--rui-font-sans,ui-sans-serif,system-ui,sans-serif); font-size:1rem; line-height:1.75; overflow-wrap:anywhere; text-align:start; }
  #|.rui-markdown *, .rui-markdown *::before, .rui-markdown *::after { box-sizing:border-box; }
  #|.rui-markdown :where(p,ul,ol,blockquote,pre,hr,.rui-markdown-table) { margin:1.25rem 0; }
  #|.rui-markdown :where(h1,h2,h3,h4,h5,h6) { margin:2rem 0 1rem; scroll-margin-top:6rem; color:inherit; text-align:start; font-weight:600; letter-spacing:-0.025em; text-wrap:balance; }
  #|.rui-markdown h1 { font-size:2.25rem; line-height:2.5rem; font-weight:800; }
  #|.rui-markdown h2 { border-bottom:1px solid var(--rui-border,oklch(0.922 0 0)); padding-bottom:0.5rem; font-size:1.875rem; line-height:2.25rem; }
  #|.rui-markdown h3 { font-size:1.5rem; line-height:2rem; }
  #|.rui-markdown h4 { font-size:1.25rem; line-height:1.75rem; }
  #|.rui-markdown h5 { font-size:1rem; line-height:1.5rem; }
  #|.rui-markdown h6 { font-size:0.875rem; line-height:1.25rem; color:var(--rui-muted-foreground,oklch(0.556 0 0)); }
  #|.rui-markdown > :first-child, .rui-markdown blockquote > :first-child, .rui-markdown li > :first-child { margin-top:0; }
  #|.rui-markdown > :last-child, .rui-markdown blockquote > :last-child, .rui-markdown li > :last-child { margin-bottom:0; }
  #|.rui-markdown a { color:inherit; font-weight:500; text-decoration:underline; text-underline-offset:0.2em; }
  #|.rui-markdown a:hover { color:var(--rui-muted-foreground,oklch(0.556 0 0)); }
  #|.rui-markdown :focus-visible { outline:2px solid var(--rui-ring,oklch(0.708 0 0)); outline-offset:3px; border-radius:0.125rem; }
  #|.rui-markdown strong { font-weight:600; }
  #|.rui-markdown ul, .rui-markdown ol { padding-inline-start:1.5rem; list-style-position:outside; }
  #|.rui-markdown ul { list-style-type:disc; }
  #|.rui-markdown ol { list-style-type:decimal; }
  #|.rui-markdown li { margin:0.375rem 0; padding:0; }
  #|.rui-markdown li > :where(ul,ol) { margin:0.375rem 0; }
  #|.rui-markdown .rui-markdown-task { list-style-type:none; position:relative; }
  #|.rui-markdown .rui-markdown-task input { position:absolute; inset-inline-start:-1.5rem; top:0.375rem; width:1rem; height:1rem; margin:0; accent-color:var(--rui-primary,oklch(0.205 0 0)); }
  #|.rui-markdown blockquote { border-inline-start:2px solid var(--rui-border,oklch(0.922 0 0)); padding-inline-start:1.5rem; font-style:italic; }
  #|.rui-markdown code { border-radius:calc(var(--rui-radius,0.625rem) - 0.25rem); background:var(--rui-muted,oklch(0.97 0 0)); padding:0.2rem 0.3rem; font-family:ui-monospace,SFMono-Regular,Menlo,Monaco,Consolas,monospace; font-size:0.875em; font-weight:600; }
  #|.rui-markdown pre { max-width:100%; overflow-x:auto; border:1px solid var(--rui-border,oklch(0.922 0 0)); border-radius:var(--rui-radius,0.625rem); background:var(--rui-muted,oklch(0.97 0 0)); padding:1rem; line-height:1.6; white-space:pre; overflow-wrap:normal; tab-size:4; }
  #|.rui-markdown pre code { display:block; width:max-content; min-width:100%; padding:0; background:none; border-radius:0; font-size:0.875rem; font-weight:400; white-space:inherit; }
  #|.rui-markdown img { display:inline-block; max-width:100%; height:auto; vertical-align:middle; }
  #|.rui-markdown hr { border:0; border-top:1px solid var(--rui-border,oklch(0.922 0 0)); }
  #|.rui-markdown .rui-markdown-table { max-width:100%; overflow-x:auto; border:1px solid var(--rui-border,oklch(0.922 0 0)); border-radius:var(--rui-radius,0.625rem); }
  #|.rui-markdown table { width:100%; border-collapse:collapse; font-size:0.875rem; line-height:1.5rem; }
  #|.rui-markdown th, .rui-markdown td { border:0; border-bottom:1px solid var(--rui-border,oklch(0.922 0 0)); padding:0.625rem 0.875rem; text-align:start; white-space:nowrap; }
  #|.rui-markdown th { background:var(--rui-muted,oklch(0.97 0 0)); font-weight:500; }
  #|.rui-markdown tbody tr:last-child td { border-bottom:0; }
  #|.rui-markdown .rui-markdown-footnotes { border-top:1px solid var(--rui-border,oklch(0.922 0 0)); margin-top:2rem; font-size:0.875rem; }
  #|.rui-markdown .rui-markdown-footnotes li { scroll-margin-top:6rem; }
  #|.rui-markdown [role=doc-noteref] { scroll-margin-top:6rem; }
  #|.rui-markdown [role=doc-backlink] { margin-inline-start:0.375rem; }

///|
#warnings("-alert_xss_vulnerable")
fn stylesheet() -> @html.Html {
  // Only this closed CSS constant reaches inner_html, never Markdown input.
  @html.style_tag(
    attrs=@html.Attrs::build()
      .data_set("rui-style", "markdown")
      .inner_html(MarkdownCss),
    @html.nothing,
  )
}
