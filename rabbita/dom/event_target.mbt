///|
#cfg(target="js")
#external
type EventTarget

///|
#cfg(target="js")
pub trait IsEventTarget: @js.Cast {
  fn as_event_target(Self) -> EventTarget = _
  fn add_event_listener(Self, String, Listener) -> Unit = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener
  fn add_event_listener_with_options(
    Self,
    String,
    Listener,
    capture? : Bool,
    passive? : Bool,
    once? : Bool,
  ) -> Unit = _
  fn remove_event_listener(Self, String, Listener) -> Unit = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/removeEventListener
  fn remove_event_listener_with_options(Self, String, Listener, capture? : Bool) -> Unit = _
  fn dispatch_event(Self, Event) -> Unit = _
  fn to_clipboard(Self) -> Clipboard? = _
  fn to_node(Self) -> Node? = _
  fn to_document(Self) -> Document? = _
  fn to_document_fragment(Self) -> DocumentFragment? = _
  fn to_element(Self) -> Element? = _
  fn to_html_element(Self) -> HTMLElement? = _
  fn to_html_canvas_element(Self) -> HTMLCanvasElement? = _
  fn to_html_input_element(Self) -> HTMLInputElement? = _
  fn to_html_dialog_element(Self) -> HTMLDialogElement? = _
  fn to_html_image_element(Self) -> HTMLImageElement? = _
  fn to_html_select_element(Self) -> HTMLSelectElement? = _
  fn to_html_media_element(Self) -> HTMLMediaElement? = _
  fn to_html_video_element(Self) -> HTMLVideoElement? = _
  fn to_text(Self) -> Text? = _
  fn to_comment(Self) -> Comment? = _
  fn to_svg_element(Self) -> SVGElement? = _
  fn to_svg_graphics_element(Self) -> SVGGraphicsElement? = _
  fn to_svg_image_element(Self) -> SVGImageElement? = _
  fn to_window(Self) -> Window? = _
}

///|
#cfg(target="js")
pub type Listener = (Event) -> Unit

///|
#cfg(target="js")
pub impl IsEventTarget for EventTarget

///|
#cfg(target="js")
pub extend EventTarget with IsEventTarget::{
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
pub impl @js.Cast for EventTarget with fn into(value) {
  value |> ffi_to_event_target |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub extend EventTarget with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for EventTarget with fn from(value) {
  value |> js_identity
}

///|
#cfg(target="js")
impl IsEventTarget with fn add_event_listener(s, type_, callback) {
  s |> js_identity |> ffi_add_event_listener(type_, callback)
}

///|
#cfg(target="js")
impl IsEventTarget with fn add_event_listener_with_options(
  s,
  type_,
  callback,
  capture?,
  passive?,
  once?,
) {
  s
  |> js_identity
  |> ffi_add_event_listener_with_options(
    type_,
    callback,
    capture.unwrap_or(false),
    passive.unwrap_or(false),
    once.unwrap_or(false),
  )
}

///|
#cfg(target="js")
impl IsEventTarget with fn remove_event_listener(s, type_, callback) {
  s |> js_identity |> ffi_remove_event_listener(type_, callback)
}

///|
#cfg(target="js")
impl IsEventTarget with fn remove_event_listener_with_options(
  s,
  type_,
  callback,
  capture?,
) {
  s
  |> js_identity
  |> ffi_remove_event_listener_with_options(
    type_,
    callback,
    capture.unwrap_or(false),
  )
}

///|
#cfg(target="js")
impl IsEventTarget with fn dispatch_event(s, event) {
  s |> js_identity |> ffi_dispatch_event(event)
}

///|
#cfg(target="js")
impl IsEventTarget with fn as_event_target(s) {
  js_identity(s)
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_clipboard(s) {
  s |> js_identity |> ffi_to_clipboard |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_node(s) {
  s |> js_identity |> ffi_to_node |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_document(s) {
  s |> js_identity |> ffi_to_document |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_document_fragment(s) {
  s |> js_identity |> ffi_to_document_fragment |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_element(s) {
  s |> js_identity |> ffi_to_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_html_element(s) {
  s |> js_identity |> ffi_to_html_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_html_canvas_element(s) {
  s |> js_identity |> ffi_to_html_canvas_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_html_input_element(s) {
  s |> js_identity |> ffi_to_html_input_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_html_dialog_element(s) {
  s |> js_identity |> ffi_to_html_dialog_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_html_image_element(s) {
  s |> js_identity |> ffi_to_html_image_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_html_select_element(s) {
  s |> js_identity |> ffi_to_html_select_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_text(s) {
  s |> js_identity |> ffi_to_text |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_comment(s) {
  s |> js_identity |> ffi_to_comment |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_svg_element(s) {
  s |> js_identity |> ffi_to_svg_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_svg_graphics_element(s) {
  s |> js_identity |> ffi_to_svg_graphics_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_svg_image_element(s) {
  s |> js_identity |> ffi_to_svg_image_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_html_media_element(s) {
  s |> js_identity |> ffi_to_html_media_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_html_video_element(s) {
  s |> js_identity |> ffi_to_html_video_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEventTarget with fn to_window(s) {
  s |> js_identity |> ffi_to_window |> y => { y.to_option() }
}

///|
#cfg(target="js")
extern "js" fn ffi_to_node(x : @js.Value) -> @js.Nullable[Node] =
  #| (x) => x instanceof Node ? x : null

///|
#cfg(target="js")
extern "js" fn ffi_to_clipboard(x : @js.Value) -> @js.Nullable[Clipboard] =
  #| (x) => x instanceof Clipboard ? x : null

///|
#cfg(target="js")
extern "js" fn ffi_add_event_listener(
  x : @js.Value,
  type_ : String,
  callback : Listener,
) =
  #| (target, type, listener) => target.addEventListener(type, listener)

///|
#cfg(target="js")
extern "js" fn ffi_add_event_listener_with_options(
  x : @js.Value,
  type_ : String,
  callback : Listener,
  capture : Bool,
  passive : Bool,
  once : Bool,
) =
  #| (target, type, listener, capture, passive, once) => target.addEventListener(
  #|   type,
  #|   listener,
  #|   { capture, passive, once },
  #| )

///|
#cfg(target="js")
extern "js" fn ffi_remove_event_listener(
  x : @js.Value,
  type_ : String,
  callback : Listener,
) =
  #| (target, type, listener) => target.removeEventListener(type, listener)

///|
#cfg(target="js")
extern "js" fn ffi_remove_event_listener_with_options(
  x : @js.Value,
  type_ : String,
  callback : Listener,
  capture : Bool,
) =
  #| (target, type, listener, capture) => target.removeEventListener(
  #|   type,
  #|   listener,
  #|   { capture },
  #| )

///|
#cfg(target="js")
extern "js" fn ffi_dispatch_event(x : @js.Value, event : Event) =
  #| (target, event) => target.dispatchEvent(event)

///|
#cfg(target="js")
extern "js" fn ffi_to_document(x : @js.Value) -> @js.Nullable[Document] =
  #| (x) => x.nodeType===9 ? x : null

///|
#cfg(target="js")
extern "js" fn ffi_to_document_fragment(
  x : @js.Value,
) -> @js.Nullable[DocumentFragment] =
  #| (x) => x.nodeType===11 ? x : null

///|
#cfg(target="js")
extern "js" fn ffi_to_element(x : @js.Value) -> @js.Nullable[Element] =
  #| (x) => x.nodeType===1 ? x : null

///|
#cfg(target="js")
extern "js" fn ffi_to_text(x : @js.Value) -> @js.Nullable[Text] =
  #| (x) => x.nodeType===3 ? x : null

///|
#cfg(target="js")
extern "js" fn ffi_to_comment(x : @js.Value) -> @js.Nullable[Comment] =
  #| (x) => x.nodeType===8 ? x : null

///|
#cfg(target="js")
extern "js" fn ffi_to_html_element(x : @js.Value) -> @js.Nullable[HTMLElement] =
  #| (x) => x instanceof HTMLElement ? x : null

///|
#cfg(target="js")
extern "js" fn ffi_to_html_canvas_element(
  x : @js.Value,
) -> @js.Nullable[HTMLCanvasElement] =
  #| (x) => x instanceof HTMLCanvasElement ? x : null

///|
#cfg(target="js")
extern "js" fn ffi_to_html_input_element(
  x : @js.Value,
) -> @js.Nullable[HTMLInputElement] =
  #| (x) => x instanceof HTMLInputElement ? x : null

///|
#cfg(target="js")
extern "js" fn ffi_to_html_select_element(
  x : @js.Value,
) -> @js.Nullable[HTMLSelectElement] =
  #| (x) => x instanceof HTMLSelectElement ? x : null

///|
#cfg(target="js")
extern "js" fn ffi_to_html_dialog_element(
  x : @js.Value,
) -> @js.Nullable[HTMLDialogElement] =
  #| (x) => x instanceof HTMLDialogElement ? x : null

///|
#cfg(target="js")
extern "js" fn ffi_to_html_image_element(
  x : @js.Value,
) -> @js.Nullable[HTMLImageElement] =
  #| (x) => typeof HTMLImageElement !== "undefined" && x instanceof HTMLImageElement
  #|   ? x
  #|   : null

///|
#cfg(target="js")
extern "js" fn ffi_to_event_target(x : @js.Value) -> @js.Nullable[EventTarget] =
  #| (self) => self instanceof EventTarget ? self : null

///|
#cfg(target="js")
extern "js" fn ffi_to_svg_element(x : @js.Value) -> @js.Nullable[SVGElement] = "(x) => x instanceof SVGElement ? x : null"

///|
#cfg(target="js")
extern "js" fn ffi_to_svg_graphics_element(
  x : @js.Value,
) -> @js.Nullable[SVGGraphicsElement] = "(x) => x instanceof SVGGraphicsElement ? x : null"

///|
#cfg(target="js")
extern "js" fn ffi_to_svg_image_element(
  x : @js.Value,
) -> @js.Nullable[SVGImageElement] = "(x) => x instanceof SVGImageElement ? x : null"

///|

///|
#cfg(target="js")
extern "js" fn ffi_to_html_video_element(
  x : @js.Value,
) -> @js.Nullable[HTMLVideoElement] = "(x) => x instanceof HTMLVideoElement ? x : null"

///|
#cfg(target="js")
extern "js" fn ffi_to_window(value : @js.Value) -> @js.Nullable[Window] = "(value) => value instanceof Window ? value : null"
