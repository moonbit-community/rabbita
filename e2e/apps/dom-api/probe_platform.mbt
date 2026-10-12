///|
fn probe_platform() -> String {
  let failures : Array[String] = []
  let window = @dom.window()
  let document = @dom.document()
  record(failures, window.inner_width() > 0, "inner_width")
  record(failures, window.inner_height() > 0, "inner_height")
  record(failures, window.current_url().contains("4308"), "current_url")
  record(failures, window.origin().contains("127.0.0.1:4308"), "origin")
  let original_base_uri = document.base_uri()
  record(failures, original_base_uri == window.current_url(), "base_uri")
  if document.get_head() is Some(head) {
    let base = document.create_element("base")
    base.set_attribute("href", "/dom-base/")
    // The first base tag takes precedence over Warren's injected base tag.
    head.insert_before(
      base.as_node(),
      @js.Nullable::from_option(Some(head.get_first_child())),
    )
    record(
      failures,
      document.base_uri() == window.origin() + "/dom-base/",
      "base_uri_with_base_element",
    )
    head.remove_child(base.as_node())
    record(
      failures,
      document.base_uri() == original_base_uri,
      "base_uri_after_base_removed",
    )
  } else {
    failures.push("missing_head")
  }
  record(failures, window.get_performance().now() >= 0.0, "performance")
  record(failures, @dom.CSS::supports("display", "block"), "css_supports_true")
  record(
    failures,
    !@dom.CSS::supports("not-a-property", "not-a-value"),
    "css_supports_false",
  )
  record(
    failures,
    window.match_media("(min-width: 1px)").get_matches(),
    "match_media",
  )
  if window.get_visual_viewport() is Some(viewport) {
    record(failures, viewport.get_width() > 0.0, "viewport_width")
    record(failures, viewport.get_height() > 0.0, "viewport_height")
    record(failures, viewport.get_offset_left() >= 0.0, "viewport_left")
    record(failures, viewport.get_offset_top() >= 0.0, "viewport_top")
    record(
      failures,
      @dom.IsEventTarget::as_event_target(viewport).to_window() is None,
      "viewport_event_target",
    )
  } else {
    failures.push("visual_viewport")
  }
  if element_by_id("event-target") is Some(target) {
    @dom.IsElement::set_attribute(
      target, "style", "direction: rtl; width: 40px; height: 20px",
    )
    let computed = window.get_computed_style(target)
    record(
      failures,
      computed.get_property_value("direction") == "rtl",
      "computed_style",
    )
    let animations = @dom.IsElement::get_animations(target)
    record(failures, animations.length() == 1, "get_animations")
    if animations.get(0) is Some(animation) {
      animation.finish()
      record(
        failures,
        @dom.IsEventTarget::as_event_target(animation).to_node() is None,
        "animation_event_target",
      )
    }
  } else {
    failures.push("event_target")
  }
  let tall = document.create_element("div")
  @dom.IsElement::set_attribute(tall, "style", "height: 2400px")
  if document.get_body() is Some(body) {
    @dom.IsNode::append_child(body, @dom.IsNode::as_node(tall))
    window.scroll_to(0, 20)
    record(failures, window.scroll_y() >= 0, "scroll_to")
    window.scroll_by(0, 10)
    record(failures, window.scroll_x() >= 0, "scroll_by")
    window.scroll_to_bottom()
    record(failures, window.scroll_y() >= 0, "scroll_bottom")
    window.scroll_to_top()
    record(failures, window.scroll_y() == 0, "scroll_top")
    @dom.IsNode::remove_child(body, @dom.IsNode::as_node(tall))
  } else {
    failures.push("scroll_body")
  }
  record(
    failures,
    @dom.IsEventTarget::to_window(window.to_event_target()) is Some(_),
    "window_event_target",
  )
  ignore(window.navigator())
  record(
    failures,
    @dom.namespace_html == "http://www.w3.org/1999/xhtml",
    "html_namespace",
  )
  record(
    failures,
    @dom.namespace_svg == "http://www.w3.org/2000/svg",
    "svg_namespace",
  )
  record(
    failures,
    @dom.namespace_mathml == "http://www.w3.org/1998/Math/MathML",
    "mathml_namespace",
  )
  record(
    failures,
    @dom.DOM_KEY_LOCATION_LEFT == 1 &&
    @dom.DOM_KEY_LOCATION_RIGHT == 2 &&
    @dom.DOM_KEY_LOCATION_NUMPAD == 3,
    "keyboard_location_constants",
  )
  finish_probe(failures)
}

///|
fn probe_dialogs() -> String {
  let failures : Array[String] = []
  let window = @dom.window()
  record(failures, window.confirm("DOM confirm probe"), "confirm")
  window.alert("DOM alert probe")
  let document = @dom.document()
  let dialog_element = document.create_element("dialog")
  let popover_element = document.create_element("div")
  @dom.IsElement::set_attribute(popover_element, "popover", "auto")
  if document.get_body() is Some(body) {
    @dom.IsNode::append_child(body, @dom.IsNode::as_node(dialog_element))
    @dom.IsNode::append_child(body, @dom.IsNode::as_node(popover_element))
    if @dom.IsEventTarget::to_html_dialog_element(dialog_element)
      is Some(dialog) {
      dialog.show()
      record(failures, dialog.open(), "dialog_show")
      dialog.close(return_value=@js.Optional::from_option(Some("done")))
      record(failures, !dialog.open(), "dialog_close")
      record(failures, dialog.return_value() == "done", "dialog_return_value")
      dialog.show_modal()
      record(failures, dialog.open(), "dialog_show_modal")
      dialog.request_close(
        return_value=@js.Optional::from_option(Some("requested")),
      )
      record(failures, !dialog.open(), "dialog_request_close")
      record(
        failures,
        @dom.IsEventTarget::to_html_dialog_element(dialog) is Some(_),
        "dialog_conversion",
      )
    } else {
      failures.push("dialog_conversion")
    }
    if @dom.IsEventTarget::to_html_element(popover_element) is Some(popover) {
      record(
        failures,
        @dom.IsHtmlElement::get_popover(popover) == Some("auto"),
        "popover_property",
      )
      @dom.IsHtmlElement::show_popover(popover)
      record(
        failures,
        @dom.IsHtmlElement::toggle_popover(popover, Some(false)) == false,
        "popover_toggle_close",
      )
      record(
        failures,
        @dom.IsHtmlElement::toggle_popover(popover, Some(true)),
        "popover_toggle_open",
      )
      @dom.IsHtmlElement::hide_popover(popover)
      @dom.IsHtmlElement::set_popover(popover, Some("manual"))
      record(
        failures,
        @dom.IsHtmlElement::get_popover(popover) == Some("manual"),
        "popover_setter",
      )
    } else {
      failures.push("popover_conversion")
    }
    @dom.IsNode::remove_child(body, @dom.IsNode::as_node(dialog_element))
    @dom.IsNode::remove_child(body, @dom.IsNode::as_node(popover_element))
  } else {
    failures.push("missing_body")
  }
  finish_probe(failures)
}

///|
fn probe_media() -> String {
  let failures : Array[String] = []
  let document = @dom.document()
  let video_element = document.create_element("video")
  if document.get_body() is Some(body) {
    @dom.IsNode::append_child(body, @dom.IsNode::as_node(video_element))
    if @dom.IsEventTarget::to_html_video_element(video_element) is Some(video) {
      let media = @dom.IsHTMLMediaElement::as_html_media_element(video)
      @dom.IsHTMLMediaElement::set_autoplay(media, false)
      @dom.IsHTMLMediaElement::set_controls(media, true)
      @dom.IsHTMLMediaElement::set_cross_origin(media, Some("anonymous"))
      @dom.IsHTMLMediaElement::set_default_muted(media, true)
      @dom.IsHTMLMediaElement::set_default_playback_rate(media, 1.25)
      @dom.IsHTMLMediaElement::set_disable_remote_playback(media, true)
      @dom.IsHTMLMediaElement::set_loop(media, true)
      @dom.IsHTMLMediaElement::set_muted(media, true)
      @dom.IsHTMLMediaElement::set_playback_rate(media, 1.5)
      @dom.IsHTMLMediaElement::set_preload(media, "metadata")
      @dom.IsHTMLMediaElement::set_preserves_pitch(media, true)
      @dom.IsHTMLMediaElement::set_src(media, "")
      @dom.IsHTMLMediaElement::set_current_time(media, 0.0)
      @dom.IsHTMLMediaElement::set_playback_rate(media, 1.5)
      @dom.IsHTMLMediaElement::set_volume(media, 0.5)
      record(
        failures,
        !@dom.IsHTMLMediaElement::get_autoplay(media),
        "media_autoplay",
      )
      record(
        failures,
        @dom.IsHTMLMediaElement::get_controls(media),
        "media_controls",
      )
      record(
        failures,
        @dom.IsHTMLMediaElement::get_cross_origin(media) == Some("anonymous"),
        "media_cross_origin",
      )
      record(
        failures,
        @dom.IsHTMLMediaElement::get_default_muted(media),
        "media_default_muted",
      )
      record(
        failures,
        @dom.IsHTMLMediaElement::get_default_playback_rate(media) == 1.25,
        "media_default_playback_rate",
      )
      record(
        failures,
        @dom.IsHTMLMediaElement::get_disable_remote_playback(media),
        "media_disable_remote",
      )
      record(failures, @dom.IsHTMLMediaElement::get_loop(media), "media_loop")
      record(failures, @dom.IsHTMLMediaElement::get_muted(media), "media_muted")
      record(
        failures,
        @dom.IsHTMLMediaElement::get_playback_rate(media) == 1.5,
        "media_playback_rate",
      )
      record(
        failures,
        @dom.IsHTMLMediaElement::get_preload(media) == "metadata",
        "media_preload",
      )
      record(
        failures,
        @dom.IsHTMLMediaElement::get_preserves_pitch(media),
        "media_preserves_pitch",
      )
      record(
        failures,
        @dom.IsHTMLMediaElement::get_volume(media) == 0.5,
        "media_volume",
      )
      ignore(@dom.IsHTMLMediaElement::get_src(media))
      record(
        failures,
        @dom.IsHTMLMediaElement::get_current_time(media) == 0.0,
        "media_current_time",
      )
      @dom.IsHTMLMediaElement::set_src_object(media, None)
      record(
        failures,
        @dom.IsHTMLMediaElement::get_src_object(media) is None,
        "media_src_object",
      )
      ignore(@dom.IsHTMLMediaElement::get_audio_tracks(media))
      ignore(@dom.IsHTMLMediaElement::get_buffered(media))
      ignore(@dom.IsHTMLMediaElement::get_controls_list(media))
      ignore(@dom.IsHTMLMediaElement::get_current_src(media))
      ignore(@dom.IsHTMLMediaElement::get_duration(media))
      ignore(@dom.IsHTMLMediaElement::get_ended(media))
      ignore(@dom.IsHTMLMediaElement::get_error(media))
      ignore(@dom.IsHTMLMediaElement::get_media_keys(media))
      ignore(@dom.IsHTMLMediaElement::get_network_state(media))
      ignore(@dom.IsHTMLMediaElement::get_paused(media))
      ignore(@dom.IsHTMLMediaElement::get_played(media))
      ignore(@dom.IsHTMLMediaElement::get_ready_state(media))
      ignore(@dom.IsHTMLMediaElement::get_remote(media))
      ignore(@dom.IsHTMLMediaElement::get_seekable(media))
      ignore(@dom.IsHTMLMediaElement::get_seeking(media))
      ignore(@dom.IsHTMLMediaElement::get_sink_id(media))
      ignore(@dom.IsHTMLMediaElement::get_text_tracks(media))
      ignore(@dom.IsHTMLMediaElement::get_video_tracks(media))
      ignore(
        @dom.IsHTMLMediaElement::add_text_track(
          media,
          "captions",
          Some("English"),
          Some("en"),
        ),
      )
      ignore(@dom.IsHTMLMediaElement::can_play_type(media, "video/webm"))
      ignore(@dom.IsHTMLMediaElement::capture_stream(media))
      @dom.IsHTMLMediaElement::fast_seek(media, 0.0)
      @dom.IsHTMLMediaElement::seek_to_next_frame(media)
      @dom.IsHTMLMediaElement::pause(media)
      @dom.IsHTMLMediaElement::load(media)
      record(
        failures,
        @dom.IsEventTarget::to_html_media_element(video) is Some(_),
        "media_conversion",
      )
    } else {
      failures.push("video_conversion")
    }
    @dom.IsNode::remove_child(body, @dom.IsNode::as_node(video_element))
  } else {
    failures.push("missing_body")
  }
  finish_probe(failures)
}
