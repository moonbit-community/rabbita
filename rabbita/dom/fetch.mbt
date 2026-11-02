///|
/// Calls the global native fetch(), preserving its promise and rejection reason.
/// HTTP error statuses such as 404 fulfill the promise; inspect Response::get_ok
/// or Response::get_status. Network and abort failures reject it.
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/fetch
#cfg(target="js")
pub fn[T : IsRequestInfo] fetch(
  resource : T,
  init? : RequestInit,
) -> @js.Promise[Response] {
  fetch_ffi(@js.Cast::from(resource), @js.Optional::from_option(init))
}

///|
#cfg(target="js")
extern "js" fn fetch_ffi(
  resource : @js.Value,
  init : @js.Optional[RequestInit],
) -> @js.Promise[Response] =
  #| (resource, init) => globalThis.fetch(resource, init)
