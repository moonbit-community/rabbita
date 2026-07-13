///|
pub trait IsChildren {
  fn to_children(Self) -> @runtime.Children[VNode]
}

///|
/// Build keyed children without allocating an intermediate `Map[String, Html]`.
pub fn keyed(children : Array[(String, Html)]) -> @runtime.Children[VNode] {
  let vnodes : Map[String, VNode] = Map([], capacity=children.length())
  for pair in children {
    let (key, child) = pair
    vnodes[key] = child.0
  }
  Map(vnodes)
}

///|
pub impl IsChildren for Html with fn to_children(html) {
  Array([html.0])
}

///|
pub impl IsChildren for String with fn to_children(str) {
  Array([text(str).0])
}

///|
pub impl IsChildren for Map[String, Html] with fn to_children(self) {
  Map(self.map((_, v) => v.0))
}

///|
pub impl IsChildren for Array[Html] with fn to_children(self) {
  Array(self.map(x => x.0))
}

///|
pub impl IsChildren for @list.List[Html] with fn to_children(self) {
  Array(self.map(x => x.0).to_array())
}

// ///|
// pub impl[H : IsHtml] IsChildren for Array[H] with to_children(self) {
//   Array(self.map(x => x.to_html()))
// }

///|
pub impl IsChildren for @runtime.Children[VNode] with fn to_children(children) {
  children
}
