///|
const InputBaseStyle : String = "display:flex;width:100%;height:2.25rem;min-width:0;--rui-control-base-bg:var(--rui-input-background,transparent);--rui-control-base-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-control-base-border:var(--rui-input,oklch(0.922 0 0));--rui-control-base-shadow:0 1px 2px rgb(0 0 0 / 0.05);border:1px solid transparent;border-color:var(--rui-control-border,var(--rui-control-base-border,var(--rui-input,oklch(0.922 0 0))));border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);background:var(--rui-control-bg,var(--rui-control-base-bg,var(--rui-input-background,transparent)));padding:0.25rem 0.625rem;color:var(--rui-control-fg,var(--rui-control-base-fg,var(--rui-foreground,oklch(0.145 0 0))));box-shadow:var(--rui-control-shadow,var(--rui-control-base-shadow,0 1px 2px rgb(0 0 0 / 0.05)));font-size:1rem;line-height:1.5rem;outline-offset:2px"

///|
const InputInvalidStyle : String = "border-color:var(--rui-destructive-border,var(--rui-destructive,oklch(0.577 0.245 27.325)));box-shadow:0 0 0 3px var(--rui-destructive-ring,oklch(0.577 0.245 27.325 / 0.2))"

///|
fn input_invalid_style(invalid : Bool) -> String {
  if invalid {
    InputInvalidStyle
  } else {
    ""
  }
}

///|
/// Render a controlled native input using the shadcn/ui Vega field recipe.
///
/// `on_input` is the immediate value-change channel; `on_change` follows the
/// browser's native change event. User styles are appended last.
pub fn input(
  input_type? : @html.InputType = @html.Text,
  name? : String,
  value? : String,
  checked? : Bool,
  read_only? : Bool,
  multiple? : Bool,
  accept? : String,
  placeholder? : String,
  auto_complete? : @html.AutoComplete,
  max? : Int,
  min? : Int,
  step? : Int,
  maxlength? : Int,
  minlength? : Int,
  pattern? : String,
  size? : Int,
  width? : Int,
  height? : Int,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  disabled? : Bool = false,
  required? : Bool,
  autofocus? : Bool,
  list? : String,
  inputmode? : String,
  invalid? : Bool = false,
  on_change? : @cmd.Emit[String],
  on_input? : @cmd.Emit[String],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  slot? : String = "input",
) -> @html.Html {
  let attrs = ui_attrs(attrs).data_set("slot", slot)
  if disabled {
    ignore(attrs.disabled(true).data_set("disabled", ""))
  }
  if invalid {
    ignore(attrs.aria_invalid("true").data_set("invalid", ""))
  }
  @html.input(
    input_type~,
    name?,
    value?,
    checked?,
    read_only?,
    multiple?,
    accept?,
    placeholder?,
    auto_complete?,
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        UiTransition,
        InputBaseStyle,
        input_invalid_style(invalid),
        ui_disabled_style(disabled),
      ],
      style,
    ),
    max?,
    min?,
    step?,
    maxlength?,
    minlength?,
    pattern?,
    size?,
    width?,
    height?,
    id?,
    class?,
    title?,
    hidden?,
    required?,
    autofocus?,
    list?,
    inputmode?,
    on_change?,
    on_input?,
    attrs~,
  )
}
