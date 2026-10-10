///|
/// cmark parser configuration for `markdown`.
/// Defaults enable syntax extensions and automatic heading IDs.
/// `file`, `defs` and `resolver` use cmark's defaults when `None`.
/// In particular, `defs=None` creates a fresh definition map on every parse;
/// a supplied map is shared and mutated by cmark when this configuration is reused.
pub(all) struct ParserOptions {
  strict : Bool
  heading_auto_ids : Bool
  nested_links : Bool
  layout : Bool
  locs : Bool
  file : String?
  defs : Map[String, @cmark.LabelDef]?
  resolver : @cmark.LabelResolverFn?
}

///|
pub extend ParserOptions with Default::{default}

///|
pub impl Default for ParserOptions with fn default() {
  {
    strict: false,
    heading_auto_ids: true,
    nested_links: false,
    layout: false,
    locs: false,
    file: None,
    defs: None,
    resolver: None,
  }
}
