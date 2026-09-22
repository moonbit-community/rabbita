///|
using @cmd {type Cmd, type Emit}

///|
using @dom {type Blob}

///|
using @json {trait FromJson}

///|
/// Raw value of an HTTP `Content-Type` header.
pub type ContentType = String

///|
struct Request((Expecting) -> @cmd.Extension)

///|
struct RequestWithBody((Body, Expecting) -> @cmd.Extension)

///|
/// Encode `x` as JSON and attach it to the request body.
/// 
/// ```mbt nocheck
/// @http.post("api/user").with_json(payload).expect_empty(x => emit(UserCreated(x)))
/// ```
pub fn[T : ToJson] RequestWithBody::with_json(
  self : RequestWithBody,
  x : T,
) -> Request {
  Request(expect => self(Json(x.to_json()), expect))
}

///|
/// Attach plain text to the request body.
/// 
/// ```mbt nocheck
/// @http.post("api/raw").with_text("hello").expect_text(x => emit(Sent(x)))
/// ```
pub fn RequestWithBody::with_text(
  self : RequestWithBody,
  x : String,
) -> Request {
  Request(expect => self(Text(x), expect))
}

///|
/// Attach raw bytes to the request body.
///
/// `content_type` is used as the request `Content-Type` header.
///
/// ```mbt nocheck
/// @http.post("api/file").with_bytes("application/pdf", data).expect_empty(x => emit(FileSent(x)))
/// ```
pub fn RequestWithBody::with_bytes(
  self : RequestWithBody,
  content_type : ContentType,
  x : Bytes,
) -> Request {
  Request(expect => self(BytesBody(content_type, x), expect))
}

///|
/// Attach a blob to the request body.
///
/// The request `Content-Type` header is taken from `x.get_type()`.
///
/// ```mbt nocheck
/// @http.post("api/file").with_blob(file).expect_empty(x => emit(FileSent(x)))
/// ```
pub fn RequestWithBody::with_blob(self : RequestWithBody, x : Blob) -> Request {
  Request(expect => self(BlobBody(x.get_type(), x), expect))
}

///|
/// Expect a message with a `Result[T, Error]` payload.
/// 
/// On success, the result contains `T`; on failure, it contains an `Error`.
/// The response body is parsed as JSON and decoded into `T`.
/// If `with_json`, `with_text`, `with_bytes`, or `with_blob` is not called
/// first, the request is sent with an empty body.
/// 
/// ```mbt nocheck
/// @http.post("api/ping").expect_json(x => emit(PingLoaded(x)))
/// ```
/// 
/// It is recommended to process the decoded value when handling the
/// `PingLoaded` message in `update`, rather than in the callback.
/// **Keep the callback passed to `expect_json` short and clean.**
/// 
/// ### Anti-pattern:
/// - embedding logic in the callback
///     ```mbt nocheck
///     @http.post("api/ping").expect_json(result => {
///       let processed = process(result)
///       emit(PingLoaded(processed))
///     })
///     ```
/// - ignoring the returned `Cmd`
///     ```
///     @http.post("api/ping").expect_json(x => emit(PingLoaded(x))) |> ignore
///     ```
pub fn[T : FromJson] RequestWithBody::expect_json(
  self : RequestWithBody,
  msg : Emit[Result[T, Error]],
) -> Cmd {
  Request(expect => self(Empty, expect)).expect_json(msg)
}

///|
/// Expect a message with a `Result[Blob, Error]` payload.
/// 
/// On success, the result contains `Blob`; on failure, it contains an `Error`.
/// The response body is returned as a `Blob`.
/// If `with_json`, `with_text`, `with_bytes`, or `with_blob` is not called
/// first, the request is sent with an empty body.
/// 
/// ```mbt nocheck
/// @http.post("api/file").expect_blob(x => emit(FileLoaded(x)))
/// ```
/// 
/// It is recommended to process the blob when handling the `FileLoaded`
/// message in `update`, rather than in the callback.
/// **Keep the callback passed to `expect_blob` short and clean.**
/// 
/// ### Anti-pattern:
/// - embedding logic in the callback
///     ```mbt nocheck
///     @http.post("api/file").expect_blob(result => {
///       let processed = process(result)
///       emit(FileLoaded(processed))
///     })
///     ```
/// - ignoring the returned `Cmd`
///     ```
///     @http.post("api/file").expect_blob(x => emit(FileLoaded(x))) |> ignore
///     ```
pub fn RequestWithBody::expect_blob(
  self : RequestWithBody,
  msg : Emit[Result[Blob, Error]],
) -> Cmd {
  Request(expect => self(Empty, expect)).expect_blob(msg)
}

///|
/// Expect a message with a `Result[(ContentType, Bytes), Error]` payload.
/// 
/// On success, the result contains the response `Content-Type` and raw bytes;
/// on failure, it contains an `Error`.
/// If `with_json`, `with_text`, `with_bytes`, or `with_blob` is not called
/// first, the request is sent with an empty body.
/// 
/// ```mbt nocheck
/// @http.post("api/file").expect_bytes(x => emit(FileBytesLoaded(x)))
/// ```
/// 
/// It is recommended to process the bytes when handling the
/// `FileBytesLoaded` message in `update`, rather than in the callback.
/// **Keep the callback passed to `expect_bytes` short and clean.**
/// 
/// ### Anti-pattern:
/// - embedding logic in the callback
///     ```mbt nocheck
///     @http.post("api/file").expect_bytes(result => {
///       let processed = process(result)
///       emit(FileBytesLoaded(processed))
///     })
///     ```
/// - ignoring the returned `Cmd`
///     ```
///     @http.post("api/file").expect_bytes(x => emit(FileBytesLoaded(x))) |> ignore
///     ```
pub fn RequestWithBody::expect_bytes(
  self : RequestWithBody,
  msg : Emit[Result[(ContentType, Bytes), Error]],
) -> Cmd {
  Request(expect => self(Empty, expect)).expect_bytes(msg)
}

///|
/// Expect a message with a `Result[String, Error]` payload.
/// 
/// On success, the result contains `String`; on failure, it contains an
/// `Error`. The response body is returned as plain text.
/// If `with_json`, `with_text`, `with_bytes`, or `with_blob` is not called
/// first, the request is sent with an empty body.
/// 
/// ```mbt nocheck
/// @http.post("api/ping").expect_text(x => emit(PingTextLoaded(x)))
/// ```
/// 
/// It is recommended to process the text when handling the
/// `PingTextLoaded` message in `update`, rather than in the callback.
/// **Keep the callback passed to `expect_text` short and clean.**
/// 
/// ### Anti-pattern:
/// - embedding logic in the callback
///     ```mbt nocheck
///     @http.post("api/ping").expect_text(result => {
///       let processed = process(result)
///       emit(PingTextLoaded(processed))
///     })
///     ```
/// - ignoring the returned `Cmd`
///     ```
///     @http.post("api/ping").expect_text(x => emit(PingTextLoaded(x))) |> ignore
///     ```
pub fn RequestWithBody::expect_text(
  self : RequestWithBody,
  msg : Emit[Result[String, Error]],
) -> Cmd {
  Request(expect => self(Empty, expect)).expect_text(msg)
}

///|
/// Expect a message with an `Error?` payload.
/// 
/// On success, the result is `None`; on failure, it is `Some(error)`.
/// The response body is ignored.
/// If `with_json`, `with_text`, `with_bytes`, or `with_blob` is not called
/// first, the request is sent with an empty body.
/// 
/// ```mbt nocheck
/// @http.post("api/ping").expect_empty(x => emit(PingFinished(x)))
/// ```
/// 
/// It is recommended to handle the success or failure state when handling the
/// `PingFinished` message in `update`, rather than in the callback.
/// **Keep the callback passed to `expect_empty` short and clean.**
/// 
/// ### Anti-pattern:
/// - embedding logic in the callback
///     ```mbt nocheck
///     @http.post("api/ping").expect_empty(result => {
///       let status = result.is_none()
///       emit(PingStatus(status))
///     })
///     ```
/// - ignoring the returned `Cmd`
///     ```
///     @http.post("api/ping").expect_empty(x => emit(PingFinished(x))) |> ignore
///     ```
pub fn RequestWithBody::expect_empty(
  self : RequestWithBody,
  msg : Emit[Error?],
) -> Cmd {
  Request(expect => self(Empty, expect)).expect_empty(msg)
}

///|
/// Expect a message with a `Result[T, Error]` payload.
/// 
/// On success, the result contains `T`; on failure, it contains an `Error`.
/// The response body is parsed as JSON and decoded into `T`.
/// 
/// ```mbt nocheck
/// @http.get("api/user").expect_json(x => emit(UserLoaded(x)))
/// ```
/// 
/// It is recommended to process the decoded value when handling the
/// `UserLoaded` message in `update`, rather than in the callback.
/// **Keep the callback passed to `expect_json` short and clean.**
/// 
/// ### Anti-pattern:
/// - embedding logic in the callback
///     ```mbt nocheck
///     @http.get("api/user").expect_json(result => {
///       let processed = process(result)
///       emit(UserLoaded(processed))
///     })
///     ```
/// - ignoring the returned `Cmd`
///     ```
///     @http.get("api/user").expect_json(x => emit(UserLoaded(x))) |> ignore
///     ```
pub fn[T : FromJson] Request::expect_json(
  self : Request,
  msg : Emit[Result[T, Error]],
) -> Cmd {
  op.request(
    self(
      Json(result => {
        match result {
          Ok(json) =>
            try @json.from_json(json) catch {
              error => msg(Err(error))
            } noraise {
              value => msg(Ok(value))
            }
          Err(error) => msg(Err(error))
        }
      }),
    ),
  )
}

///|
/// Expect a message with a `Result[Blob, Error]` payload.
/// 
/// On success, the result contains `Blob`; on failure, it contains an `Error`.
/// The response body is returned as a `Blob`.
/// 
/// ```mbt nocheck
/// @http.get("api/file").expect_blob(x => emit(FileLoaded(x)))
/// ```
/// 
/// It is recommended to process the blob when handling the `FileLoaded`
/// message in `update`, rather than in the callback.
/// **Keep the callback passed to `expect_blob` short and clean.**
/// 
/// ### Anti-pattern:
/// - embedding logic in the callback
///     ```mbt nocheck
///     @http.get("api/file").expect_blob(result => {
///       let processed = process(result)
///       emit(FileLoaded(processed))
///     })
///     ```
/// - ignoring the returned `Cmd`
///     ```
///     @http.get("api/file").expect_blob(x => emit(FileLoaded(x))) |> ignore
///     ```
pub fn Request::expect_blob(
  self : Request,
  msg : Emit[Result[Blob, Error]],
) -> Cmd {
  op.request(
    self(
      Blob(result => {
        match result {
          Ok(blob) => msg(Ok(blob))
          Err(error) => msg(Err(error))
        }
      }),
    ),
  )
}

///|
/// Expect a message with a `Result[(ContentType, Bytes), Error]` payload.
/// 
/// On success, the result contains the response `Content-Type` and raw bytes;
/// on failure, it contains an `Error`.
/// 
/// ```mbt nocheck
/// @http.get("api/file").expect_bytes(x => emit(FileBytesLoaded(x)))
/// ```
/// 
/// It is recommended to process the bytes when handling the
/// `FileBytesLoaded` message in `update`, rather than in the callback.
/// **Keep the callback passed to `expect_bytes` short and clean.**
/// 
/// ### Anti-pattern:
/// - embedding logic in the callback
///     ```mbt nocheck
///     @http.get("api/file").expect_bytes(result => {
///       let processed = process(result)
///       emit(FileBytesLoaded(processed))
///     })
///     ```
/// - ignoring the returned `Cmd`
///     ```
///     @http.get("api/file").expect_bytes(x => emit(FileBytesLoaded(x))) |> ignore
///     ```
pub fn Request::expect_bytes(
  self : Request,
  msg : Emit[Result[(ContentType, Bytes), Error]],
) -> Cmd {
  op.request(
    self(
      Bytes(result => {
        match result {
          Ok(value) => msg(Ok(value))
          Err(error) => msg(Err(error))
        }
      }),
    ),
  )
}

///|
/// Expect a message with a `Result[String, Error]` payload.
/// 
/// On success, the result contains `String`; on failure, it contains an `Error`.
/// The response body is returned as plain text.
/// 
/// ```mbt nocheck
/// @http.get("api/text").expect_text(x => emit(CustomMsg(x)))
/// ```
/// 
/// It is recommended to process the text when handling the
/// `CustomMsg` message in `update`, rather than in the callback.
/// **Keep the callback passed to `expect_text` short and clean.**
/// 
/// ### Anti-pattern:
/// - embedding logic in the callback
///     ```mbt nocheck
///     @http.get("api/text").expect_text(result => {
///       let processed = process(result)
///       emit(CustomMsg(processed))
///     })
///     ```
/// - ignoring the returned `Cmd`
///     ```
///     @http.get("api/text").expect_text(x => emit(CustomMsg(x))) |> ignore
///     ```
pub fn Request::expect_text(
  self : Request,
  msg : Emit[Result[String, Error]],
) -> Cmd {
  op.request(
    self(
      Text(result => {
        match result {
          Ok(text) => msg(Ok(text))
          Err(error) => msg(Err(error))
        }
      }),
    ),
  )
}

///|
/// Expect a message with an `Error?` payload.
/// 
/// On success, the result is `None`; on failure, it is `Some(error)`.
/// The response body is ignored.
/// 
/// ```mbt nocheck
/// @http.delete("api/user/1").expect_empty(x => emit(UserDeleted(x)))
/// ```
/// 
/// It is recommended to handle the success or failure state when handling the
/// `UserDeleted` message in `update`, rather than in the callback.
/// **Keep the callback passed to `expect_empty` short and clean.**
/// 
/// ### Anti-pattern:
/// - embedding logic in the callback
///     ```mbt nocheck
///     @http.delete("api/user/1").expect_empty(result => {
///       let status = result.is_none()
///       emit(UserDeletedStatus(status))
///     })
///     ```
/// - ignoring the returned `Cmd`
///     ```
///     @http.delete("api/user/1").expect_empty(x => emit(UserDeleted(x))) |> ignore
///     ```
pub fn Request::expect_empty(self : Request, msg : Emit[Error?]) -> Cmd {
  op.request(
    self(
      Text(result => {
        match result {
          Ok(_) => msg(None)
          Err(error) => msg(Some(error))
        }
      }),
    ),
  )
}

///|
/// Create a `GET` request.
/// 
/// The request body is empty.
/// Finish the request with `expect_json`, `expect_blob`, `expect_bytes`,
/// `expect_text`, or `expect_empty` to turn it into a `Cmd`.
/// 
/// ```mbt nocheck
/// @http.get("api/user").expect_json(x => emit(UserLoaded(x)))
/// ```
/// 
/// It is recommended to build and finish the request in one expression.
/// **Keep request construction local and straightforward.**
/// 
/// ### Anti-pattern:
/// - ignoring the returned `Request`
///     ```mbt nocheck
///     @http.get("api/user") |> ignore
///     ```
/// - storing the `Request` or `Cmd` in a variable
///     ```
///     let user_api_request = @http.get("api/user")
///     let user_api_cmd = @http.get("api/user").expect_json(x => emit(UserLoaded(x)))
///     ```
/// - wrapping the request construction in a helper function
///     ```mbt nocheck
///     fn fetch_user(emit : Emit[Msg]) -> Cmd {
///       @http.get("api/user").expect_json(x => emit(UserLoaded(x)))
///     }
///     ```
pub fn get(url : String) -> Request {
  Request(expect => Get(url, expect))
}

///|
/// Create a `DELETE` request.
/// 
/// The request body is empty.
/// Finish the request with `expect_json`, `expect_blob`, `expect_bytes`,
/// `expect_text`, or `expect_empty` to turn it into a `Cmd`.
/// 
/// ```mbt nocheck
/// @http.delete("api/user/1").expect_empty(x => emit(UserDeleted(x)))
/// ```
/// 
/// It is recommended to build and finish the request in one expression.
/// **Keep request construction local and straightforward.**
/// 
/// ### Anti-pattern:
/// - ignoring the returned `Request`
///     ```mbt nocheck
///     @http.delete("api/user/1") |> ignore
///     ```
/// - storing the `Request` or `Cmd` in a variable
///     ```
///     let delete_user_request = @http.delete("api/user/1")
///     let delete_user_cmd = @http.delete("api/user/1").expect_empty(x => emit(UserDeleted(x)))
///     ```
/// - wrapping the request construction in a helper function
///     ```mbt nocheck
///     fn delete_user(emit : Emit[Msg]) -> Cmd {
///       @http.delete("api/user/1").expect_empty(x => emit(UserDeleted(x)))
///     }
///     ```
pub fn delete(url : String) -> Request {
  Request(expect => Delete(url, expect))
}

///|
/// Create a `POST` request.
/// 
/// The request body is empty unless `with_json`, `with_text`, `with_bytes`, or
/// `with_blob` is called first.
/// Finish the request with `expect_json`, `expect_blob`, `expect_bytes`,
/// `expect_text`, or `expect_empty`.
/// 
/// ```mbt nocheck
/// @http.post("api/user").with_json(payload).expect_empty(x => emit(UserCreated(x)))
/// ```
/// 
/// It is recommended to build and finish the request in one expression.
/// **Keep request construction local and straightforward.**
/// 
/// ### Anti-pattern:
/// - ignoring the returned `RequestWithBody`
///     ```mbt nocheck
///     @http.post("api/user") |> ignore
///     ```
/// - storing the `RequestWithBody`, `Request`, or `Cmd` in a variable
///     ```
///     let create_user_request = @http.post("api/user")
///     let create_user_built = @http.post("api/user").with_json(payload)
///     let create_user_cmd = @http.post("api/user")
///       .with_json(payload)
///       .expect_empty(x => emit(UserCreated(x)))
///     ```
/// - wrapping the request construction in a helper function
///     ```mbt nocheck
///     fn create_user(emit : Emit[Msg]) -> Cmd {
///       @http.post("api/user")
///       .with_json(payload)
///       .expect_empty(x => emit(UserCreated(x)))
///     }
///     ```
pub fn post(url : String) -> RequestWithBody {
  RequestWithBody((body, expect) => Post(url, body, expect))
}

///|
/// Create a `PATCH` request.
/// 
/// The request body is empty unless `with_json`, `with_text`, `with_bytes`, or
/// `with_blob` is called first.
/// Finish the request with `expect_json`, `expect_blob`, `expect_bytes`,
/// `expect_text`, or `expect_empty`.
/// 
/// ```mbt nocheck
/// @http.patch("api/user/1").with_json(payload).expect_empty(x => emit(UserPatched(x)))
/// ```
/// 
/// It is recommended to build and finish the request in one expression.
/// **Keep request construction local and straightforward.**
/// 
/// ### Anti-pattern:
/// - ignoring the returned `RequestWithBody`
///     ```mbt nocheck
///     @http.patch("api/user/1") |> ignore
///     ```
/// - storing the `RequestWithBody`, `Request`, or `Cmd` in a variable
///     ```
///     let patch_user_request = @http.patch("api/user/1")
///     let patch_user_built = @http.patch("api/user/1").with_json(payload)
///     let patch_user_cmd = @http.patch("api/user/1")
///       .with_json(payload)
///       .expect_empty(x => emit(UserPatched(x)))
///     ```
/// - wrapping the request construction in a helper function
///     ```mbt nocheck
///     fn patch_user(emit : Emit[Msg]) -> Cmd {
///       @http.patch("api/user/1")
///       .with_json(payload)
///       .expect_empty(x => emit(UserPatched(x)))
///     }
///     ```
pub fn patch(url : String) -> RequestWithBody {
  RequestWithBody((body, expect) => Patch(url, body, expect))
}

///|
/// Create a `PUT` request.
/// 
/// The request body is empty unless `with_json`, `with_text`, `with_bytes`, or
/// `with_blob` is called first.
/// Finish the request with `expect_json`, `expect_blob`, `expect_bytes`,
/// `expect_text`, or `expect_empty`.
/// 
/// ```mbt nocheck
/// @http.put("api/user/1").with_json(payload).expect_empty(x => emit(UserReplaced(x)))
/// ```
/// 
/// It is recommended to build and finish the request in one expression.
/// **Keep request construction local and straightforward.**
/// 
/// ### Anti-pattern:
/// - ignoring the returned `RequestWithBody`
///     ```mbt nocheck
///     @http.put("api/user/1") |> ignore
///     ```
/// - storing the `RequestWithBody`, `Request`, or `Cmd` in a variable
///     ```mbt nocheck
///     let replace_user_request = @http.put("api/user/1")
///
///     let replace_user_built = @http.put("api/user/1").with_json(payload)
///
///     let replace_user_cmd = @http.put("api/user/1")
///       .with_json(payload)
///       .expect_empty(x => emit(UserReplaced(x)))
///     ```
/// - wrapping the request construction in a helper function
///     ```mbt nocheck
///     fn replace_user(emit : Emit[Msg]) -> Cmd {
///       @http.put("api/user/1")
///       .with_json(payload)
///       .expect_empty(x => emit(UserReplaced(x)))
///     }
///     ```
pub fn put(url : String) -> RequestWithBody {
  RequestWithBody((body, expect) => Put(url, body, expect))
}

///|
pub(all) enum Body {
  Json(Json)
  Text(String)
  BytesBody(ContentType, Bytes)
  BlobBody(ContentType, Blob)
  Empty
}

///|
pub(all) suberror HttpError {
  RequestError(String)
} derive(FromJson, ToJson)

///|
pub extend HttpError with FromJson::{from_json}

///|
pub extend HttpError with ToJson::{to_json}

///|
impl Show for HttpError with fn output(self, buf) {
  let RequestError(s) = self
  buf <+ "Request error, \{s}"
}
