///|
#cfg(target="js")
using @queue {type Queue}

///|
#cfg(target="js")
extern "js" fn schedule_render(f : () -> Unit) = "queueMicrotask"

///|
/// The rendering pipeline will do the following step:
///
/// 1. view(model) -> newView  
///      compute new vdom from model
///
/// 2. diff(oldView, newView) -> patch
///      generate patches by comparing to old vdom
///
/// 3. mount(patch)
///      apply patches to real DOM
#cfg(target="js")
pub(all) struct Sandbox {
  priv after_render_queue : Queue[(&Scheduler) -> Unit]
  priv msg_queue : Queue[(@slotmap.Id, @any.Any)]
  priv mut root_view : @duplix.Node[VNode]?
  priv mut drain_scheduled : Bool
  priv mut paint_scheduled : Bool
  priv mut inode : INode?
  priv captured_link_listener : @dom.Listener
  mut mount : String
  hooks : @cmd.Hooks
}

///|
#cfg(target="js")
pub fn Sandbox::new() -> Sandbox {
  let mut sandbox : Sandbox? = None
  let captured_link_listener = fn(event : @dom.Event) {
    if event.to_mouse_event() is Some(mouse_event) &&
      sandbox is Some(sandbox) &&
      sandbox.hooks.url_request is Some(hook) &&
      !(mouse_event.get_meta_key() || mouse_event.get_ctrl_key()) {
      event.prevent_default()
      let href = event
        .current_target()
        .unwrap()
        .to_element()
        .unwrap()
        .get_property("href")
        .unwrap()

      hook(sandbox, href)
    }
  }
  let sandbox_value = {
    msg_queue: Queue([]),
    root_view: None,
    inode: None,
    hooks: { url_request: None, url_changed: None },
    paint_scheduled: false,
    drain_scheduled: false,
    mount: "",
    captured_link_listener,
    after_render_queue: Queue([]),
  }
  sandbox = Some(sandbox_value)
  sandbox_value
}

///|
#cfg(target="js")
pub fn Sandbox::initialize(self : Self, vnode : @duplix.Node[VNode]) -> Unit {
  let element = @dom.document().get_element_by_id(self.mount).unwrap() // TODO: handle error

  // trigger a url_changed message 
  if self.hooks().url_changed is Some(hook) {
    hook(self, @dom.window().current_url())
  }

  self.root_view = Some(vnode)
  let vnode = self.root_view.unwrap().read()
  let inode = vnode.insert(self, element.as_node(), null())
  self.inode = Some(inode)
}

///|
/// Schedules DOM patching after the current command batch.
#cfg(target="js")
pub fn Sandbox::flush(self : Self) -> Unit {
  if !self.paint_scheduled {
    self.paint_scheduled = true
    schedule_render(fn() {
      if self.inode is Some(inode) {
        let end = inode.end()
        let parent = end.get_parent_node().unwrap()
        let next_sibling = end.get_next_sibling()
        let vnode = self.root_view.unwrap().read()
        let inode = diff_node(inode, vnode, self, parent, next_sibling)
        self.inode = Some(inode)
      }
      self.paint_scheduled = false
      while self.after_render_queue.pop() is Some(f) {
        f(self)
      }
    })
  }
}

///|
#cfg(target="js")
pub impl Scheduler for Sandbox with fn run_effect(self, kind, f) {
  match kind {
    Immediately => f(self)
    AfterRender => self.after_render_queue.push(f)
  }
}

///|
#cfg(target="js")
pub impl Scheduler for Sandbox with fn queue_message(self, path, msg) {
  self.msg_queue.push((path, msg))
}

///|
/// Processing all pending messages FIFO to update all relevant models
#cfg(target="js")
pub impl Scheduler for Sandbox with fn drain_message(self) {
  if !self.drain_scheduled {
    self.drain_scheduled = true
    while self.msg_queue.pop() is Some((id, erased_msg)) {
      guard global_stores.get(id) is Some(store) else { continue }
      (store.on_update)(self, erased_msg)
    }
    self.drain_scheduled = false
    self.flush()
  }
}

///|
#cfg(target="js")
pub impl Scheduler for Sandbox with fn hooks(self) {
  self.hooks
}
