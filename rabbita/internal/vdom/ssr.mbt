///|
fn write_escaped_text(buf : StringBuilder, value : String) -> Unit {
  for c in value.iter() {
    match c {
      '&' => buf.write_string("&amp;")
      '<' => buf.write_string("&lt;")
      '>' => buf.write_string("&gt;")
      _ => buf.write_char(c)
    }
  }
}

///|
fn is_html_raw_text_element(tag : String) -> Bool {
  match tag {
    "script"
    | "style"
    | "xmp"
    | "iframe"
    | "noembed"
    | "noframes"
    | "plaintext" => true
    _ => false
  }
}

///|
fn write_escaped_attr_value(buf : StringBuilder, value : String) -> Unit {
  for c in value.iter() {
    match c {
      '&' => buf.write_string("&amp;")
      '<' => buf.write_string("&lt;")
      '>' => buf.write_string("&gt;")
      '"' => buf.write_string("&quot;")
      '\'' => buf.write_string("&#39;")
      _ => buf.write_char(c)
    }
  }
}

///|
fn write_attr(buf : StringBuilder, name : String, value : String) -> Unit {
  buf.write_char(' ')
  buf.write_string(name)
  buf.write_string("=\"")
  write_escaped_attr_value(buf, value)
  buf.write_char('"')
}

///|
fn write_styles_attr(
  buf : StringBuilder,
  attrs : Map[String, String],
  styles : Map[String, String],
) -> Unit {
  if !attrs.contains("style") && styles.is_empty() {
    return
  }
  buf.write_string(" style=\"")
  let mut need_separator = false
  if attrs.get("style") is Some(style_text) {
    write_escaped_attr_value(buf, style_text)
    need_separator = !style_text.is_empty() && !style_text.has_suffix(";")
  }
  for name, value in styles {
    if need_separator {
      buf.write_char(';')
    }
    buf.write_string(name)
    buf.write_char(':')
    write_escaped_attr_value(buf, value)
    need_separator = true
  }
  buf.write_char('"')
}

///|
fn write_variant_text(buf : StringBuilder, value : @variant.Variant) -> Unit {
  match value {
    Boolean(v) => write_escaped_text(buf, v.to_string())
    Integer(v) => write_escaped_text(buf, v.to_string())
    Floating(v) => write_escaped_text(buf, v.to_string())
    String(v) => write_escaped_text(buf, v)
  }
}

///|
fn write_raw_variant_text(
  buf : StringBuilder,
  value : @variant.Variant,
) -> Unit {
  match value {
    Boolean(v) => buf.write_string(v.to_string())
    Integer(v) => buf.write_string(v.to_string())
    Floating(v) => buf.write_string(v.to_string())
    String(v) => buf.write_string(v)
  }
}

///|
fn write_property_attrs(
  buf : StringBuilder,
  tag : String,
  attrs : Map[String, String],
  props : Map[String, @variant.Variant],
) -> Unit {
  for property, value in props {
    if property == "textContent" ||
      property == "innerHTML" ||
      property == "style" ||
      (tag == "textarea" && property == "value") {
      continue
    }
    // A reflected property is spelt in camelCase (`readOnly`); its HTML
    // attribute is the same name in lower case.
    let name = property.to_lower()
    if attrs.contains(name) {
      continue
    }
    match value {
      Boolean(v) =>
        if v {
          buf.write_char(' ')
          buf.write_string(name)
        }
      Integer(v) => write_attr(buf, name, v.to_string())
      Floating(v) => write_attr(buf, name, v.to_string())
      String(v) => write_attr(buf, name, v)
    }
  }
}

///|
fn vnode_to_string(
  buf : StringBuilder,
  vnode : VNode,
  in_raw_text_element : Bool,
) -> Unit {
  match vnode {
    Thunk(_, render) => vnode_to_string(buf, render(), in_raw_text_element)
    Elem(tag, props, children, namespace_uri=ns) => {
      let tag = rendered_tag(tag)
      let { attrs, props, styles, .. } = props
      let has_raw_text = is_html_raw_text_element(tag)

      buf.write_char('<')
      buf.write_string(tag)

      if ns is Some(namespace_uri) && tag == "svg" && !attrs.contains("xmlns") {
        write_attr(buf, "xmlns", namespace_uri)
      }
      for name, value in attrs {
        if name == "innerHTML" || name == "style" {
          continue
        }
        write_attr(buf, name, value)
      }
      write_styles_attr(buf, attrs, styles)
      write_property_attrs(buf, tag, attrs, props)
      if is_html_void_element(tag) {
        buf.write_char('>')
      } else {
        buf.write_char('>')
        if props.get("innerHTML") is Some(String(raw_html)) {
          buf.write_string(raw_html)
        }
        if props.get("textContent") is Some(text_content) {
          if has_raw_text {
            write_raw_variant_text(buf, text_content)
          } else {
            write_variant_text(buf, text_content)
          }
        }
        if tag == "textarea" && props.get("value") is Some(String(value)) {
          write_escaped_text(buf, value)
        } else {
          children_to_string(buf, children, has_raw_text)
        }

        buf.write_string("</")
        buf.write_string(tag)
        buf.write_char('>')
      }
    }
    Text(s) =>
      if in_raw_text_element {
        buf.write_string(s)
      } else {
        write_escaped_text(buf, s)
      }
    Frag(c) =>
      if in_raw_text_element {
        children_to_string(buf, Array(c), true)
      } else {
        buf.write_string("<!--")
        buf.write_string(FRAGMENT_START_MARKER)
        buf.write_string("-->")
        children_to_string(buf, Array(c), false)
        buf.write_string("<!--")
        buf.write_string(FRAGMENT_END_MARKER)
        buf.write_string("-->")
      }
  }
}

///|
fn children_to_string(
  buf : StringBuilder,
  children : Children[VNode],
  in_raw_text_element : Bool,
) -> Unit {
  match children {
    RawHtml(html) => buf.write_string(html)
    Array(arr) =>
      for child in arr {
        vnode_to_string(buf, child, in_raw_text_element)
      }
    Map(mp) =>
      for _, child in mp {
        vnode_to_string(buf, child, in_raw_text_element)
      }
  }
}

///|
pub fn server_side_render(render : () -> VNode) -> String {
  let vnode = render()
  let buf = StringBuilder()
  buf.write_string("<!DOCTYPE html>")
  vnode_to_string(buf, vnode, false)
  buf.to_string()
}
