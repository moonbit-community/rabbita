///|
extenum @cmd.Extension += {
  ClipboardCopy(Item, Cmd?, ((String) -> Cmd)?)
  ClipboardPaste((Item) -> Cmd, ((String) -> Cmd)?)
}

///|
let op : @cmd.Op = @cmd.Op()
  ..on_invoke(op_invoke)
  ..on_debug(extension => {
    match extension {
      ClipboardCopy(Text(text), _, _) =>
        Repr::ctor("ClipboardCopy", [
          (None, Repr::ctor("Text", [(None, Repr(text))])),
        ])
      ClipboardPaste(_, _) => Repr::ctor("ClipboardPaste", [])
      _ => raise Unhandled
    }
  })

///|
#cfg(target="js")
fn op_invoke(
  extension : @cmd.Extension,
  _context : &@cmd.Context,
) -> @cmd.OpCont[@cmd.Cmd] raise @cmd.Unhandled {
  match extension {
    ClipboardCopy(item, copied, failed) =>
      Async(() => {
        try {
          match item {
            Text(text) =>
              @dom.window().navigator().clipboard().write_text(text).wait()
          }
          if copied is Some(message) {
            message
          } else {
            @cmd.none
          }
        } catch {
          error =>
            if failed is Some(to_message) {
              to_message(error.to_string())
            } else {
              @cmd.none
            }
        }
      })
    ClipboardPaste(pasted, failed) =>
      Async(() => {
        try @dom.window().navigator().clipboard().read_text().wait() catch {
          error if failed is Some(to_message) => to_message(error.to_string())
          _ => @cmd.none
        } noraise {
          text => pasted(Text(text))
        }
      })
    _ => raise Unhandled
  }
}

///|
#cfg(not(target="js"))
#warnings("-unused_error_type")
fn op_invoke(
  extension : @cmd.Extension,
  _context : &@cmd.Context,
) -> @cmd.OpCont[Cmd] raise @cmd.Unhandled {
  match extension {
    ClipboardCopy(item, copied, failed) => {
      ignore(item)
      ignore(copied)
      ignore(failed)
      None
    }
    ClipboardPaste(pasted, failed) => {
      ignore(pasted)
      ignore(failed)
      None
    }
    _ => None
  }
}
