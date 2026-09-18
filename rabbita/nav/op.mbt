///|
extenum @cmd.Extension += {
  NavBack
  NavForward
  NavLoad(String)
  NavReload
  NavPushUrl(String)
  NavReplaceUrl(String)
  NavScrollToPos(Double, Double, ScrollBehavior)
  NavScrollByPos(Double, Double, ScrollBehavior)
  NavScrollTo(String, ScrollBehavior)
  NavScrollToTop(ScrollBehavior)
  NavScrollToBottom(ScrollBehavior)
}

///|
fn scroll_behavior_repr(behavior : ScrollBehavior) -> Repr {
  match behavior {
    Auto => Repr::ctor("Auto", [])
    Instant => Repr::ctor("Instant", [])
    Smooth => Repr::ctor("Smooth", [])
  }
}

///|
let op : @cmd.Op = @cmd.Op()
  ..on_invoke(op_invoke)
  ..on_debug(extension => {
    match extension {
      NavBack => Repr::ctor("NavBack", [])
      NavForward => Repr::ctor("NavForward", [])
      NavLoad(url) => Repr::ctor("NavLoad", [(None, Repr(url))])
      NavReload => Repr::ctor("NavReload", [])
      NavPushUrl(url) => Repr::ctor("NavPushUrl", [(None, Repr(url))])
      NavReplaceUrl(url) => Repr::ctor("NavReplaceUrl", [(None, Repr(url))])
      NavScrollToPos(x, y, behavior) =>
        Repr::ctor("NavScrollToPos", [
          (None, Repr(x)),
          (None, Repr(y)),
          (None, scroll_behavior_repr(behavior)),
        ])
      NavScrollByPos(x, y, behavior) =>
        Repr::ctor("NavScrollByPos", [
          (None, Repr(x)),
          (None, Repr(y)),
          (None, scroll_behavior_repr(behavior)),
        ])
      NavScrollTo(element, behavior) =>
        Repr::ctor("NavScrollTo", [
          (None, Repr(element)),
          (None, scroll_behavior_repr(behavior)),
        ])
      NavScrollToTop(behavior) =>
        Repr::ctor("NavScrollToTop", [(None, scroll_behavior_repr(behavior))])
      NavScrollToBottom(behavior) =>
        Repr::ctor("NavScrollToBottom", [(None, scroll_behavior_repr(behavior))])
      _ => raise Unhandled
    }
  })

///|
#cfg(target="js")
fn op_invoke(
  extension : @cmd.Extension,
  context : &@cmd.Context,
) -> @cmd.OpCont[Cmd] raise @cmd.Unhandled {
  match extension {
    NavBack => {
      @dom.window().history_go_back()
      None
    }
    NavForward => {
      @dom.window().history_go_forward()
      None
    }
    NavLoad(url) => {
      @dom.window().load_url(url)
      None
    }
    NavReload => {
      @dom.window().reload_url()
      None
    }
    NavPushUrl(url) => {
      @dom.window().push_url(url)
      let normalized_url = @dom.window().current_url()
      Ready(context.inject_url_changed(normalized_url))
    }
    NavReplaceUrl(url) => {
      @dom.window().replace_url(url)
      let normalized_url = @dom.window().current_url()
      Ready(context.inject_url_changed(normalized_url))
    }
    NavScrollToPos(x, y, behavior) =>
      AfterLayout(() => {
        @dom.window().scroll_to(x, y, behavior=Show::to_string(behavior))
        @cmd.none
      })
    NavScrollByPos(x, y, behavior) =>
      AfterLayout(() => {
        @dom.window().scroll_by(x, y, behavior=Show::to_string(behavior))
        @cmd.none
      })
    NavScrollTo(element, behavior) =>
      AfterLayout(() => {
        if @dom.document().get_element_by_id(element).to_option() is Some(node) {
          node.scroll_into_view(behavior=Show::to_string(behavior))
        }
        @cmd.none
      })
    NavScrollToTop(behavior) =>
      AfterLayout(() => {
        @dom.window().scroll_to_top(behavior=Show::to_string(behavior))
        @cmd.none
      })
    NavScrollToBottom(behavior) =>
      AfterLayout(() => {
        @dom.window().scroll_to_bottom(behavior=Show::to_string(behavior))
        @cmd.none
      })
    _ => raise Unhandled
  }
}

///|
#cfg(not(target="js"))
#warnings("-unused_error_type")
fn op_invoke(
  _ : @cmd.Extension,
  _context : &@cmd.Context,
) -> @cmd.OpCont[Cmd] raise @cmd.Unhandled {
  None
}
