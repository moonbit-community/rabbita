///|
/// https://developer.mozilla.org/en-US/docs/Web/API/VisualViewport
#cfg(target="js")
#external
type VisualViewport

///|
#cfg(target="js")
pub impl IsEventTarget for VisualViewport

///|
#cfg(target="js")
pub extend VisualViewport with IsEventTarget::{
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
pub impl @js.Cast for VisualViewport with fn into(value) {
  value |> ffi_to_visual_viewport |> viewport => { viewport.to_option() }
}

///|
#cfg(target="js")
pub extend VisualViewport with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for VisualViewport with fn from(value) {
  value |> js_identity
}

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/visualViewport
#cfg(target="js")
pub fn Window::get_visual_viewport(self : Self) -> VisualViewport? {
  ffi_window_get_visual_viewport(self).to_option()
}

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/VisualViewport/width
#cfg(target="js")
pub extern "js" fn VisualViewport::get_width(self : Self) -> Double = "(self) => self.width"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/VisualViewport/height
#cfg(target="js")
pub extern "js" fn VisualViewport::get_height(self : Self) -> Double = "(self) => self.height"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/VisualViewport/offsetLeft
#cfg(target="js")
pub extern "js" fn VisualViewport::get_offset_left(self : Self) -> Double = "(self) => self.offsetLeft"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/VisualViewport/offsetTop
#cfg(target="js")
pub extern "js" fn VisualViewport::get_offset_top(self : Self) -> Double = "(self) => self.offsetTop"

///|
#cfg(target="js")
extern "js" fn ffi_window_get_visual_viewport(
  win : Window,
) -> @js.Nullable[VisualViewport] = "(self) => self.visualViewport ?? null"

///|
#cfg(target="js")
extern "js" fn ffi_to_visual_viewport(
  value : @js.Value,
) -> @js.Nullable[VisualViewport] =
  #| (value) => typeof VisualViewport !== "undefined"
  #|   && value instanceof VisualViewport
  #|   ? value
  #|   : null
