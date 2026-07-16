///|
const FormFieldLayoutStyle : String = "display:flex;width:100%;flex-direction:column;gap:0.5rem"

///|
const FormFieldInvalidStyle : String = "color:var(--rui-destructive,oklch(0.577 0.245 27.325))"

///|
pub fn[C : @html.IsChildren] form(
  action? : String,
  name? : String,
  on_submit? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.form(
    action?,
    name?,
    on_submit?,
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "form"),
    style=ui_styles(
      [UiBoxSizing, UiFontSans, "display:flex;flex-direction:column;gap:1.5rem"],
      style,
    ),
    children,
  )
}

///|
/// Adapt caller-owned field state into one semantic Rabbita form group.
///
/// This is not React Hook Form's context-backed `FormField`: it does not
/// register, validate, or retain a value. Pass the field name and validity from
/// the application's TEA model, and keep native `id`, `for`, and description
/// relationships explicit on the composed controls.
pub fn[C : @html.IsChildren] form_field(
  name~ : String,
  invalid? : Bool = false,
  required? : Bool = false,
  describedby? : String,
  errormessage? : String,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let field_attrs = ui_attrs(attrs)
    .role("group")
    .data_set("slot", "form-field")
    .data_set("name", name)
    .data_set("invalid", ui_bool(invalid))
    .data_set("required", ui_bool(required))
  if invalid {
    ignore(field_attrs.aria_invalid("true"))
  }
  if required {
    ignore(field_attrs.aria_required("true"))
  }
  if describedby is Some(description_id) {
    ignore(field_attrs.aria_describedby(description_id))
  }
  if invalid && errormessage is Some(message_id) {
    ignore(field_attrs.aria_errormessage(message_id))
  }
  @html.div(
    id?,
    class?,
    title?,
    attrs=field_attrs,
    style=ui_styles(
      [FormFieldLayoutStyle, if invalid { FormFieldInvalidStyle } else { "" }],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] form_item(
  invalid? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let item_attrs = ui_attrs(attrs)
    .role("group")
    .data_set("slot", "form-item")
    .data_set("invalid", ui_bool(invalid))
  if invalid {
    ignore(item_attrs.aria_invalid("true"))
  }
  @html.div(
    id?,
    class?,
    title?,
    attrs=item_attrs,
    style=ui_styles(
      [FormFieldLayoutStyle, if invalid { FormFieldInvalidStyle } else { "" }],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] form_label(
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
    attrs=ui_attrs(attrs).data_set("slot", "form-label"),
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
pub fn[C : @html.IsChildren] form_control(
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
    attrs=ui_attrs(attrs).data_set("slot", "form-control"),
    style=ui_styles(["min-width:0"], style),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] form_description(
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
    attrs=ui_attrs(attrs).data_set("slot", "form-description"),
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
pub fn[C : @html.IsChildren] form_message(
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
    attrs=ui_attrs(attrs).role("alert").data_set("slot", "form-message"),
    style=ui_styles(
      [
        "color:var(--rui-destructive,oklch(0.577 0.245 27.325));font-size:0.875rem;line-height:1.25rem;font-weight:400",
      ],
      style,
    ),
    children,
  )
}
