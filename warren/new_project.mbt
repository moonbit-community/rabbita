///|
let new_project_name_placeholder = "__WARREN_PROJECT_NAME__"

///|
let rabbita_version_placeholder = "__RABBITA_VERSION__"

///|
let rabbita_version = "0.15.2"

///|
let default_new_project_template = "default"

///|
enum TemplateEntry {
  Dir(String, Array[TemplateEntry])
  File(String, String)
}

///|
let default_template_dir : TemplateEntry = Dir("", [
  File("moon.mod", templates.default.moon_mod),
  File("README.md", templates.default.readme_md),
  Dir("main", [
    File("moon.pkg", templates.default.main.moon_pkg),
    File("main.mbt", templates.default.main.main_mbt),
  ]),
  Dir("public", [
    File("styles.css", templates.default.public.styles_css),
    File("index.html", templates.default.public.index_html),
  ]),
])

///|
let minimized_template_dir : TemplateEntry = Dir("", [
  File("moon.mod", templates.minimized.moon_mod),
  File("moon.pkg", templates.minimized.moon_pkg),
  File("main.mbt", templates.minimized.main_mbt),
])

///|
let server_template_dir : TemplateEntry = Dir("", [
  File("moon.mod", templates.server.moon_mod),
  File("README.md", templates.server.readme_md),
  File(".gitignore", templates.server.gitignore),
  Dir("cmd", [
    Dir("browser", [
      File("moon.pkg", templates.default.main.moon_pkg),
      File("main.mbt", templates.server.browser_main_mbt),
    ]),
    Dir("server", [
      File("moon.pkg", templates.server.moon_pkg),
      File("main.mbt", templates.server.main_mbt),
      File("warren_assets.mbt", templates.server.warren_assets_mbt),
    ]),
  ]),
  Dir("public", [
    File("styles.css", templates.default.public.styles_css),
    File("index.html", templates.default.public.index_html),
  ]),
])

///|
fn render_new_project_file(content : String, project_name : String) -> String {
  let content = content.split(new_project_name_placeholder).join(project_name)
  let content = content.split(rabbita_version_placeholder).join(rabbita_version)
  content
}

///|
fn is_valid_project_name(name : String) -> Bool {
  let mut valid = name != "" && name != "." && name != ".."
  let invalid_parts = [" ", "\t", "\n", "\r", "/", "\\", ":", "\"", "'"]
  for part in invalid_parts {
    if name.contains(part) {
      valid = false
    }
  }
  valid
}

///|
async fn write_new_project_file(
  root : String,
  relative_path : String,
  content : String,
) -> Unit {
  let path = Path::join(root, relative_path).to_string()
  let parent = Path::dirname(path).to_string()
  if parent != "" && parent != "." && !@fs.exists(parent) {
    @fs.mkdir(parent, permission=0o755, recursive=true)
  }
  @fs.write_file(path, content, create_mode=CreateOrTruncate, permission=0o644)
}

///|
async fn write_template_entry(
  root : String,
  parent : String,
  entry : TemplateEntry,
  project_name : String,
) -> Unit {
  match entry {
    File(name, content) => {
      let path = if parent == "" {
        name
      } else {
        Path::join(parent, name).to_string()
      }
      write_new_project_file(
        root,
        path,
        render_new_project_file(content, project_name),
      )
    }
    Dir(name, children) => {
      let dir = if name == "" {
        parent
      } else if parent == "" {
        name
      } else {
        Path::join(parent, name).to_string()
      }
      for child in children {
        write_template_entry(root, dir, child, project_name)
      }
    }
  }
}

///|
async fn new_project(
  project_root : SourcePath,
  dir : String,
  template_name : String,
) -> Unit {
  let project_root_string = source_path_to_string(project_root)
  let requested_target = resolve_from(project_root_string, dir)
  let requested_relative = Path::relative(
    requested_target,
    base=project_root_string,
  ).to_string()
  let project_name = Path::basename(requested_target).to_owned()
  let template_dir = match template_name {
    "default" => default_template_dir
    "minimized" => minimized_template_dir
    "server" => server_template_dir
    _ =>
      fail(
        "Unknown template `\{template_name}`. Available templates: default, minimized, server.",
      )
  }
  guard is_valid_project_name(project_name) else {
    fail(
      "Invalid project directory name `\{project_name}`. Avoid spaces, path separators, and quotes.",
    )
  }
  guard path_is_inside(requested_target, project_root_string, allow_equal=false) else {
    fail("New project directory must stay inside -C `\{project_root_string}`.")
  }
  guard !protected_output_path(requested_relative) else {
    fail("Refusing dangerous new project path: \{requested_target}")
  }
  guard !@fs.exists(requested_target) else {
    fail("Target path already exists: \{requested_target}")
  }
  let (lexical_parent, canonical_parent) = nearest_existing_parent(
    requested_target,
  )
  guard @fs.kind(canonical_parent) is Directory else {
    fail("New project parent is not a directory: \{lexical_parent}")
  }
  let target_dir = rebuild_from_canonical_parent(
    requested_target, lexical_parent, canonical_parent,
  )
  guard path_is_inside(target_dir, project_root_string, allow_equal=false) else {
    fail("New project directory resolves outside -C: \{requested_target}")
  }
  let target_relative = Path::relative(target_dir, base=project_root_string).to_string()
  guard !protected_output_path(target_relative) else {
    fail("Refusing dangerous new project path: \{requested_target}")
  }

  @fs.mkdir(target_dir, permission=0o755, recursive=true)
  write_template_entry(target_dir, "", template_dir, project_name)

  println("Created Warren project in \{target_dir}")
  println("")
  println("Next steps:")
  println("  cd \{target_dir}")
  if template_name == "server" {
    println("  warren dev --server-target native")
    println("  warren build --bundle")
  } else {
    let browser_entry = if template_name == "default" { "main" } else { "." }
    println("  warren dev --browser-entry \{browser_entry}")
  }
}

///|
test "render_new_project_file replaces placeholders" {
  inspect(
    render_new_project_file("local/__WARREN_PROJECT_NAME__", "demo"),
    content="local/demo",
  )
}

///|
test "is_valid_project_name rejects empty and path-like names" {
  inspect(is_valid_project_name("demo-app"), content="true")
  inspect(is_valid_project_name(""), content="false")
  inspect(is_valid_project_name("two words"), content="false")
  inspect(is_valid_project_name("nested/path"), content="false")
}
