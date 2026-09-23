///|
fn render_footnote_reference(
  state : RenderState,
  link : @cmark.InlineLink,
  note : @cmark.Footnote,
) -> @html.Html {
  let key = note.label.key
  let index = if state.footnote_indices.get(key) is Some(index) {
    index
  } else {
    let index = state.footnotes.length()
    state.footnote_indices[key] = index
    state.footnotes.push({
      id: unique_id(state, "rui-fn-\{index + 1}"),
      block: note.block,
      references: [],
    })
    index
  }
  let footnote = state.footnotes[index]
  let reference_id = unique_id(state, "rui-fnref-\{index + 1}")
  footnote.references.push(reference_id)
  let full_reference = link.reference is Ref(Full, _, _)
  let anchor = @html.a(
    href="#" + footnote.id,
    id=reference_id,
    escape=state.escape_link,
    attrs=@html.Attrs::build()
      .role("doc-noteref")
      .aria_label("Footnote \{index + 1}"),
    if full_reference {
      render_inline(state, link.text)
    } else {
      @html.text("\{index + 1}")
    },
  )
  if full_reference {
    anchor
  } else {
    @html.sup(anchor)
  }
}

///|
fn render_footnotes(state : RenderState) -> @html.Html {
  let bodies : Array[@html.Html] = []
  // Rendering a definition can discover another reference. Each definition is
  // queued once, so forward references and cycles cannot loop indefinitely.
  let mut index = 0
  while index < state.footnotes.length() {
    bodies.push(render_block(state, state.footnotes[index].block))
    index += 1
  }
  if bodies.is_empty() {
    return @html.nothing
  }
  @html.section(
    class="rui-markdown-footnotes",
    attrs=@html.Attrs::build().role("doc-endnotes").aria_label("Footnotes"),
    @html.ol(
      [
        for index, body in bodies => {
          let note = state.footnotes[index]
          @html.li(id=note.id, [
            body,
            @html.span(
              [
                for ref_index, reference in note.references => {
                  @html.a(
                    href="#" + reference,
                    escape=state.escape_link,
                    attrs=@html.Attrs::build()
                      .role("doc-backlink")
                      .aria_label(
                        "Back to reference \{index + 1}.\{ref_index + 1}",
                      ),
                    "↩",
                  )
                }
              ],
            ),
          ])
        }
      ],
    ),
  )
}
