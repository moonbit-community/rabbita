///|
/// https://developer.mozilla.org/en-US/docs/Web/API/NodeList
#cfg(target="js")
#external
type NodeList[T]

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/NodeList/length
#cfg(target="js")
pub fn[T] NodeList::get_length(self : NodeList[T]) -> Double {
  node_list_get_length(@js.Value::cast_from(self))
}

///|
/// Returns the number of nodes in this collection.
#cfg(target="js")
pub fn[T] NodeList::length(self : NodeList[T]) -> Int32 {
  self.get_length().to_int()
}

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/NodeList/item
#cfg(target="js")
pub fn[T] NodeList::item(self : NodeList[T], index : Double) -> @js.Nullable[T] {
  @js.Value::cast_from(node_list_item(@js.Value::cast_from(self), index)).cast()
}

///|
/// Iterates this collection without materializing an array.
#cfg(target="js")
pub fn[T] NodeList::iter(self : NodeList[T]) -> Iter[T] {
  let mut index = 0.0
  Iter(fn() {
    let item = self.item(index).to_option()
    index += 1.0
    item
  })
}

///|
#cfg(target="js")
extern "js" fn node_list_get_length(list : @js.Value) -> Double = "(list) => list.length"

///|
#cfg(target="js")
extern "js" fn node_list_item(list : @js.Value, index : Double) -> @js.Value = "(list, index) => list.item(index)"
