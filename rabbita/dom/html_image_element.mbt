///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/fetchPriority
#cfg(target="js")
#external
type HTMLImageElement

///|
#cfg(target="js")
pub impl IsEventTarget for HTMLImageElement

///|
#cfg(target="js")
pub extend HTMLImageElement with IsEventTarget::{
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
pub impl @js.Cast for HTMLImageElement with fn into(value) {
  value |> ffi_to_html_image_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub extend HTMLImageElement with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for HTMLImageElement with fn from(value) {
  value |> js_identity
}

///|
#cfg(target="js")
pub impl IsNode for HTMLImageElement

///|
#cfg(target="js")
pub extend HTMLImageElement with IsNode::{
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
pub impl IsElement for HTMLImageElement

///|
#cfg(target="js")
pub extend HTMLImageElement with IsElement::{
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
pub impl IsHtmlElement for HTMLImageElement

///|
#cfg(target="js")
pub extend HTMLImageElement with IsHtmlElement::{
  as_html_element,
  attach_internals,
  blur,
  click,
  focus,
  focus_with_options,
  get_access_key,
  get_access_key_label,
  get_anchor_element,
  get_attribute_style_map,
  get_auto_capitalize,
  get_auto_correct,
  get_auto_focus,
  get_content_editable,
  get_dataset,
  get_dir,
  get_draggable,
  get_edit_context,
  get_enter_key_hint,
  get_hidden,
  get_inert,
  get_inner_text,
  get_input_mode,
  get_is_content_editable,
  get_lang,
  get_nonce,
  get_offset_height,
  get_offset_left,
  get_offset_parent,
  get_offset_top,
  get_offset_width,
  get_outer_text,
  get_popover,
  get_spellcheck,
  get_style,
  get_tab_index,
  get_title,
  get_translate,
  get_virtual_keyboard_policy,
  get_writing_suggestions,
  hide_popover,
  set_access_key,
  set_auto_capitalize,
  set_auto_correct,
  set_auto_focus,
  set_content_editable,
  set_dir,
  set_draggable,
  set_edit_context,
  set_enter_key_hint,
  set_hidden,
  set_inert,
  set_inner_text,
  set_input_mode,
  set_lang,
  set_nonce,
  set_outer_text,
  set_popover,
  set_spellcheck,
  set_style_declaration,
  set_tab_index,
  set_title,
  set_translate,
  set_virtual_keyboard_policy,
  set_writing_suggestions,
  show_popover,
  toggle_popover,
}

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/Image
#cfg(target="js")
pub extern "js" fn HTMLImageElement::new() -> Self = "() => new Image()"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/Image
#cfg(target="js")
pub extern "js" fn HTMLImageElement::new_with_size(
  width : Double,
  height : Double,
) -> Self = "(w,h) => new Image(w, h)"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/alt
#cfg(target="js")
pub extern "js" fn HTMLImageElement::get_alt(self : Self) -> String = "(self) => self.alt"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/alt
#cfg(target="js")
pub extern "js" fn HTMLImageElement::set_alt(self : Self, value : String) = "(self, value) => self.alt = value"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/complete
#cfg(target="js")
pub extern "js" fn HTMLImageElement::get_complete(self : Self) -> Bool = "(self) => self.complete"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/crossOrigin
#cfg(target="js")
pub extern "js" fn HTMLImageElement::get_cross_origin(self : Self) -> String = "(self) => self.crossOrigin"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/crossOrigin
#cfg(target="js")
pub extern "js" fn HTMLImageElement::set_cross_origin(
  self : Self,
  value : String,
) = "(self, value) => self.crossOrigin = value"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/currentSrc
#cfg(target="js")
pub extern "js" fn HTMLImageElement::get_current_src(self : Self) -> String = "(self) => self.currentSrc"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/decoding
#cfg(target="js")
pub extern "js" fn HTMLImageElement::get_decoding(self : Self) -> String = "(self) => self.decoding"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/decoding
#cfg(target="js")
pub extern "js" fn HTMLImageElement::set_decoding(self : Self, value : String) = "(self, value) => self.decoding = value"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/height
#cfg(target="js")
pub extern "js" fn HTMLImageElement::get_height(self : Self) -> Double = "(self) => self.height"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/height
#cfg(target="js")
pub extern "js" fn HTMLImageElement::set_height(self : Self, value : Double) = "(self, value) => self.height = value"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/isMap
#cfg(target="js")
pub extern "js" fn HTMLImageElement::get_is_map(self : Self) -> Bool = "(self) => self.isMap"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/isMap
#cfg(target="js")
pub extern "js" fn HTMLImageElement::set_is_map(self : Self, value : Bool) = "(self, value) => self.isMap = value"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/loading
#cfg(target="js")
pub extern "js" fn HTMLImageElement::get_loading(self : Self) -> String = "(self) => self.loading"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/loading
#cfg(target="js")
pub extern "js" fn HTMLImageElement::set_loading(self : Self, value : String) = "(self, value) => self.loading = value"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/naturalHeight
#cfg(target="js")
pub extern "js" fn HTMLImageElement::get_natural_height(self : Self) -> Double = "(self) => self.naturalHeight"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/naturalWidth
#cfg(target="js")
pub extern "js" fn HTMLImageElement::get_natural_width(self : Self) -> Double = "(self) => self.naturalWidth"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/referrerPolicy
#cfg(target="js")
pub extern "js" fn HTMLImageElement::get_referrer_policy(self : Self) -> String = "(self) => self.referrerPolicy"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/referrerPolicy
#cfg(target="js")
pub extern "js" fn HTMLImageElement::set_referrer_policy(
  self : Self,
  value : String,
) = "(self, value) => self.referrerPolicy = value"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/sizes
#cfg(target="js")
pub extern "js" fn HTMLImageElement::get_sizes(self : Self) -> String = "(self) => self.sizes"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/sizes
#cfg(target="js")
pub extern "js" fn HTMLImageElement::set_sizes(self : Self, value : String) = "(self, value) => self.sizes = value"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/src
#cfg(target="js")
pub extern "js" fn HTMLImageElement::get_src(self : Self) -> String = "(self) => self.src"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/src
#cfg(target="js")
pub extern "js" fn HTMLImageElement::set_src(self : Self, value : String) = "(self, value) => self.src = value"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/srcset
#cfg(target="js")
pub extern "js" fn HTMLImageElement::get_srcset(self : Self) -> String = "(self) => self.srcset"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/srcset
#cfg(target="js")
pub extern "js" fn HTMLImageElement::set_srcset(self : Self, value : String) = "(self, value) => self.srcset = value"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/useMap
#cfg(target="js")
pub extern "js" fn HTMLImageElement::get_use_map(self : Self) -> String = "(self) => self.useMap"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/useMap
#cfg(target="js")
pub extern "js" fn HTMLImageElement::set_use_map(self : Self, value : String) = "(self, value) => self.useMap = value"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/width
#cfg(target="js")
pub extern "js" fn HTMLImageElement::get_width(self : Self) -> Double = "(self) => self.width"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/width
#cfg(target="js")
pub extern "js" fn HTMLImageElement::set_width(self : Self, value : Double) = "(self, value) => self.width = value"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/x
#cfg(target="js")
pub extern "js" fn HTMLImageElement::get_x(self : Self) -> Double = "(self) => self.x"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/y
#cfg(target="js")
pub extern "js" fn HTMLImageElement::get_y(self : Self) -> Double = "(self) => self.y"

// TODO: Implement the decode method and promise handling.
// pub extern "js" fn HTMLImageElement::decode() -> @js.Promise[Unit]
