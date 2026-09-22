///|
/// https://developer.mozilla.org/en-US/docs/Web/API/AnimationEvent
#cfg(target="js")
type AnimationEvent

///|
#cfg(target="js")
pub impl IsEvent for AnimationEvent

///|
#cfg(target="js")
pub extend AnimationEvent with IsEvent::{
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
pub impl @js.Cast for AnimationEvent with fn into(value) {
  value |> ffi_to_animation_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub extend AnimationEvent with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for AnimationEvent with fn from(value) {
  value |> js_identity
}

///|
#cfg(target="js")
pub extern "js" fn AnimationEvent::get_animation_name(self : Self) -> String = "(e) => e.animationName"

///|
#cfg(target="js")
pub extern "js" fn AnimationEvent::get_elapsed_time(self : Self) -> Double = "(e) => e.elapsedTime"

///|
#cfg(target="js")
pub extern "js" fn AnimationEvent::get_pseudo_element(self : Self) -> String = "(e) => e.pseudoElement"
