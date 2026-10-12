///|
#cfg(not(target="js"))
async test "SSR base URI combines the base and request path without reading base tags" {
  let host = SSRHost(
    base_uri="https://example.test/site/",
    path="/uml/index.html?lang=en",
    () => {
      @duplix.constant(
        @vdom.VNode::elem(
          "base",
          @vdom.Props::new({ "href": "https://cdn.test/assets/" }, {}, {}, {}),
          Array([]),
        ),
      )
    },
  )
  defer host.cleanup()
  assert_eq(
    host.get_base_uri(),
    "https://example.test/site/uml/index.html?lang=en",
  )
}
