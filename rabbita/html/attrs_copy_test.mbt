///|
fn vnode_attr(html : @html.Html, name : String) -> String? {
  match html.to_virtual_dom() {
    Elem(_, props, _, namespace_uri=None) => props.attrs.get(name)
    _ => None
  }
}

///|
test "Attrs::copy isolates later mutations" {
  let original = @html.Attrs::build().role("note")
  let copied = original.copy().aria_label("Copied")

  let original_html = @html.div(attrs=original, @html.nothing)
  let copied_html = @html.div(attrs=copied, @html.nothing)

  debug_inspect(vnode_attr(original_html, "role"), content="Some(\"note\")")
  debug_inspect(vnode_attr(original_html, "aria-label"), content="None")
  debug_inspect(vnode_attr(copied_html, "role"), content="Some(\"note\")")
  debug_inspect(
    vnode_attr(copied_html, "aria-label"),
    content="Some(\"Copied\")",
  )
}

///|
test "input leaves autocomplete to the browser when omitted" {
  let inherited = @html.input(attrs=@html.Attrs::build().autocomplete("on"))
  let omitted = @html.input()
  let explicit = @html.input(auto_complete="off")

  debug_inspect(vnode_attr(inherited, "autocomplete"), content="Some(\"on\")")
  debug_inspect(vnode_attr(omitted, "autocomplete"), content="None")
  debug_inspect(vnode_attr(explicit, "autocomplete"), content="Some(\"off\")")
}
