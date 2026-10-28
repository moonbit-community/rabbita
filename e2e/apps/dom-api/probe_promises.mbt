///|
extern "js" fn promise_probe_animation() -> @dom.Animation =
  #| () => document.createElement('div').animate([{ opacity: 0 }, { opacity: 1 }], 1)

///|
async fn probe_dom_promises(failures : Array[String]) -> Unit {
  let document = @dom.document()
  guard document.create_element("img").to_html_image_element() is Some(image) else {
    fail("expected an image element")
  }
  image.set_src(
    "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' width='1' height='1'></svg>",
  )
  image
  .decode()
  .then(_ => record(failures, image.get_complete(), "image_decode"))
  .wait()
  let animation = promise_probe_animation()
  let ready = animation.get_ready().wait()
  record(failures, physical_equal(ready, animation), "animation_ready")
  animation.finish()
  let finished = animation.get_finished().wait()
  record(failures, physical_equal(finished, animation), "animation_finished")
  guard document.create_element("video").to_html_video_element() is Some(video) else {
    fail("expected a video element")
  }
  video.set_media_keys(None).wait()
  video.set_sink_id("").wait()
  let playing = video.play()
  video.pause()
  let play_result = playing
    .then(_ => "fulfilled")
    .catch_(reason => reason.get_with_string("name"))
    .wait()
  record(
    failures,
    play_result == "AbortError" ||
    play_result == "NotSupportedError" ||
    play_result == "NotAllowedError",
    "media_play_rejection",
  )
}
