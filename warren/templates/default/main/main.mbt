using @html {a, button, div, h1, h2, li, text, ul}
using @rabbita {type Val, type Html}

enum Msg {
  Clicked
}

fn app() -> Val[Html] {
  let (count, emit) = @rabbita.create_pure_state(0, update=fn(count, msg) {
    match msg {
      Clicked => count + 1
    }
  })

  count.view(count => {
    div(class="app") <| [
      h1(class="title", "Hello Rabbita"),
      div(class="lead", "You built it successfully!"),
      button(
        class="click-btn",
        on_click=emit(Clicked),
        "You clicked \{count} times",
      ),
      div(class="next") <| [
        h2(class="next-title", "What's next"),
        ul(class="next-list") <| [
          li(
            "Edit a MoonBit file while the dev server runs for instant refresh.",
          ),
          li <| [
            text("Explore "),
            a(
              class="inline-link",
              target=Blank,
              href="https://github.com/moonbit-community/rabbita",
              "tutorials and examples",
            ),
          ],
        ],
      ],
    ]
  })
}

fn main {
  @rabbita.new(app).mount("app")
}
