///|
test "input preserves login form autofill hints" {
  let username = @html.input(name="name_key", auto_complete="username")
  let password = @html.input(
    input_type=Password,
    auto_complete="current-password",
  )
  let code = @html.input(name="code", auto_complete="one-time-code")
  assert_eq(vnode_attr(username, "name"), Some("name_key"))
  assert_eq(vnode_attr(username, "autocomplete"), Some("username"))
  assert_eq(vnode_attr(password, "type"), Some("password"))
  assert_eq(vnode_attr(password, "autocomplete"), Some("current-password"))
  assert_eq(vnode_attr(code, "name"), Some("code"))
  assert_eq(vnode_attr(code, "autocomplete"), Some("one-time-code"))
}

///|
test "autocomplete preserves field names and ordered token lists" {
  for
    value in [
      "new-password", "email", "section-login username webauthn", "section-blue shipping street-address",
      "section-login  username webauthn",
    ] {
    let from_builder = @html.input(
      attrs=@html.Attrs::build().autocomplete(value),
    )
    let from_option = @html.input(auto_complete=value)
    assert_eq(vnode_attr(from_builder, "autocomplete"), Some(value))
    assert_eq(vnode_attr(from_option, "autocomplete"), Some(value))
  }
}

///|
test "input autocomplete overrides the builder without mutating it" {
  let attrs = @html.Attrs::build().autocomplete("username")
  let inherited = @html.input(attrs~)
  let overridden = @html.input(attrs~, auto_complete="one-time-code")
  assert_eq(vnode_attr(inherited, "autocomplete"), Some("username"))
  assert_eq(vnode_attr(overridden, "autocomplete"), Some("one-time-code"))
  assert_eq(vnode_attr(@html.input(attrs~), "autocomplete"), Some("username"))
}
