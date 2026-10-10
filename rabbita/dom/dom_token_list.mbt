///|
/// A live token list backed by the browser, such as `classList` or
/// `controlsList`. Mutations write through to the reflected DOM attribute.
/// Native DOM exceptions (including InvalidCharacterError and SyntaxError)
/// propagate unchanged.
#cfg(target="js")
#external
type DOMTokenList

///|
/// Number of tokens in this live list.
#cfg(target="js")
pub extern "js" fn DOMTokenList::length(self : Self) -> Int = "(self) => self.length"

///|
#cfg(target="js")
extern "js" fn DOMTokenList::item_ffi(
  self : Self,
  index : Int,
) -> @js.Nullable[String] = "(self, index) => self.item(index)"

///|
/// Returns the token at `index`, or `None` when the index is out of range.
#cfg(target="js")
pub fn DOMTokenList::item(self : Self, index : Int) -> String? {
  self.item_ffi(index).to_option()
}

///|
/// Whether the list contains `token`.
#cfg(target="js")
pub extern "js" fn DOMTokenList::contains(self : Self, token : String) -> Bool = "(self, token) => self.contains(token)"

///|
/// Appends `token` when it is missing. Throws InvalidCharacterError for tokens
/// containing ASCII whitespace and SyntaxError for the empty token.
#cfg(target="js")
pub extern "js" fn DOMTokenList::add(self : Self, token : String) -> Unit = "(self, token) => self.add(token)"

///|
/// Removes `token`. Throws the same native exceptions as `add`.
#cfg(target="js")
pub extern "js" fn DOMTokenList::remove(self : Self, token : String) -> Unit = "(self, token) => self.remove(token)"

///|
/// Adds `token` when missing and removes it when present. Returns whether the
/// token is present afterwards.
#cfg(target="js")
pub extern "js" fn DOMTokenList::toggle(self : Self, token : String) -> Bool = "(self, token) => self.toggle(token)"

///|
/// Forces `token` present or absent. Returns whether the token is present
/// afterwards.
#cfg(target="js")
pub extern "js" fn DOMTokenList::toggle_with_force(
  self : Self,
  token : String,
  force : Bool,
) -> Bool = "(self, token, force) => self.toggle(token, force)"

///|
/// Replaces `old_token` with `new_token`. Returns false when `old_token` is not
/// present, in which case the list is unchanged.
#cfg(target="js")
pub extern "js" fn DOMTokenList::replace(
  self : Self,
  old_token : String,
  new_token : String,
) -> Bool = "(self, oldToken, newToken) => self.replace(oldToken, newToken)"

///|
/// The whitespace-separated serialization of the list, shared with the
/// reflected attribute.
#cfg(target="js")
pub extern "js" fn DOMTokenList::get_value(self : Self) -> String = "(self) => self.value"

///|
/// Replaces the whole list with the whitespace-separated `value`.
#cfg(target="js")
pub extern "js" fn DOMTokenList::set_value(self : Self, value : String) -> Unit = "(self, value) => { self.value = value }"
