///|
using @queue {type Queue}

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
  priv live_map : Map[Id, (&IsCell, Map[InstId, Instance])]
  priv msg_queue : Queue[Id]
  priv after_render_queue : Queue[(&Scheduler) -> Unit]
  priv mut drain_scheduled : Bool
  priv dirty_set : Set[Id]
  priv mut paint_scheduled : Bool
  priv root : Instance
  priv captured_link_listener : @dom.Listener
  mut mount : String
  mut on_url_changed : ((Url) -> Cmd)?
  mut on_url_request : ((UrlRequest) -> Cmd)?
}

///|
#cfg(target="js")
pub fn Sandbox::new(root : &IsCell) -> Sandbox {
  let root = Instance::new(root)
  let mut sandbox : Sandbox? = None
  let captured_link_listener = fn(event : @dom.Event) {
    if event.to_mouse_event() is Some(mouse_event) &&
      sandbox is Some(sandbox) &&
      sandbox.on_url_request is Some(_) &&
      !(mouse_event.get_meta_key() || mouse_event.get_ctrl_key()) {
      event.prevent_default()
      let href = event
        .current_target()
        .unwrap()
        .to_element()
        .unwrap()
        .get_property("href")
        .unwrap()
      let curr = try! @url.parse(@dom.window().current_url())
      let next = try! @url.parse(href)
      let request = if curr.protocol == next.protocol &&
        curr.host == next.host &&
        curr.port == next.port {
        @url.Internal(next)
      } else {
        External(href)
      }
      sandbox.add_url_request(request)
    }
  }
  let live_map = Map::from_array([
    (root.cell.flags().id, (root.cell, Map::from_array([(root.id, root)]))),
  ])
  sandbox = Some({
    root,
    live_map,
    msg_queue: Queue::new(),
    dirty_set: Set::new(),
    on_url_changed: None,
    on_url_request: None,
    paint_scheduled: false,
    drain_scheduled: false,
    mount: "",
    captured_link_listener,
    after_render_queue: Queue::new(),
  })
  sandbox.unwrap()
}

///|
/// Processing all pending messages FIFO to update all relevant models
#cfg(target="js")
fn Sandbox::drain(self : Self) -> Unit {
  if !self.drain_scheduled {
    self.drain_scheduled = true
    while self.msg_queue.pop() is Some(id) {
      if self.live_map.get(id) is Some((cell, _)) {
        cell.step(self)
        self.dirty_set.add(id)
      }
    }
    self.drain_scheduled = false
    self.flush()
  }
}

///|
#cfg(target="js")
pub fn Sandbox::initialize(self : Self) -> Unit {
  let root = self.root
  let element = @dom.document().get_element_by_id(self.mount).unwrap() // TODO: handle error
  self.dirty_set.add(root.cell.flags().id)
  let vnode = root.cell.view()
  let inode = vnode.insert(self, root, element.as_node(), null())
  self.root.inode = Some(inode)
  // println(self.live_map.keys())
}

///|
#cfg(target="js")
fn Sandbox::drop_live_subtree(self : Self, root : Instance) -> Unit {
  let stack = [root]
  while stack.pop() is Some(inst) {
    let flags = inst.cell.flags()
    flags.attach_count -= 1
    if self.live_map.get(flags.id()) is Some((_, insts)) {
      insts.remove(inst.id)
      if insts.is_empty() {
        self.live_map.remove(flags.id())
        self.dirty_set.remove(flags.id())
      }
    }
    // Removal can happen mid-diff; scan both old/new links to avoid leaving orphans.
    // Example: parent replaces child A with B (B goes to new_childs), then the
    // parent subtree is removed before commit. If we only scan old_childs,
    // B would stay live even though its DOM is gone.
    for _, link in inst.old_childs {
      if link.val is Some(c) {
        stack.push(c)
      }
    }
    for _, link in inst.new_childs {
      if link.val is Some(c) {
        stack.push(c)
      }
    }
  }
}

///|
#cfg(target="js")
fn Sandbox::add_url_request(self : Self, request : UrlRequest) -> Unit {
  match self.on_url_request {
    None => ()
    Some(f) => self.add(f(request))
  }
}

///|
/// Schedules a drawing frame to be rendered on the next animation frame.
#cfg(target="js")
pub fn Sandbox::flush(self : Self) -> Unit {
  if !self.paint_scheduled {
    self.paint_scheduled = true
    @dom.window().request_animation_frame(fn(_) {
      let dirty = self.dirty_set.to_array()
      for id in dirty {
        guard self.live_map.get(id) is Some((cell, insts)) && cell.flags().dirty else {
          continue
        }
        let flags = cell.flags()
        for _, inst in insts {
          // Dirty-set can contain stale ids; skip if already clean.
          // Example: a cell was marked dirty, then got removed or superseded
          // before flush; keeping this guard prevents redundant diff/crash.
          let vnode = inst.cell.view()
          // The parent cell helps child cells initialize their inodes during vdom diff,
          // so initially child cells are not in the dirty set
          guard inst.inode is Some(inode)
          let end = inode.end()
          let parent = end.get_parent_node().unwrap()
          let next_sibling = end.get_next_sibling()
          let inode = diff_node(inode, vnode, self, parent, next_sibling, inst)
          inst.inode = Some(inode)
          for id, link in inst.old_childs {
            if link.val is Some(_) {
              inst.new_childs[id] = link
            }
          }
          inst.old_childs = inst.new_childs
          inst.new_childs = Map::new()
        }
        flags.dirty = false
      }
      self.dirty_set.clear()
      // self.root.node().validate()
      self.paint_scheduled = false
      while self.after_render_queue.pop() is Some(effect) {
        effect(self)
      }
    })
    |> ignore
  }
}

///|
/// Run an effect immediately or pending a message.
#cfg(target="js")
pub impl Scheduler for Sandbox with add(self, cmd) {
  match cmd {
    Empty => ()
    Batch(xs) => xs.each(x => self.add(x))
    Effect(effect, Immediately) => effect(self)
    Effect(effect, AfterRender) => self.after_render_queue.push(effect)
    Message(id, send_message) => {
      send_message()
      self.msg_queue.push(id)
    }
  }
  self.drain()
}

///|
#cfg(target="js")
pub impl Scheduler for Sandbox with add_url_changed(self, url) {
  match self.on_url_changed {
    None => ()
    Some(f) => self.add(f(url))
  }
}
