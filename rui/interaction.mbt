///|
#cfg(target="js")
fn ui_focus_id(id : String) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.after_render, _ => {
    if @dom.document().get_element_by_id(id).to_option() is Some(element) &&
      element.to_html_element() is Some(html_element) {
      html_element.focus()
    }
  })
}

///|
#cfg(not(target="js"))
fn ui_focus_id(id : String) -> @cmd.Cmd {
  ignore(id)
  @cmd.none
}

///|
#cfg(target="js")
fn ui_scroll_id(id : String, end_ : Bool) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.after_render, _ => {
    if @dom.document().get_element_by_id(id).to_option() is Some(element) {
      if end_ {
        element.set_scroll_top(element.get_scroll_height())
      } else {
        element.set_scroll_top(0.0)
      }
    }
  })
}

///|
#cfg(not(target="js"))
fn ui_scroll_id(id : String, end_ : Bool) -> @cmd.Cmd {
  ignore((id, end_))
  @cmd.none
}
