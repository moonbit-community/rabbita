///|
fn push_style(style : Array[String], attrs : Attrs) -> Unit {
  if style.length() > 0 {
    ignore(attrs.attribute("style", style.join(";")))
  }
}

///|
fn push_id(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("id", v))
  }
}

///|
fn push_class(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("class", v))
  }
}

///|
fn push_click(value : Cmd?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.on_click(_ => v))
  }
}

///|
#cfg(target="js")
fn mouse_from_dom(event : @dom.MouseEvent) -> Mouse {
  Mouse::new(
    screen={ x: event.get_screen_x(), y: event.get_screen_y(), },
    offset={ x: event.get_offset_x(), y: event.get_offset_y(), },
    client={ x: event.get_client_x(), y: event.get_client_y(), },
  )
}

///|
#cfg(target="js")
fn keyboard_from_dom(event : @dom.KeyboardEvent) -> Keyboard {
  Keyboard::new(
    key=event.key(),
    code=event.code(),
    alt_key=event.alt_key(),
    ctrl_key=event.ctrl_key(),
    shift_key=event.shift_key(),
    meta_key=event.meta_key(),
    is_composing=event.is_composing(),
    repeat=event.repeat(),
    location=event.location(),
  )
}

///|
#cfg(target="js")
fn scroll_from_dom(element : @dom.Element) -> Scroll {
  Scroll::new(
    offset={ x: element.get_scroll_left(), y: element.get_scroll_top(), },
    width=element.get_scroll_width(),
    height=element.get_scroll_height(),
  )
}

///|
#cfg(target="js")
fn push_mousedown(value : @cmd.Emit[Mouse]?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.on_mousedown(event => v(mouse_from_dom(event))))
  }
}

///|
#cfg(not(target="js"))
fn push_mousedown(value : @cmd.Emit[Mouse]?, attrs : Attrs) -> Unit {
  ignore((value, attrs))
}

///|
#cfg(target="js")
fn push_mouseup(value : @cmd.Emit[Mouse]?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.on_mouseup(event => v(mouse_from_dom(event))))
  }
}

///|
#cfg(not(target="js"))
fn push_mouseup(value : @cmd.Emit[Mouse]?, attrs : Attrs) -> Unit {
  ignore((value, attrs))
}

///|
#cfg(target="js")
fn push_scroll(value : @cmd.Emit[Scroll]?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(
      attrs.on_scroll(event => {
        let element = event.target().to_element().unwrap()
        v(scroll_from_dom(element))
      }),
    )
  }
}

///|
#cfg(not(target="js"))
fn push_scroll(value : @cmd.Emit[Scroll]?, attrs : Attrs) -> Unit {
  ignore((value, attrs))
}

///|
#cfg(target="js")
fn push_keydown(value : @cmd.Emit[Keyboard]?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.on_keydown(event => v(keyboard_from_dom(event))))
  }
}

///|
#cfg(not(target="js"))
fn push_keydown(value : @cmd.Emit[Keyboard]?, attrs : Attrs) -> Unit {
  ignore((value, attrs))
}

///|
#cfg(target="js")
fn push_keyup(value : @cmd.Emit[Keyboard]?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.on_keyup(event => v(keyboard_from_dom(event))))
  }
}

///|
#cfg(not(target="js"))
fn push_keyup(value : @cmd.Emit[Keyboard]?, attrs : Attrs) -> Unit {
  ignore((value, attrs))
}

///|
#cfg(target="js")
fn push_submit(value : Cmd?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(
      attrs.handler("submit", (event, scheduler) => {
        event.prevent_default()
        scheduler.add(v)
      }),
    )
  }
}

///|
#cfg(not(target="js"))
fn push_submit(value : Cmd?, attrs : Attrs) -> Unit {
  ignore((value, attrs))
}

///|
fn push_open(value : Bool?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.property("open", Boolean(v)))
  }
}

///|
fn push_closedby(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.closedby(v))
  }
}

///|
fn push_datetime(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("datetime", v))
  }
}

///|
fn push_reversed(value : Bool?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("reversed", v.to_string()))
  }
}

///|
fn push_start(value : Int?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("start", v.to_string()))
  }
}

///|
fn push_value_attr_int(value : Int?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("value", v.to_string()))
  }
}

///|
fn push_value_attr_string(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("value", v))
  }
}

///|
fn push_value_prop_string(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.property("value", String(v)))
  }
}

///|
fn push_src(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("src", v))
  }
}

///|
fn push_alt(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("alt", v))
  }
}

///|
fn push_title(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("title", v))
  }
}

///|
fn push_width(value : Int?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("width", v.to_string()))
  }
}

///|
fn push_height(value : Int?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("height", v.to_string()))
  }
}

///|
fn push_action(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("action", v))
  }
}

///|
fn push_name(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("name", v))
  }
}

///|
fn push_for(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("for", v))
  }
}

///|
fn push_disabled(value : Bool?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.property("disabled", Boolean(v)))
  }
}

///|
fn push_label(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("label", v))
  }
}

///|
fn push_rows(value : Int?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("rows", v.to_string()))
  }
}

///|
fn push_cols(value : Int?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("cols", v.to_string()))
  }
}

///|
fn push_placeholder(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("placeholder", v))
  }
}

///|
fn push_readonly(value : Bool?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.property("readonly", Boolean(v)))
  }
}

///|
fn push_checked(value : Bool?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.property("checked", Boolean(v)))
  }
}

///|
fn push_multiple(value : Bool?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.property("multiple", Boolean(v)))
  }
}

///|
fn push_accept(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("accept", v))
  }
}

///|
fn push_max(value : Int?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("max", v.to_string()))
  }
}

///|
fn push_min(value : Int?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("min", v.to_string()))
  }
}

///|
fn push_step(value : Int?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("step", v.to_string()))
  }
}

///|
fn push_maxlength(value : Int?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("maxlength", v.to_string()))
  }
}

///|
fn push_minlength(value : Int?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("minlength", v.to_string()))
  }
}

///|
fn push_pattern(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("pattern", v))
  }
}

///|
fn push_size(value : Int?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("size", v.to_string()))
  }
}

///|
#cfg(target="js")
fn form_event_value(event : @dom.Event) -> String {
  let target = match event.current_target().to_option() {
    Some(target) => target
    None => event.target()
  }
  if target.to_html_input_element() is Some(input) {
    input.value()
  } else if target.to_html_select_element() is Some(select) {
    select.value()
  } else if target.to_element() is Some(element) {
    match element.get_property("value").to_option() {
      Some(value) => value
      None => panic()
    }
  } else {
    panic()
  }
}

///|
#cfg(target="js")
fn push_change(value : @cmd.Emit[String]?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(
      attrs.handler("change", (event, scheduler) => {
        scheduler.add(v(form_event_value(event)))
      }),
    )
  }
}

///|
#cfg(not(target="js"))
fn push_change(value : @cmd.Emit[String]?, attrs : Attrs) -> Unit {
  ignore((value, attrs))
}

///|
#cfg(target="js")
fn push_input(value : @cmd.Emit[String]?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(
      attrs.handler("input", (event, scheduler) => {
        scheduler.add(v(form_event_value(event)))
      }),
    )
  }
}

///|
#cfg(not(target="js"))
fn push_input(value : @cmd.Emit[String]?, attrs : Attrs) -> Unit {
  ignore((value, attrs))
}

///|
fn push_span(value : Int?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("span", v.to_string()))
  }
}

///|
fn push_colspan(value : Int?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("colspan", v.to_string()))
  }
}

///|
fn push_rowspan(value : Int?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("rowspan", v.to_string()))
  }
}

///|
fn push_headers(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("headers", v))
  }
}

///|
fn push_abbr(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("abbr", v))
  }
}

///|
fn push_scope(value : Scope?, attrs : Attrs) -> Unit {
  if value is Some(scope) {
    let s = match scope {
      Row => "row"
      Col => "col"
      RowGroup => "rowgroup"
      ColGroup => "colgroup"
    }
    ignore(attrs.attribute("scope", s))
  }
}

///|
#cfg(target="js")
fn push_close(value : @cmd.Emit[String]?, attrs : Attrs) -> Unit {
  if value is Some(close) {
    ignore(
      attrs.handler("close", (event, scheduler) => {
        let html_element = event.target().to_html_dialog_element().unwrap()
        scheduler.add(close(html_element.return_value()))
      }),
    )
  }
}

///|
#cfg(not(target="js"))
fn push_close(value : @cmd.Emit[String]?, attrs : Attrs) -> Unit {
  ignore((value, attrs))
}

///|
#cfg(target="js")
fn push_cancel(value : Cmd?, attrs : Attrs) -> Unit {
  if value is Some(cancel) {
    ignore(
      attrs.handler("cancel", (event, scheduler) => {
        event.prevent_default()
        scheduler.add(cancel)
      }),
    )
  }
}

///|
#cfg(not(target="js"))
fn push_cancel(value : Cmd?, attrs : Attrs) -> Unit {
  ignore((value, attrs))
}

///|
fn push_low(value : Int?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("low", v.to_string()))
  }
}

///|
fn push_high(value : Int?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("high", v.to_string()))
  }
}

///|
fn push_optimum(value : Int?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("optimum", v.to_string()))
  }
}

///|
fn push_lang(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("lang", v))
  }
}

///|
fn push_dir(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("dir", v))
  }
}

///|
fn push_hidden(value : Bool?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.property("hidden", Boolean(v)))
  }
}

///|
fn push_rel(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("rel", v))
  }
}

///|
fn push_href(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("href", v))
  }
}

///|
fn push_target(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("target", v))
  }
}

///|
fn push_download(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("download", v))
  }
}

///|
fn push_media(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("media", v))
  }
}

///|
fn push_sizes(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("sizes", v))
  }
}

///|
fn push_charset(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("charset", v))
  }
}

///|
fn push_content(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("content", v))
  }
}

///|
fn push_http_equiv(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("http-equiv", v))
  }
}

///|
fn push_type(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("type", v))
  }
}

///|
fn push_async(value : Bool?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.property("async", Boolean(v)))
  }
}

///|
fn push_defer(value : Bool?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.property("defer", Boolean(v)))
  }
}

///|
fn push_required(value : Bool?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.property("required", Boolean(v)))
  }
}

///|
fn push_autofocus(value : Bool?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.property("autofocus", Boolean(v)))
  }
}

///|
fn push_list(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("list", v))
  }
}

///|
fn push_inputmode(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("inputmode", v))
  }
}

///|
fn push_wrap(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("wrap", v))
  }
}

///|
fn push_srcset(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("srcset", v))
  }
}

///|
fn push_loading(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("loading", v))
  }
}

///|
fn push_decoding(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("decoding", v))
  }
}

///|
fn push_controls(value : Bool?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.property("controls", Boolean(v)))
  }
}

///|
fn push_autoplay(value : Bool?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.property("autoplay", Boolean(v)))
  }
}

///|
fn push_loop(value : Bool?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.property("loop", Boolean(v)))
  }
}

///|
fn push_muted(value : Bool?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.property("muted", Boolean(v)))
  }
}

///|
fn push_preload(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("preload", v))
  }
}

///|
fn push_poster(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("poster", v))
  }
}

///|
fn push_allow(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("allow", v))
  }
}

///|
fn push_sandbox(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("sandbox", v))
  }
}

///|
fn push_allowfullscreen(value : Bool?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.property("allowfullscreen", Boolean(v)))
  }
}

///|
fn push_coords(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("coords", v))
  }
}

///|
fn push_cite(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("cite", v))
  }
}

///|
fn push_shape(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("shape", v))
  }
}

///|
fn push_kind(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("kind", v))
  }
}

///|
fn push_srclang(value : String?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.attribute("srclang", v))
  }
}

///|
fn push_default(value : Bool?, attrs : Attrs) -> Unit {
  if value is Some(v) {
    ignore(attrs.property("default", Boolean(v)))
  }
}
