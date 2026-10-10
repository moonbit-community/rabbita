///|
#cfg(target="js")
#external
type DataTransfer

///|
#cfg(target="js")
pub extern "js" fn DataTransfer::drop_effect(self : Self) -> String = "(t) => t.dropEffect"

///|
#cfg(target="js")
pub extern "js" fn DataTransfer::effect_allowed(self : Self) -> String = "(t) => t.effectAllowed"

///|
#cfg(target="js")
pub extern "js" fn DataTransfer::items(self : Self) -> DataTransferItemList = "(t) => t.items"

///|
#cfg(target="js")
pub extern "js" fn DataTransfer::set_drog_image(
  self : Self,
  image : Element,
  x : Int,
  y : Int,
) = "(t, image, x, y) => t.setDragImage(image, x, y)"

///|
#cfg(target="js")
#external
type DataTransferItemList

///|
/// An item inside a host-backed drag data store. String items expose their
/// payload through `get_as_string`; the original platform object is preserved.
#cfg(target="js")
#external
type DataTransferItem

///|
#cfg(target="js")
pub extern "js" fn DataTransferItemList::length(self : Self) -> Int = "(l) => l.length"

///|
#cfg(target="js")
extern "js" fn DataTransferItemList::get_ffi(
  self : Self,
  index : Int,
) -> @js.Nullable[DataTransferItem] = "(l, i) => l[i] ?? null"

///|
/// Returns the item at `index`, or `None` when the index is out of range.
#cfg(target="js")
#alias("_[_]")
pub fn DataTransferItemList::get(self : Self, index : Int) -> DataTransferItem? {
  self.get_ffi(index).to_option()
}

///|
#cfg(target="js")
extern "js" fn DataTransferItemList::add_ffi(
  self : Self,
  data : String,
  type_ : String,
) -> @js.Nullable[DataTransferItem] = "(l, d, t) => l.add(d, t)"

///|
/// Adds a string item and returns it. Returns `None` when the list is not in
/// write mode instead of throwing.
#cfg(target="js")
pub fn DataTransferItemList::add(
  self : Self,
  data : String,
  type_ : String,
) -> DataTransferItem? {
  self.add_ffi(data, type_).to_option()
}

///|
/// Removes the item at `index`. Throws InvalidStateError when the list is not in
/// write mode.
#cfg(target="js")
pub extern "js" fn DataTransferItemList::remove(self : Self, index : Int) = "(l, i) => l.remove(i)"

///|
/// Removes every item. Does nothing when the list is not in write mode.
#cfg(target="js")
pub extern "js" fn DataTransferItemList::clear(self : Self) = "(l) => l.clear()"

///|
/// Either "string" or "file".
#cfg(target="js")
pub extern "js" fn DataTransferItem::get_kind(self : Self) -> String = "(i) => i.kind"

///|
/// The item's MIME type.
#cfg(target="js")
pub extern "js" fn DataTransferItem::get_type(self : Self) -> String = "(i) => i.type"

///|
/// Reads the string payload through the native asynchronous callback.
#cfg(target="js")
pub extern "js" fn DataTransferItem::get_as_string(
  self : Self,
  callback : (String) -> Unit,
) -> Unit = "(i, callback) => i.getAsString(callback)"
