///|
/// https://html.spec.whatwg.org/multipage/media.html#time-ranges
///
/// A read-only snapshot of media time ranges, such as the values returned by
/// `get_buffered`, `get_played`, and `get_seekable`. Each retrieval returns a
/// new snapshot: its ranges never change afterwards and cannot be mutated.
#cfg(target="js")
type TimeRanges

///|
/// The number of ranges in this snapshot.
#cfg(target="js")
pub extern "js" fn TimeRanges::length(self : Self) -> Int = "(r) => r.length"

///|
/// The position of the start of the range at `index`, or `None` when `index` is
/// out of range. The native `start` method throws IndexSizeError for such
/// indexes.
#cfg(target="js")
pub fn TimeRanges::start(self : Self, index : Int) -> Double? {
  if index >= 0 && index < self.length() {
    Some(self.start_ffi(index))
  } else {
    None
  }
}

///|
/// The position of the end of the range at `index`, or `None` when `index` is
/// out of range. The native `end` method throws IndexSizeError for such
/// indexes.
#cfg(target="js")
pub fn TimeRanges::end(self : Self, index : Int) -> Double? {
  if index >= 0 && index < self.length() {
    Some(self.end_ffi(index))
  } else {
    None
  }
}

///|
/// Iterates the `(start, end)` pairs of this snapshot without materializing an
/// array.
#cfg(target="js")
pub fn TimeRanges::iter(self : Self) -> Iter[(Double, Double)] {
  let length = self.length()
  let mut index = 0
  Iter::new(fn() {
    if index < length {
      let item = (self.start_ffi(index), self.end_ffi(index))
      index += 1
      Some(item)
    } else {
      None
    }
  })
}

///|
#cfg(target="js")
extern "js" fn TimeRanges::start_ffi(self : Self, index : Int) -> Double = "(r, i) => r.start(i)"

///|
#cfg(target="js")
extern "js" fn TimeRanges::end_ffi(self : Self, index : Int) -> Double = "(r, i) => r.end(i)"
