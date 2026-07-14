///|
type OnExecute = (&Scheduler) -> Unit

///|
enum Effect {
  Batch(Array[Effect])
  Message(@slotmap.Id, @any.Any)
  Effect(Handler, Payload)
}

///|
let ambient_handler : @slotmap.SlotMap[Array[HandlerFn]] = SlotMap()

///|
pub extenum Payload {}

///|
pub suberror Unhandled

///|
pub type HandlerFn = async (Payload, &Scheduler) -> Unit raise Unhandled

///|
struct Handler(@slotmap.Id)

///|
pub fn register() -> Handler {
  ambient_handler.allocate()
}

///|
pub fn Handler::add(id : Handler, f : HandlerFn) -> Unit {
  ambient_handler[id.0].push(f)
}

///|
pub fn Handler::remove(id : Handler, f : HandlerFn) -> Unit {
  ...
}
