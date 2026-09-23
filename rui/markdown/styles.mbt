///|
const MarkdownCss : String =
  #|.rui-markdown { --rui-markdown-leading:1.75; --rui-markdown-flow:1.25em; box-sizing:border-box; width:100%; min-width:0; color:var(--rui-foreground,oklch(0.145 0 0)); font-family:var(--rui-font-sans,Inter,ui-sans-serif,system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif); font-size:calc(var(--rui-markdown-size,1rem) * 1.125); line-height:var(--rui-markdown-leading); overflow-wrap:break-word; text-align:start; }
  #|@media (min-width:48rem), print { .rui-markdown { font-size:var(--rui-markdown-size,1rem); } }
  #|.rui-markdown *, .rui-markdown *::before, .rui-markdown *::after { box-sizing:border-box; }
  #|.rui-markdown :where(p,ul,ol,blockquote,.rui-markdown-code,.rui-markdown-table) { margin:var(--rui-markdown-flow) 0 0; }
  #|.rui-markdown :where(h1,h2,h3,h4,h5,h6) { margin:var(--rui-markdown-flow) 0 0; scroll-margin-top:5rem; color:inherit; text-align:start; font-weight:600; }
  #|.rui-markdown h1 { font-size:1.75em; line-height:1.3; }
  #|.rui-markdown h2 { margin-top:calc(var(--rui-markdown-flow) * 1.4); font-size:1.25em; line-height:1.4; }
  #|.rui-markdown h3 { font-size:1.125em; line-height:1.45; }
  #|.rui-markdown h4 { font-size:1em; line-height:1.5; }
  #|.rui-markdown h5 { margin-top:calc(var(--rui-markdown-flow) / 0.875); font-size:0.875em; line-height:1.5; font-weight:500; color:var(--rui-muted-foreground,oklch(0.556 0 0)); }
  #|.rui-markdown h6 { margin-top:calc(var(--rui-markdown-flow) / 0.8125); font-size:0.8125em; line-height:1.5; font-weight:500; letter-spacing:0.08em; text-transform:uppercase; color:var(--rui-muted-foreground,oklch(0.556 0 0)); }
  #|.rui-markdown > :last-child, .rui-markdown blockquote > :last-child, .rui-markdown li > p:last-child { margin-bottom:0; }
  #|.rui-markdown p { line-height:inherit; }
  #|.rui-markdown a { color:inherit; font-weight:500; text-decoration:underline; text-decoration-color:color-mix(in oklab,currentColor 30%,transparent); }
  #|.rui-markdown a:hover { text-decoration-color:currentColor; }
  #|.rui-markdown .rui-markdown-anchor { display:inline-flex; align-items:center; justify-content:center; width:1.5rem; height:1.5rem; margin-inline-start:0.25rem; vertical-align:baseline; color:var(--rui-muted-foreground,oklch(0.556 0 0)); text-decoration:none; }
  #|.rui-markdown .rui-markdown-anchor span { display:flex; }
  #|.rui-markdown .rui-markdown-anchor:hover { color:var(--rui-primary,oklch(0.205 0 0)); }
  #|.rui-markdown :focus-visible { outline:2px solid var(--rui-ring,oklch(0.708 0 0)); outline-offset:3px; border-radius:0.125rem; }
  #|.rui-markdown strong { font-weight:600; }
  #|.rui-markdown ul, .rui-markdown ol { padding-inline-start:1.5em; list-style-position:outside; }
  #|.rui-markdown ul { list-style-type:disc; }
  #|.rui-markdown ul ul { list-style-type:circle; }
  #|.rui-markdown ul ul ul { list-style-type:square; }
  #|.rui-markdown ol { list-style-type:decimal; }
  #|.rui-markdown li { margin:0.5em 0 0; padding-inline-start:0.4em; }
  #|.rui-markdown li::marker { color:var(--rui-muted-foreground,oklch(0.556 0 0)); }
  #|.rui-markdown li > :where(p,ul,ol,blockquote,.rui-markdown-code,.rui-markdown-table) { margin:0.5em 0 0; }
  #|.rui-markdown .rui-markdown-task { list-style-type:none; position:relative; }
  #|.rui-markdown .rui-markdown-task > [data-slot="checkbox"] { position:absolute; inset-inline-start:-1.1em; top:calc((1lh - 1rem) / 2); font-size:inherit; line-height:inherit; width:1rem; height:1rem; margin:0; }
  #|.rui-markdown blockquote { border-inline-start:2px solid var(--rui-border,oklch(0.922 0 0)); padding-inline-start:1em; }
  #|.rui-markdown code { border-radius:min(calc(var(--rui-radius,0.625rem) * 0.6),0.35em); background:var(--rui-muted,oklch(0.97 0 0)); padding:0.125em 0.3em; font-family:ui-monospace,SFMono-Regular,Menlo,Monaco,Consolas,monospace; font-size:0.85em; font-weight:inherit; }
  #|.rui-markdown .rui-markdown-code { position:relative; display:block; max-width:100%; border:1px solid var(--rui-border,oklch(0.922 0 0)); border-radius:var(--rui-radius,0.625rem); background:var(--rui-muted,oklch(0.97 0 0)); }
  #|.rui-markdown .rui-markdown-code-content { min-width:0; overflow-x:auto; }
  #|.rui-markdown pre { min-width:0; max-width:100%; margin:0; overflow-x:auto; border:0; border-radius:inherit; background:none; padding:1rem; font-size:0.875em; line-height:1.5; white-space:pre; overflow-wrap:normal; tab-size:2; direction:ltr; }
  #|.rui-markdown pre code { display:block; width:max-content; min-width:100%; padding:0; background:none; border-radius:0; font-size:inherit; line-height:inherit; font-weight:400; white-space:inherit; }
  #|.rui-markdown .rui-markdown-copy { position:absolute; z-index:1; top:0; inset-inline-end:0; display:inline-flex; align-items:flex-start; justify-content:center; width:2.75rem; height:2.75rem; margin:0; padding:0.25rem 0 0; border:0; border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem); background:transparent; color:var(--rui-muted-foreground,oklch(0.556 0 0)); cursor:pointer; }
  #|.rui-markdown .rui-markdown-copy > span { display:flex; align-items:center; justify-content:center; width:2rem; height:2rem; border:1px solid transparent; border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem); background:var(--rui-muted,oklch(0.97 0 0)); }
  #|.rui-markdown .rui-markdown-copy:hover > span { border-color:var(--rui-border,oklch(0.922 0 0)); background:var(--rui-background,oklch(1 0 0)); color:inherit; }
  #|.rui-markdown .rui-markdown-copy:active > span { background:var(--rui-accent,oklch(0.97 0 0)); }
  #|.rui-markdown img { display:inline-block; max-width:100%; height:auto; vertical-align:middle; }
  #|.rui-markdown hr { margin:calc(var(--rui-markdown-flow) * 2.4) 0 0; border:0; border-top:1px solid var(--rui-border,oklch(0.922 0 0)); }
  #|.rui-markdown .rui-markdown-table { max-width:100%; overflow-x:auto; }
  #|.rui-markdown table { width:max-content; min-width:100%; border-collapse:separate; border-spacing:0; border-bottom:1px solid var(--rui-border,oklch(0.922 0 0)); font-size:1em; line-height:1.5; font-variant-numeric:tabular-nums; }
  #|.rui-markdown th, .rui-markdown td { padding:0.75em 1em; text-align:start; vertical-align:top; overflow-wrap:normal; }
  #|.rui-markdown tbody :where(th,td) { border-top:1px solid var(--rui-border,oklch(0.922 0 0)); }
  #|.rui-markdown th:first-child, .rui-markdown td:first-child { padding-inline-start:0; }
  #|.rui-markdown th { font-weight:500; }
  #|.rui-markdown thead th { padding-block:0.65em; white-space:nowrap; }
  #|.rui-markdown .rui-markdown-footnotes { border-top:1px solid var(--rui-border,oklch(0.922 0 0)); margin-top:calc(var(--rui-markdown-flow) * 2); padding-top:var(--rui-markdown-flow); font-size:0.875em; color:var(--rui-muted-foreground,oklch(0.556 0 0)); }
  #|.rui-markdown .rui-markdown-footnotes li { scroll-margin-top:6rem; }
  #|.rui-markdown [role=doc-noteref] { scroll-margin-top:6rem; }
  #|.rui-markdown [role=doc-backlink] { margin-inline-start:0.375rem; }
  #|.rui-markdown :where(h1,h2,h3,h4) code { font-size:0.9em; }
  #|.rui-markdown :where(h1,h2,h3,h4,h5,h6) a { font-weight:inherit; }
  #|.rui-markdown :where(h1,h2,h3,h4,h5,h6) + * { margin-top:1em; }
  #|.rui-markdown > :first-child, .rui-markdown :where(li,blockquote,td,th) > :first-child, .rui-markdown-task > [data-slot="checkbox"] + p { margin-top:0; }

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
