///|
struct MooncakesPath(String) derive(Eq, Compare)

///|
pub extend MooncakesPath with Eq::{equal, not_equal}

///|
pub extend MooncakesPath with Compare::{compare, op_ge, op_gt, op_le, op_lt}

///|
pub fn MooncakesPath::new(s : String) -> Self {
  MooncakesPath(s)
}

///|
pub fn MooncakesPath::to_string(s : Self) -> String {
  s.0
}

///|
pub fn MooncakesPath::join(a : Self, b : String) -> Self {
  Path::join(a.0, b).0
}

///|
pub impl Debug for MooncakesPath with fn to_repr(self) {
  @debug.Repr::string(self.0)
}

///|
pub extend MooncakesPath with Debug::{to_repr}

///|
pub impl Show for MooncakesPath with fn output(self, buf) {
  buf.write_string(self.0)
}

///|
pub extend MooncakesPath with Show::{output}
