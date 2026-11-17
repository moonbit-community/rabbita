///|
#cfg(target="js")
using @cmd {type Emit}

///|
#cfg(target="js")
priv suberror WebsocketSubscription {
  Listen(
    String,
    FixedArray[String],
    open~ : Cmd?,
    message~ : Emit[String]?,
    close~ : Emit[CloseInfo]?,
    error~ : Cmd?,
  )
}

///|
#cfg(target="js")
fn websocket_sub_loader(
  payload : Error,
  scheduler : &Scheduler,
) -> @sub.RunningSub? {
  match payload {
    Listen(url, protocols, open~, message~, close~, error~) => {
      let socket = if protocols.is_empty() {
        @dom.WebSocket::new(url)
      } else {
        @dom.WebSocket::new_with_protocols(url, protocols)
      }

      let mut open_tagger = open
      let mut message_tagger = message
      let mut close_tagger = close
      let mut error_tagger = error

      fn on_open(_) {
        guard open_tagger is Some(msg) else { return }
        scheduler.add(msg)
      }
      fn on_message(event : @dom.Event) {
        guard message_tagger is Some(msg) else { return }
        guard event.to_message_event() is Some(event) else { return }
        guard event.get_data_string() is Some(text) else { return }
        scheduler.add(msg(text))
      }
      fn on_close(event : @dom.Event) {
        guard close_tagger is Some(msg) else { return }
        guard event.to_close_event() is Some(event) else { return }
        let info : CloseInfo = {
          code: event.get_code(),
          reason: event.get_reason(),
          clean: event.get_was_clean(),
        }
        scheduler.add(msg(info))
      }
      fn on_error(_) {
        guard error_tagger is Some(msg) else { return }
        scheduler.add(msg)
      }

      socket
      ..add_event_listener("open", on_open)
      ..add_event_listener("message", on_message)
      ..add_event_listener("close", on_close)
      .add_event_listener("error", on_error)

      Some({
        unload: fn(_) {
          socket
          ..remove_event_listener("open", on_open)
          ..remove_event_listener("message", on_message)
          ..remove_event_listener("close", on_close)
          ..remove_event_listener("error", on_error)
          .close()
        },
        update_tagger: fn(payload) {
          guard payload is Listen(_, _, open~, message~, close~, error~) else {
            return
          }
          open_tagger = open
          message_tagger = message
          close_tagger = close
          error_tagger = error
        },
      })
    }
    _ => None
  }
}

///|
/// Subscribe to a browser WebSocket connection.
///
/// The subscription opens a socket when installed and closes it when removed.
/// At least one callback must be provided; otherwise `@sub.none` is returned.
///
/// `message` only receives text frames. Binary messages are ignored.
#cfg(target="js")
pub fn listen(
  url : String,
  protocols~ : FixedArray[String] = [],
  open? : Cmd,
  message? : @cmd.Emit[String],
  close? : @cmd.Emit[CloseInfo],
  error? : Cmd,
) -> @sub.Sub {
  let has_open = open is Some(_)
  let has_message = message is Some(_)
  let has_close = close is Some(_)
  let has_error = error is Some(_)

  guard has_open || has_message || has_close || has_error else { @sub.none }
  let protocol_list = protocols.join(",")
  let key = "websocket.listen(url=\{url},protocols=[\{protocol_list}],open=\{has_open},message=\{has_message},close=\{has_close},error=\{has_error})"
  @sub.custom_sub(
    key,
    Local,
    Listen(url, protocols, open~, message~, close~, error~),
    websocket_sub_loader,
  )
}
