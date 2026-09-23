# Markdown

Import `moonbit-community/rui/markdown` and call the package's single function:

```mbt check
///|
test {
  let view : @html.Html = @markdown.markdown("# Hello\n\n**Welcome** to RUI.")
  ignore(view)
}
```

`markdown` is synchronous and includes a stylesheet based on shadcn Typography recipes
and RUI Nova theme tokens. No external CSS or initialization is needed. Wrap it in
`@rui.theme(mode=Dark, ...)` to inherit dark tokens, as with other RUI components.

The parser is `moonbit-community/cmark@0.4.8`, with its common syntax extensions
enabled: tables (including column alignment), task lists, strikethrough,
footnotes and math. Headings receive readable IDs, deduplicated within each
document and expose visible, keyboard-accessible anchor links; footnotes include
accessible references and return links.

- Raw inline HTML appears as text; HTML blocks appear in a code block.
- Code fences retain their language class. Code, math and Mermaid remain
  source; syntax highlighting, formula layout and diagram engines are not included.
  Every code block has a floating copy button at the right of its first line. It copies the full
  source, including text outside the current horizontal scroll position.
- Relative links and image paths remain unchanged by default and resolve against
  the host page. Use `transform_link` to rewrite destinations for a repository or
  versioned asset host; no repository URL is inferred.
- Links use `@html.a`'s default routing behavior. Set `escape_link=true` to
  bypass Rabbita's URL request handler and use native browser navigation.
  This applies to inline/reference links, autolinks, heading anchors and footnote
  references/backlinks. HTTP, HTTPS, mailto, tel and relative URLs are allowed;
  other schemes render as text. Raw HTML is never injected.
- Tables and code blocks scroll horizontally within their container. Task
  checkboxes share the RUI Checkbox renderer, display the source state and are disabled.
- Multiple documents on one page should avoid overlapping heading IDs; ID
  deduplication is local to a single function call.

The package is checked for JS, native and Wasm. Native SSR tests validate actual
HTML output, and browser tests validate interaction and layout using the
complete pinned [ripgrep README fixture](__fixtures__/PROVENANCE.md).

```mbt check
///|
test {
  let view = @markdown.markdown("[Guide](./guide.md)", escape_link=true)
  ignore(view)
}
```

## Link and image destinations

Pass `transform_link? : (String) -> String` to rewrite destinations from the
Markdown source. The same callback handles inline links, reference links,
images (including reference images), and autolinks. It receives cmark's parsed
destination; email autolinks include `mailto:`. The callback decides which URLs
to change, including whether to leave absolute URLs and source `#fragment` links
unchanged. Generated heading anchors and footnote references/backlinks remain
local to the document and do not call this callback.

```mbt check
///|
test {
  let view = @markdown.markdown("[Guide](./guide.md) ![Logo](./logo.svg)", transform_link=href => {
    if href is [.. "./", .. relative] {
      "https://assets.example.com/package@1.2.3/" + relative.to_owned()
    } else {
      href
    }
  })
  ignore(view)
}
```

URL safety checks run after rewriting. Disallowed schemes produce text instead
of a link or image. `escape_link` independently controls navigation for the
resulting links; it does not change image loading.

## Custom headings

Pass `render_heading? : (@cmark.BlockHeading) -> @html.Html` to take over the
entire heading. `@cmark` refers to `moonbit-community/cmark/cmark`;
`BlockHeading` exposes the source `level`, `inline` AST, `id` and `layout`.
All heading levels, including headings nested in quotes, lists or footnotes,
use this callback.

The callback owns inline rendering, tags, styles, IDs and anchor links.
Markdown does not wrap the result or render the default anchor. Its
`transform_link` and `escape_link` options do not apply to HTML created by the
callback. Omit the callback to retain the standard heading rendering.

This example deliberately renders a compact plain-text heading; a host can
instead render `heading.inline` with its own inline renderer to keep formatting:

```mbt check
///|
test {
  let view = @markdown.markdown("# A compact **heading**", render_heading=heading => {
    let text = heading.inline
      .to_plain_text(break_on_soft=false)
      .map(parts => parts.to_array().join(""))
      .to_array()
      .join("\n")
    @html.h3(
      id=heading.inline.id(),
      style=["font-size:14px", "line-height:1.5", "margin:0"],
      text,
    )
  })
  ignore(view)
}
```

## Custom code blocks

Pass `render_codeblock` to render fenced and indented code blocks, including
those inside lists or footnotes. The callback receives `(source, info)`:
the code without fence markers, followed by the complete fence info string,
such as `moonbit check title="example"`. It is not reduced to a language name;
cmark removes surrounding whitespace and resolves escapes and character references.
Unlabelled fences and indented code blocks pass `""` as their info string.
The callback returns the complete code block content,
usually a `<pre><code>…</code></pre>` tree. The surrounding frame and copy button
remain owned by Markdown; copying always uses the original source. The default
renderer still preserves the fence language as a `language-*` class when no
callback is provided. Inline code, escaped HTML blocks and math source do not
use this callback.

```mbt check
///|
test {
  let view = @markdown.markdown("```moonbit check\nlet answer = 42\n```", render_codeblock=(
    source,
    info,
  ) => {
    @html.pre(
      @html.code(attrs=@html.Attrs::build().data_set("info", info), source),
    )
  })
  ignore(view)
}
```

## Typography reference

Checked against shadcn's [Base Typography examples](https://github.com/shadcn-ui/ui/tree/main/apps/v4/examples/base)
on 2026-09-23: H1–H4 sizes, paragraph line height, 24px block spacing and list
indentation, 8px list-item spacing, inline code and bordered tables. The
standalone H1 example is centered; Markdown uses start alignment, as does the
upstream full Typography example.

There is no separate Typography item in the Nova component registry. The
current [Typography documentation redirects to Typeset](https://ui.shadcn.com/docs/typeset),
a different configurable prose system. This renderer does not claim to
implement Typeset. H5/H6, compact nested-list spacing, task markers, heading
anchors, code frames, copy controls and footnotes are RUI extensions. Nova
colors, disabled states and radii follow the surrounding RUI theme.

## Known cmark 0.4.8 task-list limitation

Under an unordered task such as `- [x] parent`, cmark currently counts `[x] `
as part of the required continuation indentation. Children indented with two
or four spaces can become sibling items or literal paragraph text. Use six spaces for that task's
children and continuation blocks until cmark fixes this behavior. Ordinary
nested bullets use the usual two-space indentation. This is a parser limitation,
not a difference in visual list padding; this package does not rewrite input
to work around it. The unmodified async 0.22.2 README demonstrates this: 20 of
26 task markers render as checkboxes, while six nested markers remain text.
