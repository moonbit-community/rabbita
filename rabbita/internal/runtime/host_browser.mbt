///|
/// The rendering pipeline will do the following step:
///
/// 1. view(model) -> newView
///      compute new vdom from model
///
/// 2. reconcile(oldView, newView)
///      update the mounted render state
struct BrowserHost {
  after_render_queue : Queue[() -> Cmd]
  task_queue : Queue[(@cmd.Op, @cmd.Extension)]
  stores : @slotmap.SlotMap[Store]
  scope : @duplix.ScopeId
  mut graph_output : @duplix.Node[VNode]?
  mut drain_scheduled : Bool
  mut paint_scheduled : Bool
  mut document : @vdom.VDom?
  mut url_request : @cmd.Injector[String]
  mut url_changed : @cmd.Injector[String]
}

///|
pub fn BrowserHost::BrowserHost(
  element_id~ : String,
  builder : GraphBuilder,
) -> Self {
  let target_element = @dom.document().get_element_by_id(element_id).unwrap()
  let (host, output) = @duplix.with_scope(scope => {
    let host = BrowserHost::{
      stores: SlotMap(),
      scope,
      task_queue: Queue([]),
      graph_output: None,
      document: None,
      url_request: _ => @cmd.none,
      url_changed: _ => @cmd.none,
      paint_scheduled: false,
      drain_scheduled: true,
      after_render_queue: Queue([]),
    }
    (host, ambient_host.protect(host, builder))
  })
  host.graph_output = Some(output)
  let url = @dom.window().current_url()
  let cmd = Context::inject_url_changed(host, url)
  Scheduler::queue_command(host, cmd)
  let root = ambient_host.protect(host, () => output.read())
  host.document = Some(@vdom.VDom::mount(root, host, target_element))
  host.drain_scheduled = false
  host
}

///|
pub impl Host for BrowserHost with fn flush(self) {
  self.request_task()
}

///|
pub impl Host for BrowserHost with fn get_stores(self) {
  self.stores
}

///|
/// Schedules a drawing frame to be rendered on the next animation frame.
fn BrowserHost::request_frame(self : Self) -> Unit {
  guard !self.paint_scheduled else { return }
  self.paint_scheduled = true
  @dom.window().request_animation_frame(fn(_) {
    if self.document is Some(document) {
      let output = self.graph_output.unwrap()
      let vnode = ambient_host.protect(self, () => output.read())
      document.update(vnode, self)
    }
    self.paint_scheduled = false
    while self.after_render_queue.pop() is Some(f) {
      let cmd = f()
      Scheduler::queue_command(self, cmd)
    }
  })
  |> ignore
}

///|
fn BrowserHost::request_task(self : Self) -> Unit {
  guard !self.drain_scheduled else { return }
  self.drain_scheduled = true
  @dom.window().queue_microtask(() => {
    while self.task_queue.pop() is Some((op, extension)) {
      if handle_message(self, extension) {
        continue
      }
      try @cmd.invoke(@key.key, op, extension, self) catch {
        Unhandled => ()
      } noraise {
        None => ()
        Ready(cmd) => self.queue_command(cmd)
        Async(f) =>
          @js_async.Promise::from_async(() => {
            Scheduler::queue_command(self, f())
          })
          |> ignore
        AfterLayout(f) => self.after_render_queue.push(f)
        LegacyEffect(Immediately, f) => f(self)
        LegacyEffect(AfterRender, f) =>
          self.after_render_queue.push(() => {
            f(self)
            @cmd.none
          })
      }
    }
    self.drain_scheduled = false
    self.request_frame()
  })
}

///|
pub impl Host for BrowserHost with fn cleanup(self) {
  self.scope.cleanup()
}

///|
pub impl Scheduler for BrowserHost with fn queue_command(self, cmd) {
  let tasks = @cmd.flatten(@key.key, cmd)
  for task in tasks {
    self.task_queue.push(task)
  }
  self.request_task()
}

///|
pub impl Scheduler for BrowserHost with fn set_url_changed_injector(
  self,
  injector,
) {
  self.url_changed = injector
}

///|
pub impl Scheduler for BrowserHost with fn set_url_request_injector(
  self,
  injector,
) {
  self.url_request = injector
}

///|
pub impl Context for BrowserHost with fn get_origin(_self) {
  @dom.window().origin()
}

///|
pub impl Context for BrowserHost with fn inject_url_changed(self, url) {
  (self.url_changed)(url)
}

///|
pub impl Context for BrowserHost with fn inject_url_request(self, url) {
  (self.url_request)(url)
}
