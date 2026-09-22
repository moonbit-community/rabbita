///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Animation
#cfg(target="js")
#external
type Animation

///|
#cfg(target="js")
pub impl IsEventTarget for Animation

///|
#cfg(target="js")
pub extend Animation with IsEventTarget::{
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
pub impl @js.Cast for Animation with fn into(value) {
  value |> ffi_to_animation |> animation => { animation.to_option() }
}

///|
#cfg(target="js")
pub extend Animation with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for Animation with fn from(value) {
  value |> js_identity
}

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Animation/finish
#cfg(target="js")
pub extern "js" fn Animation::finish(self : Self) -> Unit = "(self) => self.finish()"

///|
#cfg(target="js")
extern "js" fn ffi_to_animation(value : @js.Value) -> @js.Nullable[Animation] =
  #| (value) => typeof Animation !== "undefined"
  #|   && value instanceof Animation
  #|   ? value
  #|   : null
