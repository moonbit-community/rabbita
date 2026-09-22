///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement
#cfg(target="js")
type HTMLMediaElement

///|
#cfg(target="js")
pub impl IsEventTarget for HTMLMediaElement

///|
#cfg(target="js")
pub extend HTMLMediaElement with IsEventTarget::{
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
pub impl IsNode for HTMLMediaElement

///|
#cfg(target="js")
pub extend HTMLMediaElement with IsNode::{
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
pub impl IsElement for HTMLMediaElement

///|
#cfg(target="js")
pub extend HTMLMediaElement with IsElement::{
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
pub impl IsHtmlElement for HTMLMediaElement

///|
#cfg(target="js")
pub extend HTMLMediaElement with IsHtmlElement::{
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
pub impl IsHTMLMediaElement for HTMLMediaElement

///|
#cfg(target="js")
pub extend HTMLMediaElement with IsHTMLMediaElement::{
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
type AudioTrackList

///|
#cfg(target="js")
type TimeRanges

///|
#cfg(target="js")
type DOMTokenList

///|
#cfg(target="js")
type MediaError

///|
#cfg(target="js")
type MediaKeys

///|
#cfg(target="js")
type RemotePlayback

///|
#cfg(target="js")
type TextTrackList

///|
#cfg(target="js")
type VideoTrackList

///|
#cfg(target="js")
type TextTrack

///|
#cfg(target="js")
type MediaStream

///|
#cfg(target="js")
pub trait IsHTMLMediaElement: IsHtmlElement {
  fn as_html_media_element(Self) -> HTMLMediaElement = _
  fn get_audio_tracks(Self) -> AudioTrackList = _
  fn get_autoplay(Self) -> Bool = _
  fn set_autoplay(Self, Bool) -> Unit = _
  fn get_buffered(Self) -> TimeRanges = _
  fn get_controls(Self) -> Bool = _
  fn set_controls(Self, Bool) -> Unit = _
  fn get_controls_list(Self) -> DOMTokenList = _
  fn get_cross_origin(Self) -> String? = _
  fn set_cross_origin(Self, String?) -> Unit = _
  fn get_current_src(Self) -> String = _
  fn get_current_time(Self) -> Double = _
  fn set_current_time(Self, Double) -> Unit = _
  fn get_default_muted(Self) -> Bool = _
  fn set_default_muted(Self, Bool) -> Unit = _
  fn get_default_playback_rate(Self) -> Double = _
  fn set_default_playback_rate(Self, Double) -> Unit = _
  fn get_disable_remote_playback(Self) -> Bool = _
  fn set_disable_remote_playback(Self, Bool) -> Unit = _
  fn get_duration(Self) -> Double = _
  fn get_ended(Self) -> Bool = _
  fn get_error(Self) -> MediaError? = _
  fn get_loop(Self) -> Bool = _
  fn set_loop(Self, Bool) -> Unit = _
  fn get_media_keys(Self) -> MediaKeys? = _
  fn get_muted(Self) -> Bool = _
  fn set_muted(Self, Bool) -> Unit = _
  fn get_network_state(Self) -> Int = _
  fn get_paused(Self) -> Bool = _
  fn get_playback_rate(Self) -> Double = _
  fn set_playback_rate(Self, Double) -> Unit = _
  fn get_played(Self) -> TimeRanges = _
  fn get_preload(Self) -> String = _
  fn set_preload(Self, String) -> Unit = _
  fn get_preserves_pitch(Self) -> Bool = _
  fn set_preserves_pitch(Self, Bool) -> Unit = _
  fn get_ready_state(Self) -> Int = _
  fn get_remote(Self) -> RemotePlayback = _
  fn get_seekable(Self) -> TimeRanges = _
  fn get_seeking(Self) -> Bool = _
  fn get_sink_id(Self) -> String = _
  fn get_src(Self) -> String = _
  fn set_src(Self, String) -> Unit = _
  fn get_src_object(Self) -> @js.Value? = _
  fn set_src_object(Self, @js.Value?) -> Unit = _
  fn get_text_tracks(Self) -> TextTrackList = _
  fn get_video_tracks(Self) -> VideoTrackList = _
  fn get_volume(Self) -> Double = _
  fn set_volume(Self, Double) -> Unit = _
  // Methods
  fn add_text_track(Self, String, String?, String?) -> TextTrack = _
  fn capture_stream(Self) -> MediaStream = _
  fn can_play_type(Self, String) -> String = _
  fn fast_seek(Self, Double) -> Unit = _
  fn load(Self) -> Unit = _
  fn pause(Self) -> Unit = _
  // TODO: play() returns Promise<void>
  // play(Self) -> @js.Promise[Unit] = _
  fn seek_to_next_frame(Self) -> Unit = _
  // TODO: setMediaKeys() returns Promise<void>
  // set_media_keys(Self, MediaKeys?) -> @js.Promise[Unit] = _
  // TODO: setSinkId() returns Promise<void>  
  // set_sink_id(Self, String) -> @js.Promise[Unit] = _
}

///|
#cfg(target="js")
pub impl @js.Cast for HTMLMediaElement with fn into(value) {
  value |> ffi_to_html_media_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub extend HTMLMediaElement with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for HTMLMediaElement with fn from(value) {
  value |> js_identity
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn as_html_media_element(s) {
  s |> js_identity
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_audio_tracks(s) {
  ffi_html_media_element_get_audio_tracks(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_autoplay(s) {
  ffi_html_media_element_get_autoplay(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn set_autoplay(s, value) {
  ffi_html_media_element_set_autoplay(s.as_html_media_element(), value)
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_buffered(s) {
  ffi_html_media_element_get_buffered(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_controls(s) {
  ffi_html_media_element_get_controls(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn set_controls(s, value) {
  ffi_html_media_element_set_controls(s.as_html_media_element(), value)
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_controls_list(s) {
  ffi_html_media_element_get_controls_list(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_cross_origin(s) {
  ffi_html_media_element_get_cross_origin(s.as_html_media_element()).to_option()
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn set_cross_origin(s, value) {
  ffi_html_media_element_set_cross_origin(s.as_html_media_element(), value)
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_current_src(s) {
  ffi_html_media_element_get_current_src(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_current_time(s) {
  ffi_html_media_element_get_current_time(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn set_current_time(s, value) {
  ffi_html_media_element_set_current_time(s.as_html_media_element(), value)
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_default_muted(s) {
  ffi_html_media_element_get_default_muted(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn set_default_muted(s, value) {
  ffi_html_media_element_set_default_muted(s.as_html_media_element(), value)
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_default_playback_rate(s) {
  ffi_html_media_element_get_default_playback_rate(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn set_default_playback_rate(s, value) {
  ffi_html_media_element_set_default_playback_rate(
    s.as_html_media_element(),
    value,
  )
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_disable_remote_playback(s) {
  ffi_html_media_element_get_disable_remote_playback(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn set_disable_remote_playback(s, value) {
  ffi_html_media_element_set_disable_remote_playback(
    s.as_html_media_element(),
    value,
  )
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_duration(s) {
  ffi_html_media_element_get_duration(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_ended(s) {
  ffi_html_media_element_get_ended(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_error(s) {
  ffi_html_media_element_get_error(s.as_html_media_element()).to_option()
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_loop(s) {
  ffi_html_media_element_get_loop(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn set_loop(s, value) {
  ffi_html_media_element_set_loop(s.as_html_media_element(), value)
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_media_keys(s) {
  ffi_html_media_element_get_media_keys(s.as_html_media_element()).to_option()
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_muted(s) {
  ffi_html_media_element_get_muted(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn set_muted(s, value) {
  ffi_html_media_element_set_muted(s.as_html_media_element(), value)
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_network_state(s) {
  ffi_html_media_element_get_network_state(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_paused(s) {
  ffi_html_media_element_get_paused(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_playback_rate(s) {
  ffi_html_media_element_get_playback_rate(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn set_playback_rate(s, value) {
  ffi_html_media_element_set_playback_rate(s.as_html_media_element(), value)
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_played(s) {
  ffi_html_media_element_get_played(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_preload(s) {
  ffi_html_media_element_get_preload(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn set_preload(s, value) {
  ffi_html_media_element_set_preload(s.as_html_media_element(), value)
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_preserves_pitch(s) {
  ffi_html_media_element_get_preserves_pitch(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn set_preserves_pitch(s, value) {
  ffi_html_media_element_set_preserves_pitch(s.as_html_media_element(), value)
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_ready_state(s) {
  ffi_html_media_element_get_ready_state(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_remote(s) {
  ffi_html_media_element_get_remote(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_seekable(s) {
  ffi_html_media_element_get_seekable(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_seeking(s) {
  ffi_html_media_element_get_seeking(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_sink_id(s) {
  ffi_html_media_element_get_sink_id(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_src(s) {
  ffi_html_media_element_get_src(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn set_src(s, value) {
  ffi_html_media_element_set_src(s.as_html_media_element(), value)
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_src_object(s) {
  ffi_html_media_element_get_src_object(s.as_html_media_element()).to_option()
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn set_src_object(s, value) {
  ffi_html_media_element_set_src_object(
    s.as_html_media_element(),
    @js.Nullable::from_option(value),
  )
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_text_tracks(s) {
  ffi_html_media_element_get_text_tracks(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_video_tracks(s) {
  ffi_html_media_element_get_video_tracks(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn get_volume(s) {
  ffi_html_media_element_get_volume(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn set_volume(s, value) {
  ffi_html_media_element_set_volume(s.as_html_media_element(), value)
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn add_text_track(s, kind, label, language) {
  ffi_html_media_element_add_text_track(
    s.as_html_media_element(),
    kind,
    label,
    language,
  )
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn capture_stream(s) {
  ffi_html_media_element_capture_stream(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn can_play_type(s, mime_type) {
  ffi_html_media_element_can_play_type(s.as_html_media_element(), mime_type)
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn fast_seek(s, time) {
  ffi_html_media_element_fast_seek(s.as_html_media_element(), time)
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn load(s) {
  ffi_html_media_element_load(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn pause(s) {
  ffi_html_media_element_pause(s.as_html_media_element())
}

///|
#cfg(target="js")
impl IsHTMLMediaElement with fn seek_to_next_frame(s) {
  ffi_html_media_element_seek_to_next_frame(s.as_html_media_element())
}

///|
#cfg(target="js")
extern "js" fn ffi_to_html_media_element(
  x : @js.Value,
) -> @js.Nullable[HTMLMediaElement] = "(x) => x instanceof HTMLMediaElement ? x : null"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_audio_tracks(
  s : HTMLMediaElement,
) -> AudioTrackList = "(s) => s.audioTracks"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_autoplay(
  s : HTMLMediaElement,
) -> Bool = "(s) => s.autoplay"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_set_autoplay(
  s : HTMLMediaElement,
  value : Bool,
) -> Unit = "(s, value) => s.autoplay = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_buffered(
  s : HTMLMediaElement,
) -> TimeRanges = "(s) => s.buffered"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_controls(
  s : HTMLMediaElement,
) -> Bool = "(s) => s.controls"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_set_controls(
  s : HTMLMediaElement,
  value : Bool,
) -> Unit = "(s, value) => s.controls = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_controls_list(
  s : HTMLMediaElement,
) -> DOMTokenList = "(s) => s.controlsList"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_cross_origin(
  s : HTMLMediaElement,
) -> @js.Nullable[String] = "(s) => s.crossOrigin"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_set_cross_origin(
  s : HTMLMediaElement,
  value : String?,
) -> Unit = "(s, value) => s.crossOrigin = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_current_src(
  s : HTMLMediaElement,
) -> String = "(s) => s.currentSrc"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_current_time(
  s : HTMLMediaElement,
) -> Double = "(s) => s.currentTime"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_set_current_time(
  s : HTMLMediaElement,
  value : Double,
) -> Unit = "(s, value) => s.currentTime = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_default_muted(
  s : HTMLMediaElement,
) -> Bool = "(s) => s.defaultMuted"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_set_default_muted(
  s : HTMLMediaElement,
  value : Bool,
) -> Unit = "(s, value) => s.defaultMuted = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_default_playback_rate(
  s : HTMLMediaElement,
) -> Double = "(s) => s.defaultPlaybackRate"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_set_default_playback_rate(
  s : HTMLMediaElement,
  value : Double,
) -> Unit = "(s, value) => s.defaultPlaybackRate = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_disable_remote_playback(
  s : HTMLMediaElement,
) -> Bool = "(s) => s.disableRemotePlayback"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_set_disable_remote_playback(
  s : HTMLMediaElement,
  value : Bool,
) -> Unit = "(s, value) => s.disableRemotePlayback = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_duration(
  s : HTMLMediaElement,
) -> Double = "(s) => s.duration"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_ended(s : HTMLMediaElement) -> Bool = "(s) => s.ended"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_error(
  s : HTMLMediaElement,
) -> @js.Nullable[MediaError] = "(s) => s.error"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_loop(s : HTMLMediaElement) -> Bool = "(s) => s.loop"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_set_loop(
  s : HTMLMediaElement,
  value : Bool,
) -> Unit = "(s, value) => s.loop = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_media_keys(
  s : HTMLMediaElement,
) -> @js.Nullable[MediaKeys] = "(s) => s.mediaKeys"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_muted(s : HTMLMediaElement) -> Bool = "(s) => s.muted"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_set_muted(
  s : HTMLMediaElement,
  value : Bool,
) -> Unit = "(s, value) => s.muted = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_network_state(
  s : HTMLMediaElement,
) -> Int = "(s) => s.networkState"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_paused(s : HTMLMediaElement) -> Bool = "(s) => s.paused"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_playback_rate(
  s : HTMLMediaElement,
) -> Double = "(s) => s.playbackRate"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_set_playback_rate(
  s : HTMLMediaElement,
  value : Double,
) -> Unit = "(s, value) => s.playbackRate = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_played(
  s : HTMLMediaElement,
) -> TimeRanges = "(s) => s.played"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_preload(
  s : HTMLMediaElement,
) -> String = "(s) => s.preload"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_set_preload(
  s : HTMLMediaElement,
  value : String,
) -> Unit = "(s, value) => s.preload = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_preserves_pitch(
  s : HTMLMediaElement,
) -> Bool = "(s) => s.preservesPitch"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_set_preserves_pitch(
  s : HTMLMediaElement,
  value : Bool,
) -> Unit = "(s, value) => s.preservesPitch = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_ready_state(
  s : HTMLMediaElement,
) -> Int = "(s) => s.readyState"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_remote(
  s : HTMLMediaElement,
) -> RemotePlayback = "(s) => s.remote"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_seekable(
  s : HTMLMediaElement,
) -> TimeRanges = "(s) => s.seekable"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_seeking(s : HTMLMediaElement) -> Bool = "(s) => s.seeking"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_sink_id(
  s : HTMLMediaElement,
) -> String = "(s) => s.sinkId"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_src(s : HTMLMediaElement) -> String = "(s) => s.src"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_set_src(
  s : HTMLMediaElement,
  value : String,
) -> Unit = "(s, value) => s.src = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_src_object(
  s : HTMLMediaElement,
) -> @js.Nullable[@js.Value] = "(s) => s.srcObject"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_set_src_object(
  s : HTMLMediaElement,
  value : @js.Nullable[@js.Value],
) -> Unit = "(s, value) => s.srcObject = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_text_tracks(
  s : HTMLMediaElement,
) -> TextTrackList = "(s) => s.textTracks"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_video_tracks(
  s : HTMLMediaElement,
) -> VideoTrackList = "(s) => s.videoTracks"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_get_volume(
  s : HTMLMediaElement,
) -> Double = "(s) => s.volume"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_set_volume(
  s : HTMLMediaElement,
  value : Double,
) -> Unit = "(s, value) => s.volume = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_add_text_track(
  s : HTMLMediaElement,
  kind : String,
  label : String?,
  language : String?,
) -> TextTrack = "(s, kind, label, language) => s.addTextTrack(kind, label, language)"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_capture_stream(
  s : HTMLMediaElement,
) -> MediaStream = "(s) => s.captureStream()"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_can_play_type(
  s : HTMLMediaElement,
  mime_type : String,
) -> String = "(s, mimeType) => s.canPlayType(mimeType)"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_fast_seek(
  s : HTMLMediaElement,
  time : Double,
) -> Unit = "(s, time) => s.fastSeek?.(time)"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_load(s : HTMLMediaElement) -> Unit = "(s) => s.load()"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_pause(s : HTMLMediaElement) -> Unit = "(s) => s.pause()"

///|
#cfg(target="js")
extern "js" fn ffi_html_media_element_seek_to_next_frame(
  s : HTMLMediaElement,
) -> Unit = "(s) => s.seekToNextFrame?.()"
