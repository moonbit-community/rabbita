///|
priv struct RenderState {
  render_codeblock : ((String, String) -> @html.Html)?
  render_heading : ((@cmark.BlockHeading) -> @html.Html)?
  render_html_block : ((String) -> @html.Html)?
  render_inline : ((
    @cmark.Inline,
    Map[String, @cmark.LabelDef],
    (@cmark.Inline) -> @html.Html,
  ) -> @html.Html)?
  heading_anchors : Bool
  escape_link : Bool
  transform_link : ((String) -> String)?
  defs : Map[String, @cmark.LabelDef]
  ids : Map[String, Bool]
  footnotes : Array[FootnoteUse]
  footnote_indices : Map[String, Int]
}

///|
priv struct FootnoteUse {
  id : String
  block : @cmark.Block
  references : Array[String]
}

///|
/// Render Markdown with shadcn Typeset typography and Nova theme tokens.
///
/// Parses CommonMark and cmark's table, task-list, strikethrough, footnote and
/// math extensions. Raw HTML is displayed as text. Code and math remain source;
/// no asynchronous highlighter or diagram engine is required. Relative URLs
/// are preserved by default; only relative URLs and http, https, mailto and tel schemes
/// are navigable. Wrap the result in `@rui.theme` to inherit dark theme tokens.
/// `render_codeblock` replaces fenced/indented code content with caller-rendered
/// HTML (usually `pre`/`code`); the frame still copies the original source.
/// Its arguments are the source and the complete cmark-parsed fence info string
/// (for example, `moonbit check`). Indented or unlabelled blocks pass empty info.
/// Links use Rabbita's routing by default. Set `escape_link=true` to use native
/// browser navigation for all links, including heading anchors and footnotes.
/// `transform_link` rewrites source link and image destinations before URL safety
/// checks. Generated heading anchors and footnote references are not rewritten.
/// Set `heading_anchors=false` to omit generated heading links while retaining
/// heading IDs, inline formatting and typography. Defaults to `true`.
/// `render_heading` receives the cmark heading and replaces the entire heading.
/// The callback owns inline rendering, styles, IDs and anchor links;
/// `heading_anchors` does not affect its output.
/// `parser_options` is forwarded to cmark's `Doc::from_string`. `strict=false`
/// enables cmark's bundled extensions; `strict=true` selects CommonMark only.
/// `heading_auto_ids=false` omits default heading IDs and anchor links.
/// `layout`, `locs` and `file` preserve source metadata for renderer callbacks.
/// `defs` supplies initial label definitions and is mutated by cmark during
/// parsing; leave it as `None` for a fresh map on each call. `resolver` controls label
/// resolution. `nested_links` defaults to `false`, as in cmark.
/// `render_html_block` replaces escaped HTML blocks with caller-rendered HTML.
/// `render_inline` receives a complete inline tree, label definitions and a
/// default-rendering function. It handles paragraph, heading and table-cell
/// content, including inside lists, quotes and footnotes. The default renderer
/// can be called on any subtree without re-entering the callback.
///
/// # Vulnerability Warning
///
/// HTML callbacks can inject raw HTML and cause XSS. The application author
/// must ensure content is trusted, sanitized or isolated. Injected HTML is not
/// subject to Markdown URL checks, link transforms or Rabbita routing. Custom
/// inline rendering owns links and footnote references unless it delegates to
/// the supplied default renderer. Custom headings own their inline rendering.
pub fn markdown(
  source : String,
  render_codeblock? : (String, String) -> @html.Html,
  escape_link? : Bool = false,
  transform_link? : (String) -> String,
  render_heading? : (@cmark.BlockHeading) -> @html.Html,
  heading_anchors? : Bool = true,
  parser_options? : ParserOptions = ParserOptions::default(),
  render_html_block? : (String) -> @html.Html,
  render_inline? : (
    @cmark.Inline,
    Map[String, @cmark.LabelDef],
    (@cmark.Inline) -> @html.Html,
  ) -> @html.Html,
) -> @html.Html {
  let doc = @cmark.Doc::from_string(
    source,
    strict=parser_options.strict,
    heading_auto_ids=parser_options.heading_auto_ids,
    nested_links=parser_options.nested_links,
    layout=parser_options.layout,
    locs=parser_options.locs,
    file?=parser_options.file,
    defs?=parser_options.defs,
    resolver?=parser_options.resolver,
  )
  let state : RenderState = {
    render_codeblock,
    render_heading,
    render_html_block,
    render_inline,
    heading_anchors,
    escape_link,
    transform_link,
    defs: doc.defs,
    ids: {},
    footnotes: [],
    footnote_indices: {},
  }
  let body = render_block(state, doc.block)
  let notes = render_footnotes(state)
  @html.fragment([
    stylesheet(),
    @html.div(
      class="rui-markdown",
      attrs=@html.Attrs::build().data_set("slot", "markdown"),
      [body, notes],
    ),
  ])
}

///|
fn unique_id(state : RenderState, value : String) -> String {
  let base = if value.is_empty() { "section" } else { value }
  let mut candidate = base
  let mut suffix = 0
  while state.ids.contains(candidate) {
    suffix += 1
    candidate = "\{base}-\{suffix}"
  }
  state.ids[candidate] = true
  candidate
}

///|
fn plain_text(inline : @cmark.Inline) -> String {
  inline
  .to_plain_text(break_on_soft=false)
  .map(parts => parts.to_array().join(""))
  .to_array()
  .join("\n")
}

///|
fn tight_text(parts : @cmark.Seq[@cmark.Tight]) -> String {
  parts.map(part => part.to_string()).to_array().join("\n")
}

///|
fn lines_text(lines : @cmark.Seq[@cmark.Node[String]]) -> String {
  lines.map(line => line.v).to_array().join("\n")
}

///|
fn allowed_url(value : String) -> Bool {
  // Browsers ignore ASCII controls in schemes. Validate the normalized scheme,
  // but retain the original URL when rendering allowed destinations.
  let scheme = StringBuilder()
  for character in value {
    match character {
      '\u0000'..='\u0020' | '\u007f' => continue
      ':' => {
        let name = scheme.to_string()
        return name == "https" ||
          name == "http" ||
          name == "mailto" ||
          name == "tel"
      }
      '/' | '\\' | '?' | '#' => return true
      _ => scheme.write_char(character.to_ascii_lowercase())
    }
  }
  true
}
