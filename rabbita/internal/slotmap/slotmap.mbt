///|
struct SlotMap[T] {
  slots : Array[T?]
  gens : Array[UInt]
  free : Array[Int]
}

///|
pub fn[T] SlotMap::SlotMap() -> Self[T] {
  { slots: [], gens: [], free: [], }
}

///|
pub fn[T] SlotMap::allocate(arena : Self[T]) -> Id {
  if arena.free.pop() is Some(idx) {
    let gen = arena.gens[idx]
    arena.slots[idx] = None
    { gen, idx, }
  } else {
    let gen = 0U
    let idx = arena.slots.length()
    arena.gens.push(gen)
    arena.slots.push(None)
    { gen, idx, }
  }
}

///|
pub fn[T] SlotMap::allocate_with(arena : Self[T], f : (Id) -> T) -> Id {
  let id = arena.allocate()
  arena[id] = f(id)
  id
}

///|
struct Id {
  gen : UInt
  idx : Int
} derive(Eq, Hash, Compare)

///|
pub fn[T] SlotMap::free(arena : Self[T], id : Id) -> Unit {
  let { gen, idx, } = id
  guard idx != -1 else { abort("valid slot index") }
  guard arena.gens[idx] == gen else { abort("current generation") }
  guard arena.slots[idx] is Some(_) else { abort("occupied slot") }
  arena.slots[idx] = None
  arena.gens[idx] += 1
  arena.free.push(idx)
}

///|
pub fn[T] SlotMap::get(arena : Self[T], id : Id) -> T? {
  let { gen, idx, } = id
  guard idx != -1 else { None }
  guard arena.gens[idx] == gen else { None }
  arena.slots[idx]
}

///|
#alias("_[_]")
pub fn[T] SlotMap::read(arena : Self[T], id : Id) -> T {
  let { gen, idx, } = id
  guard idx != -1 else { abort("valid slot index") }
  guard arena.gens[idx] == gen else { abort("current generation") }
  guard arena.slots[idx] is Some(value) else { abort("occupied slot") }
  value
}

///|
#alias("_[_]=_")
pub fn[T] SlotMap::write(arena : Self[T], id : Id, value : T) -> Unit {
  let { gen, idx, } = id
  guard idx != -1 else { abort("valid slot index") }
  guard arena.gens[idx] == gen else { abort("current generation") }
  arena.slots[idx] = Some(value)
}
