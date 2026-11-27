///|
test "static HTML serialization escapes text and attributes without a DOM" {
  inspect(
    @html.div(title="\"<&>'", "<script>alert(1)</script> & 文本").render_to_string(),
    content=(
      #|<div title="&quot;&lt;&amp;&gt;&#39;">&lt;script&gt;alert(1)&lt;/script&gt; &amp; 文本</div>
    ),
  )
}

///|
test "static HTML serialization preserves form values and omits handlers" {
  let input = @html.input(
    value="\"<&>",
    checked=true,
    attrs=@html.Attrs::build().disabled(false),
    on_input=_ => @rabbita.none,
  ).render_to_string()
  assert_true(input.has_prefix("<input"))
  assert_true(input.contains("value=\"&quot;&lt;&amp;&gt;\""))
  assert_true(input.contains(" checked"))
  assert_false(input.contains("disabled"))
  assert_false(input.contains("oninput"))
  assert_false(input.contains("</input>"))
  inspect(
    @html.textarea(value="<tag> & text", "ignored").render_to_string(),
    content="<textarea>&lt;tag&gt; &amp; text</textarea>",
  )
}

///|
test "static HTML serialization evaluates memoized children once per call" {
  let calls = Ref(0)
  let html = @html.div([
    @html.memo(7, value => {
      calls.val += 1
      @html.span("memo \{value}")
    }),
    @html.span("tail"),
  ])
  assert_eq(calls.val, 0)
  inspect(
    html.render_to_string(),
    content="<div><span>memo 7</span><span>tail</span></div>",
  )
  assert_eq(calls.val, 1)
}
