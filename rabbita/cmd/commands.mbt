///|
pub(all) enum EffectKind {
  Immediately
  AfterRender
}

///|
/// A deferred command handled by the Rabbita runtime.
///
/// `Cmd` models side effects in the update loop. Commands are returned from
/// `update` or embedded in `Html` event handlers, and are executed later by
/// the runtime.
enum Cmd {
  Batch(Array[Cmd])
  Invoke(Op, Extension)
}

///|
#doc(hidden)
#internal(experimental, "This API is unstable and may change in the future.")
pub fn flatten(key : @key.Key, cmd : Cmd) -> Array[(Op, Extension)] {
  match cmd {
    Batch(cmds) => cmds.map(x => flatten(key, x)).flatten()
    Invoke(op, extension) => [(op, extension)]
  }
}

///|
type OnExecute = (&Scheduler) -> Unit

///|
pub let immediately : EffectKind = Immediately

///|
pub let after_render : EffectKind = AfterRender

///|
/// A command that does nothing.
pub let none : Cmd = Batch([])

///|
/// Combine multiple commands into one command.
#inline
pub fn batch(cmds : Array[Cmd]) -> Cmd {
  Batch(cmds)
}

///|
/// Create a **low-level** effect command for runtime and FFI integration.
/// **Consider use higher-level helpers like `perform`, `delay`, `@http.post()`, and 
/// `@dialog.show()` in app code.**
/// 
/// This function allows you to write wrappers that encapsulate FFI in a
/// command when the functionality is not provided by Rabbita yet. 
/// 
/// Parameters:
/// 
/// - `callback`: receives the runtime `Scheduler`, so it can enqueue follow-up
///   commands (for example, after an async callback).
/// 
/// - `kind`: determines when the effect runs.
///   - `Immediately`: run as soon as the runtime receives it.
///   - `AfterRender`: run after DOM patching for the current flush completes.
/// 
/// Example: 
/// 
/// ```moonbit nocheck
/// extern "js" fn set_timeout(f : () -> Unit, ms : Int) = "(f,ms) => setTimeout(f, ms)"
///
/// pub fn delay(cmd : Cmd, ms : Int) -> Cmd {
///   raw_effect(scheduler => set_timeout(() => scheduler.add(cmd), ms))
/// }
/// ```
#inline
#alias(raw_effect, deprecated)
pub fn custom_cmd(
  callback : (&Scheduler) -> Unit,
  kind? : EffectKind = Immediately,
) -> Cmd {
  op.request(LegacyEffect(kind, callback))
}

///|
/// Create a command that runs an effectful async function
#cfg(target="js")
pub fn effect(f : async () -> Unit noraise) -> Cmd {
  custom_cmd(_ => @js.Promise::from_async(() => f()) |> ignore)
}

///|
/// Create a command that runs an async function.
/// 
/// The async function `f` is executed, then its result is converted into a new
/// command by `msg` and scheduled back into the update loop.
#cfg(target="js")
pub fn[A] perform(msg : (A) -> Cmd, f : async () -> A noraise) -> Cmd {
  custom_cmd(scheduler => {
    @js.Promise::from_async(() => scheduler.add(msg(f()))) |> ignore
  })
}

///|
/// Create a command that runs an async function and handles errors.
/// 
/// Similar to `perform`, but captures errors and passes `Result[A, E]` to `msg`.
#cfg(target="js")
pub fn[A, E : Error] attempt(
  msg : (Result[A, E]) -> Cmd,
  f : async () -> A raise E,
) -> Cmd {
  custom_cmd(scheduler => {
    @js.Promise::from_async(() => {
      let msg = try f() catch {
        e => msg(Err(e))
      } noraise {
        r => msg(Ok(r))
      }
      scheduler.add(msg)
    })
    |> ignore
  })
}
