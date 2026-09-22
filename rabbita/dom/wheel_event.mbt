///|
#cfg(target="js")
type WheelEvent

///|
#cfg(target="js")
pub impl IsEvent for WheelEvent

///|
#cfg(target="js")
pub extend WheelEvent with IsEvent::{
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
pub impl IsUIEvent for WheelEvent

///|
#cfg(target="js")
pub extend WheelEvent with IsUIEvent::{as_ui_event}

///|
#cfg(target="js")
pub impl IsMouseEvent for WheelEvent

///|
#cfg(target="js")
pub extend WheelEvent with IsMouseEvent::{
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
pub impl @js.Cast for WheelEvent with fn into(value) {
  value |> ffi_to_wheel_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub extend WheelEvent with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for WheelEvent with fn from(value) {
  value |> js_identity
}

///|
#cfg(target="js")
pub extern "js" fn WheelEvent::get_delta_x(self : Self) -> Double = "(e) => e.deltaX"

///|
#cfg(target="js")
pub extern "js" fn WheelEvent::get_delta_y(self : Self) -> Double = "(e) => e.deltaY"

///|
#cfg(target="js")
pub extern "js" fn WheelEvent::get_delta_z(self : Self) -> Double = "(e) => e.deltaZ"

///|
#cfg(target="js")
pub extern "js" fn WheelEvent::get_delta_mode(self : Self) -> Int = "(e) => e.deltaMode"
