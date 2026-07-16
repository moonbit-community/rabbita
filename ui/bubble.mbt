///|
pub(all) enum BubbleVariant {
  BubbleDefault
  BubbleSecondary
  BubbleMuted
  BubbleTinted
  BubbleOutline
  BubbleGhost
  BubbleDestructive
} derive(Debug, Eq)

///|
pub(all) enum BubbleReactionSide {
  ReactionTop
  ReactionBottom
} derive(Debug, Eq)

///|
fn bubble_variant_value(variant : BubbleVariant) -> String {
  match variant {
    BubbleDefault => "default"
    BubbleSecondary => "secondary"
    BubbleMuted => "muted"
    BubbleTinted => "tinted"
    BubbleOutline => "outline"
    BubbleGhost => "ghost"
    BubbleDestructive => "destructive"
  }
}

///|
fn bubble_variant_style(variant : BubbleVariant) -> String {
  match variant {
    BubbleDefault =>
      "--rui-bubble-bg:var(--rui-primary,oklch(0.205 0 0));--rui-bubble-fg:var(--rui-primary-foreground,oklch(0.985 0 0));--rui-bubble-border:transparent;--rui-bubble-radius:0.75rem;--rui-bubble-padding:0.5rem 0.75rem"
    BubbleSecondary =>
      "--rui-bubble-bg:var(--rui-secondary,oklch(0.97 0 0));--rui-bubble-fg:var(--rui-secondary-foreground,oklch(0.205 0 0));--rui-bubble-border:transparent;--rui-bubble-radius:0.75rem;--rui-bubble-padding:0.5rem 0.75rem"
    BubbleMuted =>
      "--rui-bubble-bg:var(--rui-muted,oklch(0.97 0 0));--rui-bubble-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-bubble-border:transparent;--rui-bubble-radius:0.75rem;--rui-bubble-padding:0.5rem 0.75rem"
    BubbleTinted =>
      "--rui-bubble-bg:light-dark(oklch(from var(--rui-primary,oklch(0.205 0 0)) 0.93 calc(c * 0.4) h),oklch(from var(--rui-primary,oklch(0.922 0 0)) 0.3 calc(c * 0.4) h));--rui-bubble-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-bubble-border:transparent;--rui-bubble-radius:0.75rem;--rui-bubble-padding:0.5rem 0.75rem"
    BubbleOutline =>
      "--rui-bubble-bg:var(--rui-background,white);--rui-bubble-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-bubble-border:var(--rui-border,oklch(0.922 0 0));--rui-bubble-radius:0.75rem;--rui-bubble-padding:0.5rem 0.75rem"
    BubbleGhost =>
      "--rui-bubble-bg:transparent;--rui-bubble-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-bubble-border:transparent;--rui-bubble-radius:0;--rui-bubble-padding:0"
    BubbleDestructive =>
      "--rui-bubble-bg:var(--rui-destructive-subtle,oklch(0.577 0.245 27.325 / 0.1));--rui-bubble-fg:var(--rui-destructive,oklch(0.577 0.245 27.325));--rui-bubble-border:transparent;--rui-bubble-radius:0.75rem;--rui-bubble-padding:0.5rem 0.75rem"
  }
}

///|
const BubbleContentBaseStyle : String = "width:fit-content;max-width:100%;min-width:0;align-self:var(--rui-bubble-content-align,flex-start);overflow:hidden;border:1px solid var(--rui-bubble-border,transparent);border-radius:var(--rui-bubble-radius,0.75rem);padding:var(--rui-bubble-padding,0.5rem 0.75rem);background:var(--rui-bubble-bg,var(--rui-primary,oklch(0.205 0 0)));color:var(--rui-bubble-fg,var(--rui-primary-foreground,oklch(0.985 0 0)));box-shadow:var(--rui-bubble-shadow,none);font-size:0.875rem;line-height:1.625;overflow-wrap:break-word;word-break:normal;outline:none"

///|
pub fn[C : @html.IsChildren] bubble_group(
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
    attrs=ui_attrs(attrs).data_set("slot", "bubble-group"),
    style=ui_styles(
      [
        UiBoxSizing,
        "display:flex;min-width:0;align-self:var(--rui-message-content-align,flex-start);flex-direction:column;gap:0.5rem",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] bubble(
  variant? : BubbleVariant = BubbleDefault,
  align? : ContentAlignment = AlignStart,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let align_value = content_alignment_value(align)
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "bubble")
      .data_set("variant", bubble_variant_value(variant))
      .data_set("align", align_value),
    style=ui_styles(
      [
        UiBoxSizing,
        "position:relative;display:flex;width:fit-content;max-width:80%;min-width:0;align-self:var(--rui-message-content-align,flex-start);flex-direction:column;gap:0.25rem;--rui-bubble-content-align:flex-start",
        bubble_variant_style(variant),
        if variant is BubbleGhost {
          "max-width:100%"
        } else {
          ""
        },
        if align is AlignEnd {
          "align-self:flex-end;--rui-bubble-content-align:flex-end"
        } else {
          ""
        },
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] bubble_content(
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
    attrs=ui_attrs(attrs).data_set("slot", "bubble-content"),
    style=ui_styles([UiBoxSizing, UiTransition, BubbleContentBaseStyle], style),
    children,
  )
}

///|
#cfg(target="js")
fn bubble_bind_disabled_link(attrs : @html.Attrs, disabled : Bool) -> Unit {
  if disabled {
    ignore(
      attrs.on_click_after(event => {
        event.prevent_default()
        @cmd.none
      }),
    )
  }
}

///|
#cfg(not(target="js"))
fn bubble_bind_disabled_link(attrs : @html.Attrs, disabled : Bool) -> Unit {
  ignore((attrs, disabled))
}

///|
/// Render an interactive bubble-content anchor without a Slot/runtime wrapper.
pub fn[C : @html.IsChildren] bubble_content_link(
  href~ : String,
  disabled? : Bool = false,
  aria_label? : String,
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
  let element_attrs = ui_attrs(attrs).data_set("slot", "bubble-content")
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  }
  if disabled {
    ignore(
      element_attrs.aria_disabled("true").data_set("disabled", "").tabindex(-1),
    )
  } else if on_click is Some(command) {
    ignore(element_attrs.on_click_after(_ => command))
  }
  bubble_bind_disabled_link(element_attrs, disabled)
  @html.a(
    href~,
    target~,
    rel?,
    download?,
    id?,
    class?,
    title?,
    attrs=element_attrs,
    style=ui_styles(
      [
        UiBoxSizing,
        UiTransition,
        BubbleContentBaseStyle,
        "text-decoration:none;cursor:pointer",
        ui_disabled_style(disabled),
      ],
      style,
    ),
    children,
    escape~,
  )
}

///|
/// Render the button branch of Vega's interactive bubble-content recipe.
pub fn[C : @html.IsChildren] bubble_content_button(
  disabled? : Bool = false,
  type_? : String = "button",
  aria_label? : String,
  on_click? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs).data_set("slot", "bubble-content")
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  }
  if disabled {
    ignore(element_attrs.aria_disabled("true").data_set("disabled", ""))
  }
  @html.button(
    type_~,
    disabled~,
    on_click?,
    id?,
    class?,
    title?,
    attrs=element_attrs,
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTransition,
        BubbleContentBaseStyle,
        "margin:0;text-align:start;cursor:pointer;appearance:none;-webkit-appearance:none",
        ui_disabled_style(disabled),
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] bubble_reactions(
  side? : BubbleReactionSide = ReactionBottom,
  align? : ContentAlignment = AlignEnd,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let side_value = if side is ReactionTop { "top" } else { "bottom" }
  let align_value = content_alignment_value(align)
  let placement = match (side, align) {
    (ReactionTop, AlignStart) =>
      "top:0;inset-inline-start:0.75rem;transform:translateY(-75%)"
    (ReactionTop, AlignEnd) =>
      "top:0;inset-inline-end:0.75rem;transform:translateY(-75%)"
    (ReactionBottom, AlignStart) =>
      "bottom:0;inset-inline-start:0.75rem;transform:translateY(75%)"
    (ReactionBottom, AlignEnd) =>
      "bottom:0;inset-inline-end:0.75rem;transform:translateY(75%)"
  }
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "bubble-reactions")
      .data_set("side", side_value)
      .data_set("align", align_value),
    style=ui_styles(
      [
        UiBoxSizing,
        "position:absolute;z-index:10;display:flex;width:fit-content;flex-shrink:0;align-items:center;justify-content:center;gap:0.25rem;border-radius:9999px;background:var(--rui-muted,oklch(0.97 0 0));padding:0.125rem 0.375rem;font-size:0.875rem;box-shadow:0 0 0 3px var(--rui-card,var(--rui-background,white))",
        placement,
      ],
      style,
    ),
    children,
  )
}
