///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLCollection
#cfg(target="js")
#external
type HTMLCollection

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLCollection/length
#cfg(target="js")
pub extern "js" fn HTMLCollection::get_length(self : Self) -> Double = "(self) => self.length"

///|
/// Returns the current number of elements in this live collection.
#cfg(target="js")
pub fn HTMLCollection::length(self : Self) -> Int32 {
  self.get_length().to_int()
}

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLCollection/item
#cfg(target="js")
pub extern "js" fn HTMLCollection::item(
  self : Self,
  index : Double,
) -> @js.Nullable[Element] = "(self,index) => self.item(index)"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLCollection/namedItem
#cfg(target="js")
pub extern "js" fn HTMLCollection::named_item(
  self : Self,
  key : String,
) -> @js.Nullable[Element] = "(self,key) => self.namedItem(key)"

///|
/// Iterates the collection without materializing an array.
///
/// `HTMLCollection` is live, so DOM changes made during iteration are visible
/// to subsequent iterator steps.
#cfg(target="js")
pub fn HTMLCollection::iter(self : Self) -> Iter[Element] {
  let mut index = 0.0
  Iter(fn() {
    let item = self.item(index).to_option()
    index += 1.0
    item
  })
}
