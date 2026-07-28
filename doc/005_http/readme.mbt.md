# Using HTTP

HTTP requests are commands. They start in `update`, return immediately, and
later send a normal message back into the same update loop.

This chapter uses two small examples: one request that loads text with `GET`,
and one request that sends text with `POST`. The goal is to show the shape of
the flow, not every HTTP option.

## GET: load a greeting

### Add loading state to the model

```moonbit check
///|
enum Model {
  Idle
  Loading
  Ready(String)
  Failed(Error)
}

///|
let initial_model : Model = Idle
```

The model says what the page should show. There is no hidden loading flag inside
the HTTP package.

### Describe the request and response messages

```moonbit check
///|
enum Msg {
  Load
  Loaded(Result[String, Error])
}
```

`Load` is a user intention. `Loaded` is the result that arrives later.

### Return the request command from `update`

Use `@rabbita.create_state` when `update` needs to return both a command and a
new model.

```moonbit check
///|
fn update(emit : Emit[Msg], msg : Msg, _model : Model) -> (Cmd, Model) {
  match msg {
    Load =>
      (
        @http.get("/api/greeting").expect_text(result => emit(Loaded(result))),
        Loading,
      )
    Loaded(Ok(s)) => (none, Ready(s))
    Loaded(Err(e)) => (none, Failed(e))
  }
}
```

The important detail is the callback passed to `expect_text`: it only turns the
HTTP result into `Loaded`. The state change still happens in `update`, when the
`Loaded` message is handled.

`get` starts a request without a body. `expect_text` finishes it by choosing how
the response should be read and which message should receive the result. For
structured data, use `expect_json`; for files or binary data, use `expect_blob`
or `expect_bytes`; when the response body does not matter, use `expect_empty`.

### Render the states

```moonbit check
///|
fn view(emit : Emit[Msg], model : Model) -> Html {
  div([
    button(on_click=emit(Load), "Load greeting"),
    match model {
      Idle => p("Nothing loaded yet.")
      Loading => p("Loading...")
      Ready(text) => p(text)
      Failed(message) => p("Request failed: \{message}")
    },
  ])
}
```

Now the page follows the usual Rabbita loop:

```text
click button
  -> Load
  -> update returns an HTTP Cmd and Loading
  -> runtime runs the request
  -> Loaded(result)
  -> update stores Ready(...) or Failed(...)
```

### Build the GET app

```moonbit nocheck
///|
fn build_app() -> Val[Html] {
  let (model, emit) = @rabbita.create_state(initial_model, update=fn(
    model,
    msg,
    emit,
  ) {
    let (cmd, model) = update(emit, msg, model)
    (model, cmd)
  })
  model.map(model => view(emit, model))
}
```

Mount it the same way as earlier chapters:

```moonbit nocheck
///|
fn main {
  @rabbita.new(build_app).mount("main")
}
```

## POST: send a greeting

POST follows the same command flow. The difference is that the request also
includes a body, and this example only cares whether the server accepted it.

```moonbit check
///|
enum SaveModel {
  NotSaved
  Saving
  SaveDone
  SaveError(Error)
}

///|
let save_initial_model : SaveModel = NotSaved

///|
enum SaveMsg {
  SaveGreeting
  GreetingSaved(Error?)
}
```

`GreetingSaved(None)` means the request finished successfully.
`GreetingSaved(Some(error))` means the command failed.

```moonbit check
///|
fn save_update(
  emit : Emit[SaveMsg],
  msg : SaveMsg,
  _model : SaveModel,
) -> (Cmd, SaveModel) {
  match msg {
    SaveGreeting =>
      (
        @http.post("/api/greeting")
        .with_text("hello from Rabbita")
        .expect_empty(result => emit(GreetingSaved(result))),
        Saving,
      )
    GreetingSaved(None) => (none, SaveDone)
    GreetingSaved(Some(error)) => (none, SaveError(error))
  }
}
```

The POST body is built before `expect_empty`. The response still comes back as a
message, and the model still changes only in `update`.

Body helpers follow the same pattern. Use `with_text` for plain text,
`with_json` for JSON values, and `with_bytes` or `with_blob` for file-like
payloads. The same body helpers are available on `post`, `patch`, and `put`.
Use `delete` for body-less delete requests.

```moonbit check
///|
fn save_view(emit : Emit[SaveMsg], model : SaveModel) -> Html {
  div([
    button(on_click=emit(SaveGreeting), "Save greeting"),
    match model {
      NotSaved => p("Nothing saved yet.")
      Saving => p("Saving...")
      SaveDone => p("Saved.")
      SaveError(error) => p("Save failed: \{error}")
    },
  ])
}
```

```moonbit nocheck
///|
fn build_save_app() -> Val[Html] {
  let (model, emit) = @rabbita.create_state(save_initial_model, update=fn(
    model,
    msg,
    emit,
  ) {
    let (cmd, model) = save_update(emit, msg, model)
    (model, cmd)
  })
  model.map(model => save_view(emit, model))
}
```

## Practical guidance

- Start requests from `update`, not from `view`.
- Keep `expect_*` callbacks short; usually they only call `emit(...)`.
- Store loading, success, and failure in the model.
- Use JSON decoding when the response is data, and plain text for simple text endpoints.

For exact signatures and all variants, see the full [HTTP API manual](https://mooncakes.io/docs/moonbit-community/rabbita/http).
