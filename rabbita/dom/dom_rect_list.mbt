///|
/// https://drafts.csswg.org/geometry/#DOMRectList
#cfg(target="js")
#external
type DOMRectList

///|
/// https://drafts.csswg.org/geometry/#dom-domrectlist-length
#cfg(target="js")
pub extern "js" fn DOMRectList::get_length(self : Self) -> Double = "(self) => self.length"

///|
/// Returns the number of rectangles in this static collection.
#cfg(target="js")
pub fn DOMRectList::length(self : Self) -> Int32 {
  self.get_length().to_int()
}

///|
/// https://drafts.csswg.org/geometry/#dom-domrectlist-item
#cfg(target="js")
pub extern "js" fn DOMRectList::item(
  self : Self,
  index : Double,
) -> @js.Nullable[DOMRect] = "(self, index) => self.item(index)"

///|
/// Iterates this static collection without materializing an array.
#cfg(target="js")
pub fn DOMRectList::iter(self : Self) -> Iter[DOMRect] {
  let mut index = 0.0
  Iter(fn() {
    let item = self.item(index).to_option()
    index += 1.0
    item
  })
}
