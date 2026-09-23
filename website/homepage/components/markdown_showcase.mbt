///|
const MarkdownSyntaxSource : String =
  #|# A small field guide
  #|
  #|Readable documents, with **strong emphasis**, *a quiet aside*, ~~a revision~~
  #|and `inline_code`. Visit [the checklist](#release-checklist), read a note[^nova],
  #|or follow a [relative link](./guide.md).
  #|
  #|> Good documentation makes the next step clear.
  #|>
  #|> It also gives long content room to breathe.
  #|
  #|## Release checklist
  #|
  #|- [x] Render semantic HTML
  #|- [x] Check light and dark themes
  #|- [ ] Publish the next release
  #|
  #|3. Review the package.
  #|4. Check the examples.
  #|   - Nested lists retain their indentation.
  #|   - A repeated note returns to this exact reference.[^nova]
  #|
  #|### Comparison
  #|
  #|| Feature | Status | Count |
  #|| :--- | :---: | ---: |
  #|| Semantic content | Ready | 12 |
  #|| Keyboard navigation | Ready | 4 |
  #|| Tables with a deliberately long cell | Scroll horizontally on narrow screens | 128 |
  #|
  #|### Code and formulas
  #|
  #|```moonbit
  #|let view = @markdown.markdown("# Hello from RUI")
  #|let long_line = "Long code stays on one line and scrolls inside this block without widening the document."
  #|```
  #|
  #|Math stays as source: $E = mc^2$.
  #|
  #|$$
  #|a^2 + b^2 = c^2
  #|$$
  #|
  #|```mermaid
  #|graph LR; Markdown-->Html
  #|```
  #|
  #|#### HTML source
  #|
  #|Inline <kbd>Enter</kbd> remains visible source. HTML blocks are also text:
  #|
  #|<details>
  #|<summary>Example</summary>
  #|This content is displayed, not executed.
  #|</details>
  #|
  #|---
  #|
  #|[^nova]: Nova typography follows the surrounding RUI theme.

///|
const MarkdownUsageCode : String =
  #|// moon.pkg: import { "moonbit-community/rui/markdown" }
  #|@markdown.markdown(source)

///|
fn markdown_demo() -> @html.Html {
  showcase_component_demos(
    "Markdown",
    "Synchronous Markdown rendering with cmark 0.4.8 and Nova typography. HTML, code, math and diagrams remain source where no renderer is provided.",
    [
      showcase_demo_section(
        "Markdown syntax",
        "Tables, tasks, nested lists and footnotes. Links can move within this example; navigation away from it is disabled.",
        showcase_demo_stage(
          @markdown.markdown(MarkdownSyntaxSource),
          MarkdownUsageCode,
          variant=ShowcaseStagePlain,
        ),
      ),
      showcase_demo_section(
        "Real README",
        "The complete 541-line ripgrep README, pinned to commit 3fce3b5. Original text, images and relative paths are preserved. Copyright 2015 Andrew Gallant; MIT license.",
        showcase_demo_stage(
          @markdown.markdown(markdown_readme),
          MarkdownUsageCode,
          variant=ShowcaseStagePlain,
        ),
      ),
    ],
  )
}
