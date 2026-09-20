///|
// Internal controller for alert dialogs, sheets, and drawers.
priv struct DialogController {
  id : String
  open : Bool
  open_command : @cmd.Cmd
  close_command : @cmd.Cmd
  on_close : @cmd.Emit[String]?
  on_cancel : @cmd.Cmd?
  native_open : Bool?
  modal : Bool
  close_on_escape : Bool
}

///|
#cfg(target="js")
priv struct DialogModel {
  open : Bool
  generation : Int
} derive(Eq)

///|
#cfg(target="js")
priv enum DialogMessage {
  OpenDialog
  RequestDialogClose
  FinalizeDialogClose(Int)
  DialogDidClose(String)
}

///|
const DialogExitDurationMs : Int = 200

///|
const DialogNativeStyle : String = "width:100vw;height:100vh;max-width:none;max-height:none;margin:auto;border:0;padding:0;background:transparent;color:inherit;overflow:visible;pointer-events:none;transition:display 200ms,overlay 200ms;transition-behavior:allow-discrete"

///|
const DialogOverlayStyle : String = "position:fixed;inset:0;z-index:50;background:rgb(0 0 0 / 0.5);opacity:var(--rui-dialog-overlay-opacity,1);pointer-events:auto;transition:opacity 200ms ease"

///|
const DialogPositionerStyle : String = "position:fixed;inset:0;z-index:51;display:grid;place-items:center;overflow-y:auto;padding:1rem;pointer-events:none"

///|
const DialogContentStyle : String = "position:relative;display:grid;width:min(100%,32rem);max-height:calc(100vh - 2rem);gap:1rem;overflow-y:auto;border:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:var(--rui-radius,0.625rem);background:var(--rui-popover,var(--rui-background,oklch(1 0 0)));padding:1.5rem;color:var(--rui-popover-foreground,var(--rui-foreground,oklch(0.145 0 0)));box-shadow:0 16px 48px rgb(0 0 0 / 0.18);opacity:var(--rui-dialog-content-opacity,1);transform:var(--rui-dialog-content-transform,translateY(0) scale(1));pointer-events:auto;transition:opacity 200ms ease,transform 200ms ease"

///|
fn DialogController::title_id(self : DialogController) -> String {
  "\{self.id}-title"
}

///|
fn DialogController::description_id(self : DialogController) -> String {
  "\{self.id}-description"
}

///|
#cfg(target="js")
fn[T] dialog_emit_or_none(emit : @cmd.Emit[T]?, value : T) -> @cmd.Cmd {
  if emit is Some(emit) {
    emit(value)
  } else {
    @cmd.none
  }
}

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
fn dialog_overlay_part(
  scope : DialogController,
  slot~ : String,
  close_on_overlay~ : Bool,
  id~ : String?,
  class~ : String?,
  title~ : String?,
  hidden~ : Bool?,
  attrs~ : @html.Attrs?,
  style~ : Array[String],
) -> @html.Html {
  let element_attrs = dialog_state_attrs(attrs, slot, scope.open)
  if close_on_overlay {
    ignore(
      element_attrs.on_click(_ => {
        if ui_dialog_should_close_outside() {
          scope.close_command
        } else {
          @cmd.none
        }
      }),
    )
  }
  @html.div(
    style=ui_styles(
      [UiBoxSizing, DialogOverlayStyle, dialog_overlay_motion_style(scope.open)],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=element_attrs,
    @html.nothing,
  )
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

///|
#cfg(target="js")
fn stateful_dialog(
  id~ : String,
  default_open? : Bool = false,
  modal? : Bool = true,
  close_on_escape? : Bool = true,
  on_open_change? : @cmd.Emit[Bool],
  on_close? : @cmd.Emit[String],
  children : (DialogController) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  let (model, emit) = @rabbita.create_state_with_init(
    init=fn(emit) {
      (
        { open: default_open, generation: 0, },
        @cmd.batch([
          ui_dialog_bind(id, emit(RequestDialogClose)),
          if default_open {
            ui_dialog_show(id, modal)
          } else {
            @cmd.none
          },
        ]),
      )
    },
    update=fn(current, message, emit) {
      match message {
        OpenDialog =>
          if current.open {
            (current, @cmd.none)
          } else {
            let next = { open: true, generation: current.generation + 1, }
            (
              next,
              @cmd.batch([
                dialog_emit_or_none(on_open_change, true),
                ui_dialog_show(id, modal),
              ]),
            )
          }
        RequestDialogClose =>
          if current.open {
            let generation = current.generation + 1
            (
              { open: false, generation, },
              @cmd.batch([
                dialog_emit_or_none(on_open_change, false),
                @rabbita.delay(
                  emit(FinalizeDialogClose(generation)),
                  DialogExitDurationMs,
                ),
              ]),
            )
          } else {
            (current, @cmd.none)
          }
        FinalizeDialogClose(generation) =>
          if !current.open && current.generation == generation {
            (current, ui_dialog_close(id))
          } else {
            (current, @cmd.none)
          }
        DialogDidClose(value) =>
          (
            { open: false, generation: current.generation + 1, },
            @cmd.batch([
              if current.open {
                dialog_emit_or_none(on_open_change, false)
              } else {
                @cmd.none
              },
              dialog_emit_or_none(on_close, value),
            ]),
          )
      }
    },
  )
  model.view(model => {
    let scope : DialogController = {
      id,
      open: model.open,
      open_command: emit(OpenDialog),
      close_command: emit(RequestDialogClose),
      on_close: Some(emit.map(value => DialogDidClose(value))),
      on_cancel: Some(
        if close_on_escape {
          emit(RequestDialogClose)
        } else {
          @cmd.none
        },
      ),
      native_open: None,
      modal,
      close_on_escape,
    }
    children(scope)
  })
}

///|
#cfg(not(target="js"))
fn stateful_dialog(
  id~ : String,
  default_open? : Bool = false,
  modal? : Bool = true,
  close_on_escape? : Bool = true,
  on_open_change? : @cmd.Emit[Bool],
  on_close? : @cmd.Emit[String],
  children : (DialogController) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  ignore((on_open_change, on_close))
  let scope : DialogController = {
    id,
    open: default_open,
    open_command: @cmd.none,
    close_command: @cmd.none,
    on_close: None,
    on_cancel: None,
    native_open: Some(default_open),
    modal,
    close_on_escape,
  }
  @rabbita.Val::constant(children(scope))
}
