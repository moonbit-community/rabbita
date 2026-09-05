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
pub impl Eq for VNode with fn equal(a, b) {
  physical_equal(a, b)
}

///|
const CAPTURED_LINK_TAG : String = "RABBITA_CAPTURED_LINK"

///|
const FRAGMENT_START_MARKER : String = "["

///|
const FRAGMENT_END_MARKER : String = "]"

///|
fn rendered_tag(tag : String) -> String {
  if tag == CAPTURED_LINK_TAG {
    "a"
  } else {
    tag
  }
}

///|
#cfg(target="js")
fn is_captured_link_tag(tag : String) -> Bool {
  tag == CAPTURED_LINK_TAG
}

///|
fn is_html_void_element(tag : String) -> Bool {
  match tag {
    "area"
    | "base"
    | "br"
    | "col"
    | "embed"
    | "hr"
    | "img"
    | "input"
    | "link"
    | "meta"
    | "param"
    | "source"
    | "track"
    | "wbr" => true
    _ => false
  }
}

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
pub fn VNode::document(props : Props, head : VNode, body : VNode) -> VNode {
  Elem("html", props, Array([head, body]), namespace_uri=None)
}

///|
pub(all) enum Children[T] {
  Array(Array[T])
  Map(Map[String, T])
  RawHtml(String)
}

///|
#cfg(target="js")
type Event = @dom.Event

///|
#cfg(not(target="js"))
type Event = Unit

///|
pub struct Props {
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
  { handlers, attrs, styles, props, }
}

///|
fn[K : Eq + Hash, V] copy_map(src : Map[K, V]) -> Map[K, V] {
  let dst : Map[K, V] = Map([])
  for k, v in src {
    dst[k] = v
  }
  dst
}

///|
pub fn Props::copy(self : Props) -> Props {
  {
    handlers: copy_map(self.handlers),
    attrs: copy_map(self.attrs),
    props: copy_map(self.props),
    styles: copy_map(self.styles),
  }
}
