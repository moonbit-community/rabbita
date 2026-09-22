///|
using @cmd {type Cmd}

///|
/// Scroll behavior for navigation commands.
///
/// These variants map to the DOM `ScrollBehavior` string values:
/// `auto`, `instant`, and `smooth`.
pub(all) enum ScrollBehavior {
  Auto
  Instant
  Smooth
}

///|
pub impl Show for ScrollBehavior with fn output(self, buf) {
  match self {
    Auto => buf.write_string("auto")
    Instant => buf.write_string("instant")
    Smooth => buf.write_string("smooth")
  }
}

///|
pub extend ScrollBehavior with Show::{output, to_string}

///|
/// Create a command to scroll the window to a specific position.
pub fn scroll_to_pos(
  x : Double,
  y : Double,
  behavior? : ScrollBehavior = Auto,
) -> Cmd {
  op.request(NavScrollToPos(x, y, behavior))
}

///|
/// Create a command to scroll the window by a specific amount.
pub fn scroll_by_pos(
  x : Double,
  y : Double,
  behavior? : ScrollBehavior = Auto,
) -> Cmd {
  op.request(NavScrollByPos(x, y, behavior))
}

///|
/// Create a command to scroll the window to a specific element.
/// The element is specified by its id.
pub fn scroll_to(element : String, behavior? : ScrollBehavior = Auto) -> Cmd {
  op.request(NavScrollTo(element, behavior))
}

///|
/// Create a command to scroll the window to the top.
pub fn scroll_to_top(behavior? : ScrollBehavior = Auto) -> Cmd {
  op.request(NavScrollToTop(behavior))
}

///|
/// Create a command to scroll the window to the bottom.
pub fn scroll_to_bottom(behavior? : ScrollBehavior = Auto) -> Cmd {
  op.request(NavScrollToBottom(behavior))
}
