///|
#cfg(target="js")
#external
type KeyboardEvent

///|
#cfg(target="js")
pub impl IsEvent for KeyboardEvent

///|
#cfg(target="js")
pub extend KeyboardEvent with IsEvent::{
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
pub impl IsUIEvent for KeyboardEvent

///|
#cfg(target="js")
pub extend KeyboardEvent with IsUIEvent::{as_ui_event}

///|
#cfg(target="js")
pub impl @js.Cast for KeyboardEvent with fn into(value) {
  value |> ffi_to_keyboard_event |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub extend KeyboardEvent with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for KeyboardEvent with fn from(value) {
  value |> js_identity
}

///|
#cfg(target="js")
pub extern "js" fn KeyboardEvent::key(self : Self) -> String = "(e) => e.key"

///|
#cfg(target="js")
pub extern "js" fn KeyboardEvent::code(self : Self) -> String = "(e) => e.code"

///|
#cfg(target="js")
pub extern "js" fn KeyboardEvent::alt_key(self : Self) -> Bool = "(e) => e.altKey"

///|
#cfg(target="js")
pub extern "js" fn KeyboardEvent::ctrl_key(self : Self) -> Bool = "(e) => e.ctrlKey"

///|
#cfg(target="js")
pub extern "js" fn KeyboardEvent::shift_key(self : Self) -> Bool = "(e) => e.shiftKey"

///|
#cfg(target="js")
pub extern "js" fn KeyboardEvent::meta_key(self : Self) -> Bool = "(e) => e.metaKey"

///|
#cfg(target="js")
pub extern "js" fn KeyboardEvent::is_composing(self : Self) -> Bool = "(e) => e.isComposing"

///|
#cfg(target="js")
pub extern "js" fn KeyboardEvent::repeat(self : Self) -> Bool = "(e) => e.repeat"

///|
#cfg(target="js")
pub extern "js" fn KeyboardEvent::location(self : Self) -> Int = "(e) => e.location"

///|
#cfg(target="js")
pub const DOM_KEY_LOCATION_STANDARD : Int = 0x00

///|
#cfg(target="js")
pub const DOM_KEY_LOCATION_LEFT : Int = 0x01

///|
#cfg(target="js")
pub const DOM_KEY_LOCATION_RIGHT : Int = 0x02

///|
#cfg(target="js")
pub const DOM_KEY_LOCATION_NUMPAD : Int = 0x03
