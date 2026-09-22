///|
#cfg(target="js")
#external
type MouseEvent

///|
#cfg(target="js")
pub trait IsMouseEvent: IsUIEvent {
  fn as_mouse_event(Self) -> MouseEvent = _
  fn get_alt_key(Self) -> Bool = _
  fn get_button(Self) -> Int = _
  fn get_buttons(Self) -> Int = _
  fn get_client_x(Self) -> Double = _
  fn get_client_y(Self) -> Double = _
  fn get_ctrl_key(Self) -> Bool = _
  fn get_meta_key(Self) -> Bool = _
  fn get_movement_x(Self) -> Double = _
  fn get_movement_y(Self) -> Double = _
  fn get_offset_x(Self) -> Double = _
  fn get_offset_y(Self) -> Double = _
  fn get_page_x(Self) -> Double = _
  fn get_page_y(Self) -> Double = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/relatedTarget
  fn get_related_target(Self) -> EventTarget? = _
  fn get_screen_x(Self) -> Double = _
  fn get_screen_y(Self) -> Double = _
  fn get_shift_key(Self) -> Bool = _
  fn get_x(Self) -> Double = _
  fn get_y(Self) -> Double = _
  fn get_modifier_state(Self, String) -> Bool = _
}

///|
#cfg(target="js")
pub impl IsEvent for MouseEvent

///|
#cfg(target="js")
pub extend MouseEvent with IsEvent::{
  as_event,
  composed_path,
  current_target,
  get_default_prevented,
  get_time_stamp,
  prevent_default,
  stop_immediate_propagation,
  stop_propagation,
  target,
  to_animation_event,
  to_before_unload_event,
  to_blob_event,
  to_clipboard_event,
  to_close_event,
  to_composition_event,
  to_custom_event,
  to_drag_event,
  to_focus_event,
  to_input_event,
  to_keyboard_event,
  to_message_event,
  to_mouse_event,
  to_pointer_event,
  to_ui_event,
  to_wheel_event,
}

///|
#cfg(target="js")
pub impl IsUIEvent for MouseEvent

///|
#cfg(target="js")
pub extend MouseEvent with IsUIEvent::{as_ui_event}

///|
#cfg(target="js")
pub impl IsMouseEvent for MouseEvent

///|
#cfg(target="js")
pub extend MouseEvent with IsMouseEvent::{
  as_mouse_event,
  get_alt_key,
  get_button,
  get_buttons,
  get_client_x,
  get_client_y,
  get_ctrl_key,
  get_meta_key,
  get_modifier_state,
  get_movement_x,
  get_movement_y,
  get_offset_x,
  get_offset_y,
  get_page_x,
  get_page_y,
  get_related_target,
  get_screen_x,
  get_screen_y,
  get_shift_key,
  get_x,
  get_y,
}

///|
#cfg(target="js")
pub impl @js.Cast for MouseEvent with fn into(value) {
  value |> ffi_to_mouse_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub extend MouseEvent with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for MouseEvent with fn from(value) {
  value |> js_identity
}

///|
#cfg(target="js")
impl IsMouseEvent with fn as_mouse_event(s) {
  s |> js_identity
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_alt_key(s) {
  s |> js_identity |> ffi_mouse_event_alt_key
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_button(s) {
  s |> js_identity |> ffi_mouse_event_button
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_buttons(s) {
  s |> js_identity |> ffi_mouse_event_buttons
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_client_x(s) {
  s |> js_identity |> ffi_mouse_event_client_x
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_client_y(s) {
  s |> js_identity |> ffi_mouse_event_client_y
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_ctrl_key(s) {
  s |> js_identity |> ffi_mouse_event_ctrl_key
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_meta_key(s) {
  s |> js_identity |> ffi_mouse_event_meta_key
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_movement_x(s) {
  s |> js_identity |> ffi_mouse_event_movement_x
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_movement_y(s) {
  s |> js_identity |> ffi_mouse_event_movement_y
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_offset_x(s) {
  s |> js_identity |> ffi_mouse_event_offset_x
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_offset_y(s) {
  s |> js_identity |> ffi_mouse_event_offset_y
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_page_x(s) {
  s |> js_identity |> ffi_mouse_event_page_x
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_page_y(s) {
  s |> js_identity |> ffi_mouse_event_page_y
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_related_target(s) {
  s
  |> js_identity
  |> ffi_mouse_event_related_target
  |> related_target => { related_target.to_option() }
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_screen_x(s) {
  s |> js_identity |> ffi_mouse_event_screen_x
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_screen_y(s) {
  s |> js_identity |> ffi_mouse_event_screen_y
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_shift_key(s) {
  s |> js_identity |> ffi_mouse_event_shift_key
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_x(s) {
  s |> js_identity |> ffi_mouse_event_x
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_y(s) {
  s |> js_identity |> ffi_mouse_event_y
}

///|
#cfg(target="js")
impl IsMouseEvent with fn get_modifier_state(s, key) {
  s |> js_identity |> ffi_mouse_event_modifier_state(key)
}

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_screen_x(e : @js.Value) -> Double = "(e) => e.screenX"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_screen_y(e : @js.Value) -> Double = "(e) => e.screenY"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_client_x(e : @js.Value) -> Double = "(e) => e.clientX"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_client_y(e : @js.Value) -> Double = "(e) => e.clientY"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_offset_x(e : @js.Value) -> Double = "(e) => e.offsetX"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_offset_y(e : @js.Value) -> Double = "(e) => e.offsetY"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_ctrl_key(e : @js.Value) -> Bool = "(e) => e.ctrlKey"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_shift_key(e : @js.Value) -> Bool = "(e) => e.shiftKey"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_alt_key(e : @js.Value) -> Bool = "(e) => e.altKey"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_meta_key(e : @js.Value) -> Bool = "(e) => e.metaKey"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_button(e : @js.Value) -> Int = "(e) => e.button"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_buttons(e : @js.Value) -> Int = "(e) => e.buttons"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_movement_x(e : @js.Value) -> Double = "(e) => e.movementX"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_movement_y(e : @js.Value) -> Double = "(e) => e.movementY"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_page_x(e : @js.Value) -> Double = "(e) => e.pageX"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_page_y(e : @js.Value) -> Double = "(e) => e.pageY"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_related_target(
  e : @js.Value,
) -> @js.Nullable[EventTarget] = "(e) => e.relatedTarget"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_x(e : @js.Value) -> Double = "(e) => e.x"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_y(e : @js.Value) -> Double = "(e) => e.y"

///|
#cfg(target="js")
extern "js" fn ffi_mouse_event_modifier_state(
  e : @js.Value,
  key : String,
) -> Bool = "(e, key) => e.getModifierState(key)"
