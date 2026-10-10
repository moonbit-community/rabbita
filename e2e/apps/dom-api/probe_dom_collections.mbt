///|
fn probe_dom_collections() -> String {
  let failures : Array[String] = []
  probe_uint8_clamped_array(failures)
  probe_dom_token_list(failures)
  probe_data_transfer_items(failures)
  finish_probe(failures)
}

///|
fn probe_uint8_clamped_array(failures : Array[String]) -> Unit {
  let image_data = @dom.ImageData::new(2, 2, @js.Optional::undefined())
  let data = image_data.get_data()
  record(failures, data.length() == 16, "array_length")
  record(failures, data.get(0) == Some(0), "array_read")
  data.set(0, 300)
  record(failures, data.get(0) == Some(255), "array_clamp_high")
  data.set(1, -20)
  record(failures, data.get(1) == Some(0), "array_clamp_low")
  record(failures, data.get(100) is None, "array_out_of_range")
  record(
    failures,
    image_data.get_data().get(0) == Some(255),
    "array_shared_view",
  )
  let document = @dom.document()
  let canvas_element = document.create_element("canvas")
  @dom.IsElement::set_attribute(canvas_element, "width", "2")
  @dom.IsElement::set_attribute(canvas_element, "height", "2")
  if document.get_body() is Some(body) {
    @dom.IsNode::append_child(body, @dom.IsNode::as_node(canvas_element))
    if @dom.IsEventTarget::to_html_canvas_element(canvas_element)
      is Some(canvas) {
      if canvas.get_context("2d").to0() is Some(context) {
        data.set(2, 64)
        data.set(3, 255)
        context.put_image_data(image_data, 0, 0)
        let readback = context.get_image_data(
          0.0,
          0.0,
          2.0,
          2.0,
          settings=@js.Optional::undefined(),
        )
        record(
          failures,
          readback.get_data().get(0) == Some(255),
          "array_canvas_write_through",
        )
        record(
          failures,
          readback.get_data().get(2) == Some(64),
          "array_canvas_channel",
        )
      } else {
        failures.push("array_2d_context")
      }
    } else {
      failures.push("array_canvas_conversion")
    }
    @dom.IsNode::remove_child(body, @dom.IsNode::as_node(canvas_element))
  } else {
    failures.push("array_missing_body")
  }
}

///|
fn probe_dom_token_list(failures : Array[String]) -> Unit {
  let document = @dom.document()
  let element = document.create_element("div")
  @dom.IsElement::set_attribute(element, "class", "alpha beta")
  let tokens = element.class_list()
  record(failures, tokens.length() == 2, "token_length")
  record(failures, tokens.item(0) == Some("alpha"), "token_item")
  record(failures, tokens.item(2) is None, "token_item_out_of_range")
  record(failures, tokens.contains("beta"), "token_contains")
  tokens.add("gamma")
  record(failures, tokens.length() == 3, "token_add")
  record(failures, tokens.contains("gamma"), "token_add_contains")
  tokens.remove("alpha")
  record(failures, !tokens.contains("alpha"), "token_remove")
  record(failures, !tokens.toggle("beta"), "token_toggle_off")
  record(failures, tokens.toggle("beta"), "token_toggle_on")
  record(
    failures,
    tokens.toggle_with_force("delta", true),
    "token_toggle_force",
  )
  record(
    failures,
    tokens.toggle_with_force("delta", true),
    "token_toggle_force_keep",
  )
  record(failures, tokens.replace("beta", "omega"), "token_replace")
  record(failures, !tokens.replace("missing", "sigma"), "token_replace_missing")
  record(failures, tokens.get_value() == "gamma omega delta", "token_value")
  tokens.set_value("one two")
  record(failures, tokens.length() == 2, "token_set_value")
  record(failures, tokens.item(0) == Some("one"), "token_set_value_item")
  record(
    failures,
    element.get_attribute("class") == Some("one two"),
    "token_attribute_reflection",
  )
  record(
    failures,
    native_error(() => tokens.add("two words")) == "InvalidCharacterError",
    "token_add_whitespace",
  )
  record(
    failures,
    native_error(() => tokens.add("")) == "SyntaxError",
    "token_add_empty",
  )
  record(
    failures,
    native_error(() => ignore(tokens.replace("one", ""))) == "SyntaxError",
    "token_replace_empty",
  )
  record(
    failures,
    native_error(() => ignore(tokens.toggle("two words"))) ==
    "InvalidCharacterError",
    "token_toggle_whitespace",
  )
}

///|
fn probe_data_transfer_items(failures : Array[String]) -> Unit {
  let transfer = new_data_transfer()
  let items = transfer.items()
  record(failures, items.length() == 0, "item_list_empty")
  let added = items.add("rabbit", "text/plain")
  record(failures, added is Some(_), "item_add_write_mode")
  if added is Some(item) {
    record(failures, item.get_kind() == "string", "item_kind")
    record(failures, item.get_type() == "text/plain", "item_type")
    record(failures, items.get(0) is Some(_), "item_get")
    record(failures, items.get(9) is None, "item_get_out_of_range")
    record(failures, items.length() == 1, "item_length_after_add")
    items.remove(0)
    record(failures, items.length() == 0, "item_remove_write_mode")
  }
  ignore(items.add("first", "text/plain"))
  ignore(items.add("second", "text/html"))
  record(failures, items.length() == 2, "item_add_twice")
  items.clear()
  record(failures, items.length() == 0, "item_clear_write_mode")
}

///|
fn install_drag_probes() -> Unit {
  let failures : Array[String] = []
  if element_by_id("dnd-source") is Some(source) {
    if element_by_id("dnd-target") is Some(target) {
      install_drag_listeners(failures, source, target)
    } else {
      set_result("dnd-result", "failed: missing dnd elements")
    }
  } else {
    set_result("dnd-result", "failed: missing dnd elements")
  }
}

///|
fn install_drag_listeners(
  failures : Array[String],
  source : @dom.Element,
  target : @dom.Element,
) -> Unit {
  @dom.IsElement::set_attribute(source, "draggable", "true")
  @dom.IsEventTarget::add_event_listener(source, "dragstart", event => {
    if @dom.IsEvent::to_drag_event(event) is Some(drag) {
      let items = drag.get_data_transfer().items()
      record(failures, items.length() == 0, "drag_start_empty")
      let added = items.add("dragged", "text/plain")
      record(failures, added is Some(_), "drag_start_write_mode")
      if added is Some(item) {
        record(failures, item.get_kind() == "string", "drag_start_kind")
        record(failures, item.get_type() == "text/plain", "drag_start_type")
      }
    } else {
      failures.push("drag_start_conversion")
    }
  })
  @dom.IsEventTarget::add_event_listener(target, "dragover", event => {
    @dom.IsEvent::prevent_default(event)
  })
  @dom.IsEventTarget::add_event_listener(target, "drop", event => {
    if @dom.IsEvent::to_drag_event(event) is Some(drag) {
      let items = drag.get_data_transfer().items()
      record(
        failures,
        items.add("late", "text/plain") is None,
        "drop_add_read_only",
      )
      record(
        failures,
        remove_error(items) == "InvalidStateError",
        "drop_remove_read_only",
      )
      items.clear()
      record(failures, items.length() == 1, "drop_clear_read_only")
      if items.get(0) is Some(item) {
        record(failures, item.get_kind() == "string", "drop_kind")
        record(failures, item.get_type() == "text/plain", "drop_type")
        item.get_as_string(payload => {
          record(failures, payload == "dragged", "drop_string_payload")
          set_result("dnd-result", finish_probe(failures))
        })
      } else {
        failures.push("drop_item_missing")
        set_result("dnd-result", finish_probe(failures))
      }
    } else {
      failures.push("drop_conversion")
      set_result("dnd-result", finish_probe(failures))
    }
  })
}

///|
extern "js" fn new_data_transfer() -> @dom.DataTransfer = "() => new DataTransfer()"

///|
extern "js" fn native_error(f : () -> Unit) -> String =
  #| f => { try { f(); return "no error" } catch (error) { return error.name } }

///|
extern "js" fn remove_error(items : @dom.DataTransferItemList) -> String =
  #| items => { try { items.remove(0); return "no error" } catch (error) { return error.name } }
