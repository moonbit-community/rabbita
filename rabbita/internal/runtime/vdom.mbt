///|
pub enum VNode {
  Elem(String, Props, Children[VNode], namespace_uri~ : String?)
  Text(String)
  Frag(Array[VNode])
  Slot(&IsCell)
}

///|
#cfg(target="js")
priv enum INode {
  Elem(String, Props, Children[INode], namespace_uri~ : String?, @dom.Element)
  Text(String, @dom.Element)
  Frag(Array[INode], @dom.Comment, @dom.Comment)
  Slot(Instance, @dom.Comment, @dom.Comment)
}

///|
#cfg(not(target="js"))
type INode = Unit

///|
priv struct Instance {
  cell : &IsCell
  mut inode : INode?
  link : Link
  mut old_childs : Map[InstId, Link]
  mut new_childs : Map[InstId, Link]
  id : InstId
}

///|
fn Instance::new(cell : &IsCell) -> Self {
  {
    cell,
    inode: None,
    link: { val: None },
    old_childs: {},
    new_childs: {},
    id: InstId::new(),
  }
}

///|
#cfg(target="js")
fn INode::scan_direct_childs(s : Self) -> Array[Link] {
  let tmp = [s]
  let result = []
  while tmp.pop() is Some(inode) {
    match inode {
      Text(_) => ()
      Elem(_, _, cs, _, ..) =>
        match cs {
          Map(mp) => tmp.push_iter(mp.values())
          Array(arr) => tmp.push_iter(arr.iter())
        }
      Frag(xs, _, _) => tmp.push_iter(xs.iter())
      Slot(inst, _, _) => result.push(inst.link)
    }
  }
  return result
}

///|
#cfg(target="js")
fn INode::start(s : Self) -> @dom.Node {
  match s {
    Elem(_, _, _, e, ..) | Text(_, e) => e.as_node()
    Frag(_, s, _) | Slot(_, s, _) => s.as_node()
  }
}

///|
#cfg(target="js")
fn INode::end(s : Self) -> @dom.Node {
  match s {
    Elem(_, _, _, e, ..) | Text(_, e) => e.as_node()
    Frag(_, _, e) | Slot(_, _, e) => e.as_node()
  }
}

///|
#cfg(target="js")
fn INode::remove(self : Self, sandbox : Sandbox, parent : @dom.Node) -> Unit {
  for link in self.scan_direct_childs() {
    if link.val is Some(inst) {
      sandbox.drop_live_subtree(inst)
    }
    link.detach()
  }
  match self {
    Elem(_, _, _, e, ..) | Text(_, e) => parent.remove_child(e.as_node())
    Frag(_, s, e) | Slot(_, s, e) => {
      let s = s.as_node()
      let e = e.as_node()
      // guard s.get_parent_node().to_option() is Some(a) &&
      //   e.get_parent_node().to_option() is Some(b) &&
      //   a.is_same_node(b)
      while s.get_next_sibling().to_option() is Some(n) && !n.is_same_node(e) {
        parent.remove_child(n)
      }
      parent.remove_child(s)
      parent.remove_child(e)
    }
  }
}

///|
#cfg(target="js")
fn INode::relocate(
  self : Self,
  parent : @dom.Node,
  before : @js.Nullable[@dom.Node],
) -> Unit {
  match self {
    Elem(_, _, _, e, ..) | Text(_, e) =>
      parent.insert_before(e.as_node(), before)
    Frag(_, s, e) | Slot(_, s, e) => {
      {
        guard s.get_parent_node().to_option() is Some(a)
        guard e.get_parent_node().to_option() is Some(b)
        guard a.is_same_node(b)
      }
      let s = s.as_node()
      let e = e.as_node()
      let mut anchor = before
      while e.get_previous_sibling().to_option() is Some(n) &&
            !n.is_same_node(s) {
        parent.insert_before(n, anchor)
        anchor = nullable(n)
      }
      parent.insert_before(e, before)
      parent.insert_before(s, anchor)
    }
  }
}

///|
#cfg(target="js")
fn VNode::insert(
  self : Self,
  sandbox : Sandbox,
  parent_inst : Instance,
  parent : @dom.Node,
  before : @js.Nullable[@dom.Node],
) -> INode {
  match self {
    Text(s) => {
      let e = @dom.document().create_text_node(s)
      parent.insert_before(e.as_node(), before)
      Text(s, e)
    }
    // if c.dirty_flag() {
    //   c.refersh()
    // } 
    Slot(cell) => {
      // sandbox.subscribe(cell, c)
      let flags = cell.flags()
      flags.attach_count += 1
      let start = @dom.document().create_comment("")
      let end = @dom.document().create_comment("")
      let fragment = @dom.document().create_document_fragment()
      fragment.insert_before(start.as_node(), null())
      // let inter = 
      // match c.data().inode {
      //   None => {
      let inst = Instance::new(cell)
      let inode = cell.view().insert(sandbox, inst, fragment.as_node(), null())
      inst.inode = Some(inode)
      match sandbox.live_map.get(flags.id) {
        None =>
          sandbox.live_map[flags.id] = (
            inst.cell,
            Map::from_array([(inst.id, inst)]),
          )
        Some((_, map)) => map[inst.id] = inst
      }
      inst.link.val = Some(inst)
      parent_inst.new_childs[inst.id] = inst.link
      //     inter
      //   }
      //   Some(inter) => {
      //     inter.relocate(fragment.as_node(), null())
      //     inter
      //   }
      // }
      fragment.insert_before(end.as_node(), null())
      parent.insert_before(fragment.as_node(), before)
      Slot(inst, start, end)
    }
    Frag(childs) => {
      let doc = @dom.document()
      let fragment = doc.create_document_fragment()
      let start = doc.create_comment("start")
      let end = doc.create_comment("end")
      fragment.append_child(start.as_node())
      let childs = childs.map(fn(x) {
        x.insert(sandbox, parent_inst, fragment.as_node(), null())
      })
      fragment.append_child(end.as_node())
      parent.insert_before(fragment.as_node(), before)
      Frag(childs, start, end)
    }
    Elem(tag, properties, childs, namespace_uri~) => {
      let s = if tag == CAPTURED_LINK_TAG { "a" } else { tag }
      let doc = @dom.document()
      let element = match namespace_uri {
        None => doc.create_element(s)
        Some(ns) => doc.create_element_ns(ns, s)
      }
      let { slots, handlers, attrs, props, styles } = properties
      for e, h in handlers {
        let slot = @ref.new(h)
        element.add_event_listener(e, x => (slot.val)(x, sandbox))
        slots[e] = slot
      }
      if tag == CAPTURED_LINK_TAG {
        element.add_event_listener("click", sandbox.captured_link_listener)
      }
      for n, val in attrs {
        element.set_attribute(n, val)
      }
      for n, val in props {
        element.set_property(n, variant_to_js_value(val))
      }
      let sheet = if element.to_html_element() is Some(html) {
        html.get_style()
      } else if element.to_svg_element() is Some(svg) {
        svg.get_style()
      } else {
        panic()
      }
      for n, val in styles {
        sheet.set_property(n, val)
      }
      let n = element.as_node()
      let childs = match childs {
        Array(xs) =>
          Array(xs.map(x => x.insert(sandbox, parent_inst, n, null())))
        Map(mp) => {
          let imp = {}
          for k, v in mp {
            imp[k] = v.insert(sandbox, parent_inst, n, null())
          }
          Map(imp)
        }
      }
      parent.insert_before(n, before)
      Elem(tag, properties, childs, namespace_uri~, element)
    }
  }
}

///|
const CAPTURED_LINK_TAG : String = "RABBITA_CAPTURED_LINK"

///|
pub fn VNode::elem(
  tag : String,
  props : Props,
  children : Children[VNode],
  namespace_uri? : String,
) -> VNode {
  Elem(tag, props, children, namespace_uri~)
}

///|
pub fn VNode::text(s : String) -> VNode {
  Text(s)
}

///|
pub fn VNode::link(
  props : Props,
  children : Children[VNode],
  escape? : Bool = false,
) -> VNode {
  let tag = if escape { "a" } else { CAPTURED_LINK_TAG }
  VNode::elem(tag, props, children)
}

///|
pub fn VNode::slot(cell : &IsCell) -> VNode {
  Slot(cell)
}

///|
pub fn VNode::fragment(childs : Array[VNode]) -> VNode {
  Frag(childs)
}

///|
pub(all) enum Children[T] {
  Array(Array[T])
  Map(Map[String, T])
}

///|
#cfg(target="js")
type Event = @dom.Event

///|
#cfg(not(target="js"))
type Event = Unit

///|
pub struct Props {
  priv mut slots : Map[String, Ref[(Event, &Scheduler) -> Unit]]
  handlers : Map[String, (Event, &Scheduler) -> Unit]
  attrs : Map[String, String]
  props : Map[String, @variant.Variant]
  styles : Map[String, String]
}

///|
pub fn Props::new(
  attrs : Map[String, String],
  props : Map[String, @variant.Variant],
  styles : Map[String, String],
  handlers : Map[String, (Event, &Scheduler) -> Unit],
) -> Props {
  { slots: {}, handlers, attrs, styles, props }
}

///|
fn[K : Eq + Hash, V] copy_map(src : Map[K, V]) -> Map[K, V] {
  let dst = {}
  for k, v in src {
    dst[k] = v
  }
  dst
}

///|
pub fn Props::copy(self : Props) -> Props {
  {
    slots: copy_map(self.slots),
    handlers: copy_map(self.handlers),
    attrs: copy_map(self.attrs),
    props: copy_map(self.props),
    styles: copy_map(self.styles),
  }
}

///|
#cfg(target="js")
fn[T] nullable(x : T) -> @js.Nullable[T] {
  @js.Nullable::from_option(Some(x))
}

///|
#cfg(target="js")
fn[T] null() -> @js.Nullable[T] {
  @js.Nullable::null()
}

// extern "js" fn log_node(x : @js.Nullable[@dom.Node]) = "(x) => console.log(x)"

///|
#cfg(target="js")
fn diff_node(
  old : INode,
  new : VNode,
  sandbox : Sandbox,
  parent : @dom.Node,
  anchor : @js.Nullable[@dom.Node],
  parent_inst : Instance,
) -> INode {
  match (old, new) {
    (
      Elem(tag1, props1, childs1, namespace_uri=ns1, e),
      Elem(tag2, props2, childs2, namespace_uri=ns2),
    ) =>
      if tag1 != tag2 || ns1 != ns2 {
        old.remove(sandbox, parent.as_node())
        new.insert(sandbox, parent_inst, parent.as_node(), anchor)
      } else {
        diff_props(props1, props2, sandbox, e)
        let childs = diff_children(
          childs1,
          childs2,
          sandbox,
          e.as_node(),
          null(),
          parent_inst,
        )
        Elem(tag2, props2, childs, namespace_uri=ns2, e)
      }
    (Text(s1, e), Text(s2)) => {
      if s1 != s2 {
        e.set_node_value(@js.Nullable::from_option(Some(s2)))
      }
      Text(s2, e)
    }
    (Frag(childs1, s, e), Frag(childs2)) => {
      let childs = diff_children(
        Array(childs1),
        Array(childs2),
        sandbox,
        parent.as_node(),
        nullable(e.as_node()),
        parent_inst,
      )
      guard childs is Array(childs)
      Frag(childs, s, e)
    }
    (Slot(inst, _s, _e), Slot(c2)) =>
      if inst.cell.flags().id != c2.flags().id {
        old.remove(sandbox, parent.as_node())
        new.insert(sandbox, parent_inst, parent.as_node(), anchor)
      } else {
        old
      }
    (_, _) => {
      old.remove(sandbox, parent.as_node())
      new.insert(sandbox, parent_inst, parent.as_node(), anchor)
    }
  }
}

///|
#cfg(target="js")
fn diff_props(
  old : Props,
  new : Props,
  sandbox : Sandbox,
  parent : @dom.Element,
) -> Unit {
  // update event listeners slots
  let slots = old.slots
  for event, slot in slots {
    if !new.handlers.contains(event) {
      slot.val = fn(_, _) {  }
    }
  }
  for event, handler in new.handlers {
    match slots.get(event) {
      Some(slot) => slot.val = handler
      None => {
        let slot = @ref.new(handler)
        parent.add_event_listener(event, e => (slot.val)(e, sandbox))
        slots[event] = slot
      }
    }
  }
  new.slots = slots

  // O(n+m), TODO: use small sorted array to optimize this 
  // patch attributes
  for k, _ in old.attrs {
    if !new.attrs.contains(k) {
      parent.remove_attribute(k)
    }
  }
  for k, v2 in new.attrs {
    match old.attrs.get(k) {
      None => parent.set_attribute(k, v2)
      Some(v1) => if v1 != v2 { parent.set_attribute(k, v2) }
    }
  }
  // patch properties
  for k, _ in old.props {
    if !new.props.contains(k) {
      parent.remove_property(k)
    }
  }
  for k, v2 in new.props {
    match old.props.get(k) {
      None => parent.set_property(k, variant_to_js_value(v2))
      Some(v1) =>
        if v1 != v2 {
          parent.set_property(k, variant_to_js_value(v2))
        }
    }
  }
  // patch styles
  let stylesheet = if parent.to_html_element() is Some(html) {
    html.get_style()
  } else if parent.to_svg_element() is Some(svg) {
    svg.get_style()
  } else {
    panic()
  }
  for k, _ in old.styles {
    if !new.styles.contains(k) {
      stylesheet.remove_property(k) |> ignore
    }
  }
  for k, v2 in new.styles {
    match old.styles.get(k) {
      None => stylesheet.set_property(k, v2)
      Some(v1) => if v1 != v2 { stylesheet.set_property(k, v2) }
    }
  }
}

///|
#cfg(target="js")
fn diff_children(
  old : Children[INode],
  new : Children[VNode],
  sandbox : Sandbox,
  parent : @dom.Node,
  anchor : @js.Nullable[@dom.Node],
  parent_inst : Instance,
) -> Children[INode] {
  match (old, new) {
    (Array(old), Array(new)) => {
      // if old.length() == 3 && new.length() == 3 {
      //   println("---------------diff_children(Arr,Arr)")
      //   println(old.map(x => x.binding().to_string()))
      //   println(new.map(x => x.binding().to_string()))
      //   println("-------------------------------------")
      // }
      let len1 = old.length()
      let len2 = new.length()
      let mut before = anchor
      let acc = []
      let len = if len1 > len2 {
        for i in len1>..len2 {
          old[i].remove(sandbox, parent)
        }
        len2
      } else {
        for i in len2>..len1 {
          let inode = new[i].insert(sandbox, parent_inst, parent, before)
          acc.push(inode)
          before = nullable(inode.start())
        }
        len1
      }
      for i in len>..0 {
        let inode = diff_node(
          old[i],
          new[i],
          sandbox,
          parent,
          before,
          parent_inst,
        )
        acc.push(inode)
        before = nullable(inode.start())
      }
      Array(acc.rev())
    }
    (Map(old), Map(new)) => {
      for k, v1 in old {
        if !new.contains(k) {
          v1.remove(sandbox, parent)
        }
      }
      let order = new.to_array()
      let mut before = null()
      let reversed = []
      for i in order.length()>..0 {
        let (k, v2) = order[i]
        let inode = match old.get(k) {
          None => v2.insert(sandbox, parent_inst, parent, before)
          Some(v1) => {
            let inode = diff_node(v1, v2, sandbox, parent, before, parent_inst)
            inode.relocate(parent, before)
            inode
          }
        }
        reversed.push((k, inode))
        before = nullable(inode.start())
      }
      Map(Map::from_array(reversed))
    }
    (_, _) => {
      match old {
        Map(xs) => xs.each((_, x) => x.remove(sandbox, parent))
        Array(xs) => xs.each(x => x.remove(sandbox, parent))
      }
      new.map(y => y.insert(sandbox, parent_inst, parent, null()))
    }
  }
}

///|
fn[A, B] Children::map(c : Children[A], f : (A) -> B) -> Children[B] {
  match c {
    Array(arr) => Array(arr.map(f))
    Map(mp) => Map(mp.map((_, v) => f(v)))
  }
}

///|
#cfg(target="js")
fn variant_to_js_value(value : @variant.Variant) -> @js.Value {
  match value {
    String(value) => @js.Value::cast_from(value)
    Floating(value) => @js.Value::cast_from(value)
    Integer(value) => @js.Value::cast_from(value)
    Boolean(value) => @js.Value::cast_from(value)
  }
}
