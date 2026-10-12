///|
#cfg(not(target="js"))
test "failed HTTP results request hydration fallback" {
  let result : Result[String, HttpError] = Err(RequestError("offline"))
  try settle_result(result, _ => @cmd.none) catch {
    @cmd.HydrateExn::Fallback => ()
    _ => fail("unexpected hydration error")
  } noraise {
    _ => fail("expected hydration fallback")
  }
}

///|
#cfg(not(target="js"))
test "settle HTTP requests include a user agent" {
  let headers = settle_request_headers()
  assert_eq(headers.get("User-Agent"), Some("MoonBit"))
}

///|
#cfg(not(target="js"))
test "SSR HTTP requests append paths to the base URI" {
  for base in ["https://example.test/uml/", "https://example.test/uml"] {
    assert_eq(resolve_request_url("api", base), "https://example.test/uml/api")
    assert_eq(
      resolve_request_url("./examples-manifest.json", base),
      "https://example.test/uml/./examples-manifest.json",
    )
    assert_eq(
      request_target("examples-manifest.json?lang=en", base),
      ("https://example.test", "/uml/examples-manifest.json?lang=en"),
    )
    assert_eq(
      resolve_request_url("https://cdn.test/examples-manifest.json", base),
      "https://cdn.test/examples-manifest.json",
    )
  }
}
