///|
/// https://html.spec.whatwg.org/multipage/media.html#audiotracklist
///
/// A live, `[SameObject]` collection of the media element's audio tracks: the
/// list object stays identical while its contents update as tracks are added or
/// removed. Not every engine exposes `audioTracks` (Chromium does not).
#cfg(target="js")
type AudioTrackList

///|
/// A track inside an `AudioTrackList`.
#cfg(target="js")
type AudioTrack

///|
/// https://html.spec.whatwg.org/multipage/media.html#videotracklist
///
/// A live, `[SameObject]` collection of the media element's video tracks, with
/// the same live semantics as `AudioTrackList`. Not every engine exposes
/// `videoTracks` (Chromium does not).
#cfg(target="js")
type VideoTrackList

///|
/// A track inside a `VideoTrackList`.
#cfg(target="js")
type VideoTrack

///|
/// https://html.spec.whatwg.org/multipage/media.html#texttracklist
///
/// A live, `[SameObject]` collection of the media element's text tracks: the
/// list object stays identical while its contents update as tracks are added or
/// removed.
#cfg(target="js")
type TextTrackList

///|
/// https://html.spec.whatwg.org/multipage/media.html#texttrack
#cfg(target="js")
type TextTrack

///|
/// The number of tracks currently in this live collection.
#cfg(target="js")
pub extern "js" fn AudioTrackList::length(self : Self) -> Int = "(l) => l.length"

///|
/// Returns the track at `index`, or `None` when the index is out of range.
#cfg(target="js")
#alias("_[_]")
pub fn AudioTrackList::get(self : Self, index : Int) -> AudioTrack? {
  audio_track_list_get_ffi(self, index).to_option()
}

///|
/// Returns the track whose `id` is `id`, or `None` when no track matches.
#cfg(target="js")
pub fn AudioTrackList::get_track_by_id(self : Self, id : String) -> AudioTrack? {
  audio_track_list_get_track_by_id_ffi(self, id).to_option()
}

///|
/// Iterates the current tracks without materializing an array. The collection
/// is live: tracks added or removed while iterating affect later steps.
#cfg(target="js")
pub fn AudioTrackList::iter(self : Self) -> Iter[AudioTrack] {
  let mut index = 0
  Iter::new(fn() {
    let item = self.get(index)
    index += 1
    item
  })
}

///|
#cfg(target="js")
extern "js" fn audio_track_list_get_ffi(
  list : AudioTrackList,
  index : Int,
) -> @js.Nullable[AudioTrack] = "(l, i) => l[i] ?? null"

///|
#cfg(target="js")
extern "js" fn audio_track_list_get_track_by_id_ffi(
  list : AudioTrackList,
  id : String,
) -> @js.Nullable[AudioTrack] = "(l, id) => l.getTrackById(id)"

///|
/// The identifier of the track. Tracks created through `add_text_track` have an
/// empty identifier; in-band and `<track>`-element tracks carry their own.
#cfg(target="js")
pub extern "js" fn AudioTrack::get_id(self : Self) -> String = "(t) => t.id"

///|
/// The human-readable label of the track.
#cfg(target="js")
pub extern "js" fn AudioTrack::get_label(self : Self) -> String = "(t) => t.label"

///|
/// The track category, such as `"alternative"` or `"main"`.
#cfg(target="js")
pub extern "js" fn AudioTrack::get_kind(self : Self) -> String = "(t) => t.kind"

///|
/// The number of tracks currently in this live collection.
#cfg(target="js")
pub extern "js" fn VideoTrackList::length(self : Self) -> Int = "(l) => l.length"

///|
/// Returns the track at `index`, or `None` when the index is out of range.
#cfg(target="js")
#alias("_[_]")
pub fn VideoTrackList::get(self : Self, index : Int) -> VideoTrack? {
  video_track_list_get_ffi(self, index).to_option()
}

///|
/// Returns the track whose `id` is `id`, or `None` when no track matches.
#cfg(target="js")
pub fn VideoTrackList::get_track_by_id(self : Self, id : String) -> VideoTrack? {
  video_track_list_get_track_by_id_ffi(self, id).to_option()
}

///|
/// Iterates the current tracks without materializing an array. The collection
/// is live: tracks added or removed while iterating affect later steps.
#cfg(target="js")
pub fn VideoTrackList::iter(self : Self) -> Iter[VideoTrack] {
  let mut index = 0
  Iter::new(fn() {
    let item = self.get(index)
    index += 1
    item
  })
}

///|
#cfg(target="js")
extern "js" fn video_track_list_get_ffi(
  list : VideoTrackList,
  index : Int,
) -> @js.Nullable[VideoTrack] = "(l, i) => l[i] ?? null"

///|
#cfg(target="js")
extern "js" fn video_track_list_get_track_by_id_ffi(
  list : VideoTrackList,
  id : String,
) -> @js.Nullable[VideoTrack] = "(l, id) => l.getTrackById(id)"

///|
/// The identifier of the track. Tracks created through `add_text_track` have an
/// empty identifier; in-band and `<track>`-element tracks carry their own.
#cfg(target="js")
pub extern "js" fn VideoTrack::get_id(self : Self) -> String = "(t) => t.id"

///|
/// The human-readable label of the track.
#cfg(target="js")
pub extern "js" fn VideoTrack::get_label(self : Self) -> String = "(t) => t.label"

///|
/// The track category, such as `"alternative"` or `"main"`.
#cfg(target="js")
pub extern "js" fn VideoTrack::get_kind(self : Self) -> String = "(t) => t.kind"

///|
/// The number of tracks currently in this live collection.
#cfg(target="js")
pub extern "js" fn TextTrackList::length(self : Self) -> Int = "(l) => l.length"

///|
/// Returns the track at `index`, or `None` when the index is out of range.
#cfg(target="js")
#alias("_[_]")
pub fn TextTrackList::get(self : Self, index : Int) -> TextTrack? {
  text_track_list_get_ffi(self, index).to_option()
}

///|
/// Returns the track whose `id` is `id`, or `None` when no track matches.
#cfg(target="js")
pub fn TextTrackList::get_track_by_id(self : Self, id : String) -> TextTrack? {
  text_track_list_get_track_by_id_ffi(self, id).to_option()
}

///|
/// Iterates the current tracks without materializing an array. The collection
/// is live: tracks added or removed while iterating affect later steps.
#cfg(target="js")
pub fn TextTrackList::iter(self : Self) -> Iter[TextTrack] {
  let mut index = 0
  Iter::new(fn() {
    let item = self.get(index)
    index += 1
    item
  })
}

///|
#cfg(target="js")
extern "js" fn text_track_list_get_ffi(
  list : TextTrackList,
  index : Int,
) -> @js.Nullable[TextTrack] = "(l, i) => l[i] ?? null"

///|
#cfg(target="js")
extern "js" fn text_track_list_get_track_by_id_ffi(
  list : TextTrackList,
  id : String,
) -> @js.Nullable[TextTrack] = "(l, id) => l.getTrackById(id)"

///|
/// The identifier of the track. Tracks created through `add_text_track` have an
/// empty identifier; in-band and `<track>`-element tracks carry their own.
#cfg(target="js")
pub extern "js" fn TextTrack::get_id(self : Self) -> String = "(t) => t.id"

///|
/// The human-readable label of the track.
#cfg(target="js")
pub extern "js" fn TextTrack::get_label(self : Self) -> String = "(t) => t.label"

///|
/// The track category, such as `"captions"` or `"subtitles"`.
#cfg(target="js")
pub extern "js" fn TextTrack::get_kind(self : Self) -> String = "(t) => t.kind"
