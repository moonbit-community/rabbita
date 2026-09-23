# Markdown

Import `moonbit-community/rui/markdown` and call the package's single function:

```mbt check
///|
test {
  let view : @html.Html = @markdown.markdown("# Hello\n\n**Welcome** to RUI.")
  ignore(view)
}
```

`markdown(String) -> @html.Html` is synchronous and includes its own Nova
typography stylesheet. No external CSS or initialization is needed. Wrap it in
`@rui.theme(mode=Dark, ...)` to inherit dark tokens, as with other RUI components.

The parser is `moonbit-community/cmark@0.4.8`, with its common syntax extensions
enabled: tables (including column alignment), task lists, strikethrough,
footnotes and math. Headings receive readable IDs, deduplicated within each
document; footnotes include accessible references and return links.

- Raw inline HTML appears as text; HTML blocks appear in a code block.
- Code fences retain their language class. Code, math and Mermaid remain
  source; syntax highlighting, formula layout and diagram engines are not included.
- Relative links and image paths remain unchanged and resolve against the host
  page. The function does not infer a repository URL or rewrite assets.
- Links use normal browser navigation. HTTP, HTTPS, mailto, tel and relative
  URLs are allowed; other schemes render as text. Raw HTML is never injected.
- Tables and code blocks scroll horizontally within their container. Task
  checkboxes display the source state and are disabled.
- Multiple documents on one page should avoid overlapping heading IDs; ID
  deduplication is local to a single function call.

The package is checked for JS, native and Wasm. Native SSR tests validate actual
HTML output, and browser tests validate interaction and layout using the
complete pinned [ripgrep README fixture](__fixtures__/PROVENANCE.md).
