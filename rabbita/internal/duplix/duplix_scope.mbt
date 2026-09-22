///|
let global_scopes : @slotmap.SlotMap[Scope] = SlotMap()

///|
let dummy_scope : ScopeId = global_scopes.allocate_with(id => {
  id,
  parent: None,
  sub_scopes: Set([]),
  cleanups: [],
})

///|
let current_scope : Ref[ScopeId] = Ref(dummy_scope)

///|
fn get_scope() -> Scope {
  global_scopes[current_scope.val.0]
}

///|
priv struct Scope {
  id : ScopeId
  parent : ScopeId?
  sub_scopes : Set[ScopeId]
  cleanups : Array[() -> Unit]
}

///|
struct ScopeId(@slotmap.Id) derive(Hash, Eq)

///|
pub extend ScopeId with Hash::{hash, hash_combine}

///|
pub extend ScopeId with Eq::{equal, not_equal}

///|
pub fn[A] with_scope(f : (ScopeId) -> A) -> A {
  let id = global_scopes.allocate_with(id => {
    id,
    parent: Some(current_scope.val),
    sub_scopes: Set([]),
    cleanups: [],
  })
  let result = current_scope.protect(id, () => f(id))
  if global_scopes.get(current_scope.val.0) is Some(scope) {
    scope.sub_scopes.add(id)
  }
  result
}

///|
pub fn on_cleanup(f : () -> Unit) -> Unit {
  get_scope().cleanups.push(f)
}

///|
pub fn ScopeId::cleanup(id : ScopeId) -> Unit {
  global_scopes[id.0].dispose()
}

///|
fn Scope::dispose(self : Self) -> Unit {
  for id in self.sub_scopes {
    if global_scopes.get(id.0) is Some(scope) {
      scope.dispose()
    }
  }

  for cleanup in self.cleanups {
    cleanup()
  }

  if self.parent is Some(p) {
    global_scopes[p.0].sub_scopes.remove(self.id)
  }

  global_scopes.free(self.id.0)
}
