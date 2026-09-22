///|
#cfg(target="js")
#external
type HTMLVideoElement

///|
#cfg(target="js")
pub impl IsEventTarget for HTMLVideoElement

///|
#cfg(target="js")
pub extend HTMLVideoElement with IsEventTarget::{
  add_event_listener,
  add_event_listener_with_options,
  as_event_target,
  dispatch_event,
  remove_event_listener,
  remove_event_listener_with_options,
  to_clipboard,
  to_comment,
  to_document,
  to_document_fragment,
  to_element,
  to_html_canvas_element,
  to_html_dialog_element,
  to_html_element,
  to_html_image_element,
  to_html_input_element,
  to_html_media_element,
  to_html_select_element,
  to_html_video_element,
  to_node,
  to_svg_element,
  to_svg_graphics_element,
  to_svg_image_element,
  to_text,
  to_window,
}

///|
#cfg(target="js")
pub impl IsNode for HTMLVideoElement

///|
#cfg(target="js")
pub extend HTMLVideoElement with IsNode::{
  append_child,
  as_node,
  contains,
  get_child,
  get_child_count,
  get_first_child,
  get_is_connected,
  get_last_child,
  get_next_sibling,
  get_node_name,
  get_node_type,
  get_node_value,
  get_parent_element,
  get_parent_node,
  get_previous_sibling,
  insert_before,
  is_same_node,
  remove_child,
  replace_child,
  set_node_value,
}

///|
#cfg(target="js")
pub impl IsElement for HTMLVideoElement

///|
#cfg(target="js")
pub extend HTMLVideoElement with IsElement::{
  as_element,
  closest,
  get_animations,
  get_attribute,
  get_bounding_client_rect,
  get_children,
  get_client_height,
  get_client_left,
  get_client_rects,
  get_client_top,
  get_client_width,
  get_property,
  get_scroll_height,
  get_scroll_left,
  get_scroll_top,
  get_scroll_width,
  has_attribute,
  has_pointer_capture,
  matches,
  query_selector,
  query_selector_all,
  release_pointer_capture,
  remove_attribute,
  remove_property,
  scroll_into_view,
  scroll_into_view_with_options,
  set_attribute,
  set_inner_html,
  set_pointer_capture,
  set_property,
  set_scroll_left,
  set_scroll_top,
}

///|
#cfg(target="js")
pub impl IsHtmlElement for HTMLVideoElement

///|
#cfg(target="js")
pub extend HTMLVideoElement with IsHtmlElement::{
  as_html_element,
  attach_internals,
  blur,
  click,
  focus,
  focus_with_options,
  get_access_key,
  get_access_key_label,
  get_anchor_element,
  get_attribute_style_map,
  get_auto_capitalize,
  get_auto_correct,
  get_auto_focus,
  get_content_editable,
  get_dataset,
  get_dir,
  get_draggable,
  get_edit_context,
  get_enter_key_hint,
  get_hidden,
  get_inert,
  get_inner_text,
  get_input_mode,
  get_is_content_editable,
  get_lang,
  get_nonce,
  get_offset_height,
  get_offset_left,
  get_offset_parent,
  get_offset_top,
  get_offset_width,
  get_outer_text,
  get_popover,
  get_spellcheck,
  get_style,
  get_tab_index,
  get_title,
  get_translate,
  get_virtual_keyboard_policy,
  get_writing_suggestions,
  hide_popover,
  set_access_key,
  set_auto_capitalize,
  set_auto_correct,
  set_auto_focus,
  set_content_editable,
  set_dir,
  set_draggable,
  set_edit_context,
  set_enter_key_hint,
  set_hidden,
  set_inert,
  set_inner_text,
  set_input_mode,
  set_lang,
  set_nonce,
  set_outer_text,
  set_popover,
  set_spellcheck,
  set_style_declaration,
  set_tab_index,
  set_title,
  set_translate,
  set_virtual_keyboard_policy,
  set_writing_suggestions,
  show_popover,
  toggle_popover,
}

///|
#cfg(target="js")
pub impl IsHTMLMediaElement for HTMLVideoElement

///|
#cfg(target="js")
pub extend HTMLVideoElement with IsHTMLMediaElement::{
  add_text_track,
  as_html_media_element,
  can_play_type,
  capture_stream,
  fast_seek,
  get_audio_tracks,
  get_autoplay,
  get_buffered,
  get_controls,
  get_controls_list,
  get_cross_origin,
  get_current_src,
  get_current_time,
  get_default_muted,
  get_default_playback_rate,
  get_disable_remote_playback,
  get_duration,
  get_ended,
  get_error,
  get_loop,
  get_media_keys,
  get_muted,
  get_network_state,
  get_paused,
  get_playback_rate,
  get_played,
  get_preload,
  get_preserves_pitch,
  get_ready_state,
  get_remote,
  get_seekable,
  get_seeking,
  get_sink_id,
  get_src,
  get_src_object,
  get_text_tracks,
  get_video_tracks,
  get_volume,
  load,
  pause,
  seek_to_next_frame,
  set_autoplay,
  set_controls,
  set_cross_origin,
  set_current_time,
  set_default_muted,
  set_default_playback_rate,
  set_disable_remote_playback,
  set_loop,
  set_muted,
  set_playback_rate,
  set_preload,
  set_preserves_pitch,
  set_src,
  set_src_object,
  set_volume,
}

///|
#cfg(target="js")
pub impl @js.Cast for HTMLVideoElement with fn into(value) {
  value |> ffi_to_html_video_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub extend HTMLVideoElement with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for HTMLVideoElement with fn from(value) {
  value |> js_identity
}
