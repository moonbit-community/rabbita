///|
using @rabbita {type Cmd, type Emit, type Html, type Val}

///|
using @html {button, div, h1, p}

///|
priv struct Model {
  active : Bool
  resize_count : Int
  width : Double
  height : Double
  key_count : Int
  last_key : String
  use_new_tagger : Bool
  old_tagger_count : Int
  new_tagger_count : Int
  barrier : Int
  socket_case : Int
  socket_errors : Int
  socket_opens : Int
  socket_message : String
} derive(Eq)

///|
priv enum Msg {
  SetActive(Bool)
  Resized(@common.Viewport)
  OldTaggedKey(@common.Keyboard)
  NewTaggedKey(@common.Keyboard)
  UseOldTagger
  UseNewTagger
  Barrier
  SetSocket(Int)
  SocketError
  SocketOpened
  SocketMessage(String)
}

///|
fn update(model : Model, message : Msg, _ : Emit[Msg]) -> (Model, Cmd) {
  match message {
    SetActive(active) => ({ ..model, active, }, @rabbita.none)
    Resized(viewport) =>
      (
        {
          ..model,
          resize_count: model.resize_count + 1,
          width: viewport.width,
          height: viewport.height,
        },
        @rabbita.none,
      )
    OldTaggedKey(keyboard) =>
      (
        {
          ..model,
          key_count: model.key_count + 1,
          last_key: keyboard.key(),
          old_tagger_count: model.old_tagger_count + 1,
        },
        @rabbita.none,
      )
    NewTaggedKey(keyboard) =>
      (
        {
          ..model,
          key_count: model.key_count + 1,
          last_key: keyboard.key(),
          new_tagger_count: model.new_tagger_count + 1,
        },
        @rabbita.none,
      )
    UseOldTagger => ({ ..model, use_new_tagger: false, }, @rabbita.none)
    UseNewTagger => ({ ..model, use_new_tagger: true, }, @rabbita.none)
    Barrier => ({ ..model, barrier: model.barrier + 1, }, @rabbita.none)
    SetSocket(socket_case) => ({ ..model, socket_case, }, @rabbita.none)
    SocketError =>
      ({ ..model, socket_errors: model.socket_errors + 1, }, @rabbita.none)
    SocketOpened =>
      ({ ..model, socket_opens: model.socket_opens + 1, }, @rabbita.none)
    SocketMessage(socket_message) =>
      ({ ..model, socket_message, }, @rabbita.none)
  }
}

///|
fn subscriptions(model : Model, emit : Emit[Msg]) -> @sub.Sub {
  if model.active {
    @sub.batch([
      socket_subscription(model.socket_case, emit),
      @sub.on_resize(emit.map(viewport => Resized(viewport))),
      @sub.on_key_down(
        emit.map(keyboard => {
          if model.use_new_tagger {
            NewTaggedKey(keyboard)
          } else {
            OldTaggedKey(keyboard)
          }
        }),
      ),
    ])
  } else {
    @sub.none
  }
}

///|
fn socket_subscription(socket_case : Int, emit : Emit[Msg]) -> @sub.Sub {
  let (url, protocols) : (String, FixedArray[String]) = match socket_case {
    1 => ("ftp://example.test", [])
    2 => ("ws://example.test/#fragment", [])
    3 => ("ws://example.test/socket", ["duplicate", "duplicate"])
    4 => ("ws://example.test/socket", [])
    5 => ("ws://example.test/socket", ["events"])
    _ => return @sub.none
  }
  @websocket.listen(
    url,
    protocols~,
    open=emit(SocketOpened),
    message=emit.map(message => SocketMessage(message)),
    error=emit(SocketError),
  )
}

///|
fn app() -> Val[Html] {
  let initial : Model = {
    active: true,
    resize_count: 0,
    width: 0.0,
    height: 0.0,
    key_count: 0,
    last_key: "",
    use_new_tagger: false,
    old_tagger_count: 0,
    new_tagger_count: 0,
    barrier: 0,
    socket_case: 0,
    socket_errors: 0,
    socket_opens: 0,
    socket_message: "",
  }
  let (model, emit) = @rabbita.create_state(initial, update~, subscriptions~)
  model.view(model => {
    div <| [
      h1("Subscriptions"),
      p(
        id="subscription-state",
        if model.active {
          "active"
        } else {
          "inactive"
        },
      ),
      button(on_click=emit(SetActive(false)), "Disable subscriptions"),
      button(on_click=emit(SetActive(true)), "Enable subscriptions"),
      button(on_click=emit(Barrier), "Flush barrier"),
      p(id="barrier", "barrier: \{model.barrier}"),
      button(on_click=emit(SetSocket(1)), "Invalid socket scheme"),
      button(on_click=emit(SetSocket(2)), "Socket URL fragment"),
      button(on_click=emit(SetSocket(3)), "Duplicate socket protocols"),
      button(on_click=emit(SetSocket(4)), "Valid socket"),
      button(on_click=emit(SetSocket(5)), "Valid socket with protocol"),
      button(on_click=emit(SetSocket(0)), "Remove socket"),
      p(id="socket-errors", "socket errors: \{model.socket_errors}"),
      p(id="socket-opens", "socket opens: \{model.socket_opens}"),
      p(id="socket-message", "socket message: \{model.socket_message}"),
      p(id="resize-count", "resizes: \{model.resize_count}"),
      p(id="viewport", "viewport: \{model.width}x\{model.height}"),
      p(id="key-count", "keys: \{model.key_count}"),
      p(id="last-key", "last key: \{model.last_key}"),
      p(
        id="tagger-mode",
        if model.use_new_tagger {
          "tagger: new"
        } else {
          "tagger: old"
        },
      ),
      button(on_click=emit(UseOldTagger), "Use old tagger"),
      button(on_click=emit(UseNewTagger), "Use new tagger"),
      p(id="old-tagger-count", "old tagger: \{model.old_tagger_count}"),
      p(id="new-tagger-count", "new tagger: \{model.new_tagger_count}"),
    ]
  })
}
