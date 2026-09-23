///|
#cfg(not(target="js"))
#warnings("-alert_experimental")
async fn render(
  source : String,
  render_codeblock? : (String, String) -> @html.Html,
  transform_link? : (String) -> String,
  render_heading? : (@cmark.BlockHeading) -> @html.Html,
) -> String {
  @rabbita.new(() => {
    @rabbita.Val::constant(
      @html.html([
        @html.head(@html.nothing),
        @html.body(
          @markdown.markdown(
            source,
            render_codeblock?,
            transform_link?,
            render_heading?,
          ),
        ),
      ]),
    )
  }).render(url="https://example.com/readme")
}

///|
#cfg(not(target="js"))
fn count_tag(output : String, tag : String) -> Int {
  output.split("<" + tag + " ").count() +
  output.split("<" + tag + ">").count() -
  2
}

///|
#cfg(not(target="js"))
async test "complete pinned README includes all tables code images and final section" {
  let html = render(ripgrep_readme)
  assert_eq(count_tag(html, "h2"), 1)
  assert_true(html.contains(">ripgrep (rg)<"))
  assert_eq(count_tag(html, "table"), 6)
  assert_eq(count_tag(html, "img"), 4)
  assert_true(count_tag(html, "pre") >= 30)
  assert_eq(count_tag(html, "button"), 31)
  assert_eq(
    count_tag(html, "a"),
    80 + count_tag(html, "h2") + count_tag(html, "h3"),
  )
  assert_true(html.contains(">Translations<"))
  assert_true(html.contains("href=\"GUIDE.md#configuration-file\""))
}

///|
#cfg(not(target="js"))
async test "inline markup links images and email autolinks" {
  let html = render(
    "**bold** *italic* ~~gone~~ `a < b`  \nnext\n\n[guide][ref] ![an *image*](./logo.svg \"Logo\") <hi@example.com>\n\n[ref]: ./GUIDE.md \"Guide\"",
  )
  for
    expected in [
      "<strong>bold</strong>", "<em>italic</em>", "<del>gone</del>", "<code>a &lt; b</code>",
      "<br>", "href=\"./GUIDE.md\"", "title=\"Guide\"", "href=\"mailto:hi@example.com\"",
      "src=\"./logo.svg\"", "alt=\"an image\"",
    ] {
    assert_true(html.contains(expected), msg=expected)
  }
}

///|
#cfg(not(target="js"))
async test "link transform rewrites links and images while preserving generated anchors" {
  let destinations : Array[String] = []
  let source =
    #|# Intro
    #|
    #|[Guide](./guide.md?mode=1#usage "Guide") ![Logo](./logo.svg "Logo")
    #|[Reference][guide] ![Reference logo][logo]
    #|<https://example.com> <hi@example.com> [Local](#intro) Footnote[^note]
    #|
    #|[guide]: ./guide.md?mode=1#usage
    #|[logo]: ./logo.svg
    #|
    #|[^note]: Note with [Nested](./nested.md)
  let html = render(source, transform_link=href => {
    destinations.push(href)
    if href is [.. "./", .. relative] {
      "https://assets.mooncakes.io/source/alice/tool@1.2.3/lib/" +
      relative.to_owned()
    } else {
      href
    }
  })
  assert_eq(destinations, [
    "./guide.md?mode=1#usage", "./logo.svg", "./guide.md?mode=1#usage", "./logo.svg",
    "https://example.com", "mailto:hi@example.com", "#intro", "./nested.md",
  ])
  for
    expected in [
      "href=\"https://assets.mooncakes.io/source/alice/tool@1.2.3/lib/guide.md?mode=1#usage\"",
      "src=\"https://assets.mooncakes.io/source/alice/tool@1.2.3/lib/logo.svg\"",
      "href=\"https://assets.mooncakes.io/source/alice/tool@1.2.3/lib/nested.md\"",
      "title=\"Guide\"", "title=\"Logo\"", "alt=\"Reference logo\"", "href=\"https://example.com\"",
      "href=\"mailto:hi@example.com\"", "href=\"#intro\"", "href=\"#rui-fn-1\"",
      "href=\"#rui-fnref-1\"",
    ] {
    assert_true(html.contains(expected), msg=expected)
  }
  assert_eq(count_tag(html, "img"), 2)
}

///|
#cfg(not(target="js"))
async test "transformed links images and autolinks still reject unsafe schemes" {
  for
    destination in [
      "javascript:alert(1)", "java\tscript:alert(1)", "data:text/html,payload", "file:///etc/passwd",
    ] {
    let html = render(
      "[Guide](./guide.md) ![Logo](./logo.svg) <https://example.com> <hi@example.com>",
      transform_link=_ => destination,
    )
    assert_eq(count_tag(html, "a"), 0)
    assert_eq(count_tag(html, "img"), 0)
    assert_true(html.contains("Guide Logo https://example.com hi@example.com"))
  }
}

///|
#cfg(not(target="js"))
async test "HTML remains visible escaped source" {
  let html = render(
    "before <span onclick=\"alert(1)\">**bold**</span> after\n\n<div>\n<script>alert(1)</script>\n</div>",
  )
  // The only script is Rabbita's inert SSR hydration transcript.
  assert_eq(count_tag(html, "script"), 1)
  assert_false(html.contains("<span onclick="))
  assert_true(
    html.contains(
      "&lt;div&gt;\n&lt;script&gt;alert(1)&lt;/script&gt;\n&lt;/div&gt;",
    ),
  )
  assert_true(
    html.contains(
      "&lt;span onclick=\"alert(1)\"&gt;<strong>bold</strong>&lt;/span&gt;",
    ),
  )
}

///|
#cfg(not(target="js"))
async test "unsafe URL schemes cannot create links or images" {
  for
    source in [
      "[click](javascript:alert%281%29)", "[click](JaVaScRiPt:alert%281%29)", "[click](jav&#x61;script:alert%281%29)",
      "[click](java&#x09;script:alert%281%29)", "[click](vbscript:msgbox%281%29)",
      "[click](data:text/html,payload)", "![image](data:image/svg+xml,payload)",
      "[local](file:///etc/passwd)",
    ] {
    let html = render(source)
    assert_eq(count_tag(html, "a"), 0)
    assert_eq(count_tag(html, "img"), 0)
  }
}

///|
#cfg(not(target="js"))
async test "headings deduplicate IDs including Unicode" {
  let html = render(
    "# Hello World\n\n## Hello World\n\n### Hello World-1\n\n#### 中文 😀\n\n##### Five\n\n###### Six",
  )
  for id in ["hello-world", "hello-world-1", "hello-world-1-1"] {
    assert_true(html.contains("id=\"" + id + "\""))
    assert_true(html.contains("href=\"#" + id + "\""))
  }
  assert_eq(count_tag(html, "h4"), 1)
  assert_eq(count_tag(html, "h5"), 1)
  assert_eq(count_tag(html, "h6"), 1)
  assert_true(html.contains("中文 😀"))
}

///|
#cfg(not(target="js"))
async test "custom heading renderer receives the cmark AST at every level and nesting" {
  let headings : Array[@cmark.BlockHeading] = []
  let transformed : Array[String] = []
  let source =
    #|# **Strong** and `code` with [Guide](./guide.md)
    #|
    #|Second *heading*
    #|---
    #|
    #|> ### Quoted heading
    #|
    #|- #### Listed heading
    #|
    #|##### Five
    #|
    #|###### Six
    #|
    #|Footnote[^note]
    #|
    #|[^note]: Note.
    #|
    #|    ## Footnote heading
  let html = render(
    source,
    transform_link=href => {
      transformed.push(href)
      href
    },
    render_heading=heading => {
      headings.push(heading)
      @html.h4(
        id="custom-" + heading.level.to_string(),
        style=["font-size:14px"],
        "Custom " + heading.level.to_string(),
      )
    },
  )
  assert_eq(headings.map(heading => heading.level), [1, 2, 3, 4, 5, 6, 2])
  assert_true(headings[0].layout is Atx(_))
  assert_true(headings[1].layout is Setext(_))
  assert_true(headings[0].id is Some(Auto(_)))
  assert_eq(
    headings[0].inline
    .to_plain_text(break_on_soft=false)
    .map(parts => parts.to_array().join(""))
    .to_array()
    .join("\n"),
    "Strong and code with Guide",
  )
  assert_eq(count_tag(html, "h4"), 7)
  assert_eq(count_tag(html, "h1"), 0)
  assert_false(html.contains("class=\"rui-markdown-anchor\""))
  assert_false(html.contains("<strong>"))
  assert_true(html.contains("id=\"custom-6\""))
  // The callback owns the whole heading; default inline rendering and link
  // transformations must not run for content it replaces.
  assert_eq(transformed, [])
}

///|
#cfg(not(target="js"))
async test "ordered starts nested loose lists and disabled tasks" {
  let html = render(
    "3. three\n4. four\n   - nested\n\n- [x] done\n- [ ] pending\n\n- loose one\n\n- loose two",
  )
  assert_true(html.contains("start=\"3\""))
  assert_eq(html.split("role=\"checkbox\"").count() - 1, 2)
  assert_true(count_tag(html, "ul") >= 2)
  assert_true(count_tag(html, "p") >= 2)
  assert_eq(html.split(" disabled").count() - 1, 2)
  assert_eq(html.split("aria-checked=\"true\"").count() - 1, 1)
}

///|
#cfg(not(target="js"))
async test "tables preserve alignment and rectangular rows" {
  let html = render(
    "| left | center | right |\n| :--- | :---: | ---: |\n| a | b | c |\n| short |",
  )
  assert_eq(count_tag(html, "th"), 3)
  assert_eq(count_tag(html, "td"), 6)
  for alignment in ["left", "center", "right"] {
    assert_true(html.contains("style=\"text-align:" + alignment + "\""))
  }
}

///|
#cfg(not(target="js"))
async test "repeated footnotes and cycles produce complete backlinks" {
  let html = render(
    "See[^b], again[^b], then[^a].\n\n[^a]: First definition.\n[^b]: Second definition with **bold**.",
  )
  assert_eq(html.split("role=\"doc-noteref\"").count() - 1, 3)
  assert_eq(html.split("role=\"doc-backlink\"").count() - 1, 3)
  for id in ["rui-fnref-1", "rui-fnref-1-1", "rui-fnref-2"] {
    assert_true(html.contains("id=\"" + id + "\""))
    assert_true(html.contains("href=\"#" + id + "\""))
  }
  let cyclic = render(
    "Start[^a].\n\n[^a]: A refers to B[^b].\n[^b]: B refers back[^a].",
  )
  assert_eq(count_tag(cyclic, "li"), 2)
  assert_eq(cyclic.split("role=\"doc-backlink\"").count() - 1, 3)
}

///|
#cfg(not(target="js"))
async test "code math and diagrams preserve source" {
  let html = render(
    "```moonbit\nlet x = \"<tag>\"\n```\n\n```mermaid\ngraph LR; A-->B\n```\n\nInline $x^2$.\n\n$$\ny = x + 1\n$$",
  )
  for
    expected in [
      "class=\"language-moonbit\"", "&lt;tag&gt;", "graph LR; A--&gt;B", "$x^2$",
      "y = x + 1",
    ] {
    assert_true(html.contains(expected), msg=expected)
  }
}

///|
#cfg(not(target="js"))
async test "empty and incomplete input remains renderable" {
  assert_eq(count_tag(render(""), "p"), 0)
  assert_true(render("[unfinished **text").contains("[unfinished **text"))
  assert_true(render("```\nunclosed fence").contains("unclosed fence"))
}

///|
test "synchronous API accepts the same complete README on every backend" {
  let _ : @html.Html = @markdown.markdown(ripgrep_readme)
  let _ : @html.Html = @markdown.markdown(async_readme)
}

///|
#cfg(not(target="js"))
async test "custom code block rendering receives source and info inside nested lists and footnotes" {
  let blocks : Array[(String, String)] = []
  let html = render(
    "- item\n\n  ```moonbit check\n  let x = \"<tag>\"\n  ```\n\nparagraph ends the list.\n\n    indented\n\nref[^code]\n\n[^code]: note\n\n    ```text title=note\n    footnote code\n    ```\n\n<div>source</div>\n\n$$\nx^2\n$$",
    render_codeblock=(source, info) => {
      blocks.push((source, info))
      @html.pre(
        class="highlighted",
        @html.code(@html.span(class="token", source)),
      )
    },
  )
  assert_eq(blocks, [
    ("let x = \"<tag>\"", "moonbit check"),
    ("indented", ""),
    ("footnote code", "text title=note"),
  ])
  assert_eq(html.split("class=\"highlighted\"").count() - 1, 3)
  assert_eq(count_tag(html, "pre"), 4)
  assert_eq(count_tag(html, "button"), 4)
  assert_true(html.contains("let x = \"&lt;tag&gt;\""))
  assert_true(html.contains("&lt;div&gt;source&lt;/div&gt;"))
}

///|
#cfg(not(target="js"))
async test "code renderer receives complete parsed fence info including metadata" {
  let blocks : Array[(String, String)] = []
  let source =
    #|````moonbit check title="示例 😀" {1,3}
    #|let answer = 42
    #|````
    #|
    #|~~~json title="a &amp; b"
    #|{"answer":42}
    #|~~~
    #|
    #|```
    #|no language
    #|```
  let html = render(source, render_codeblock=(code, info) => {
    blocks.push((code, info))
    @html.pre(@html.code(code))
  })
  assert_eq(blocks, [
    ("let answer = 42", "moonbit check title=\"示例 😀\" {1,3}"),
    ("{\"answer\":42}", "json title=\"a & b\""),
    ("no language", ""),
  ])
  assert_eq(count_tag(html, "button"), 3)
  let default_html = render(source)
  assert_true(default_html.contains("class=\"language-moonbit\""))
  assert_true(default_html.contains("class=\"language-json\""))
}

///|
#cfg(not(target="js"))
async test "complete async 0.22.2 README preserves packages tasks code and final caveat" {
  let html = render(async_readme)
  assert_eq(count_tag(html, "h1"), 1)
  assert_eq(count_tag(html, "h2"), 5)
  assert_eq(count_tag(html, "pre"), 2)
  assert_eq(html.split("role=\"checkbox\"").count() - 1, 20)
  assert_eq(html.split("aria-checked=\"true\"").count() - 1, 19)
  // cmark 0.4.8 retains six nested task markers as paragraph text. This is a
  // pinned-fixture observation, not the desired behavior of a future parser.
  assert_eq(html.split("- [X] ").count() - 1, 4)
  assert_eq(html.split("- [ ] ").count() - 1, 2)
  assert_true(html.contains("moon add moonbitlang/async@0.22.1"))
  assert_true(
    html.contains("href=\"#structured-concurrency-and-error-propagation\""),
  )
  assert_true(
    html.contains("and use <code>@async.Queue</code> to distribute/gather data"),
  )
}
