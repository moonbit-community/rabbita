///|
using @html {a, div, h1, h2, li, text, ul}

///|
using @rabbita {type Cmd, type Html}

///|
#cfg(target="js")
enum Msg {
  Clicked
}

///|
type Model = Int

///|
#cfg(target="js")
fn update(count : Model, msg : Msg) -> Model {
  match msg {
    Clicked => count + 1
  }
}

///|
fn button(text : String, on_click~ : Cmd) -> Html {
  div(class="click-btn", on_click~, text)
}

///|
fn view(on_click : Cmd, count : Model) -> Html {
  div(class="app", [
    h1(class="title", "Hello Rabbita"),
    div(class="lead", "You built it successfully!"),
    div(class="actions", [button("You clicked \{count} times", on_click~)]),
    div(class="next", [
      h2(class="next-title", "What's next"),
      ul(class="next-list", [
        li("Edit a MoonBit file while the dev server runs for instant refresh."),
        li([
          text("Explore "),
          a(
            class="inline-link",
            target=Blank,
            href="https://github.com/moonbit-community/rabbita",
            "tutorials and examples",
          ),
        ]),
      ]),
    ]),
  ])
}
