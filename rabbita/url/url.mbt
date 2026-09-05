///|
/// Represent the URL change request from the user, trigger by `@html.a` tag.
/// The `Internal` means the target URL is in the same domain.
/// The `External` means the target URL is in another site.
pub(all) enum UrlRequest {
  Internal(Url)
  External(String)
} derive(Debug, Eq, Compare)

///|
pub impl Show for UrlRequest with fn output(self, buf) {
  Show::output(self.to_repr(), buf)
}

///|
/// Url
/// 
/// ```text
///  https://example.com:8042/over/there?name=ferret#nose
///  \___/   \______________/\_________/ \_________/ \__/
///    |            |            |            |        |
///  scheme     authority       path        query   fragment
/// ```
/// 
/// This diagram is from https://package.elm-lang.org/packages/elm/url/latest/Url
pub(all) struct Url {
  protocol : Protocol
  host : String
  port : Int?
  path : String
  query : String?
  fragment : String?
} derive(Debug, Eq, Compare)

///|
pub impl Show for Url with fn output(self, buf) {
  Show::output(self.to_repr(), buf)
}

///|
pub(all) enum Protocol {
  Http
  Https
  Other(String)
} derive(Debug, Eq, Compare)

///|
pub impl Show for Protocol with fn output(self, buf) {
  Show::output(self.to_repr(), buf)
}

///|
pub fn Url::to_string(self : Url) -> String {
  let protocol = match self.protocol {
    Http => "http"
    Https => "https"
    _ => panic() // TODO: fix this
  }
  let port = match self.port {
    Some(p) => ":\{p}"
    None => ""
  }
  let query = match self.query {
    Some(q) => "?\{q}"
    None => ""
  }
  let fragment = match self.fragment {
    Some(f) => "#\{f}"
    None => ""
  }
  "\{protocol}://\{self.host}\{port}/\{self.path}\{query}\{fragment}"
}

///|
pub fn parse(url : String) -> Url raise Error {
  let (protocol, remain) = match url.split("://").collect() {
    ["http", remain] => (Http, remain)
    ["https", remain] => (Https, remain)
    [x, remain] => (Other(x.to_owned()), remain)
    [remain] => (Other(""), remain)
    _ => fail("Invalid protocol")
  }
  let (mid, query_and_fragment) = match remain.split("?").collect() {
    [mid, remain] => (mid, remain)
    [mid] => (mid, "")
    _ => fail("Invalid host")
  }
  let (mid_part, fragment1) = match mid.split("#").collect() {
    [mid, fragment] => (mid, Some(fragment))
    [mid] => (mid, None)
    _ => fail("Invalid fragment")
  }
  let (mid, path) = match mid_part.split("/").collect() {
    [mid] => (mid, "")
    [mid, .. paths] => (mid, paths.iter().map(StringView::to_owned).join("/"))
    _ => fail("Invalid host")
  }
  let (host, port) = match mid.split(":").collect() {
    [host, port] => {
      let port = try @string.parse_int(port.to_owned()) catch {
        _ => Option::None
      } noraise {
        number => Some(number)
      }
      (host.to_owned(), port)
    }
    [host] => (host.to_owned(), None)
    _ => fail("Invalid host")
  }
  let (query, fragment2) = match query_and_fragment.split("#").collect() {
    [query, fragment] => (Some(query.to_owned()), Some(fragment))
    [query] =>
      if query.is_empty() {
        (None, None)
      } else {
        (Some(query.to_owned()), None)
      }
    [] => (None, None)
    _ => fail("Invalid query")
  }
  let fragment = match (fragment1, fragment2) {
    (Some(f1), Some(f2)) => Some("\{f1}#\{f2}")
    (Some(f), None) => Some(f.to_owned())
    (None, Some(f)) => Some(f.to_owned())
    (None, None) => None
  }
  { protocol, host, port, path, query, fragment, }
}
