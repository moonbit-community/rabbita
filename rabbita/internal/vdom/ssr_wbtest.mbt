///|
test "SSR applies raw-text rules inside script and style elements" {
  let props = Props::new({}, {}, {}, {})
  let script = VNode::elem(
    "script",
    props,
    Array([
      VNode::text("const comparison = 'a < b && b > c';"),
      VNode::fragment([]),
    ]),
  )
  inspect(
    server_side_render(() => script),
    content=(
      #|<!DOCTYPE html><script>const comparison = 'a < b && b > c';</script>
    ),
  )

  let style = VNode::elem(
    "style",
    props,
    Array([VNode::text("a > b { content: '<&>'; }")]),
  )
  inspect(
    server_side_render(() => style),
    content=(
      #|<!DOCTYPE html><style>a > b { content: '<&>'; }</style>
    ),
  )
}

///|
test "SSR keeps escaping text in normal elements" {
  let div = VNode::elem(
    "div",
    Props::new({}, {}, {}, {}),
    Array([VNode::text("a < b && b > c")]),
  )
  inspect(
    server_side_render(() => div),
    content=(
      #|<!DOCTYPE html><div>a &lt; b &amp;&amp; b &gt; c</div>
    ),
  )
}

///|
test "SSR writes a camelCase property as its lowercase attribute" {
  let props : Map[String, @variant.Variant] = {
    "readOnly": Boolean(true),
    "noValidate": Boolean(false),
  }
  let input = VNode::elem("input", Props::new({}, props, {}, {}), Array([]))
  inspect(
    server_side_render(() => input),
    content=(
      #|<!DOCTYPE html><input readonly>
    ),
  )
}
