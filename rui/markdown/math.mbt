///|
/// A math expression parsed by cmark's math extension.
///
/// `tex` is the source without the surrounding `$` or `$$` delimiters.
/// `display` is `true` for display math and `false` for inline math.
pub(all) struct MathSource {
  tex : String
  display : Bool
}
