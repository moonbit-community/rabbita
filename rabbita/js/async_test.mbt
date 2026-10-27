///|
suberror CallbackError {
  CallbackError(String)
}

///|
fn callback_error_message(reason : @js.Value) -> String raise {
  let error : Error = reason.cast()
  guard error is CallbackError(message) else {
    fail("expected the original MoonBit callback error")
  }
  message
}

///|
extern "js" fn native_promise() -> @js.Promise[String] =
  #| () => Promise.resolve("native")

///|
async test "Promise wraps and unwraps js_async promises" {
  let inner = @js_async.Promise::from_async(() => 21)
  let promise = @js.Promise(inner)
  assert_eq(promise.0.wait(), 21)
  assert_eq(promise.then(value => value * 2).wait(), 42)
  assert_eq(
    native_promise().then(value => value + " promise").wait(),
    "native promise",
  )
}

///|
async test "Promise then transforms values and runs asynchronously" {
  let mut called = false
  let promise = @js.Promise::resolve(21).then(value => {
    called = true
    value * 2
  })
  assert_false(called)
  assert_eq(promise.then(value => "value: \{value}").wait(), "value: 42")
  assert_true(called)
}

///|
async test "Promise then passes rejections to catch" {
  let mut called = false
  let promise : @js.Promise[String] = @js.Promise::reject(
    @js.Value::cast_from("rejected"),
  )
  let result = promise
    .then(value => {
      called = true
      value
    })
    .catch_(reason => reason.cast())
    .wait()
  assert_eq(result, "rejected")
  assert_false(called)
}

///|
async test "Promise catch preserves fulfilled values and resumes chaining" {
  let mut called = false
  let value = @js.Promise::resolve(42)
    .catch_(_ => {
      called = true
      0
    })
    .wait()
  assert_eq(value, 42)
  assert_false(called)
  let rejected : @js.Promise[Int32] = @js.Promise::reject(
    @js.Value::from_json_string("null"),
  )
  assert_eq(rejected.catch_(_ => 21).then(value => value * 2).wait(), 42)
}

///|
async test "Promise flat_map adopts fulfillment and rejection" {
  let result = @js.Promise::resolve(21)
    .flat_map(value => @js.Promise::from_async(() => "value: \{value * 2}"))
    .wait()
  assert_eq(result, "value: 42")
  let rejected : @js.Promise[String] = @js.Promise::resolve(1).flat_map(_ => {
    @js.Promise::reject(@js.Value::cast_from("inner rejection"))
  })
  assert_eq(rejected.catch_(reason => reason.cast()).wait(), "inner rejection")
}

///|
async test "Promise flat_map skips callbacks on rejection" {
  let mut called = false
  let rejected : @js.Promise[Int32] = @js.Promise::reject(
    @js.Value::from_json_string("null"),
  )
  let result = rejected
    .flat_map(value => {
      called = true
      @js.Promise::resolve(value)
    })
    .catch_(_ => 42)
    .wait()
  assert_eq(result, 42)
  assert_false(called)
}

///|
async test "Promise finally preserves fulfillment and callback order" {
  let events : Array[String] = []
  let value = @js.Promise::resolve(42)
    .then(value => {
      events.push("then")
      value
    })
    .finally_(() => events.push("finally"))
    .then(value => {
      events.push("after")
      value
    })
    .wait()
  assert_eq(value, 42)
  debug_inspect(events, content="[\"then\", \"finally\", \"after\"]")
}

///|
extern "js" fn same_value(left : @js.Value, right : @js.Value) -> Bool =
  #| (left, right) => Object.is(left, right)

///|
async test "Promise finally preserves arbitrary rejection reasons" {
  let object = @js.Object::new().to_value()
  let reasons = [
    @js.Value::from_json_string("null"),
    object.get_with_string("missing"),
    @js.Value::cast_from("rejected"),
    object,
  ]
  for reason in reasons {
    let mut called = false
    let rejected : @js.Promise[Unit] = @js.Promise::reject(reason)
    rejected
    .finally_(() => called = true)
    .catch_(actual => {
      assert_true(called)
      assert_true(same_value(actual, reason))
    })
    .wait()
  }
}

///|
async test "Promise then converts checked callback errors into rejections" {
  let promise : @js.Promise[String] = @js.Promise::resolve(1).then(_ => {
    raise CallbackError("then failed")
  })
  assert_eq(promise.catch_(callback_error_message).wait(), "then failed")
}

///|
async test "Promise flat_map converts checked callback errors into rejections" {
  let promise : @js.Promise[String] = @js.Promise::resolve(1).flat_map(_ => {
    raise CallbackError("flat_map failed")
  })
  assert_eq(promise.catch_(callback_error_message).wait(), "flat_map failed")
}

///|
async test "Promise catch converts checked callback errors into rejections" {
  let rejected : @js.Promise[String] = @js.Promise::reject(
    @js.Value::from_json_string("null"),
  )
  let promise = rejected.catch_(_ => raise CallbackError("catch failed"))
  assert_eq(promise.catch_(callback_error_message).wait(), "catch failed")
}

///|
async test "Promise finally callback errors replace fulfillment and rejection" {
  let fulfilled = @js.Promise::resolve("original value")
  let rejected : @js.Promise[String] = @js.Promise::reject(
    @js.Value::from_json_string("null"),
  )
  for promise in [fulfilled, rejected] {
    let result = promise.finally_(() => raise CallbackError("finally failed"))
    assert_eq(result.catch_(callback_error_message).wait(), "finally failed")
  }
}

///|
async test "Promise from_async forwards abort signals" {
  let controller = @js_async.AbortController::new()
  controller.abort()
  let mut called = false
  let promise = @js.Promise::from_async(abort_signal=controller.signal(), () => {
    @async.sleep(1)
    called = true
    "completed"
  })
  let result = promise.catch_(reason => reason.get_with_string("name")).wait()
  assert_eq(result, "AbortError")
  assert_false(called)
}

///|
extern "js" fn abortable_promise(
  signal : @js_async.AbortSignal,
) -> @js.Promise[Unit] =
  #| (signal) => new Promise((_, reject) => {
  #|   signal.addEventListener("abort", () => reject(new Error("aborted")), { once: true });
  #| })

///|
extern "js" fn signal_aborted(signal : @js_async.AbortSignal) -> Bool =
  #| (signal) => signal.aborted

///|
async test "Promise wait forwards abort controllers" {
  let controller = @js_async.AbortController::new()
  let signal = controller.signal()
  let promise = abortable_promise(signal)
  try
    @async.with_timeout(10, () => promise.wait(abort_controller=controller))
  catch {
    @async.TimeoutError => ()
    error => raise error
  } noraise {
    _ => fail("expected cancellation")
  }
  assert_true(signal_aborted(signal))
}
