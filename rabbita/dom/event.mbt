///|
#cfg(target="js")
#external
type Event

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Event/Event
#cfg(target="js")
pub extern "js" fn Event::new(
  type_ : String,
  bubbles? : Bool = false,
  cancelable? : Bool = false,
  composed? : Bool = false,
) -> Self =
  #| (type, bubbles, cancelable, composed) => new Event(type, {
  #|   bubbles,
  #|   cancelable,
  #|   composed,
  #| })

///|
#cfg(target="js")
fn[A, B] js_identity(a : A) -> B {
  @js.Value::cast_from(a).cast()
}

///|
#cfg(target="js")
pub trait IsEvent: @js.Cast {
  fn target(Self) -> EventTarget = _
  fn current_target(Self) -> @js.Nullable[EventTarget] = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Event/defaultPrevented
  fn get_default_prevented(Self) -> Bool = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Event/timeStamp
  fn get_time_stamp(Self) -> DOMHighResTimeStamp = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Event/composedPath
  fn composed_path(Self) -> FixedArray[EventTarget] = _
  fn prevent_default(Self) -> Unit = _
  fn stop_propagation(Self) -> Unit = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/Event/stopImmediatePropagation
  fn stop_immediate_propagation(Self) -> Unit = _
  fn as_event(Self) -> Event = _
  fn to_ui_event(Self) -> UIEvent? = _
  fn to_clipboard_event(Self) -> ClipboardEvent? = _
  fn to_mouse_event(Self) -> MouseEvent? = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent
  fn to_pointer_event(Self) -> PointerEvent? = _
  fn to_input_event(Self) -> InputEvent? = _
  fn to_focus_event(Self) -> FocusEvent? = _
  fn to_keyboard_event(Self) -> KeyboardEvent? = _
  fn to_animation_event(Self) -> AnimationEvent? = _
  fn to_before_unload_event(Self) -> BeforeUnloadEvent? = _
  fn to_blob_event(Self) -> BlobEvent? = _
  fn to_close_event(Self) -> CloseEvent? = _
  fn to_composition_event(Self) -> CompositionEvent? = _
  fn to_custom_event(Self) -> CustomEvent? = _
  fn to_drag_event(Self) -> DragEvent? = _
  fn to_message_event(Self) -> MessageEvent? = _
  fn to_wheel_event(Self) -> WheelEvent? = _
}

///|
#cfg(target="js")
pub impl IsEvent for Event

///|
#cfg(target="js")
pub impl @js.Cast for Event with fn into(value) {
  value |> ffi_to_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub impl @js.Cast for Event with fn from(value) {
  value |> js_identity
}

///|
#cfg(target="js")
impl IsEvent with fn target(s) {
  s |> js_identity |> ffi_event_target
}

///|
#cfg(target="js")
impl IsEvent with fn current_target(s) {
  s |> js_identity |> ffi_event_current_target
}

///|
#cfg(target="js")
impl IsEvent with fn get_default_prevented(s) {
  s |> js_identity |> ffi_event_get_default_prevented
}

///|
#cfg(target="js")
impl IsEvent with fn get_time_stamp(s) {
  s |> js_identity |> ffi_event_get_time_stamp
}

///|
#cfg(target="js")
impl IsEvent with fn composed_path(s) {
  ffi_event_composed_path(js_identity(s))
}

///|
#cfg(target="js")
impl IsEvent with fn prevent_default(s) {
  s.as_event() |> ffi_event_prevent_default
}

///|
#cfg(target="js")
impl IsEvent with fn stop_propagation(s) {
  s.as_event() |> ffi_event_stop_propagation
}

///|
#cfg(target="js")
impl IsEvent with fn stop_immediate_propagation(s) {
  s.as_event() |> ffi_event_stop_immediate_propagation
}

///|
#cfg(target="js")
impl IsEvent with fn as_event(s) {
  js_identity(s)
}

///|
#cfg(target="js")
impl IsEvent with fn to_ui_event(s) {
  s |> js_identity |> ffi_to_ui_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEvent with fn to_clipboard_event(s) {
  s |> js_identity |> ffi_to_clipboard_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEvent with fn to_mouse_event(s) {
  s |> js_identity |> ffi_to_mouse_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEvent with fn to_pointer_event(s) {
  s |> js_identity |> ffi_to_pointer_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEvent with fn to_input_event(s) {
  s |> js_identity |> ffi_to_input_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEvent with fn to_focus_event(s) {
  s |> js_identity |> ffi_to_focus_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEvent with fn to_keyboard_event(s) {
  s |> js_identity |> ffi_to_keyboard_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEvent with fn to_animation_event(s) {
  s |> js_identity |> ffi_to_animation_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEvent with fn to_before_unload_event(s) {
  s |> js_identity |> ffi_to_before_unload_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEvent with fn to_blob_event(s) {
  s |> js_identity |> ffi_to_blob_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEvent with fn to_close_event(s) {
  s |> js_identity |> ffi_to_close_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEvent with fn to_composition_event(s) {
  s |> js_identity |> ffi_to_composition_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEvent with fn to_custom_event(s) {
  s |> js_identity |> ffi_to_custom_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEvent with fn to_drag_event(s) {
  s |> js_identity |> ffi_to_drag_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEvent with fn to_message_event(s) {
  s |> js_identity |> ffi_to_message_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
impl IsEvent with fn to_wheel_event(s) {
  s |> js_identity |> ffi_to_wheel_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
extern "js" fn ffi_event_target(x : @js.Value) -> EventTarget = "(self) => self.target"

///|
#cfg(target="js")
extern "js" fn ffi_event_current_target(
  x : @js.Value,
) -> @js.Nullable[EventTarget] = "(self) => self.currentTarget"

///|
#cfg(target="js")
extern "js" fn ffi_event_get_default_prevented(x : @js.Value) -> Bool = "(self) => self.defaultPrevented"

///|
#cfg(target="js")
extern "js" fn ffi_event_get_time_stamp(x : @js.Value) -> DOMHighResTimeStamp = "(self) => self.timeStamp"

///|
#cfg(target="js")
extern "js" fn ffi_event_composed_path(
  x : @js.Value,
) -> FixedArray[EventTarget] = "(self) => self.composedPath()"

///|
#cfg(target="js")
extern "js" fn ffi_to_ui_event(x : @js.Value) -> @js.Nullable[UIEvent] =
  #| (x) => x instanceof UIEvent ? x : null

///|
#cfg(target="js")
extern "js" fn ffi_to_clipboard_event(
  x : @js.Value,
) -> @js.Nullable[ClipboardEvent] =
  #| (x) => x instanceof ClipboardEvent ? x : null

///|
#cfg(target="js")
extern "js" fn ffi_event_prevent_default(x : Event) = "(self) => self.preventDefault()"

///|
#cfg(target="js")
extern "js" fn ffi_event_stop_propagation(x : Event) = "(self) => self.stopPropagation()"

///|
#cfg(target="js")
extern "js" fn ffi_event_stop_immediate_propagation(x : Event) = "(self) => self.stopImmediatePropagation()"

///|
#cfg(target="js")
extern "js" fn ffi_to_mouse_event(x : @js.Value) -> @js.Nullable[MouseEvent] =
  #| (event) => {
  #|   if (typeof MouseEvent === "undefined") {
  #|     return null
  #|   }
  #|   if (event instanceof MouseEvent) {
  #|     return event
  #|   }
  #|   try {
  #|     // Web IDL operations validate the interface brand across realms.
  #|     MouseEvent.prototype.getModifierState.call(event, "")
  #|     return event
  #|   } catch {
  #|     return null
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_to_pointer_event(
  x : @js.Value,
) -> @js.Nullable[PointerEvent] =
  #| (event) => {
  #|   if (typeof PointerEvent === "undefined") {
  #|     return null
  #|   }
  #|   if (event instanceof PointerEvent) {
  #|     return event
  #|   }
  #|   try {
  #|     // Use the native getter as a realm-independent brand check.
  #|     const getPointerId = Object.getOwnPropertyDescriptor(
  #|       PointerEvent.prototype,
  #|       "pointerId",
  #|     ).get
  #|     getPointerId.call(event)
  #|     return event
  #|   } catch {
  #|     return null
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_to_transition_event(
  x : @js.Value,
) -> @js.Nullable[TransitionEvent] =
  #| (e) => typeof TransitionEvent !== "undefined" && e instanceof TransitionEvent
  #|   ? e
  #|   : null

///|
#cfg(target="js")
extern "js" fn ffi_to_toggle_event(x : @js.Value) -> @js.Nullable[ToggleEvent] =
  #| (e) => typeof ToggleEvent !== "undefined" && e instanceof ToggleEvent
  #|   ? e
  #|   : null

///|
#cfg(target="js")
extern "js" fn ffi_to_input_event(x : @js.Value) -> @js.Nullable[InputEvent] =
  #| (e) => e instanceof InputEvent ? e : null

///|
#cfg(target="js")
extern "js" fn ffi_to_focus_event(x : @js.Value) -> @js.Nullable[FocusEvent] =
  #| (e) => e instanceof FocusEvent ? e : null

///|
#cfg(target="js")
extern "js" fn ffi_to_keyboard_event(
  x : @js.Value,
) -> @js.Nullable[KeyboardEvent] =
  #| (e) => e instanceof KeyboardEvent ? e : null

///|
#cfg(target="js")
extern "js" fn ffi_to_animation_event(
  x : @js.Value,
) -> @js.Nullable[AnimationEvent] =
  #| (e) => e instanceof AnimationEvent ? e : null

///|
#cfg(target="js")
extern "js" fn ffi_to_before_unload_event(
  x : @js.Value,
) -> @js.Nullable[BeforeUnloadEvent] =
  #| (e) => e instanceof BeforeUnloadEvent ? e : null

///|
#cfg(target="js")
extern "js" fn ffi_to_blob_event(x : @js.Value) -> @js.Nullable[BlobEvent] =
  #| (e) => e instanceof BlobEvent ? e : null

///|
#cfg(target="js")
extern "js" fn ffi_to_close_event(x : @js.Value) -> @js.Nullable[CloseEvent] =
  #| (e) => e instanceof CloseEvent ? e : null

///|
#cfg(target="js")
extern "js" fn ffi_to_composition_event(
  x : @js.Value,
) -> @js.Nullable[CompositionEvent] =
  #| (e) => e instanceof CompositionEvent ? e : null

///|
#cfg(target="js")
extern "js" fn ffi_to_custom_event(x : @js.Value) -> @js.Nullable[CustomEvent] =
  #| (e) => e instanceof CustomEvent ? e : null

///|
#cfg(target="js")
extern "js" fn ffi_to_drag_event(x : @js.Value) -> @js.Nullable[DragEvent] =
  #| (e) => e instanceof DragEvent ? e : null

///|
#cfg(target="js")
extern "js" fn ffi_to_message_event(
  x : @js.Value,
) -> @js.Nullable[MessageEvent] =
  #| (e) => e instanceof MessageEvent ? e : null

///|
#cfg(target="js")
extern "js" fn ffi_to_wheel_event(x : @js.Value) -> @js.Nullable[WheelEvent] =
  #| (e) => e instanceof WheelEvent ? e : null

///|
#cfg(target="js")
extern "js" fn ffi_to_event(x : @js.Value) -> @js.Nullable[Event] =
  #| (e) => e instanceof Event ? e : null
