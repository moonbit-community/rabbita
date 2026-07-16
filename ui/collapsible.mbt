///|
const CollapsibleRootStyle : String = "display:block;width:100%;min-width:0;color:var(--rui-foreground,oklch(0.145 0 0))"

///|
const CollapsibleTriggerStyle : String = AccordionTriggerStyle

///|
const CollapsibleTriggerLabelStyle : String = "display:block;min-width:0;flex:1"

///|
const CollapsibleIndicatorBoxStyle : String = "display:inline-flex;width:1rem;height:1rem;flex-shrink:0;align-items:center;justify-content:center;color:var(--rui-muted-foreground,oklch(0.556 0 0));pointer-events:none"

///|
const CollapsibleIndicatorStyle : String = "display:block;width:0.4375rem;height:0.4375rem;border-right:1.5px solid currentColor;border-bottom:1.5px solid currentColor;transform-origin:center;transition:transform 150ms ease"

///|
const CollapsibleIndicatorClosedStyle : String = "transform:translateY(-0.125rem) rotate(45deg)"

///|
const CollapsibleIndicatorOpenStyle : String = "transform:translateY(0.125rem) rotate(225deg)"

///|
const CollapsibleContentOuterStyle : String = "display:grid;min-width:0;grid-template-rows:var(--rui-collapsible-content-rows,0fr);opacity:var(--rui-collapsible-content-opacity,0);visibility:var(--rui-collapsible-content-visibility,hidden);transition:grid-template-rows 200ms cubic-bezier(0.22,1,0.36,1),opacity 150ms ease,visibility 0s linear var(--rui-collapsible-content-visibility-delay,200ms)"

///|
const CollapsibleContentOpenStyle : String = "--rui-collapsible-content-rows:1fr;--rui-collapsible-content-opacity:1;--rui-collapsible-content-visibility:visible;--rui-collapsible-content-visibility-delay:0s"

///|
const CollapsibleContentClosedStyle : String = "--rui-collapsible-content-rows:0fr;--rui-collapsible-content-opacity:0;--rui-collapsible-content-visibility:hidden;--rui-collapsible-content-visibility-delay:200ms"

///|
const CollapsibleContentClipStyle : String = "min-width:0;min-height:0;overflow:hidden"

///|
const CollapsibleContentStyle : String = "min-width:0;padding:0.25rem 0.625rem 0.75rem;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem;line-height:1.5;overflow-wrap:anywhere"

///|
fn collapsible_state(open : Bool) -> String {
  if open {
    "open"
  } else {
    "closed"
  }
}

///|
fn collapsible_state_attrs(
  attrs : @html.Attrs?,
  slot : String,
  open : Bool,
) -> @html.Attrs {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", slot)
    .data_set("state", collapsible_state(open))
  if open {
    ignore(element_attrs.data_set("open", ""))
  } else {
    ignore(element_attrs.data_set("closed", ""))
  }
  element_attrs
}

///|
#cfg(target="js")
fn collapsible_bind_open_change(
  attrs : @html.Attrs,
  open : Bool,
  emit : @cmd.Emit[Bool],
) -> Unit {
  ignore(
    attrs.on_click_after(event => {
      event.prevent_default()
      emit(!open)
    }),
  )
}

///|
#cfg(not(target="js"))
fn collapsible_bind_open_change(
  attrs : @html.Attrs,
  open : Bool,
  emit : @cmd.Emit[Bool],
) -> Unit {
  ignore((attrs, open, emit))
}

///|
fn collapsible_indicator(open : Bool) -> @html.Html {
  let state = collapsible_state(open)
  @html.span(
    style=[UiBoxSizing, CollapsibleIndicatorBoxStyle],
    attrs=@html.Attrs::build()
      .aria_hidden("true")
      .data_set("slot", "collapsible-indicator")
      .data_set("state", state),
    @html.span(
      style=[
        UiBoxSizing,
        CollapsibleIndicatorStyle,
        if open {
          CollapsibleIndicatorOpenStyle
        } else {
          CollapsibleIndicatorClosedStyle
        },
      ],
      attrs=@html.Attrs::build().data_set("state", state),
      @html.nothing,
    ),
  )
}

///|
/// Render the root used by a controlled collapsible.
pub fn[C : @html.IsChildren] collapsible_root(
  open? : Bool = false,
  disabled? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = collapsible_state_attrs(attrs, "collapsible", open).aria_disabled(
    ui_bool(disabled),
  )
  if disabled {
    ignore(element_attrs.data_set("disabled", ""))
  }
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        CollapsibleRootStyle,
        ui_disabled_visual_style(disabled),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=element_attrs,
    children,
  )
}

///|
/// Render the native button trigger for a controlled collapsible.
///
/// The native button supplies pointer, Enter, and Space activation. The
/// component appends its state request after any caller click handler stored
/// in `attrs`.
pub fn[C : @html.IsChildren] collapsible_trigger(
  open? : Bool = false,
  disabled? : Bool = false,
  controls? : String,
  show_indicator? : Bool = true,
  on_open_change? : @cmd.Emit[Bool],
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = collapsible_state_attrs(
      attrs, "collapsible-trigger", open,
    )
    .aria_expanded(ui_bool(open))
    .aria_disabled(ui_bool(disabled))
  if controls is Some(controls) {
    ignore(element_attrs.aria_controls(controls))
  }
  if disabled {
    ignore(element_attrs.data_set("disabled", "").tabindex(-1))
  }
  if !disabled && on_open_change is Some(emit) {
    collapsible_bind_open_change(element_attrs, open, emit)
  }
  @html.button(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        CollapsibleTriggerStyle,
        if open {
          AccordionTriggerOpenStyle
        } else {
          ""
        },
        ui_disabled_style(disabled),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    type_="button",
    disabled~,
    attrs=element_attrs,
    [
      @html.span(
        style=[UiBoxSizing, CollapsibleTriggerLabelStyle],
        attrs=@html.Attrs::build().data_set("slot", "collapsible-trigger-label"),
        children,
      ),
      if show_indicator {
        collapsible_indicator(open)
      } else {
        @html.nothing
      },
    ],
  )
}

///|
/// Render the collapsible panel. Content remains mounted so both entering and
/// leaving states can animate without a component-specific script.
pub fn[C : @html.IsChildren] collapsible_content(
  open? : Bool = false,
  force_mount? : Bool = false,
  labelledby? : String,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = collapsible_state_attrs(
      attrs, "collapsible-content", open,
    )
    .data_set("force-mount", ui_bool(force_mount))
    .aria_hidden(ui_bool(!open))
    .inert(!open)
  if labelledby is Some(labelledby) {
    ignore(element_attrs.aria_labelledby(labelledby))
  }
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        CollapsibleContentOuterStyle,
        if open {
          CollapsibleContentOpenStyle
        } else {
          CollapsibleContentClosedStyle
        },
      ],
      style,
    ),
    id?,
    class?,
    title?,
    attrs=element_attrs,
    @html.div(
      style=[UiBoxSizing, CollapsibleContentClipStyle],
      attrs=@html.Attrs::build().data_set("slot", "collapsible-content-clip"),
      @html.div(
        style=[UiBoxSizing, CollapsibleContentStyle],
        attrs=@html.Attrs::build().data_set("slot", "collapsible-content-body"),
        children,
      ),
    ),
  )
}

///|
/// Render the current collapsible state for the public incremental component.
fn[T : @html.IsChildren, C : @html.IsChildren] render_collapsible(
  open~ : Bool,
  disabled? : Bool = false,
  show_indicator? : Bool = true,
  force_mount? : Bool = false,
  on_open_change? : @cmd.Emit[Bool],
  id? : String,
  trigger_id? : String,
  content_id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  trigger_attrs? : @html.Attrs,
  content_attrs? : @html.Attrs,
  style? : Array[String] = [],
  trigger_style? : Array[String] = [],
  content_style? : Array[String] = [],
  trigger~ : T,
  content~ : C,
) -> @html.Html {
  let resolved_trigger_id = match trigger_id {
    Some(trigger_id) => Some(trigger_id)
    None => id.map(id => id + "-trigger")
  }
  let resolved_content_id = match content_id {
    Some(content_id) => Some(content_id)
    None => id.map(id => id + "-content")
  }
  let trigger_html = {
    let controls = resolved_content_id
    let id = resolved_trigger_id
    let attrs = trigger_attrs
    collapsible_trigger(
      open~,
      disabled~,
      controls?,
      show_indicator~,
      on_open_change?,
      id?,
      attrs?,
      style=trigger_style,
      trigger,
    )
  }
  let content_html = {
    let labelledby = resolved_trigger_id
    let id = resolved_content_id
    let attrs = content_attrs
    collapsible_content(
      open~,
      force_mount~,
      labelledby?,
      id?,
      attrs?,
      style=content_style,
      content,
    )
  }
  collapsible_root(
    open~,
    disabled~,
    id?,
    class?,
    title?,
    hidden?,
    attrs?,
    style~,
    [trigger_html, content_html],
  )
}

///|
/// Build a self-contained collapsible with component-local incremental state.
#cfg(target="js")
pub fn[T : @html.IsChildren, C : @html.IsChildren] collapsible(
  default_open? : Bool = false,
  disabled? : Bool = false,
  show_indicator? : Bool = true,
  force_mount? : Bool = false,
  id? : String,
  trigger_id? : String,
  content_id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  trigger_attrs? : @html.Attrs,
  content_attrs? : @html.Attrs,
  style? : Array[String] = [],
  trigger_style? : Array[String] = [],
  content_style? : Array[String] = [],
  trigger~ : T,
  content~ : C,
) -> @rabbita.Val[@html.Html] {
  let (open, set_open) = @rabbita.create_variable(default_open)
  let on_open_change = set_open.map(next => _ => next)
  open.view(open => {
    render_collapsible(
      open~,
      disabled~,
      show_indicator~,
      force_mount~,
      on_open_change~,
      id?,
      trigger_id?,
      content_id?,
      class?,
      title?,
      hidden?,
      attrs?,
      trigger_attrs?,
      content_attrs?,
      style~,
      trigger_style~,
      content_style~,
      trigger~,
      content~,
    )
  })
}

///|
/// Native/SSR fallback: render the requested initial state as a constant
/// incremental value.
#cfg(not(target="js"))
pub fn[T : @html.IsChildren, C : @html.IsChildren] collapsible(
  default_open? : Bool = false,
  disabled? : Bool = false,
  show_indicator? : Bool = true,
  force_mount? : Bool = false,
  id? : String,
  trigger_id? : String,
  content_id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  trigger_attrs? : @html.Attrs,
  content_attrs? : @html.Attrs,
  style? : Array[String] = [],
  trigger_style? : Array[String] = [],
  content_style? : Array[String] = [],
  trigger~ : T,
  content~ : C,
) -> @rabbita.Val[@html.Html] {
  @rabbita.Val::constant(
    render_collapsible(
      open=default_open,
      disabled~,
      show_indicator~,
      force_mount~,
      id?,
      trigger_id?,
      content_id?,
      class?,
      title?,
      hidden?,
      attrs?,
      trigger_attrs?,
      content_attrs?,
      style~,
      trigger_style~,
      content_style~,
      trigger~,
      content~,
    ),
  )
}
