///|
/// A JavaScript promise that resolves to a value of type `T`.
#cfg(target="js")
pub(all) struct Promise[T](@js_async.Promise[T])

///|
/// Creates a fulfilled promise.
#cfg(target="js")
pub fn[T] Promise::resolve(value : T) -> Promise[T] {
  Promise(promise_resolve_ffi(Value::cast_from(value)).cast())
}

///|
#cfg(target="js")
extern "js" fn promise_resolve_ffi(value : Value) -> Value =
  #| (value) => Promise.resolve(value)

///|
/// Creates a rejected promise with any JavaScript rejection reason.
#cfg(target="js")
pub fn[T] Promise::reject(reason : Value) -> Promise[T] {
  Promise(promise_reject_ffi(reason).cast())
}

///|
#cfg(target="js")
extern "js" fn promise_reject_ffi(reason : Value) -> Value =
  #| (reason) => Promise.reject(reason)

///|
#cfg(target="js")
extern "js" fn throw_promise_error(error : Error) -> Value =
  #| (error) => { throw error; }

///|
// Convert checked MoonBit errors into exceptions caught by native Promise handlers.
#cfg(target="js")
fn[T] promise_callback(callback : () -> T raise) -> T {
  callback() catch {
    error => throw_promise_error(error).cast()
  }
}

///|
#cfg(target="js")
extern "js" fn promise_then_ffi(
  promise : Value,
  on_fulfilled : (Value) -> Value,
) -> Value =
  #| (self, onFulfilled) => self.then(onFulfilled)

///|
/// Transforms a fulfilled value. Rejections pass through unchanged, and errors
/// raised by the callback reject the returned promise.
///
/// JavaScript automatically flattens promises and thenables returned by the
/// callback. This API does not check for or compensate for that behavior, so
/// callers must ensure `U` is not a promise or thenable; otherwise the runtime
/// value will not match the declared `Promise[U]` type. Use `flat_map` when the
/// callback returns a promise.
///
/// ```mbt check
/// async test {
///   let result = @js.Promise::resolve(21).then(value => value * 2).wait()
///   assert_eq(result, 42)
/// }
/// ```
#cfg(target="js")
pub fn[T, U] Promise::then(
  self : Promise[T],
  on_fulfilled : (T) -> U raise,
) -> Promise[U] {
  Promise(
    promise_then_ffi(Value::cast_from(self.0), value => {
      Value::cast_from(promise_callback(() => on_fulfilled(value.cast())))
    }).cast(),
  )
}

///|
/// Chains a promise returned by the callback, adopting its value or rejection.
/// Errors raised by the callback also reject the returned promise.
#cfg(target="js")
pub fn[T, U] Promise::flat_map(
  self : Promise[T],
  on_fulfilled : (T) -> Promise[U] raise,
) -> Promise[U] {
  Promise(
    promise_then_ffi(Value::cast_from(self.0), value => {
      Value::cast_from(promise_callback(() => on_fulfilled(value.cast())).0)
    }).cast(),
  )
}

///|
#cfg(target="js")
extern "js" fn promise_catch_ffi(
  promise : Value,
  on_rejected : (Value) -> Value,
) -> Value =
  #| (self, onRejected) => self.catch(onRejected)

///|
/// Recovers from a rejection. Fulfilled values pass through unchanged, and errors
/// raised by the callback reject the returned promise.
#cfg(target="js")
pub fn[T] Promise::catch_(
  self : Promise[T],
  on_rejected : (Value) -> T raise,
) -> Promise[T] {
  Promise(
    promise_catch_ffi(Value::cast_from(self.0), reason => {
      Value::cast_from(promise_callback(() => on_rejected(reason)))
    }).cast(),
  )
}

///|
#cfg(target="js")
extern "js" fn promise_finally_ffi(
  promise : Value,
  on_finally : () -> Unit,
) -> Value =
  #| (self, onFinally) => self.finally(onFinally)

///|
/// Runs after fulfillment or rejection, preserving the original outcome unless
/// the callback raises an error, which rejects the returned promise instead.
#cfg(target="js")
pub fn[T] Promise::finally_(
  self : Promise[T],
  on_finally : () -> Unit raise,
) -> Promise[T] {
  Promise(
    promise_finally_ffi(Value::cast_from(self.0), () => {
      promise_callback(on_finally)
    }).cast(),
  )
}

///|
/// Converts a MoonBit async function into a JavaScript promise.
/// An optional abort signal cancels the function when activated.
#cfg(target="js")
pub fn[T] Promise::from_async(
  f : async () -> T,
  abort_signal? : @js_async.AbortSignal,
) -> Promise[T] {
  Promise(@js_async.Promise::from_async(f, abort_signal?))
}

///|
/// Waits for fulfillment, or raises an error on rejection.
/// An optional abort controller cancels the promise when the wait is cancelled;
/// without one, the wait is non-cancellable.
#cfg(target="js")
pub async fn[T] Promise::wait(
  self : Promise[T],
  abort_controller? : @js_async.AbortController,
) -> T {
  self.0.wait(abort_controller?)
}
