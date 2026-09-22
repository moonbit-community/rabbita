///|
pub(all) enum Variant {
  Boolean(Bool)
  Integer(Int)
  Floating(Double)
  String(String)
} derive(Debug, Eq, Compare, Hash)

///|
pub extend Variant with Debug::{to_repr}

///|
pub extend Variant with Eq::{equal, not_equal}

///|
pub extend Variant with Compare::{compare, op_ge, op_gt, op_le, op_lt}

///|
pub extend Variant with Hash::{hash, hash_combine}

///|
pub impl Show for Variant with fn output(self, buf) {
  Show::output(@debug.Debug::to_repr(self), buf)
}

///|
pub extend Variant with Show::{output, to_string}
