///|
struct SSRHost {
  task_queue : Queue[(@cmd.Op, @cmd.Extension)]
  transcript : Map[String, Json]
  scope : @duplix.ScopeId
  mut document : @vdom.VDom?
  mut url_request : @cmd.Injector[String]
  mut url_changed : @cmd.Injector[String]
  origin : String
  path : String
  stores : @slotmap.SlotMap[Store]
}

///|
pub fn SSRHost::render_to_string(
  self : Self,
  head : Array[@vdom.VNode],
) -> String {
  let document = self.document.unwrap()
  guard! document.vnode
    is Elem("html", _, Array([Elem("head", _, Array(metadata), ..), ..]), ..)
  metadata.append(head)
  let transcript = Json::object(self.transcript).stringify(escape_slash=true)
  let props = @vdom.Props::new(
    { "id": RABBITA_TRANSCRIPT_ID, "type": "application/json" },
    {},
    {},
    {},
  )
  metadata.push(
    @vdom.VNode::elem("script", props, Array([@vdom.VNode::text(transcript)])),
  )
  document.to_string()
}

///|
pub async fn SSRHost::SSRHost(
  origin~ : String,
  path~ : String,
  builder : GraphBuilder,
) -> Self {
  let (host, output) = @duplix.with_scope(scope => {
    let host = SSRHost::{
      task_queue: Queue([]),
      document: None,
      url_request: _ => @cmd.none,
      url_changed: _ => @cmd.none,
      origin: origin.trim_end(chars="/").to_owned(),
      path,
      transcript: Map([]),
      stores: SlotMap(),
      scope,
    }
    (host, ambient_host.protect(host, builder))
  })
  errdefer host.cleanup()
  let cmd = Context::inject_url_changed(host, host.origin + host.path)
  Scheduler::queue_command(host, cmd)

  let vnode = for ;; {
    host.drain_task()
    let tmp = ambient_host.protect(host, () => output.read())
    if host.task_queue.is_empty() {
      break tmp
    }
  }

  host.document = Some(@vdom.VDom::initialize(vnode, host))
  host
}

///|
async fn SSRHost::drain_task(host : Self) -> Unit {
  @async.with_task_group(group => {
    fn run(op, extension) {
      let runner = @cmd.runner(@key.key, op)
      try runner.settle(extension, host) catch {
        Unhandled =>
          try runner.invoke(extension, host) catch {
            Unhandled => ()
          } noraise {
            None => ()
            Ready(cmd) => host.queue_command(cmd)
            Async(f) => group.spawn_bg(() => host.queue_command(f()))
            LegacyEffect(Immediately, f) => f(host)
            AfterLayout(_) | LegacyEffect(AfterRender, _) => ()
          }
      } noraise {
        None => ()
        Ready((value, cmd)) => {
          try runner.identify(extension) catch {
            Unhandled => ()
          } noraise {
            key => host.transcript[key] = value
          }
          host.queue_command(cmd)
        }
        Async(f) =>
          group.spawn_bg(() => {
            try f() catch {
              @cmd.HydrateExn::Fallback => ()
              error => raise error
            } noraise {
              (value, cmd) => {
                try runner.identify(extension) catch {
                  Unhandled => ()
                } noraise {
                  key => host.transcript[key] = value
                }
                Scheduler::queue_command(host, cmd)
              }
            }
          })
        LegacyEffect(Immediately, f) => f(host)
        AfterLayout(_) | LegacyEffect(AfterRender, _) => ()
      }
    }
    while host.task_queue.pop() is Some((op, extension)) {
      if handle_message(host, extension) {
        continue
      }
      run(op, extension)
    }
  })
}

///|
pub impl Host for SSRHost with fn flush(self) {
  ignore(self)
}

///|
pub impl Host for SSRHost with fn get_stores(self) {
  self.stores
}

///|
pub impl Host for SSRHost with fn cleanup(self) {
  self.scope.cleanup()
}

///|
pub impl Scheduler for SSRHost with fn queue_command(self, cmd) {
  let tasks = @cmd.flatten(@key.key, cmd)
  for task in tasks {
    self.task_queue.push(task)
  }
}

///|
pub impl Scheduler for SSRHost with fn set_url_changed_injector(self, injector) {
  self.url_changed = injector
}

///|
pub impl Scheduler for SSRHost with fn set_url_request_injector(self, injector) {
  self.url_request = injector
}

///|
pub impl Context for SSRHost with fn get_origin(self) {
  self.origin
}

///|
pub impl Context for SSRHost with fn inject_url_changed(self, url) {
  (self.url_changed)(url)
}

///|
pub impl Context for SSRHost with fn inject_url_request(self, url) {
  (self.url_request)(url)
}
