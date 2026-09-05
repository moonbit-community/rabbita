///|
using @rabbita {type Cmd, type Emit, type Html, type Val}

///|
using @html {button, div, h1, p}

///|
priv struct Model {
  location : String
  count : Int
} derive(Eq)

///|
priv enum Msg {
  PushFirst
  ReplaceSecond
  GoBack
  GoForward
  Increment
  UrlChanged(@url.Url)
}

///|
fn location_label(url : @url.Url) -> String {
  let query = match url.query {
    Some(value) => "?\{value}"
    None => ""
  }
  "/" + url.path + query
}

///|
fn current_location() -> String {
  location_label(try! @url.parse(@dom.window().current_url()))
}

///|
fn update(model : Model, message : Msg, _ : Emit[Msg]) -> (Model, Cmd) {
  match message {
    PushFirst => (model, @nav.push_url("/first?from=push"))
    ReplaceSecond => (model, @nav.replace_url("/second?from=replace"))
    GoBack => (model, @nav.back())
    GoForward => (model, @nav.forward())
    Increment => ({ ..model, count: model.count + 1, }, @rabbita.none)
    UrlChanged(url) =>
      ({ ..model, location: location_label(url), }, @rabbita.none)
  }
}

///|
fn subscriptions(_ : Model, emit : Emit[Msg]) -> @sub.Sub {
  @sub.on_url_changed(emit.map(url => UrlChanged(url)))
}

///|
fn app() -> Val[Html] {
  let (model, emit) = @rabbita.create_state(
    { location: current_location(), count: 0, },
    update~,
    subscriptions~,
  )
  model.view(model => {
    div <| [
      h1("Navigation and history"),
      p(id="location", model.location),
      p(id="preserved-count", "count: \{model.count}"),
      button(on_click=emit(Increment), "Increment preserved state"),
      button(on_click=emit(PushFirst), "Push first URL"),
      button(on_click=emit(ReplaceSecond), "Replace with second URL"),
      button(on_click=emit(GoBack), "Go back"),
      button(on_click=emit(GoForward), "Go forward"),
    ]
  })
}
