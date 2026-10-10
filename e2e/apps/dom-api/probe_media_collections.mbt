///|
fn probe_media_collections() -> Unit {
  let failures : Array[String] = []
  let document = @dom.document()
  let video_element = document.create_element("video")
  let track_element = document.create_element("track")
  @dom.IsElement::set_attribute(track_element, "id", "t1")
  @dom.IsElement::set_attribute(track_element, "kind", "captions")
  @dom.IsElement::set_attribute(track_element, "label", "cap")
  @dom.IsElement::set_attribute(track_element, "src", "data:text/vtt,WEBVTT")
  @dom.IsNode::append_child(
    @dom.IsNode::as_node(video_element),
    @dom.IsNode::as_node(track_element),
  )
  if document.get_body() is Some(body) {
    @dom.IsNode::append_child(body, @dom.IsNode::as_node(video_element))
    if @dom.IsEventTarget::to_html_video_element(video_element) is Some(video) {
      let media = @dom.IsHTMLMediaElement::as_html_media_element(video)
      probe_text_track_lists(failures, media)
      probe_av_track_lists(failures, media)
      probe_time_ranges(failures, media, video_element)
    } else {
      set_result("media-collections-result", "failed: video_conversion")
    }
  } else {
    set_result("media-collections-result", "failed: missing_body")
  }
}

///|
fn probe_text_track_lists(
  failures : Array[String],
  media : @dom.HTMLMediaElement,
) -> Unit {
  let lists = @dom.IsHTMLMediaElement::get_text_tracks(media)
  record(failures, lists.length() == 1, "track_list_length")
  record(failures, lists.get(0) is Some(_), "track_list_get")
  record(failures, lists.get(9) is None, "track_list_get_out_of_range")
  record(failures, lists.get_track_by_id("t1") is Some(_), "track_list_by_id")
  record(
    failures,
    lists.get_track_by_id("zzz") is None,
    "track_list_by_id_missing",
  )
  if lists.get_track_by_id("t1") is Some(track) {
    record(failures, track.get_id() == "t1", "track_id")
    record(failures, track.get_label() == "cap", "track_label")
    record(failures, track.get_kind() == "captions", "track_kind")
  } else {
    failures.push("track_missing")
  }
  record(failures, lists.iter().count() == 1, "track_list_iter")
  let added = @dom.IsHTMLMediaElement::add_text_track(
    media,
    "subtitles",
    Some("extra"),
    Some("en"),
  )
  record(failures, added.get_kind() == "subtitles", "added_track_kind")
  record(failures, lists.length() == 2, "track_list_live_growth")
  record(failures, lists.iter().count() == 2, "track_list_live_iter")
  record(
    failures,
    same_track_list(lists, @dom.IsHTMLMediaElement::get_text_tracks(media)),
    "track_list_same_object",
  )
}

///|
fn probe_av_track_lists(
  failures : Array[String],
  media : @dom.HTMLMediaElement,
) -> Unit {
  if av_track_lists_supported(media) {
    let audio = @dom.IsHTMLMediaElement::get_audio_tracks(media)
    record(failures, audio.length() == 0, "audio_list_length")
    record(failures, audio.get(0) is None, "audio_list_get_out_of_range")
    record(
      failures,
      audio.get_track_by_id("zzz") is None,
      "audio_list_by_id_missing",
    )
    record(failures, audio.iter().count() == 0, "audio_list_iter")
    let video_tracks = @dom.IsHTMLMediaElement::get_video_tracks(media)
    record(failures, video_tracks.length() == 0, "video_list_length")
    record(failures, video_tracks.get(0) is None, "video_list_get_out_of_range")
    record(
      failures,
      video_tracks.get_track_by_id("zzz") is None,
      "video_list_by_id_missing",
    )
    record(failures, video_tracks.iter().count() == 0, "video_list_iter")
  }
}

///|
fn probe_time_ranges(
  failures : Array[String],
  media : @dom.HTMLMediaElement,
  video_element : @dom.Element,
) -> Unit {
  let buffered_before = @dom.IsHTMLMediaElement::get_buffered(media)
  record(failures, buffered_before.length() == 0, "ranges_before_empty")
  record(failures, buffered_before.start(0) is None, "ranges_before_start")
  record(failures, buffered_before.iter().count() == 0, "ranges_before_iter")
  @dom.IsEventTarget::add_event_listener(video_element, "loadedmetadata", _ => {
    let duration = @dom.IsHTMLMediaElement::get_duration(media)
    let buffered_after = @dom.IsHTMLMediaElement::get_buffered(media)
    record(failures, buffered_before.length() == 0, "ranges_snapshot")
    record(failures, buffered_after.length() == 1, "ranges_after_length")
    record(failures, buffered_after.start(0) == Some(0.0), "ranges_start")
    record(failures, buffered_after.end(0) == Some(duration), "ranges_end")
    record(failures, buffered_after.start(1) is None, "ranges_out_of_range")
    record(failures, buffered_after.end(-1) is None, "ranges_negative_index")
    let seekable = @dom.IsHTMLMediaElement::get_seekable(media)
    record(failures, seekable.length() == 1, "seekable_length")
    record(failures, seekable.start(0) == Some(0.0), "seekable_start")
    record(failures, seekable.end(0) == Some(duration), "seekable_end")
    record(
      failures,
      @dom.IsHTMLMediaElement::get_played(media).length() == 0,
      "played_empty",
    )
    let seen : Array[(Double, Double)] = []
    buffered_after.iter().each(pair => seen.push(pair))
    record(failures, seen.length() == 1, "ranges_iter_count")
    if seen.get(0) is Some(pair) {
      record(failures, pair == (0.0, duration), "ranges_iter_values")
    } else {
      failures.push("ranges_iter_missing")
    }
    set_result("media-collections-result", finish_probe(failures))
  })
  @dom.IsEventTarget::add_event_listener(video_element, "error", _ => {
    set_result("media-collections-result", "failed: media_load_error")
  })
  @dom.IsHTMLMediaElement::set_src(media, wav_url())
}

///|
extern "js" fn same_track_list(
  a : @dom.TextTrackList,
  b : @dom.TextTrackList,
) -> Bool = "(a, b) => a === b"

///|
extern "js" fn av_track_lists_supported(media : @dom.HTMLMediaElement) -> Bool =
  #| (m) => typeof m.audioTracks === 'object' && m.audioTracks !== null &&
  #|   typeof m.videoTracks === 'object' && m.videoTracks !== null

///|
extern "js" fn wav_url() -> String =
  #| () => {
  #|   const rate = 8000, count = rate / 2, bytes = 44 + count * 2;
  #|   const buffer = new ArrayBuffer(bytes), view = new DataView(buffer);
  #|   const ascii = (offset, text) => {
  #|     for (let i = 0; i < text.length; i += 1) {
  #|       view.setUint8(offset + i, text.charCodeAt(i));
  #|     }
  #|   };
  #|   ascii(0, 'RIFF'); view.setUint32(4, bytes - 8, true); ascii(8, 'WAVE');
  #|   ascii(12, 'fmt '); view.setUint32(16, 16, true);
  #|   view.setUint16(20, 1, true); view.setUint16(22, 1, true);
  #|   view.setUint32(24, rate, true); view.setUint32(28, rate * 2, true);
  #|   view.setUint16(32, 2, true); view.setUint16(34, 16, true);
  #|   ascii(36, 'data'); view.setUint32(40, count * 2, true);
  #|   return URL.createObjectURL(new Blob([buffer], { type: 'audio/wav' }));
  #| }
