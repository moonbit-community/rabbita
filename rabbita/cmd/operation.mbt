///|
#internal(experimental, "This API is unstable and may change in the future.")
struct Op {
  mut invoke : (Extension, &Context) -> OpCont[Cmd] raise Unhandled
  mut settle : (Extension, &Context) -> OpCont[(Json, Cmd)] raise Unhandled
  mut resume_ : (Extension, Json, &Context) -> Cmd raise HydrateExn
  mut identify : (Extension) -> String raise Unhandled
  mut debug : (Extension) -> Repr raise Unhandled
}

///|
#internal(experimental, "This API is unstable and may change in the future.")
pub(all) enum OpCont[T] {
  None
  Ready(T)
  Async(async () -> T)
  AfterLayout(() -> T)
  LegacyEffect(EffectKind, (&Scheduler) -> Unit)
}

///|
#internal(experimental, "This API is unstable and may change in the future.")
pub(all) suberror Unhandled

///|
#internal(experimental, "This API is unstable and may change in the future.")
pub(all) suberror HydrateExn {
  Unhandled
  Fallback
  Skip
}

///|
#internal(experimental, "This API is unstable and may change in the future.")
pub(all) extenum Extension {}

///|
let default_handler : Op = {
  resume_: (_, _, _) => raise Unhandled,
  settle: (_, _) => raise Unhandled,
  identify: _ => raise Unhandled,
  debug: _ => raise Unhandled,
  invoke: (_, _) => raise Unhandled,
}

///|
#internal(experimental, "This API is unstable and may change in the future.")
pub fn Op::Op() -> Self {
  // copy the handler
  { ..default_handler, }
}

///|
#internal(experimental, "This API is unstable and may change in the future.")
pub impl Debug for Cmd with fn to_repr(cmd) {
  match cmd {
    Batch(cmds) => Repr::array(cmds.map(Debug::to_repr))
    Invoke(op, extension) =>
      (op.debug)(extension) catch {
        Unhandled => Repr::omitted()
      }
  }
}

///|
fn[A, B] wrap_hook(
  f : (A) -> B raise Unhandled,
  g : (A) -> B raise Unhandled,
) -> (A) -> B raise Unhandled {
  a => f(a) catch { Unhandled => g(a) }
}

///|
#internal(experimental, "This API is unstable and may change in the future.")
pub type Settle = (Json) -> Unit

///|
#internal(experimental, "This API is unstable and may change in the future.")
pub fn Op::on_resume(
  self : Self,
  f : (Extension, Json, &Context) -> Cmd raise HydrateExn,
) -> Unit {
  self.resume_ = f
}

///|
#internal(experimental, "This API is unstable and may change in the future.")
pub fn Op::on_settle(
  self : Self,
  f : (Extension, &Context) -> OpCont[(Json, Cmd)] raise Unhandled,
) -> Unit {
  self.settle = f
}

///|
/// Registers the identity used to store and resume this command's SSR
/// transcript value. Authors must return different keys for commands that may
/// need different transcript values during hydration.
#internal(experimental, "This API is unstable and may change in the future.")
pub fn Op::on_identify(
  self : Self,
  identify : (Extension) -> String raise Unhandled,
) -> Unit {
  self.identify = identify
}

///|
#internal(experimental, "This API is unstable and may change in the future.")
pub fn Op::on_debug(
  self : Self,
  f : (Extension) -> Repr raise Unhandled,
) -> Unit {
  self.debug = wrap_hook(f, self.debug)
}

///|
#internal(experimental, "This API is unstable and may change in the future.")
pub fn Op::on_invoke(
  self : Self,
  f : (Extension, &Context) -> OpCont[Cmd] raise Unhandled,
) -> Unit {
  let g = self.invoke
  self.invoke = (extension, context) => {
    f(extension, context) catch {
      Unhandled => g(extension, context)
    }
  }
}

///|
#internal(experimental, "This API is unstable and may change in the future.")
pub fn Op::request(self : Self, extension : Extension) -> Cmd {
  Invoke(self, extension)
}

///|
#internal(experimental, "This API is unstable and may change in the future.")
struct Runner(Op)

///|
#internal(experimental, "This API is unstable and may change in the future.")
pub fn Runner::invoke(
  runner : Self,
  extension : Extension,
  context : &Context,
) -> OpCont[Cmd] raise Unhandled {
  (runner.0.invoke)(extension, context)
}

///|
#internal(experimental, "This API is unstable and may change in the future.")
pub fn Runner::settle(
  runner : Runner,
  extension : Extension,
  context : &Context,
) -> OpCont[(Json, Cmd)] raise Unhandled {
  (runner.0.settle)(extension, context)
}

///|
#internal(experimental, "This API is unstable and may change in the future.")
pub fn Runner::resume_(
  runner : Runner,
  extension : Extension,
  value : Json,
  context : &Context,
) -> Cmd raise HydrateExn {
  (runner.0.resume_)(extension, value, context)
}

///|
#internal(experimental, "This API is unstable and may change in the future.")
pub fn Runner::identify(
  runner : Runner,
  extension : Extension,
) -> String raise Unhandled {
  (runner.0.identify)(extension)
}

///|
#doc(hidden)
#internal(experimental, "This API is unstable and may change in the future.")
pub fn invoke(
  _ : @key.Key,
  op : Op,
  extension : Extension,
  context : &Context,
) -> OpCont[Cmd] raise Unhandled {
  (op.invoke)(extension, context)
}
