///|
#cfg(target="js")
fn ui_dialog_should_close_outside() -> Bool {
  floating_top_layer() is None
}

///|
#cfg(not(target="js"))
fn ui_dialog_should_close_outside() -> Bool {
  true
}

///|
#cfg(target="js")
fn ui_dialog_show(id : String, modal : Bool) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.after_render, _ => {
    ui_after_mount(
      id,
      () => {
        if @dom.document().get_element_by_id(id).to_option() is Some(element) &&
          element.to_html_element() is Some(html_element) &&
          html_element.to_html_dialog_element() is Some(dialog) {
          if !dialog.open() {
            if modal {
              dialog.show_modal()
            } else {
              dialog.show()
            }
          }
        }
      },
      purpose="dialog-show",
    )
  })
}

///|
#cfg(not(target="js"))
fn ui_dialog_show(id : String, modal : Bool) -> @cmd.Cmd {
  ignore((id, modal))
  @cmd.none
}

///|
#cfg(target="js")
fn ui_dialog_close(id : String) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.after_render, _ => {
    if @dom.document().get_element_by_id(id).to_option() is Some(element) &&
      element.to_html_element() is Some(html_element) &&
      html_element.to_html_dialog_element() is Some(dialog) {
      if dialog.open() {
        dialog.close()
      }
    }
  })
}

///|
#cfg(not(target="js"))
fn ui_dialog_close(id : String) -> @cmd.Cmd {
  ignore(id)
  @cmd.none
}

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
