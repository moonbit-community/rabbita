///|
fn render_inline(state : RenderState, inline : @cmark.Inline) -> @html.Html {
  match inline {
    Text({ v, .. }) => @html.text(v)
    Inlines({ v, .. }) =>
      @html.fragment(v.map(item => render_inline(state, item)).to_array())
    Emphasis({ v, .. }) => @html.em(render_inline(state, v.inline))
    StrongEmphasis({ v, .. }) => @html.strong(render_inline(state, v.inline))
    CodeSpan({ v, .. }) => @html.code(v.code())
    Link({ v, .. }) => render_link(state, v, image=false)
    Image({ v, .. }) => render_link(state, v, image=true)
    Break({ v: { ty: Hard, .. }, .. }) => @html.br()
    Break({ v: { ty: Soft, .. }, .. }) => @html.text("\n")
    Autolink({ v, .. }) => {
      let href = if v.is_email { "mailto:" + v.link.v } else { v.link.v }
      if allowed_url(href) {
        @html.a(href~, escape=true, v.link.v)
      } else {
        @html.text(v.link.v)
      }
    }
    RawHtml({ v, .. }) => @html.text(tight_text(v.0))
    ExtStrikethrough({ v, .. }) => @html.del(render_inline(state, v.0))
    ExtMathSpan({ v, .. }) => {
      let delimiter = if v.display { "$$" } else { "$" }
      @html.code(class="language-math", delimiter + v.tex() + delimiter)
    }
  }
}

///|
fn render_link(
  state : RenderState,
  link : @cmark.InlineLink,
  image~ : Bool,
) -> @html.Html {
  if link.reference_definition(state.defs) is Some(definition) {
    match definition {
      FootnoteDef({ v, .. }) =>
        if image {
          @html.text(plain_text(link.text))
        } else {
          render_footnote_reference(state, link, v)
        }
      LinkDef({ v, .. }) => {
        let destination = v.dest.map(node => node.v).unwrap_or("")
        let title = v.title.map(tight_text)
        if !allowed_url(destination) {
          @html.text(plain_text(link.text))
        } else if image {
          @html.img(
            src=destination,
            alt=plain_text(link.text),
            title?,
            loading="lazy",
          )
        } else {
          @html.a(
            href=destination,
            title?,
            escape=true,
            render_inline(state, link.text),
          )
        }
      }
    }
  } else {
    render_inline(state, link.text)
  }
}
