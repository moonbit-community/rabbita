///|
pub(all) enum ContentAlignment {
  AlignStart
  AlignEnd
} derive(Debug, Eq)

///|
fn content_alignment_value(align : ContentAlignment) -> String {
  match align {
    AlignStart => "start"
    AlignEnd => "end"
  }
}

///|
pub fn[C : @html.IsChildren] message_group(
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
    attrs=ui_attrs(attrs).data_set("slot", "message-group"),
    style=ui_styles(
      [UiBoxSizing, "display:flex;min-width:0;flex-direction:column;gap:0.5rem"],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] message(
  align? : ContentAlignment = AlignStart,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let value = content_alignment_value(align)
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "message").data_set("align", value),
    style=ui_styles(
      [
        UiBoxSizing,
        "position:relative;display:flex;width:100%;min-width:0;gap:0.5rem;--rui-message-content-align:flex-start;font-size:0.875rem;line-height:1.25rem",
        if align is AlignEnd {
          "flex-direction:row-reverse;--rui-message-content-align:flex-end"
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
pub fn[C : @html.IsChildren] message_avatar(
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
    attrs=ui_attrs(attrs).data_set("slot", "message-avatar"),
    style=ui_styles(
      [
        UiBoxSizing,
        "display:flex;width:fit-content;min-width:2rem;min-height:2rem;aspect-ratio:1;flex-shrink:0;align-items:center;justify-content:center;align-self:flex-end;overflow:hidden;border-radius:9999px;background:var(--rui-muted,oklch(0.97 0 0))",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] message_content(
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
    attrs=ui_attrs(attrs).data_set("slot", "message-content"),
    style=ui_styles(
      [
        UiBoxSizing,
        "display:flex;width:100%;min-width:0;flex-direction:column;gap:0.625rem;overflow-wrap:break-word;word-break:normal",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] message_header(
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
    attrs=ui_attrs(attrs).data_set("slot", "message-header"),
    style=ui_styles(
      [
        UiBoxSizing,
        "display:flex;max-width:100%;min-width:0;align-items:center;align-self:var(--rui-message-content-align,flex-start);padding-inline:0.75rem;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.75rem;line-height:1rem;font-weight:500",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] message_footer(
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
    attrs=ui_attrs(attrs).data_set("slot", "message-footer"),
    style=ui_styles(
      [
        UiBoxSizing,
        "display:flex;max-width:100%;min-width:0;align-items:center;align-self:var(--rui-message-content-align,flex-start);padding-inline:0.75rem;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.75rem;line-height:1rem;font-weight:500",
      ],
      style,
    ),
    children,
  )
}
