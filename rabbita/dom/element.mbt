///|
#cfg(target="js")
#external
type Element

///|
#cfg(target="js")
pub trait IsElement: IsNode {
  fn as_element(Self) -> Element = _
  fn get_children(Self) -> HTMLCollection = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Element/querySelector
  fn query_selector(Self, String) -> Element? = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Element/querySelectorAll
  fn query_selector_all(Self, String) -> NodeList[Element] = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Element/closest
  fn closest(Self, String) -> Element? = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Element/matches
  fn matches(Self, String) -> Bool = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Element/hasAttribute
  fn has_attribute(Self, String) -> Bool = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Element/clientWidth
  fn get_client_width(Self) -> Double = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Element/clientHeight
  fn get_client_height(Self) -> Double = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Element/clientLeft
  fn get_client_left(Self) -> Double = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Element/clientTop
  fn get_client_top(Self) -> Double = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Element/getClientRects
  fn get_client_rects(Self) -> DOMRectList = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Element/setPointerCapture
  fn set_pointer_capture(Self, Int) -> Unit = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Element/releasePointerCapture
  fn release_pointer_capture(Self, Int) -> Unit = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Element/hasPointerCapture
  fn has_pointer_capture(Self, Int) -> Bool = _
  fn set_attribute(Self, String, String) -> Unit = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Element/getAttribute
  fn get_attribute(Self, String) -> String? = _
  fn remove_attribute(Self, String) -> Unit = _
  fn set_property(Self, String, @js.Value) -> Unit = _
  fn get_property(Self, String) -> @js.Optional[String] = _
  fn remove_property(Self, String) -> Unit = _
  fn scroll_into_view(Self, behavior? : String) -> Unit = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollIntoView
  fn scroll_into_view_with_options(
    Self,
    behavior? : String,
    block? : String,
    inline? : String,
    container? : String,
  ) -> Unit = _
  fn get_scroll_top(Self) -> Double = _
  fn set_scroll_top(Self, Double) -> Unit = _
  fn get_scroll_left(Self) -> Double = _
  fn set_scroll_left(Self, Double) -> Unit = _
  fn get_scroll_width(Self) -> Double = _
  fn get_scroll_height(Self) -> Double = _
  fn set_inner_html(Self, String) -> Unit = _
  fn get_bounding_client_rect(Self) -> DOMRect = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Element/getAnimations
  fn get_animations(Self) -> FixedArray[Animation] = _
}

///|
#cfg(target="js")
pub impl IsEventTarget for Element

///|
#cfg(target="js")
pub extend Element with IsEventTarget::{
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
  to_node,
  to_svg_element,
  to_svg_graphics_element,
  to_svg_image_element,
  to_text,
  to_window,
}

///|
#cfg(target="js")
pub impl @js.Cast for Element with fn into(value) {
  value |> ffi_to_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub extend Element with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for Element with fn from(value) {
  value |> js_identity
}

///|
#cfg(target="js")
pub impl IsNode for Element

///|
#cfg(target="js")
pub extend Element with IsNode::{
  append_child,
  as_node,
  contains,
  get_child,
  get_child_count,
  get_first_child,
  get_is_connected,
  get_last_child,
  get_next_sibling,
  get_node_name,
  get_node_type,
  get_node_value,
  get_parent_element,
  get_parent_node,
  get_previous_sibling,
  insert_before,
  is_same_node,
  remove_child,
  replace_child,
  set_node_value,
}

///|
#cfg(target="js")
pub impl IsElement for Element

///|
#cfg(target="js")
pub extend Element with IsElement::{
  as_element,
  closest,
  get_animations,
  get_attribute,
  get_bounding_client_rect,
  get_children,
  get_client_height,
  get_client_left,
  get_client_rects,
  get_client_top,
  get_client_width,
  get_property,
  get_scroll_height,
  get_scroll_left,
  get_scroll_top,
  get_scroll_width,
  has_attribute,
  has_pointer_capture,
  matches,
  query_selector,
  query_selector_all,
  release_pointer_capture,
  remove_attribute,
  remove_property,
  scroll_into_view,
  scroll_into_view_with_options,
  set_attribute,
  set_inner_html,
  set_pointer_capture,
  set_property,
  set_scroll_left,
  set_scroll_top,
}

///|
#cfg(target="js")
impl IsElement with fn as_element(s) {
  js_identity(s)
}

///|
#cfg(target="js")
impl IsElement with fn get_children(s) {
  s |> js_identity |> ffi_element_children
}

///|
#cfg(target="js")
impl IsElement with fn query_selector(s, selectors) {
  s
  |> js_identity
  |> ffi_element_query_selector(selectors)
  |> result => { result.to_option() }
}

///|
#cfg(target="js")
impl IsElement with fn query_selector_all(s, selectors) {
  ffi_element_query_selector_all(js_identity(s), selectors)
}

///|
#cfg(target="js")
impl IsElement with fn closest(s, selectors) {
  s
  |> js_identity
  |> ffi_element_closest(selectors)
  |> result => { result.to_option() }
}

///|
#cfg(target="js")
impl IsElement with fn matches(s, selectors) {
  s |> js_identity |> ffi_element_matches(selectors)
}

///|
#cfg(target="js")
impl IsElement with fn has_attribute(s, attr) {
  s |> js_identity |> ffi_element_has_attribute(attr)
}

///|
#cfg(target="js")
impl IsElement with fn get_client_width(s) {
  s |> js_identity |> ffi_element_get_client_width
}

///|
#cfg(target="js")
impl IsElement with fn get_client_height(s) {
  s |> js_identity |> ffi_element_get_client_height
}

///|
#cfg(target="js")
impl IsElement with fn get_client_left(s) {
  s |> js_identity |> ffi_element_get_client_left
}

///|
#cfg(target="js")
impl IsElement with fn get_client_top(s) {
  s |> js_identity |> ffi_element_get_client_top
}

///|
#cfg(target="js")
impl IsElement with fn get_client_rects(s) {
  ffi_element_get_client_rects(js_identity(s))
}

///|
#cfg(target="js")
impl IsElement with fn set_pointer_capture(s, pointer_id) {
  s |> js_identity |> ffi_element_set_pointer_capture(pointer_id)
}

///|
#cfg(target="js")
impl IsElement with fn release_pointer_capture(s, pointer_id) {
  s |> js_identity |> ffi_element_release_pointer_capture(pointer_id)
}

///|
#cfg(target="js")
impl IsElement with fn has_pointer_capture(s, pointer_id) {
  s |> js_identity |> ffi_element_has_pointer_capture(pointer_id)
}

///|
#cfg(target="js")
impl IsElement with fn set_attribute(s, attr, value) {
  s |> js_identity |> ffi_element_set_attribute(attr, value)
}

///|
#cfg(target="js")
impl IsElement with fn get_attribute(s, attr) {
  s
  |> js_identity
  |> ffi_element_get_attribute(attr)
  |> value => { value.to_option() }
}

///|
#cfg(target="js")
impl IsElement with fn remove_attribute(s, attr) {
  s |> js_identity |> ffi_element_remove_attribute(attr)
}

///|
#cfg(target="js")
impl IsElement with fn set_property(s, prop, value) {
  s |> js_identity |> ffi_element_set_property(prop, value)
}

///|
#cfg(target="js")
impl IsElement with fn get_property(s, prop) {
  s |> js_identity |> ffi_element_get_property(prop)
}

///|
#cfg(target="js")
impl IsElement with fn remove_property(s, prop) {
  s |> js_identity |> ffi_element_remove_property(prop)
}

///|
#cfg(target="js")
impl IsElement with fn scroll_into_view(s, behavior?) {
  let behavior = match behavior {
    Some(behavior) => behavior
    None => "auto"
  }
  s |> js_identity |> ffi_element_scroll_into_view(behavior)
}

///|
#cfg(target="js")
impl IsElement with fn scroll_into_view_with_options(
  s,
  behavior?,
  block?,
  inline?,
  container?,
) {
  let behavior = behavior.unwrap_or("auto")
  let block = block.unwrap_or("start")
  let inline = inline.unwrap_or("nearest")
  let container = container.unwrap_or("all")
  s
  |> js_identity
  |> ffi_element_scroll_into_view_with_options(
    behavior, block, inline, container,
  )
}

///|
#cfg(target="js")
impl IsElement with fn get_scroll_top(s) {
  s |> js_identity |> ffi_element_get_scroll_top
}

///|
#cfg(target="js")
impl IsElement with fn set_scroll_top(s, value) {
  s |> js_identity |> ffi_element_set_scroll_top(value)
}

///|
#cfg(target="js")
impl IsElement with fn get_scroll_left(s) {
  s |> js_identity |> ffi_element_get_scroll_left
}

///|
#cfg(target="js")
impl IsElement with fn set_scroll_left(s, value) {
  s |> js_identity |> ffi_element_set_scroll_left(value)
}

///|
#cfg(target="js")
impl IsElement with fn get_scroll_width(s) {
  s |> js_identity |> ffi_element_get_scroll_width
}

///|
#cfg(target="js")
impl IsElement with fn get_scroll_height(s) {
  s |> js_identity |> ffi_element_get_scroll_height
}

///|
#cfg(target="js")
impl IsElement with fn set_inner_html(s, html) {
  s |> js_identity |> ffi_element_set_inner_html(html)
}

///|
#cfg(target="js")
impl IsElement with fn get_bounding_client_rect(s) {
  s |> js_identity |> ffi_element_get_bounding_client_rect
}

///|
#cfg(target="js")
impl IsElement with fn get_animations(s) {
  ffi_element_get_animations(js_identity(s))
}

///|
#cfg(target="js")
extern "js" fn ffi_element_children(x : @js.Value) -> HTMLCollection =
  #| (self) => self.children

///|
#cfg(target="js")
extern "js" fn ffi_element_query_selector(
  x : @js.Value,
  selectors : String,
) -> @js.Nullable[Element] = "(self, selectors) => self.querySelector(selectors)"

///|
#cfg(target="js")
extern "js" fn ffi_element_query_selector_all(
  x : @js.Value,
  selectors : String,
) -> NodeList[Element] = "(self, selectors) => self.querySelectorAll(selectors)"

///|
#cfg(target="js")
extern "js" fn ffi_element_closest(
  x : @js.Value,
  selectors : String,
) -> @js.Nullable[Element] = "(self, selectors) => self.closest(selectors)"

///|
#cfg(target="js")
extern "js" fn ffi_element_matches(x : @js.Value, selectors : String) -> Bool = "(self, selectors) => self.matches(selectors)"

///|
#cfg(target="js")
extern "js" fn ffi_element_has_attribute(x : @js.Value, attr : String) -> Bool = "(self, attr) => self.hasAttribute(attr)"

///|
#cfg(target="js")
extern "js" fn ffi_element_get_client_width(x : @js.Value) -> Double = "(self) => self.clientWidth"

///|
#cfg(target="js")
extern "js" fn ffi_element_get_client_height(x : @js.Value) -> Double = "(self) => self.clientHeight"

///|
#cfg(target="js")
extern "js" fn ffi_element_get_client_left(x : @js.Value) -> Double = "(self) => self.clientLeft"

///|
#cfg(target="js")
extern "js" fn ffi_element_get_client_top(x : @js.Value) -> Double = "(self) => self.clientTop"

///|
#cfg(target="js")
extern "js" fn ffi_element_get_client_rects(x : @js.Value) -> DOMRectList = "(self) => self.getClientRects()"

///|
#cfg(target="js")
extern "js" fn ffi_element_set_pointer_capture(
  x : @js.Value,
  pointer_id : Int,
) -> Unit = "(self, pointerId) => self.setPointerCapture(pointerId)"

///|
#cfg(target="js")
extern "js" fn ffi_element_release_pointer_capture(
  x : @js.Value,
  pointer_id : Int,
) -> Unit = "(self, pointerId) => self.releasePointerCapture(pointerId)"

///|
#cfg(target="js")
extern "js" fn ffi_element_has_pointer_capture(
  x : @js.Value,
  pointer_id : Int,
) -> Bool = "(self, pointerId) => self.hasPointerCapture(pointerId)"

// NOTE: The DOM tree also includes the TEXT_NODE, which is not an element.
// Therefore, a vdom patch algorithm should not be based on the ffi above.
// https://dom.spec.whatwg.org/#ref-for-dom-node-nodetype%E2%91%A0

///|
#cfg(target="js")
extern "js" fn ffi_element_set_attribute(
  x : @js.Value,
  attr : String,
  value : String,
) = "(self,attr,value) => self.setAttribute(attr, value)"

///|
#cfg(target="js")
extern "js" fn ffi_element_get_attribute(
  x : @js.Value,
  attr : String,
) -> @js.Nullable[String] = "(self,attr) => self.getAttribute(attr)"

///|
#cfg(target="js")
extern "js" fn ffi_element_remove_attribute(x : @js.Value, attr : String) = "(self,attr) => self.removeAttribute(attr)"

///|
#cfg(target="js")
extern "js" fn ffi_element_set_property(
  x : @js.Value,
  prop : String,
  value : @js.Value,
) = "(self,prop,value) => self[prop] = value"

///|
#cfg(target="js")
extern "js" fn ffi_element_remove_property(x : @js.Value, prop : String) = "(self,prop) => delete self[prop]"

///|
#cfg(target="js")
// FIXME: The result type may not be string
extern "js" fn ffi_element_get_property(
  x : @js.Value,
  prop : String,
) -> @js.Optional[String] = "(self,prop) => self[prop]"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollIntoView
#cfg(target="js")
extern "js" fn ffi_element_scroll_into_view(x : @js.Value, behavior : String) =
  #| (self, behavior) => self.scrollIntoView({ behavior })

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollIntoView
#cfg(target="js")
extern "js" fn ffi_element_scroll_into_view_with_options(
  x : @js.Value,
  behavior : String,
  block : String,
  inline : String,
  container : String,
) =
  #| (self, behavior, block, inline, container) => self.scrollIntoView({
  #|   behavior,
  #|   block,
  #|   inline,
  #|   container,
  #| })

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollTop
#cfg(target="js")
extern "js" fn ffi_element_get_scroll_top(x : @js.Value) -> Double = "(self) => self.scrollTop"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollTop
#cfg(target="js")
extern "js" fn ffi_element_set_scroll_top(x : @js.Value, value : Double) = "(s,v) => s.scrollTop = v"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollLeft
#cfg(target="js")
extern "js" fn ffi_element_get_scroll_left(x : @js.Value) -> Double = "(self) => self.scrollLeft"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollLeft
#cfg(target="js")
extern "js" fn ffi_element_set_scroll_left(x : @js.Value, value : Double) = "(s,v) => s.scrollLeft = v"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollWidth
#cfg(target="js")
extern "js" fn ffi_element_get_scroll_width(x : @js.Value) -> Double = "(self) => self.scrollWidth"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollHeight
#cfg(target="js")
extern "js" fn ffi_element_get_scroll_height(x : @js.Value) -> Double = "(self) => self.scrollHeight"

///|
#cfg(target="js")
extern "js" fn ffi_element_set_inner_html(x : @js.Value, html : String) -> Unit = "(self,html) => self.innerHTML = html"

///|
#cfg(target="js")
extern "js" fn ffi_element_get_bounding_client_rect(x : @js.Value) -> DOMRect =
  #| (self) => self.getBoundingClientRect()

///|
#cfg(target="js")
extern "js" fn ffi_element_get_animations(
  x : @js.Value,
) -> FixedArray[Animation] =
  #| (self) => self.getAnimations()
