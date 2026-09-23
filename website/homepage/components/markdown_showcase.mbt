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
const MarkdownListsSource : String =
  #|## Nested lists
  #|
  #|- First level: a long bullet wraps onto multiple lines while its continuation stays aligned with the text, not the marker.
  #|  - Second level: each nested list adds the same indentation.
  #|    - Third level: markers stay visible on narrow screens, and this deliberately long sentence checks wrapped-line alignment.
  #|    - Another third-level bullet.
  #|  - Back to the second level.
  #|- Back to the first level.
  #|
  #|10. Ordered parent with a two-digit marker.
  #|    - Unordered child.
  #|      1. Ordered grandchild.
  #|      2. Another ordered grandchild.
  #|11. Next ordered parent.
  #|
  #|- [x] Completed parent task
  #|      - [ ] Nested pending task whose description wraps over several lines on a narrow screen.
  #|      - A regular bullet beside task items.
  #|- [ ] Another parent task
  #|
  #|- A loose item with multiple blocks.
  #|
  #|  Its second paragraph aligns with the first paragraph.
  #|
  #|  > A nested quote retains the list indentation.
  #|
  #|  ```sh
  #|  printf '%s\n' "A deliberately long command inside a list scrolls without pushing the bullet or the copy button out of the viewport."
  #|  ```
  #|
  #|  - A child after the code block.
  #|
  #|- The next loose item.

///|
fn markdown_highlight_example(source : String, info : String) -> @html.Html {
  let moonbit = info == "moonbit" ||
    info.has_prefix("moonbit ") ||
    info == "mbt" ||
    info.has_prefix("mbt ")
  @html.pre(
    @html.code(
      attrs=@html.Attrs::build().data_set("info", info),
      if moonbit && source is [.. "let ", .. rest] {
        @html.fragment([
          @html.span(style=["color:var(--rui-primary);font-weight:700"], "let"),
          @html.text(" " + rest.to_owned()),
        ])
      } else {
        @html.text(source)
      },
    ),
  )
}

///|
const MarkdownUsageCode : String =
  #|// moon.pkg: import { "moonbit-community/rui/markdown" }
  #|@markdown.markdown(source)

///|
fn markdown_demo() -> @html.Html {
  showcase_component_demos(
    "Markdown",
    "Synchronous Markdown rendering with cmark 0.4.8, shadcn Typeset typography and Nova theme tokens. HTML, code, math and diagrams remain source where no renderer is provided.",
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
      showcase_demo_section(
        "List indentation",
        "Three levels of bullets, mixed numbering and loose items. cmark 0.4.8 requires six spaces for children of an unordered task; two or four spaces currently flatten them.",
        showcase_demo_stage(
          @markdown.markdown(MarkdownListsSource),
          MarkdownUsageCode,
          variant=ShowcaseStagePlain,
        ),
      ),
      showcase_demo_section(
        "Custom renderers",
        "A heading callback controls the whole heading. The code callback receives source and complete fence info, such as moonbit check; copying still uses the original source.",
        showcase_demo_stage(
          @markdown.markdown(
            "# A compact heading\n\n```moonbit check\nlet greeting = \"Hello from a custom renderer\"\n```",
            render_codeblock=markdown_highlight_example,
            render_heading=heading => {
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
            },
          ),
          "@markdown.markdown(source, render_codeblock=highlight, render_heading=compact_heading)",
          variant=ShowcaseStagePlain,
        ),
      ),
      showcase_demo_section(
        "Async README",
        "The complete, unmodified moonbitlang/async 0.22.2 README (149 lines, Apache-2.0). Known cmark 0.4.8 limitation: 20 of 26 tasks become checkboxes; six nested task markers remain text. The source is preserved.",
        showcase_demo_stage(
          @markdown.markdown(markdown_async_readme),
          MarkdownUsageCode,
          variant=ShowcaseStagePlain,
        ),
      ),
    ],
  )
}
