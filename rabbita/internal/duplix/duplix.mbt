///|
using @vector {type Vector}

///|
let uuid : Ref[Int] = Ref(0)

///|
let clock : Ref[Double] = Ref(0)

///|
fn get_uuid() -> Int {
  uuid.val += 1
  uuid.val
}

///|
/// child1 ---+
///           |----derived----> parent
/// child2 ---+
///
/// parent_expr = child1_expr + child2_expr
priv trait ErasedNode {
  fn get_id(Self) -> Int
  fn childs(Self) -> Array[&ErasedNode]
  fn changed_at(Self) -> Double
  fn dirty_flag(Self) -> DirtyFlag
  fn recompute(Self) -> Unit
}

///|
///       child ---derived---> parent
/// 
///          Node(parent) ---ref---> Node(child)
///              |                        |
///             ref                      ref
///              |                        |
///              v                        v
///     DirtyFlag(parent) <---ref--- DirtyFlag(child)
struct Node[T] {
  id : Int
  mut value : T?
  mut compute : () -> T
  // Logical clock stamps. Double can represent every integer up to 2^53 - 1
  // exactly. At 60fps, even 100,000 reads per frame would take about 47 years
  // to exhaust that range, so wraparound is not a practical concern here.
  mut changed_at : Double
  mut recomputed_at : Double
  scope : ScopeId
  childs : Array[&ErasedNode]
  dirty_flag : DirtyFlag
}

///|
pub fn[T] constant(x : T) -> Node[T] {
  let dirty_b = { dirty: false, parents: [], id: get_uuid(), }
  {
    id: get_uuid(),
    scope: current_scope.val,
    value: Some(x),
    compute: () => x,
    changed_at: 0,
    recomputed_at: 0,
    childs: [],
    dirty_flag: dirty_b,
  }
}

///|
pub impl[T] Eq for Node[T] with fn equal(a, b) {
  a.id == b.id
}

///|
pub impl[T] Compare for Node[T] with fn compare(a, b) {
  a.id.compare(b.id)
}

///|
impl[T : Eq] ErasedNode for Node[T] with fn get_id(self) {
  self.id
}

///|
impl[T : Eq] ErasedNode for Node[T] with fn changed_at(self) {
  self.changed_at
}

///|
impl[T : Eq] ErasedNode for Node[T] with fn childs(self) {
  self.childs
}

///|
impl[T : Eq] ErasedNode for Node[T] with fn dirty_flag(self) {
  self.dirty_flag
}

///|
extend Node with ErasedNode::{dirty_flag}

///|
impl[T : Eq] ErasedNode for Node[T] with fn recompute(self) {
  current_scope.protect(self.scope, () => {
    match self.value {
      None => {
        let new = (self.compute)()
        self.value = Some(new)
        self.recomputed_at = clock.val
        self.changed_at = self.recomputed_at
        self.dirty_flag().dirty = false
      }
      Some(old) if self.dirty_flag().dirty => {
        if self.childs is [] ||
          self.childs.any(x => x.changed_at() > self.recomputed_at) {
          let new = (self.compute)()
          self.recomputed_at = clock.val
          if !Eq::equal(old, new) {
            self.changed_at = self.recomputed_at
          }
          self.value = Some(new)
        }
        self.dirty_flag().dirty = false
      }
      Some(_) => ()
    }
  })
}

///|
/// DirtyFlag(parent) <--ref--- DirtyFlag(child)
struct DirtyFlag {
  id : Int
  mut dirty : Bool
  parents : Array[DirtyFlag]
}

///|
pub impl Eq for DirtyFlag with fn equal(a, b) {
  a.id == b.id
}

///|
pub impl Compare for DirtyFlag with fn compare(a, b) {
  a.id.compare(b.id)
}

///|
pub fn[T : Eq] input(x : T) -> (Node[T], (T) -> Unit) {
  let node = {
    id: get_uuid(),
    scope: current_scope.val,
    value: None,
    compute: () => x,
    changed_at: 0,
    recomputed_at: 0,
    childs: [],
    dirty_flag: { dirty: true, parents: [], id: get_uuid(), },
  }

  fn write(x : T) {
    node.compute = () => x
    push_dirty(node)
  }

  (node, write)
}

///|
/// child_a ---derived---> parent_b
pub fn[A : Eq, B] Node::map(a : Node[A], f : (A) -> B) -> Node[B] {
  let dirty_b = { dirty: true, parents: [], id: get_uuid(), }
  // a.dirty_flag.parents.push(dirty_b)
  {
    id: get_uuid(),
    scope: current_scope.val,
    value: None,
    compute: () => f(a.value.unwrap()),
    changed_at: 0,
    recomputed_at: 0,
    childs: [a],
    dirty_flag: dirty_b,
  }
}

///|
///         a -----+
///                |----> output
///   b1 or b2 ----+
pub fn[A : Eq, B : Eq] Node::bind(a : Node[A], f : (A) -> Node[B]) -> Node[B] {
  let mut b1_dirty_sub : DirtyFlag? = None
  let output_childs : Array[&ErasedNode] = []
  let output_dirty_flag = { dirty: true, parents: [], id: get_uuid(), }
  fn compute() {
    let b2 = f(a.value.unwrap())
    let branch_changed = b1_dirty_sub is None ||
      (b1_dirty_sub is Some(prev) && prev.id != b2.dirty_flag().id)

    if branch_changed {
      // delete: b1 ---derived---> output
      // add:    b2 ---derived---> output
      if b1_dirty_sub is Some(b1) && b1.id != a.dirty_flag().id {
        if b1.parents.search(output_dirty_flag) is Some(i) {
          ignore(b1.parents.remove(i))
        }
        if output_childs.search_by(x => x.dirty_flag().id == b1.id) is Some(i) {
          ignore(output_childs.remove(i))
        }
      }

      if b2.dirty_flag().id != a.dirty_flag().id {
        b2.dirty_flag().parents.push(output_dirty_flag)
        output_childs.push(b2)
      }
      b1_dirty_sub = Some(b2.dirty_flag())
    }

    b2.internal_read()
  }

  // a ---derived--->output
  // a.dirty_flag.parents.push(output_dirty_flag)
  output_childs.push(a)

  {
    id: get_uuid(),
    scope: current_scope.val,
    value: None,
    compute,
    changed_at: 0,
    recomputed_at: 0,
    childs: output_childs,
    dirty_flag: output_dirty_flag,
  }
}

///|
pub fn[E : @common.Enumerate + Eq, A : Eq] Node::switch(
  a : Node[E],
  f : (E) -> Node[A],
) -> Node[A] {
  a.switch_by(f, by=value => @common.Enumerate::tag(value))
}

///|
pub fn[E : Eq, A : Eq] Node::switch_by(
  a : Node[E],
  f : (E) -> Node[A],
  by~ : (E) -> String,
) -> Node[A] {
  let mut active : (String, Node[A], ScopeId)? = None
  a.bind(value => {
    let tag = by(value)
    fn update_active(value) {
      with_scope(scope => {
        let node = current_scope.protect(scope, () => f(value))
        active = Some((tag, node, scope))
        node
      })
    }
    match active {
      None => update_active(value)
      Some((old_tag, node, scope)) =>
        if tag == old_tag {
          node
        } else {
          if global_scopes.get(scope.0) is Some(scope) {
            scope.dispose()
          }
          update_active(value)
        }
    }
  })
}

///|
pub fn[E : @common.Enumerate + Eq, A : Eq] Node::enumerate(
  map : Node[E],
  f : (E) -> Node[A],
) -> Node[A] {
  map.enumerate_by(f, by=value => @common.Enumerate::tag(value))
}

///|
pub fn[E : Eq, A : Eq] Node::enumerate_by(
  map : Node[E],
  f : (E) -> Node[A],
  by~ : (E) -> String,
) -> Node[A] {
  let cache : Map[String, Node[A]] = Map([])
  map.bind(value => {
    let tag = by(value)
    if cache.get(tag) is Some(node) {
      node
    } else {
      let node = f(value)
      cache.set(tag, node)
      node
    }
  })
}

///|
priv struct AssocEntry[V, C] {
  mut value : V
  set_value : (V) -> Unit
  result : Node[C]
  scope : ScopeId
  mut epoch : Int
}

///|
///             node(entries) ---+
///                              |
/// node(v1) --?-> node(c1) -----+
///                              |---> node(vector(c))
/// node(v2) --?-> node(c2) -----+
///   ...                        |
/// node(vN) --?-> node(cN) -----+
fn[K : Hash + Eq, I : Eq, V : Eq, C : Eq] Node::assoc_projected(
  a : Node[Vector[I]],
  f : (K, Node[V]) -> Node[C],
  key_of : (I) -> K,
  value_of : (I) -> V,
) -> Node[Vector[C]] {
  let mut epoch = 0
  let cache : Map[K, AssocEntry[V, C]] = Map([])
  let output_childs : Array[&ErasedNode] = [a]
  let output_dirty_flag = { dirty: true, parents: [], id: get_uuid(), }
  fn compute() {
    epoch += 1
    let active_results : Array[Node[C]] = []
    let entries = a.value.unwrap()
    for item in entries {
      let key = key_of(item)
      let value = value_of(item)
      let entry = if cache.get(key) is Some(entry) {
        if entry.value != value {
          entry.value = value
          (entry.set_value)(value)
        }
        entry.epoch = epoch
        entry
      } else {
        let entry = with_scope(scope => {
          let (value_node, set_value) = input(value)
          let result = f(key, value_node)
          { value, set_value, result, scope, epoch, }
        })
        cache.set(key, entry)
        entry
      }
      active_results.push(entry.result)
    }

    let stale_keys : Array[K] = []
    for key, entry in cache {
      if entry.epoch != epoch {
        stale_keys.push(key)
      }
    }
    for key in stale_keys {
      if cache.get(key) is Some(entry) {
        if entry.result.dirty_flag.parents.search(output_dirty_flag) is Some(i) {
          ignore(entry.result.dirty_flag.parents.remove(i))
        }
        if global_scopes.get(entry.scope.0) is Some(scope) {
          scope.dispose()
        }
      }
      cache.remove(key)
    }

    output_childs.clear()
    output_childs.push(a)
    @vector.from_iter(
      active_results
      .iter()
      .map(result => {
        output_childs.push(result)
        if result.dirty_flag.parents.all(x => x.id != output_dirty_flag.id) {
          result.dirty_flag.parents.push(output_dirty_flag)
        }
        result.internal_read()
      }),
    )
  }

  {
    id: get_uuid(),
    scope: current_scope.val,
    value: None,
    compute,
    recomputed_at: 0,
    changed_at: 0,
    childs: output_childs,
    dirty_flag: output_dirty_flag,
  }
}

///|
pub fn[K : Hash + Eq, V : Eq, C : Eq] Node::assoc(
  a : Node[Vector[(K, V)]],
  f : (K, Node[V]) -> Node[C],
) -> Node[Vector[C]] {
  a.assoc_projected(f, pair => pair.0, pair => pair.1)
}

///|
pub fn[K : Hash + Eq, V : Eq, C : Eq] Node::assoc_by(
  a : Node[Vector[V]],
  f : (K, Node[V]) -> Node[C],
  by~ : (V) -> K,
) -> Node[Vector[C]] {
  a.assoc_projected(f, by, value => value)
}

///|
fn[A : Eq] Node::internal_read(a : Node[A]) -> A {
  pull_value(a)
  a.value.unwrap()
}

///|
pub fn[A : Eq] Node::read(a : Node[A]) -> A {
  clock.val += 1
  a.internal_read()
}

///|
fn pull_value(node : &ErasedNode) -> Unit {
  let stack = [(node, false)]
  let seen = Set([])
  let recomputes = []

  while stack.pop() is Some((x, expanded)) {
    guard x.dirty_flag().dirty else { continue }
    let id = x.get_id()
    if expanded {
      recomputes.push(x)
    } else if !seen.contains(id) {
      seen.add(id)
      stack.push((x, true))

      for child in x.childs() {
        if child.dirty_flag().dirty {
          stack.push((child, false))
        }
      }
    }
  }

  for node in recomputes {
    for child in node.childs() {
      if child.dirty_flag().parents.all(x => x.id != node.dirty_flag().id) {
        child.dirty_flag().parents.push(node.dirty_flag())
      }
    }
    node.recompute()
  }
}

///|
fn push_dirty(node : &ErasedNode) -> Unit {
  let traverses = @queue.Queue([(node.dirty_flag(), false)])
  while traverses.pop() is Some((x, expanded)) {
    if expanded {
      x.parents.clear()
    } else {
      guard !x.dirty else { continue }
      x.dirty = true
      for p in x.parents {
        traverses.push((p, false))
      }
      traverses.push((x, true))
    }
  }
}
