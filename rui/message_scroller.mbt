///|
pub(all) enum MessageScrollDirection {
  ScrollStart
  ScrollEnd
} derive(Debug, Eq)

///|
priv struct MessageScrollerPosition {
  at_start : Bool
  at_end : Bool
} derive(Eq)

///|
priv enum MessageScrollerMsg {
  SetScrollerPosition(Bool, Bool)
}

///|
/// Opaque render scope owned by `message_scroller`.
struct MessageScrollerScope {
  viewport_id : String
  position : MessageScrollerPosition
  emit : @cmd.Emit[MessageScrollerMsg]
}

///|
#cfg(target="js")
fn message_scroller_initialize_cmd(
  viewport_id : String,
  scroll_to_end : Bool,
  emit : @cmd.Emit[MessageScrollerMsg],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=AfterRender, scheduler => {
    ui_after_mount(
      viewport_id,
      () => {
        if @dom.document().get_element_by_id(viewport_id).to_option()
          is Some(element) {
          if scroll_to_end {
            element.set_scroll_top(element.get_scroll_height())
          }
          let top = element.get_scroll_top()
          let height = element.get_bounding_client_rect().get_height()
          let total = element.get_scroll_height()
          scheduler.add(
            emit(SetScrollerPosition(top <= 1.0, top + height >= total - 1.0)),
          )
        }
      },
      purpose="message-scroller-initialize",
    )
  })
}

///|
fn[C : @html.IsChildren] render_message_scroller(
  scope : MessageScrollerScope,
  id : String?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : (MessageScrollerScope) -> C,
) -> @html.Html {
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "message-scroller"),
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        "position:relative;display:flex;width:100%;height:100%;min-height:0;flex-direction:column;overflow:hidden",
      ],
      style,
    ),
    children(scope),
  )
}

///|
#cfg(target="js")
pub fn[C : @html.IsChildren] message_scroller(
  id~ : String,
  default_at_end? : Bool = true,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (MessageScrollerScope) -> C,
) -> @rabbita.Val[@html.Html] {
  let viewport_id = "\{id}-viewport"
  let initial = { at_start: !default_at_end, at_end: default_at_end, }
  let (position, emit) = @rabbita.create_state_with_init(
    init=emit => {
      (
        initial,
        message_scroller_initialize_cmd(viewport_id, default_at_end, emit),
      )
    },
    update=(_, msg, _) => {
      (
        match msg {
          SetScrollerPosition(at_start, at_end) => { at_start, at_end, }
        },
        @cmd.none,
      )
    },
  )
  position.view(position => {
    render_message_scroller(
      { viewport_id, position, emit, },
      Some(id),
      class,
      title,
      attrs,
      style,
      children,
    )
  })
}

///|
#cfg(not(target="js"))
pub fn[C : @html.IsChildren] message_scroller(
  id~ : String,
  default_at_end? : Bool = true,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (MessageScrollerScope) -> C,
) -> @rabbita.Val[@html.Html] {
  let position = { at_start: !default_at_end, at_end: default_at_end, }
  let emit = @cmd.Emit(_ => @cmd.none)
  @rabbita.Val::constant(
    render_message_scroller(
      { viewport_id: "\{id}-viewport", position, emit, },
      Some(id),
      class,
      title,
      attrs,
      style,
      children,
    ),
  )
}

///|
#cfg(target="js")
fn message_scroller_viewport_attrs(
  scope : MessageScrollerScope,
  attrs : @html.Attrs?,
) -> @html.Attrs {
  ui_attrs(attrs).on_scroll(event => {
    if event.current_target().to_option() is Some(target) &&
      target.to_element() is Some(element) {
      let top = element.get_scroll_top()
      let height = element.get_bounding_client_rect().get_height()
      let total = element.get_scroll_height()
      (scope.emit)(SetScrollerPosition(top <= 1.0, top + height >= total - 1.0))
    } else {
      @cmd.none
    }
  })
}

///|
#cfg(not(target="js"))
fn message_scroller_viewport_attrs(
  _ : MessageScrollerScope,
  attrs : @html.Attrs?,
) -> @html.Attrs {
  ui_attrs(attrs)
}

///|
pub fn[C : @html.IsChildren] message_scroller_viewport(
  scope~ : MessageScrollerScope,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = message_scroller_viewport_attrs(scope, attrs)
    .data_set("slot", "message-scroller-viewport")
    .data_set("at-start", ui_bool(scope.position.at_start))
    .data_set("at-end", ui_bool(scope.position.at_end))
    .tabindex(0)
  @html.div(
    id=id.unwrap_or(scope.viewport_id),
    class?,
    title?,
    attrs=element_attrs,
    style=ui_styles(
      [
        UiBoxSizing,
        "width:100%;height:100%;min-width:0;min-height:0;overflow-y:auto;overscroll-behavior:contain;scrollbar-gutter:stable;scrollbar-width:thin;contain:content;outline-offset:2px",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] message_scroller_content(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "message-scroller-content"),
    style=ui_styles(
      [
        "display:flex;height:max-content;min-height:100%;flex-direction:column;gap:2rem",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] message_scroller_item(
  scroll_anchor? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "message-scroller-item")
      .data_set("scroll-anchor", ui_bool(scroll_anchor)),
    style=ui_styles(
      [
        "min-width:0;flex-shrink:0;content-visibility:auto;contain-intrinsic-size:auto 10rem",
        if scroll_anchor {
          "overflow-anchor:auto"
        } else {
          "overflow-anchor:none"
        },
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] message_scroller_button(
  scope~ : MessageScrollerScope,
  direction? : MessageScrollDirection = ScrollEnd,
  label? : String,
  variant? : ButtonVariant = Secondary,
  size? : ButtonSize = IconSm,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let end_ = direction is ScrollEnd
  let active = if end_ {
    !scope.position.at_end
  } else {
    !scope.position.at_start
  }
  let direction_value = if end_ { "end" } else { "start" }
  let button_attrs = ui_attrs(attrs)
    .data_set("slot", "message-scroller-button")
    .data_set("direction", direction_value)
    .data_set("active", ui_bool(active))
  if label is Some(label) {
    ignore(button_attrs.aria_label(label))
  }
  button(
    variant~,
    size~,
    disabled=!active,
    slot="message-scroller-button",
    on_click=ui_scroll_id(scope.viewport_id, end_),
    id?,
    class?,
    title?,
    attrs=button_attrs,
    style=ui_styles(
      [
        "position:absolute;left:50%;z-index:10;transform:translate(-50%,var(--rui-message-scroller-shift,0)) scale(var(--rui-message-scroller-scale,1));transition:transform 200ms cubic-bezier(0.23,1,0.32,1),opacity 200ms cubic-bezier(0.23,1,0.32,1);--rui-button-base-border:var(--rui-border,oklch(0.922 0 0));--rui-button-base-bg:var(--rui-background,white);--rui-button-base-fg:var(--rui-foreground,oklch(0.145 0 0))",
        if end_ {
          "bottom:1rem"
        } else {
          "top:1rem"
        },
        if active {
          "--rui-message-scroller-shift:0;--rui-message-scroller-scale:1;opacity:1"
        } else if end_ {
          "--rui-message-scroller-shift:100%;--rui-message-scroller-scale:0.95;opacity:0;transition-duration:400ms;transition-timing-function:cubic-bezier(0.7,0,0.84,0)"
        } else {
          "--rui-message-scroller-shift:-100%;--rui-message-scroller-scale:0.95;opacity:0;transition-duration:400ms;transition-timing-function:cubic-bezier(0.7,0,0.84,0)"
        },
      ],
      style,
    ),
    children,
  )
}
