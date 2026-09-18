///|
struct HydrationHost {
  browser : BrowserHost
  transcript : Map[String, Json]
}

///|
priv suberror UnwrapNone

///|
pub fn HydrationHost::HydrationHost(builder : GraphBuilder) -> HydrationHost {
  let transcript = try {
    let element = @dom.document()
      .get_element_by_id(RABBITA_TRANSCRIPT_ID)
      .to_option()
      .unwrap_or_error(UnwrapNone)
    let text = element
      .get_property("textContent")
      .to_option()
      .unwrap_or_error(UnwrapNone)
    guard @json.parse(text) is Object(transcript) else { fail("") }
    transcript
  } catch {
    _ => Map([])
  }

  let (host, output) = @duplix.with_scope(scope => {
    let host = HydrationHost::{
      browser: {
        stores: SlotMap(),
        scope,
        task_queue: Queue([]),
        graph_output: None,
        document: None,
        url_request: _ => @cmd.none,
        url_changed: _ => @cmd.none,
        paint_scheduled: false,
        drain_scheduled: true,
        after_render_queue: Queue([]),
      },
      transcript,
    }
    (host, ambient_host.protect(host, builder))
  })
  host.browser.graph_output = Some(output)
  let url = @dom.window().current_url()
  let cmd = Context::inject_url_changed(host, url)
  Scheduler::queue_command(host, cmd)

  let vnode = for ;; {
    host.drain_task_with_transcript()
    let tmp = ambient_host.protect(host, () => output.read())
    if host.browser.task_queue.is_empty() {
      break tmp
    }
  }

  let vdom = @vdom.VDom::initialize_with_hydration(vnode, host)
  host.browser.document = Some(vdom)
  host.browser.drain_scheduled = false
  host
}

///|
pub impl Host for HydrationHost with fn flush(self) {
  Host::flush(self.browser)
}

///|
pub impl Host for HydrationHost with fn get_stores(self) {
  self.browser.stores
}

///|
fn HydrationHost::drain_task_with_transcript(host : Self) -> Unit {
  let self = host.browser
  while self.task_queue.pop() is Some((op, extension)) {
    if handle_message(host, extension) {
      continue
    }
    fn fallback() {
      try @cmd.invoke(@key.key, op, extension, self) catch {
        Unhandled => ()
      } noraise {
        None => ()
        Ready(cmd) => Scheduler::queue_command(self, cmd)
        Async(f) =>
          @js.Promise::from_async(() => Scheduler::queue_command(self, f()))
          |> ignore
        AfterLayout(f) => self.after_render_queue.push(f)
        LegacyEffect(Immediately, f) => f(self)
        LegacyEffect(AfterRender, f) =>
          self.after_render_queue.push(() => {
            f(self)
            @cmd.none
          })
      }
    }
    try {
      let runner = @cmd.runner(@key.key, op)
      let key = runner.identify(extension)
      let json = host.transcript
        .get(key)
        .unwrap_or_error(@cmd.HydrateExn::Fallback)
      let cmd = runner.resume_(extension, json, host)
      Scheduler::queue_command(self, cmd)
    } catch {
      @cmd.Unhandled::Unhandled
      | @cmd.HydrateExn::Unhandled
      | @cmd.HydrateExn::Fallback => fallback()
      @cmd.HydrateExn::Skip | _ => ()
    }
  }
}

///|
pub impl Host for HydrationHost with fn cleanup(self) {
  Host::cleanup(self.browser)
}

///|
pub impl Scheduler for HydrationHost with fn queue_command(self, cmd) {
  Scheduler::queue_command(self.browser, cmd)
}

///|
pub impl Scheduler for HydrationHost with fn set_url_changed_injector(
  self,
  injector,
) {
  Scheduler::set_url_changed_injector(self.browser, injector)
}

///|
pub impl Scheduler for HydrationHost with fn set_url_request_injector(
  self,
  injector,
) {
  Scheduler::set_url_request_injector(self.browser, injector)
}

///|
pub impl Context for HydrationHost with fn get_origin(self) {
  Context::get_origin(self.browser)
}

///|
pub impl Context for HydrationHost with fn inject_url_changed(self, url) {
  Context::inject_url_changed(self.browser, url)
}

///|
pub impl Context for HydrationHost with fn inject_url_request(self, url) {
  Context::inject_url_request(self.browser, url)
}
