///|
let global_id_count : Ref[Int32] = Ref(0)

///|
#derive(Eq, Hash, Compare)
struct Id(Int32)

///|
pub extend Id with Eq::{equal, not_equal}

///|
pub extend Id with Hash::{hash, hash_combine}

///|
pub extend Id with Compare::{compare, op_ge, op_gt, op_le, op_lt}

///|
pub impl Show for Id with fn output(self, buf) {
  Show::output(self.0, buf)
}

///|
pub extend Id with Show::{output, to_string}

///|
fn next_id() -> Int32 {
  let id = global_id_count.val
  global_id_count.val += 1
  id
}

///|
#doc(hidden)
pub fn Id::new(_ : @key.Key) -> Id {
  next_id()
}

///|
#derive(Eq, Hash)
struct InstId(Int32)

///|
pub extend InstId with Eq::{equal, not_equal}

///|
pub extend InstId with Hash::{hash, hash_combine}

///|
#doc(hidden)
pub fn InstId::new(_ : @key.Key) -> InstId {
  next_id()
}
