///|
/// Construct a lazily rendered virtual DOM subtree.
pub fn VNode::thunk(hash : Int, render : () -> VNode) -> VNode {
  Thunk(hash, render)
}
