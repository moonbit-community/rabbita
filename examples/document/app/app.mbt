///|
using @rabbita {type Val, type Resource, none, batch, create_resource}

///|
using @html {
  type Html,
  title,
  div,
  h2,
  button,
  p,
  ul,
  li,
  html,
  body,
  head,
}

///|
priv enum Msg {
  Inc
  Dec
  Repeat(Int, Msg)
}

///|
pub(all) struct Issue {
  content : String
  status : String
} derive(FromJson, ToJson, Eq)

///|
/// The whole page, `<html>` element included: the server renders it as the
/// response document and the browser hydrates the very same tree.
pub fn view() -> Val[Html] {
  let (model, inject) = @rabbita.create_state_with_init(
    init=inject => (0, inject(Repeat(5, Inc))),
    update=(model, msg, inject) => {
      match msg {
        Repeat(0, _) => (model, none)
        Repeat(n, msg) =>
          (model, batch([inject(msg), inject(Repeat(n - 1, msg))]))
        Inc => (model + 1, none)
        Dec => (model - 1, none)
      }
    },
  )
  let issues : Resource[Array[Issue]] = create_resource(inject => {
    @http.get("/issues").expect_json(inject)
  })
  Val::map2(model, issues, (count, issues) => {
    let theme = if count % 2 == 0 { "dark" } else { "light" }
    html(attrs=@html.Attrs::build().data_set("theme", theme)) <| [
      head([title("\{count}")]),
      body <| [
        div <| [
          h2("\{count}"),
          button(on_click=inject(Inc), "+"),
          button(on_click=inject(Dec), "-"),
        ],
        match issues {
          Loaded(xs) => ul(xs.map(x => li([h2(x.content), p(x.status)])))
          Pending => p("loading")
          Failed(e) => p("failed: \{e}")
        },
      ],
    ]
  })
}
