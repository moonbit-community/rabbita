///|
const DialogExitDurationMs : Int = 200

///|
const DialogNativeStyle : String = "width:100vw;height:100vh;max-width:none;max-height:none;margin:auto;border:0;padding:0;background:transparent;color:inherit;overflow:visible;pointer-events:none;transition:display 200ms,overlay 200ms;transition-behavior:allow-discrete"

///|
const DialogOverlayStyle : String = "position:fixed;inset:0;z-index:50;background:rgb(0 0 0 / 0.5);opacity:var(--rui-dialog-overlay-opacity,1);pointer-events:auto;transition:opacity 200ms ease"

///|
const DialogPositionerStyle : String = "position:fixed;inset:0;z-index:51;display:grid;place-items:center;overflow-y:auto;padding:1rem;pointer-events:none"

///|
fn dialog_state_value(open : Bool) -> String {
  if open {
    "open"
  } else {
    "closed"
  }
}

///|
fn dialog_overlay_motion_style(open : Bool) -> String {
  if open {
    "--rui-dialog-overlay-opacity:1"
  } else {
    "--rui-dialog-overlay-opacity:0;pointer-events:none"
  }
}

///|
fn dialog_content_motion_style(open : Bool) -> String {
  if open {
    "--rui-dialog-content-opacity:1;--rui-dialog-content-transform:translateY(0) scale(1)"
  } else {
    "--rui-dialog-content-opacity:0;--rui-dialog-content-transform:translateY(-0.5rem) scale(0.95);pointer-events:none"
  }
}

///|
fn dialog_state_attrs(
  attrs : @html.Attrs?,
  slot : String,
  open : Bool,
) -> @html.Attrs {
  let state = dialog_state_value(open)
  let element_attrs = ui_attrs(attrs)
    .data_set("slot", slot)
    .data_set("state", state)
  if open {
    ignore(element_attrs.data_set("open", ""))
  } else {
    ignore(element_attrs.data_set("closed", ""))
  }
  element_attrs
}

///|
fn[C : @html.IsChildren] dialog_control_button(
  slot~ : String,
  command~ : @cmd.Cmd,
  variant~ : ButtonVariant,
  size~ : ButtonSize,
  disabled~ : Bool,
  id~ : String?,
  class~ : String?,
  title~ : String?,
  aria_label~ : String?,
  on_click~ : @cmd.Cmd?,
  attrs~ : @html.Attrs?,
  style~ : Array[String],
  children : C,
) -> @html.Html {
  let control_attrs = ui_attrs(attrs)
    .data_set("slot", slot)
    .data_set("variant", button_variant_value(variant))
    .data_set("size", button_size_value(size))
  ignore(control_attrs.aria_disabled(ui_bool(disabled)))
  if aria_label is Some(label) {
    ignore(control_attrs.aria_label(label))
  }
  if disabled {
    ignore(control_attrs.data_set("disabled", ""))
  } else {
    if on_click is Some(on_click) {
      ignore(control_attrs.on_click(_ => on_click))
    }
    ignore(control_attrs.on_click(_ => command))
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
      ],
      style,
    ),
    id?,
    class?,
    title?,
    type_="button",
    disabled~,
    attrs=control_attrs,
    children,
  )
}
