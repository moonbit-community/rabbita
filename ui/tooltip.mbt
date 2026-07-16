///|
const TooltipProviderStyle : String = "display:contents"

///|
const TooltipRootStyle : String = "display:contents"

///|
const TooltipContentStyle : String = "position:fixed;inset:auto;left:var(--rui-floating-left,auto);top:var(--rui-floating-top,auto);z-index:50;display:flex;width:max-content;max-width:calc(100vw - 1rem);transform-origin:var(--rui-floating-transform-origin,center);align-items:center;margin:0;border:0;border-radius:calc(var(--rui-radius,0.625rem) - 0.25rem);background:var(--rui-primary,oklch(0.205 0 0));padding:0.375rem 0.75rem;color:var(--rui-primary-foreground,oklch(0.985 0 0));font-size:0.75rem;line-height:1rem;font-weight:400;text-wrap:balance;box-shadow:0 4px 6px -1px rgb(0 0 0 / 0.1),0 2px 4px -2px rgb(0 0 0 / 0.1);outline:none;transition:opacity 100ms ease,transform 100ms ease,visibility 100ms ease"

///|
const TooltipArrowBaseStyle : String = "position:absolute;z-index:-1;top:var(--rui-tooltip-arrow-top,auto);right:var(--rui-tooltip-arrow-right,auto);bottom:var(--rui-tooltip-arrow-bottom,auto);left:var(--rui-tooltip-arrow-left,auto);width:0.625rem;height:0.625rem;margin-top:var(--rui-tooltip-arrow-margin-top,0);margin-left:var(--rui-tooltip-arrow-margin-left,0);border-radius:2px;background:var(--rui-primary,oklch(0.205 0 0));transform:rotate(45deg)"

///|
fn tooltip_delay(value : Int) -> Int {
  if value < 0 {
    0
  } else {
    value
  }
}

///|
fn tooltip_arrow_side_style(side : PopupSide) -> String {
  match side {
    Top =>
      "--rui-tooltip-arrow-top:auto;--rui-tooltip-arrow-right:auto;--rui-tooltip-arrow-bottom:-0.25rem;--rui-tooltip-arrow-left:50%;--rui-tooltip-arrow-margin-top:0;--rui-tooltip-arrow-margin-left:-0.3125rem"
    Right =>
      "--rui-tooltip-arrow-top:50%;--rui-tooltip-arrow-right:auto;--rui-tooltip-arrow-bottom:auto;--rui-tooltip-arrow-left:-0.25rem;--rui-tooltip-arrow-margin-top:-0.3125rem;--rui-tooltip-arrow-margin-left:0"
    Bottom =>
      "--rui-tooltip-arrow-top:-0.25rem;--rui-tooltip-arrow-right:auto;--rui-tooltip-arrow-bottom:auto;--rui-tooltip-arrow-left:50%;--rui-tooltip-arrow-margin-top:0;--rui-tooltip-arrow-margin-left:-0.3125rem"
    Left =>
      "--rui-tooltip-arrow-top:50%;--rui-tooltip-arrow-right:-0.25rem;--rui-tooltip-arrow-bottom:auto;--rui-tooltip-arrow-left:auto;--rui-tooltip-arrow-margin-top:-0.3125rem;--rui-tooltip-arrow-margin-left:0"
  }
}

///|
/// Supply shared open and close delays to descendant tooltips.
///
/// shadcn's Vega preset opens without a wait, so `delay` defaults to zero.
/// `timeout` is the instant-phase window: moving between tooltips within
/// that period bypasses a non-zero opening delay. An individual `tooltip` can
/// override the opening or closing delay.
pub fn[C : @html.IsChildren] tooltip_provider(
  delay? : Int = 0,
  close_delay? : Int = 0,
  timeout? : Int = 400,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let actual_delay = tooltip_delay(delay)
  let actual_close_delay = tooltip_delay(close_delay)
  let actual_timeout = tooltip_delay(timeout)
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "tooltip-provider")
    .data_set("delay", "\{actual_delay}")
    .data_set("close-delay", "\{actual_close_delay}")
    .data_set("timeout", "\{actual_timeout}")
  @html.span(
    style=ui_styles([UiBoxSizing, TooltipProviderStyle], style),
    id?,
    class?,
    title?,
    attrs=element_attrs,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] tooltip_trigger(
  content_id~ : String,
  open? : Bool = false,
  disabled? : Bool = false,
  variant? : ButtonVariant = Ghost,
  size? : ButtonSize = Default,
  on_click? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let resolved_id = id.unwrap_or(content_id + "-trigger")
  let element_attrs = popup_state_attrs(attrs, "tooltip-trigger", open)
    .data_set("variant", button_variant_value(variant))
    .data_set("size", button_size_value(size))
  if open {
    ignore(element_attrs.aria_describedby(content_id))
  }
  if disabled {
    ignore(element_attrs.aria_disabled("true").data_set("disabled", ""))
  }
  if on_click is Some(command) {
    ignore(element_attrs.on_click_after(_ => command))
  }
  @html.button(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        ButtonBaseStyle,
        button_variant_style(variant),
        button_size_style(size),
        ui_disabled_style(disabled),
        popup_anchor_style(resolved_id),
      ],
      style,
    ),
    id=resolved_id,
    class?,
    title?,
    type_="button",
    disabled~,
    attrs=element_attrs,
    children,
  )
}

///|
pub fn tooltip_arrow(
  side? : PopupSide = Top,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  @html.span(
    style=ui_styles(
      [UiBoxSizing, TooltipArrowBaseStyle, tooltip_arrow_side_style(side)],
      style,
    ),
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "tooltip-arrow").aria_hidden("true"),
    @html.nothing,
  )
}

///|
pub fn[C : @html.IsChildren] tooltip_content(
  id~ : String,
  trigger_id~ : String,
  open? : Bool = false,
  side? : PopupSide = Top,
  align? : PopupAlign = Center,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  show_arrow? : Bool = true,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  arrow_attrs? : @html.Attrs,
  style? : Array[String] = [],
  arrow_style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = popup_state_attrs(attrs, "tooltip-content", open)
    .popover("manual")
    .role("tooltip")
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
  let body = @html.span(
    style=[UiBoxSizing, "display:contents"],
    attrs=@html.Attrs::build().data_set("slot", "tooltip-content-body"),
    children,
  )
  let content_children = if show_arrow {
    [
      body,
      @html.span(
        style=ui_styles([UiBoxSizing, TooltipArrowBaseStyle], arrow_style),
        attrs=ui_attrs(arrow_attrs)
          .data_set("slot", "tooltip-arrow")
          .aria_hidden("true"),
        @html.nothing,
      ),
    ]
  } else {
    [body]
  }
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        TooltipContentStyle,
        PopupTransition100Style,
        popup_floating_anchor_style(
          trigger_id, side, align, side_offset, align_offset,
        ),
        tooltip_arrow_side_style(side),
        popup_state_style(open),
      ],
      style,
    ),
    id~,
    class?,
    title?,
    attrs=element_attrs,
    content_children,
  )
}

///|
#cfg(target="js")
extern "js" fn ffi_bind_tooltip_events(
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
  #|   root.__ruiTooltipDispatch = dispatch
  #|   if (root.__ruiTooltipBound) return true
  #|   root.__ruiTooltipBound = true
  #|   const provider = () => root.closest('[data-slot="tooltip-provider"]')
  #|   const numberConfig = (name, fallback) => {
  #|     const own = root.dataset[name]
  #|     const inherited = provider()?.dataset[name]
  #|     const value = own !== undefined ? own : inherited
  #|     const parsed = Number(value)
  #|     return Number.isFinite(parsed) ? Math.max(0, parsed) : fallback
  #|   }
  #|   const now = () => typeof performance !== "undefined"
  #|     ? performance.now()
  #|     : Date.now()
  #|   const isOpen = item => {
  #|     if (!item || !item.isConnected) return false
  #|     if (typeof HTMLDialogElement !== "undefined"
  #|       && item instanceof HTMLDialogElement) return item.open
  #|     try {
  #|       if (item.matches(":popover-open")) return true
  #|     } catch (_) {
  #|     }
  #|     return Boolean(item.__ruiFloatingOpen)
  #|   }
  #|   const openDelay = () => {
  #|     const configured = numberConfig("delay", 0)
  #|     const group = provider()
  #|     if (!group || configured <= 0) return configured
  #|     const timeout = Math.max(0, Number(group.dataset.timeout || 400))
  #|     const hasOpenTooltip = Array.from(
  #|       group.querySelectorAll('[data-slot="tooltip-content"]'),
  #|     ).some(isOpen)
  #|     const lastClose = Number(group.__ruiTooltipLastClose)
  #|     const inInstantPhase = Number.isFinite(lastClose)
  #|       && now() - lastClose <= timeout
  #|     return hasOpenTooltip || inInstantPhase ? 0 : configured
  #|   }
  #|   const topFloating = () => {
  #|     const stack = globalThis.__ruiFloatingStack ||= []
  #|     for (let index = stack.length - 1; index >= 0; index -= 1) {
  #|       const item = document.getElementById(stack[index])
  #|       if (isOpen(item)) return item
  #|       stack.splice(index, 1)
  #|     }
  #|     return null
  #|   }
  #|   const send = (kind, wait = 0) => {
  #|     if (trigger.disabled || !root.__ruiTooltipDispatch) return
  #|     root.__ruiTooltipDispatch(kind, wait)
  #|   }
  #|   trigger.addEventListener("mouseenter", () => {
  #|     send(0, openDelay())
  #|   })
  #|   trigger.addEventListener("mouseleave", () => {
  #|     const hoverGrace = root.dataset.hoverable === "true" ? 80 : 0
  #|     send(1, Math.max(numberConfig("closeDelay", 0), hoverGrace))
  #|   })
  #|   trigger.addEventListener("focus", () => {
  #|     const focusVisible = typeof trigger.matches !== "function"
  #|       || trigger.matches(":focus-visible")
  #|     if (focusVisible) send(2, 0)
  #|   })
  #|   trigger.addEventListener("blur", () => {
  #|     send(3, numberConfig("closeDelay", 0))
  #|   })
  #|   trigger.addEventListener("click", () => {
  #|     if (root.dataset.closeOnClick === "true") send(4, 0)
  #|   })
  #|   popup.addEventListener("mouseenter", () => {
  #|     if (root.dataset.hoverable === "true") send(5, 0)
  #|   })
  #|   popup.addEventListener("mouseleave", () => {
  #|     if (root.dataset.hoverable === "true") {
  #|       send(6, numberConfig("closeDelay", 0))
  #|     }
  #|   })
  #|   if (!document.__ruiTooltipEscapeBound) {
  #|     document.__ruiTooltipEscapeBound = true
  #|     document.addEventListener("keydown", event => {
  #|       if (event.key !== "Escape" || event.defaultPrevented) return
  #|       const popup = topFloating()
  #|       if (!popup || popup.dataset.slot !== "tooltip-content") return
  #|       const owner = popup.closest('[data-slot="tooltip"]')
  #|       if (!owner?.__ruiTooltipDispatch) return
  #|       event.preventDefault()
  #|       event.stopPropagation()
  #|       owner.__ruiTooltipDispatch(7, 0)
  #|     })
  #|     document.addEventListener("pointerdown", event => {
  #|       if (event.defaultPrevented) return
  #|       const popup = topFloating()
  #|       if (!popup || popup.dataset.slot !== "tooltip-content") return
  #|       const owner = popup.closest('[data-slot="tooltip"]')
  #|       const reference = document.getElementById(popup.dataset.triggerId || "")
  #|       const path = typeof event.composedPath === "function" ? event.composedPath() : []
  #|       if (popup.contains(event.target) || reference?.contains(event.target)
  #|         || path.includes(popup) || (reference && path.includes(reference))) return
  #|       owner?.__ruiTooltipDispatch?.(8, 0)
  #|     })
  #|   }
  #|   return true
  #| }

///|
#cfg(target="js")
priv struct TooltipModel {
  open : Bool
  trigger_hovered : Bool
  trigger_focused : Bool
  content_hovered : Bool
  generation : Int
} derive(Eq)

///|
#cfg(target="js")
priv enum TooltipMsg {
  TooltipDomEvent(Int, Int)
  TooltipOpenAfter(Int)
  TooltipCloseAfter(Int)
  TooltipNativeChanged(Bool)
}

///|
#cfg(target="js")
fn tooltip_is_active(model : TooltipModel) -> Bool {
  model.trigger_hovered || model.trigger_focused || model.content_hovered
}

///|
#cfg(target="js")
fn tooltip_notify_cmd(
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
fn tooltip_commit_open(
  id : String,
  on_open_change : @cmd.Emit[Bool]?,
  model : TooltipModel,
  open : Bool,
) -> (TooltipModel, @cmd.Cmd) {
  if model.open == open {
    (model, @cmd.none)
  } else {
    (
      { ..model, open, },
      @cmd.batch([
        floating_set_open_cmd(id, open),
        tooltip_notify_cmd(on_open_change, open),
      ]),
    )
  }
}

///|
#cfg(target="js")
fn tooltip_commit_native(
  on_open_change : @cmd.Emit[Bool]?,
  model : TooltipModel,
  open : Bool,
) -> (TooltipModel, @cmd.Cmd) {
  if open {
    if model.open {
      (model, @cmd.none)
    } else {
      ({ ..model, open: true }, tooltip_notify_cmd(on_open_change, true))
    }
  } else {
    let next : TooltipModel = {
      open: false,
      trigger_hovered: false,
      trigger_focused: false,
      content_hovered: false,
      generation: model.generation + 1,
    }
    if model.open {
      (next, tooltip_notify_cmd(on_open_change, false))
    } else {
      (next, @cmd.none)
    }
  }
}

///|
#cfg(target="js")
fn tooltip_bind_events_cmd(
  id : String,
  emit : @cmd.Emit[TooltipMsg],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, scheduler => {
    ui_after_ready("tooltip-events:" + id, () => {
      ffi_bind_tooltip_events(id, (kind, wait) => {
        scheduler.add(emit(TooltipDomEvent(kind, wait)))
      })
    })
  })
}

///|
#cfg(target="js")
fn tooltip_update(
  id : String,
  close_on_click : Bool,
  on_open_change : @cmd.Emit[Bool]?,
  emit : @cmd.Emit[TooltipMsg],
  msg : TooltipMsg,
  current : TooltipModel,
) -> (TooltipModel, @cmd.Cmd) {
  match msg {
    TooltipDomEvent(kind, wait) =>
      match kind {
        // Trigger hover starts after the configured provider/root delay.
        0 => {
          let generation = current.generation + 1
          let next = { ..current, trigger_hovered: true, generation }
          if current.open {
            (next, @cmd.none)
          } else if wait <= 0 {
            tooltip_commit_open(id, on_open_change, next, true)
          } else {
            (next, @cmd.delay(emit(TooltipOpenAfter(generation)), wait))
          }
        }
        // Trigger hover ends; popup hover can cancel this delayed close.
        1 => {
          let generation = current.generation + 1
          let next = { ..current, trigger_hovered: false, generation }
          if tooltip_is_active(next) || !next.open {
            (next, @cmd.none)
          } else if wait <= 0 {
            tooltip_commit_open(id, on_open_change, next, false)
          } else {
            (next, @cmd.delay(emit(TooltipCloseAfter(generation)), wait))
          }
        }
        // Keyboard/programmatic focus opens immediately.
        2 => {
          let next = {
            ..current,
            trigger_focused: true,
            generation: current.generation + 1,
          }
          tooltip_commit_open(id, on_open_change, next, true)
        }
        3 => {
          let generation = current.generation + 1
          let next = { ..current, trigger_focused: false, generation }
          if tooltip_is_active(next) || !next.open {
            (next, @cmd.none)
          } else if wait <= 0 {
            tooltip_commit_open(id, on_open_change, next, false)
          } else {
            (next, @cmd.delay(emit(TooltipCloseAfter(generation)), wait))
          }
        }
        // Click-to-dismiss remains configurable.
        4 =>
          if close_on_click {
            tooltip_commit_open(
              id,
              on_open_change,
              {
                ..current,
                trigger_hovered: false,
                trigger_focused: false,
                content_hovered: false,
                generation: current.generation + 1,
              },
              false,
            )
          } else {
            (current, @cmd.none)
          }
        5 =>
          (
            {
              ..current,
              content_hovered: true,
              generation: current.generation + 1,
            },
            @cmd.none,
          )
        6 => {
          let generation = current.generation + 1
          let next = { ..current, content_hovered: false, generation }
          if tooltip_is_active(next) || !next.open {
            (next, @cmd.none)
          } else if wait <= 0 {
            tooltip_commit_open(id, on_open_change, next, false)
          } else {
            (next, @cmd.delay(emit(TooltipCloseAfter(generation)), wait))
          }
        }
        // Only the top floating layer dispatches Escape/outside dismissal.
        _ =>
          tooltip_commit_open(
            id,
            on_open_change,
            {
              ..current,
              trigger_hovered: false,
              trigger_focused: false,
              content_hovered: false,
              generation: current.generation + 1,
            },
            false,
          )
      }
    TooltipOpenAfter(generation) =>
      if generation == current.generation && tooltip_is_active(current) {
        tooltip_commit_open(id, on_open_change, current, true)
      } else {
        (current, @cmd.none)
      }
    TooltipCloseAfter(generation) =>
      if generation == current.generation && !tooltip_is_active(current) {
        tooltip_commit_open(id, on_open_change, current, false)
      } else {
        (current, @cmd.none)
      }
    TooltipNativeChanged(open) =>
      tooltip_commit_native(on_open_change, current, open)
  }
}

///|
fn[T : @html.IsChildren, C : @html.IsChildren] render_tooltip(
  id : String,
  open : Bool,
  disabled : Bool,
  delay : Int?,
  close_delay : Int?,
  close_on_click : Bool,
  hoverable : Bool,
  side : PopupSide,
  align : PopupAlign,
  side_offset : Int,
  align_offset : Int,
  show_arrow : Bool,
  trigger_variant : ButtonVariant,
  trigger_size : ButtonSize,
  attrs : @html.Attrs?,
  style : Array[String],
  trigger_attrs : @html.Attrs?,
  trigger_style : Array[String],
  content_attrs : @html.Attrs?,
  content_style : Array[String],
  arrow_attrs : @html.Attrs?,
  arrow_style : Array[String],
  on_trigger_click : @cmd.Cmd?,
  trigger : T,
  content : C,
) -> @html.Html {
  let root_id = id + "-root"
  let trigger_id = id + "-trigger"
  let root_attrs = popup_state_attrs(attrs, "tooltip", open)
    .data_set("close-on-click", ui_bool(close_on_click))
    .data_set("hoverable", ui_bool(hoverable))
  if delay is Some(delay) {
    ignore(root_attrs.data_set("delay", "\{delay}"))
  }
  if close_delay is Some(close_delay) {
    ignore(root_attrs.data_set("close-delay", "\{close_delay}"))
  }
  let on_click = on_trigger_click
  let trigger_element_attrs = trigger_attrs
  let popup_attrs = content_attrs
  @html.span(
    style=ui_styles([UiBoxSizing, TooltipRootStyle], style),
    id=root_id,
    attrs=root_attrs,
    [
      tooltip_trigger(
        content_id=id,
        open~,
        disabled~,
        variant=trigger_variant,
        size=trigger_size,
        on_click?,
        id=trigger_id,
        attrs?=trigger_element_attrs,
        style=trigger_style,
        trigger,
      ),
      tooltip_content(
        id~,
        trigger_id~,
        open~,
        side~,
        align~,
        side_offset~,
        align_offset~,
        show_arrow~,
        attrs?=popup_attrs,
        arrow_attrs?,
        style=content_style,
        arrow_style~,
        content,
      ),
    ],
  )
}

///|
/// Imperatively open a mounted tooltip. The owning incremental component
/// receives the resulting native `toggle` event and synchronizes its state.
pub fn tooltip_open(id : String) -> @cmd.Cmd {
  floating_set_open_cmd(id, true)
}

///|
pub fn tooltip_close(id : String) -> @cmd.Cmd {
  floating_set_open_cmd(id, false)
}

///|
pub fn tooltip_toggle(id : String) -> @cmd.Cmd {
  floating_toggle_cmd(id)
}

///|
/// Build a black-box tooltip with Rabbita-owned incremental interaction state.
///
/// Hover, keyboard focus, click dismissal, Escape, hoverable content, provider
/// delays, and native Popover top-layer synchronization are handled internally.
#cfg(target="js")
pub fn[T : @html.IsChildren, C : @html.IsChildren] tooltip(
  id~ : String,
  default_open? : Bool = false,
  disabled? : Bool = false,
  delay? : Int,
  close_delay? : Int,
  close_on_click? : Bool = true,
  hoverable? : Bool = true,
  side? : PopupSide = Top,
  align? : PopupAlign = Center,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  show_arrow? : Bool = true,
  trigger_variant? : ButtonVariant = Ghost,
  trigger_size? : ButtonSize = Default,
  on_open_change? : @cmd.Emit[Bool],
  on_trigger_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  trigger_attrs? : @html.Attrs,
  trigger_style? : Array[String] = [],
  content_attrs? : @html.Attrs,
  content_style? : Array[String] = [],
  arrow_attrs? : @html.Attrs,
  arrow_style? : Array[String] = [],
  trigger : T,
  content : C,
) -> @rabbita.Val[@html.Html] {
  let initial_open = default_open && !disabled
  let initial_model : TooltipModel = {
    open: initial_open,
    trigger_hovered: false,
    trigger_focused: false,
    content_hovered: false,
    generation: 0,
  }
  let (model, _) = @rabbita.create_state_with_init(
    init=emit => {
      let sync = emit.map(value => TooltipNativeChanged(value))
      (
        initial_model,
        @cmd.batch([
          floating_bind_sync_cmd(id, sync),
          tooltip_bind_events_cmd(id, emit),
          if initial_open {
            floating_set_open_cmd(id, true)
          } else {
            @cmd.none
          },
        ]),
      )
    },
    update=(emit, msg, current) => {
      tooltip_update(id, close_on_click, on_open_change, emit, msg, current)
    },
  )
  model.view(model => {
    render_tooltip(
      id,
      model.open,
      disabled,
      delay,
      close_delay,
      close_on_click,
      hoverable,
      side,
      align,
      side_offset,
      align_offset,
      show_arrow,
      trigger_variant,
      trigger_size,
      attrs,
      style,
      trigger_attrs,
      trigger_style,
      content_attrs,
      content_style,
      arrow_attrs,
      arrow_style,
      on_trigger_click,
      trigger,
      content,
    )
  })
}

///|
/// Native/SSR fallback: render the requested initial state. Browser event and
/// top-layer behavior is enabled by the JavaScript target.
#cfg(not(target="js"))
pub fn[T : @html.IsChildren, C : @html.IsChildren] tooltip(
  id~ : String,
  default_open? : Bool = false,
  disabled? : Bool = false,
  delay? : Int,
  close_delay? : Int,
  close_on_click? : Bool = true,
  hoverable? : Bool = true,
  side? : PopupSide = Top,
  align? : PopupAlign = Center,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  show_arrow? : Bool = true,
  trigger_variant? : ButtonVariant = Ghost,
  trigger_size? : ButtonSize = Default,
  on_open_change? : @cmd.Emit[Bool],
  on_trigger_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  trigger_attrs? : @html.Attrs,
  trigger_style? : Array[String] = [],
  content_attrs? : @html.Attrs,
  content_style? : Array[String] = [],
  arrow_attrs? : @html.Attrs,
  arrow_style? : Array[String] = [],
  trigger : T,
  content : C,
) -> @rabbita.Val[@html.Html] {
  ignore(on_open_change)
  @rabbita.Val::constant(
    render_tooltip(
      id,
      default_open && !disabled,
      disabled,
      delay,
      close_delay,
      close_on_click,
      hoverable,
      side,
      align,
      side_offset,
      align_offset,
      show_arrow,
      trigger_variant,
      trigger_size,
      attrs,
      style,
      trigger_attrs,
      trigger_style,
      content_attrs,
      content_style,
      arrow_attrs,
      arrow_style,
      on_trigger_click,
      trigger,
      content,
    ),
  )
}
