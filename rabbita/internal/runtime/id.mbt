///|
let global_id_count : Ref[Int] = @ref.new(0)

///|
struct Id(Int) derive(Eq, Hash, Compare, Show)

///|
priv struct InstId(Int) derive(Eq, Hash)

///|
fn next_id() -> Int {
  let id = global_id_count.val
  global_id_count.val += 1
  id
}

///|
fn Id::new() -> Id {
  next_id()
}

///|
fn InstId::new() -> InstId {
  next_id()
}
