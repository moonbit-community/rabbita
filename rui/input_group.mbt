///|
pub(all) enum InputGroupAddonAlign {
  InputInlineStart
  InputInlineEnd
  InputBlockStart
  InputBlockEnd
} derive(Debug, Eq)

///|
pub extend InputGroupAddonAlign with Debug::{to_repr}

///|
pub extend InputGroupAddonAlign with Eq::{equal, not_equal}

///|
pub(all) enum InputGroupButtonSize {
  InputButtonXs
  InputButtonSm
  InputButtonIconXs
  InputButtonIconSm
} derive(Debug, Eq)

///|
pub extend InputGroupButtonSize with Debug::{to_repr}

///|
pub extend InputGroupButtonSize with Eq::{equal, not_equal}

///|
fn input_group_align_value(align : InputGroupAddonAlign) -> String {
  match align {
    InputInlineStart => "inline-start"
    InputInlineEnd => "inline-end"
    InputBlockStart => "block-start"
    InputBlockEnd => "block-end"
  }
}

///|
fn input_group_align_style(align : InputGroupAddonAlign) -> String {
  match align {
    InputInlineStart => "order:-1;padding-inline-start:0.5rem"
    InputInlineEnd => "order:1;padding-inline-end:0.5rem"
    InputBlockStart =>
      "order:-1;width:100%;justify-content:flex-start;padding:0.5rem 0.625rem 0"
    InputBlockEnd =>
      "order:1;width:100%;justify-content:flex-start;padding:0 0.625rem 0.5rem"
  }
}

///|
pub fn[C : @html.IsChildren] input_group(
  disabled? : Bool = false,
  invalid? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let group_attrs = ui_attrs(attrs)
    .role("group")
    .data_set("slot", "input-group")
  if disabled {
    ignore(group_attrs.aria_disabled("true").data_set("disabled", ""))
  }
  if invalid {
    ignore(group_attrs.aria_invalid("true").data_set("invalid", ""))
  }
  @html.div(
    id?,
    class?,
    title?,
    attrs=group_attrs,
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTransition,
        "position:relative;display:flex;width:100%;height:var(--rui-input-group-height,2rem);min-width:0;min-height:2rem;flex-direction:var(--rui-input-group-direction,row);align-items:var(--rui-input-group-align,center);--rui-control-base-bg:var(--rui-input-background,transparent);--rui-control-base-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-control-base-border:var(--rui-input,oklch(0.922 0 0));--rui-control-base-shadow:0 0 #0000;border:1px solid transparent;border-color:var(--rui-control-border,var(--rui-control-base-border,var(--rui-input,oklch(0.922 0 0))));border-radius:var(--rui-radius,0.625rem);background:var(--rui-control-bg,var(--rui-control-base-bg,var(--rui-input-background,transparent)));color:var(--rui-control-fg,var(--rui-control-base-fg,var(--rui-foreground,oklch(0.145 0 0))));box-shadow:var(--rui-control-shadow,var(--rui-control-base-shadow,0 0 #0000));outline:none",
        if invalid {
          InputInvalidStyle
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
pub fn[C : @html.IsChildren] input_group_addon(
  align? : InputGroupAddonAlign = InputInlineStart,
  for_? : String,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let addon_attrs = ui_attrs(attrs)
    .role("group")
    .data_set("slot", "input-group-addon")
    .data_set("align", input_group_align_value(align))
  let addon_style = ui_styles(
    [
      UiBoxSizing,
      "display:flex;height:auto;align-items:center;justify-content:center;gap:0.5rem;padding-block:0.375rem;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem;font-weight:500;user-select:none;cursor:text",
      input_group_align_style(align),
    ],
    style,
  )
  if for_ is Some(for_) {
    @html.label(
      for_~,
      id?,
      class?,
      title?,
      attrs=addon_attrs,
      style=addon_style,
      children,
    )
  } else {
    @html.div(
      id?,
      class?,
      title?,
      attrs=addon_attrs,
      style=addon_style,
      children,
    )
  }
}

///|
pub fn[C : @html.IsChildren] input_group_text(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.span(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "input-group-text"),
    style=ui_styles(
      [
        "display:flex;align-items:center;gap:0.5rem;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem",
      ],
      style,
    ),
    children,
  )
}

///|
/// Adapt a custom form control to the Input Group surface.
///
/// The callback receives the complete public control-slot attributes and the
/// shared nested-control style. Add only control-specific behavior through
/// `style`; callers never need to know the Input Group's internal data slots.
pub fn input_group_control(
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  render : (@html.Attrs, Array[String]) -> @html.Html,
) -> @html.Html {
  let control_attrs = ui_attrs(attrs)
    .data_set("slot", "input-group-control")
    .data_set("input-group-control", "")
  render(
    control_attrs,
    ui_styles(
      [
        "display:flex;width:100%;min-width:0;min-height:2rem;flex:1;border:0;border-radius:0;background:transparent;padding:0.625rem;color:inherit;font:inherit;font-size:var(--rui-control-font-size,1rem);line-height:var(--rui-control-line-height,1.5rem);box-shadow:none;outline:none",
      ],
      style,
    ),
  )
}

///|
fn input_group_button_size(size : InputGroupButtonSize) -> (ButtonSize, String) {
  match size {
    InputButtonXs => (Xs, "xs")
    InputButtonSm => (Default, "sm")
    InputButtonIconXs => (IconXs, "icon-xs")
    InputButtonIconSm => (Icon, "icon-sm")
  }
}

///|
fn input_group_button_size_style(size : InputGroupButtonSize) -> String {
  match size {
    InputButtonXs =>
      "--rui-control-radius:calc(var(--rui-radius,0.625rem) - 0.1875rem);--rui-button-padding-inline:0.375rem;--rui-button-icon-size:0.875rem;font-size:0.875rem;line-height:1.25rem"
    InputButtonIconXs =>
      "--rui-control-radius:calc(var(--rui-radius,0.625rem) - 0.1875rem);--rui-button-icon-size:1rem"
    InputButtonSm | InputButtonIconSm => ""
  }
}

///|
pub fn[C : @html.IsChildren] input_group_button(
  size? : InputGroupButtonSize = InputButtonXs,
  variant? : ButtonVariant = Ghost,
  disabled? : Bool = false,
  on_click? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let (button_size, size_value) = input_group_button_size(size)
  button(
    variant~,
    size=button_size,
    disabled~,
    slot="input-group-button",
    on_click?,
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "input-group-button")
      .data_set("size", size_value),
    style=ui_styles(
      ["--rui-button-base-shadow:none", input_group_button_size_style(size)],
      style,
    ),
    children,
  )
}

///|
pub fn input_group_input(
  input_type? : @html.InputType = Text,
  name? : String,
  value? : String,
  placeholder? : String,
  read_only? : Bool,
  disabled? : Bool = false,
  required? : Bool,
  autofocus? : Bool,
  invalid? : Bool = false,
  on_change? : @cmd.Emit[String],
  on_input? : @cmd.Emit[String],
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  input(
    input_type~,
    name?,
    value?,
    placeholder?,
    read_only?,
    disabled~,
    required?,
    autofocus?,
    invalid~,
    on_change?,
    on_input?,
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("input-group-control", ""),
    slot="input-group-control",
    style=ui_styles(
      [
        "height:var(--rui-input-group-control-height,100%);min-height:0;flex:1;border:0;border-radius:0;background:transparent;padding-inline-start:var(--rui-input-group-padding-start,0.625rem);padding-inline-end:var(--rui-input-group-padding-end,0.625rem);padding-block-start:var(--rui-input-group-padding-top,0.25rem);padding-block-end:var(--rui-input-group-padding-bottom,0.25rem);box-shadow:none;outline:none",
      ],
      style,
    ),
  )
}

///|
pub fn input_group_textarea(
  name? : String,
  value? : String,
  rows? : Int,
  cols? : Int,
  placeholder? : String,
  read_only? : Bool,
  disabled? : Bool = false,
  required? : Bool,
  autofocus? : Bool,
  invalid? : Bool = false,
  on_change? : @cmd.Emit[String],
  on_input? : @cmd.Emit[String],
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  textarea(
    name?,
    value?,
    rows?,
    cols?,
    placeholder?,
    read_only?,
    disabled~,
    required?,
    autofocus?,
    invalid~,
    on_change?,
    on_input?,
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("input-group-control", ""),
    slot="input-group-control",
    style=ui_styles(
      [
        "min-height:5rem;flex:1;resize:none;border:0;border-radius:0;background:transparent;padding-block:0.5rem;box-shadow:none;outline:none",
      ],
      style,
    ),
  )
}
