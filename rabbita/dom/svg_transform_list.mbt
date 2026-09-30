///|
/// The live base and animated views of an SVG transform attribute.
#cfg(target="js")
#external
type SVGAnimatedTransformList

///|
/// A browser-owned transform item. No mutation methods are exposed here,
/// so items obtained from animated lists are not presented as writable.
#cfg(target="js")
#external
type SVGTransform

///|
/// A live, mutable base transform list. Native DOM exceptions propagate.
#cfg(target="js")
#external
type SVGTransformList

///|
/// A live animated transform list, exposing only read operations.
/// This is a separate type, not a copy of the browser's list.
#cfg(target="js")
#external
type SVGTransformListReadOnly

///|
/// Returns the mutable base list. The baseVal property itself is read-only.
#cfg(target="js")
pub extern "js" fn SVGAnimatedTransformList::get_base_val(
  self : Self,
) -> SVGTransformList = "(self) => self.baseVal"

///|
/// Returns the live read-only animated list, including while no animation runs.
#cfg(target="js")
pub extern "js" fn SVGAnimatedTransformList::get_anim_val(
  self : Self,
) -> SVGTransformListReadOnly = "(self) => self.animVal"

///|
/// Number of items in this live list.
#cfg(target="js")
pub extern "js" fn SVGTransformList::get_length(self : Self) -> Double = "(self) => self.length"

///|
/// The SVG numberOfItems alias for length.
#cfg(target="js")
pub extern "js" fn SVGTransformList::get_number_of_items(self : Self) -> Double = "(self) => self.numberOfItems"

///|
/// Returns the current item count as an Int.
#cfg(target="js")
pub fn SVGTransformList::length(self : Self) -> Int {
  self.get_length().to_int()
}

///|
/// Returns the item at index. The browser throws IndexSizeError out of bounds.
#cfg(target="js")
pub extern "js" fn SVGTransformList::get_item(
  self : Self,
  index : Double,
) -> SVGTransform = "(self, index) => self.getItem(index)"

///|
/// Removes all items from the reflected attribute.
#cfg(target="js")
pub extern "js" fn SVGTransformList::clear(self : Self) -> Unit = "(self) => self.clear()"

///|
/// Replaces the list with one item and returns that item.
#cfg(target="js")
pub extern "js" fn SVGTransformList::initialize(
  self : Self,
  item : SVGTransform,
) -> SVGTransform = "(self, item) => self.initialize(item)"

///|
/// Inserts before index, or appends if index is past the end.
#cfg(target="js")
pub extern "js" fn SVGTransformList::insert_item_before(
  self : Self,
  item : SVGTransform,
  index : Double,
) -> SVGTransform = "(self, item, index) => self.insertItemBefore(item, index)"

///|
/// Replaces the item at index. Throws the native IndexSizeError out of bounds.
#cfg(target="js")
pub extern "js" fn SVGTransformList::replace_item(
  self : Self,
  item : SVGTransform,
  index : Double,
) -> SVGTransform = "(self, item, index) => self.replaceItem(item, index)"

///|
/// Removes and returns the item at index. Throws IndexSizeError out of bounds.
#cfg(target="js")
pub extern "js" fn SVGTransformList::remove_item(
  self : Self,
  index : Double,
) -> SVGTransform = "(self, index) => self.removeItem(index)"

///|
/// Appends and returns the item, preserving native SVG list ownership rules.
#cfg(target="js")
pub extern "js" fn SVGTransformList::append_item(
  self : Self,
  item : SVGTransform,
) -> SVGTransform = "(self, item) => self.appendItem(item)"

///|
/// Combines the base transforms into one matrix transform; null for an empty list.
#cfg(target="js")
pub extern "js" fn SVGTransformList::consolidate(
  self : Self,
) -> @js.Nullable[SVGTransform] = "(self) => self.consolidate()"

///|
/// Number of items in this live list.
#cfg(target="js")
pub extern "js" fn SVGTransformListReadOnly::get_length(self : Self) -> Double = "(self) => self.length"

///|
/// The SVG numberOfItems alias for length.
#cfg(target="js")
pub extern "js" fn SVGTransformListReadOnly::get_number_of_items(
  self : Self,
) -> Double = "(self) => self.numberOfItems"

///|
/// Returns the current item count as an Int.
#cfg(target="js")
pub fn SVGTransformListReadOnly::length(self : Self) -> Int {
  self.get_length().to_int()
}

///|
/// Returns the item at index. The browser throws IndexSizeError out of bounds.
#cfg(target="js")
pub extern "js" fn SVGTransformListReadOnly::get_item(
  self : Self,
  index : Double,
) -> SVGTransform = "(self, index) => self.getItem(index)"
