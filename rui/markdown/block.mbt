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
      let id = unique_id(state, v.inline.id())
      let content = render_inline(state, v.inline)
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
      let language = if v.info_string is Some(info) {
        @cmark.CodeBlock::language_of_info_string(info.v).map(pair => pair.0)
      } else {
        None
      }
      code_block(lines_text(v.code), language?)
    }
    HtmlBlock({ v, .. }) => code_block(lines_text(v.0), language="html")
    ExtMathBlock({ v, .. }) =>
      code_block("$$\n" + lines_text(v.code) + "\n$$", language="math")
    ThematicBreak(_) => @html.hr()
    List({ v, .. }) => render_list(state, v)
    ExtTable({ v, .. }) => render_table(state, v)
    BlankLine(_) | LinkRefDefinition(_) | ExtFootnoteDefinition(_) =>
      @html.nothing
  }
}

///|
fn code_block(source : String, language? : String) -> @html.Html {
  @html.pre(
    attrs=@html.Attrs::build().tabindex(0).aria_label("Code block"),
    @html.code(class?=language.map(name => "language-" + name), source),
  )
}

///|
fn render_list(state : RenderState, list : @cmark.BlockList) -> @html.Html {
  let items = list.items
    .map(node => {
      let item = node.v
      let content = render_block(state, item.block, tight=list.tight)
      if item.ext_task_marker is Some(marker) {
        @html.li(class="rui-markdown-task", [
          @html.input(
            input_type=Checkbox,
            checked=marker.v == 'x' || marker.v == 'X',
            attrs=@html.Attrs::build().disabled(true).aria_label("Task status"),
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
