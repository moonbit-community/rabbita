///|
priv enum Route {
  Index
  Forms
  Modals
  Missing(String)
} derive(Eq)

///|
priv enum Msg {
  UrlChanged(@url.Url)
  UrlRequest(@url.UrlRequest)
}

///|
fn route_from_path(path : String) -> Route {
  match path {
    "" => Index
    "forms" => Forms
    "modals" => Modals
    path => Missing(path)
  }
}

///|
fn update(
  route : Route,
  message : Msg,
  _ : @rabbita.Emit[Msg],
) -> (Route, @rabbita.Cmd) {
  match message {
    UrlChanged(url) => (route_from_path(url.path), @rabbita.none)
    UrlRequest(request) =>
      match request {
        Internal(url) => (route, @nav.push_url(url.to_string()))
        External(url) => (route, @nav.load(url))
      }
  }
}

///|
fn subscriptions(_ : Route, emit : @rabbita.Emit[Msg]) -> @sub.Sub {
  @sub.batch([
    @sub.on_url_changed(emit.map(url => UrlChanged(url))),
    @sub.on_url_request(emit.map(request => UrlRequest(request))),
  ])
}

///|
fn app() -> @rabbita.Val[@html.Html] {
  let url = try! @url.parse(@dom.window().current_url())
  let (route, _) = @rabbita.create_state(
    route_from_path(url.path),
    update~,
    subscriptions~,
  )
  route.view(route => {
    let (title, section_title, body) = match route {
      Index =>
        (
          "Index", "Fixture pages", "Choose a page to exercise navigation and browser history.",
        )
      Forms => ("Forms", "Forms route", "This is the Forms route.")
      Modals => ("Modals", "Modals route", "This is the Modals route.")
      Missing(path) =>
        (
          "Not found",
          "Fixture page not found",
          "No fixture page exists for /\{path}.",
        )
    }
    @html.fragment([
      @html.nav(
        title="Fixture pages",
        style=["display:flex;gap:0.5rem;padding:1rem 1.5rem"],
        [
          @html.a(href="/", "Index"),
          @html.a(href="/forms", "Forms"),
          @html.a(href="/modals", "Modals"),
        ],
      ),
      @html.p(
        id="fixture-route-title",
        style=["margin:0;padding:1rem 1.5rem;font-weight:600"],
        title,
      ),
      @fixture.section("fixture-route-content", section_title, [@html.p(body)]),
    ])
  })
}
