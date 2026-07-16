///|
const TypographyH1Style : String = "margin:0;scroll-margin-top:5rem;font-size:2.25rem;line-height:2.5rem;font-weight:800;letter-spacing:-0.025em;text-align:center;text-wrap:balance"

///|
const TypographyH2Style : String = "margin:0;scroll-margin-top:5rem;border-bottom:1px solid var(--rui-border,oklch(0.922 0 0));padding-bottom:0.5rem;font-size:1.875rem;line-height:2.25rem;font-weight:600;letter-spacing:-0.025em"

///|
const TypographyH3Style : String = "margin:0;scroll-margin-top:5rem;font-size:1.5rem;line-height:2rem;font-weight:600;letter-spacing:-0.025em"

///|
const TypographyH4Style : String = "margin:0;scroll-margin-top:5rem;font-size:1.25rem;line-height:1.75rem;font-weight:600;letter-spacing:-0.025em"

///|
const TypographyPStyle : String = "margin:0;line-height:1.75rem"

///|
const TypographyBlockquoteStyle : String = "margin:1.5rem 0 0;border-inline-start:2px solid var(--rui-border,oklch(0.922 0 0));padding-inline-start:1.5rem;font-style:italic"

///|
const TypographyListStyle : String = "margin-block:1.5rem;margin-inline:1.5rem 0;padding:0;list-style-position:outside;list-style-type:disc"

///|
const TypographyInlineCodeStyle : String = "position:relative;border-radius:calc(var(--rui-radius,0.625rem) - 0.25rem);background:var(--rui-muted,oklch(0.97 0 0));padding:0.2rem 0.3rem;font-family:ui-monospace,SFMono-Regular,Menlo,Monaco,Consolas,\"Liberation Mono\",\"Courier New\",monospace;font-size:0.875rem;line-height:1.25rem;font-weight:600"

///|
const TypographyLeadStyle : String = "margin:0;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:1.25rem;line-height:1.75rem"

///|
const TypographyLargeStyle : String = "font-size:1.125rem;line-height:1.75rem;font-weight:600"

///|
const TypographySmallStyle : String = "font-size:0.875rem;line-height:1;font-weight:500"

///|
const TypographyMutedStyle : String = "margin:0;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem;line-height:1.25rem"

///|
fn typography_attrs(attrs : @html.Attrs?, slot : String) -> @html.Attrs {
  ui_attrs(attrs).data_set("slot", slot)
}

///|
/// Render the Vega display heading recipe as a semantic `h1`.
pub fn[C : @html.IsChildren] typography_h1(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.h1(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, TypographyH1Style],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=typography_attrs(attrs, "typography-h1"),
    children,
  )
}

///|
/// Render the Vega section heading recipe as a semantic `h2`.
pub fn[C : @html.IsChildren] typography_h2(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.h2(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, TypographyH2Style],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=typography_attrs(attrs, "typography-h2"),
    children,
  )
}

///|
/// Render the Vega subsection heading recipe as a semantic `h3`.
pub fn[C : @html.IsChildren] typography_h3(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.h3(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, TypographyH3Style],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=typography_attrs(attrs, "typography-h3"),
    children,
  )
}

///|
/// Render the Vega compact heading recipe as a semantic `h4`.
pub fn[C : @html.IsChildren] typography_h4(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.h4(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, TypographyH4Style],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=typography_attrs(attrs, "typography-h4"),
    children,
  )
}

///|
/// Render a readable body paragraph.
pub fn[C : @html.IsChildren] typography_p(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.p(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, TypographyPStyle],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=typography_attrs(attrs, "typography-p"),
    children,
  )
}

///|
/// Render the Vega quotation recipe as a semantic `blockquote`.
pub fn[C : @html.IsChildren] typography_blockquote(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.blockquote(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, TypographyBlockquoteStyle],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=typography_attrs(attrs, "typography-blockquote"),
    children,
  )
}

///|
/// Render the Vega bulleted-list recipe as a semantic `ul`.
pub fn[C : @html.IsChildren] typography_list(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.ul(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, TypographyListStyle],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=typography_attrs(attrs, "typography-list"),
    children,
  )
}

///|
/// Render a short inline code fragment.
pub fn[C : @html.IsChildren] typography_inline_code(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.code(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, TypographyInlineCodeStyle],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=typography_attrs(attrs, "typography-inline-code"),
    children,
  )
}

///|
/// Render introductory copy with the Vega lead treatment.
pub fn[C : @html.IsChildren] typography_lead(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.p(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, TypographyLeadStyle],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=typography_attrs(attrs, "typography-lead"),
    children,
  )
}

///|
/// Render emphasized large text without adding heading semantics.
pub fn[C : @html.IsChildren] typography_large(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, TypographyLargeStyle],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=typography_attrs(attrs, "typography-large"),
    children,
  )
}

///|
/// Render compact supporting copy using the semantic `small` element.
pub fn[C : @html.IsChildren] typography_small(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.small(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, TypographySmallStyle],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=typography_attrs(attrs, "typography-small"),
    children,
  )
}

///|
/// Render subdued helper copy.
pub fn[C : @html.IsChildren] typography_muted(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.p(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, TypographyMutedStyle],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=typography_attrs(attrs, "typography-muted"),
    children,
  )
}
