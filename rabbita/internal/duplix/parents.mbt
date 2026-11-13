///|
/// Past this many parents, membership is answered by an id index instead of a
/// linear scan.
const PARENT_INDEX_THRESHOLD : Int32 = 16

///|
/// The dirty flags that depend on one node, without duplicates.
///
/// Every read after an invalidation rebuilds these edges, adding each parent
/// to each child it read, and an add must skip a parent that is already
/// present. A child shared by many parents, like the keyed source that every
/// `assoc` row reads, therefore sees one membership check per parent on every
/// read. With a linear check per parent, rebuilding N edges would cost O(N²).
/// Small sets stay a plain array. Once a set grows past
/// `PARENT_INDEX_THRESHOLD`, an id index answers each check in O(1).
priv struct Parents {
  flags : Array[DirtyFlag]
  mut index : Set[Int32]?
}

///|
fn Parents::new() -> Parents {
  { flags: [], index: None, }
}

///|
fn Parents::contains(self : Parents, flag : DirtyFlag) -> Bool {
  match self.index {
    Some(ids) => ids.contains(flag.id)
    None => self.flags.contains(flag)
  }
}

///|
/// Adds `flag` unless it is already a parent.
fn Parents::add(self : Parents, flag : DirtyFlag) -> Unit {
  guard !self.contains(flag) else { return }
  self.flags.push(flag)
  match self.index {
    Some(ids) => ids.add(flag.id)
    None => self.reindex()
  }
}

///|
fn Parents::remove(self : Parents, flag : DirtyFlag) -> Unit {
  guard self.flags.search(flag) is Some(i) else { return }
  ignore(self.flags.remove(i))
  if self.index is Some(ids) {
    ids.remove(flag.id)
  }
}

///|
fn Parents::retain(self : Parents, keep : (DirtyFlag) -> Bool) -> Unit {
  self.flags.retain(keep)
  self.reindex()
}

///|
fn Parents::clear(self : Parents) -> Unit {
  self.flags.clear()
  self.index = None
}

///|
fn Parents::iter(self : Parents) -> Iter[DirtyFlag] {
  self.flags.iter()
}

///|
/// Builds the id index when the set is past the threshold, and drops it
/// otherwise.
fn Parents::reindex(self : Parents) -> Unit {
  self.index = if self.flags.length() > PARENT_INDEX_THRESHOLD {
    Some(Set::from_iter(self.flags.iter().map(flag => flag.id)))
  } else {
    None
  }
}
