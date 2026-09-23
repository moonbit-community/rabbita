///|
#cfg(not(target="js"))
#warnings("-alert_experimental")
async fn render(source : String) -> String {
  @rabbita.new(() => {
    @rabbita.Val::constant(
      @html.html([
        @html.head(@html.nothing),
        @html.body(@markdown.markdown(source)),
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
  assert_true(html.contains(">ripgrep (rg)</h2>"))
  assert_eq(count_tag(html, "table"), 6)
  assert_eq(count_tag(html, "img"), 4)
  assert_true(count_tag(html, "pre") >= 30)
  assert_eq(count_tag(html, "a"), 80)
  assert_true(html.contains(">Translations</h3>"))
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
async test "HTML remains visible escaped source" {
  let html = render(
    "before <span onclick=\"alert(1)\">**bold**</span> after\n\n<div>\n<script>alert(1)</script>\n</div>",
  )
  // The only script is Rabbita's inert SSR hydration transcript.
  assert_eq(count_tag(html, "script"), 1)
  assert_eq(count_tag(html, "span"), 0)
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
  }
  assert_eq(count_tag(html, "h4"), 1)
  assert_eq(count_tag(html, "h5"), 1)
  assert_eq(count_tag(html, "h6"), 1)
  assert_true(html.contains("中文 😀"))
}

///|
#cfg(not(target="js"))
async test "ordered starts nested loose lists and disabled tasks" {
  let html = render(
    "3. three\n4. four\n   - nested\n\n- [x] done\n- [ ] pending\n\n- loose one\n\n- loose two",
  )
  assert_true(html.contains("start=\"3\""))
  assert_eq(count_tag(html, "input"), 2)
  assert_true(count_tag(html, "ul") >= 2)
  assert_true(count_tag(html, "p") >= 2)
  assert_eq(html.split(" disabled").count() - 1, 2)
  assert_eq(html.split(" checked").count() - 1, 1)
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
}
