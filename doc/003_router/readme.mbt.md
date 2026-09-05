# Router

This tour shows how a Rabbita component can own routing state and dispatch each
route to a page component.

Rabbita has no hidden router object. Routing is explicit:

- Keep the current route in component-local state
- Parse URLs with pattern matching or a package such as `sw_router`
- Handle `UrlRequest` and `UrlChanged` messages in the root component

## Define routes and messages

This example has three kinds of pages:

- `/home` lists the available articles
- `/article/:id` displays one article
- Any other path displays a 404 page

The route state and navigation messages are ordinary MoonBit types:

```moonbit check
///|
type Id = String

///|
struct Article {
  id : Id
  title : String
  content : String
} derive(Eq)

///|
enum Route {
  Home
  Article(Article)
  NotFound
} derive(Eq)

///|
enum Msg {
  UrlChanged(Url)
  UrlRequest(UrlRequest)
}
```

`Route` also gives each page component a stable branch identity. An article's
id is part of that identity, so navigating to another article creates the
component for that article.

```moonbit check
///|
impl @rabbita.Enumerate for Route with fn tag(self) {
  match self {
    Home => "home"
    Article(article) => "article/\{article.id}"
    NotFound => "not-found"
  }
}
```

## Define the page components

The tutorial uses local immutable article data instead of a network request.
Each route is rendered by a named component:

```moonbit check
///|
fn home_page(articles : Vector[Article]) -> Val[Html] {
  Val::constant(
    ul(
      articles.map(article => {
        li(a(href="/article/\{article.id}", article.title))
      }),
    ),
  )
}

///|
fn article_page(article : Article) -> Val[Html] {
  Val::constant(div([h1(article.title), p(article.content)]))
}

///|
fn not_found_page() -> Val[Html] {
  Val::constant(div([h1("404"), a(href="/home", "go home")]))
}
```

The URL parser receives the same immutable article collection as the
components. `Url.path` does not include the leading `/`, so `/home` produces
`"home"` and `/article/1` produces `"article/1"`.

```moonbit check
///|
fn route_from_url(articles : Vector[Article], url : Url) -> Route {
  match url.path {
    "" | "home" => Home
    [.. "article/", .. id] => {
      let id = id.to_owned()
      if articles.iter().find_first(article => article.id == id)
        is Some(article) {
        Article(article)
      } else {
        NotFound
      }
    }
    _ => NotFound
  }
}
```

## Build the root component

The root component creates the route state, handles navigation, and owns the
route subscriptions. There is no separate top-level model, update function, or
view function.

```moonbit check
///|
fn app() -> Val[Html] {
  let articles = from_array([
    { id: "1", title: "Article 1", content: "content 1", },
    { id: "2", title: "Article 2", content: "content 2", },
    { id: "3", title: "Article 3", content: "content 3", },
  ])
  let (route, _) = @rabbita.create_state(
    Home,
    subscriptions=fn(_, emit) {
      @sub.batch([
        @sub.on_url_changed(url => emit(UrlChanged(url))),
        @sub.on_url_request(request => emit(UrlRequest(request))),
      ])
    },
    update=fn(current_route, msg, _) {
      match msg {
        UrlRequest(request) =>
          match request {
            Internal(url) => (current_route, @nav.push_url(url.to_string()))
            External(url) => (current_route, @nav.load(url))
          }
        UrlChanged(url) => (route_from_url(articles, url), none)
      }
    },
  )

  route.switch(current_route => {
    match current_route {
      Home => home_page(articles)
      Article(article) => article_page(article)
      NotFound => not_found_page()
    }
  })
}
```

The callback passed to `switch` immediately dispatches each route to a page
component. When the route tag changes, Rabbita disposes the active branch and
builds the next one.

Route subscriptions belong to the root component. On mount,
`on_url_changed` emits the current browser URL, which initializes refreshes and
deep links. It also reports back and forward navigation. Links built with
`a(href=...)` produce `UrlRequest` messages.

An internal request schedules `push_url`. That command changes browser history
without reloading the page and then produces `UrlChanged`. An external request
schedules `load`, which performs a full-page navigation.

Mount the root component as usual:

```moonbit nocheck
///|
fn main {
  @rabbita.new(app).mount("main")
}
```

## When should you use a router?

You do not need a router when an app only switches local UI and does not need
deep links, refresh recovery, or browser back and forward support.

Introduce routing when navigation becomes part of the app's public state. It
can remain ordinary component state instead of becoming a separate global
system.

## Core idea recap

- The root component owns the current route
- Navigation is expressed as messages and commands
- URL changes update the route state
- `switch` dispatches routes to page components

Routing is local route state plus navigation messages and page components.
