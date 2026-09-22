///|
pub type Path = @p.Path

///|
struct SourcePath(String) derive(Eq, Compare, Hash)

///|
pub extend SourcePath with Eq::{equal, not_equal}

///|
pub extend SourcePath with Compare::{compare, op_ge, op_gt, op_le, op_lt}

///|
pub extend SourcePath with Hash::{hash, hash_combine}

///|
pub impl Debug for SourcePath with fn to_repr(self) {
  @debug.Repr::string(self.0)
}

///|
pub extend SourcePath with Debug::{to_repr}

///|
pub fn SourcePath::new(s : String) -> Self {
  Path::resolve(s).0
}

///|
pub impl Show for SourcePath with fn output(self, buf) {
  buf.write_string(self.0)
}

///|
pub extend SourcePath with Show::{output, to_string}

///|
pub fn SourcePath::join(a : Self, b : String) -> Self {
  Path::join(a.0, b).normalize().0
}

///|
pub fn SourcePath::relative(a : Self, base : SourcePath) -> String {
  Path::relative(a.0, base=base.0).0
}
