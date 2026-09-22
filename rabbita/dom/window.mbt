///|
#cfg(target="js")
#external
type Window

///|
#cfg(target="js")
pub impl IsEventTarget for Window

///|
#cfg(target="js")
pub extend Window with IsEventTarget::{
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
pub impl @js.Cast for Window with fn into(value) {
  value |> ffi_to_window |> x => { x.to_option() }
}

///|
#cfg(target="js")
pub extend Window with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for Window with fn from(value) {
  value |> js_identity
}

///|
#cfg(target="js")
pub fn Window::scroll_to(
  self : Self,
  x : Double,
  y : Double,
  behavior? : String = "auto",
) -> Unit {
  ffi_window_scroll_to(self, x, y, behavior)
}

///|
#cfg(target="js")
pub fn Window::scroll_by(
  self : Self,
  x : Double,
  y : Double,
  behavior? : String = "auto",
) -> Unit {
  ffi_window_scroll_by(self, x, y, behavior)
}

///|
#cfg(target="js")
pub fn Window::scroll_to_top(self : Self, behavior? : String = "auto") -> Unit {
  self.scroll_to(0, 0, behavior~)
}

///|
#cfg(target="js")
pub fn Window::scroll_to_bottom(
  self : Self,
  behavior? : String = "auto",
) -> Unit {
  ffi_window_scroll_to_bottom(self, behavior)
}

///|
#cfg(target="js")
extern "js" fn ffi_window_scroll_to(
  win : Window,
  x : Double,
  y : Double,
  behavior : String,
) =
  #| (self, x, y, behavior) => {
  #|   self.scrollTo({ left: x, top: y, behavior });
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_window_scroll_by(
  win : Window,
  x : Double,
  y : Double,
  behavior : String,
) =
  #| (self, x, y, behavior) => {
  #|   self.scrollBy({ left: x, top: y, behavior });
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_window_scroll_to_bottom(win : Window, behavior : String) =
  #| (self, behavior) => {
  #|   const root = self.document.scrollingElement || self.document.documentElement || self.document.body;
  #|   self.scrollTo({ left: 0, top: root.scrollHeight, behavior });
  #| }

///|
#cfg(target="js")
pub extern "js" fn Window::history_go_back(self : Self) =
  #| (self) => { self.history.back(); }

///|
#cfg(target="js")
pub extern "js" fn Window::history_go_forward(self : Self) =
  #| (self) => { self.history.forward(); }

///|
#cfg(target="js")
pub extern "js" fn Window::load_url(self : Self, url : String) =
  #| (self,url) => { self.location.href = url; }

///|
#cfg(target="js")
pub extern "js" fn Window::reload_url(self : Self) =
  #| (self) => { self.location.reload(); }

///|
#cfg(target="js")
pub extern "js" fn Window::push_url(self : Self, url : String) =
  #| (self,url) => { self.history.pushState(null, '', url); }

///|
#cfg(target="js")
pub extern "js" fn Window::current_url(self : Self) -> String =
  #| (self) => { return self.location.href; }

///|
#cfg(target="js")
pub extern "js" fn Window::origin(self : Self) -> String =
  #| (self) => { return self.location.origin; }

///|
#cfg(target="js")
pub extern "js" fn Window::replace_url(self : Self, url : String) =
  #| (self,url) => { self.history.replaceState(null, '', url); }

///|
#cfg(target="js")
pub extern "js" fn Window::inner_width(self : Self) -> Double = "(self) => self.innerWidth"

///|
#cfg(target="js")
pub extern "js" fn Window::inner_height(self : Self) -> Double = "(self) => self.innerHeight"

///|
#cfg(target="js")
pub extern "js" fn Window::scroll_x(self : Self) -> Double = "(self) => self.scrollX"

///|
#cfg(target="js")
pub extern "js" fn Window::scroll_y(self : Self) -> Double = "(self) => self.scrollY"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/setInterval
#cfg(target="js")
pub extern "js" fn Window::set_interval(
  self : Self,
  f : () -> Unit,
  ms : Int,
) -> Int = "(self,f,ms) => self.setInterval(f, ms)"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/clearInterval
#cfg(target="js")
pub extern "js" fn Window::clear_interval(self : Self, interval_id : Int) = "(self,id) => self.clearInterval(id)"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/setTimeout
#cfg(target="js")
pub extern "js" fn Window::set_timeout(
  self : Self,
  f : () -> Unit,
  ms : Int,
) -> Int = "(self, f, ms) => self.setTimeout(f, ms)"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/clearTimeout
#cfg(target="js")
pub extern "js" fn Window::clear_timeout(self : Self, timeout_id : Int) = "(self, id) => self.clearTimeout(id)"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/queueMicrotask
#cfg(target="js")
pub extern "js" fn Window::queue_microtask(self : Self, f : () -> Unit) = "(self, f) => self.queueMicrotask(f)"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/requestAnimationFrame
#cfg(target="js")
pub extern "js" fn Window::request_animation_frame(
  self : Self,
  f : (DOMHighResTimeStamp) -> Unit,
) -> Double = "(self,f) => self.requestAnimationFrame(f)"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/cancelAnimationFrame
#cfg(target="js")
pub extern "js" fn Window::cancel_animation_frame(
  self : Self,
  request_id : Double,
) = "(self,id) => self.cancelAnimationFrame(id)"

///|
#cfg(target="js")
pub extern "js" fn window() -> Window = "() => window"

///|
#cfg(target="js")
pub extern "js" fn Window::to_event_target(self : Self) -> EventTarget = "(x) => x"

///|
#cfg(target="js")
pub extern "js" fn Window::alert(self : Self, msg : String) = "(self,msg) => self.alert(msg)"

///|
#cfg(target="js")
pub extern "js" fn Window::confirm(self : Self, msg : String) -> Bool = "(self,msg) => self.confirm(msg)"

///|
#cfg(target="js")
pub extern "js" fn Window::navigator(self : Self) -> Navigator =
  #| (self) => self.navigator

///|
/// Returns the resolved CSS values for an element.
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/getComputedStyle
#cfg(target="js")
pub extern "js" fn Window::get_computed_style(
  self : Self,
  element : Element,
) -> CSSStyleDeclaration = "(self, element) => self.getComputedStyle(element)"
