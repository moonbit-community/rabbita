///|
using @path {type SourcePath, type Path}

///|
let build_entry_script =
  #|    <script src="/index.js" type="module"></script>

///|
priv struct MoonBuildOutput {
  artifacts_path : Array[String]
} derive(FromJson)

///|
fn source_path_to_string(path : SourcePath) -> String {
  "\{path}"
}

///|
fn has_build_entry_script(html : String) -> Bool {
  html.contains("src=\"/index.js") ||
  html.contains("src='/index.js") ||
  html.contains("src=\"./index.js") ||
  html.contains("src='./index.js") ||
  html.contains("src=\"index.js") ||
  html.contains("src='index.js")
}

///|
fn inject_build_entry_script(html : String) -> String {
  guard !has_build_entry_script(html) else { html }
  let patch = "\{build_entry_script}\n"
  match html.rev_find("</head>") {
    Some(index) => "\{html[:index]}\{patch}\{html[index:]}"
    None =>
      match html.rev_find("</body>") {
        Some(index) => "\{html[:index]}\{patch}\{html[index:]}"
        None =>
          match html.rev_find("</html>") {
            Some(index) => "\{html[:index]}\{patch}\{html[index:]}"
            None =>
              if html.has_suffix("\n") {
                "\{html}\{patch}"
              } else {
                "\{html}\n\{patch}"
              }
          }
      }
  }
}

///|
fn default_build_html(has_stylesheet : Bool) -> String {
  let stylesheet = if has_stylesheet {
    (
      #|    <link rel="stylesheet" type="text/css" href="/styles.css"></link>
    )
  } else {
    ""
  }
  (
    $|<!DOCTYPE html>
    $|<html lang="en">
    $|<head>
    $|    <meta charset="UTF-8">
    $|    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    $|    <title>warren build</title>
    $|\{stylesheet}
    $|\{build_entry_script}
    $|</head>
    $|<body>
    $|    <div id="app"></div>
    $|</body>
    $|</html>
  )
}

///|
async fn ensure_clean_dir(path : SourcePath) -> Unit {
  let path_string = source_path_to_string(path)
  if @fs.exists(path_string) {
    match @fs.kind(path_string, follow_symlink=false) {
      SymLink =>
        fail("Refusing to replace symbolic-link directory: `\{path_string}`")
      Directory => @fs.rmdir(path_string, recursive=true)
      _ => @fs.remove(path_string)
    }
  }
  @fs.mkdir(path_string, permission=0o755, recursive=true)
}

///|
async fn copy_dir_contents(src : SourcePath, dst : SourcePath) -> Unit {
  for
    entry in @fs.readdir(
      source_path_to_string(src),
      include_hidden=true,
      sort=true,
    ) {
    copy(src=src.join(entry), dst=dst.join(entry))
  }
}

///|
fn moon_entry(project_root : SourcePath, entry : SourcePath) -> String {
  match entry.relative(project_root) {
    "" | "." => "."
    relative => relative
  }
}

///|
fn build_only_args(
  project_root : SourcePath,
  entry : SourcePath,
  target : String,
  release : Bool,
) -> Array[String] {
  let args = ["run", "--build-only", "--target", target]
  if release {
    args.push("--release")
  }
  args.push(moon_entry(project_root, entry))
  args
}

///|
fn parse_build_only_artifact(output : String) -> String raise {
  let result : MoonBuildOutput = @json.from_json(@json.parse(output)) catch {
    _ =>
      fail(
        "`moon run --build-only` returned invalid JSON. Upgrade MoonBit to a version that prints `artifacts_path`.",
      )
  }
  match result.artifacts_path {
    [artifact] => artifact
    [] =>
      fail(
        "`moon run --build-only` returned no artifact. Upgrade MoonBit if this command does not support `artifacts_path`.",
      )
    artifacts =>
      fail(
        "`moon run --build-only` returned multiple artifacts: \{Repr(artifacts)}.",
      )
  }
}

///|
async fn run_build_only(
  project_root : SourcePath,
  entry : SourcePath,
  target : String,
  release : Bool,
) -> SourcePath {
  let args = build_only_args(project_root, entry, target, release)
  log("build", "Running `moon \{args.join(" ")}`")
  let (code, stdout, stderr) = @process.collect_output(
    "moon",
    args,
    cwd=source_path_to_string(project_root),
    inherit_env=true,
  )
  let stderr_text = stderr.text().trim().to_owned()
  let stdout_text = stdout.text().trim().to_owned()
  if stderr_text != "" {
    log("moon", stderr_text)
  }
  guard code == 0 else {
    let output = if stderr_text == "" {
      stdout_text
    } else if stdout_text == "" {
      stderr_text
    } else {
      "\{stderr_text}\n\{stdout_text}"
    }
    let diagnostics = if output == "" {
      "moon run --build-only exited with code \{code}."
    } else {
      "\{output}\n\nmoon run --build-only exited with code \{code}."
    }
    fail(diagnostics)
  }
  let artifact = parse_build_only_artifact(stdout_text)
  guard Path::is_absolute(artifact) else {
    fail("Moon returned a non-absolute artifact path: `\{artifact}`")
  }
  guard @fs.exists(artifact) && @fs.kind(artifact) is Regular else {
    fail("Moon artifact does not exist or is not a file: `\{artifact}`")
  }
  SourcePath::new(artifact)
}

///|
async fn has_command(cmd : String) -> Bool {
  try @process.collect_stdout(cmd, ["--version"]) catch {
    _ => false
  } noraise {
    (0, _) => true
    _ => false
  }
}

///|
async fn run_minifier(
  cmd : String,
  args : Array[String],
  cwd : SourcePath,
  label : String,
) -> Bool {
  log("build", "Minifying JS with \{label}")
  try @process.run(cmd, args, cwd=source_path_to_string(cwd)) catch {
    err => {
      log("warn", "\{label} failed: \{err}. Falling back to release JS")
      false
    }
  } noraise {
    0 => true
    code => {
      log(
        "warn",
        "\{label} exited with code \{code}, falling back to release JS",
      )
      false
    }
  }
}

///|
async fn minify_or_copy_js(
  src : SourcePath,
  dst : SourcePath,
  project_root : SourcePath,
) -> Unit {
  let src_string = source_path_to_string(src)
  let dst_string = source_path_to_string(dst)
  let terser_args = [
    src_string, "-c", "toplevel=true", "-m", "toplevel=true", "-o", dst_string,
  ]
  if has_command("terser") {
    guard !run_minifier("terser", terser_args, project_root, "terser") else {
      return
    }
    copy(src~, dst~)
    return
  }
  if has_command("node") && has_command("npm") {
    guard !run_minifier(
      "npm",
      ["exec", "--yes", "terser", "--", ..terser_args],
      project_root,
      "npm exec terser",
    ) else {
      return
    }
    copy(src~, dst~)
    return
  }
  log(
    "warn", "terser not found and node/npm unavailable. Using Moon release JS without extra minification.",
  )
  copy(src~, dst~)
}

///|
async fn write_index_html(dist_dir : SourcePath) -> Unit {
  let index_path = dist_dir.join("index.html")
  let index_string = source_path_to_string(index_path)
  if @fs.exists(index_string) {
    let html = @fs.read_file(index_string).text()
    @fs.write_file(
      index_string,
      inject_build_entry_script(html),
      create_mode=CreateOrTruncate,
      permission=0o644,
    )
  } else {
    let has_stylesheet = @fs.exists(
      source_path_to_string(dist_dir.join("styles.css")),
    )
    @fs.write_file(
      index_string,
      default_build_html(has_stylesheet),
      create_mode=CreateOrTruncate,
      permission=0o644,
    )
  }
}

///|
async fn assemble_static(
  project_root : SourcePath,
  public_dir : SourcePath?,
  browser_artifact : SourcePath,
  destination : SourcePath,
  release : Bool,
) -> Unit {
  if public_dir is Some(dir) {
    let generated_files = ["index.js"]
    if !release {
      generated_files.push("index.js.map")
    }
    for generated in generated_files {
      if @fs.exists(source_path_to_string(dir.join(generated))) {
        fail("Public files collide with generated `\{generated}`.")
      }
    }
  }
  ensure_clean_dir(destination)
  if public_dir is Some(dir) {
    copy_dir_contents(dir, destination)
  }
  if release {
    minify_or_copy_js(
      browser_artifact,
      destination.join("index.js"),
      project_root,
    )
  } else {
    let artifact_string = source_path_to_string(browser_artifact)
    let artifact_basename = Path::basename(artifact_string).to_owned()
    let map_path = Path::join(
      Path::dirname(artifact_string),
      "\{artifact_basename}.map",
    ).to_string()
    let browser_js = @fs.read_file(artifact_string)
      .text()
      .split("sourceMappingURL=\{artifact_basename}.map")
      .join("sourceMappingURL=index.js.map")
    @fs.write_file(
      source_path_to_string(destination.join("index.js")),
      browser_js,
      create_mode=CreateOrTruncate,
      permission=0o644,
    )
    if @fs.exists(map_path) {
      copy(src=SourcePath::new(map_path), dst=destination.join("index.js.map"))
    }
  }
  write_index_html(destination)
}

///|
async fn copy_server_artifact(
  artifact : SourcePath,
  destination : SourcePath,
  target : ServerTarget,
  output_name? : String,
) -> SourcePath {
  let basename = output_name.unwrap_or(
    Path::basename(source_path_to_string(artifact)).to_owned(),
  )
  let output = destination.join(basename)
  guard !@fs.exists(source_path_to_string(output)) else {
    fail(
      "Server artifact `\{basename}` collides with a public or generated file.",
    )
  }
  copy(src=artifact, dst=output)
  if target is Native {
    chmod_executable(output)
  }
  output
}

///|
fn server_run_command(
  dist : SourcePath,
  target : ServerTarget,
  server_output : SourcePath?,
) -> String? {
  if target is Wasm && server_output is Some(output) {
    let basename = Path::basename(source_path_to_string(output))
    Some("cd \{dist} && moon run \{basename}")
  } else {
    None
  }
}

///|
async fn build_project(
  layout : ProjectLayout,
  server_target : ServerTarget,
  dist : SourcePath,
  bundle? : Bool = false,
) -> Unit {
  if bundle {
    build_bundle(layout, server_target, dist)
    return
  }
  ensure_clean_dir(dist)
  let browser_artifact = run_build_only(
    layout.root,
    layout.browser_entry,
    "js",
    true,
  )
  assemble_static(layout.root, layout.public_dir, browser_artifact, dist, true)
  let server_output = if layout.server_entry is Some(server_entry) {
    let server_artifact = run_build_only(
      layout.root,
      server_entry,
      server_target.moon_target(),
      true,
    )
    Some(copy_server_artifact(server_artifact, dist, server_target))
  } else {
    None
  }
  log("build", "Build output written to \{dist}")
  if server_run_command(dist, server_target, server_output) is Some(command) {
    println("")
    log("hint", "Start the server with:")
    println("")
    println("  \{command}")
    println("")
  }
}

///|
async test "inject_build_entry_script inserts before head" {
  let html =
    $|<html>
    $|<head>
    $|</head>
    $|<body></body>
    $|</html>
  inspect(
    inject_build_entry_script(html),
    content=(
      $|<html>
      $|<head>
      $|    <script src="/index.js" type="module"></script>
      $|</head>
      $|<body></body>
      $|</html>
    ),
  )
}

///|
test "inject_build_entry_script uses fallback insertion points" {
  let patch = "\{build_entry_script}\n"
  inspect(
    inject_build_entry_script("<html><body></body></html>"),
    content="<html><body>\{patch}</body></html>",
  )
  inspect(
    inject_build_entry_script("<html></html>"),
    content="<html>\{patch}</html>",
  )
  inspect(
    inject_build_entry_script("plain text"),
    content="plain text\n\{patch}",
  )
  inspect(
    inject_build_entry_script("plain text\n"),
    content="plain text\n\{patch}",
  )
}

///|
test "build-only JSON requires exactly one artifact" {
  inspect(
    parse_build_only_artifact("{\"artifacts_path\":[\"/tmp/server.exe\"]}"),
    content="/tmp/server.exe",
  )
  let no_artifact = try
    parse_build_only_artifact("{\"artifacts_path\":[]}")
  catch {
    Failure(_) => true
    _ => false
  } noraise {
    _ => false
  }
  inspect(no_artifact, content="true")
  let multiple = try
    parse_build_only_artifact(
      "{\"artifacts_path\":[\"/tmp/one\",\"/tmp/two\"]}",
    )
  catch {
    Failure(_) => true
    _ => false
  } noraise {
    _ => false
  }
  inspect(multiple, content="true")
  let invalid = try parse_build_only_artifact("not-json") catch {
    Failure(_) => true
    _ => false
  } noraise {
    _ => false
  }
  inspect(invalid, content="true")
}

///|
test "build HTML preserves a relative browser entry" {
  inspect(
    inject_build_entry_script(
      "<html><head><script src=\"./index.js\"></script></head></html>",
    ),
    content="<html><head><script src=\"./index.js\"></script></head></html>",
  )
}

///|
test "build HTML preserves a relative browser entry with a query" {
  inspect(
    inject_build_entry_script(
      "<html><head><script src=\"./index.js?v=1\"></script></head></html>",
    ),
    content="<html><head><script src=\"./index.js?v=1\"></script></head></html>",
  )
}

///|
test "build-only command reuses Moon's default build cache" {
  let root = SourcePath::new("test-project")
  let args = build_only_args(root, root.join("cmd/browser"), "js", false)
  inspect(args.length(), content="5")
  inspect(args[0], content="run")
  inspect(args[1], content="--build-only")
  inspect(args[3], content="js")
  inspect(args.contains("--target-dir"), content="false")
  inspect(args[4] == "cmd/browser" || args[4] == "cmd\\browser", content="true")
}

///|
test "wasm build prints the copied server artifact run command" {
  let dist = SourcePath::new("/workspace/dist")
  let server = dist.join("server.wasm")
  assert_eq(
    server_run_command(dist, Wasm, Some(server)),
    Some("cd /workspace/dist && moon run server.wasm"),
  )
  assert_eq(server_run_command(dist, Native, Some(server)), None)
  assert_eq(server_run_command(dist, Wasm, None), None)
}
