
///|
pub(all) enum Kind {
  Immediately
  AfterRender
}

///|
pub(open) trait Scheduler {
  fn run_effect(Self, Kind, OnExecute) -> Unit
  fn queue_message(Self, @slotmap.Id, @any.Any) -> Unit
  fn drain_message(Self) -> Unit
  fn add(Self, Cmd) -> Unit = _
  fn hooks(Self) -> Hooks
}

///|
pub(all) enum Path {
  Index(Int, Path)
  Keyed(String, Path)
  Root
} derive(Eq, Compare, Hash)

///|
pub(all) struct Hooks {
  mut url_request : Hook[String]?
  mut url_changed : Hook[String]?
}

///|
pub type Hook[Arg] = (&Scheduler, Arg) -> Unit

///|
impl Scheduler with fn add(self, cmd) {
  fn go(cmd) {
    match cmd {
      Batch(xs) => xs.each(x => go(x))
      Effect(k, f) => self.run_effect(k, f)
      Message(id, msg) => self.queue_message(id, msg)
      LegacyMessage(f) => f(self)
    }
  }
  go(cmd)
  self.drain_message()
}
