///|
using @rabbita {type Html, type Val}

///|
pub fn section(id : String, title : String, body : Array[Html]) -> Html {
  @html.section(
    id~,
    style=[
      "display:flex;flex-direction:column;gap:0.75rem;padding:1.5rem;border-bottom:1px solid var(--rui-border,oklch(0.922 0 0))",
    ],
    [
      @html.h2(style=["margin:0;font-size:1.125rem;font-weight:600"], title),
      @html.div(
        style=[
          "display:flex;flex-wrap:wrap;gap:1rem;align-items:center;padding-top:0.25rem",
        ],
        body,
      ),
    ],
  )
}

///|
pub fn mount(name : String, app : () -> Val[Html]) -> Unit {
  @rabbita.new(() => {
    app().map(body => {
      @rui.theme(
        mode=Light,
        id="fixture-theme",
        @html.main_(
          id="fixture-main",
          style=["max-width:64rem;margin:0 auto"],
          [
            @html.header(style=["padding:1.5rem"], [
              @html.h1(style=["margin:0;font-size:1.5rem"], "RUI · \{name}"),
              @html.p(style=["margin:0.25rem 0 0"], "rui.\{name}.spec.ts"),
            ]),
            body,
          ],
        ),
      )
    })
  }).mount("app")
}
