///|
fn probe_svg_collections() -> String {
  let failures : Array[String] = []
  let element = @dom.document().create_element_ns(@dom.namespace_svg, "g")
  let graphics = element.to_svg_graphics_element().unwrap()
  let strings : @dom.SVGStringList = graphics.get_required_extensions()
  record(failures, strings.length() == 0, "empty strings")
  record(failures, strings.initialize("first") == "first", "initialize string")
  record(failures, strings.append_item("last") == "last", "append string")
  record(
    failures,
    strings.insert_item_before("middle", 1.0) == "middle",
    "insert string",
  )
  record(
    failures,
    strings.get_length() == 3.0 && strings.get_number_of_items() == 3.0,
    "string length",
  )
  record(failures, strings.get_item(1.0) == "middle", "indexed string")
  record(
    failures,
    strings.replace_item("replaced", 1.0) == "replaced",
    "replace string",
  )
  record(failures, strings.remove_item(0.0) == "first", "remove string")
  record(
    failures,
    element.get_attribute("requiredExtensions") == Some("replaced last"),
    "string attribute reflection",
  )
  record(
    failures,
    native_error(() => ignore(strings.get_item(99.0))) == "IndexSizeError",
    "string index error",
  )
  record(
    failures,
    strings.insert_item_before("end", 99.0) == "end",
    "insert past end appends",
  )
  strings.clear()
  record(failures, strings.length() == 0, "clear strings")
  let languages = graphics.get_system_language()
  ignore(languages.append_item("en"))
  record(
    failures,
    element.get_attribute("systemLanguage") == Some("en"),
    "systemLanguage list",
  )

  element.set_attribute("transform", "translate(10 20) scale(2)")
  let transforms = graphics.get_transform()
  let base = transforms.get_base_val()
  let animated : @dom.SVGTransformList = transforms.get_anim_val()
  record(
    failures,
    base.length() == 2 && base.get_number_of_items() == 2.0,
    "base length",
  )
  record(
    failures,
    animated.length() == 2 &&
    animated.get_length() == 2.0 &&
    animated.get_number_of_items() == 2.0,
    "animated length",
  )
  record(failures, transform_type(base.get_item(0.0)) == 2, "base get item")
  record(
    failures,
    transform_type(animated.get_item(1.0)) == 3,
    "animated get item",
  )
  record(
    failures,
    native_error(() => ignore(base.get_item(99.0))) == "IndexSizeError",
    "transform index error",
  )
  record(
    failures,
    animated_clear_error(animated) == "NoModificationAllowedError",
    "animated native read-only list",
  )
  record(
    failures,
    animated_item_error(animated.get_item(0.0)) == "NoModificationAllowedError",
    "animated native read-only item",
  )
  let translation = base.remove_item(0.0)
  record(
    failures,
    transform_type(translation) == 2 && base.length() == 1,
    "remove transform",
  )
  record(
    failures,
    element.get_attribute("transform") == Some("scale(2 2)"),
    "transform attribute reflection",
  )
  record(failures, animated.length() == 1, "animated list stays live")
  ignore(base.append_item(translation))
  let scale = base.remove_item(0.0)
  ignore(base.insert_item_before(scale, 0.0))
  record(failures, transform_type(base.get_item(0.0)) == 3, "insert transform")
  let replacement = base.remove_item(1.0)
  ignore(base.replace_item(replacement, 0.0))
  record(
    failures,
    base.length() == 1 && transform_type(base.get_item(0.0)) == 2,
    "replace transform",
  )
  ignore(base.initialize(scale))
  record(
    failures,
    base.length() == 1 && transform_type(base.get_item(0.0)) == 3,
    "initialize transform",
  )
  ignore(base.append_item(translation))
  record(
    failures,
    base.consolidate().to_option() is Some(_),
    "consolidate transforms",
  )
  record(
    failures,
    base.length() == 1 && transform_type(base.get_item(0.0)) == 1,
    "consolidated matrix",
  )
  base.clear()
  record(
    failures,
    base.length() == 0 && animated.length() == 0,
    "clear transforms",
  )
  record(
    failures,
    base.consolidate().to_option() is None,
    "consolidate empty list",
  )
  finish_probe(failures)
}

///|
extern "js" fn transform_type(value : @dom.SVGTransform) -> Int = "value => value.type"

///|
extern "js" fn animated_clear_error(list : @dom.SVGTransformList) -> String =
  #| list => { try { list.clear(); return "no error" } catch (error) { return error.name } }

///|
extern "js" fn animated_item_error(value : @dom.SVGTransform) -> String =
  #| value => { try { value.setTranslate(1, 2); return "no error" } catch (error) { return error.name } }
