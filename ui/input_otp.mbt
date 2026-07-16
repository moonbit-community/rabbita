///|
priv struct InputOtpModel {
  value : String
} derive(Eq)

///|
priv enum InputOtpMsg {
  SetOtpValue(String)
}

///|
/// Opaque render scope owned by `input_otp`.
struct InputOtpScope {
  model : InputOtpModel
  max_length : Int
  invalid : Bool
  disabled : Bool
  input_id : String
  emit : @cmd.Emit[InputOtpMsg]
}

///|
fn otp_normalize(value : String, max_length : Int) -> String {
  let mut result = ""
  let mut count = 0
  for character in value {
    if count < max_length {
      result = result + "\{character}"
      count += 1
    }
  }
  result
}

///|
fn otp_chars(value : String) -> Array[Char] {
  let chars : Array[Char] = []
  for character in value {
    chars.push(character)
  }
  chars
}

///|
fn input_otp_control_attrs(
  scope : InputOtpScope,
  attrs : @html.Attrs?,
) -> @html.Attrs {
  let control_attrs = ui_attrs(attrs).data_set("slot", "input-otp-control")
  if scope.disabled {
    ignore(control_attrs.disabled(true))
  }
  control_attrs
}

///|
pub fn[C : @html.IsChildren] input_otp_group(
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
    attrs=ui_attrs(attrs).data_set("slot", "input-otp-group"),
    style=ui_styles(["display:flex;align-items:center"], style),
    children,
  )
}

///|
pub fn input_otp_slot(
  scope~ : InputOtpScope,
  index~ : Int,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let chars = otp_chars(scope.model.value)
  let char_count = chars.length()
  let active_index = if char_count >= scope.max_length {
    scope.max_length - 1
  } else {
    char_count
  }
  let current = index == active_index
  let value = if index >= 0 && index < char_count {
    "\{chars[index]}"
  } else {
    ""
  }
  let slot_attrs = ui_attrs(attrs)
    .aria_hidden("true")
    .data_set("slot", "input-otp-slot")
    .data_set("index", "\{index}")
    .data_set("active", ui_bool(current))
    .data_set("current", ui_bool(current))
  if scope.invalid {
    ignore(slot_attrs.aria_invalid("true"))
  }
  @html.div(
    id?,
    class?,
    title?,
    attrs=slot_attrs,
    style=ui_styles(
      [
        UiBoxSizing,
        UiTransition,
        "position:relative;display:flex;width:2.25rem;height:2.25rem;align-items:center;justify-content:center;border-block:1px solid var(--rui-otp-border,var(--rui-input,oklch(0.922 0 0)));border-inline-end:1px solid var(--rui-otp-border,var(--rui-input,oklch(0.922 0 0)));background:var(--rui-input-background,transparent);font-size:0.875rem;line-height:1.25rem;box-shadow:var(--rui-otp-shadow,0 1px 2px rgb(0 0 0 / 0.05));outline:none",
        if scope.invalid {
          "--rui-otp-border:var(--rui-destructive-border,var(--rui-destructive,oklch(0.577 0.245 27.325)))"
        } else {
          ""
        },
      ],
      style,
    ),
    [
      @html.span(style=["display:contents"], value),
      if current && index >= char_count {
        @html.span(
          attrs=@html.Attrs::build()
            .aria_hidden("true")
            .data_set("slot", "input-otp-caret"),
          style=[
            "pointer-events:none;position:absolute;inset:0;display:flex;align-items:center;justify-content:center",
          ],
          @html.span(
            style=[
              "display:block;width:1px;height:1rem;background:var(--rui-foreground,oklch(0.145 0 0));animation:rui-caret-blink 1s ease-out infinite",
            ],
            "",
          ),
        )
      } else {
        @html.nothing
      },
    ],
  )
}

///|
pub fn input_otp_separator(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .role("separator")
      .data_set("slot", "input-otp-separator"),
    style=ui_styles(
      [
        "display:flex;width:1.5rem;height:1rem;flex:none;align-items:center;justify-content:center;color:var(--rui-muted-foreground,oklch(0.556 0 0))",
      ],
      style,
    ),
    ui_minus_icon(),
  )
}

///|
fn input_otp_default_view(
  scope : InputOtpScope,
  separator_after : Int,
) -> @html.Html {
  let split = if separator_after > 0 && separator_after < scope.max_length {
    separator_after
  } else {
    -1
  }
  if split < 0 {
    let slots : Array[@html.Html] = []
    for index in 0..<scope.max_length {
      slots.push(input_otp_slot(scope~, index~))
    }
    return input_otp_group(slots)
  }
  let leading : Array[@html.Html] = []
  let trailing : Array[@html.Html] = []
  for index in 0..<split {
    leading.push(input_otp_slot(scope~, index~))
  }
  for index in split..<scope.max_length {
    trailing.push(input_otp_slot(scope~, index~))
  }
  @html.fragment([
    input_otp_group(leading),
    input_otp_separator(),
    input_otp_group(trailing),
  ])
}

///|
fn render_input_otp(
  scope : InputOtpScope,
  separator_after : Int,
  aria_label : String,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  input_attrs : @html.Attrs?,
  style : Array[String],
  render : ((InputOtpScope) -> @html.Html)?,
) -> @html.Html {
  let content = if render is Some(render) {
    render(scope)
  } else {
    input_otp_default_view(scope, separator_after)
  }
  @html.div(
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "input-otp"),
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        "position:relative;display:inline-flex;width:fit-content;align-items:center;gap:0.5rem",
        ui_disabled_visual_style(scope.disabled),
      ],
      style,
    ),
    [
      @html.input(
        input_type=@html.Text,
        value=scope.model.value,
        maxlength=scope.max_length,
        inputmode="numeric",
        id=scope.input_id,
        on_input=scope.emit.map(value => SetOtpValue(value)),
        attrs=input_otp_control_attrs(scope, input_attrs)
          .aria_label(aria_label)
          .aria_invalid(ui_bool(scope.invalid)),
        style=[
          "box-sizing:border-box;position:absolute;inset:0;z-index:20;width:100%;height:100%;margin:0;border:0;background:transparent;padding:0;opacity:0.001;color:transparent;caret-color:transparent;cursor:text;appearance:none;-webkit-appearance:none",
        ],
      ),
      content,
    ],
  )
}

///|
#cfg(target="js")
pub fn input_otp(
  id~ : String,
  max_length? : Int = 6,
  default_value? : String = "",
  separator_after? : Int = -1,
  disabled? : Bool = false,
  invalid? : Bool = false,
  aria_label? : String = "One-time password",
  on_value_change? : @cmd.Emit[String],
  on_complete? : @cmd.Emit[String],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  input_attrs? : @html.Attrs,
  style? : Array[String] = [],
  render? : (InputOtpScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  let initial_value = otp_normalize(default_value, max_length)
  let (model, emit) = @rabbita.create_state({ value: initial_value }, update=fn(
    _,
    msg,
    model,
  ) {
    match msg {
      SetOtpValue(value) => {
        let value = otp_normalize(value, max_length)
        let commands : Array[@cmd.Cmd] = []
        if on_value_change is Some(notify) {
          commands.push(notify(value))
        }
        if value.char_length() == max_length &&
          model.value.char_length() != max_length &&
          on_complete is Some(complete) {
          commands.push(complete(value))
        }
        ({ value, }, @cmd.batch(commands))
      }
    }
  })
  model.view(model => {
    render_input_otp(
      { model, max_length, invalid, disabled, input_id: id, emit },
      separator_after,
      aria_label,
      class,
      title,
      attrs,
      input_attrs,
      style,
      render,
    )
  })
}

///|
#cfg(not(target="js"))
pub fn input_otp(
  id~ : String,
  max_length? : Int = 6,
  default_value? : String = "",
  separator_after? : Int = -1,
  disabled? : Bool = false,
  invalid? : Bool = false,
  aria_label? : String = "One-time password",
  on_value_change? : @cmd.Emit[String],
  on_complete? : @cmd.Emit[String],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  input_attrs? : @html.Attrs,
  style? : Array[String] = [],
  render? : (InputOtpScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  ignore((on_value_change, on_complete))
  let model = { value: otp_normalize(default_value, max_length) }
  let emit = @cmd.Emit(_ => @cmd.none)
  @rabbita.Val::constant(
    render_input_otp(
      { model, max_length, invalid, disabled, input_id: id, emit },
      separator_after,
      aria_label,
      class,
      title,
      attrs,
      input_attrs,
      style,
      render,
    ),
  )
}
