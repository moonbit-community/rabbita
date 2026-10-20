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
  id : Int32
  mut value : T?
  mut compute : () -> T
  // Logical clock stamps. Double can represent every integer up to 2^53 - 1
  // exactly. At 60fps, even 100,000 reads per frame would take about 47 years
  // to exhaust that range, so wraparound is not a practical concern here.
  mut changed_at : Double
  mut recomputed_at : Double
  scope : ScopeId
  mut childs : () -> Array[&ErasedNode]
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
    childs: () => [],
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
  (self.childs)()
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
        let childs = (self.childs)()
        if childs is [] || childs.any(x => x.changed_at() > self.recomputed_at) {
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
  parents : Array[DirtyFlag]
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
    childs: () => [],
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
    childs: () => [a],
    dirty_flag: dirty_b,
  }
}

///|
/// node(a) --> node(node(b)) --> node(b)
///  input        selected         output
///
/// branch is the Node[B] currently stored in selected.
pub fn[A : Eq, B : Eq] Node::bind(a : Node[A], f : (A) -> Node[B]) -> Node[B] {
  let selected : Node[Node[B]] = a.map(f)
  let mut previous : DirtyFlag? = None
  let output_dirty_flag = { dirty: true, parents: [], id: get_uuid(), }
  fn compute() -> B {
    let branch : Node[B] = selected.value.unwrap()
    if previous is Some(prev) && prev.id != branch.dirty_flag.id {
      if prev.parents.search(output_dirty_flag) is Some(i) {
        ignore(prev.parents.remove(i))
      }
    }
    previous = Some(branch.dirty_flag)
    branch.value.unwrap()
  }

  {
    id: get_uuid(),
    scope: current_scope.val,
    value: None,
    compute,
    changed_at: 0,
    recomputed_at: 0,
    childs: () => {
      // Visit selected first. Refresh childs before visiting the selected branch.
      if selected.value is Some(branch) {
        [selected, branch]
      } else {
        [selected]
      }
    },
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
  retain_value : Ref[V]
  value : Node[V]
  result : Node[C]
  scope : ScopeId
  mut epoch : Int32
}

///|
/// 
///    a : Node[Vector[V]]
///           |                 +-> v1 : Node[V] -> c1 : Node[C] ---+
///           v                 |                                   |
/// indexed : Node[Map[K,V]] ---+-> v2 : Node[V] -> c2 : Node[C] ---+-> output: Node[Vector[C]]
///                             |               ...                 |
///                             +-> vN : Node[V] -> cN : Node[C] ---+
/// 
fn[K : Hash + Eq, I : Eq, V : Eq, C : Eq] Node::assoc_projected(
  a : Node[Vector[I]],
  f : (K, Node[V]) -> Node[C],
  key_of : (I) -> K,
  value_of : (I) -> V,
) -> Node[Vector[C]] {
  let indexed : Node[(Map[K, V], Array[K])] = a.map(inputs => {
    let dict = Map([])
    let order = []
    for input in inputs {
      let k = key_of(input)
      let v = value_of(input)
      dict[k] = v
      order.push(k)
    }
    (dict, order)
  })

  let mut epoch : Int32 = 0
  let cache : Map[K, AssocEntry[V, C]] = Map([])

  let output : Node[Vector[C]] = indexed.bind(pair => {
    epoch += 1
    let (dict, order) = pair
    let results : Array[Node[C]] = []
    for k in order {
      let entry : AssocEntry[V, C] = match cache.get(k) {
        Some(entry) => {
          entry.epoch = epoch
          entry
        }
        None => {
          let entry : AssocEntry[V, C] = with_scope(scope => {
            let retain_value : Ref[V] = Ref(dict[k])
            let value_node : Node[V] = indexed.map(index => {
              match index.0.get(k) {
                Some(v) => {
                  retain_value.val = v
                  v
                }
                None => retain_value.val
              }
            })
            let c : Node[C] = f(k, value_node)
            { result: c, scope, epoch, value: value_node, retain_value, }
          })
          cache[k] = entry
          entry
        }
      }
      results.push(entry.result)
    }

    let removed : Set[Int32] = Set([])
    cache.retain((_, entry) => {
      match entry.epoch == epoch {
        true => true
        false => {
          // NOTE:
          // If (k, v) is removed from `a` but `node(v) --> node(c)` is still
          // active, what happens when someone reads `node(c)`?
          //
          // Like SolidJS's per-item signals, retain the last known `v` so
          // `node(c)` can recompute with it even after (k, v) is removed.
          let value : V = entry.retain_value.val
          entry.value.compute = () => value
          entry.value.childs = () => []
          removed.add(entry.value.dirty_flag.id)
          if global_scopes.get(entry.scope.0) is Some(scope) {
            scope.dispose()
          }
          false
        }
      }
    })
    // Detach all removed nodes in one pass.
    indexed.dirty_flag.parents.retain(parent => !removed.contains(parent.id))

    let combined : Node[Vector[C]] = map_node(
      results.map(x => x as &ErasedNode),
      () => {
        @vector.from_iter(results.iter().map(result => result.value.unwrap()))
      },
    )
    combined
  })

  output
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
/// Recompute dirty nodes in post-order.
/// Re-read `childs()` after processing each child, since earlier children
/// may change later dependencies, as in `a.bind(f)`.
fn pull_value(node : &ErasedNode) -> Unit {
  let stack : Array[(&ErasedNode, Int32)] = [(node, 0)]
  while stack.pop() is Some((node, index)) {
    guard node.dirty_flag().dirty else { continue }
    // Earlier children may change which later children should be visited.
    let childs : Array[&ErasedNode] = node.childs()
    if index < childs.length() {
      stack.push((node, index + 1))
      let child = childs[index]
      if child.dirty_flag().dirty {
        stack.push((child, 0))
      }
    } else {
      for child in childs {
        if child.dirty_flag().parents.all(x => x.id != node.dirty_flag().id) {
          child.dirty_flag().parents.push(node.dirty_flag())
        }
      }
      node.recompute()
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
