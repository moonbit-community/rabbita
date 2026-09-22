///|
#cfg(target="js")
#external
type UIEvent

///|
#cfg(target="js")
pub trait IsUIEvent: IsEvent {
  fn as_ui_event(Self) -> UIEvent = _
}

///|
#cfg(target="js")
impl IsUIEvent with fn as_ui_event(s) {
  s |> js_identity
}

///|
#cfg(target="js")
pub impl IsEvent for UIEvent

///|
#cfg(target="js")
pub extend UIEvent with IsEvent::{
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
pub impl IsUIEvent for UIEvent

///|
#cfg(target="js")
pub extend UIEvent with IsUIEvent::{as_ui_event}

///|
#cfg(target="js")
pub impl @js.Cast for UIEvent with fn into(value) {
  value |> ffi_to_ui_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub extend UIEvent with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for UIEvent with fn from(value) {
  value |> js_identity
}
