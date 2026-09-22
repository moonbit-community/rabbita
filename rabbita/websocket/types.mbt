///|
using @debug {trait Debug, type Repr}

///|
/// Close event information surfaced by `@websocket.connect(...)`.
#warnings("-struct_never_constructed")
pub struct CloseInfo {
  code : Int
  reason : String
  clean : Bool
} derive(Debug)

///|
pub extend CloseInfo with Debug::{to_repr}

///|
pub impl Show for CloseInfo with fn output(self, buf) {
  Show::output(@debug.Debug::to_repr(self), buf)
}

///|
pub extend CloseInfo with Show::{output, to_string}

///|
/// Inbound events emitted by a managed WebSocket connection.
pub(all) enum Event {
  Opened
  Message(String)
  Closed(CloseInfo)
  Errored
} derive(Debug)

///|
pub extend Event with Debug::{to_repr}

///|
pub impl Show for Event with fn output(self, buf) {
  Show::output(@debug.Debug::to_repr(self), buf)
}

///|
pub extend Event with Show::{output, to_string}

///|
/// Outbound payload for `send(...)`.
pub(all) enum Payload {
  Text(String)
  Json(Json)
}

///|
pub impl Show for Payload with fn output(self, buf) {
  match self {
    Text(text) => {
      buf.write_string("Text(")
      Show::output(text, buf)
      buf.write_string(")")
    }
    Json(value) => {
      buf.write_string("Json(")
      buf.write_string(value.stringify())
      buf.write_string(")")
    }
  }
}

///|
pub extend Payload with Show::{output, to_string}

///|
pub impl Debug for Payload with fn to_repr(self) {
  match self {
    Text(text) => Repr::ctor("Text", [(None, Repr(text))])
    Json(value) => Repr::ctor("Json", [(None, Repr(value))])
  }
}

///|
pub extend Payload with Debug::{to_repr}

///|
/// Browser `WebSocket.readyState` mapped to a MoonBit enum.
pub(all) enum ReadyState {
  Connecting
  Open
  Closing
  Closed
} derive(Debug)

///|
pub extend ReadyState with Debug::{to_repr}

///|
pub impl Show for ReadyState with fn output(self, buf) {
  Show::output(@debug.Debug::to_repr(self), buf)
}

///|
pub extend ReadyState with Show::{output, to_string}

///|
/// Snapshot of the current connection state for a named socket.
#warnings("-struct_never_constructed")
pub struct Snapshot {
  id : String
  url : String
  protocol : String
  buffered_amount : Int
  ready_state : ReadyState
} derive(Debug)

///|
pub extend Snapshot with Debug::{to_repr}

///|
pub impl Show for Snapshot with fn output(self, buf) {
  Show::output(@debug.Debug::to_repr(self), buf)
}

///|
pub extend Snapshot with Show::{output, to_string}
