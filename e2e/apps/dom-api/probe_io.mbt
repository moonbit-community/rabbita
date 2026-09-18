///|
fn probe_async_apis() -> Unit {
  let failures : Array[String] = []
  let io_done = [false]
  let websocket_done = [false]
  fn update_result() {
    if io_done[0] && websocket_done[0] {
      set_result("async-result", finish_probe(failures))
    }
  }

  let basic = @dom.DOMException::new()
  let with_message = @dom.DOMException::new_with_message("problem")
  let named = @dom.DOMException::new_with_message_and_name(
    "missing", "NotFoundError",
  )
  record(failures, basic.get_name() == "Error", "dom_exception_default")
  record(
    failures,
    with_message.get_message() == "problem",
    "dom_exception_message",
  )
  record(failures, named.get_name() == "NotFoundError", "dom_exception_name")
  record(
    failures,
    named.get_message() == "missing",
    "dom_exception_named_message",
  )

  let blob = @dom.Blob::from_bytes(b"rabbit", "text/plain")
  let slice = blob.slice(1, end_=@js.Optional::from_option(Some(4)))
  record(failures, blob.get_size() == 6, "blob_size")
  record(failures, blob.get_type() == "text/plain", "blob_type")
  record(failures, slice.get_size() == 3, "blob_slice")
  @js.Promise::from_async(() => {
    try {
      let text = blob.text()
      let bytes = blob.bytes()
      let sliced_text = slice.text()
      let clipboard = @dom.window().navigator().clipboard()
      record(
        failures,
        @dom.IsEventTarget::to_clipboard(clipboard) is Some(_),
        "clipboard_conversion",
      )
      clipboard.write_text("rabbit clipboard").wait()
      let clipboard_text = clipboard.read_text().wait()
      record(failures, text == "rabbit", "blob_text")
      record(failures, bytes == b"rabbit", "blob_bytes")
      record(failures, sliced_text == "abb", "blob_slice_text")
      record(
        failures,
        clipboard_text == "rabbit clipboard",
        "clipboard_roundtrip",
      )
    } catch {
      error => failures.push("async_io: \{error}")
    } noraise {
      _ => ()
    }
    io_done[0] = true
    update_result()
  })
  |> ignore

  let socket_url = "ws://127.0.0.1:4308/dom-api-echo"
  let direct_socket = @dom.WebSocket::new(socket_url)
  direct_socket.close_quietly()
  let protocol_socket = @dom.WebSocket::new_with_protocols(socket_url, [
    "dom-api",
  ])
  protocol_socket.close_quietly()
  match @dom.WebSocket::open(socket_url) {
    Err(message) => {
      failures.push("websocket_open: \{message}")
      websocket_done[0] = true
      update_result()
    }
    Ok(socket) => {
      let messages = [0]
      record(failures, socket.get_url() == socket_url, "websocket_url")
      record(failures, socket.get_ready_state() == 0, "websocket_connecting")
      let open_listener : @dom.Listener = _ => {
        record(failures, socket.get_ready_state() == 1, "websocket_open")
        socket.send("rabbit")
        record(
          failures,
          socket.send_safe("rabbit-safe") is Ok(_),
          "websocket_send_safe",
        )
        ignore(socket.get_buffered_amount())
        ignore(socket.get_protocol())
      }
      let message_listener : @dom.Listener = event => {
        if @dom.IsEvent::to_message_event(event) is Some(message) {
          let data = message.get_data_string()
          record(
            failures,
            data == Some("echo:rabbit") || data == Some("echo:rabbit-safe"),
            "websocket_message_string",
          )
          record(
            failures,
            message.get_data().is_string(),
            "websocket_message_value",
          )
        } else {
          failures.push("websocket_message_conversion")
        }
        messages[0] += 1
        if messages[0] == 2 {
          socket.close_with_code_reason(1000, "done")
          record(
            failures,
            socket.close_safe(code=1000, reason="done") is Ok(_),
            "websocket_close_safe",
          )
        }
      }
      let close_listener : @dom.Listener = event => {
        if @dom.IsEvent::to_close_event(event) is Some(close) {
          record(failures, close.get_code() == 1000, "close_event_code")
          record(failures, close.get_reason() == "done", "close_event_reason")
          ignore(close.get_was_clean())
        } else {
          failures.push("close_event_conversion")
        }
        socket.close()
        socket.close_quietly()
        websocket_done[0] = true
        update_result()
      }
      @dom.IsEventTarget::add_event_listener(socket, "open", open_listener)
      @dom.IsEventTarget::add_event_listener(
        socket, "message", message_listener,
      )
      @dom.IsEventTarget::add_event_listener(socket, "close", close_listener)
    }
  }
}
