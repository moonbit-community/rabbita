///|
#cfg(target="js")
#external
pub type Clipboard

///|
#cfg(target="js")
pub impl IsEventTarget for Clipboard

///|
#cfg(target="js")
pub extend Clipboard with IsEventTarget::{
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
pub impl @js.Cast for Clipboard with fn into(value) {
  value |> ffi_to_clipboard |> clipboard => { clipboard.to_option() }
}

///|
#cfg(target="js")
pub extend Clipboard with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for Clipboard with fn from(value) {
  value |> js_identity
}

// TODO: support ClipboardItem

///|
#cfg(target="js")
pub extern "js" fn Clipboard::write_text(
  self : Clipboard,
  text : String,
) -> @js.Promise[Unit] =
  #| (self, text) => {
  #|   const writeText = self && self.writeText
  #|   if (typeof writeText === 'function') {
  #|     return writeText.call(self, text)
  #|   }
  #|   return Promise.reject(
  #|     new Error(
  #|       "Clipboard.writeText is unavailable (requires browser support and secure context)."
  #|     )
  #|   )
  #| }

///|
#cfg(target="js")
pub extern "js" fn Clipboard::read_text(
  self : Clipboard,
) -> @js.Promise[String] =
  #| (self) => {
  #|   const readText = self && self.readText
  #|   if (typeof readText === 'function') {
  #|     return readText.call(self)
  #|   }
  #|   return Promise.reject(
  #|     new Error(
  #|       "Clipboard.readText is unavailable (requires browser support and secure context)."
  #|     )
  #|   )
  #| }
