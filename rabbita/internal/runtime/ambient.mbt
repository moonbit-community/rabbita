///|
pub using @vdom {type Children, type Props, type VNode, type VDom}

///|
using @cmd {trait Context, trait Scheduler}

///|
using @queue {type Queue}

///|
const RABBITA_TRANSCRIPT_ID = "__rabbita_transcript"

///|
type GraphBuilder = () -> @duplix.Node[@vdom.VNode]

///|
pub trait Host: Scheduler {
  fn flush(Self) -> Unit
  fn cleanup(Self) -> Unit
  fn get_stores(Self) -> @slotmap.SlotMap[Store]
}

///|
/// The dynamically scoped host of the App currently being evaluated.
/// This is intentionally a dynamic variable so stateful and stateless
/// components can share the same API, instead of requiring stateful components
/// to accept an explicit graph as in Bonsai. MoonBit also lacks an equivalent of
/// OxCaml's `local`, so passing the graph explicitly would introduce that API
/// distinction without letting the type system constrain the graph's lifetime.
///
/// The cost of this choice is internal to Rabbita rather than exposed to users.
/// As frameworks with fine-grained reactivity and implicit tracking, the runtime
/// must carefully establish and restore this context around every graph
/// evaluation. Async boundaries also make this internal bookkeeping substantially
/// more fragile.
///
/// TODO: Report an error when the ambient host is `DummyHost`.
pub let ambient_host : Ref[&Host] = Ref(DummyHost::{ stores: SlotMap(), })
