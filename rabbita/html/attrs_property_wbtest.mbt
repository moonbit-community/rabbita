///|
test "boolean helpers use native DOM property names and serialize for SSR" {
  for value in [true, false] {
    let cases = [
      (Attrs::build().readonly_(value), "input", "readOnly"),
      (Attrs::build().formnovalidate(value), "input", "formNoValidate"),
      (Attrs::build().novalidate(value), "form", "noValidate"),
      (Attrs::build().playsinline(value), "video", "playsInline"),
      (Attrs::build().allowfullscreen(value), "iframe", "allowFullscreen"),
      (Attrs::build().ismap(value), "img", "isMap"),
    ]
    for case in cases {
      let (attrs, tag, name) = case
      match attrs.0.props.get(name) {
        Some(Boolean(actual)) => assert_eq(actual, value)
        _ => fail("missing native property \{name}")
      }
      let rendered = @vdom.server_side_render(() => {
        node(tag, attrs, nothing).to_virtual_dom()
      })
      let opening = if value { "<\{tag} \{name}>" } else { "<\{tag}>" }
      assert_true(rendered.has_prefix("<!DOCTYPE html>" + opening))
    }
  }
}

///|
test "itemscope is a boolean HTML attribute, including reused builders" {
  let attrs = Attrs::build()
  for value in [true, false, true] {
    ignore(attrs.itemscope(value))
    assert_eq(attrs.0.attrs.contains("itemscope"), value)
    assert_false(attrs.0.props.contains("itemScope"))
    assert_false(attrs.0.props.contains("itemscope"))
    let rendered = @vdom.server_side_render(() => {
      div(attrs~, nothing).to_virtual_dom()
    })
    assert_eq(rendered.contains("itemscope"), value)
  }
}

///|
test "constructor helpers use native DOM property names" {
  for value in [true, false] {
    let cases = [
      (input(read_only=value), "readOnly"),
      (textarea(read_only=value, nothing), "readOnly"),
      (iframe(allowfullscreen=value), "allowFullscreen"),
      (fencedframe(allowfullscreen=value), "allowFullscreen"),
    ]
    for case in cases {
      let (html, name) = case
      match html.to_virtual_dom() {
        Elem(_, props, _, ..) =>
          match props.props.get(name) {
            Some(Boolean(actual)) => assert_eq(actual, value)
            _ => fail("missing native property \{name}")
          }
        _ => fail("expected an element")
      }
    }
  }
}
