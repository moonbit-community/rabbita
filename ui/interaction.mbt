///|
#cfg(target="js")
extern "js" fn ffi_bind_dialog_layer(
  id : String,
  request_close : () -> Unit,
) -> Unit =
  #| (id, requestClose) => {
  #|   const dialog = document.getElementById(id)
  #|   if (typeof HTMLDialogElement === "undefined"
  #|     || !(dialog instanceof HTMLDialogElement)) return
  #|   dialog.__ruiRequestClose = requestClose
  #|   const stack = globalThis.__ruiDialogStack ||= []
  #|   const remove = () => {
  #|     const index = stack.indexOf(id)
  #|     if (index >= 0) stack.splice(index, 1)
  #|   }
  #|   if (!dialog.__ruiDialogBound) {
  #|     dialog.__ruiDialogBound = true
  #|     dialog.addEventListener("close", () => {
  #|       remove()
  #|       if (dialog.dataset.modal !== "false"
  #|         || dialog.dataset.restoreFocus === "false") return
  #|       const restore = () => {
  #|         const active = document.activeElement
  #|         if (active && active !== document.body && !dialog.contains(active)) return
  #|         const finalId = dialog.dataset.finalFocusId || ""
  #|         const target = document.getElementById(finalId) || dialog.__ruiReturnFocus
  #|         if (target instanceof HTMLElement && target.isConnected) {
  #|           target.focus({ preventScroll: true })
  #|         }
  #|       }
  #|       if (typeof queueMicrotask === "function") queueMicrotask(restore)
  #|       else setTimeout(restore, 0)
  #|     })
  #|   }
  #|   if (document.__ruiDialogLayerBound) return
  #|   document.__ruiDialogLayerBound = true
  #|   const topDialog = () => {
  #|     for (let index = stack.length - 1; index >= 0; index -= 1) {
  #|       const candidate = document.getElementById(stack[index])
  #|       if (candidate instanceof HTMLDialogElement && candidate.open) return candidate
  #|       stack.splice(index, 1)
  #|     }
  #|     return null
  #|   }
  #|   const hasFloatingLayer = () => {
  #|     try {
  #|       if (document.querySelector(":popover-open")) return true
  #|     } catch (_) {
  #|     }
  #|     const floatingStack = globalThis.__ruiFloatingStack ||= []
  #|     for (let index = floatingStack.length - 1; index >= 0; index -= 1) {
  #|       const item = document.getElementById(floatingStack[index])
  #|       if (!item || !item.isConnected) {
  #|         floatingStack.splice(index, 1)
  #|         continue
  #|       }
  #|       if (item instanceof HTMLDialogElement && item.open) return true
  #|       try {
  #|         if (item.matches(":popover-open")) return true
  #|       } catch (_) {
  #|         if (item.__ruiFloatingOpen) return true
  #|       }
  #|       floatingStack.splice(index, 1)
  #|     }
  #|     return false
  #|   }
  #|   document.addEventListener("pointerdown", () => {
  #|     globalThis.__ruiDialogOutsidePressHadFloating = hasFloatingLayer()
  #|   }, true)
  #|   document.addEventListener("keydown", event => {
  #|     if (event.key !== "Escape" || event.defaultPrevented) return
  #|     if (hasFloatingLayer()) return
  #|     const current = topDialog()
  #|     if (!current) return
  #|     if (current.dataset.closeOnEscape !== "true") return
  #|     event.preventDefault()
  #|     event.stopPropagation()
  #|     current.__ruiRequestClose?.()
  #|   })
  #|   document.addEventListener("click", event => {
  #|     if (event.defaultPrevented) return
  #|     const hadFloating = Boolean(globalThis.__ruiDialogOutsidePressHadFloating)
  #|     globalThis.__ruiDialogOutsidePressHadFloating = false
  #|     if (hadFloating) return
  #|     if (hasFloatingLayer()) return
  #|     const current = topDialog()
  #|     if (!current || current.dataset.modal !== "false") return
  #|     const content = current.querySelector(
  #|       '[data-slot="dialog-content"], [data-slot="sheet-content"], [data-slot="drawer-content"]',
  #|     )
  #|     const path = typeof event.composedPath === "function" ? event.composedPath() : []
  #|     if (content && (content.contains(event.target) || path.includes(content))) return
  #|     if (current.dataset.closeOnOutside === "true") current.__ruiRequestClose?.()
  #|   })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_should_close_dialog_outside() -> Bool =
  #| () => {
  #|   const hadFloating = Boolean(globalThis.__ruiDialogOutsidePressHadFloating)
  #|   globalThis.__ruiDialogOutsidePressHadFloating = false
  #|   if (hadFloating) return false
  #|   try {
  #|     if (document.querySelector(":popover-open")) return false
  #|   } catch (_) {
  #|   }
  #|   const stack = globalThis.__ruiFloatingStack ||= []
  #|   for (let index = stack.length - 1; index >= 0; index -= 1) {
  #|     const item = document.getElementById(stack[index])
  #|     if (!item || !item.isConnected) {
  #|       stack.splice(index, 1)
  #|       continue
  #|     }
  #|     if (typeof HTMLDialogElement !== "undefined"
  #|       && item instanceof HTMLDialogElement && item.open) return false
  #|     if (item.__ruiFloatingOpen) return false
  #|     stack.splice(index, 1)
  #|   }
  #|   return true
  #| }

///|
#cfg(target="js")
fn ui_dialog_should_close_outside() -> Bool {
  ffi_should_close_dialog_outside()
}

///|
#cfg(not(target="js"))
fn ui_dialog_should_close_outside() -> Bool {
  true
}

///|
#cfg(target="js")
extern "js" fn ffi_mark_dialog_layer(id : String, open : Bool) -> Unit =
  #| (id, open) => {
  #|   const stack = globalThis.__ruiDialogStack ||= []
  #|   const index = stack.indexOf(id)
  #|   if (index >= 0) stack.splice(index, 1)
  #|   if (!open) return
  #|   const dialog = document.getElementById(id)
  #|   if (typeof HTMLDialogElement === "undefined"
  #|     || !(dialog instanceof HTMLDialogElement)) return
  #|   const active = document.activeElement
  #|   if (active instanceof HTMLElement && !dialog.contains(active)) {
  #|     dialog.__ruiReturnFocus = active
  #|   }
  #|   stack.push(id)
  #|   if (dialog.dataset.modal !== "false"
  #|     || dialog.dataset.initialFocus === "false") return
  #|   const focusInitial = () => {
  #|     if (!dialog.open) return
  #|     const requested = document.getElementById(dialog.dataset.initialFocusId || "")
  #|     const selector = [
  #|       'button:not([disabled])',
  #|       'a[href]',
  #|       'input:not([disabled])',
  #|       'select:not([disabled])',
  #|       'textarea:not([disabled])',
  #|       '[tabindex]:not([tabindex="-1"])',
  #|     ].join(',')
  #|     const target = requested && dialog.contains(requested)
  #|       ? requested
  #|       : dialog.querySelector(selector) || dialog
  #|     if (target instanceof HTMLElement) target.focus({ preventScroll: true })
  #|   }
  #|   if (typeof requestAnimationFrame === "function") requestAnimationFrame(focusInitial)
  #|   else focusInitial()
  #| }

///|
#cfg(target="js")
fn ui_dialog_bind(id : String, request_close : @cmd.Cmd) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, scheduler => {
    ui_after_mount(
      id,
      () => ffi_bind_dialog_layer(id, () => scheduler.add(request_close)),
      purpose="dialog-bind",
    )
  })
}

///|
#cfg(not(target="js"))
fn ui_dialog_bind(id : String, request_close : @cmd.Cmd) -> @cmd.Cmd {
  ignore((id, request_close))
  @cmd.none
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
          ffi_mark_dialog_layer(id, true)
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
      ffi_mark_dialog_layer(id, false)
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
fn ui_dialog_request_close(id : String) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.after_render, _ => {
    if @dom.document().get_element_by_id(id).to_option() is Some(element) &&
      element.to_html_element() is Some(html_element) &&
      html_element.to_html_dialog_element() is Some(dialog) {
      dialog.request_close()
    }
  })
}

///|
#cfg(not(target="js"))
fn ui_dialog_request_close(id : String) -> @cmd.Cmd {
  ignore(id)
  @cmd.none
}

///|
#cfg(target="js")
fn ui_popover_show(id : String) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.after_render, _ => {
    if @dom.document().get_element_by_id(id).to_option() is Some(element) &&
      element.to_html_element() is Some(html_element) {
      html_element.show_popover()
    }
  })
}

///|
#cfg(not(target="js"))
fn ui_popover_show(id : String) -> @cmd.Cmd {
  ignore(id)
  @cmd.none
}

///|
#cfg(target="js")
fn ui_popover_hide(id : String) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.after_render, _ => {
    if @dom.document().get_element_by_id(id).to_option() is Some(element) &&
      element.to_html_element() is Some(html_element) {
      html_element.hide_popover()
    }
  })
}

///|
#cfg(not(target="js"))
fn ui_popover_hide(id : String) -> @cmd.Cmd {
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
