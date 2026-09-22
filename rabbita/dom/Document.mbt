///|
#cfg(target="js")
#external
type Document

///|
#cfg(target="js")
pub impl @js.Cast for Document with fn into(value) {
  value |> ffi_to_document |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub extend Document with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for Document with fn from(value) {
  value |> js_identity
}

///|
#cfg(target="js")
pub impl IsEventTarget for Document

///|
#cfg(target="js")
pub extend Document with IsEventTarget::{
  add_event_listener,
  add_event_listener_with_options,
  as_event_target,
  dispatch_event,
  remove_event_listener,
  remove_event_listener_with_options,
  to_clipboard,
  to_comment,
  to_document,
  to_document_fragment,
  to_element,
  to_html_canvas_element,
  to_html_dialog_element,
  to_html_element,
  to_html_image_element,
  to_html_input_element,
  to_html_media_element,
  to_html_select_element,
  to_html_video_element,
  to_svg_element,
  to_svg_graphics_element,
  to_svg_image_element,
  to_text,
  to_window,
}

///|
#cfg(target="js")
pub extern "js" fn document() -> Document = "() => document"

///|
#cfg(target="js")
pub extern "js" fn Document::create_element(
  self : Self,
  tag : String,
) -> Element = "(doc,tag) => doc.createElement(tag)"

///|
pub let namespace_html = "http://www.w3.org/1999/xhtml"

///|
pub let namespace_svg = "http://www.w3.org/2000/svg"

///|
pub let namespace_mathml = "http://www.w3.org/1998/Math/MathML"

///|
#cfg(target="js")
pub extern "js" fn Document::create_element_ns(
  self : Self,
  namespace_uri : String,
  qualified_name : String,
  on_namespace_error? : (DOMException) -> Element = default_exception_handler,
  on_invalid_character_error? : (DOMException) -> Element = default_exception_handler,
) -> Element = "(doc,namespace,qualifiedName) => doc.createElementNS(namespace, qualifiedName)"

///|
#cfg(target="js")
pub extern "js" fn Document::create_text_node(
  self : Self,
  str : String,
) -> Element = "(doc,str) => doc.createTextNode(str)"

///|
#cfg(target="js")
pub extern "js" fn Document::create_comment(
  self : Self,
  str : String,
) -> Comment = "(doc,str) => doc.createComment(str)"

///|
#cfg(target="js")
pub extern "js" fn Document::create_document_fragment(
  self : Self,
) -> DocumentFragment = "(doc) => doc.createDocumentFragment()"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementById
#cfg(target="js")
pub extern "js" fn Document::get_element_by_id(
  self : Self,
  id : String,
) -> @js.Nullable[Element] = "(doc,id) => doc.getElementById(id)"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementsByClassName
#cfg(target="js")
pub extern "js" fn Document::get_elements_by_class_name(
  self : Self,
  names : String,
) -> HTMLCollection = "(doc,names) => doc.getElementsByClassName(names)"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementsByName
#cfg(target="js")
pub extern "js" fn Document::get_elements_by_name(
  self : Self,
  name : String,
) -> NodeList[Element] = "(doc,name) => doc.getElementsByName(name)"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementsByTagName
#cfg(target="js")
pub extern "js" fn Document::get_elements_by_tag_name(
  self : Self,
  tag : String,
) -> HTMLCollection = "(doc,tag) => doc.getElementsByTagName(tag)"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementsByTagNameNS
#cfg(target="js")
pub extern "js" fn Document::get_elements_by_tag_name_ns(
  self : Self,
  namespace_ : String,
  name : String,
) -> HTMLCollection = "(doc,namespace,name) => doc.getElementsByTagNameNS(namespace, name)"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelector
#cfg(target="js")
pub extern "js" fn Document::query_selector(
  self : Self,
  selectors : String,
) -> @js.Nullable[Element] = "(self,selectors) => self.querySelector(selectors)"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelectorAll
#cfg(target="js")
pub extern "js" fn Document::query_selector_all(
  self : Self,
  selectors : String,
) -> NodeList[Element] = "(self,selectors) => self.querySelectorAll(selectors)"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/activeElement
#cfg(target="js")
pub fn Document::get_active_element(self : Self) -> Element? {
  ffi_document_get_active_element(self).to_option()
}

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/head
#cfg(target="js")
pub fn Document::get_head(self : Self) -> HTMLElement? {
  ffi_document_get_head(self).to_option()
}

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/body
#cfg(target="js")
pub fn Document::get_body(self : Self) -> HTMLElement? {
  ffi_document_get_body(self).to_option()
}

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/documentElement
#cfg(target="js")
pub fn Document::get_document_element(self : Self) -> Element? {
  ffi_document_get_document_element(self).to_option()
}

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/elementFromPoint
#cfg(target="js")
pub fn Document::element_from_point(
  self : Self,
  x : Double,
  y : Double,
) -> Element? {
  ffi_document_element_from_point(self, x, y).to_option()
}

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/elementsFromPoint
#cfg(target="js")
pub fn Document::elements_from_point(
  self : Self,
  x : Double,
  y : Double,
) -> FixedArray[Element] {
  ffi_document_elements_from_point(self, x, y)
}

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/hidden
#cfg(target="js")
pub extern "js" fn Document::hidden(self : Self) -> Bool = "(doc) => doc.hidden"

///|
#cfg(target="js")
pub extern "js" fn Document::to_node(self : Self) -> Node = "(x) => x"

///|
#cfg(target="js")
extern "js" fn ffi_document_get_active_element(
  doc : Document,
) -> @js.Nullable[Element] = "(doc) => doc.activeElement"

///|
#cfg(target="js")
extern "js" fn ffi_document_get_head(
  doc : Document,
) -> @js.Nullable[HTMLElement] = "(doc) => doc.head"

///|
#cfg(target="js")
extern "js" fn ffi_document_get_body(
  doc : Document,
) -> @js.Nullable[HTMLElement] = "(doc) => doc.body"

///|
#cfg(target="js")
extern "js" fn ffi_document_get_document_element(
  doc : Document,
) -> @js.Nullable[Element] = "(doc) => doc.documentElement"

///|
#cfg(target="js")
extern "js" fn ffi_document_element_from_point(
  doc : Document,
  x : Double,
  y : Double,
) -> @js.Nullable[Element] = "(doc, x, y) => doc.elementFromPoint(x, y)"

///|
#cfg(target="js")
extern "js" fn ffi_document_elements_from_point(
  doc : Document,
  x : Double,
  y : Double,
) -> FixedArray[Element] = "(doc, x, y) => doc.elementsFromPoint(x, y)"
