///|
const HoverCardRootStyle : String = "display:contents"

///|
const HoverCardContentStyle : String = "position:fixed;inset:auto;left:var(--rui-floating-left,auto);top:var(--rui-floating-top,auto);z-index:50;display:block;width:16rem;max-width:calc(100vw - 1rem);transform-origin:var(--rui-floating-transform-origin,center);margin:0;border:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-popover,oklch(1 0 0));padding:1rem;color:var(--rui-popover-foreground,oklch(0.145 0 0));font-size:0.875rem;line-height:1.25rem;box-shadow:0 4px 6px -1px rgb(0 0 0 / 0.1),0 2px 4px -2px rgb(0 0 0 / 0.1);outline:none;transition:opacity 100ms ease,transform 100ms ease,visibility 100ms ease"

///|
fn hover_card_delay(value : Int) -> Int {
  if value < 0 {
    0
  } else {
    value
  }
}

///|
fn hover_card_trigger_adjustment_style(variant : ButtonVariant) -> String {
  match variant {
    Link =>
      "height:auto;padding:0;border:0;vertical-align:baseline;text-decoration-line:underline;text-decoration-thickness:from-font"
    _ => ""
  }
}

///|
/// Render the native link that owns hover-card interaction.
///
/// The stateful `hover_card` root wires hover and focus events. This standalone
/// part exposes the same state, delay, and relationship attributes for custom
/// composition without requiring a stylesheet.
pub fn[C : @html.IsChildren] hover_card_trigger(
  content_id~ : String,
  href~ : String,
  open? : Bool = false,
  disabled? : Bool = false,
  open_delay? : Int = 600,
  close_delay? : Int = 300,
  variant? : ButtonVariant = Link,
  size? : ButtonSize = Default,
  target? : @html.Target = Self,
  rel? : String,
  download? : String,
  escape? : Bool = false,
  on_click? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let resolved_id = id.unwrap_or(content_id + "-trigger")
  let actual_open_delay = hover_card_delay(open_delay)
  let actual_close_delay = hover_card_delay(close_delay)
  let element_attrs = popup_state_attrs(attrs, "hover-card-trigger", open)
    .data_set("variant", button_variant_value(variant))
    .data_set("size", button_size_value(size))
    .data_set("delay", "\{actual_open_delay}")
    .data_set("close-delay", "\{actual_close_delay}")
    .aria_expanded(ui_bool(open))
    .aria_controls(content_id)
  if open {
    ignore(element_attrs.data_set("popup-open", ""))
  }
  if disabled {
    ignore(
      element_attrs.aria_disabled("true").tabindex(-1).data_set("disabled", ""),
    )
  }
  if !disabled && on_click is Some(command) {
    ignore(element_attrs.on_click_after(_ => command))
  }
  @html.a(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        ButtonBaseStyle,
        button_variant_style(variant),
        button_size_style(size),
        hover_card_trigger_adjustment_style(variant),
        ui_disabled_style(disabled),
        popup_anchor_style(resolved_id),
      ],
      style,
    ),
    id=resolved_id,
    class?,
    title?,
    href~,
    target~,
    rel?,
    download?,
    attrs=element_attrs,
    children,
    escape~,
  )
}

///|
/// Render the shadcn Vega hover-card surface on the native Popover top layer.
///
/// `popover="auto"` supplies browser Escape and light-dismiss behavior. The
/// stateful root synchronizes those native changes back into Rabbita state.
pub fn[C : @html.IsChildren] hover_card_content(
  id~ : String,
  trigger_id~ : String,
  open? : Bool = false,
  side? : PopupSide = Bottom,
  align? : PopupAlign = Center,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  aria_labelledby? : String,
  aria_describedby? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = popup_state_attrs(attrs, "hover-card-content", open)
    .popover("auto")
    .tabindex(-1)
    .data_set("initial-focus", "false")
    .data_set("restore-focus", "false")
    .data_set("trigger-id", trigger_id)
    .data_set("requested-side", popup_side_value(side))
    .data_set("requested-align", popup_align_value(align))
    .data_set("side", popup_side_value(side))
    .data_set("align", popup_align_value(align))
    .data_set("side-offset", "\{side_offset}")
    .data_set("align-offset", "\{align_offset}")
    .data_set("collision-padding", "0")
    .data_set("sticky", "partial")
  if aria_labelledby is Some(labelledby) {
    ignore(element_attrs.aria_labelledby(labelledby))
  }
  if aria_describedby is Some(describedby) {
    ignore(element_attrs.aria_describedby(describedby))
  }
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        HoverCardContentStyle,
        PopupTransition100Style,
        popup_floating_anchor_style(
          trigger_id, side, align, side_offset, align_offset,
        ),
        popup_state_style(open),
      ],
      style,
    ),
    id~,
    class?,
    title?,
    attrs=element_attrs,
    children,
  )
}

///|
#cfg(target="js")
extern "js" fn ffi_bind_hover_card_events(
  id : String,
  dispatch : (Int, Int) -> Unit,
) -> Bool =
  #| (id, dispatch) => {
  #|   if (typeof document === "undefined") return false
  #|   const popup = document.getElementById(id)
  #|   const trigger = document.getElementById(id + "-trigger")
  #|   const root = document.getElementById(id + "-root")
  #|   if (!popup || !trigger || !root
  #|     || popup.isConnected === false
  #|     || trigger.isConnected === false
  #|     || root.isConnected === false) return false
  #|   root.__ruiHoverCardDispatch = dispatch
  #|   if (root.__ruiHoverCardBound) return true
  #|   root.__ruiHoverCardBound = true
  #|   const numberConfig = (triggerName, rootName, fallback) => {
  #|     const own = trigger.dataset[triggerName]
  #|     const inherited = root.dataset[rootName]
  #|     const parsed = Number(own !== undefined ? own : inherited)
  #|     return Number.isFinite(parsed) ? Math.max(0, parsed) : fallback
  #|   }
  #|   const openDelay = () => numberConfig("delay", "openDelay", 600)
  #|   const closeDelay = () => numberConfig("closeDelay", "closeDelay", 300)
  #|   const send = (kind, wait = 0) => {
  #|     if (root.hasAttribute("data-disabled") || !root.__ruiHoverCardDispatch) return
  #|     root.__ruiHoverCardDispatch(kind, wait)
  #|   }
  #|   trigger.addEventListener("mouseenter", () => {
  #|     send(0, openDelay())
  #|   })
  #|   trigger.addEventListener("mouseleave", () => {
  #|     const hoverGrace = root.dataset.hoverable === "true" ? 100 : 0
  #|     send(1, Math.max(closeDelay(), hoverGrace))
  #|   })
  #|   trigger.addEventListener("focus", () => {
  #|     let focusVisible = true
  #|     try {
  #|       focusVisible = typeof trigger.matches !== "function"
  #|         || trigger.matches(":focus-visible")
  #|     } catch (_) {
  #|     }
  #|     if (focusVisible) send(2, openDelay())
  #|   })
  #|   trigger.addEventListener("blur", () => {
  #|     send(3, closeDelay())
  #|   })
  #|   trigger.addEventListener("click", event => {
  #|     if (root.hasAttribute("data-disabled")) {
  #|       event.preventDefault()
  #|       event.stopPropagation()
  #|     }
  #|   })
  #|   popup.addEventListener("mouseenter", () => {
  #|     if (root.dataset.hoverable === "true") send(4, 0)
  #|   })
  #|   popup.addEventListener("mouseleave", () => {
  #|     if (root.dataset.hoverable === "true") send(5, closeDelay())
  #|   })
  #|   popup.addEventListener("focusin", () => {
  #|     send(6, 0)
  #|   })
  #|   popup.addEventListener("focusout", event => {
  #|     if (!popup.contains(event.relatedTarget)) send(7, closeDelay())
  #|   })
  #|   return true
  #| }

///|
#cfg(target="js")
priv struct HoverCardModel {
  open : Bool
  trigger_hovered : Bool
  trigger_focused : Bool
  content_hovered : Bool
  content_focused : Bool
  generation : Int
} derive(Eq)

///|
#cfg(target="js")
priv enum HoverCardMsg {
  HoverCardDomEvent(Int, Int)
  HoverCardOpenAfter(Int)
  HoverCardCloseAfter(Int)
  HoverCardNativeChanged(Bool)
}

///|
#cfg(target="js")
fn hover_card_is_active(model : HoverCardModel) -> Bool {
  model.trigger_hovered ||
  model.trigger_focused ||
  model.content_hovered ||
  model.content_focused
}

///|
#cfg(target="js")
fn hover_card_notify_cmd(
  on_open_change : @cmd.Emit[Bool]?,
  open : Bool,
) -> @cmd.Cmd {
  if on_open_change is Some(notify) {
    notify(open)
  } else {
    @cmd.none
  }
}

///|
#cfg(target="js")
fn hover_card_commit_open(
  id : String,
  on_open_change : @cmd.Emit[Bool]?,
  model : HoverCardModel,
  open : Bool,
) -> (HoverCardModel, @cmd.Cmd) {
  if model.open == open {
    (model, @cmd.none)
  } else {
    (
      { ..model, open, },
      @cmd.batch([
        floating_set_open_cmd(id, open),
        hover_card_notify_cmd(on_open_change, open),
      ]),
    )
  }
}

///|
#cfg(target="js")
fn hover_card_commit_native(
  on_open_change : @cmd.Emit[Bool]?,
  model : HoverCardModel,
  open : Bool,
) -> (HoverCardModel, @cmd.Cmd) {
  if open {
    if model.open {
      (model, @cmd.none)
    } else {
      ({ ..model, open: true }, hover_card_notify_cmd(on_open_change, true))
    }
  } else {
    let next : HoverCardModel = {
      open: false,
      trigger_hovered: false,
      trigger_focused: false,
      content_hovered: false,
      content_focused: false,
      generation: model.generation + 1,
    }
    if model.open {
      (next, hover_card_notify_cmd(on_open_change, false))
    } else {
      (next, @cmd.none)
    }
  }
}

///|
#cfg(target="js")
fn hover_card_bind_events_cmd(
  id : String,
  emit : @cmd.Emit[HoverCardMsg],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, scheduler => {
    ui_after_ready("hover-card-events:" + id, () => {
      ffi_bind_hover_card_events(id, (kind, wait) => {
        scheduler.add(emit(HoverCardDomEvent(kind, wait)))
      })
    })
  })
}

///|
#cfg(target="js")
fn hover_card_open_from_interaction(
  id : String,
  on_open_change : @cmd.Emit[Bool]?,
  emit : @cmd.Emit[HoverCardMsg],
  current : HoverCardModel,
  next : HoverCardModel,
  wait : Int,
) -> (HoverCardModel, @cmd.Cmd) {
  if current.open {
    (next, @cmd.none)
  } else if wait <= 0 {
    hover_card_commit_open(id, on_open_change, next, true)
  } else {
    (next, @cmd.delay(emit(HoverCardOpenAfter(next.generation)), wait))
  }
}

///|
#cfg(target="js")
fn hover_card_close_from_interaction(
  id : String,
  on_open_change : @cmd.Emit[Bool]?,
  emit : @cmd.Emit[HoverCardMsg],
  next : HoverCardModel,
  wait : Int,
) -> (HoverCardModel, @cmd.Cmd) {
  if hover_card_is_active(next) || !next.open {
    (next, @cmd.none)
  } else if wait <= 0 {
    hover_card_commit_open(id, on_open_change, next, false)
  } else {
    (next, @cmd.delay(emit(HoverCardCloseAfter(next.generation)), wait))
  }
}

///|
#cfg(target="js")
fn hover_card_update(
  id : String,
  on_open_change : @cmd.Emit[Bool]?,
  emit : @cmd.Emit[HoverCardMsg],
  msg : HoverCardMsg,
  current : HoverCardModel,
) -> (HoverCardModel, @cmd.Cmd) {
  match msg {
    HoverCardDomEvent(kind, wait) =>
      match kind {
        // Trigger hover opens after the configured delay.
        0 => {
          let next = {
            ..current,
            trigger_hovered: true,
            generation: current.generation + 1,
          }
          hover_card_open_from_interaction(
            id, on_open_change, emit, current, next, wait,
          )
        }
        1 => {
          let next = {
            ..current,
            trigger_hovered: false,
            generation: current.generation + 1,
          }
          hover_card_close_from_interaction(
            id, on_open_change, emit, next, wait,
          )
        }
        // Keyboard focus uses the same opening delay as pointer hover.
        2 => {
          let next = {
            ..current,
            trigger_focused: true,
            generation: current.generation + 1,
          }
          hover_card_open_from_interaction(
            id, on_open_change, emit, current, next, wait,
          )
        }
        3 => {
          let next = {
            ..current,
            trigger_focused: false,
            generation: current.generation + 1,
          }
          hover_card_close_from_interaction(
            id, on_open_change, emit, next, wait,
          )
        }
        // Hovering or focusing the popup invalidates a pending close.
        4 =>
          (
            {
              ..current,
              content_hovered: true,
              generation: current.generation + 1,
            },
            @cmd.none,
          )
        5 => {
          let next = {
            ..current,
            content_hovered: false,
            generation: current.generation + 1,
          }
          hover_card_close_from_interaction(
            id, on_open_change, emit, next, wait,
          )
        }
        6 =>
          (
            {
              ..current,
              content_focused: true,
              generation: current.generation + 1,
            },
            @cmd.none,
          )
        7 => {
          let next = {
            ..current,
            content_focused: false,
            generation: current.generation + 1,
          }
          hover_card_close_from_interaction(
            id, on_open_change, emit, next, wait,
          )
        }
        // Native light-dismiss synchronizes through HoverCardNativeChanged.
        _ =>
          hover_card_commit_open(
            id,
            on_open_change,
            {
              ..current,
              trigger_hovered: false,
              trigger_focused: false,
              content_hovered: false,
              content_focused: false,
              generation: current.generation + 1,
            },
            false,
          )
      }
    HoverCardOpenAfter(generation) =>
      if generation == current.generation && hover_card_is_active(current) {
        hover_card_commit_open(id, on_open_change, current, true)
      } else {
        (current, @cmd.none)
      }
    HoverCardCloseAfter(generation) =>
      if generation == current.generation && !hover_card_is_active(current) {
        hover_card_commit_open(id, on_open_change, current, false)
      } else {
        (current, @cmd.none)
      }
    HoverCardNativeChanged(open) =>
      hover_card_commit_native(on_open_change, current, open)
  }
}

///|
fn[T : @html.IsChildren, C : @html.IsChildren] render_hover_card(
  id : String,
  href : String,
  target : @html.Target,
  rel : String?,
  download : String?,
  escape : Bool,
  open : Bool,
  disabled : Bool,
  open_delay : Int,
  close_delay : Int,
  hoverable : Bool,
  side : PopupSide,
  align : PopupAlign,
  side_offset : Int,
  align_offset : Int,
  trigger_variant : ButtonVariant,
  trigger_size : ButtonSize,
  aria_labelledby : String?,
  aria_describedby : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  trigger_attrs : @html.Attrs?,
  trigger_style : Array[String],
  content_attrs : @html.Attrs?,
  content_style : Array[String],
  on_trigger_click : @cmd.Cmd?,
  trigger : T,
  content : C,
) -> @html.Html {
  let root_id = id + "-root"
  let trigger_id = id + "-trigger"
  let root_attrs = popup_state_attrs(attrs, "hover-card", open)
    .data_set("open-delay", "\{open_delay}")
    .data_set("close-delay", "\{close_delay}")
    .data_set("hoverable", ui_bool(hoverable))
  if disabled {
    ignore(root_attrs.data_set("disabled", "").aria_disabled("true"))
  }
  let link_attrs = trigger_attrs
  let popup_attrs = content_attrs
  @html.div(
    style=ui_styles([UiBoxSizing, HoverCardRootStyle], style),
    id=root_id,
    attrs=root_attrs,
    [
      hover_card_trigger(
        content_id=id,
        href~,
        open~,
        disabled~,
        open_delay~,
        close_delay~,
        variant=trigger_variant,
        size=trigger_size,
        target~,
        rel?,
        download?,
        escape~,
        on_click?=on_trigger_click,
        id=trigger_id,
        attrs?=link_attrs,
        style=trigger_style,
        trigger,
      ),
      hover_card_content(
        id~,
        trigger_id~,
        open~,
        side~,
        align~,
        side_offset~,
        align_offset~,
        aria_labelledby?,
        aria_describedby?,
        attrs?=popup_attrs,
        style=content_style,
        content,
      ),
    ],
  )
}

///|
/// Build a black-box hover card with Rabbita-owned incremental state.
///
/// Pointer hover, keyboard focus, configurable opening/closing delays,
/// hoverable content, Escape, outside press, native light-dismiss, and floating
/// positioning are handled internally. All Vega styling is inline.
#cfg(target="js")
pub fn[T : @html.IsChildren, C : @html.IsChildren] hover_card(
  id~ : String,
  href? : String = "#",
  target? : @html.Target = Self,
  rel? : String,
  download? : String,
  escape? : Bool = false,
  default_open? : Bool = false,
  disabled? : Bool = false,
  open_delay? : Int = 600,
  close_delay? : Int = 300,
  hoverable? : Bool = true,
  side? : PopupSide = Bottom,
  align? : PopupAlign = Center,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  trigger_variant? : ButtonVariant = Link,
  trigger_size? : ButtonSize = Default,
  aria_labelledby? : String,
  aria_describedby? : String,
  on_open_change? : @cmd.Emit[Bool],
  on_trigger_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  trigger_attrs? : @html.Attrs,
  trigger_style? : Array[String] = [],
  content_attrs? : @html.Attrs,
  content_style? : Array[String] = [],
  trigger : T,
  content : C,
) -> @rabbita.Val[@html.Html] {
  let actual_open_delay = hover_card_delay(open_delay)
  let actual_close_delay = hover_card_delay(close_delay)
  let initial_open = default_open && !disabled
  let initial_model : HoverCardModel = {
    open: initial_open,
    trigger_hovered: false,
    trigger_focused: false,
    content_hovered: false,
    content_focused: false,
    generation: 0,
  }
  let (model, _) = @rabbita.create_state_with_init(
    init=emit => {
      let sync = emit.map(value => HoverCardNativeChanged(value))
      (
        initial_model,
        @cmd.batch([
          floating_bind_sync_cmd(id, sync),
          hover_card_bind_events_cmd(id, emit),
          if initial_open {
            floating_set_open_cmd(id, true)
          } else {
            @cmd.none
          },
        ]),
      )
    },
    update=(emit, msg, current) => {
      hover_card_update(id, on_open_change, emit, msg, current)
    },
  )
  model.view(model => {
    render_hover_card(
      id,
      href,
      target,
      rel,
      download,
      escape,
      model.open,
      disabled,
      actual_open_delay,
      actual_close_delay,
      hoverable,
      side,
      align,
      side_offset,
      align_offset,
      trigger_variant,
      trigger_size,
      aria_labelledby,
      aria_describedby,
      attrs,
      style,
      trigger_attrs,
      trigger_style,
      content_attrs,
      content_style,
      on_trigger_click,
      trigger,
      content,
    )
  })
}

///|
/// Native/SSR fallback: retain the same API and render the normalized initial
/// state as a constant incremental value.
#cfg(not(target="js"))
pub fn[T : @html.IsChildren, C : @html.IsChildren] hover_card(
  id~ : String,
  href? : String = "#",
  target? : @html.Target = Self,
  rel? : String,
  download? : String,
  escape? : Bool = false,
  default_open? : Bool = false,
  disabled? : Bool = false,
  open_delay? : Int = 600,
  close_delay? : Int = 300,
  hoverable? : Bool = true,
  side? : PopupSide = Bottom,
  align? : PopupAlign = Center,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  trigger_variant? : ButtonVariant = Link,
  trigger_size? : ButtonSize = Default,
  aria_labelledby? : String,
  aria_describedby? : String,
  on_open_change? : @cmd.Emit[Bool],
  on_trigger_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  trigger_attrs? : @html.Attrs,
  trigger_style? : Array[String] = [],
  content_attrs? : @html.Attrs,
  content_style? : Array[String] = [],
  trigger : T,
  content : C,
) -> @rabbita.Val[@html.Html] {
  ignore(on_open_change)
  @rabbita.Val::constant(
    render_hover_card(
      id,
      href,
      target,
      rel,
      download,
      escape,
      default_open && !disabled,
      disabled,
      hover_card_delay(open_delay),
      hover_card_delay(close_delay),
      hoverable,
      side,
      align,
      side_offset,
      align_offset,
      trigger_variant,
      trigger_size,
      aria_labelledby,
      aria_describedby,
      attrs,
      style,
      trigger_attrs,
      trigger_style,
      content_attrs,
      content_style,
      on_trigger_click,
      trigger,
      content,
    ),
  )
}
