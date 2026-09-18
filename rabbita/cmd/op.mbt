///|
#internal(experimental, "This API is unstable and may change in the future.")
pub extenum Extension += {
  LegacyEffect(EffectKind, (&Scheduler) -> Unit)
  LegacyMessage(OnExecute)
  Delay(Cmd, Int)
}

///|
let op : Op = Op()..on_invoke(on_invoke)

///|
pub fn delay(cmd : Cmd, ms : Int) -> Cmd {
  op.request(Delay(cmd, ms))
}

///|
#cfg(target="js")
fn on_invoke(
  extension : Extension,
  _context : &Context,
) -> OpCont[Cmd] raise Unhandled {
  match extension {
    LegacyEffect(kind, f) => LegacyEffect(kind, f)
    LegacyMessage(f) => LegacyEffect(Immediately, f)
    Delay(cmd, ms) =>
      Async(() => {
        let _ = set_timeout(ms).wait()
        cmd
      })
    _ => raise Unhandled
  }
}

///|
#cfg(target="js")
extern "js" fn set_timeout(ms : Int) -> @js.Promise[Int] =
  #| ms => new Promise(resolve => { setTimeout(() => resolve(0), ms) })

///|
#cfg(not(target="js"))
fn on_invoke(
  extension : Extension,
  _context : &Context,
) -> OpCont[Cmd] raise Unhandled {
  match extension {
    LegacyEffect(kind, f) => LegacyEffect(kind, f)
    Delay(cmd, _) => Ready(cmd)
    _ => raise Unhandled
  }
}
