///|
pub type Any

///|
priv struct Wrapper[T] {
  value : T
}

///|
pub fn[T] erase(x : T) -> Any {
  unsafe_erase({ value: x, })
}

///|
pub fn[T] Any::into(x : Any) -> T {
  unsafe_downcast(x).value
}

///|
fn[T] unsafe_downcast(x : Any) -> Wrapper[T] = "%identity"

///|
fn[T] unsafe_erase(x : Wrapper[T]) -> Any = "%identity"
