///|
priv struct RenderState {
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
/// Render Markdown with self-contained Nova typography.
///
/// Parses CommonMark and cmark's table, task-list, strikethrough, footnote and
/// math extensions. Raw HTML is displayed as text. Code and math remain source;
/// no asynchronous highlighter or diagram engine is required. Relative URLs
/// are preserved; only relative URLs and http, https, mailto and tel schemes
/// are navigable. Wrap the result in `@rui.theme` to inherit dark theme tokens.
pub fn markdown(source : String) -> @html.Html {
  let doc = @cmark.Doc::from_string(source, strict=false, heading_auto_ids=true)
  let state : RenderState = {
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
