///|
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGElement
#cfg(target="js")
type SVGElement

///|
#cfg(target="js")
pub impl IsEventTarget for SVGElement

///|
#cfg(target="js")
pub extend SVGElement with IsEventTarget::{
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
pub impl IsNode for SVGElement

///|
#cfg(target="js")
pub extend SVGElement with IsNode::{
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
pub impl IsElement for SVGElement

///|
#cfg(target="js")
pub extend SVGElement with IsElement::{
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
pub impl IsSVGElement for SVGElement

///|
#cfg(target="js")
pub extend SVGElement with IsSVGElement::{
  as_svg_element,
  blur,
  focus,
  get_attribute_style_map,
  get_auto_focus,
  get_data_set,
  get_nonce,
  get_owner_svg_element,
  get_style,
  get_tab_index,
  get_viewport_element,
  set_auto_focus,
  set_nonce,
  set_style,
  set_tab_index,
}

///|
#cfg(target="js")
type StylePropertyMap

///|
#cfg(target="js")
type DOMStringMap

///|
#cfg(target="js")
pub trait IsSVGElement: IsElement {
  fn as_svg_element(Self) -> SVGElement = _
  fn get_attribute_style_map(Self) -> StylePropertyMap = _
  fn get_auto_focus(Self) -> Bool = _
  fn set_auto_focus(Self, Bool) -> Unit = _
  fn get_data_set(Self) -> DOMStringMap = _
  fn get_nonce(Self) -> String = _
  fn set_nonce(Self, String) -> Unit = _
  fn get_owner_svg_element(Self) -> SVGElement? = _
  fn get_style(Self) -> CSSStyleDeclaration = _
  fn set_style(Self, CSSStyleDeclaration) -> Unit = _
  fn get_tab_index(Self) -> Int = _
  fn set_tab_index(Self, Int) -> Unit = _
  fn get_viewport_element(Self) -> SVGElement? = _
  fn blur(Self) -> Unit = _
  fn focus(Self) -> Unit = _
}

///|
#cfg(target="js")
pub impl @js.Cast for SVGElement with fn into(value) {
  value |> ffi_to_svg_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub extend SVGElement with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for SVGElement with fn from(value) {
  value |> js_identity
}

///|
#cfg(target="js")
impl IsSVGElement with fn as_svg_element(s) {
  s |> js_identity
}

///|
#cfg(target="js")
impl IsSVGElement with fn get_attribute_style_map(s) {
  s |> js_identity |> ffi_get_attribute_style_map
}

///|
#cfg(target="js")
impl IsSVGElement with fn get_auto_focus(s) {
  s |> js_identity |> get_auto_focus
}

///|
#cfg(target="js")
impl IsSVGElement with fn set_auto_focus(s, value) {
  s |> js_identity |> set_auto_focus(value)
}

///|
#cfg(target="js")
impl IsSVGElement with fn get_data_set(s) {
  s |> js_identity |> get_data_set
}

///|
#cfg(target="js")
impl IsSVGElement with fn get_nonce(s) {
  s |> js_identity |> get_nonce
}

///|
#cfg(target="js")
impl IsSVGElement with fn set_nonce(s, value) {
  s |> js_identity |> set_nonce(value)
}

///|
#cfg(target="js")
impl IsSVGElement with fn get_owner_svg_element(s) {
  s |> js_identity |> get_owner_svg_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsSVGElement with fn get_style(s) {
  s |> js_identity |> get_style
}

///|
#cfg(target="js")
impl IsSVGElement with fn set_style(s, style) {
  s |> js_identity |> set_style(style)
}

///|
#cfg(target="js")
impl IsSVGElement with fn get_tab_index(s) {
  s |> js_identity |> get_tab_index
}

///|
#cfg(target="js")
impl IsSVGElement with fn set_tab_index(s, value) {
  s |> js_identity |> set_tab_index(value)
}

///|
#cfg(target="js")
impl IsSVGElement with fn get_viewport_element(s) {
  s |> js_identity |> get_viewport_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsSVGElement with fn blur(s) {
  s |> js_identity |> blur
}

///|
#cfg(target="js")
impl IsSVGElement with fn focus(s) {
  s |> js_identity |> focus
}

///|
#cfg(target="js")
extern "js" fn ffi_get_attribute_style_map(x : @js.Value) -> StylePropertyMap = "(self) => self.style"

///|
#cfg(target="js")
extern "js" fn get_auto_focus(x : @js.Value) -> Bool = "(self) => self.autofocus"

///|
#cfg(target="js")
extern "js" fn set_auto_focus(x : @js.Value, value : Bool) = "(self, value) => self.autofocus = value"

///|
#cfg(target="js")
extern "js" fn get_data_set(x : @js.Value) -> DOMStringMap = "(self) => self.dataset"

///|
#cfg(target="js")
extern "js" fn get_nonce(x : @js.Value) -> String = "(self) => self.nonce"

///|
#cfg(target="js")
extern "js" fn set_nonce(x : @js.Value, value : String) = "(self, value) => self.nonce = value"

///|
#cfg(target="js")
extern "js" fn get_owner_svg_element(x : @js.Value) -> @js.Optional[SVGElement] = "(self) => self.ownerSVGElement"

///|
#cfg(target="js")
extern "js" fn get_style(x : @js.Value) -> CSSStyleDeclaration = "(self) => self.style"

///|
#cfg(target="js")
extern "js" fn set_style(x : @js.Value, style : CSSStyleDeclaration) = "(self, style) => self.style = style"

///|
#cfg(target="js")
extern "js" fn get_tab_index(x : @js.Value) -> Int = "(self) => self.tabIndex"

///|
#cfg(target="js")
extern "js" fn set_tab_index(x : @js.Value, value : Int) = "(self, value) => self.tabIndex = value"

///|
#cfg(target="js")
extern "js" fn get_viewport_element(x : @js.Value) -> @js.Optional[SVGElement] = "(self) => self.viewportElement"

///|
#cfg(target="js")
extern "js" fn blur(x : @js.Value) = "(self) => self.blur()"

///|
#cfg(target="js")
extern "js" fn focus(x : @js.Value) = "(self) => self.focus()"
