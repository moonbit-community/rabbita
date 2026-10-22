///|
const TooltipProviderStyle : String = "display:contents"

///|
const TooltipRootStyle : String = "position:relative;display:inline-flex;max-width:100%;vertical-align:middle"

///|
const TooltipContentStyle : String = "position:var(--rui-tooltip-position,absolute);inset:auto;left:var(--rui-tooltip-left,auto);right:var(--rui-tooltip-right,auto);top:var(--rui-tooltip-top,auto);bottom:var(--rui-tooltip-bottom,auto);translate:var(--rui-tooltip-translate,none);z-index:50;display:flex;width:max-content;max-width:min(20rem,calc(100vw - 1rem));transform-origin:var(--rui-floating-transform-origin,center);align-items:center;gap:0.375rem;margin:0;border:0;border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-foreground,oklch(0.145 0 0));padding:0.375rem 0.75rem;color:var(--rui-background,oklch(1 0 0));font-size:0.75rem;line-height:1rem;font-weight:400;text-wrap:balance;box-shadow:none;outline:none;visibility:var(--rui-tooltip-visibility,hidden);opacity:var(--rui-tooltip-opacity,0);pointer-events:none;animation:var(--rui-tooltip-animation,rui-tooltip-out) 100ms ease var(--rui-tooltip-wait,0ms) both;transition:visibility 0s linear var(--rui-tooltip-visibility-wait,100ms)"

///|
const TooltipArrowBaseStyle : String = "position:absolute;z-index:-1;top:var(--rui-tooltip-arrow-top,auto);right:var(--rui-tooltip-arrow-right,auto);bottom:var(--rui-tooltip-arrow-bottom,auto);left:var(--rui-tooltip-arrow-left,auto);width:0.625rem;height:0.625rem;margin-top:var(--rui-tooltip-arrow-margin-top,0);margin-left:var(--rui-tooltip-arrow-margin-left,0);border-radius:2px;background:var(--rui-foreground,oklch(0.145 0 0));transform:rotate(45deg)"

///|
fn tooltip_delay(value : Int32) -> Int32 {
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
/// Supply CSS hover delays to descendant tooltips. Individual tooltips can
/// override either delay.
pub fn[C : @html.IsChildren] tooltip_provider(
  delay~ : Int32 = 0,
  close_delay~ : Int32 = 0,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style~ : Array[String] = [],
  children : C,
) -> @html.Html {
  let actual_delay = tooltip_delay(delay)
  let actual_close_delay = tooltip_delay(close_delay)
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "tooltip-provider")
    .style("--rui-tooltip-delay", "\{actual_delay}ms")
    .style("--rui-tooltip-close-delay", "\{actual_close_delay}ms")
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
  disabled~ : Bool = false,
  variant~ : ButtonVariant = Ghost,
  size~ : ButtonSize = Default,
  on_click? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style~ : Array[String] = [],
  children : C,
) -> @html.Html {
  let resolved_id = id.unwrap_or(content_id + "-trigger")
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "tooltip-trigger")
    .data_set("variant", button_variant_value(variant))
    .data_set("size", button_size_value(size))
  ignore(element_attrs.aria_describedby(content_id))
  if disabled {
    ignore(element_attrs.aria_disabled("true").data_set("disabled", ""))
  }
  if on_click is Some(command) {
    ignore(element_attrs.on_click(_ => command))
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
  side~ : PopupSide = Top,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style~ : Array[String] = [],
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
  side~ : PopupSide = Top,
  align~ : PopupAlign = Center,
  side_offset~ : Int32 = 4,
  align_offset~ : Int32 = 0,
  show_arrow~ : Bool = true,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  arrow_attrs? : @html.Attrs,
  style~ : Array[String] = [],
  arrow_style~ : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", "tooltip-content")
    .role("tooltip")
    .data_set("trigger-id", trigger_id)
    .data_set("requested-side", popup_side_value(side))
    .data_set("requested-align", popup_align_value(align))
    .data_set("side", popup_side_value(side))
    .data_set("align", popup_align_value(align))
    .data_set("side-offset", "\{side_offset}")
    .data_set("align-offset", "\{align_offset}")
    .style("--rui-tooltip-side-offset", "\{side_offset}px")
    .style("--rui-tooltip-align-offset", "\{align_offset}px")
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
        "position-anchor:\{popup_anchor_name(trigger_id)};--rui-floating-transform-origin:\{popup_transform_origin(side, align)}",
        tooltip_arrow_side_style(side),
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
/// Render a tooltip as ordinary HTML. `theme` supplies hover visibility,
/// positioning, and entry/exit animations. No DOM access or internal state.
///
/// Content uses CSS anchor positioning where available, with an absolute
/// positioning fallback. It is not promoted to the browser's top layer.
pub fn[T : @html.IsChildren, C : @html.IsChildren] tooltip(
  id~ : String,
  disabled~ : Bool = false,
  delay? : Int32,
  close_delay? : Int32,
  side~ : PopupSide = Top,
  align~ : PopupAlign = Center,
  side_offset~ : Int32 = 4,
  align_offset~ : Int32 = 0,
  show_arrow~ : Bool = true,
  trigger_variant~ : ButtonVariant = Ghost,
  trigger_size~ : ButtonSize = Default,
  on_trigger_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style~ : Array[String] = [],
  trigger_attrs? : @html.Attrs,
  trigger_style~ : Array[String] = [],
  content_attrs? : @html.Attrs,
  content_style~ : Array[String] = [],
  arrow_attrs? : @html.Attrs,
  arrow_style~ : Array[String] = [],
  trigger : T,
  content : C,
) -> @html.Html {
  let root_id = id + "-root"
  let trigger_id = id + "-trigger"
  let root_attrs = ui_attrs(attrs)
    .data_set("slot", "tooltip")
    .data_set("disabled", ui_bool(disabled))
  if delay is Some(delay) {
    ignore(root_attrs.style("--rui-tooltip-delay", "\{tooltip_delay(delay)}ms"))
  }
  if close_delay is Some(close_delay) {
    ignore(
      root_attrs.style(
        "--rui-tooltip-close-delay",
        "\{tooltip_delay(close_delay)}ms",
      ),
    )
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
