///|
enum ServerTarget {
  Native
  Wasm
}

///|
fn ServerTarget::moon_target(self : ServerTarget) -> String {
  match self {
    Native => "native"
    Wasm => "wasm"
  }
}

///|
struct ProjectLayout {
  root : SourcePath
  browser_entry : SourcePath
  server_entry : SourcePath?
  public_dir : SourcePath?
}

///|
fn resolve_from(root : String, raw : String) -> String {
  if Path::is_absolute(raw) {
    Path::normalize(raw).to_string()
  } else {
    Path::join(root, raw).normalize().to_string()
  }
}

///|
fn relative_is_inside(relative : String, allow_equal : Bool) -> Bool {
  if relative == "" || relative == "." {
    return allow_equal
  }
  !Path::is_absolute(relative) &&
  relative != ".." &&
  !relative.has_prefix("../") &&
  !relative.has_prefix("..\\")
}

///|
fn path_is_inside(child : String, parent : String, allow_equal~ : Bool) -> Bool {
  relative_is_inside(
    Path::relative(child, base=parent).to_string(),
    allow_equal,
  )
}

///|
async fn effective_root(raw : String?) -> SourcePath {
  let cwd = match @env.current_dir() {
    Some(path) => path
    None => fail("Unable to determine the current directory.")
  }
  let candidate = resolve_from(cwd, raw.unwrap_or("."))
  guard @fs.exists(candidate) else {
    fail("Project directory does not exist: `\{candidate}`")
  }
  guard @fs.kind(candidate) is Directory else {
    fail("Project path is not a directory: `\{candidate}`")
  }
  SourcePath::new(@fs.realpath(candidate))
}

///|
async fn resolve_input_dir(
  root : SourcePath,
  raw : String,
  label : String,
) -> SourcePath {
  let root_string = source_path_to_string(root)
  let candidate = resolve_from(root_string, raw)
  guard @fs.exists(candidate) else {
    fail("\{label} directory does not exist: `\{candidate}`")
  }
  let canonical = @fs.realpath(candidate)
  guard @fs.kind(canonical) is Directory else {
    fail("\{label} path is not a directory: `\{candidate}`")
  }
  guard path_is_inside(canonical, root_string, allow_equal=true) else {
    fail("\{label} must stay inside -C `\{root_string}`: `\{candidate}`")
  }
  SourcePath::new(canonical)
}

///|
async fn nearest_existing_parent(path : String) -> (String, String) {
  for current = path {
    if @fs.exists(current) {
      break (current, @fs.realpath(current))
    }
    let parent = Path::dirname(current).to_string()
    if parent == current {
      break fail("No existing parent directory for `\{path}`.")
    }
    continue parent
  }
}

///|
fn rebuild_from_canonical_parent(
  path : String,
  lexical_parent : String,
  canonical_parent : String,
) -> String {
  let remainder = Path::relative(path, base=lexical_parent).to_string()
  if remainder == "" || remainder == "." {
    canonical_parent
  } else {
    Path::join(canonical_parent, remainder).normalize().to_string()
  }
}

///|
fn protected_output_path(relative : String) -> Bool {
  let normalized = relative.split("\\").join("/")
  match normalized.split("/").collect() {
    [first, ..] => first == ".git" || first == "_build" || first == ".mooncakes"
    [] => false
  }
}

///|
async fn resolve_dist_dir(root : SourcePath, raw : String) -> SourcePath {
  let root_string = source_path_to_string(root)
  let candidate = resolve_from(root_string, raw)
  let relative = Path::relative(candidate, base=root_string).to_string()
  guard relative_is_inside(relative, false) else {
    fail("--dist must be a child of -C `\{root_string}`: `\{candidate}`")
  }
  guard !protected_output_path(relative) else {
    fail("Refusing dangerous --dist path: `\{candidate}`")
  }
  let resolved_output = if @fs.exists(candidate) {
    let output_kind = @fs.kind(candidate, follow_symlink=false)
    guard !(output_kind is SymLink) else {
      fail("--dist must not be a symbolic link: `\{candidate}`")
    }
    guard output_kind is Directory else {
      fail("--dist exists but is not a directory: `\{candidate}`")
    }
    let canonical = @fs.realpath(candidate)
    guard path_is_inside(canonical, root_string, allow_equal=false) else {
      fail("--dist resolves outside -C: `\{candidate}`")
    }
    canonical
  } else {
    let (lexical_parent, canonical_parent) = nearest_existing_parent(candidate)
    guard @fs.kind(canonical_parent) is Directory else {
      fail("--dist parent is not a directory: `\{lexical_parent}`")
    }
    let canonical = rebuild_from_canonical_parent(
      candidate, lexical_parent, canonical_parent,
    )
    guard path_is_inside(canonical, root_string, allow_equal=false) else {
      fail("--dist has a parent that resolves outside -C: `\{candidate}`")
    }
    canonical
  }
  let resolved_relative = Path::relative(resolved_output, base=root_string).to_string()
  guard !protected_output_path(resolved_relative) else {
    fail("Refusing dangerous --dist path: `\{candidate}`")
  }
  SourcePath::new(resolved_output)
}

///|
fn paths_overlap(a : SourcePath, b : SourcePath) -> Bool {
  let a = source_path_to_string(a)
  let b = source_path_to_string(b)
  path_is_inside(a, b, allow_equal=true) ||
  path_is_inside(b, a, allow_equal=true)
}

///|
fn validate_dist_inputs(
  root : SourcePath,
  dist : SourcePath,
  browser_entry : SourcePath,
  server_entry : SourcePath?,
  public_dir : SourcePath?,
) -> Unit raise {
  if browser_entry != root {
    guard !paths_overlap(dist, browser_entry) else {
      fail("--dist must not overlap --browser-entry.")
    }
  }
  if server_entry is Some(entry) {
    guard !paths_overlap(dist, entry) else {
      fail("--dist must not overlap --server-entry.")
    }
  }
  if public_dir is Some(dir) {
    guard !paths_overlap(dist, dir) else {
      fail("--dist must not overlap --public-dir.")
    }
  }
}

///|
async fn resolve_project_layout(
  root : SourcePath,
  browser_entry_raw : String?,
  server_entry_raw : String?,
  public_dir_raw : String?,
) -> ProjectLayout {
  let browser_entry = if browser_entry_raw is Some(raw) {
    guard raw != "" else { fail("Browser entry is required.") }
    resolve_input_dir(root, raw, "Browser entry")
  } else {
    resolve_input_dir(root, "cmd/browser", "Browser entry")
  }
  let server_entry = if server_entry_raw is Some(raw) {
    if raw == "" {
      None
    } else {
      Some(resolve_input_dir(root, raw, "Server entry"))
    }
  } else {
    let conventional = resolve_from(source_path_to_string(root), "cmd/server")
    if @fs.exists(conventional) {
      Some(resolve_input_dir(root, "cmd/server", "Server entry"))
    } else {
      None
    }
  }
  let public_dir = match public_dir_raw {
    Some(raw) => Some(resolve_input_dir(root, raw, "Public"))
    None => {
      let conventional = resolve_from(source_path_to_string(root), "public")
      if @fs.exists(conventional) {
        Some(resolve_input_dir(root, "public", "Public"))
      } else {
        None
      }
    }
  }
  { root, browser_entry, server_entry, public_dir }
}

///|
async fn resolve_mbtx_layout(
  root : SourcePath,
  raw : String,
  public_dir_raw : String?,
) -> ProjectLayout {
  guard raw.has_suffix(".mbtx") else {
    fail("Standalone browser entry must use the `.mbtx` extension.")
  }
  let root_string = source_path_to_string(root)
  let candidate = resolve_from(root_string, raw)
  guard @fs.exists(candidate) else {
    fail("Standalone browser entry does not exist.")
  }
  let canonical = @fs.realpath(candidate)
  guard @fs.kind(canonical) is Regular else {
    fail("Standalone browser entry must be a regular file.")
  }
  guard path_is_inside(canonical, root_string, allow_equal=false) else {
    fail("Standalone browser entry must stay inside the project root.")
  }
  let public_dir = match public_dir_raw {
    Some(value) => Some(resolve_input_dir(root, value, "Public"))
    None => {
      let conventional = resolve_from(root_string, "public")
      if @fs.exists(conventional) {
        Some(resolve_input_dir(root, "public", "Public"))
      } else {
        None
      }
    }
  }
  {
    root,
    browser_entry: SourcePath::new(canonical),
    server_entry: None,
    public_dir,
  }
}

///|
fn parse_server_target(raw : String?) -> ServerTarget raise {
  match raw {
    None | Some("wasm") => Wasm
    Some("native") => Native
    Some(value) =>
      fail("Invalid --server-target `\{value}`. Expected `native` or `wasm`.")
  }
}

///|
fn parse_port(raw : String?) -> UInt raise {
  let value = raw.unwrap_or("4300")
  let parsed = @string.parse_int(value) catch {
    _ =>
      fail(
        "Invalid --port value `\{value}`. Expected a number from 1 to 65535.",
      )
  }
  guard parsed > 0 && parsed <= 65535 else {
    fail("Invalid --port value `\{value}`. Expected a number from 1 to 65535.")
  }
  parsed.reinterpret_as_uint()
}

///|
fn ignored_watch_path(path : String) -> Bool {
  let normalized = path.split("\\").join("/")
  normalized
  .split("/")
  .any(part => {
    part == ".git" || part == "_build" || part == ".mooncakes" || part == "dist"
  })
}

///|
fn ignored_watch_path_with_temp(path : String, temp_relative : String) -> Bool {
  if ignored_watch_path(path) {
    return true
  }
  guard relative_is_inside(temp_relative, false) else { return false }
  let normalized = path.split("\\").join("/")
  let normalized_temp = temp_relative.split("\\").join("/")
  normalized == normalized_temp || normalized.has_prefix("\{normalized_temp}/")
}

///|
test "relative path containment" {
  inspect(relative_is_inside("", true), content="true")
  inspect(relative_is_inside("child/file", false), content="true")
  inspect(relative_is_inside("../outside", true), content="false")
  inspect(relative_is_inside("..\\outside", true), content="false")
}

///|
test "watch ignores fixed generated directories" {
  inspect(ignored_watch_path("cmd/browser/main.mbt"), content="false")
  inspect(ignored_watch_path("cmd/browser/_build/out.js"), content="true")
  inspect(ignored_watch_path("nested/dist/index.js"), content="true")
  inspect(ignored_watch_path(".git/index"), content="true")
  inspect(
    ignored_watch_path_with_temp(".warren-temp/static/index.js", ".warren-temp"),
    content="true",
  )
}

///|
test "server target defaults to wasm" {
  assert_true(parse_server_target(None) is Wasm)
  assert_true(parse_server_target(Some("wasm")) is Wasm)
  assert_true(parse_server_target(Some("native")) is Native)
}

///|
async test "empty entry options clear their defaults" {
  let root_string = @fs.tmpdir(prefix="warren-entry-options")
  let root = SourcePath::new(@fs.realpath(root_string))
  @fs.mkdir(
    source_path_to_string(root.join("cmd/browser")),
    permission=0o755,
    recursive=true,
  )
  @fs.mkdir(
    source_path_to_string(root.join("cmd/server")),
    permission=0o755,
    recursive=true,
  )
  let browser_only = resolve_project_layout(root, None, Some(""), None)
  assert_true(browser_only.server_entry is None)
  let missing_browser = try
    resolve_project_layout(root, Some(""), None, None)
  catch {
    Failure(_) => true
    _ => false
  } noraise {
    _ => false
  }
  assert_true(missing_browser)
  @fs.rmdir(root_string, recursive=true)
}

///|
test "dist may be nested under a root browser entry" {
  let root = SourcePath::new("test-project")
  validate_dist_inputs(root, root.join("dist"), root, None, None)
}

///|
test "dist may not contain an entry" {
  let root = SourcePath::new("test-project")
  let rejected = try
    validate_dist_inputs(
      root,
      root.join("output"),
      root.join("output/cmd/browser"),
      None,
      None,
    )
  catch {
    Failure(_) => true
    _ => false
  } noraise {
    _ => false
  }
  inspect(rejected, content="true")
}
