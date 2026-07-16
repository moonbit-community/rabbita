///|
pub(all) enum NativeSelectSize {
  NativeSelectDefault
  NativeSelectSm
} derive(Debug, Eq)

///|
const NativeSelectWrapperStyle : String = "position:relative;display:inline-flex;width:fit-content;max-width:100%;align-items:center"

///|
const NativeSelectBaseStyle : String = "width:100%;min-width:0;--rui-control-base-bg:var(--rui-input-background,transparent);--rui-control-base-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-control-base-border:var(--rui-input,oklch(0.922 0 0));--rui-control-base-shadow:0 1px 2px rgb(0 0 0 / 0.05);appearance:none;-webkit-appearance:none;border:1px solid transparent;border-color:var(--rui-control-border,var(--rui-control-base-border,var(--rui-input,oklch(0.922 0 0))));border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-control-bg,var(--rui-control-base-bg,var(--rui-input-background,transparent)));padding-block:0.25rem;padding-inline:0.625rem 2.25rem;color:var(--rui-control-fg,var(--rui-control-base-fg,var(--rui-foreground,oklch(0.145 0 0))));font-size:0.875rem;line-height:1.25rem;box-shadow:var(--rui-control-shadow,var(--rui-control-base-shadow,0 1px 2px rgb(0 0 0 / 0.05)));outline-offset:2px;user-select:none"

///|
const NativeSelectDefaultStyle : String = "height:2.25rem"

///|
const NativeSelectSmStyle : String = "height:2rem"

///|
const NativeSelectInvalidStyle : String = "border-color:var(--rui-destructive-border,var(--rui-destructive,oklch(0.577 0.245 27.325)));box-shadow:0 0 0 3px var(--rui-destructive-ring,oklch(0.577 0.245 27.325 / 0.2))"

///|
const NativeSelectIconStyle : String = "position:absolute;inset-block-start:50%;inset-inline-end:0.875rem;display:inline-flex;width:1rem;height:1rem;align-items:center;justify-content:center;color:var(--rui-muted-foreground,oklch(0.556 0 0));opacity:0.5;pointer-events:none;transform:translateY(-50%);user-select:none"

///|
const NativeSelectOptionStyle : String = "background:Canvas;color:CanvasText"

///|
fn native_select_size_value(size : NativeSelectSize) -> String {
  match size {
    NativeSelectDefault => "default"
    NativeSelectSm => "sm"
  }
}

///|
fn native_select_size_style(size : NativeSelectSize) -> String {
  match size {
    NativeSelectDefault => NativeSelectDefaultStyle
    NativeSelectSm => NativeSelectSmStyle
  }
}

///|
fn native_select_invalid_style(invalid : Bool) -> String {
  if invalid {
    NativeSelectInvalidStyle
  } else {
    ""
  }
}

///|
fn native_select_disabled_style(disabled : Bool) -> String {
  if disabled {
    "cursor:not-allowed;pointer-events:none"
  } else {
    ""
  }
}

///|
/// Render the shadcn native-select recipe with a real browser `<select>`.
///
/// `value` is written as a DOM property for controlled browser rendering.
/// Options can also set `selected` for meaningful standalone SSR output.
pub fn[C : @html.IsChildren] native_select(
  size? : NativeSelectSize = NativeSelectDefault,
  value? : String,
  name? : String,
  disabled? : Bool = false,
  required? : Bool,
  autofocus? : Bool,
  invalid? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  on_change? : @cmd.Emit[String],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  wrapper_style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let size_value = native_select_size_value(size)
  let select_attrs = ui_attrs(attrs)
    .data_set("slot", "native-select")
    .data_set("size", size_value)
  if value is Some(value) {
    ignore(select_attrs.value_prop(value))
  }
  if disabled {
    ignore(select_attrs.data_set("disabled", ""))
  }
  if invalid {
    ignore(select_attrs.aria_invalid("true").data_set("invalid", ""))
  }
  if aria_label is Some(label) {
    ignore(select_attrs.aria_label(label))
  }
  let select = @html.select(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        NativeSelectBaseStyle,
        native_select_size_style(size),
        native_select_invalid_style(invalid),
        native_select_disabled_style(disabled),
      ],
      style,
    ),
    id?,
    disabled~,
    name?,
    required?,
    autofocus?,
    on_change?,
    attrs=select_attrs,
    children,
  )
  let wrapper_attrs = @html.Attrs::build()
    .data_set("slot", "native-select-wrapper")
    .data_set("size", size_value)
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        NativeSelectWrapperStyle,
        ui_disabled_visual_style(disabled),
      ],
      wrapper_style,
    ),
    class?,
    title?,
    attrs=wrapper_attrs,
    [
      select,
      @html.span(
        style=[UiBoxSizing, NativeSelectIconStyle],
        attrs=@html.Attrs::build()
          .data_set("slot", "native-select-icon")
          .aria_hidden("true"),
        ui_chevron_down_icon(),
      ),
    ],
  )
}

///|
pub fn[C : @html.IsChildren] native_select_option(
  value? : String,
  selected? : Bool,
  disabled? : Bool,
  label? : String,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.option(
    style=ui_styles([NativeSelectOptionStyle], style),
    id?,
    class?,
    title?,
    label?,
    disabled?,
    value?,
    selected?,
    attrs=ui_attrs(attrs).data_set("slot", "native-select-option"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] native_select_optgroup(
  label? : String,
  disabled? : Bool,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.optgroup(
    style=ui_styles([NativeSelectOptionStyle], style),
    id?,
    class?,
    title?,
    label?,
    disabled?,
    attrs=ui_attrs(attrs).data_set("slot", "native-select-optgroup"),
    children,
  )
}
