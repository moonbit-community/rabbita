///|
using @rabbita {type Cmd, type Emit, type Html, type Resource, type Val}

///|
using @html {button, div, h1, p}

///|
fn update(model : Model, message : Msg, emit : Emit[Msg]) -> (Model, Cmd) {
  match message {
    StartGet =>
      (
        { ..model, get: "loading", },
        @http.get("/api/method/get").expect_text(
          emit.map(value => GetFinished(value)),
        ),
      )
    GetFinished(result) =>
      ({ ..model, get: result_text(result), }, @rabbita.none)
    StartPost =>
      (
        { ..model, post: "loading", },
        @http.post("/api/method/post")
        .with_json({ name: "rabbit", })
        .expect_text(emit.map(value => PostFinished(value))),
      )
    PostFinished(result) =>
      ({ ..model, post: result_text(result), }, @rabbita.none)
    StartPut =>
      (
        { ..model, put: "loading", },
        @http.put("/api/method/put")
        .with_text("put-body")
        .expect_text(emit.map(value => PutFinished(value))),
      )
    PutFinished(result) =>
      ({ ..model, put: result_text(result), }, @rabbita.none)
    StartPatch =>
      (
        { ..model, patch: "loading", },
        @http.patch("/api/method/patch")
        .with_text("patch-body")
        .expect_text(emit.map(value => PatchFinished(value))),
      )
    PatchFinished(result) =>
      ({ ..model, patch: result_text(result), }, @rabbita.none)
    StartDelete =>
      (
        { ..model, delete: "loading", },
        @http.delete("/api/method/delete").expect_empty(
          emit.map(value => DeleteFinished(value)),
        ),
      )
    DeleteFinished(error) =>
      (
        { ..model, delete: if error is None { "deleted" } else { "failed" }, },
        @rabbita.none,
      )
    StartText =>
      (
        { ..model, text: "loading", },
        @http.get("/api/decode/text").expect_text(
          emit.map(value => TextFinished(value)),
        ),
      )
    TextFinished(result) =>
      ({ ..model, text: result_text(result), }, @rabbita.none)
    StartJson =>
      (
        { ..model, json: "loading", },
        @http.get("/api/decode/json").expect_json(
          emit.map(value => JsonFinished(value)),
        ),
      )
    JsonFinished(result) =>
      (
        {
          ..model,
          json: match result {
            Ok(payload) => payload.value
            Err(_) => "failed"
          },
        },
        @rabbita.none,
      )
    StartBlob =>
      (
        { ..model, blob: "loading", },
        @http.get("/api/decode/blob").expect_blob(
          emit.map(value => BlobFinished(value)),
        ),
      )
    BlobFinished(result) =>
      (
        {
          ..model,
          blob: match result {
            Ok(blob) => "\{blob.get_type()}:\{blob.get_size()}"
            Err(_) => "failed"
          },
        },
        @rabbita.none,
      )
    StartBytes =>
      (
        { ..model, bytes: "loading", },
        @http.get("/api/decode/bytes").expect_bytes(
          emit.map(value => BytesFinished(value)),
        ),
      )
    BytesFinished(result) =>
      (
        {
          ..model,
          bytes: match result {
            Ok((content_type, bytes)) => "\{content_type}:\{bytes.length()}"
            Err(_) => "failed"
          },
        },
        @rabbita.none,
      )
    StartFailure =>
      (
        { ..model, failure: "loading", },
        @http.get("/api/failure").expect_text(
          emit.map(value => FailureFinished(value)),
        ),
      )
    FailureFinished(result) =>
      (
        {
          ..model,
          failure: match result {
            Ok(_) => "unexpected success"
            Err(_) => "failed"
          },
        },
        @rabbita.none,
      )
  }
}

///|
fn app() -> Val[Html] {
  let resource : Resource[String] = @rabbita.create_resource(inject => {
    @http.get("/api/resource").expect_text(inject)
  })
  let initial : Model = {
    get: "idle",
    post: "idle",
    put: "idle",
    patch: "idle",
    delete: "idle",
    text: "idle",
    json: "idle",
    blob: "idle",
    bytes: "idle",
    failure: "idle",
  }
  let (model, emit) = @rabbita.create_state(initial, update~)
  model.view2(resource, (model, resource) => {
    let resource_status = match resource {
      Pending => "pending"
      Loaded(value) => "loaded: \{value}"
      Failed(_) => "failed"
    }
    div <| [
      h1("HTTP"),
      button(on_click=emit(StartGet), "Send GET"),
      p(id="get-status", model.get),
      button(on_click=emit(StartPost), "Send POST"),
      p(id="post-status", model.post),
      button(on_click=emit(StartPut), "Send PUT"),
      p(id="put-status", model.put),
      button(on_click=emit(StartPatch), "Send PATCH"),
      p(id="patch-status", model.patch),
      button(on_click=emit(StartDelete), "Send DELETE"),
      p(id="delete-status", model.delete),
      button(on_click=emit(StartText), "Decode text"),
      p(id="text-status", model.text),
      button(on_click=emit(StartJson), "Decode JSON"),
      p(id="json-status", model.json),
      button(on_click=emit(StartBlob), "Decode blob"),
      p(id="blob-status", model.blob),
      button(on_click=emit(StartBytes), "Decode bytes"),
      p(id="bytes-status", model.bytes),
      button(on_click=emit(StartFailure), "Request failure"),
      p(id="failure-status", model.failure),
      p(id="resource-status", resource_status),
    ]
  })
}
