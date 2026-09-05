///|
/// Explicit scope passed by [`dialog`] to its compound parts.
///
/// Rabbita does not need a global component context here: the opaque scope
/// carries the component-local state and commands without exposing them to
/// callers.
struct DialogScope {
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
const DialogHeaderStyle : String = "display:flex;min-width:0;flex-direction:column;gap:0.375rem;text-align:start"

///|
const DialogFooterStyle : String = "display:flex;flex-wrap:wrap;align-items:center;justify-content:flex-end;gap:0.5rem"

///|
const DialogTitleStyle : String = "margin:0;color:var(--rui-foreground,oklch(0.145 0 0));font-size:1.125rem;line-height:1.25;font-weight:600;letter-spacing:-0.01em;text-wrap:balance"

///|
const DialogDescriptionStyle : String = "margin:0;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem;line-height:1.5;text-wrap:pretty"

///|
const DialogCloseIconButtonStyle : String = "position:absolute;top:1rem;inset-inline-end:1rem;background:var(--rui-close-bg,var(--rui-button-bg,var(--rui-button-base-bg,transparent)));color:var(--rui-close-fg,var(--rui-button-fg,var(--rui-button-base-fg,currentColor)));box-shadow:var(--rui-close-shadow,var(--rui-button-shadow,var(--rui-button-base-shadow,none)));opacity:var(--rui-close-opacity,var(--rui-close-base-opacity,0.7))"

///|
fn DialogScope::title_id(self : DialogScope) -> String {
  "\{self.id}-title"
}

///|
fn DialogScope::description_id(self : DialogScope) -> String {
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
  scope : DialogScope,
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
fn dialog_close_icon(scope : DialogScope, label : String) -> @html.Html {
  let icon_attrs = @html.Attrs::build().aria_hidden("true")
  let close_attrs = @html.Attrs::build()
    .data_set("rui-close-icon", "")
    .data_set("state", dialog_state_value(scope.open))
  dialog_control_button(
    slot="dialog-close",
    command=scope.close_command,
    variant=Ghost,
    size=IconSm,
    disabled=false,
    id=None,
    class=None,
    title=None,
    aria_label=Some(label),
    on_click=None,
    attrs=Some(close_attrs),
    style=[DialogCloseIconButtonStyle],
    @html.span(attrs=icon_attrs, ui_x_icon()),
  )
}

///|
/// Create a stateful native-dialog component.
///
/// The builder receives one opaque scope. Pass that scope to
/// [`dialog_trigger`], [`dialog_content`], and [`dialog_close`]. This is the
/// explicit Rabbita equivalent of shadcn's implicit Dialog context. Modal
/// dialogs use `showModal()` for inert background, focus containment, and
/// native Escape behavior. With `modal=false`, the page stays interactive and
/// Rabbita dismisses only the top non-modal layer.
#cfg(target="js")
pub fn dialog(
  id~ : String,
  default_open? : Bool = false,
  modal? : Bool = true,
  close_on_escape? : Bool = true,
  on_open_change? : @cmd.Emit[Bool],
  on_close? : @cmd.Emit[String],
  children : (DialogScope) -> @html.Html,
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
    let scope : DialogScope = {
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
pub fn dialog(
  id~ : String,
  default_open? : Bool = false,
  modal? : Bool = true,
  close_on_escape? : Bool = true,
  on_open_change? : @cmd.Emit[Bool],
  on_close? : @cmd.Emit[String],
  children : (DialogScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  ignore((on_open_change, on_close))
  let scope : DialogScope = {
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

///|
/// Render the default Vega trigger for a dialog scope.
///
/// Caller handlers stored in `attrs` and `on_click` run before the component's
/// open command; neither is discarded.
pub fn[C : @html.IsChildren] dialog_trigger(
  scope : DialogScope,
  variant? : ButtonVariant = Outline,
  size? : ButtonSize = Default,
  disabled? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  on_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let trigger_attrs = dialog_state_attrs(attrs, "dialog-trigger", scope.open)
    .aria_haspopup("dialog")
    .aria_controls(scope.id)
    .aria_expanded(ui_bool(scope.open))
  dialog_control_button(
    slot="dialog-trigger",
    command=scope.open_command,
    variant~,
    size~,
    disabled~,
    id~,
    class~,
    title~,
    aria_label~,
    on_click~,
    attrs=Some(trigger_attrs),
    style~,
    children,
  )
}

///|
/// Pass native-dialog content through without adding a DOM node.
///
/// Native `<dialog>` already enters the browser top layer, so a JavaScript
/// body portal would be redundant. The fragment keeps the familiar shadcn
/// compound API while preserving the caller's exact DOM structure.
pub fn dialog_portal(children : Array[@html.Html]) -> @html.Html {
  @html.fragment(children)
}

///|
/// Render the dialog backdrop associated with a compound dialog scope.
///
/// Caller click handlers run before the optional close command and are never
/// discarded. Set `close_on_overlay=false` for a non-dismissible backdrop.
pub fn dialog_overlay(
  scope : DialogScope,
  close_on_overlay? : Bool = true,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  dialog_overlay_part(
    scope,
    slot="dialog-overlay",
    close_on_overlay~,
    id~,
    class~,
    title~,
    hidden~,
    attrs~,
    style~,
  )
}

///|
/// Render the native dialog, backdrop, positioner, and Vega content surface.
///
/// `attrs` and `style` customize the visible content surface. Use
/// `native_attrs` / `native_style` for the underlying `<dialog>` and
/// `overlay_attrs` / `overlay_style` for the backdrop.
pub fn[C : @html.IsChildren] dialog_content(
  scope : DialogScope,
  close_on_overlay? : Bool = true,
  show_close? : Bool = true,
  close_label? : String = "Close",
  described? : Bool = true,
  aria_label? : String,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  overlay_attrs? : @html.Attrs,
  overlay_style? : Array[String] = [],
  native_attrs? : @html.Attrs,
  native_style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let native_element_attrs = dialog_state_attrs(
      native_attrs,
      "dialog-native",
      scope.open,
    )
    .data_set("modal", ui_bool(scope.modal))
    .data_set("close-on-outside", ui_bool(close_on_overlay))
    .data_set("close-on-escape", ui_bool(scope.close_on_escape))
  if scope.modal {
    ignore(native_element_attrs.aria_modal("true"))
  }
  if aria_label is Some(label) {
    ignore(native_element_attrs.aria_label(label))
  } else {
    ignore(native_element_attrs.aria_labelledby(scope.title_id()))
  }
  if described {
    ignore(native_element_attrs.aria_describedby(scope.description_id()))
  }
  let content_attrs = dialog_state_attrs(attrs, "dialog-content", scope.open)
  let positioner_attrs = dialog_state_attrs(
    None,
    "dialog-positioner",
    scope.open,
  )
  let content = @html.div(
    style=ui_styles(
      [UiBoxSizing, DialogContentStyle, dialog_content_motion_style(scope.open)],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=content_attrs,
    [
      @html.div(style=[UiBoxSizing, "display:contents"], children),
      if show_close {
        dialog_close_icon(scope, close_label)
      } else {
        @html.nothing
      },
    ],
  )
  let open = scope.native_open
  let on_close = scope.on_close
  let on_cancel = scope.on_cancel
  let closedby = if !scope.modal {
    "none"
  } else if close_on_overlay {
    "any"
  } else if scope.close_on_escape {
    "closerequest"
  } else {
    "none"
  }
  dialog_portal([
    @html.dialog(
      style=ui_styles([UiBoxSizing, DialogNativeStyle], native_style),
      id=scope.id,
      open?,
      closedby~,
      on_close?,
      on_cancel?,
      attrs=native_element_attrs,
      [
        if scope.modal {
          dialog_overlay(
            scope,
            close_on_overlay~,
            attrs=ui_attrs(overlay_attrs),
            style=overlay_style,
          )
        } else {
          @html.nothing
        },
        @html.div(
          style=[UiBoxSizing, DialogPositionerStyle],
          attrs=positioner_attrs,
          content,
        ),
      ],
    ),
  ])
}

///|
pub fn[C : @html.IsChildren] dialog_header(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, DialogHeaderStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "dialog-header"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] dialog_footer(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, DialogFooterStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "dialog-footer"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] dialog_title(
  scope : DialogScope,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_id = id.unwrap_or(scope.title_id())
  @html.h2(
    style=ui_styles([UiBoxSizing, DialogTitleStyle], style),
    id=element_id,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "dialog-title"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] dialog_description(
  scope : DialogScope,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_id = id.unwrap_or(scope.description_id())
  @html.p(
    style=ui_styles([UiBoxSizing, DialogDescriptionStyle], style),
    id=element_id,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "dialog-description"),
    children,
  )
}

///|
/// Render a close control wired to this dialog's internal state.
pub fn[C : @html.IsChildren] dialog_close(
  scope : DialogScope,
  variant? : ButtonVariant = Outline,
  size? : ButtonSize = Default,
  disabled? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  on_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  dialog_control_button(
    slot="dialog-close",
    command=scope.close_command,
    variant~,
    size~,
    disabled~,
    id~,
    class~,
    title~,
    aria_label~,
    on_click~,
    attrs~,
    style~,
    children,
  )
}
