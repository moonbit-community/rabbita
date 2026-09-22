///|
/// https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList
#cfg(target="js")
#external
type MediaQueryList

///|
#cfg(target="js")
pub impl IsEventTarget for MediaQueryList

///|
#cfg(target="js")
pub extend MediaQueryList with IsEventTarget::{
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
pub impl @js.Cast for MediaQueryList with fn into(value) {
  value |> ffi_to_media_query_list |> list => { list.to_option() }
}

///|
#cfg(target="js")
pub extend MediaQueryList with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for MediaQueryList with fn from(value) {
  value |> js_identity
}

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/matchMedia
#cfg(target="js")
pub extern "js" fn Window::match_media(
  self : Self,
  query : String,
) -> MediaQueryList = "(self, query) => self.matchMedia(query)"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList/matches
#cfg(target="js")
pub extern "js" fn MediaQueryList::get_matches(self : Self) -> Bool = "(self) => self.matches"

///|
#cfg(target="js")
extern "js" fn ffi_to_media_query_list(
  value : @js.Value,
) -> @js.Nullable[MediaQueryList] =
  #| (value) => typeof MediaQueryList !== "undefined"
  #|   && value instanceof MediaQueryList
  #|   ? value
  #|   : null
