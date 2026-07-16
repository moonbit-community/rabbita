///|
pub(all) enum FieldOrientation {
  FieldVertical
  FieldHorizontal
  FieldResponsive
} derive(Debug, Eq)

///|
pub(all) enum FieldLegendVariant {
  FieldLegend
  FieldLabelLegend
} derive(Debug, Eq)

///|
fn field_orientation_value(orientation : FieldOrientation) -> String {
  match orientation {
    FieldVertical => "vertical"
    FieldHorizontal => "horizontal"
    FieldResponsive => "responsive"
  }
}

///|
fn field_orientation_style(orientation : FieldOrientation) -> String {
  match orientation {
    FieldVertical => "flex-direction:column"
    FieldHorizontal => "flex-direction:row;align-items:center"
    FieldResponsive => "flex-direction:column"
  }
}

///|
const FieldLabelStyle : String = "display:flex;width:var(--rui-field-label-width,fit-content);flex-direction:var(--rui-field-label-direction,row);align-items:var(--rui-field-label-align,center);gap:0.5rem;--rui-field-label-base-bg:transparent;--rui-field-label-base-border:transparent;--rui-field-label-base-shadow:none;border-width:var(--rui-field-label-border-width,0px);border-style:solid;border-color:var(--rui-field-label-border,var(--rui-field-label-base-border,transparent));border-radius:var(--rui-field-label-radius,0px);background:var(--rui-field-label-bg,var(--rui-field-label-base-bg,transparent));padding:var(--rui-field-label-padding,0px);color:var(--rui-field-label-fg,inherit);box-shadow:var(--rui-field-label-shadow,var(--rui-field-label-base-shadow,none));font-size:0.875rem;line-height:1.375;font-weight:500"

///|
pub fn[C : @html.IsChildren] field_set(
  disabled? : Bool = false,
  name? : String,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let set_attrs = ui_attrs(attrs).data_set("slot", "field-set")
  if disabled {
    ignore(set_attrs.data_set("disabled", ""))
  }
  @html.fieldset(
    disabled~,
    name?,
    id?,
    class?,
    title?,
    attrs=set_attrs,
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        "display:flex;min-width:0;flex-direction:column;gap:1.5rem;border:0;margin:0;padding:0",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] field_legend(
  variant? : FieldLegendVariant = FieldLegend,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let value = if variant is FieldLegend { "legend" } else { "label" }
  @html.legend(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "field-legend")
      .data_set("variant", value),
    style=ui_styles(
      [
        "margin:0 0 0.75rem;padding:0;font-weight:500",
        if variant is FieldLegend {
          "font-size:1rem;line-height:1.5rem"
        } else {
          "font-size:0.875rem;line-height:1.25rem"
        },
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] field_group(
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
    attrs=ui_attrs(attrs).data_set("slot", "field-group"),
    style=ui_styles(
      [
        "display:flex;width:100%;flex-direction:column;gap:1.75rem;container-type:inline-size;container-name:rui-field-group",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] field(
  orientation? : FieldOrientation = FieldVertical,
  disabled? : Bool = false,
  invalid? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let value = field_orientation_value(orientation)
  let field_attrs = ui_attrs(attrs)
    .role("group")
    .data_set("slot", "field")
    .data_set("orientation", value)
    .data_set("invalid", ui_bool(invalid))
  if disabled {
    ignore(field_attrs.aria_disabled("true").data_set("disabled", ""))
  }
  if invalid {
    ignore(field_attrs.aria_invalid("true"))
  }
  @html.div(
    id?,
    class?,
    title?,
    attrs=field_attrs,
    style=ui_styles(
      [
        "display:flex;width:100%;gap:0.75rem",
        field_orientation_style(orientation),
        if invalid {
          "color:var(--rui-destructive,oklch(0.577 0.245 27.325))"
        } else {
          ""
        },
        ui_disabled_visual_style(disabled),
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] field_content(
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
    attrs=ui_attrs(attrs).data_set("slot", "field-content"),
    style=ui_styles(
      [
        "display:flex;min-width:0;flex:1;flex-direction:column;gap:0.375rem;line-height:1.375",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] field_label(
  for_? : String,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.label(
    for_?,
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "field-label"),
    style=ui_styles([UiBoxSizing, FieldLabelStyle], style),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] field_title(
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
    attrs=ui_attrs(attrs).data_set("slot", "field-label"),
    style=ui_styles(
      [
        "display:flex;width:fit-content;align-items:center;gap:0.5rem;font-size:0.875rem;line-height:1.375;font-weight:500",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] field_description(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.p(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "field-description"),
    style=ui_styles(
      [
        "margin:0;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem;line-height:1.5;font-weight:400",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] field_error(
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
    attrs=ui_attrs(attrs).role("alert").data_set("slot", "field-error"),
    style=ui_styles(
      [
        "color:var(--rui-destructive,oklch(0.577 0.245 27.325));font-size:0.875rem;line-height:1.25rem;font-weight:400",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] field_separator(
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
    attrs=ui_attrs(attrs).data_set("slot", "field-separator"),
    style=ui_styles(
      [
        "position:relative;display:flex;height:1.25rem;align-items:center;justify-content:center;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem",
      ],
      style,
    ),
    [
      @html.span(
        attrs=@html.Attrs::build().aria_hidden("true"),
        style=[
          "position:absolute;left:0;right:0;top:50%;height:1px;background:var(--rui-border,oklch(0.922 0 0))",
        ],
        "",
      ),
      @html.span(
        attrs=@html.Attrs::build().data_set("slot", "field-separator-content"),
        style=[
          "position:relative;display:block;width:fit-content;background:var(--rui-background,white);padding-inline:0.5rem",
        ],
        children,
      ),
    ],
  )
}
