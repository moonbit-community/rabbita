///|
#cfg(target="js")
using @cmd {trait Scheduler}

///|
extenum @cmd.Extension += {
  WebSocketConnect(
    String,
    String,
    FixedArray[String],
    @cmd.Emit[Event],
    @cmd.Emit[String]?
  )
  WebSocketSend(String, Payload, @cmd.Emit[String]?)
  WebSocketClose(String, Int?, String?, @cmd.Emit[String]?)
  WebSocketState(String, @cmd.Emit[Result[Snapshot, String]])
}

///|
let op : @cmd.Op = @cmd.Op()
  ..on_invoke(op_invoke)
  ..on_debug(extension => {
    match extension {
      WebSocketConnect(id, url, protocols, _, _) =>
        Repr::ctor("WebSocketConnect", [
          (None, Repr(id)),
          (None, Repr(url)),
          (None, Repr(protocols)),
        ])
      WebSocketSend(id, payload, _) =>
        Repr::ctor("WebSocketSend", [(None, Repr(id)), (None, Repr(payload))])
      WebSocketClose(id, code, reason, _) =>
        Repr::ctor("WebSocketClose", [
          (None, Repr(id)),
          (None, Repr(code)),
          (None, Repr(reason)),
        ])
      WebSocketState(id, _) => Repr::ctor("WebSocketState", [(None, Repr(id))])
      _ => raise Unhandled
    }
  })

///|
#cfg(target="js")
priv struct SocketEntry {
  socket : @dom.WebSocket
  listeners : Map[String, @dom.Listener]
}

///|
#cfg(target="js")
let connections : Map[String, SocketEntry] = Map([])

///|
#cfg(target="js")
fn op_invoke(
  extension : @cmd.Extension,
  _context : &@cmd.Context,
) -> @cmd.OpCont[Cmd] raise @cmd.Unhandled {
  fn ready_state_from_dom(value : Int) -> ReadyState {
    match value {
      0 => Connecting
      1 => Open
      2 => Closing
      _ => Closed
    }
  }

  match extension {
    WebSocketConnect(id, url, protocols, on_event, failed) =>
      LegacyEffect(@cmd.immediately, scheduler => {
        let listeners : Map[String, @dom.Listener] = Map([])
        match @dom.WebSocket::open(url, protocols~) {
          Ok(created) => {
            fn on_open(_) {
              scheduler.add(on_event(Opened))
            }
            listeners["open"] = on_open
            created.add_event_listener("open", on_open)

            fn on_message(event : @dom.Event) {
              guard event.to_message_event() is Some(event) else { return }
              guard event.get_data_string() is Some(text) else { return }
              scheduler.add(on_event(Message(text)))
            }
            listeners["message"] = on_message
            created.add_event_listener("message", on_message)

            fn on_close(event : @dom.Event) {
              guard event.to_close_event() is Some(event) else { return }
              let info : CloseInfo = {
                code: event.get_code(),
                reason: event.get_reason(),
                clean: event.get_was_clean(),
              }
              if connections.get(id) is Some(entry) {
                for event_name, listener in entry.listeners {
                  entry.socket.remove_event_listener(event_name, listener)
                }
                connections.remove(id)
              }
              scheduler.add(on_event(Closed(info)))
            }
            listeners["close"] = on_close
            created.add_event_listener("close", on_close)

            fn on_error(_) {
              scheduler.add(on_event(Errored))
            }
            listeners["error"] = on_error
            created.add_event_listener("error", on_error)

            if connections.get(id) is Some(old_entry) {
              for event_name, listener in old_entry.listeners {
                old_entry.socket.remove_event_listener(event_name, listener)
              }
              old_entry.socket.close_quietly()
            }
            connections[id] = { socket: created, listeners, }
          }
          Err(message) =>
            if failed is Some(failed) {
              scheduler.add(failed(message))
            }
        }
      })
    WebSocketSend(id, payload, failed) =>
      if connections.get(id) is Some(entry) {
        let data = match payload {
          Text(text) => text
          Json(json) => json.stringify()
        }
        match entry.socket.send_safe(data) {
          Err(message) if failed is Some(failed) => Ready(failed(message))
          Ok(_) | Err(_) => None
        }
      } else {
        let message = "websocket connection not found: \{id}"
        if failed is Some(failed) {
          Ready(failed(message))
        } else {
          None
        }
      }
    WebSocketClose(id, code, reason, failed) =>
      if connections.get(id) is Some(entry) {
        let result = match (code, reason) {
          (Some(code), Some(reason)) => entry.socket.close_safe(code~, reason~)
          (Some(code), None) => entry.socket.close_safe(code~)
          (None, Some(reason)) => entry.socket.close_safe(reason~)
          (None, None) => entry.socket.close_safe()
        }
        match result {
          Err(message) if failed is Some(failed) => Ready(failed(message))
          Err(_) | Ok(_) => None
        }
      } else {
        let message = "websocket connection not found: \{id}"
        if failed is Some(failed) {
          Ready(failed(message))
        } else {
          None
        }
      }
    WebSocketState(id, reply) =>
      if connections.get(id) is Some(entry) {
        let socket = entry.socket
        let snapshot : Snapshot = {
          id,
          url: socket.get_url(),
          protocol: socket.get_protocol(),
          buffered_amount: socket.get_buffered_amount(),
          ready_state: ready_state_from_dom(socket.get_ready_state()),
        }
        Ready(reply(Ok(snapshot)))
      } else {
        Ready(reply(Err("websocket connection not found: \{id}")))
      }
    _ => raise Unhandled
  }
}

///|
#cfg(not(target="js"))
#warnings("-unused_error_type")
fn op_invoke(
  extension : @cmd.Extension,
  _context : &@cmd.Context,
) -> @cmd.OpCont[Cmd] raise @cmd.Unhandled {
  match extension {
    WebSocketConnect(_, _, _, on_event, failed) => {
      ignore(on_event)
      ignore(failed)
      None
    }
    WebSocketSend(_, _, failed) => {
      ignore(failed)
      None
    }
    WebSocketClose(_, _, _, failed) => {
      ignore(failed)
      None
    }
    WebSocketState(_, reply) => {
      ignore(reply)
      None
    }
    _ => None
  }
}
