///|
pub trait IsChildren {
  fn to_children(Self) -> @vdom.Children[VNode]
}

///|
pub impl IsChildren for Html with fn to_children(html) {
  Array([html.0])
}

///|
pub extend Html with IsChildren::{to_children}

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
pub impl IsChildren for @vector.Vector[Html] with fn to_children(self) {
  Array(self.iter().map(x => x.0).to_array())
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
pub impl IsChildren for @vdom.Children[VNode] with fn to_children(children) {
  children
}
