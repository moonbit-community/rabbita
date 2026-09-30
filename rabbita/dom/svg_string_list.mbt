///|
/// A live SVG string list backed by the browser.
/// Native DOM exceptions (including IndexSizeError) propagate unchanged.
#cfg(target="js")
#external
type SVGStringList

///|
/// Number of items in this live list.
#cfg(target="js")
pub extern "js" fn SVGStringList::get_length(self : Self) -> Double = "(self) => self.length"

///|
/// The SVG numberOfItems alias for length.
#cfg(target="js")
pub extern "js" fn SVGStringList::get_number_of_items(self : Self) -> Double = "(self) => self.numberOfItems"

///|
/// Returns the current item count as an Int.
#cfg(target="js")
pub fn SVGStringList::length(self : Self) -> Int {
  self.get_length().to_int()
}

///|
/// Returns the item at index. The browser throws IndexSizeError out of bounds.
#cfg(target="js")
pub extern "js" fn SVGStringList::get_item(
  self : Self,
  index : Double,
) -> String = "(self, index) => self.getItem(index)"

///|
/// Removes all items from the reflected attribute.
#cfg(target="js")
pub extern "js" fn SVGStringList::clear(self : Self) -> Unit = "(self) => self.clear()"

///|
/// Replaces the list with one item and returns that item.
#cfg(target="js")
pub extern "js" fn SVGStringList::initialize(
  self : Self,
  item : String,
) -> String = "(self, item) => self.initialize(item)"

///|
/// Inserts before index, or appends if index is past the end.
#cfg(target="js")
pub extern "js" fn SVGStringList::insert_item_before(
  self : Self,
  item : String,
  index : Double,
) -> String = "(self, item, index) => self.insertItemBefore(item, index)"

///|
/// Replaces the item at index. Throws the native IndexSizeError out of bounds.
#cfg(target="js")
pub extern "js" fn SVGStringList::replace_item(
  self : Self,
  item : String,
  index : Double,
) -> String = "(self, item, index) => self.replaceItem(item, index)"

///|
/// Removes and returns the item at index. Throws IndexSizeError out of bounds.
#cfg(target="js")
pub extern "js" fn SVGStringList::remove_item(
  self : Self,
  index : Double,
) -> String = "(self, index) => self.removeItem(index)"

///|
/// Appends and returns the item, preserving native SVG list ownership rules.
#cfg(target="js")
pub extern "js" fn SVGStringList::append_item(
  self : Self,
  item : String,
) -> String = "(self, item) => self.appendItem(item)"
