///|
const TextareaBaseStyle : String = "display:flex;width:100%;min-height:4rem;min-width:0;field-sizing:content;resize:vertical;--rui-control-base-bg:var(--rui-input-background,transparent);--rui-control-base-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-control-base-border:var(--rui-input,oklch(0.922 0 0));--rui-control-base-shadow:0 1px 2px rgb(0 0 0 / 0.05);border:1px solid transparent;border-color:var(--rui-control-border,var(--rui-control-base-border,var(--rui-input,oklch(0.922 0 0))));border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-control-bg,var(--rui-control-base-bg,var(--rui-input-background,transparent)));padding:0.5rem 0.625rem;color:var(--rui-control-fg,var(--rui-control-base-fg,var(--rui-foreground,oklch(0.145 0 0))));box-shadow:var(--rui-control-shadow,var(--rui-control-base-shadow,0 1px 2px rgb(0 0 0 / 0.05)));font-size:1rem;line-height:1.5rem;outline-offset:2px"

///|
const TextareaInvalidStyle : String = "border-color:var(--rui-destructive-border,var(--rui-destructive,oklch(0.577 0.245 27.325)));box-shadow:0 0 0 3px var(--rui-destructive-ring,oklch(0.577 0.245 27.325 / 0.2))"

///|
fn textarea_invalid_style(invalid : Bool) -> String {
  if invalid {
    TextareaInvalidStyle
  } else {
    ""
  }
}

///|
/// Render a controlled native textarea using the shadcn/ui Vega field recipe.
///
/// `on_input` is the immediate value-change channel; `on_change` follows the
/// browser's native change event. User styles are appended last.
pub fn textarea(
  name? : String,
  value? : String,
  rows? : Int,
  cols? : Int,
  placeholder? : String,
  read_only? : Bool,
  disabled? : Bool = false,
  maxlength? : Int,
  minlength? : Int,
  required? : Bool,
  autofocus? : Bool,
  wrap? : String,
  invalid? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  on_change? : @cmd.Emit[String],
  on_input? : @cmd.Emit[String],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  slot? : String = "textarea",
) -> @html.Html {
  let attrs = ui_attrs(attrs).data_set("slot", slot)
  if disabled {
    ignore(attrs.data_set("disabled", ""))
  }
  if invalid {
    ignore(attrs.aria_invalid("true").data_set("invalid", ""))
  }
  @html.textarea(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        TextareaBaseStyle,
        textarea_invalid_style(invalid),
        ui_disabled_visual_style(disabled),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    name?,
    value?,
    rows?,
    cols?,
    placeholder?,
    read_only?,
    disabled~,
    maxlength?,
    minlength?,
    required?,
    autofocus?,
    wrap?,
    on_change?,
    on_input?,
    attrs~,
    ([] : Array[@html.Html]),
  )
}
