///|
fn render_block(
  state : RenderState,
  block : @cmark.Block,
  tight? : Bool = false,
) -> @html.Html {
  match block {
    Blocks({ v, .. }) =>
      @html.fragment(
        v.map(item => render_block(state, item, tight~)).to_array(),
      )
    Paragraph({ v, .. }) => {
      let content = render_inline(state, v.inline)
      if tight {
        content
      } else {
        @html.p(content)
      }
    }
    Heading({ v, .. }) => {
      if state.render_heading is Some(render) {
        return render(v)
      }
      let id = unique_id(state, v.inline.id())
      let content = @html.fragment([
        render_inline(state, v.inline),
        @html.a(
          class="rui-markdown-anchor",
          href="#" + id,
          title="Link to " + plain_text(v.inline),
          attrs=@html.Attrs::build().aria_label(
            "Link to " + plain_text(v.inline),
          ),
          escape=state.escape_link,
          @html.span(
            attrs=@html.Attrs::build().aria_hidden("true"),
            @svg.svg(width=16, height=16, view_box="0 0 24 24", [
              @svg.path(
                d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71",
                fill="none",
                stroke="currentColor",
                stroke_width=2,
                attrs=@svg.Attrs::build()
                  .stroke_linecap("round")
                  .stroke_linejoin("round"),
              ),
            ]),
          ),
        ),
      ])
      match v.level {
        1 => @html.h1(id~, content)
        2 => @html.h2(id~, content)
        3 => @html.h3(id~, content)
        4 => @html.h4(id~, content)
        5 => @html.h5(id~, content)
        _ => @html.h6(id~, content)
      }
    }
    BlockQuote({ v, .. }) => @html.blockquote(render_block(state, v.block))
    CodeBlock({ v, .. }) => {
      let info = v.info_string.map(node => node.v).unwrap_or("")
      code_block(lines_text(v.code), info~, render?=state.render_codeblock)
    }
    HtmlBlock({ v, .. }) => code_block(lines_text(v.0), info="html")
    ExtMathBlock({ v, .. }) =>
      code_block("$$\n" + lines_text(v.code) + "\n$$", info="math")
    ThematicBreak(_) => @html.hr()
    List({ v, .. }) => render_list(state, v)
    ExtTable({ v, .. }) => render_table(state, v)
    BlankLine(_) | LinkRefDefinition(_) | ExtFootnoteDefinition(_) =>
      @html.nothing
  }
}

///|
fn code_block(
  source : String,
  info~ : String,
  render? : (String, String) -> @html.Html,
) -> @html.Html {
  @html.div(class="rui-markdown-code", [
    @html.button(
      class="rui-markdown-copy",
      type_="button",
      title="Copy code",
      attrs=@html.Attrs::build().aria_label("Copy code"),
      on_click=@clipboard.copy(Text(source)),
      @html.span(
        style=["display:flex"],
        attrs=@html.Attrs::build().aria_hidden("true"),
        @svg.svg(width=16, height=16, view_box="0 0 24 24", [
          @svg.path(
            d="M8 8h12a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H10a2 2 0 0 1-2-2ZM4 16a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2",
            fill="none",
            stroke="currentColor",
            stroke_width=2,
            attrs=@svg.Attrs::build()
              .stroke_linecap("round")
              .stroke_linejoin("round"),
          ),
        ]),
      ),
    ),
    @html.div(
      class="rui-markdown-code-content",
      if render is Some(render) {
        render(source, info)
      } else {
        let language = @cmark.CodeBlock::language_of_info_string(info).map(pair => {
          pair.0
        })
        @html.pre(
          attrs=@html.Attrs::build().tabindex(0).aria_label("Code block"),
          @html.code(class?=language.map(name => "language-" + name), source),
        )
      },
    ),
  ])
}

///|
fn render_list(state : RenderState, list : @cmark.BlockList) -> @html.Html {
  let items = list.items
    .map(node => {
      let item = node.v
      let content = render_block(state, item.block, tight=list.tight)
      if item.ext_task_marker is Some(marker) {
        @html.li(class="rui-markdown-task", [
          @checkbox_view.render(
            checked=marker.v == 'x' || marker.v == 'X',
            disabled=true,
            aria_label="Task status",
          ),
          content,
        ])
      } else {
        @html.li(content)
      }
    })
    .to_array()
  match list.ty {
    Unordered(_) => @html.ul(items)
    Ordered(start, _) => @html.ol(start~, items)
  }
}

///|
fn render_table(state : RenderState, table : @cmark.Table) -> @html.Html {
  let alignments : Array[String] = []
  for row in table.rows.iter() {
    if row.0.v is Sep(columns) {
      for column in columns.iter() {
        let alignment = column.v.0.0
        alignments.push(
          if alignment is Some(Center) {
            "text-align:center"
          } else if alignment is Some(Right) {
            "text-align:right"
          } else {
            "text-align:left"
          },
        )
      }
    }
  }
  let headers : Array[@html.Html] = []
  let rows : Array[@html.Html] = []
  for row in table.rows.iter() {
    match row.0.v {
      Header(cells) | Data(cells) => {
        let header = row.0.v is Header(_)
        let children : Array[@html.Html] = []
        for index in 0..<table.col_count {
          let content = if cells.get(index) is Some(cell) {
            render_inline(state, cell.0)
          } else {
            @html.nothing
          }
          let style = [alignments.get(index).unwrap_or("text-align:left")]
          children.push(
            if header {
              @html.th(style~, scope=Col, content)
            } else {
              @html.td(style~, content)
            },
          )
        }
        if header {
          headers.push(@html.tr(children))
        } else {
          rows.push(@html.tr(children))
        }
      }
      Sep(_) => ()
    }
  }
  @html.div(
    class="rui-markdown-table",
    attrs=@html.Attrs::build()
      .tabindex(0)
      .role("region")
      .aria_label("Markdown table"),
    @html.table([@html.thead(headers), @html.tbody(rows)]),
  )
}
