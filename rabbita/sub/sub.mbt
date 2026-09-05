///|
using @common {type Keyboard, type Mouse, type Scroll, type Viewport}

///|
using @cmd {trait Scheduler}

///|
using @cmd {type Cmd, type Emit}

///|
/// A long-lived subscription managed by the Rabbita runtime.
///
/// Use subscriptions to listen to external signals such as timers, window
/// resize, scrolling, keyboard input, visibility changes, or WebSocket events.
/// Browser event sources are inert on native targets.
enum Sub {
  Custom(String, Scope, Error, SubLoader)
  Batch(Array[Sub])
}

///|
/// Custom subscriptions loader. 
pub(all) struct SubLoader((Error, &Scheduler) -> RunningSub?)

///|
pub(all) struct RunningSub {
  unload : (&Scheduler) -> Unit
  update_tagger : (Error) -> Unit
}

///|
/// Create a custom subscription
pub fn custom_sub(
  key : String,
  scope : Scope,
  payload : Error,
  loader : SubLoader,
) -> Sub {
  Custom(key, scope, payload, loader)
}

///|
priv suberror BuiltinSub {
  Every(Int, Cmd)
  AnimationFrame(Emit[Double])
  Keydown(Emit[Keyboard])
  Keyup(Emit[Keyboard])
  MouseMove(Emit[Mouse])
  Resize(Emit[Viewport])
  UrlChanged(Emit[@url.Url])
  UrlRequest(Emit[@url.UrlRequest])
  Scroll(Emit[Scroll])
  VisibilityChange(Emit[Bool])
}

///|
#cfg(target="js")
fn builtin_sub_loader(payload : Error, scheduler : &Scheduler) -> RunningSub? {
  match payload {
    Every(ms, cmd) => {
      let tagger = @ref.Ref(cmd)
      let id = @dom.window().set_interval(() => scheduler.add(tagger.val), ms)
      let unload = _ => @dom.window().clear_interval(id)
      let update_tagger = self => {
        guard self is BuiltinSub::Every(_, new_cmd) else { return }
        tagger.val = new_cmd
      }
      Some({ unload, update_tagger, })
    }
    AnimationFrame(cmd) => {
      let tagger = @ref.Ref(cmd)
      let mut active = true
      let mut request_id : Double? = None

      fn queue_next() {
        request_id = Some(
          @dom.window().request_animation_frame(timestamp => {
            guard active else { return }
            scheduler.add((tagger.val)(timestamp))
            queue_next()
          }),
        )
      }

      queue_next()
      let unload = _ => {
        active = false
        guard request_id is Some(id) else { return }
        @dom.window().cancel_animation_frame(id)
      }
      let update_tagger = self => {
        guard self is BuiltinSub::AnimationFrame(new_cmd) else { return }
        tagger.val = new_cmd
      }
      Some({ unload, update_tagger, })
    }
    Keydown(cmd) => {
      let tagger = @ref.Ref(cmd)
      let listener : @dom.Listener = event => {
        scheduler.add(
          (tagger.val)(keyboard_from_dom(event.to_keyboard_event().unwrap())),
        )
      }
      let unload = _ => {
        @dom.document()
        .as_event_target()
        .remove_event_listener("keydown", listener)
      }
      let update_tagger = self => {
        guard self is BuiltinSub::Keydown(new_cmd) else { return }
        tagger.val = new_cmd
      }
      @dom.document().as_event_target().add_event_listener("keydown", listener)
      Some({ unload, update_tagger, })
    }
    Keyup(cmd) => {
      let tagger = @ref.Ref(cmd)
      let listener : @dom.Listener = event => {
        scheduler.add(
          (tagger.val)(keyboard_from_dom(event.to_keyboard_event().unwrap())),
        )
      }
      let unload = _ => {
        @dom.document()
        .as_event_target()
        .remove_event_listener("keyup", listener)
      }
      let update_tagger = self => {
        guard self is BuiltinSub::Keyup(new_cmd) else { return }
        tagger.val = new_cmd
      }
      @dom.document().as_event_target().add_event_listener("keyup", listener)
      Some({ unload, update_tagger, })
    }
    MouseMove(cmd) => {
      let tagger = @ref.Ref(cmd)
      let listener : @dom.Listener = event => {
        scheduler.add(
          (tagger.val)(mouse_from_dom(event.to_mouse_event().unwrap())),
        )
      }
      let unload = _ => {
        @dom.document()
        .as_event_target()
        .remove_event_listener("mousemove", listener)
      }
      let update_tagger = self => {
        guard self is BuiltinSub::MouseMove(new_cmd) else { return }
        tagger.val = new_cmd
      }
      @dom.document()
      .as_event_target()
      .add_event_listener("mousemove", listener)
      Some({ unload, update_tagger, })
    }
    Resize(cmd) => {
      let mut tagger = cmd
      let listener : @dom.Listener = event => {
        ignore(event)
        scheduler.add(
          tagger({
            width: @dom.window().inner_width(),
            height: @dom.window().inner_height(),
          }),
        )
      }
      let unload = _ => {
        @dom.window()
        .as_event_target()
        .remove_event_listener("resize", listener)
      }
      let update_tagger = self => {
        guard self is BuiltinSub::Resize(new_cmd) else { return }
        tagger = new_cmd
      }
      @dom.window().as_event_target().add_event_listener("resize", listener)
      Some({ unload, update_tagger, })
    }
    Scroll(cmd) => {
      let mut tagger = cmd
      let listener : @dom.Listener = event => {
        ignore(event)
        scheduler.add(tagger(window_scroll()))
      }
      let unload = _ => {
        @dom.window()
        .as_event_target()
        .remove_event_listener("scroll", listener)
      }
      let update_tagger = self => {
        guard self is BuiltinSub::Scroll(new_cmd) else { return }
        tagger = new_cmd
      }
      @dom.window().as_event_target().add_event_listener("scroll", listener)
      Some({ unload, update_tagger, })
    }
    UrlChanged(cmd) => {
      let mut tagger = cmd
      scheduler.set_url_changed_injector(url => {
        try @url.parse(url) catch {
          e => {
            println("failed to parse \{url}: \{e}")
            @cmd.none
          }
        } noraise {
          url => tagger(url)
        }
      })

      let listener : @dom.Listener = _ => {
        let cmd = scheduler.inject_url_changed(@dom.window().current_url())
        scheduler.add(cmd)
      }
      let unload = _ => {
        scheduler.set_url_changed_injector(_ => @cmd.none)
        @dom.window()
        .to_event_target()
        .remove_event_listener("popstate", listener)
      }
      let update_tagger = self => {
        guard self is BuiltinSub::UrlChanged(new_cmd) else { return }
        tagger = new_cmd
      }
      @dom.window().to_event_target().add_event_listener("popstate", listener)
      Some({ unload, update_tagger, })
    }
    UrlRequest(cmd) => {
      let mut tagger = cmd
      scheduler.set_url_request_injector(href => {
        let curr = try! @url.parse(@dom.window().current_url())
        let next = try! @url.parse(href)
        let request = if curr.protocol == next.protocol &&
          curr.host == next.host &&
          curr.port == next.port {
          @url.Internal(next)
        } else {
          External(href)
        }
        tagger(request)
      })

      fn unload(_) {
        scheduler.set_url_request_injector(_ => @cmd.none)
      }
      fn update_tagger(self) {
        guard self is BuiltinSub::UrlRequest(new_cmd) else { return }
        tagger = new_cmd
      }
      Some({ unload, update_tagger, })
    }
    VisibilityChange(cmd) => {
      let mut tagger = cmd
      let listener : @dom.Listener = _ => {
        scheduler.queue_command(tagger(@dom.document().hidden()))
      }
      let unload = _ => {
        @dom.document()
        .as_event_target()
        .remove_event_listener("visibilitychange", listener)
      }
      let update_tagger = self => {
        guard self is BuiltinSub::VisibilityChange(new_cmd) else { return }
        tagger = new_cmd
      }
      @dom.document()
      .as_event_target()
      .add_event_listener("visibilitychange", listener)
      Some({ unload, update_tagger, })
    }
    _ => None
  }
}

///|
#cfg(not(target="js"))
fn builtin_sub_loader(payload : Error, scheduler : &Scheduler) -> RunningSub? {
  match payload {
    UrlChanged(cmd) => {
      let mut tagger = cmd
      scheduler.set_url_changed_injector(url => {
        try @url.parse(url) catch {
          e => {
            println("failed to parse \{url}: \{e}")
            @cmd.none
          }
        } noraise {
          url => tagger(url)
        }
      })
      let unload = _ => scheduler.set_url_changed_injector(_ => @cmd.none)
      let update_tagger = self => {
        guard self is BuiltinSub::UrlChanged(new_cmd) else { return }
        tagger = new_cmd
      }
      Some({ unload, update_tagger, })
    }
    _ => None
  }
}

///|
pub(all) enum Scope {
  Local
  Global
}

///|
#doc(hidden)
pub fn Sub::to_map(
  self : Self,
  _ : @key.Key,
  filter_global~ : Bool,
) -> Map[String, (Error, SubLoader)] {
  let map = Map([])
  fn go(s) {
    match s {
      Custom(_, Global, _, _) if filter_global => ()
      Custom(k, _, h, v) => map[k] = (h, v)
      Batch(xs) => xs.each(go)
    }
  }
  go(self)
  map
}

///|
#cfg(target="js")
fn keyboard_from_dom(event : @dom.KeyboardEvent) -> Keyboard {
  Keyboard::new(
    key=event.key(),
    code=event.code(),
    alt_key=event.alt_key(),
    ctrl_key=event.ctrl_key(),
    shift_key=event.shift_key(),
    meta_key=event.meta_key(),
    is_composing=event.is_composing(),
    repeat=event.repeat(),
    location=event.location(),
  )
}

///|
#cfg(target="js")
fn mouse_from_dom(event : @dom.MouseEvent) -> Mouse {
  Mouse::new(
    screen={ x: event.get_screen_x(), y: event.get_screen_y(), },
    offset={ x: event.get_offset_x(), y: event.get_offset_y(), },
    client={ x: event.get_client_x(), y: event.get_client_y(), },
  )
}

///|
#cfg(target="js")
fn window_scroll() -> Scroll {
  let root = @dom.document().query_selector("html").unwrap()
  Scroll::new(
    offset={ x: @dom.window().scroll_x(), y: @dom.window().scroll_y(), },
    width=root.get_scroll_width(),
    height=root.get_scroll_height(),
  )
}

///|
/// Repeatedly enqueue `cmd` every `ms` milliseconds.
pub fn every(ms : Int, cmd : @cmd.Cmd) -> Sub {
  custom_sub("every(\{ms})", Local, Every(ms, cmd), builtin_sub_loader)
}

///|
/// Subscribe to window resize events.
///
/// The handler receives the latest viewport width and height.
pub fn on_resize(msg : @cmd.Emit[Viewport]) -> Sub {
  custom_sub("on_resize", Local, Resize(msg), builtin_sub_loader)
}

///|
/// Subscribe to `requestAnimationFrame` ticks.
///
/// The handler receives the browser timestamp for each frame while the
/// subscription is active.
pub fn on_animation_frame(msg : @cmd.Emit[Double]) -> Sub {
  custom_sub(
    "on_animation_frame",
    Local,
    AnimationFrame(msg),
    builtin_sub_loader,
  )
}

///|
/// Subscribe to document `keydown` events.
///
/// The handler receives a normalized `Keyboard` value from `@common`.
pub fn on_key_down(msg : @cmd.Emit[Keyboard]) -> Sub {
  custom_sub("on_key_down", Local, Keydown(msg), builtin_sub_loader)
}

///|
/// Subscribe to document `keyup` events.
///
/// The handler receives a normalized `Keyboard` value from `@common`.
pub fn on_key_up(msg : @cmd.Emit[Keyboard]) -> Sub {
  custom_sub("on_key_up", Local, Keyup(msg), builtin_sub_loader)
}

///|
/// Subscribe to document visibility changes.
///
/// The handler receives `true` when the document is hidden, and `false`
/// when it becomes visible again.
pub fn on_visibility_change(msg : @cmd.Emit[Bool]) -> Sub {
  custom_sub(
    "on_visibility_change",
    Local,
    VisibilityChange(msg),
    builtin_sub_loader,
  )
}

///|
/// Subscribe to document `mousemove` events.
///
/// The handler receives a normalized `Mouse` value from `@common`.
pub fn on_mouse_move(msg : @cmd.Emit[Mouse]) -> Sub {
  custom_sub("on_mouse_move", Local, MouseMove(msg), builtin_sub_loader)
}

///|
/// Subscribe to window scroll events.
///
/// This reports page-level scrolling on `window`, not scrolling of an inner
/// element. The handler receives the current scroll offset and document scroll
/// size as a `Scroll` value.
pub fn on_scroll(msg : @cmd.Emit[Scroll]) -> Sub {
  custom_sub("on_scroll", Local, Scroll(msg), builtin_sub_loader)
}

///|
/// Subscribe to browser location changes.
///
/// This is an app-scoped subscription. It is only active when returned from
/// the root cell's `subscriptions` callback; if a non-root cell returns it,
/// the subscription is ignored.
pub fn on_url_changed(msg : @cmd.Emit[@url.Url]) -> Sub {
  custom_sub("on_url_changed", Global, UrlChanged(msg), builtin_sub_loader)
}

///|
/// Subscribe to captured navigation requests from `@html.a(...)`.
///
/// This is an app-scoped subscription. It is only active when returned from
/// the root cell's `subscriptions` callback; if a non-root cell returns it,
/// the subscription is ignored.
pub fn on_url_request(msg : @cmd.Emit[@url.UrlRequest]) -> Sub {
  custom_sub("on_url_request", Global, UrlRequest(msg), builtin_sub_loader)
}

///|
/// A subscription that does nothing.
pub let none : Sub = Batch([])

///|
/// Combine multiple subscriptions into one.
///
/// If multiple subscriptions use the same internal key, the later one wins.
pub fn batch(xs : Array[Sub]) -> Sub {
  Batch(xs)
}
