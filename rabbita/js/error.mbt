///|
#cfg(target="js")
pub suberror Error_ {
  Error_(Value)
}

///|
#cfg(target="js")
extern "js" fn Error_::cause_ffi(self : Value) -> Value = "(self) => self.cause"

///|
#cfg(target="js")
pub fn Error_::cause(self : Error_) -> Value? {
  let Error_(inner) = self
  let cause = Error_::cause_ffi(inner)
  guard !cause.is_undefined() else { None }
  Some(cause.cast())
}

///|
#cfg(target="js")
pub impl Show for Error_ with fn output(self, logger) {
  logger.write_string("@js.Error: ")
  let Error_(inner) = self
  logger.write_object(inner)
  guard self.cause() is Some(cause_inner) else { return }
  logger.write_string("\n  caused by:\n")
  logger.write_object(cause_inner)
}

///|
#cfg(target="js")
pub extend Error_ with Show::{output, to_string}

///|
#cfg(target="js")
extern "js" fn Error_::wrap_ffi(
  op : () -> Value,
  on_ok : (Value) -> Unit,
  on_error : (Value) -> Unit,
) -> Unit =
  #| (op, on_ok, on_error) => { try { on_ok(op()); } catch (e) { on_error(e); } }

///|
#cfg(target="js")
pub fn[T] Error_::wrap(
  op : () -> Value,
  map_ok? : (Value) -> T = Value::cast,
) -> T raise Error_ {
  let mut res : Result[Value, Error_] = Ok(Value::undefined())
  Error_::wrap_ffi(op, fn(v) { res = Ok(v) }, fn(e) { res = Err(Error_(e)) })
  match res {
    Ok(v) => map_ok(v)
    Err(e) => raise e
  }
}
