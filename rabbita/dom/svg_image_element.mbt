///|
#cfg(target="js")
#external
type SVGImageElement

///|
#cfg(target="js")
pub impl IsEventTarget for SVGImageElement

///|
#cfg(target="js")
pub extend SVGImageElement with IsEventTarget::{
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
pub impl IsNode for SVGImageElement

///|
#cfg(target="js")
pub extend SVGImageElement with IsNode::{
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
pub impl IsElement for SVGImageElement

///|
#cfg(target="js")
pub extend SVGImageElement with IsElement::{
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
pub impl IsSVGElement for SVGImageElement

///|
#cfg(target="js")
pub extend SVGImageElement with IsSVGElement::{
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
pub impl @js.Cast for SVGImageElement with fn into(value) {
  value |> ffi_to_svg_image_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub extend SVGImageElement with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for SVGImageElement with fn from(value) {
  value |> js_identity
}
