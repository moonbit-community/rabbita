///|
enum Msg {
  Clicked
}

///|
fn app() -> @rabbita.Val[@rabbita.Html] {
  let (count, emit) = @rabbita.create_pure_state(0, update=(count, msg) => {
    match msg {
      Clicked => count + 1
    }
  })
  count.view(count => {
    @html.div(class="app", [
      @html.h1(class="title", "Hello Rabbita"),
      @html.button(
        class="click-btn",
        on_click=emit(Clicked),
        "You clicked \{count} times",
      ),
    ])
  })
}

///|
fn main {
  @rabbita.new(app).mount("app")
}
