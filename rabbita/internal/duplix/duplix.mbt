///|
using @vector {type Vector}

///|
let uuid : Ref[Int32] = Ref(0)

///|
let clock : Ref[Double] = Ref(0)

///|
fn get_uuid() -> Int32 {
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
  fn get_id(Self) -> Int32
  fn childs(Self) -> Array[&ErasedNode]
  fn pull_plan(Self) -> PullPlan
  fn prepare_childs(Self) -> Unit
  fn changed_at(Self) -> Double
  fn dirty_flag(Self) -> DirtyFlag
  fn recompute(Self) -> Unit
}

///|
priv enum PullPlan {
  Static
  // Pull control inputs, prepare the active edges, then pull those edges.
  Dynamic(Array[&ErasedNode], () -> Unit)
}

///|
priv enum PullStep {
  Visit(&ErasedNode)
  Prepare(&ErasedNode)
  Recompute(&ErasedNode)
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
  id : Int32
  mut value : T?
  mut compute : () -> T
  // Logical clock stamps. Double can represent every integer up to 2^53 - 1
  // exactly. At 60fps, even 100,000 reads per frame would take about 47 years
  // to exhaust that range, so wraparound is not a practical concern here.
  mut changed_at : Double
  mut recomputed_at : Double
  scope : ScopeId
  childs : Array[&ErasedNode]
  pull_plan : PullPlan
  dirty_flag : DirtyFlag
}

///|
pub fn[T] constant(x : T) -> Node[T] {
  let dirty_b = { dirty: false, parents: Set([]), id: get_uuid(), }
  {
    id: get_uuid(),
    scope: current_scope.val,
    value: Some(x),
    compute: () => x,
    changed_at: 0,
    recomputed_at: 0,
    childs: [],
    pull_plan: Static,
    dirty_flag: dirty_b,
  }
}

///|
pub impl[T] Eq for Node[T] with fn equal(a, b) {
  a.id == b.id
}

///|
pub extend Node with Eq::{equal, not_equal}

///|
pub impl[T] Compare for Node[T] with fn compare(a, b) {
  a.id.compare(b.id)
}

///|
pub extend Node with Compare::{compare, op_ge, op_gt, op_le, op_lt}

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
impl[T : Eq] ErasedNode for Node[T] with fn pull_plan(self) {
  self.pull_plan
}

///|
impl[T : Eq] ErasedNode for Node[T] with fn prepare_childs(self) {
  if self.pull_plan is Dynamic(_, prepare) {
    current_scope.protect(self.scope, prepare)
  }
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
  id : Int32
  mut dirty : Bool
  parents : Set[DirtyFlag]
}

///|
impl Hash for DirtyFlag with fn hash_combine(self, hasher) {
  Hash::hash_combine(self.id, hasher)
}

///|
pub impl Eq for DirtyFlag with fn equal(a, b) {
  a.id == b.id
}

///|
pub extend DirtyFlag with Eq::{equal, not_equal}

///|
pub impl Compare for DirtyFlag with fn compare(a, b) {
  a.id.compare(b.id)
}

///|
pub extend DirtyFlag with Compare::{compare, op_ge, op_gt, op_le, op_lt}

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
    pull_plan: Static,
    dirty_flag: { dirty: true, parents: Set([]), id: get_uuid(), },
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
  let dirty_b = { dirty: true, parents: Set([]), id: get_uuid(), }
  // a.dirty_flag.parents.add(dirty_b)
  {
    id: get_uuid(),
    scope: current_scope.val,
    value: None,
    compute: () => f(a.value.unwrap()),
    changed_at: 0,
    recomputed_at: 0,
    childs: [a],
    pull_plan: Static,
    dirty_flag: dirty_b,
  }
}

///|
///         a -----+
///                |----> output
///   b1 or b2 ----+
pub fn[A : Eq, B : Eq] Node::bind(a : Node[A], f : (A) -> Node[B]) -> Node[B] {
  let mut active : Node[B]? = None
  let mut selected_at = -1.0
  let mut selection_prepared = false
  let output_childs : Array[&ErasedNode] = []
  let output_dirty_flag = { dirty: true, parents: Set([]), id: get_uuid(), }
  fn select() {
    let b2 = f(a.value.unwrap())
    let branch_changed = active is None ||
      (active is Some(prev) && prev.id != b2.id)

    if branch_changed {
      // delete: b1 ---derived---> output
      // add:    b2 ---derived---> output
      if active is Some(b1) && b1.id != a.id {
        b1.dirty_flag.parents.remove(output_dirty_flag)
        if output_childs.search_by(x => x.get_id() == b1.id) is Some(i) {
          ignore(output_childs.remove(i))
        }
      }

      if b2.dirty_flag().id != a.dirty_flag().id {
        b2.dirty_flag().parents.add(output_dirty_flag)
        output_childs.push(b2)
      }
    }
    active = Some(b2)
    selected_at = a.changed_at
  }
  fn prepare() {
    selection_prepared = active is None || a.changed_at > selected_at
    if selection_prepared {
      select()
    }
  }
  fn compute() {
    // Preserve bind's callback behavior for updates from the active branch.
    if !selection_prepared {
      select()
    }
    active.unwrap().internal_read()
  }

  // a ---derived--->output
  // a.dirty_flag.parents.add(output_dirty_flag)
  output_childs.push(a)

  {
    id: get_uuid(),
    scope: current_scope.val,
    value: None,
    compute,
    changed_at: 0,
    recomputed_at: 0,
    childs: output_childs,
    pull_plan: Dynamic([a], prepare),
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
priv struct AssocValue[V] {
  mut value : V
  mut retained : Bool
}

///|
priv struct AssocEntry[V, C] {
  value : Node[V]
  result : Node[C]
  scope : ScopeId
  mut epoch : Int32
}

///|
fn[K : Hash + Eq, I : Eq, V, C : Eq] Node::assoc_projected(
  a : Node[Vector[I]],
  f : (K, Node[V]) -> Node[C],
  key_of : (I) -> K,
  value_of : (I) -> V,
) -> Node[Vector[C]] {
  // Index cells contain values only, so row -> index edges cannot retain rows.
  let values : Map[K, AssocValue[V]] = Map([])
  let indexed = a.map(items => {
    // Keep cells owned by existing branches until collection reconciliation.
    values.retain((_, cell) => cell.retained)
    for item in items {
      let key = key_of(item)
      let value = value_of(item)
      let cell = if values.get(key) is Some(cell) {
        cell
      } else {
        { value, retained: false, }
      }
      cell.value = value
      values[key] = cell
    }
    items
  })
  let mut epoch = 0
  let mut reconciled_at = -1.0
  let cache : Map[K, AssocEntry[V, C]] = Map([])
  let active_results : Array[Node[C]] = []
  let output_childs : Array[&ErasedNode] = [indexed]
  let output_dirty_flag = { dirty: true, parents: Set([]), id: get_uuid(), }
  fn prepare() {
    guard indexed.changed_at > reconciled_at else { return }
    reconciled_at = indexed.changed_at
    epoch += 1
    active_results.clear()
    for item in indexed.value.unwrap() {
      let key = key_of(item)
      let entry = if cache.get(key) is Some(entry) {
        entry.epoch = epoch
        entry
      } else {
        let entry = with_scope(scope => {
          let cell = values[key]
          cell.retained = true
          // A removed key releases its cell; reinsertion gets a fresh lifetime.
          let value_node = map_node([indexed], () => cell.value)
          let result = f(key, value_node)
          { value: value_node, result, scope, epoch, }
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
        // Freeze retained row handles and release their source dependency.
        entry.value.childs.clear()
        values.remove(key)
        indexed.dirty_flag.parents.remove(entry.value.dirty_flag)
        entry.result.dirty_flag.parents.remove(output_dirty_flag)
        if global_scopes.get(entry.scope.0) is Some(scope) {
          scope.dispose()
        }
      }
      cache.remove(key)
    }

    output_childs.clear()
    output_childs.push(indexed)
    for result in active_results {
      output_childs.push(result)
    }
  }
  fn compute() {
    @vector.from_iter(
      active_results.iter().map(result => result.value.unwrap()),
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
    pull_plan: Dynamic([indexed], prepare),
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
  let stack : Array[PullStep] = [Visit(node)]
  let seen = Set([])
  while stack.pop() is Some(step) {
    match step {
      Visit(node) => {
        guard node.dirty_flag().dirty else { continue }
        guard !seen.contains(node.get_id()) else { continue }
        seen.add(node.get_id())
        let childs = match node.pull_plan() {
          Static => {
            stack.push(Recompute(node))
            node.childs()
          }
          Dynamic(sources, _) => {
            stack.push(Prepare(node))
            sources
          }
        }
        for child in childs {
          if child.dirty_flag().dirty {
            stack.push(Visit(child))
          }
        }
      }
      Prepare(node) => {
        node.prepare_childs()
        stack.push(Recompute(node))
        for child in node.childs() {
          if child.dirty_flag().dirty {
            stack.push(Visit(child))
          }
        }
      }
      Recompute(node) => {
        for child in node.childs() {
          child.dirty_flag().parents.add(node.dirty_flag())
        }
        node.recompute()
      }
    }
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
