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
#cfg(target="js")
pub extern "js" fn DataTransferItemList::length(self : Self) -> Int = "(l) => l.length"

///|
#cfg(target="js")
#alias("_[_]")
pub extern "js" fn DataTransferItemList::get(self : Self, index : Int) = "(l, i) => l[i]"

///|
#cfg(target="js")
pub extern "js" fn DataTransferItemList::add(
  self : Self,
  data : String,
  type_ : String,
) = "(l, d, t) => l.add(d, t)"

///|
#cfg(target="js")
pub extern "js" fn DataTransferItemList::remove(self : Self, index : Int) = "(l, i) => l.remove(i)"

///|
#cfg(target="js")
pub extern "js" fn DataTransferItemList::clear(self : Self) = "(l) => l.clear()"
