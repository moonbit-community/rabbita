///|
#cfg(target="js")
#external
type FocusEvent

///|
#cfg(target="js")
pub impl IsEvent for FocusEvent

///|
#cfg(target="js")
pub extend FocusEvent with IsEvent::{
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
pub impl IsUIEvent for FocusEvent

///|
#cfg(target="js")
pub extend FocusEvent with IsUIEvent::{as_ui_event}

///|
#cfg(target="js")
pub impl @js.Cast for FocusEvent with fn into(value) {
  value |> ffi_to_focus_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub extend FocusEvent with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for FocusEvent with fn from(value) {
  value |> js_identity
}

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/FocusEvent/relatedTarget
#cfg(target="js")
pub fn FocusEvent::related_target(self : Self) -> EventTarget? {
  ffi_focus_event_related_target(self).to_option()
}

///|
#cfg(target="js")
extern "js" fn ffi_focus_event_related_target(
  event : FocusEvent,
) -> @js.Nullable[EventTarget] = "(event) => event.relatedTarget"
