///|
using @html {button, code, div, fragment, h1, h2, input, nothing, p, textarea}

///|
using @rabbita {type Cmd, type Emit, type Html, type Val}

///|
using @websocket {type CloseInfo, type Event, type ReadyState, type Snapshot}

///|
struct ChatEntry {
  tone : String
  label : String
  body : String
} derive(Eq)

///|
enum Msg {
  UrlChanged(String)
  ProtocolsChanged(String)
  NicknameChanged(String)
  DraftChanged(String)
  ToggleListen
  ClearListenLog
  ListenOpened
  ListenMessage(String)
  ListenClosed(CloseInfo)
  ListenErrored
  ClientConnectRequested
  ClientDisconnectRequested
  ClientSendChat
  ClientSendRaw
  ClientRefreshState
  ClearTranscript
  ClientSocketEvent(Event)
  ClientFailed(String)
  ClientStateUpdated(Result[Snapshot, String])
}

///|
struct Model {
  url_input : String
  protocols_input : String
  nickname_input : String
  draft_input : String
  listening : Bool
  listen_status : String
  listen_open_count : Int
  listen_message_count : Int
  listen_close_count : Int
  listen_error_count : Int
  listen_last_message : String
  listen_last_close : String
  listen_log : Array[String]
  client_status : String
  client_open_count : Int
  client_message_count : Int
  client_close_count : Int
  client_error_count : Int
  client_last_error : String
  client_last_close : String
  client_ready_state : String
  client_protocol : String
  client_buffered_amount : Int
  client_socket_url : String
  client_state_note : String
  transcript : Array[ChatEntry]
} derive(Eq)

///|
fn command_socket_id() -> String {
  "chat-demo-client"
}

///|
fn normalized_url(url : String) -> String {
  url.trim().to_owned()
}

///|
fn normalized_nickname(name : String) -> String {
  let nickname = name.trim().to_owned()
  if nickname == "" {
    "guest"
  } else {
    nickname
  }
}

///|
fn trimmed_draft(draft : String) -> String {
  draft.trim().to_owned()
}

///|
fn parse_protocols(input : String) -> Array[String] {
  let protocols = []
  for part in input.split(",") {
    let protocol = part.trim().to_owned()
    if protocol != "" {
      protocols.push(protocol)
    }
  }
  protocols
}

///|
fn last_value(value : String) -> String {
  if value == "" {
    "-"
  } else {
    value
  }
}

///|
fn bool_label(value : Bool) -> String {
  if value {
    "true"
  } else {
    "false"
  }
}

///|
fn ready_state_label(state : ReadyState) -> String {
  match state {
    Connecting => "connecting"
    Open => "open"
    Closing => "closing"
    Closed => "closed"
  }
}

///|
fn close_summary(info : CloseInfo) -> String {
  "code=\{info.code} clean=\{bool_label(info.clean)} reason=\{last_value(info.reason)}"
}

///|
fn capped_prepend(
  xs : Array[String],
  value : String,
  limit : Int,
) -> Array[String] {
  let next = xs.copy()
  next.insert(0, value)
  if next.length() > limit {
    ignore(next.remove(next.length() - 1))
  }
  next
}

///|
fn capped_append(
  xs : Array[ChatEntry],
  value : ChatEntry,
  limit : Int,
) -> Array[ChatEntry] {
  let next = xs.copy()
  next.push(value)
  if next.length() > limit {
    ignore(next.remove(0))
  }
  next
}

///|
fn with_listen_log(model : Model, line : String) -> Model {
  { ..model, listen_log: capped_prepend(model.listen_log, line, 16) }
}

///|
fn with_transcript(
  model : Model,
  tone : String,
  label : String,
  body : String,
) -> Model {
  {
    ..model,
    transcript: capped_append(model.transcript, { tone, label, body }, 24),
  }
}

///|
fn status_class(status : String) -> String {
  match status {
    "open" => "status-chip is-open"
    "error" => "status-chip is-error"
    "connecting" | "reconnecting" | "closing" => "status-chip is-pending"
    _ => "status-chip is-idle"
  }
}

///|
fn stats_line(label : String, value : String) -> Html {
  div(class="stats-line") <| [
    code(class="stats-label", label),
    p(class="stats-value", value),
  ]
}

///|
fn command_can_send(model : Model) -> Bool {
  model.client_status == "open" && trimmed_draft(model.draft_input) != ""
}

///|
fn connect_cmd(emit : Emit[Msg], model : Model) -> Cmd {
  @websocket.connect(
    command_socket_id(),
    normalized_url(model.url_input),
    protocols=parse_protocols(model.protocols_input),
    on_event=emit.map(event => ClientSocketEvent(event)),
    failed=emit.map(message => ClientFailed(message)),
  )
}

///|
fn disconnect_cmd(emit : Emit[Msg]) -> Cmd {
  @websocket.close(
    command_socket_id(),
    code=1000,
    reason="user disconnect",
    failed=emit.map(message => ClientFailed(message)),
  )
}

///|
fn refresh_state_cmd(emit : Emit[Msg]) -> Cmd {
  @websocket.state(
    command_socket_id(),
    reply=emit.map(reply => ClientStateUpdated(reply)),
  )
}

///|
fn send_chat_cmd(emit : Emit[Msg], model : Model) -> Cmd {
  @websocket.send(
    command_socket_id(),
    Json({
      "kind": "chat",
      "user": normalized_nickname(model.nickname_input),
      "text": trimmed_draft(model.draft_input),
    }),
    failed=emit.map(message => ClientFailed(message)),
  )
}

///|
fn send_raw_cmd(emit : Emit[Msg], model : Model) -> Cmd {
  @websocket.send(
    command_socket_id(),
    Text(trimmed_draft(model.draft_input)),
    failed=emit.map(message => ClientFailed(message)),
  )
}

///|
fn decode_chat_message(raw : String) -> (String, String)? {
  try @json.parse(raw) catch {
    _ => None
  } noraise {
    parsed =>
      match parsed {
        Object(fields) =>
          match fields.get("kind") {
            Some(String(kind)) =>
              if kind == "chat" {
                match fields.get("user") {
                  Some(String(user)) =>
                    match fields.get("text") {
                      Some(String(text)) => Some((user, text))
                      _ => None
                    }
                  _ => None
                }
              } else {
                None
              }
            _ => None
          }
        _ => None
      }
  }
}

///|
fn update(emit : Emit[Msg], msg : Msg, model : Model) -> (Cmd, Model) {
  match msg {
    UrlChanged(url) => {
      let next = { ..model, url_input: url }
      let next = if model.listening {
        { ..next, listen_status: "reconnecting" }
      } else {
        next
      }
      (@rabbita.none, next)
    }
    ProtocolsChanged(protocols) => {
      let next = { ..model, protocols_input: protocols }
      let next = if model.listening {
        { ..next, listen_status: "reconnecting" }
      } else {
        next
      }
      (@rabbita.none, next)
    }
    NicknameChanged(nickname) =>
      (@rabbita.none, { ..model, nickname_input: nickname })
    DraftChanged(draft) => (@rabbita.none, { ..model, draft_input: draft })
    ToggleListen => {
      let url = normalized_url(model.url_input)
      if model.listening {
        (
          @rabbita.none,
          with_listen_log(
            { ..model, listening: false, listen_status: "idle" },
            "listen -> removed subscription",
          ),
        )
      } else if url == "" {
        (
          @rabbita.none,
          with_listen_log(
            { ..model, listen_status: "missing url" },
            "listen -> ignored because url is empty",
          ),
        )
      } else {
        (
          @rabbita.none,
          with_listen_log(
            { ..model, listening: true, listen_status: "connecting" },
            "listen -> install subscription for \{url}",
          ),
        )
      }
    }
    ClearListenLog => (@rabbita.none, { ..model, listen_log: [] })
    ListenOpened =>
      (
        @rabbita.none,
        with_listen_log(
          {
            ..model,
            listen_status: "open",
            listen_open_count: model.listen_open_count + 1,
          },
          "listen -> open",
        ),
      )
    ListenMessage(text) =>
      (
        @rabbita.none,
        with_listen_log(
          {
            ..model,
            listen_status: "open",
            listen_message_count: model.listen_message_count + 1,
            listen_last_message: text,
          },
          "listen -> message \{text}",
        ),
      )
    ListenClosed(info) => {
      let summary = close_summary(info)
      (
        @rabbita.none,
        with_listen_log(
          {
            ..model,
            listening: false,
            listen_status: "closed",
            listen_close_count: model.listen_close_count + 1,
            listen_last_close: summary,
          },
          "listen -> close \{summary}",
        ),
      )
    }
    ListenErrored =>
      (
        @rabbita.none,
        with_listen_log(
          {
            ..model,
            listen_status: "error",
            listen_error_count: model.listen_error_count + 1,
          },
          "listen -> error",
        ),
      )
    ClientConnectRequested => {
      let url = normalized_url(model.url_input)
      if url == "" {
        (
          @rabbita.none,
          with_transcript(
            { ..model, client_last_error: "client connect ignored: empty url" },
            "error",
            "client",
            "connect ignored because url is empty",
          ),
        )
      } else {
        (
          @rabbita.batch([connect_cmd(emit, model), refresh_state_cmd(emit)]),
          with_transcript(
            {
              ..model,
              client_status: "connecting",
              client_last_error: "",
              client_last_close: "",
              client_socket_url: url,
              client_state_note: "awaiting open event",
            },
            "system",
            "client",
            "connect -> \{url}",
          ),
        )
      }
    }
    ClientDisconnectRequested =>
      (
        disconnect_cmd(emit),
        with_transcript(
          {
            ..model,
            client_status: "closing",
            client_state_note: "close requested",
          },
          "system",
          "client",
          "close requested",
        ),
      )
    ClientSendChat => {
      let text = trimmed_draft(model.draft_input)
      if !command_can_send(model) {
        (
          @rabbita.none,
          with_transcript(
            model, "error", "client", "chat send ignored because the socket is not open or the draft is empty",
          ),
        )
      } else {
        let sent_model = with_transcript(
          { ..model, draft_input: "" },
          "self",
          normalized_nickname(model.nickname_input),
          text,
        )
        (
          @rabbita.batch([send_chat_cmd(emit, model), refresh_state_cmd(emit)]),
          sent_model,
        )
      }
    }
    ClientSendRaw => {
      let text = trimmed_draft(model.draft_input)
      if !command_can_send(model) {
        (
          @rabbita.none,
          with_transcript(
            model, "error", "client", "raw send ignored because the socket is not open or the draft is empty",
          ),
        )
      } else {
        let sent_model = with_transcript(
          { ..model, draft_input: "" },
          "self",
          "raw",
          text,
        )
        (
          @rabbita.batch([send_raw_cmd(emit, model), refresh_state_cmd(emit)]),
          sent_model,
        )
      }
    }
    ClientRefreshState => (refresh_state_cmd(emit), model)
    ClearTranscript => (@rabbita.none, { ..model, transcript: [] })
    ClientSocketEvent(event) =>
      match event {
        Opened =>
          (
            refresh_state_cmd(emit),
            with_transcript(
              {
                ..model,
                client_status: "open",
                client_open_count: model.client_open_count + 1,
              },
              "system",
              "client",
              "open",
            ),
          )
        Message(text) => {
          let next = {
            ..model,
            client_status: "open",
            client_message_count: model.client_message_count + 1,
          }
          let next = match decode_chat_message(text) {
            Some((user, body)) => with_transcript(next, "echo", user, body)
            None => with_transcript(next, "echo", "raw echo", text)
          }
          (refresh_state_cmd(emit), next)
        }
        Closed(info) => {
          let summary = close_summary(info)
          (
            refresh_state_cmd(emit),
            with_transcript(
              {
                ..model,
                client_status: "closed",
                client_close_count: model.client_close_count + 1,
                client_last_close: summary,
                client_state_note: "close event received",
              },
              "system",
              "close",
              summary,
            ),
          )
        }
        Errored =>
          (
            refresh_state_cmd(emit),
            with_transcript(
              {
                ..model,
                client_status: "error",
                client_error_count: model.client_error_count + 1,
                client_last_error: "browser error event",
              },
              "error",
              "client",
              "browser error event",
            ),
          )
      }
    ClientFailed(message) =>
      (
        @rabbita.none,
        with_transcript(
          { ..model, client_status: "error", client_last_error: message },
          "error",
          "client",
          message,
        ),
      )
    ClientStateUpdated(reply) =>
      match reply {
        Ok(snapshot) =>
          (
            @rabbita.none,
            {
              ..model,
              client_ready_state: ready_state_label(snapshot.ready_state),
              client_protocol: last_value(snapshot.protocol),
              client_buffered_amount: snapshot.buffered_amount,
              client_socket_url: snapshot.url,
              client_state_note: "state ok for \{snapshot.id}",
            },
          )
        Err(message) =>
          (
            @rabbita.none,
            {
              ..model,
              client_ready_state: "-",
              client_protocol: "-",
              client_buffered_amount: 0,
              client_socket_url: last_value(normalized_url(model.url_input)),
              client_state_note: message,
            },
          )
      }
  }
}

///|
fn subscriptions(model : Model, emit : Emit[Msg]) -> @sub.Sub {
  let url = normalized_url(model.url_input)
  if model.listening && url != "" {
    @websocket.listen(
      url,
      protocols=parse_protocols(model.protocols_input),
      open=emit(ListenOpened),
      message=emit.map(text => ListenMessage(text)),
      close=emit.map(info => ListenClosed(info)),
      error=emit(ListenErrored),
    )
  } else {
    @sub.none
  }
}

///|
fn transcript_entry(entry : ChatEntry) -> Html {
  div(class="chat-entry tone-\{entry.tone}") <| [
    div(class="chat-meta") <| [
      p(class="chat-author", entry.label),
    ],
    p(class="chat-body", entry.body),
  ]
}

///|
struct SharedConfigModel {
  url_input : String
  protocols_input : String
  nickname_input : String
} derive(Eq)

///|
struct ListenPanelModel {
  url_input : String
  listening : Bool
  listen_status : String
  listen_open_count : Int
  listen_message_count : Int
  listen_close_count : Int
  listen_error_count : Int
  listen_last_message : String
  listen_last_close : String
  listen_log : Array[String]
} derive(Eq)

///|
struct ClientPanelModel {
  url_input : String
  nickname_input : String
  draft_input : String
  client_status : String
  client_open_count : Int
  client_message_count : Int
  client_close_count : Int
  client_error_count : Int
  client_last_error : String
  client_last_close : String
  client_ready_state : String
  client_protocol : String
  client_buffered_amount : Int
  client_socket_url : String
  client_state_note : String
} derive(Eq)

///|
struct TranscriptPanelModel {
  transcript : Array[ChatEntry]
} derive(Eq)

///|
fn client_can_send(model : ClientPanelModel) -> Bool {
  model.client_status == "open" && trimmed_draft(model.draft_input) != ""
}

///|
fn client_connecting(status : String) -> Bool {
  match status {
    "connecting" | "open" | "closing" => true
    _ => false
  }
}

///|
fn shared_config_panel(
  emit : Emit[Msg],
  model : Val[SharedConfigModel],
) -> Val[Html] {
  model.map(model => {
    div(class="panel controls panel-wide") <| [
      h2(class="panel-title", "shared config"),
      div(class="shared-grid") <| [
        div(class="field") <| [
          p(class="field-label", "URL"),
          input(
            class="field-input",
            value=model.url_input,
            placeholder="wss://example.com/socket",
            on_input=emit.map(url => UrlChanged(url)),
          ),
        ],
        div(class="field") <| [
          p(class="field-label", "Protocols"),
          input(
            class="field-input",
            value=model.protocols_input,
            placeholder="chat, superchat",
            on_input=emit.map(protocols => ProtocolsChanged(protocols)),
          ),
        ],
        div(class="field") <| [
          p(class="field-label", "Nickname"),
          input(
            class="field-input",
            value=model.nickname_input,
            placeholder="guest",
            on_input=emit.map(nickname => NicknameChanged(nickname)),
          ),
        ],
      ],
    ]
  })
}

///|
fn listen_panel(emit : Emit[Msg], model : Val[ListenPanelModel]) -> Val[Html] {
  model.map(model => {
    let url_missing = normalized_url(model.url_input) == ""
    let listen_button = if model.listening {
      "stop listen"
    } else {
      "start listen"
    }
    div(class="panel controls") <| [
      h2(class="panel-title", "listen watcher"),
      div(class=status_class(model.listen_status), model.listen_status),
      div(class="actions") <| [
        button(
          class="primary",
          disabled=url_missing,
          on_click=emit(ToggleListen),
          listen_button,
        ),
        button(
          class="ghost",
          on_click=emit(ClearListenLog),
          "clear watcher log",
        ),
      ],
      div(class="stats-grid") <| [
        stats_line("open_count", "\{model.listen_open_count}"),
        stats_line("message_count", "\{model.listen_message_count}"),
        stats_line("close_count", "\{model.listen_close_count}"),
        stats_line("error_count", "\{model.listen_error_count}"),
        stats_line("last_message", last_value(model.listen_last_message)),
        stats_line("last_close", last_value(model.listen_last_close)),
      ],
      if model.listen_log.is_empty() {
        p(class="empty", "-")
      } else {
        div(class="log-list") <| model.listen_log.map(line => {
          div(class="log-line", code(line))
        })
      },
    ]
  })
}

///|
fn client_panel(emit : Emit[Msg], model : Val[ClientPanelModel]) -> Val[Html] {
  model.map(model => {
    let url_missing = normalized_url(model.url_input) == ""
    let connect_button = if client_connecting(model.client_status) {
      "reconnect client"
    } else {
      "connect client"
    }
    div(class="panel controls") <| [
      h2(class="panel-title", "cmd chat client"),
      div(class=status_class(model.client_status), model.client_status),
      div(class="actions") <| [
        button(
          class="primary",
          disabled=url_missing,
          on_click=emit(ClientConnectRequested),
          connect_button,
        ),
        button(
          class="secondary",
          disabled=!client_connecting(model.client_status),
          on_click=emit(ClientDisconnectRequested),
          "disconnect client",
        ),
        button(
          class="ghost",
          on_click=emit(ClientRefreshState),
          "refresh state",
        ),
      ],
      div(class="stats-grid") <| [
        stats_line("open_count", "\{model.client_open_count}"),
        stats_line("message_count", "\{model.client_message_count}"),
        stats_line("close_count", "\{model.client_close_count}"),
        stats_line("error_count", "\{model.client_error_count}"),
        stats_line("ready_state", model.client_ready_state),
        stats_line("protocol", model.client_protocol),
        stats_line("buffered_amount", "\{model.client_buffered_amount}"),
        stats_line("socket_url", model.client_socket_url),
        stats_line("state_note", model.client_state_note),
        stats_line("last_error", last_value(model.client_last_error)),
        stats_line("last_close", last_value(model.client_last_close)),
      ],
      div(class="field") <| [
        p(class="field-label", "Draft"),
        textarea(
          class="field-input composer-input",
          rows=4,
          value=model.draft_input,
          placeholder="Type a chat message or raw frame",
          on_input=emit.map(draft => DraftChanged(draft)),
          nothing,
        ),
      ],
      div(class="actions") <| [
        button(
          class="primary",
          disabled=!client_can_send(model),
          on_click=emit(ClientSendChat),
          "send chat json",
        ),
        button(
          class="secondary",
          disabled=!client_can_send(model),
          on_click=emit(ClientSendRaw),
          "send raw text",
        ),
        button(
          class="ghost",
          on_click=emit(ClearTranscript),
          "clear transcript",
        ),
      ],
    ]
  })
}

///|
fn transcript_panel(model : Val[TranscriptPanelModel]) -> Val[Html] {
  model.map(model => {
    div(class="panel log-panel panel-wide") <| [
      h2(class="panel-title", "transcript"),
      if model.transcript.is_empty() {
        p(class="empty", "-")
      } else {
        div(class="transcript-list") <| model.transcript.map(entry => {
          transcript_entry(entry)
        })
      },
    ]
  })
}

///|
fn view(emit : Emit[Msg], model : Val[Model]) -> Val[Html] {
  let shared = model.map(model => {
    url_input: model.url_input,
    protocols_input: model.protocols_input,
    nickname_input: model.nickname_input,
  })
  let listen = model.map(model => {
    url_input: model.url_input,
    listening: model.listening,
    listen_status: model.listen_status,
    listen_open_count: model.listen_open_count,
    listen_message_count: model.listen_message_count,
    listen_close_count: model.listen_close_count,
    listen_error_count: model.listen_error_count,
    listen_last_message: model.listen_last_message,
    listen_last_close: model.listen_last_close,
    listen_log: model.listen_log,
  })
  let client = model.map(model => {
    url_input: model.url_input,
    nickname_input: model.nickname_input,
    draft_input: model.draft_input,
    client_status: model.client_status,
    client_open_count: model.client_open_count,
    client_message_count: model.client_message_count,
    client_close_count: model.client_close_count,
    client_error_count: model.client_error_count,
    client_last_error: model.client_last_error,
    client_last_close: model.client_last_close,
    client_ready_state: model.client_ready_state,
    client_protocol: model.client_protocol,
    client_buffered_amount: model.client_buffered_amount,
    client_socket_url: model.client_socket_url,
    client_state_note: model.client_state_note,
  })
  let transcript = model.map(model => { transcript: model.transcript })
  let shared = shared_config_panel(emit, shared)
  let listen = listen_panel(emit, listen)
  let client = client_panel(emit, client)
  let transcript = transcript_panel(transcript)
  let lower = client.map2(transcript, (client, transcript) => {
    fragment([client, transcript])
  })
  let layout = shared.map3(listen, lower, (shared, listen, lower) => {
    div(class="layout") <| [
      shared, listen, lower,
    ]
  })
  layout.map(layout => {
    div(class="page") <| [
      div(class="hero") <| [
        h1(class="title", "websocket chat demo"),
      ],
      layout,
    ]
  })
}

///|
let initial_model : Model = {
  url_input: "wss://echo-websocket.fly.dev",
  protocols_input: "",
  nickname_input: "rabbit",
  draft_input: "",
  listening: false,
  listen_status: "idle",
  listen_open_count: 0,
  listen_message_count: 0,
  listen_close_count: 0,
  listen_error_count: 0,
  listen_last_message: "",
  listen_last_close: "",
  listen_log: [],
  client_status: "idle",
  client_open_count: 0,
  client_message_count: 0,
  client_close_count: 0,
  client_error_count: 0,
  client_last_error: "",
  client_last_close: "",
  client_ready_state: "-",
  client_protocol: "-",
  client_buffered_amount: 0,
  client_socket_url: "-",
  client_state_note: "not connected",
  transcript: [],
}

///|
#cfg(target="js")
fn main {
  fn app() {
    let (model, emit) = @rabbita.create_state(
      initial_model,
      update=fn(model, msg, emit) {
        let (cmd, model) = update(emit, msg, model)
        (model, cmd)
      },
      subscriptions~,
    )
    view(emit, model)
  }
  @rabbita.new(app).mount("app")
}
