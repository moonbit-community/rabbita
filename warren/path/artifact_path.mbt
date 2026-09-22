///|
struct ArtifactPath {
  root : SourcePath
  mod_path : String?
  relative : String
}

///|
pub(all) enum Target {
  Wasm
  WasmGC
  Js
  Native
} derive(Eq, Hash, Debug)

///|
pub extend Target with Eq::{equal, not_equal}

///|
pub extend Target with Hash::{hash, hash_combine}

///|
pub extend Target with Debug::{to_repr}

///|
pub(all) enum Build {
  Release
  Debug
} derive(Eq, Hash, Debug)

///|
pub extend Build with Eq::{equal, not_equal}

///|
pub extend Build with Hash::{hash, hash_combine}

///|
pub extend Build with Debug::{to_repr}

///|
pub(all) enum Mode {
  Check
  Build
} derive(Eq, Hash, Debug)

///|
pub extend Mode with Eq::{equal, not_equal}

///|
pub extend Mode with Hash::{hash, hash_combine}

///|
pub extend Mode with Debug::{to_repr}

///|
pub impl Debug for ArtifactPath with fn to_repr(self) {
  @debug.Repr::string(self.to_string(Js, Debug, Build).to_string())
}

///|
pub extend ArtifactPath with Debug::{to_repr}

///|
pub fn ArtifactPath::join_module_path(
  self : Self,
  mod : MooncakesPath,
) -> ArtifactPath {
  { ..self, mod_path: Some(mod.to_string()), }
}

///|
pub fn ArtifactPath::new(root : SourcePath) -> ArtifactPath {
  { root, relative: "", mod_path: None, }
}

///|
pub fn ArtifactPath::join_relative(s1 : Self, s2 : String) -> ArtifactPath {
  { ..s1, relative: Path::join(s1.relative, s2).0, }
}

///|
pub fn ArtifactPath::to_string(
  self : Self,
  target : Target,
  build : Build,
  mode : Mode,
) -> SourcePath {
  let mut acc = self.root
  acc = acc.join(
    match target {
      Js => "js"
      Native => "native"
      Wasm => "wasm"
      WasmGC => "wasm-gc"
    },
  )
  acc = acc.join(
    match build {
      Release => "release"
      Debug => "debug"
    },
  )
  acc = acc.join(
    match mode {
      Check => "check"
      Build => "build"
    },
  )
  if self.mod_path is Some(mod) {
    acc = acc.join(mod)
  }
  acc.join(self.relative)
}
