///|
using @rabbita {type Cmd, type Emit, type Html, type Val, delay, new, none}

///|
using @common {type Mouse, type Viewport}

///|
using @html {button, div, fragment, iframe, pre, span}

///|
let min_tab_left = 12

///|
let default_tab_left = 24

///|
let desktop_tab_width = 92

///|
let mobile_tab_width = 84

///|
let mobile_breakpoint = 560

///|
struct DragState {
  start_x : Int
  start_left : Int
  moved : Bool
} derive(Eq)

///|
enum DevStatus {
  Ready
  Building
  Reloading
  BuildFailed
} derive(Eq)

///|
struct Model {
  pinned : Bool
  hovered : Bool
  tab_left : Int
  viewport_width : Int
  reload_nonce : Int
  drag : DragState?
  auto_open : Bool
  listening : Bool
  reconnecting : Bool
  status : DevStatus
  build_diagnostics : String
} derive(Eq)

///|
enum Msg {
  HoverStarted
  HoverEnded
  TogglePinned
  DragStarted(Mouse)
  DragMoved(Mouse)
  DragEnded
  ViewportChanged(Viewport)
  SocketOpened
  SocketMessage(String)
  SocketClosed
  SocketErrored
  ReconnectTick
  PreviewSettled
}

///|
fn tab_width(viewport_width : Int) -> Int {
  if viewport_width <= mobile_breakpoint {
    mobile_tab_width
  } else {
    desktop_tab_width
  }
}

///|
fn clamp_tab_left(left : Int, viewport_width : Int) -> Int {
  let max_left = viewport_width - tab_width(viewport_width) - min_tab_left
  let max_left = if max_left < min_tab_left { min_tab_left } else { max_left }
  if left < min_tab_left {
    min_tab_left
  } else if left > max_left {
    max_left
  } else {
    left
  }
}

///|
fn dev_status_class(status : DevStatus) -> String {
  match status {
    Ready => "is-ready"
    Building => "is-building"
    Reloading => "is-reloading"
    BuildFailed => "is-build-failed"
  }
}

///|
fn dev_status_label(status : DevStatus) -> String {
  match status {
    Ready => "Ready"
    Building => "Building"
    Reloading => "Reloading"
    BuildFailed => "Build failed"
  }
}

///|
fn dev_status_is_loading(status : DevStatus) -> Bool {
  match status {
    Building | Reloading => true
    Ready | BuildFailed => false
  }
}

///|
fn panel_expanded(model : Model) -> Bool {
  model.pinned || model.hovered || model.auto_open || model.drag is Some(_)
}

///|
fn mouse_client_x(mouse : Mouse) -> Int {
  mouse.client_pos().x
}

///|
let build_failed_message = "build_failed"

///|
let build_failed_prefix = "build_failed\n"

///|
fn build_failed_diagnostics(message : String) -> String? {
  if message == build_failed_message {
    Some("moon build failed.")
  } else if message.has_prefix(build_failed_prefix) {
    Some(message[build_failed_prefix.length():].to_owned())
  } else {
    None
  }
}

///|
fn websocket_url() -> String {
  try @url.parse(@dom.window().current_url()) catch {
    _ => "ws://127.0.0.1:4300/__warren/events"
  } noraise {
    url => {
      let protocol = match url.protocol {
        @url.Https => "wss"
        _ => "ws"
      }
      let port = match url.port {
        Some(port) => ":\{port}"
        None => ""
      }
      "\{protocol}://\{url.host}\{port}/__warren/events"
    }
  }
}

///|
fn initial_model() -> Model {
  let viewport_width = @dom.window().inner_width()
  {
    pinned: false,
    hovered: false,
    tab_left: clamp_tab_left(default_tab_left, viewport_width),
    viewport_width,
    reload_nonce: 0,
    drag: None,
    auto_open: false,
    listening: true,
    reconnecting: false,
    status: Ready,
    build_diagnostics: "",
  }
}

///|
fn update(emit : Emit[Msg], msg : Msg, model : Model) -> (Cmd, Model) {
  match msg {
    HoverStarted => (none, { ..model, hovered: true })
    HoverEnded => (none, { ..model, hovered: false })
    TogglePinned => (none, { ..model, pinned: !model.pinned, hovered: true })
    DragStarted(mouse) => {
      let x = mouse_client_x(mouse)
      (
        none,
        {
          ..model,
          hovered: true,
          drag: Some({ start_x: x, start_left: model.tab_left, moved: false }),
        },
      )
    }
    DragMoved(mouse) =>
      match model.drag {
        Some(drag) => {
          let delta = mouse_client_x(mouse) - drag.start_x
          let moved = drag.moved || delta.abs() > 3
          let tab_left = clamp_tab_left(
            drag.start_left + delta,
            model.viewport_width,
          )
          (none, { ..model, tab_left, drag: Some({ ..drag, moved, }) })
        }
        None => (none, model)
      }
    DragEnded =>
      match model.drag {
        Some(_) => (none, { ..model, drag: None })
        None => (none, model)
      }
    ViewportChanged(viewport) => {
      let tab_left = clamp_tab_left(model.tab_left, viewport.width)
      (none, { ..model, tab_left, viewport_width: viewport.width })
    }
    SocketOpened => (none, { ..model, listening: true, reconnecting: false })
    SocketMessage("building") =>
      (
        none,
        { ..model, auto_open: false, status: Building, build_diagnostics: "" },
      )
    SocketMessage("reload") =>
      (
        delay(emit(PreviewSettled), 520),
        {
          ..model,
          auto_open: false,
          reload_nonce: model.reload_nonce + 1,
          status: Reloading,
          build_diagnostics: "",
        },
      )
    SocketMessage(message) =>
      match build_failed_diagnostics(message) {
        Some(diagnostics) =>
          (
            none,
            {
              ..model,
              auto_open: true,
              status: BuildFailed,
              build_diagnostics: diagnostics,
            },
          )
        None => (none, model)
      }
    SocketClosed | SocketErrored =>
      (none, { ..model, listening: false, reconnecting: true })
    ReconnectTick =>
      if model.reconnecting {
        (none, { ..model, listening: true, reconnecting: false })
      } else {
        (none, model)
      }
    PreviewSettled =>
      match model.status {
        Reloading =>
          (
            none,
            { ..model, auto_open: false, status: Ready, build_diagnostics: "" },
          )
        _ => (none, model)
      }
  }
}

///|
fn subscriptions(model : Model, emit : Emit[Msg]) -> @sub.Sub {
  let socket_sub = if model.listening {
    @websocket.listen(
      websocket_url(),
      open=emit(SocketOpened),
      message=emit.map(message => SocketMessage(message)),
      close=emit.map(_ => SocketClosed),
      error=emit(SocketErrored),
    )
  } else {
    @sub.none
  }
  let reconnect_sub = if model.reconnecting {
    @sub.every(1000, emit(ReconnectTick))
  } else {
    @sub.none
  }
  let drag_sub = match model.drag {
    Some(_) => @sub.on_mouse_move(emit.map(mouse => DragMoved(mouse)))
    None => @sub.none
  }
  @sub.batch([
    socket_sub,
    reconnect_sub,
    drag_sub,
    @sub.on_resize(emit.map(viewport => ViewportChanged(viewport))),
  ])
}

///|
fn drag_layer(emit : Emit[Msg], drag : Val[DragState?]) -> Val[Html] {
  drag.map(drag => match drag {
    Some(_) =>
      div(
        class="warren-devtool-drag-layer",
        on_mouseup=emit.map(_ => DragEnded),
        "",
      )
    None => @html.nothing
  })
}

///|
fn pin_icon() -> Html {
  @svg.svg(
    class="warren-devtool-pin-svg",
    view_box="0 0 24 24",
    attrs=@svg.Attrs::build().fill("none"),
    [
      @svg.path(
        d="M16 9V4l1 1V3H7v2l1-1v5l-2 2v2h5v7l1 1 1-1v-7h5v-2l-2-2z",
        fill="currentColor",
      ),
    ],
  )
}

///|
fn diagnostics_panel(status : DevStatus, build_diagnostics : String) -> Html {
  match status {
    BuildFailed =>
      pre(class="warren-devtool-diagnostics", build_diagnostics)
    _ => @html.nothing
  }
}

///|
fn preview_frame(model : Val[Model]) -> Val[Html] {
  model.map(model => {
  let preview_class = if dev_status_is_loading(model.status) {
    "warren-preview-frame is-loading"
  } else {
    "warren-preview-frame"
  }
    iframe(
      class=preview_class,
      title="Warren preview",
      src="/__warren/preview/index.html?warren_reload=\{model.reload_nonce}",
    )
  })
}

///|
fn hover_zone(emit : Emit[Msg], model : Val[Model]) -> Val[Html] {
  model.map(model => {
  let status_class = "warren-devtool-status \{dev_status_class(model.status)}"
  let tab_title = if model.pinned {
    "Drag Warren devtool"
  } else {
    "Hover to open Warren devtool"
  }
  let pin_title = if model.pinned {
    "Unpin Warren devtool"
  } else {
    "Pin Warren devtool"
  }
  let pin_button_class = if model.pinned {
    "warren-devtool-pin is-pinned"
  } else {
    "warren-devtool-pin"
  }
  let pin_attrs = @html.Attrs::build().aria_pressed(
    if model.pinned {
      "true"
    } else {
      "false"
    },
  )
  let hover_attrs = @html.Attrs::build()
    .on_mouseenter(_ => emit(HoverStarted))
    .on_mouseleave(_ => emit(HoverEnded))
    div(class="warren-devtool-hover-zone", attrs=hover_attrs) <| [
      div(
        class="warren-devtool-tab",
        title=tab_title,
        on_mousedown=emit.map(mouse => DragStarted(mouse)),
        on_mouseup=emit.map(_ => DragEnded),
      ) <| [
        span(class="warren-devtool-tab-indicator", ""),
        span(class="warren-devtool-tab-label", "Warren"),
      ],
      div(class="warren-devtool-drawer") <| [
        button(
          class=pin_button_class,
          title=pin_title,
          attrs=pin_attrs,
          on_click=emit(TogglePinned),
          pin_icon(),
        ),
        div(class="warren-devtool-body") <| [
          div(class=status_class) <| [
            span(dev_status_label(model.status)),
          ],
          diagnostics_panel(model.status, model.build_diagnostics),
        ],
      ],
    ]
  })
}

///|
fn view(emit : Emit[Msg], model : Val[Model]) -> Val[Html] {
  let root_class = model.map(model => {
    let expansion_class = if panel_expanded(model) {
      "is-expanded"
    } else {
      "is-collapsed"
    }
    let pin_class = if model.pinned { "is-pinned" } else { "is-unpinned" }
    let loading_class = if dev_status_is_loading(model.status) {
      "is-loading"
    } else {
      "is-idle"
    }
    "warren-devtool \{expansion_class} \{pin_class} \{dev_status_class(model.status)} \{loading_class}"
  })
  let root_style = model.map(model => {
    [
      "--warren-devtool-tab-left: \{clamp_tab_left(model.tab_left, model.viewport_width)}px",
      "--warren-devtool-tab-width: \{tab_width(model.viewport_width)}px",
    ]
  })
  let preview = preview_frame(model)
  let hover = hover_zone(emit, model)
  let drag = drag_layer(emit, model.map(model => model.drag))
  let children = preview.map3(hover, drag, (preview, hover, drag) => {
    fragment([preview, hover, drag])
  })
  root_class.map3(root_style, children, (root_class, root_style, children) => {
    div(class=root_class, style=root_style) <| [
      children,
    ]
  })
}

///|
fn main {
  fn app() {
    let (model, emit) = @rabbita.create_state(
      initial_model(),
      update=fn(model, msg, emit) {
        let (cmd, model) = update(emit, msg, model)
        (model, cmd)
      },
      subscriptions~,
    )
    view(emit, model)
  }
  new(app).mount("warren-devtool")
}
