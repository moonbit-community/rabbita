///|
async test "Blob reads compose as promises without entering async first" {
  let bytes = b"\xe4\xbd\xa0\xe5\xa5\xbd"
  let blob = @dom.Blob::from_bytes(bytes, "text/plain")
  let text_promise = blob.text().then(text => text + "!")
  let bytes_promise = blob.bytes()
  assert_eq(text_promise.wait(), "你好!")
  assert_eq(bytes_promise.wait(), bytes)
  assert_eq(
    blob
    .text()
    .flat_map(text => {
      blob
      .bytes()
      .then(data => {
        assert_eq(data, bytes)
        text
      })
    })
    .wait(),
    "你好",
  )
  let empty = @dom.Blob::from_bytes(b"", "text/plain")
  assert_eq(empty.text().wait(), "")
  assert_eq(empty.bytes().wait(), b"")
}

///|
extern "js" fn rejected_blob() -> @js.Value =
  #| () => {
  #|   const reason = new Error('blob read failed');
  #|   return {
  #|     reason,
  #|     text() { return Promise.reject(reason); },
  #|     bytes() { return Promise.reject(reason); },
  #|   };
  #| }

///|
async test "Blob read promises preserve the native rejection reason" {
  let host = rejected_blob()
  let blob : @dom.Blob = host.cast()
  let expected : @js.Value = host.get_with_string("reason")
  let text = blob
    .text()
    .catch_(reason => {
      assert_true(physical_equal(reason, expected))
      "recovered"
    })
  let bytes = blob
    .bytes()
    .catch_(reason => {
      assert_true(physical_equal(reason, expected))
      b"recovered"
    })
  assert_eq(text.wait(), "recovered")
  assert_eq(bytes.wait(), b"recovered")
}

///|
extern "js" fn blob_bytes_host() -> @js.Value =
  #| () => ({
  #|   promise: Promise.resolve(new Uint8Array([1, 2, 3])),
  #|   bytes() { this.read = true; return this.promise; },
  #| })

///|
async test "Blob bytes calls the native method and preserves its promise" {
  let host = blob_bytes_host()
  let blob : @dom.Blob = host.cast()
  let promise = blob.bytes()
  assert_true(host.get_with_string("read"))
  assert_true(
    physical_equal(
      @js.Value::cast_from(promise.0),
      host.get_with_string("promise"),
    ),
  )
  assert_eq(promise.wait(), b"\x01\x02\x03")
}

///|
extern "js" fn capture_js_error(f : () -> Unit) -> @js.Nullable[@js.Value] =
  #| (f) => { try { f(); return null; } catch (error) { return error; } }

///|
test "Unavailable native methods keep their synchronous TypeError" {
  let host = @js.Object::new().to_value()
  let blob : @dom.Blob = host.cast()
  let media : @dom.HTMLMediaElement = host.cast()
  for
    call in [
      () => ignore(blob.bytes()),
      () => ignore(media.seek_to_next_frame()),
    ] {
    guard capture_js_error(call).to_option() is Some(error) else {
      fail("expected a native synchronous error")
    }
    assert_eq(error.get_with_string("name"), "TypeError")
  }
}

///|
extern "js" fn media_promise_host(rejected : Bool) -> @js.Value =
  #| (rejected) => {
  #|   const reason = new Error('media operation failed');
  #|   const promise = rejected ? Promise.reject(reason) : Promise.resolve();
  #|   return {
  #|     reason, promise, keys: null, sinkId: '',
  #|     play() { this.played = true; return this.promise; },
  #|     seekToNextFrame() { this.sought = true; return this.promise; },
  #|     setMediaKeys(keys) { this.keys = keys; return this.promise; },
  #|     setSinkId(id) { this.sinkId = id; return this.promise; },
  #|     decode() { this.decoded = true; return this.promise; },
  #|   };
  #| }

///|
async test "Media promise methods preserve receiver arguments and promise identity" {
  let host = media_promise_host(false)
  let media : @dom.HTMLMediaElement = host.cast()
  let promise = media.play()
  assert_true(
    physical_equal(
      @js.Value::cast_from(promise.0),
      host.get_with_string("promise"),
    ),
  )
  promise.wait()
  assert_true(host.get_with_string("played"))
  let keys_value = @js.Object::new().to_value()
  let keys : @dom.MediaKeys = keys_value.cast()
  media.set_media_keys(Some(keys)).wait()
  assert_true(physical_equal(host.get_with_string("keys"), keys_value))
  media.set_media_keys(None).wait()
  assert_true((host.get_with_string("keys") : @js.Value).is_null())
  media.set_sink_id("speaker-1").wait()
  assert_eq(host.get_with_string("sinkId"), "speaker-1")
  media.seek_to_next_frame().wait()
  assert_true(host.get_with_string("sought"))
  let video : @dom.HTMLVideoElement = host.cast()
  video.play().wait()
  video.set_media_keys(None).wait()
  video.set_sink_id("speaker-2").wait()
  video.seek_to_next_frame().wait()
  assert_eq(host.get_with_string("sinkId"), "speaker-2")
  let image : @dom.HTMLImageElement = host.cast()
  image.decode().wait()
  assert_true(host.get_with_string("decoded"))
}

///|
async test "Media and image promise methods propagate native rejections" {
  let host = media_promise_host(true)
  let media : @dom.HTMLMediaElement = host.cast()
  let image : @dom.HTMLImageElement = host.cast()
  let expected : @js.Value = host.get_with_string("reason")
  for
    promise in [
      media.play(),
      media.set_media_keys(None),
      media.set_sink_id("speaker"),
      media.seek_to_next_frame(),
      image.decode(),
    ] {
    let mut recovered = false
    promise
    .catch_(reason => {
      assert_true(physical_equal(reason, expected))
      recovered = true
    })
    .wait()
    assert_true(recovered)
  }
}

///|
extern "js" fn animation_promise_host(rejected : Bool) -> @js.Value =
  #| (rejected) => {
  #|   const host = { reason: new Error('animation cancelled') };
  #|   host.ready = host.finished = rejected
  #|     ? Promise.reject(host.reason)
  #|     : Promise.resolve(host);
  #|   return host;
  #| }

///|
extern "js" fn replace_animation_promises(host : @js.Value) -> Unit =
  #| (host) => { host.ready = host.finished = Promise.resolve(host); }

///|
async test "Animation reads current ready and finished promises" {
  let host = animation_promise_host(false)
  let animation : @dom.Animation = host.cast()
  let first_ready = animation.get_ready()
  assert_true(physical_equal(first_ready.wait(), animation))
  assert_true(physical_equal(animation.get_finished().wait(), animation))
  assert_true(
    physical_equal(
      @js.Value::cast_from(first_ready.0),
      host.get_with_string("ready"),
    ),
  )
  replace_animation_promises(host)
  let next_ready = animation.get_ready()
  assert_false(physical_equal(first_ready.0, next_ready.0))
  assert_true(physical_equal(next_ready.wait(), animation))
  assert_true(physical_equal(animation.get_finished().wait(), animation))
}

///|
async test "Animation promises preserve cancellation rejections" {
  let host = animation_promise_host(true)
  let animation : @dom.Animation = host.cast()
  let expected : @js.Value = host.get_with_string("reason")
  for promise in [animation.get_ready(), animation.get_finished()] {
    let mut recovered = false
    promise
    .catch_(reason => {
      assert_true(physical_equal(reason, expected))
      recovered = true
      animation
    })
    .wait()
    |> ignore
    assert_true(recovered)
  }
}
