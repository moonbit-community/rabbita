///|
#cfg(target="js")
#external
type DocumentFragment

///|
#cfg(target="js")
pub impl @js.Cast for DocumentFragment with fn into(value) {
  value |> ffi_to_document_fragment |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub extend DocumentFragment with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for DocumentFragment with fn from(value) {
  value |> js_identity
}

///|
#cfg(target="js")
pub impl IsEventTarget for DocumentFragment

///|
#cfg(target="js")
pub extend DocumentFragment with IsEventTarget::{
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
pub impl IsNode for DocumentFragment

///|
#cfg(target="js")
pub extend DocumentFragment with IsNode::{
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
pub extern "js" fn DocumentFragment::to_node(self : Self) -> Node = "(x) => x"
