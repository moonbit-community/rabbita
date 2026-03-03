///|
pub trait Scheduler {
  add(Self, Cmd) -> Unit
  add_url_changed(Self, Url) -> Unit
}
