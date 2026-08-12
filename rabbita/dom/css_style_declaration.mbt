///|
/// The CSSStyleDeclaration interface represents an object that is a CSS declaration block, and exposes style information and various style-related methods and properties.
/// 
/// [mdn](https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleDeclaration)
#cfg(target="js")
#external
type CSSStyleDeclaration

///|
#cfg(target="js")
#external
type CSSRule

///|
#cfg(target="js")
pub impl @js.Cast for CSSStyleDeclaration with fn into(value) {
  value |> ffi_to_css_style_declaration |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub impl @js.Cast for CSSStyleDeclaration with fn from(value) {
  value |> js_identity
}

///|
/// Same as `get_property_value`
#cfg(target="js")
#alias("_[_]")
pub fn CSSStyleDeclaration::get(self : Self, property : String) -> String {
  self.get_property_value(property)
}

///|
/// Same as `set_property`
#cfg(target="js")
#alias("_[_]=_")
pub fn CSSStyleDeclaration::set(
  self : Self,
  property : String,
  value : String,
) -> Unit {
  self.set_property(property, value)
}

///|
/// Textual representation of the declaration block, if and only if it is exposed via HTMLElement.style.
#cfg(target="js")
pub extern "js" fn CSSStyleDeclaration::get_css_text(self : Self) -> String = "(self) => self.cssText"

///|
/// Textual representation of the declaration block, if and only if it is exposed via HTMLElement.style.
#cfg(target="js")
pub extern "js" fn CSSStyleDeclaration::set_css_text(
  self : Self,
  value : String,
) = "(self, value) => self.cssText = value"

///|
/// The number of properties.
#cfg(target="js")
pub extern "js" fn CSSStyleDeclaration::get_length(self : Self) -> Int = "(self) => self.length"

///|
/// The containing CSSRule.
#cfg(target="js")
pub fn CSSStyleDeclaration::get_parent_rule(self : Self) -> CSSRule? {
  ffi_css_style_declaration_get_parent_rule(self).to_option()
}

///|
/// Special alias for the float CSS property.
#cfg(target="js")
pub extern "js" fn CSSStyleDeclaration::get_css_float(self : Self) -> String = "(self) => self.cssFloat"

///|
/// Special alias for the float CSS property.
#cfg(target="js")
pub extern "js" fn CSSStyleDeclaration::set_css_float(
  self : Self,
  value : String,
) = "(self, value) => self.cssFloat = value"

///|
/// Returns the optional priority, "important".
#cfg(target="js")
pub extern "js" fn CSSStyleDeclaration::get_property_priority(
  self : Self,
  property : String,
) -> String = "(self, property) => self.getPropertyPriority(property)"

///|
/// Returns the property value given a property name.
#cfg(target="js")
pub extern "js" fn CSSStyleDeclaration::get_property_value(
  self : Self,
  property : String,
) -> String = "(self, property) => self.getPropertyValue(property)"

///|
/// Returns a CSS property name by its index, or the empty string if the index is out-of-bounds.
#cfg(target="js")
pub extern "js" fn CSSStyleDeclaration::item(
  self : Self,
  index : Int,
) -> String = "(self, index) => self.item(index)"

///|
/// Removes a property from the CSS declaration block.
#cfg(target="js")
pub extern "js" fn CSSStyleDeclaration::remove_property(
  self : Self,
  property : String,
) -> String = "(self, property) => self.removeProperty(property)"

///|
/// Modifies an existing CSS property or creates a new CSS property in the declaration block.
#cfg(target="js")
pub extern "js" fn CSSStyleDeclaration::set_property(
  self : Self,
  property : String,
  value : String,
) -> Unit = "(self, property, value) => self.setProperty(property, value)"

///|
/// Modifies an existing CSS property or creates a new CSS property in the declaration block with priority.
#cfg(target="js")
// FIXME: Can throw DOMException - ignoring error
pub extern "js" fn CSSStyleDeclaration::set_property_with_priority(
  self : Self,
  property : String,
  value : String,
  priority : String,
) = "(self, property, value, priority) => self.setProperty(property, value, priority)"

///|
#cfg(target="js")
extern "js" fn ffi_css_style_declaration_get_parent_rule(
  s : CSSStyleDeclaration,
) -> @js.Nullable[CSSRule] = "(s) => s.parentRule"

///|
#cfg(target="js")
extern "js" fn ffi_to_css_style_declaration(
  x : @js.Value,
) -> @js.Nullable[CSSStyleDeclaration] = "(x) => x instanceof CSSStyleDeclaration ? x : null"
