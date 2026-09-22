///|
/// https://developer.mozilla.org/en-US/docs/Web/API/ToggleEvent
#cfg(target="js")
#external
type ToggleEvent

///|
#cfg(target="js")
pub impl IsEvent for ToggleEvent

///|
#cfg(target="js")
pub extend ToggleEvent with IsEvent::{
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
pub impl @js.Cast for ToggleEvent with fn into(value) {
  value |> ffi_to_toggle_event |> result => { result.to_option() }
}

///|
#cfg(target="js")
pub extend ToggleEvent with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for ToggleEvent with fn from(value) {
  value |> js_identity
}

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/ToggleEvent/oldState
#cfg(target="js")
pub extern "js" fn ToggleEvent::get_old_state(self : Self) -> String = "(event) => event.oldState"

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/ToggleEvent/newState
#cfg(target="js")
pub extern "js" fn ToggleEvent::get_new_state(self : Self) -> String = "(event) => event.newState"
