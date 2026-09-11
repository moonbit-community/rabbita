///|
fn install_event_probes() -> Unit {
  if element_by_id("event-target") is Some(target) {
    @dom.IsElement::set_attribute(
      target, "style", "width: 160px; height: 64px; background: rgb(220, 220, 220)",
    )
    install_generic_event_probe(target)
    install_pointer_event_probe(target)
    install_fractional_pointer_event_probe(target)
    install_subtype_event_probes(target)
  } else {
    @dom.window().queue_microtask(() => {
      set_result("event-generic-result", "failed: event_target")
    })
  }
  if element_by_id("key-target") is Some(target) {
    install_keyboard_event_probe(target)
  }
  if element_by_id("input-target") is Some(target) {
    install_input_event_probe(target)
  }
}

///|
fn install_generic_event_probe(target : @dom.Element) -> Unit {
  let failures : Array[String] = []
  let calls = [0]
  let once_calls = [0]
  let removed_calls = [0]
  let listener : @dom.Listener = event => {
    calls[0] += 1
    record(
      failures,
      @dom.IsEventTarget::to_element(@dom.IsEvent::target(event)) is Some(_),
      "event_target",
    )
    record(
      failures,
      @dom.IsEvent::current_target(event).to_option() is Some(_),
      "event_current_target",
    )
    record(
      failures,
      @dom.IsEvent::get_time_stamp(event) >= 0.0,
      "event_timestamp",
    )
    let path = @dom.IsEvent::composed_path(event)
    record(failures, !path.is_empty(), "event_composed_path")
    record(
      failures,
      path.get(0) is Some(first) &&
      first.to_node() is Some(first_node) &&
      event.target().to_node() is Some(target_node) &&
      first_node.is_same_node(target_node),
      "event_composed_path_target_first",
    )
    @dom.IsEvent::prevent_default(event)
    record(
      failures,
      @dom.IsEvent::get_default_prevented(event),
      "event_prevent_default",
    )
    @dom.IsEvent::stop_propagation(event)
  }
  let once_listener : @dom.Listener = _ => once_calls[0] += 1
  let removed_listener : @dom.Listener = _ => removed_calls[0] += 1
  @dom.IsEventTarget::add_event_listener(target, "generic-probe", listener)
  @dom.IsEventTarget::add_event_listener_with_options(
    target,
    "generic-probe",
    once_listener,
    capture=true,
    passive=false,
    once=true,
  )
  @dom.IsEventTarget::add_event_listener_with_options(
    target,
    "generic-probe",
    removed_listener,
    capture=true,
  )
  @dom.IsEventTarget::remove_event_listener_with_options(
    target,
    "generic-probe",
    removed_listener,
    capture=true,
  )
  let immediate_calls = [0]
  let immediate_listener : @dom.Listener = event => {
    @dom.IsEvent::stop_immediate_propagation(event)
  }
  let skipped_listener : @dom.Listener = _ => immediate_calls[0] += 1
  @dom.IsEventTarget::add_event_listener(
    target, "immediate-probe", immediate_listener,
  )
  @dom.IsEventTarget::add_event_listener(
    target, "immediate-probe", skipped_listener,
  )
  @dom.IsEventTarget::dispatch_event(target, @dom.Event::new("immediate-probe"))
  @dom.IsEventTarget::remove_event_listener(
    target, "immediate-probe", immediate_listener,
  )
  @dom.IsEventTarget::remove_event_listener(
    target, "immediate-probe", skipped_listener,
  )
  record(failures, immediate_calls[0] == 0, "event_stop_immediate_propagation")
  let first = @dom.Event::new(
    "generic-probe",
    bubbles=true,
    cancelable=true,
    composed=true,
  )
  let second = @dom.Event::new(
    "generic-probe",
    bubbles=true,
    cancelable=true,
    composed=true,
  )
  @dom.IsEventTarget::dispatch_event(target, first)
  @dom.IsEventTarget::dispatch_event(target, second)
  @dom.IsEventTarget::remove_event_listener(target, "generic-probe", listener)
  record(failures, calls[0] == 2, "event_listener")
  record(failures, once_calls[0] == 1, "event_listener_once")
  record(failures, removed_calls[0] == 0, "event_listener_remove")
  record(
    failures,
    @dom.IsEvent::to_ui_event(first) is None,
    "generic_not_ui_event",
  )
  record(
    failures,
    @dom.IsEvent::to_pointer_event(first) is None,
    "generic_not_pointer_event",
  )
  record(
    failures,
    @dom.IsEvent::to_mouse_event(first) is None,
    "generic_not_mouse_event",
  )
  record(
    failures,
    physical_equal(@dom.IsEvent::as_event(first), first),
    "as_event",
  )
  let custom = @dom.CustomEvent::new(
    "custom-direct",
    detail=@js.Optional::from_option(Some(@js.Value::cast_from("detail"))),
  )
  record(
    failures,
    custom.get_detail().to_string() == "detail",
    "custom_event_detail",
  )
  let composition = @dom.CompositionEvent::new()
  ignore(composition.get_data())
  record(
    failures,
    @dom.IsEvent::to_composition_event(composition) is Some(_),
    "composition_constructor",
  )
  let blob_event = @dom.BlobEvent::new()
  record(
    failures,
    blob_event.get_data().get_size() == 0,
    "blob_event_constructor",
  )
  ignore(blob_event.get_timecode())
  @dom.window().queue_microtask(() => {
    set_result("event-generic-result", finish_probe(failures))
  })
}

///|
fn install_fractional_pointer_event_probe(target : @dom.Element) -> Unit {
  let listener : @dom.Listener = event => {
    let failures : Array[String] = []
    if @dom.IsEvent::to_pointer_event(event) is Some(pointer) {
      record(
        failures,
        @dom.IsEvent::to_mouse_event(pointer) is Some(_),
        "pointer_fractional_mouse_event",
      )
      record(
        failures,
        pointer.get_client_x() == 10.25 && pointer.get_client_y() == 20.75,
        "pointer_fractional_client",
      )
      record(
        failures,
        pointer.get_page_x() == 10.25 && pointer.get_page_y() == 20.75,
        "pointer_fractional_page",
      )
      record(
        failures,
        pointer.get_screen_x() == 30.5 && pointer.get_screen_y() == 40.125,
        "pointer_fractional_screen",
      )
      record(
        failures,
        pointer.get_x() == 10.25 && pointer.get_y() == 20.75,
        "pointer_fractional_alias",
      )
    } else {
      failures.push("pointer_fractional_conversion")
    }
    set_result("event-fractional-pointer-result", finish_probe(failures))
  }
  @dom.IsEventTarget::add_event_listener(
    target, "fractional-pointer-probe", listener,
  )
}

///|
fn install_pointer_event_probe(target : @dom.Element) -> Unit {
  let listener : @dom.Listener = event => {
    let failures : Array[String] = []
    if @dom.IsEvent::to_pointer_event(event) is Some(pointer) {
      record(
        failures,
        @dom.IsEvent::to_mouse_event(pointer) is Some(_),
        "pointer_mouse_event",
      )
      ignore(@dom.IsMouseEvent::as_mouse_event(pointer))
      ignore(@dom.IsUIEvent::as_ui_event(pointer))
      record(failures, pointer.get_pointer_id() > 0, "pointer_id")
      record(failures, pointer.get_width() > 0.0, "pointer_width")
      record(failures, pointer.get_height() > 0.0, "pointer_height")
      record(failures, pointer.get_pressure() >= 0.0, "pointer_pressure")
      record(
        failures,
        pointer.get_tangential_pressure() >= -1.0,
        "pointer_tangential_pressure",
      )
      ignore(pointer.get_tilt_x())
      ignore(pointer.get_tilt_y())
      ignore(pointer.get_twist())
      ignore(pointer.get_altitude_angle())
      ignore(pointer.get_azimuth_angle())
      record(failures, pointer.get_pointer_type() == "mouse", "pointer_type")
      record(failures, pointer.get_is_primary(), "pointer_primary")
      record(
        failures,
        @dom.IsMouseEvent::get_buttons(pointer) == 1,
        "pointer_buttons",
      )
      record(
        failures,
        @dom.IsMouseEvent::get_button(pointer) == 0,
        "pointer_button",
      )
      ignore(@dom.IsMouseEvent::get_client_x(pointer))
      ignore(@dom.IsMouseEvent::get_client_y(pointer))
      ignore(@dom.IsMouseEvent::get_page_x(pointer))
      ignore(@dom.IsMouseEvent::get_page_y(pointer))
      ignore(@dom.IsMouseEvent::get_screen_x(pointer))
      ignore(@dom.IsMouseEvent::get_screen_y(pointer))
      ignore(@dom.IsMouseEvent::get_offset_x(pointer))
      ignore(@dom.IsMouseEvent::get_offset_y(pointer))
      ignore(@dom.IsMouseEvent::get_movement_x(pointer))
      ignore(@dom.IsMouseEvent::get_movement_y(pointer))
      ignore(@dom.IsMouseEvent::get_x(pointer))
      ignore(@dom.IsMouseEvent::get_y(pointer))
      ignore(@dom.IsMouseEvent::get_alt_key(pointer))
      ignore(@dom.IsMouseEvent::get_ctrl_key(pointer))
      ignore(@dom.IsMouseEvent::get_meta_key(pointer))
      ignore(@dom.IsMouseEvent::get_shift_key(pointer))
      record(
        failures,
        !@dom.IsMouseEvent::get_modifier_state(pointer, "Shift"),
        "pointer_modifier_state",
      )
      record(
        failures,
        @dom.IsMouseEvent::get_related_target(pointer) is None,
        "pointer_related_target",
      )
      @dom.IsElement::set_pointer_capture(target, pointer.get_pointer_id())
      record(
        failures,
        @dom.IsElement::has_pointer_capture(target, pointer.get_pointer_id()),
        "pointer_capture",
      )
      @dom.IsElement::release_pointer_capture(target, pointer.get_pointer_id())
      record(
        failures,
        !@dom.IsElement::has_pointer_capture(target, pointer.get_pointer_id()),
        "pointer_release",
      )
    } else {
      failures.push("pointer_conversion")
    }
    set_result("event-pointer-result", finish_probe(failures))
  }
  @dom.IsEventTarget::add_event_listener(target, "pointerdown", listener)
}

///|
fn install_keyboard_event_probe(target : @dom.Element) -> Unit {
  let listener : @dom.Listener = event => {
    let failures : Array[String] = []
    if @dom.IsEvent::to_keyboard_event(event) is Some(keyboard) {
      record(failures, keyboard.key() == "K", "keyboard_key")
      record(failures, keyboard.code() == "KeyK", "keyboard_code")
      record(failures, keyboard.shift_key(), "keyboard_shift")
      record(failures, !keyboard.alt_key(), "keyboard_alt")
      record(failures, !keyboard.ctrl_key(), "keyboard_ctrl")
      record(failures, !keyboard.meta_key(), "keyboard_meta")
      record(failures, !keyboard.repeat(), "keyboard_repeat")
      record(failures, !keyboard.is_composing(), "keyboard_composing")
      record(
        failures,
        keyboard.location() == @dom.DOM_KEY_LOCATION_STANDARD,
        "keyboard_location",
      )
      record(
        failures,
        @dom.IsEvent::to_ui_event(keyboard) is Some(_),
        "keyboard_ui_event",
      )
    } else {
      failures.push("keyboard_conversion")
    }
    set_result("event-keyboard-result", finish_probe(failures))
  }
  @dom.IsEventTarget::add_event_listener(target, "keydown", listener)
}

///|
fn install_input_event_probe(target : @dom.Element) -> Unit {
  let listener : @dom.Listener = event => {
    let failures : Array[String] = []
    if @dom.IsEvent::to_input_event(event) is Some(input) {
      record(failures, input.data() == "x", "input_data")
      record(failures, input.input_type() == "insertText", "input_type")
      record(failures, !input.is_composing(), "input_composing")
    } else {
      failures.push("input_conversion")
    }
    set_result("event-subtypes-result", finish_probe(failures))
  }
  @dom.IsEventTarget::add_event_listener(target, "input-probe", listener)
}

///|
fn install_subtype_event_probes(target : @dom.Element) -> Unit {
  let failures : Array[String] = []
  let completed = [0]
  fn complete() {
    completed[0] += 1
    if completed[0] == 10 {
      set_result("event-subtypes-result", finish_probe(failures))
    }
  }
  let wheel_listener : @dom.Listener = event => {
    if @dom.IsEvent::to_wheel_event(event) is Some(wheel) {
      record(failures, wheel.get_delta_x() == 1.0, "wheel_delta_x")
      record(failures, wheel.get_delta_y() == 2.0, "wheel_delta_y")
      record(failures, wheel.get_delta_z() == 3.0, "wheel_delta_z")
      record(failures, wheel.get_delta_mode() == 0, "wheel_delta_mode")
    } else {
      failures.push("wheel_conversion")
    }
    set_result("event-wheel-result", finish_probe(failures))
  }
  @dom.IsEventTarget::add_event_listener(target, "wheel-probe", wheel_listener)

  @dom.IsEventTarget::add_event_listener(target, "focus-probe", event => {
    if @dom.IsEvent::to_focus_event(event) is Some(focus) {
      record(failures, focus.related_target() is None, "focus_related_target")
      record(
        failures,
        @dom.IsEvent::to_ui_event(focus) is Some(_),
        "focus_ui_event",
      )
    } else {
      failures.push("focus_conversion")
    }
    complete()
  })
  @dom.IsEventTarget::add_event_listener(target, "composition-probe", event => {
    if @dom.IsEvent::to_composition_event(event) is Some(composition) {
      record(failures, composition.get_data() == "compose", "composition_data")
    } else {
      failures.push("composition_conversion")
    }
    complete()
  })
  @dom.IsEventTarget::add_event_listener(target, "animation-probe", event => {
    if @dom.IsEvent::to_animation_event(event) is Some(animation) {
      record(
        failures,
        animation.get_animation_name() == "fade",
        "animation_name",
      )
      record(
        failures,
        animation.get_elapsed_time() == 0.25,
        "animation_elapsed",
      )
      record(
        failures,
        animation.get_pseudo_element() == "::before",
        "animation_pseudo",
      )
    } else {
      failures.push("animation_conversion")
    }
    complete()
  })
  @dom.IsEventTarget::add_event_listener(target, "transition-probe", event => {
    let transition : @dom.TransitionEvent? = @js.Cast::into(
      @js.Value::cast_from(event),
    )
    if transition is Some(transition) {
      record(
        failures,
        transition.get_property_name() == "opacity",
        "transition_property",
      )
      record(
        failures,
        transition.get_elapsed_time() == 0.5,
        "transition_elapsed",
      )
      record(
        failures,
        transition.get_pseudo_element() == "::after",
        "transition_pseudo",
      )
    } else {
      failures.push("transition_conversion")
    }
    complete()
  })
  @dom.IsEventTarget::add_event_listener(target, "toggle-probe", event => {
    let toggle : @dom.ToggleEvent? = @js.Cast::into(@js.Value::cast_from(event))
    if toggle is Some(toggle) {
      record(failures, toggle.get_old_state() == "closed", "toggle_old")
      record(failures, toggle.get_new_state() == "open", "toggle_new")
    } else {
      failures.push("toggle_conversion")
    }
    complete()
  })
  @dom.IsEventTarget::add_event_listener(target, "custom-probe", event => {
    if @dom.IsEvent::to_custom_event(event) is Some(custom) {
      record(
        failures,
        custom.get_detail().to_string() == "custom detail",
        "custom_detail",
      )
    } else {
      failures.push("custom_conversion")
    }
    complete()
  })
  @dom.IsEventTarget::add_event_listener(target, "message-probe", event => {
    if @dom.IsEvent::to_message_event(event) is Some(message) {
      record(
        failures,
        message.get_data_string() == Some("message data"),
        "message_data_string",
      )
      record(failures, message.get_data().is_string(), "message_data_value")
    } else {
      failures.push("message_conversion")
    }
    complete()
  })
  @dom.IsEventTarget::add_event_listener(target, "blob-probe", event => {
    if @dom.IsEvent::to_blob_event(event) is Some(blob) {
      record(failures, blob.get_data().get_size() == 4, "blob_event_data")
      record(failures, blob.get_timecode() == 1.5, "blob_event_timecode")
    } else {
      failures.push("blob_event_conversion")
    }
    complete()
  })
  @dom.IsEventTarget::add_event_listener(target, "drag-probe", event => {
    if @dom.IsEvent::to_drag_event(event) is Some(drag) {
      let transfer = drag.get_data_transfer()
      ignore(transfer.drop_effect())
      ignore(transfer.effect_allowed())
      let items = transfer.items()
      items.add("rabbit", "text/plain")
      record(failures, items.length() == 1, "data_transfer_add")
      ignore(items.get(0))
      items.remove(0)
      record(failures, items.length() == 0, "data_transfer_remove")
      items.add("rabbit", "text/plain")
      items.clear()
      record(failures, items.length() == 0, "data_transfer_clear")
      transfer.set_drog_image(target, 0, 0)
    } else {
      failures.push("drag_conversion")
    }
    complete()
  })
  @dom.IsEventTarget::add_event_listener(target, "clipboard-probe", event => {
    if @dom.IsEvent::to_clipboard_event(event) is Some(clipboard) {
      let items = clipboard.clipboard_data().items()
      items.add("copy", "text/plain")
      record(failures, items.length() == 1, "clipboard_event_data")
      items.clear()
    } else {
      failures.push("clipboard_conversion")
    }
    complete()
  })
  @dom.IsEventTarget::add_event_listener(@dom.window(), "beforeunload", event => {
    record_before_unload_probe(
      @dom.IsEvent::to_before_unload_event(event) is Some(_),
    )
  })
}

///|
extern "js" fn record_before_unload_probe(passed : Bool) -> Unit =
  #| (passed) => sessionStorage.setItem(
  #|   'dom-api-beforeunload',
  #|   passed ? 'passed' : 'failed',
  #| )
