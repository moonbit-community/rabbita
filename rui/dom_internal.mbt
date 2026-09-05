///|
#cfg(target="js")
fn ui_has_global(name : String) -> Bool {
  let value : @js.Value = @js.globalThis.get_with_string(name)
  !value.is_undefined() && !value.is_null()
}

///|
#cfg(target="js")
fn ui_has_window() -> Bool {
  ui_has_global("window")
}

///|
#cfg(target="js")
fn ui_has_document() -> Bool {
  ui_has_global("document")
}

///|
#cfg(target="js")
fn[E] ui_transition_event(event : E) -> @dom.TransitionEvent? {
  @js.Cast::into(@js.Value::cast_from(event))
}

///|
#cfg(target="js")
fn ui_element_by_id(id : String) -> @dom.Element? {
  @dom.document().get_element_by_id(id).to_option()
}

///|
#cfg(target="js")
fn ui_find_descendant(
  root : @dom.Element,
  predicate : (@dom.Element) -> Bool,
) -> @dom.Element? {
  for child in root.get_children() {
    if predicate(child) {
      return Some(child)
    }
    if ui_find_descendant(child, predicate) is Some(found) {
      return Some(found)
    }
  }
  None
}

///|
#cfg(target="js")
fn ui_find_element(
  elements : Array[@dom.Element],
  predicate : (@dom.Element) -> Bool,
) -> @dom.Element? {
  for element in elements {
    if predicate(element) {
      return Some(element)
    }
  }
  None
}

///|
#cfg(target="js")
fn ui_find_node_list_element(
  elements : @dom.NodeList[@dom.Element],
  predicate : (@dom.Element) -> Bool,
) -> @dom.Element? {
  for element in elements {
    if predicate(element) {
      return Some(element)
    }
  }
  None
}

///|
#cfg(target="js")
fn ui_find_descendant_by_attribute(
  root : @dom.Element,
  name : String,
  value : String,
) -> @dom.Element? {
  ui_find_descendant(root, element => {
    element.get_attribute(name).unwrap_or("") == value
  })
}

///|
#cfg(target="js")
fn ui_element_contains_target(
  root : @dom.Element,
  target : @dom.EventTarget,
) -> Bool {
  if target.to_node() is Some(node) {
    root.contains(node)
  } else {
    false
  }
}

///|
#cfg(target="js")
fn ui_focus_element(element : @dom.Element) -> Unit {
  if element.to_html_element() is Some(html_element) {
    html_element.focus()
  }
}

///|
#cfg(target="js")
fn ui_focus_element_without_scroll(element : @dom.Element) -> Unit {
  if element.to_html_element() is Some(html_element) {
    html_element.focus_with_options(prevent_scroll=true)
  }
}

///|
#cfg(target="js")
fn ui_click_element(element : @dom.Element) -> Unit {
  if element.to_html_element() is Some(html_element) {
    html_element.click()
  }
}

///|
#cfg(target="js")
fn ui_set_element_tab_index(element : @dom.Element, value : Int) -> Unit {
  if element.to_html_element() is Some(html_element) {
    html_element.set_tab_index(value)
  }
}

///|
#cfg(target="js")
fn ui_element_is_enabled(element : @dom.Element) -> Bool {
  !element.has_attribute("disabled") &&
  element.get_attribute("aria-disabled").unwrap_or("") != "true"
}

///|
#cfg(target="js")
fn ui_element_is_rtl(element : @dom.Element) -> Bool {
  if ui_has_window() {
    let style = @dom.window().get_computed_style(element)
    style.get_property_value("direction") == "rtl"
  } else {
    false
  }
}

///|
#cfg(target="js")
priv struct UiRovingContext {
  current : @dom.Element
  root : @dom.Element
  items : Array[@dom.Element]
}

///|
#cfg(target="js")
fn ui_roving_context(
  event : @dom.KeyboardEvent,
  current_selector : String,
  root_selector : String,
  item_selector : String,
) -> UiRovingContext? {
  guard event.target().to_element() is Some(target) else { return None }
  guard target.closest(current_selector) is Some(current) else { return None }
  guard current.closest(root_selector) is Some(root) else { return None }
  let items = root
    .query_selector_all(item_selector)
    .iter()
    .filter(item => {
      item.closest(root_selector) is Some(owner) &&
      owner.is_same_node(root.as_node()) &&
      ui_element_is_enabled(item)
    })
    .collect()
  if items.length() == 0 {
    None
  } else {
    Some({ current, root, items, })
  }
}

///|
#cfg(target="js")
fn ui_roving_target(
  context : UiRovingContext,
  key : String,
  orientation : String,
  rtl : Bool,
) -> @dom.Element? {
  let mut index = -1
  for item_index, item in context.items {
    if item.is_same_node(context.current.as_node()) {
      index = item_index
    }
  }
  if index < 0 {
    return None
  }
  let length = context.items.length()
  let previous = if index == 0 { length - 1 } else { index - 1 }
  let next = if index == length - 1 { 0 } else { index + 1 }
  let target_index = match key {
    "Home" => 0
    "End" => length - 1
    "ArrowUp" if orientation == "vertical" || orientation == "both" => previous
    "ArrowDown" if orientation == "vertical" || orientation == "both" => next
    "ArrowLeft" if orientation == "horizontal" || orientation == "both" =>
      if rtl {
        next
      } else {
        previous
      }
    "ArrowRight" if orientation == "horizontal" || orientation == "both" =>
      if rtl {
        previous
      } else {
        next
      }
    _ => -1
  }
  context.items.get(target_index)
}

///|
fn ui_parse_int_or(value : String, fallback : Int) -> Int {
  @string.parse_int(value) catch {
    _ => fallback
  }
}

///|
fn ui_parse_double_or(value : String, fallback : Double) -> Double {
  @string.parse_double(value) catch {
    _ => fallback
  }
}
