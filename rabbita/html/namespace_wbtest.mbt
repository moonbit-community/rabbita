///|
test "html.svg helper keeps the SVG namespace" {
  let html = svg([text("child")])
  assert_true(
    html.to_virtual_dom() is Elem(_, _, _, namespace_uri=Some(ns)) &&
    ns == @dom.namespace_svg,
  )
}

///|
test "html.math helper keeps the MathML namespace" {
  let html = math([text("child")])
  assert_true(
    html.to_virtual_dom() is Elem(_, _, _, namespace_uri=Some(ns)) &&
    ns == @dom.namespace_mathml,
  )
}
