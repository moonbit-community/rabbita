///|
#internal(experimental, "This API is unstable and may change in the future.")
pub(open) trait Context {
  /// Base URL used to resolve relative HTTP requests.
  #internal(experimental, "This API is unstable and may change in the future.")
  fn get_base_uri(Self) -> String
  #internal(experimental, "This API is unstable and may change in the future.")
  fn inject_url_changed(Self, String) -> Cmd
  #internal(experimental, "This API is unstable and may change in the future.")
  fn inject_url_request(Self, String) -> Cmd
}

///|
pub(open) trait Scheduler: Context {
  fn add(Self, Cmd) -> Unit = _
  #internal(experimental, "This API is unstable and may change in the future.")
  fn queue_command(Self, Cmd) -> Unit
  #internal(experimental, "This API is unstable and may change in the future.")
  fn set_url_changed_injector(Self, Injector[String]) -> Unit
  #internal(experimental, "This API is unstable and may change in the future.")
  fn set_url_request_injector(Self, Injector[String]) -> Unit
}

///|
pub extend &Scheduler with Context::{
  get_base_uri,
  inject_url_changed,
  inject_url_request,
}

///|
impl Scheduler with fn add(self, cmd) {
  self.queue_command(cmd)
}

///|
#doc(hidden)
#internal(experimental, "This API is unstable and may change in the future.")
pub fn runner(_ : @key.Key, op : Op) -> Runner {
  Runner(op)
}

///|
#internal(experimental, "This API is unstable and may change in the future.")
pub(all) struct Injector[Arg]((Arg) -> Cmd)
