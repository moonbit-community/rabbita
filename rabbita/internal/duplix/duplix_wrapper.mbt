///|
fn[T] map_node(childs : Array[&ErasedNode], compute : () -> T) -> Node[T] {
  let dirty = { dirty: true, parents: [], id: get_uuid() }
  // for child in childs {
  //   child.dirty_flag().parents.push(dirty)
  // }
  {
    id: get_uuid(),
    scope: current_scope.val,
    value: None,
    compute,
    childs,
    dirty_flag: dirty,
    changed_at: 0,
    recomputed_at: 0,
  }
}

///|
pub fn[A : Eq, B] Node::map1(a : Node[A], f : (A) -> B) -> Node[B] {
  map_node([a], () => f(a.value.unwrap()))
}

///|
pub fn[A : Eq, B : Eq, C] Node::map2(
  a : Node[A],
  b : Node[B],
  f : (A, B) -> C,
) -> Node[C] {
  map_node([a, b], () => f(a.value.unwrap(), b.value.unwrap()))
}

///|
pub fn[A : Eq, B : Eq, C : Eq, D] Node::map3(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  f : (A, B, C) -> D,
) -> Node[D] {
  map_node([a, b, c], () => {
    f(a.value.unwrap(), b.value.unwrap(), c.value.unwrap())
  })
}

///|
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E] Node::map4(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  f : (A, B, C, D) -> E,
) -> Node[E] {
  map_node([a, b, c, d], () => {
    f(a.value.unwrap(), b.value.unwrap(), c.value.unwrap(), d.value.unwrap())
  })
}

///|
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E : Eq, F] Node::map5(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : (A, B, C, D, E) -> F,
) -> Node[F] {
  map_node([a, b, c, d, e], () => {
    f(
      a.value.unwrap(),
      b.value.unwrap(),
      c.value.unwrap(),
      d.value.unwrap(),
      e.value.unwrap(),
    )
  })
}

///|
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E : Eq, F : Eq, G] Node::map6(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : (A, B, C, D, E, F) -> G,
) -> Node[G] {
  map_node([a, b, c, d, e, f], () => {
    g(
      a.value.unwrap(),
      b.value.unwrap(),
      c.value.unwrap(),
      d.value.unwrap(),
      e.value.unwrap(),
      f.value.unwrap(),
    )
  })
}

///|
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E : Eq, F : Eq, G : Eq, H] Node::map7(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
  h : (A, B, C, D, E, F, G) -> H,
) -> Node[H] {
  map_node([a, b, c, d, e, f, g], () => {
    h(
      a.value.unwrap(),
      b.value.unwrap(),
      c.value.unwrap(),
      d.value.unwrap(),
      e.value.unwrap(),
      f.value.unwrap(),
      g.value.unwrap(),
    )
  })
}

///|
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E : Eq, F : Eq, G : Eq, H : Eq, I] Node::map8(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
  h : Node[H],
  i : (A, B, C, D, E, F, G, H) -> I,
) -> Node[I] {
  map_node([a, b, c, d, e, f, g, h], () => {
    i(
      a.value.unwrap(),
      b.value.unwrap(),
      c.value.unwrap(),
      d.value.unwrap(),
      e.value.unwrap(),
      f.value.unwrap(),
      g.value.unwrap(),
      h.value.unwrap(),
    )
  })
}

///|
pub fn[
  A : Eq,
  B : Eq,
  C : Eq,
  D : Eq,
  E : Eq,
  F : Eq,
  G : Eq,
  H : Eq,
  I : Eq,
  J,
] Node::map9(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
  h : Node[H],
  i : Node[I],
  j : (A, B, C, D, E, F, G, H, I) -> J,
) -> Node[J] {
  map_node([a, b, c, d, e, f, g, h, i], () => {
    j(
      a.value.unwrap(),
      b.value.unwrap(),
      c.value.unwrap(),
      d.value.unwrap(),
      e.value.unwrap(),
      f.value.unwrap(),
      g.value.unwrap(),
      h.value.unwrap(),
      i.value.unwrap(),
    )
  })
}

///|
pub fn[
  A : Eq,
  B : Eq,
  C : Eq,
  D : Eq,
  E : Eq,
  F : Eq,
  G : Eq,
  H : Eq,
  I : Eq,
  J : Eq,
  K,
] Node::map10(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
  h : Node[H],
  i : Node[I],
  j : Node[J],
  k : (A, B, C, D, E, F, G, H, I, J) -> K,
) -> Node[K] {
  map_node([a, b, c, d, e, f, g, h, i, j], () => {
    k(
      a.value.unwrap(),
      b.value.unwrap(),
      c.value.unwrap(),
      d.value.unwrap(),
      e.value.unwrap(),
      f.value.unwrap(),
      g.value.unwrap(),
      h.value.unwrap(),
      i.value.unwrap(),
      j.value.unwrap(),
    )
  })
}

///|
pub fn[
  A : Eq,
  B : Eq,
  C : Eq,
  D : Eq,
  E : Eq,
  F : Eq,
  G : Eq,
  H : Eq,
  I : Eq,
  J : Eq,
  K : Eq,
  L,
] Node::map11(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
  h : Node[H],
  i : Node[I],
  j : Node[J],
  k : Node[K],
  l : (A, B, C, D, E, F, G, H, I, J, K) -> L,
) -> Node[L] {
  map_node([a, b, c, d, e, f, g, h, i, j, k], () => {
    l(
      a.value.unwrap(),
      b.value.unwrap(),
      c.value.unwrap(),
      d.value.unwrap(),
      e.value.unwrap(),
      f.value.unwrap(),
      g.value.unwrap(),
      h.value.unwrap(),
      i.value.unwrap(),
      j.value.unwrap(),
      k.value.unwrap(),
    )
  })
}

///|
pub fn[
  A : Eq,
  B : Eq,
  C : Eq,
  D : Eq,
  E : Eq,
  F : Eq,
  G : Eq,
  H : Eq,
  I : Eq,
  J : Eq,
  K : Eq,
  L : Eq,
  M,
] Node::map12(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
  h : Node[H],
  i : Node[I],
  j : Node[J],
  k : Node[K],
  l : Node[L],
  m : (A, B, C, D, E, F, G, H, I, J, K, L) -> M,
) -> Node[M] {
  map_node([a, b, c, d, e, f, g, h, i, j, k, l], () => {
    m(
      a.value.unwrap(),
      b.value.unwrap(),
      c.value.unwrap(),
      d.value.unwrap(),
      e.value.unwrap(),
      f.value.unwrap(),
      g.value.unwrap(),
      h.value.unwrap(),
      i.value.unwrap(),
      j.value.unwrap(),
      k.value.unwrap(),
      l.value.unwrap(),
    )
  })
}

///|
pub fn[
  A : Eq,
  B : Eq,
  C : Eq,
  D : Eq,
  E : Eq,
  F : Eq,
  G : Eq,
  H : Eq,
  I : Eq,
  J : Eq,
  K : Eq,
  L : Eq,
  M : Eq,
  N,
] Node::map13(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
  h : Node[H],
  i : Node[I],
  j : Node[J],
  k : Node[K],
  l : Node[L],
  m : Node[M],
  n : (A, B, C, D, E, F, G, H, I, J, K, L, M) -> N,
) -> Node[N] {
  map_node([a, b, c, d, e, f, g, h, i, j, k, l, m], () => {
    n(
      a.value.unwrap(),
      b.value.unwrap(),
      c.value.unwrap(),
      d.value.unwrap(),
      e.value.unwrap(),
      f.value.unwrap(),
      g.value.unwrap(),
      h.value.unwrap(),
      i.value.unwrap(),
      j.value.unwrap(),
      k.value.unwrap(),
      l.value.unwrap(),
      m.value.unwrap(),
    )
  })
}

///|
pub fn[
  A : Eq,
  B : Eq,
  C : Eq,
  D : Eq,
  E : Eq,
  F : Eq,
  G : Eq,
  H : Eq,
  I : Eq,
  J : Eq,
  K : Eq,
  L : Eq,
  M : Eq,
  N : Eq,
  O,
] Node::map14(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
  h : Node[H],
  i : Node[I],
  j : Node[J],
  k : Node[K],
  l : Node[L],
  m : Node[M],
  n : Node[N],
  o : (A, B, C, D, E, F, G, H, I, J, K, L, M, N) -> O,
) -> Node[O] {
  map_node([a, b, c, d, e, f, g, h, i, j, k, l, m, n], () => {
    o(
      a.value.unwrap(),
      b.value.unwrap(),
      c.value.unwrap(),
      d.value.unwrap(),
      e.value.unwrap(),
      f.value.unwrap(),
      g.value.unwrap(),
      h.value.unwrap(),
      i.value.unwrap(),
      j.value.unwrap(),
      k.value.unwrap(),
      l.value.unwrap(),
      m.value.unwrap(),
      n.value.unwrap(),
    )
  })
}

///|
pub fn[
  A : Eq,
  B : Eq,
  C : Eq,
  D : Eq,
  E : Eq,
  F : Eq,
  G : Eq,
  H : Eq,
  I : Eq,
  J : Eq,
  K : Eq,
  L : Eq,
  M : Eq,
  N : Eq,
  O : Eq,
  P,
] Node::map15(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
  h : Node[H],
  i : Node[I],
  j : Node[J],
  k : Node[K],
  l : Node[L],
  m : Node[M],
  n : Node[N],
  o : Node[O],
  p : (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) -> P,
) -> Node[P] {
  map_node([a, b, c, d, e, f, g, h, i, j, k, l, m, n, o], () => {
    p(
      a.value.unwrap(),
      b.value.unwrap(),
      c.value.unwrap(),
      d.value.unwrap(),
      e.value.unwrap(),
      f.value.unwrap(),
      g.value.unwrap(),
      h.value.unwrap(),
      i.value.unwrap(),
      j.value.unwrap(),
      k.value.unwrap(),
      l.value.unwrap(),
      m.value.unwrap(),
      n.value.unwrap(),
      o.value.unwrap(),
    )
  })
}

///|
pub fn[
  A : Eq,
  B : Eq,
  C : Eq,
  D : Eq,
  E : Eq,
  F : Eq,
  G : Eq,
  H : Eq,
  I : Eq,
  J : Eq,
  K : Eq,
  L : Eq,
  M : Eq,
  N : Eq,
  O : Eq,
  P : Eq,
  Q,
] Node::map16(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
  h : Node[H],
  i : Node[I],
  j : Node[J],
  k : Node[K],
  l : Node[L],
  m : Node[M],
  n : Node[N],
  o : Node[O],
  p : Node[P],
  q : (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P) -> Q,
) -> Node[Q] {
  map_node([a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p], () => {
    q(
      a.value.unwrap(),
      b.value.unwrap(),
      c.value.unwrap(),
      d.value.unwrap(),
      e.value.unwrap(),
      f.value.unwrap(),
      g.value.unwrap(),
      h.value.unwrap(),
      i.value.unwrap(),
      j.value.unwrap(),
      k.value.unwrap(),
      l.value.unwrap(),
      m.value.unwrap(),
      n.value.unwrap(),
      o.value.unwrap(),
      p.value.unwrap(),
    )
  })
}

///|
pub fn[
  A : Eq,
  B : Eq,
  C : Eq,
  D : Eq,
  E : Eq,
  F : Eq,
  G : Eq,
  H : Eq,
  I : Eq,
  J : Eq,
  K : Eq,
  L : Eq,
  M : Eq,
  N : Eq,
  O : Eq,
  P : Eq,
  Q : Eq,
  R,
] Node::map17(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
  h : Node[H],
  i : Node[I],
  j : Node[J],
  k : Node[K],
  l : Node[L],
  m : Node[M],
  n : Node[N],
  o : Node[O],
  p : Node[P],
  q : Node[Q],
  r : (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q) -> R,
) -> Node[R] {
  map_node([a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q], () => {
    r(
      a.value.unwrap(),
      b.value.unwrap(),
      c.value.unwrap(),
      d.value.unwrap(),
      e.value.unwrap(),
      f.value.unwrap(),
      g.value.unwrap(),
      h.value.unwrap(),
      i.value.unwrap(),
      j.value.unwrap(),
      k.value.unwrap(),
      l.value.unwrap(),
      m.value.unwrap(),
      n.value.unwrap(),
      o.value.unwrap(),
      p.value.unwrap(),
      q.value.unwrap(),
    )
  })
}

///|
pub fn[
  A : Eq,
  B : Eq,
  C : Eq,
  D : Eq,
  E : Eq,
  F : Eq,
  G : Eq,
  H : Eq,
  I : Eq,
  J : Eq,
  K : Eq,
  L : Eq,
  M : Eq,
  N : Eq,
  O : Eq,
  P : Eq,
  Q : Eq,
  R : Eq,
  S,
] Node::map18(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
  h : Node[H],
  i : Node[I],
  j : Node[J],
  k : Node[K],
  l : Node[L],
  m : Node[M],
  n : Node[N],
  o : Node[O],
  p : Node[P],
  q : Node[Q],
  r : Node[R],
  s : (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R) -> S,
) -> Node[S] {
  map_node([a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r], () => {
    s(
      a.value.unwrap(),
      b.value.unwrap(),
      c.value.unwrap(),
      d.value.unwrap(),
      e.value.unwrap(),
      f.value.unwrap(),
      g.value.unwrap(),
      h.value.unwrap(),
      i.value.unwrap(),
      j.value.unwrap(),
      k.value.unwrap(),
      l.value.unwrap(),
      m.value.unwrap(),
      n.value.unwrap(),
      o.value.unwrap(),
      p.value.unwrap(),
      q.value.unwrap(),
      r.value.unwrap(),
    )
  })
}

///|
pub fn[
  A : Eq,
  B : Eq,
  C : Eq,
  D : Eq,
  E : Eq,
  F : Eq,
  G : Eq,
  H : Eq,
  I : Eq,
  J : Eq,
  K : Eq,
  L : Eq,
  M : Eq,
  N : Eq,
  O : Eq,
  P : Eq,
  Q : Eq,
  R : Eq,
  S : Eq,
  T,
] Node::map19(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
  h : Node[H],
  i : Node[I],
  j : Node[J],
  k : Node[K],
  l : Node[L],
  m : Node[M],
  n : Node[N],
  o : Node[O],
  p : Node[P],
  q : Node[Q],
  r : Node[R],
  s : Node[S],
  t : (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S) -> T,
) -> Node[T] {
  map_node([a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s], () => {
    t(
      a.value.unwrap(),
      b.value.unwrap(),
      c.value.unwrap(),
      d.value.unwrap(),
      e.value.unwrap(),
      f.value.unwrap(),
      g.value.unwrap(),
      h.value.unwrap(),
      i.value.unwrap(),
      j.value.unwrap(),
      k.value.unwrap(),
      l.value.unwrap(),
      m.value.unwrap(),
      n.value.unwrap(),
      o.value.unwrap(),
      p.value.unwrap(),
      q.value.unwrap(),
      r.value.unwrap(),
      s.value.unwrap(),
    )
  })
}

///|
pub fn[A : Eq, B : Eq] Node::zip2(a : Node[A], b : Node[B]) -> Node[(A, B)] {
  a.map2(b, (a, b) => (a, b))
}

///|
pub fn[A : Eq, B : Eq, C : Eq] Node::zip3(
  a : Node[A],
  b : Node[B],
  c : Node[C],
) -> Node[(A, B, C)] {
  a.map3(b, c, (a, b, c) => (a, b, c))
}

///|
pub fn[A : Eq, B : Eq, C : Eq, D : Eq] Node::zip4(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
) -> Node[(A, B, C, D)] {
  a.map4(b, c, d, (a, b, c, d) => (a, b, c, d))
}

///|
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E : Eq] Node::zip5(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
) -> Node[(A, B, C, D, E)] {
  a.map5(b, c, d, e, (a, b, c, d, e) => (a, b, c, d, e))
}

///|
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E : Eq, F : Eq] Node::zip6(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
) -> Node[(A, B, C, D, E, F)] {
  a.map6(b, c, d, e, f, (a, b, c, d, e, f) => (a, b, c, d, e, f))
}

///|
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E : Eq, F : Eq, G : Eq] Node::zip7(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
) -> Node[(A, B, C, D, E, F, G)] {
  a.map7(b, c, d, e, f, g, (a, b, c, d, e, f, g) => (a, b, c, d, e, f, g))
}

///|
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E : Eq, F : Eq, G : Eq, H : Eq] Node::zip8(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
  h : Node[H],
) -> Node[(A, B, C, D, E, F, G, H)] {
  a.map8(b, c, d, e, f, g, h, (a, b, c, d, e, f, g, h) => {
    (a, b, c, d, e, f, g, h)
  })
}

///|
pub fn[A : Eq, B : Eq, C : Eq, D : Eq, E : Eq, F : Eq, G : Eq, H : Eq, I : Eq] Node::zip9(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
  h : Node[H],
  i : Node[I],
) -> Node[(A, B, C, D, E, F, G, H, I)] {
  a.map9(b, c, d, e, f, g, h, i, (a, b, c, d, e, f, g, h, i) => {
    (a, b, c, d, e, f, g, h, i)
  })
}

///|
pub fn[
  A : Eq,
  B : Eq,
  C : Eq,
  D : Eq,
  E : Eq,
  F : Eq,
  G : Eq,
  H : Eq,
  I : Eq,
  J : Eq,
] Node::zip10(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
  h : Node[H],
  i : Node[I],
  j : Node[J],
) -> Node[(A, B, C, D, E, F, G, H, I, J)] {
  a.map10(b, c, d, e, f, g, h, i, j, (a, b, c, d, e, f, g, h, i, j) => {
    (a, b, c, d, e, f, g, h, i, j)
  })
}

///|
pub fn[
  A : Eq,
  B : Eq,
  C : Eq,
  D : Eq,
  E : Eq,
  F : Eq,
  G : Eq,
  H : Eq,
  I : Eq,
  J : Eq,
  K : Eq,
] Node::zip11(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
  h : Node[H],
  i : Node[I],
  j : Node[J],
  k : Node[K],
) -> Node[(A, B, C, D, E, F, G, H, I, J, K)] {
  a.map11(b, c, d, e, f, g, h, i, j, k, (a, b, c, d, e, f, g, h, i, j, k) => {
    (a, b, c, d, e, f, g, h, i, j, k)
  })
}

///|
pub fn[
  A : Eq,
  B : Eq,
  C : Eq,
  D : Eq,
  E : Eq,
  F : Eq,
  G : Eq,
  H : Eq,
  I : Eq,
  J : Eq,
  K : Eq,
  L : Eq,
] Node::zip12(
  a : Node[A],
  b : Node[B],
  c : Node[C],
  d : Node[D],
  e : Node[E],
  f : Node[F],
  g : Node[G],
  h : Node[H],
  i : Node[I],
  j : Node[J],
  k : Node[K],
  l : Node[L],
) -> Node[(A, B, C, D, E, F, G, H, I, J, K, L)] {
  a.map12(b, c, d, e, f, g, h, i, j, k, l, (a, b, c, d, e, f, g, h, i, j, k, l) => {
    (a, b, c, d, e, f, g, h, i, j, k, l)
  })
}
