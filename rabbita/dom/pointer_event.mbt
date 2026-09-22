///|
/// https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent
#cfg(target="js")
#external
type PointerEvent

///|
#cfg(target="js")
pub impl IsEvent for PointerEvent

///|
#cfg(target="js")
pub extend PointerEvent with IsEvent::{
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
pub impl IsUIEvent for PointerEvent

///|
#cfg(target="js")
pub extend PointerEvent with IsUIEvent::{as_ui_event}

///|
#cfg(target="js")
pub impl IsMouseEvent for PointerEvent

///|
#cfg(target="js")
pub extend PointerEvent with IsMouseEvent::{
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
pub impl @js.Cast for PointerEvent with fn into(value) {
  value |> ffi_to_pointer_event |> result => { result.to_option() }
}

///|
#cfg(target="js")
pub extend PointerEvent with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for PointerEvent with fn from(value) {
  value |> js_identity
}

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/pointerId
#cfg(target="js")
pub extern "js" fn PointerEvent::get_pointer_id(self : Self) -> Int = "(event) => event.pointerId"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/width
#cfg(target="js")
pub extern "js" fn PointerEvent::get_width(self : Self) -> Double = "(event) => event.width"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/height
#cfg(target="js")
pub extern "js" fn PointerEvent::get_height(self : Self) -> Double = "(event) => event.height"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/pressure
#cfg(target="js")
pub extern "js" fn PointerEvent::get_pressure(self : Self) -> Double = "(event) => event.pressure"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/tangentialPressure
#cfg(target="js")
pub extern "js" fn PointerEvent::get_tangential_pressure(self : Self) -> Double = "(event) => event.tangentialPressure"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/tiltX
#cfg(target="js")
pub extern "js" fn PointerEvent::get_tilt_x(self : Self) -> Int = "(event) => event.tiltX"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/tiltY
#cfg(target="js")
pub extern "js" fn PointerEvent::get_tilt_y(self : Self) -> Int = "(event) => event.tiltY"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/twist
#cfg(target="js")
pub extern "js" fn PointerEvent::get_twist(self : Self) -> Int = "(event) => event.twist"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/altitudeAngle
#cfg(target="js")
pub extern "js" fn PointerEvent::get_altitude_angle(self : Self) -> Double = "(event) => event.altitudeAngle"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/azimuthAngle
#cfg(target="js")
pub extern "js" fn PointerEvent::get_azimuth_angle(self : Self) -> Double = "(event) => event.azimuthAngle"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/pointerType
#cfg(target="js")
pub extern "js" fn PointerEvent::get_pointer_type(self : Self) -> String = "(event) => event.pointerType"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/isPrimary
#cfg(target="js")
pub extern "js" fn PointerEvent::get_is_primary(self : Self) -> Bool = "(event) => event.isPrimary"
