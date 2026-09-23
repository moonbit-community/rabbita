///|
priv struct CheckboxModel {
  checked : Bool
  indeterminate : Bool
} derive(Eq)

///|
priv enum CheckboxMsg {
  CheckboxChange(Bool)
}

///|
/// Build a black-box checkbox with component-local incremental state.
#cfg(target="js")
pub fn checkbox(
  default_checked? : Bool = false,
  default_indeterminate? : Bool = false,
  disabled? : Bool = false,
  read_only? : Bool = false,
  invalid? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  on_checked_change? : @cmd.Emit[Bool],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @rabbita.Val[@html.Html] {
  let initial = {
    checked: default_checked,
    indeterminate: default_indeterminate,
  }
  let (model, emit) = @rabbita.create_state(initial, update=fn(_, msg, _) {
    let next = match msg {
      CheckboxChange(checked) => { checked, indeterminate: false, }
    }
    let command = if on_checked_change is Some(notify) {
      notify(next.checked)
    } else {
      @cmd.none
    }
    (next, command)
  })
  model.view(model => {
    @checkbox_view.render(
      checked=model.checked,
      indeterminate=model.indeterminate,
      disabled~,
      read_only~,
      invalid~,
      id?,
      class?,
      title?,
      aria_label?,
      on_checked_change=Emit(checked => emit(CheckboxChange(checked))),
      attrs?,
      style~,
    )
  })
}

///|
/// Native/SSR fallback for `checkbox`: render the initial state as a constant
/// incremental value.
#cfg(not(target="js"))
pub fn checkbox(
  default_checked? : Bool = false,
  default_indeterminate? : Bool = false,
  disabled? : Bool = false,
  read_only? : Bool = false,
  invalid? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  on_checked_change? : @cmd.Emit[Bool],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @rabbita.Val[@html.Html] {
  ignore(on_checked_change)
  @rabbita.Val::constant(
    @checkbox_view.render(
      checked=default_checked,
      indeterminate=default_indeterminate,
      disabled~,
      read_only~,
      invalid~,
      id?,
      class?,
      title?,
      aria_label?,
      attrs?,
      style~,
    ),
  )
}
