///|
using @cmd {trait Scheduler}

///|
#warnings("-unused_constructor")
pub enum VNode {
  Elem(String, Props, Children[VNode], namespace_uri~ : String?)
  Text(String)
  Frag(Array[VNode])
  Thunk(Int, () -> VNode)
}

///|
pub impl Eq for VNode with fn equal(_, _) {
  false
}

///|
#cfg(target="js")
priv enum INode {
  Elem(
    VNode,
    String,
    Props,
    Children[INode],
    namespace_uri~ : String?,
    @dom.Element
  )
  Text(VNode, String, @dom.Element)
  Frag(VNode, Array[INode], @dom.Comment, @dom.Comment)
  Thunk(VNode, Int, INode)
}

///|
#cfg(target="js")
fn INode::vnode(self : Self) -> VNode {
  match self {
    Elem(vnode, _, _, _, namespace_uri=_, _) => vnode
    Text(vnode, _, _) => vnode
    Frag(vnode, _, _, _) => vnode
    Thunk(vnode, _, _) => vnode
  }
}

///|
#cfg(target="js")
fn INode::start(s : Self) -> @dom.Node {
  match s {
    Elem(_, _, _, _, namespace_uri=_, e) | Text(_, _, e) => e.as_node()
    Thunk(_, _, n) => n.start()
    Frag(_, _, s, _) => s.as_node()
  }
}

///|
#cfg(target="js")
fn INode::end(s : Self) -> @dom.Node {
  match s {
    Elem(_, _, _, _, namespace_uri=_, e) | Text(_, _, e) => e.as_node()
    Thunk(_, _, n) => n.end()
    Frag(_, _, _, e) => e.as_node()
  }
}

///|
#cfg(target="js")
fn INode::remove(self : Self, sandbox : Sandbox, parent : @dom.Node) -> Unit {
  match self {
    Elem(_, _, _, _, namespace_uri=_, e) | Text(_, _, e) =>
      parent.remove_child(e.as_node())
    Thunk(_, _, inode) => inode.remove(sandbox, parent)
    Frag(_, _, s, e) => {
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
    Elem(_, _, _, _, namespace_uri=_, e) | Text(_, _, e) =>
      parent.insert_before(e.as_node(), before)
    Thunk(_, _, inode) => inode.relocate(parent, before)
    Frag(_, _, s, e) => {
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
  parent : @dom.Node,
  before : @js.Nullable[@dom.Node],
) -> INode {
  match self {
    Text(s) => {
      let e = @dom.document().create_text_node(s)
      parent.insert_before(e.as_node(), before)
      Text(self, s, e)
    }
    Thunk(hash, render) => {
      let inode = render().insert(sandbox, parent, before)
      Thunk(self, hash, inode)
    }
    Frag(childs) => {
      let doc = @dom.document()
      let fragment = doc.create_document_fragment()
      let start = doc.create_comment("start")
      let end = doc.create_comment("end")
      fragment.append_child(start.as_node())
      let childs = childs.map(fn(x) {
        x.insert(sandbox, fragment.as_node(), null())
      })
      fragment.append_child(end.as_node())
      parent.insert_before(fragment.as_node(), before)
      Frag(self, childs, start, end)
    }
    Elem(tag, properties, childs, namespace_uri~) => {
      // Event listener slots belong to one mounted occurrence. Keep them out of
      // the source VNode so sharing a VNode across mount points remains safe.
      let properties = properties.mounted_copy()
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
      let childs : Children[INode] = if is_html_void_element(tag) {
        Array([])
      } else {
        match childs {
          Array(xs) => Array(xs.map(x => x.insert(sandbox, n, null())))
          Map(mp) => {
            let imp = {}
            for k, v in mp {
              imp[k] = v.insert(sandbox, n, null())
            }
            Map(imp)
          }
        }
      }
      parent.insert_before(n, before)
      Elem(self, tag, properties, childs, namespace_uri~, element)
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
test {
  let props = { slots: {}, handlers: {}, attrs: {}, props: {}, styles: {} }
  props.slots = {}
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
fn Props::mounted_copy(self : Props) -> Props {
  {
    slots: {},
    handlers: self.handlers,
    attrs: self.attrs,
    props: self.props,
    styles: self.styles,
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
) -> INode {
  if physical_equal(old.vnode(), new) {
    old
  } else {
    match (old, new) {
      (
        Elem(_, tag1, props1, childs1, namespace_uri=ns1, e),
        Elem(tag2, props2, childs2, namespace_uri=ns2),
      ) =>
        if tag1 != tag2 || ns1 != ns2 {
          old.remove(sandbox, parent.as_node())
          new.insert(sandbox, parent.as_node(), anchor)
        } else {
          // `diff_props` installs listener slots into its second argument, so
          // retain an occurrence-local snapshot instead of mutating the VNode.
          let props2 = props2.mounted_copy()
          diff_props(props1, props2, sandbox, e)
          let childs = diff_children(
            childs1,
            childs2,
            sandbox,
            e.as_node(),
            null(),
          )
          Elem(new, tag2, props2, childs, namespace_uri=ns2, e)
        }
      (Text(_, s1, e), Text(s2)) => {
        if s1 != s2 {
          e.set_node_value(@js.Nullable::from_option(Some(s2)))
        }
        Text(new, s2, e)
      }
      (Frag(_, childs1, s, e), Frag(childs2)) => {
        let childs = diff_children(
          Array(childs1),
          Array(childs2),
          sandbox,
          parent.as_node(),
          nullable(e.as_node()),
        )
        guard childs is Array(childs)
        Frag(new, childs, s, e)
      }
      (Thunk(_, hash1, inode), Thunk(hash2, render)) =>
        if hash1 == hash2 {
          // Keep the latest wrapper so a subsequent diff against this exact
          // VNode can take the physical-identity fast path.
          Thunk(new, hash2, inode)
        } else {
          let vnode = render()
          let inode = diff_node(inode, vnode, sandbox, parent, anchor)
          Thunk(new, hash2, inode)
        }
      (_, _) => {
        old.remove(sandbox, parent.as_node())
        new.insert(sandbox, parent.as_node(), anchor)
      }
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
fn lis_members(old_positions : Array[Int]) -> Array[Bool] {
  let members = Array::make(old_positions.length(), false)
  let mut previous = -1
  let mut already_increasing = true
  for index, old_position in old_positions {
    if old_position >= 0 {
      members[index] = true
      if old_position <= previous {
        already_increasing = false
      }
      previous = old_position
    }
  }
  if already_increasing {
    return members
  }
  let predecessors = Array::make(old_positions.length(), -1)
  // Each entry is a new-order index. The old position at that index is the
  // smallest tail found for an increasing subsequence of this length.
  let tails : Array[Int] = []
  for index, old_position in old_positions {
    if old_position < 0 {
      continue
    }
    let mut low = 0
    let mut high = tails.length()
    while low < high {
      let middle = low + (high - low) / 2
      if old_positions[tails[middle]] < old_position {
        low = middle + 1
      } else {
        high = middle
      }
    }
    if low > 0 {
      predecessors[index] = tails[low - 1]
    }
    if low == tails.length() {
      tails.push(index)
    } else {
      tails[low] = index
    }
  }
  for index, _ in members {
    members[index] = false
  }
  if tails.last() is Some(last) {
    let mut index = last
    while index >= 0 {
      members[index] = true
      index = predecessors[index]
    }
  }
  members
}

///|
#cfg(target="js")
fn diff_children(
  old : Children[INode],
  new : Children[VNode],
  sandbox : Sandbox,
  parent : @dom.Node,
  anchor : @js.Nullable[@dom.Node],
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
          let inode = new[i].insert(sandbox, parent, before)
          acc.push(inode)
          before = nullable(inode.start())
        }
        len1
      }
      for i in len>..0 {
        let inode = diff_node(old[i], new[i], sandbox, parent, before)
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
      let old_order = old.to_array()
      let order = new.to_array()
      let mut same_key_order = old_order.length() == order.length()
      if same_key_order {
        for index, pair in order {
          let (key, _) = pair
          if old_order[index].0 != key {
            same_key_order = false
            break
          }
        }
      }
      let stable = if same_key_order {
        ([] : Array[Bool])
      } else {
        let old_positions : Map[String, Int] = {}
        for index, pair in old_order {
          let (key, _) = pair
          old_positions[key] = index
        }
        let positions = order.map(pair => {
          let (key, _) = pair
          old_positions.get(key).unwrap_or(-1)
        })
        lis_members(positions)
      }
      let mut before = anchor
      let reversed = []
      for i in order.length()>..0 {
        let (k, v2) = order[i]
        let inode = match old.get(k) {
          None => v2.insert(sandbox, parent, before)
          Some(v1) =>
            if same_key_order || stable[i] {
              diff_node(v1, v2, sandbox, parent, before)
            } else {
              let old_start = v1.start()
              let inode = diff_node(v1, v2, sandbox, parent, before)
              // A replacement is already inserted at `before`; only an
              // existing mounted range that survived diffing needs relocation.
              if old_start.is_same_node(inode.start()) {
                inode.relocate(parent, before)
              }
              inode
            }
        }
        reversed.push((k, inode))
        before = nullable(inode.start())
      }
      Map(Map::from_array(reversed.rev()))
    }
    (_, _) => {
      match old {
        Map(xs) => xs.each((_, x) => x.remove(sandbox, parent))
        Array(xs) => xs.each(x => x.remove(sandbox, parent))
      }
      match new {
        Array(xs) =>
          Array(xs.map(vnode => vnode.insert(sandbox, parent, anchor)))
        Map(xs) => {
          // `Map::map` evaluates its callback from tail to head while cloning
          // the linked structure. Mount explicitly in insertion order because
          // DOM insertion is an observable side effect.
          let mounted = {}
          for key, vnode in xs {
            mounted[key] = vnode.insert(sandbox, parent, anchor)
          }
          Map(mounted)
        }
      }
    }
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
