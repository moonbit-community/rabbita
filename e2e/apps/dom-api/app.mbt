///|
using @rabbita {type Html, type Val}

///|
using @html {button, div, h1, input, p}

///|
priv struct Model {
  nodes : String
  canvas : String
  platform : String
  dialogs : String
  observers : String
  timers : String
  events : String
  async_apis : String
  media : String
} derive(Eq)

///|
priv enum Msg {
  RunNodes
  RunCanvas
  RunPlatform
  RunDialogs
  RunObservers
  RunTimers
  InstallEvents
  RunAsyncApis
  RunMedia
  PushUrl
  ReplaceUrl
  HistoryBack
  HistoryForward
  ReloadUrl
  LoadUrl
}

///|
fn update(model : Model, message : Msg) -> Model {
  match message {
    RunNodes => { ..model, nodes: probe_nodes(), }
    RunCanvas => { ..model, canvas: probe_canvas(), }
    RunPlatform => { ..model, platform: probe_platform(), }
    RunDialogs => { ..model, dialogs: probe_dialogs(), }
    RunObservers => {
      probe_observers()
      { ..model, observers: "running", }
    }
    RunTimers => {
      probe_timers()
      { ..model, timers: "running", }
    }
    InstallEvents => {
      install_event_probes()
      { ..model, events: "ready", }
    }
    RunAsyncApis => {
      probe_async_apis()
      { ..model, async_apis: "running", }
    }
    RunMedia => { ..model, media: probe_media(), }
    PushUrl => {
      @dom.window().push_url("/dom-api-pushed")
      model
    }
    ReplaceUrl => {
      @dom.window().replace_url("/dom-api-replaced")
      model
    }
    HistoryBack => {
      @dom.window().history_go_back()
      model
    }
    HistoryForward => {
      @dom.window().history_go_forward()
      model
    }
    ReloadUrl => {
      @dom.window().reload_url()
      model
    }
    LoadUrl => {
      @dom.window().load_url("/dom-api-loaded")
      model
    }
  }
}

///|
fn app() -> Val[Html] {
  let initial : Model = {
    nodes: "idle",
    canvas: "idle",
    platform: "idle",
    dialogs: "idle",
    observers: "idle",
    timers: "idle",
    events: "idle",
    async_apis: "idle",
    media: "idle",
  }
  let (model, emit) = @rabbita.create_pure_state(initial, update~)
  model.view(model => {
    div <| [
      h1("DOM API browser probes"),
      button(on_click=emit(RunNodes), "Run node and element APIs"),
      p(id="nodes-result", model.nodes),
      button(on_click=emit(RunCanvas), "Run canvas APIs"),
      p(id="canvas-result", model.canvas),
      button(on_click=emit(RunPlatform), "Run platform APIs"),
      p(id="platform-result", model.platform),
      button(on_click=emit(RunDialogs), "Run dialog APIs"),
      p(id="dialogs-result", model.dialogs),
      button(on_click=emit(RunObservers), "Run observer APIs"),
      p(id="observers-result", model.observers),
      button(on_click=emit(RunTimers), "Run scheduling APIs"),
      p(id="timers-result", model.timers),
      button(on_click=emit(InstallEvents), "Install event API probes"),
      p(id="events-result", model.events),
      p(id="event-generic-result", "pending"),
      p(id="event-pointer-result", "pending"),
      p(id="event-fractional-pointer-result", "pending"),
      p(id="event-keyboard-result", "pending"),
      p(id="event-wheel-result", "pending"),
      p(id="event-subtypes-result", "pending"),
      div(id="event-target", "Event target"),
      button(id="key-target", "Keyboard event target"),
      input(id="input-target", value="before"),
      button(on_click=emit(RunAsyncApis), "Run blob and clipboard APIs"),
      p(id="async-result", model.async_apis),
      button(on_click=emit(RunMedia), "Run media APIs"),
      p(id="media-result", model.media),
      button(on_click=emit(PushUrl), "Push URL"),
      button(on_click=emit(ReplaceUrl), "Replace URL"),
      button(on_click=emit(HistoryBack), "History back"),
      button(on_click=emit(HistoryForward), "History forward"),
      button(on_click=emit(ReloadUrl), "Reload URL"),
      button(on_click=emit(LoadUrl), "Load URL"),
    ]
  })
}
