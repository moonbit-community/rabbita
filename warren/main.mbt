///|
let shell_html_template =
  $|<!DOCTYPE html>
  $|<html lang="en">
  $|<head>
  $|    <meta charset="UTF-8">
  $|    <meta name="viewport" content="width=device-width, initial-scale=1.0">
  $|    <title>warren dev</title>
  $|    <script src="/warren_devtool.js" type="module"></script>
  $|    <link rel="stylesheet" type="text/css" href="/warren_devtool.css"></link>
  $|</head>
  $|<body>
  $|    <div id="warren-devtool"></div>
  $|</body>
  $|</html>

///|
let app_html_template =
  $|<!DOCTYPE html>
  $|<html lang="en">
  $|<head>
  $|    <meta charset="UTF-8">
  $|    <meta name="viewport" content="width=device-width, initial-scale=1.0">
  $|    <title>warren preview</title>
  $|</head>
  $|<body>
  $|    <div id="app"></div>
  $|</body>
  $|</html>

///|
let preview_base_patch =
  #|<base href="/">

///|
let preview_entry_script_patch =
  #|<script src="/index.js" type="module"></script>

///|
let preview_stylesheet_patch =
  #|<link rel="stylesheet" type="text/css" href="/styles.css"></link>

///|
let direct_client_patch =
  #|<script src="/__warren/direct.js" type="module"></script>

///|
let direct_client_js =
  #|function connect() {
  #|  const protocol = location.protocol === "https:" ? "wss:" : "ws:";
  #|  const socket = new WebSocket(`${protocol}//${location.host}/__warren/events`);
  #|  socket.addEventListener("message", event => {
  #|    if (event.data === "reload") {
  #|      location.reload();
  #|    }
  #|  });
  #|  socket.addEventListener("close", () => {
  #|    setTimeout(connect, 1000);
  #|  });
  #|}
  #|connect();

///|
let fullstack_client_js =
  #|(function () {
  #|  const script = document.currentScript;
  #|  if (!script) {
  #|    return;
  #|  }
  #|  const clientUrl = new URL(script.src);
  #|  const protocol = clientUrl.protocol === "https:" ? "wss:" : "ws:";
  #|  const eventsUrl = `${protocol}//${clientUrl.host}/__warren/events`;
  #|  function connect() {
  #|    const socket = new WebSocket(eventsUrl);
  #|    socket.addEventListener("message", event => {
  #|      if (event.data === "reload") {
  #|        location.reload();
  #|      }
  #|    });
  #|    socket.addEventListener("close", () => {
  #|      setTimeout(connect, 1000);
  #|    });
  #|  }
  #|  connect();
  #|})();

///|
fn warren_cli() -> @argparse.Command {
  Command(
    "warren",
    options=[
      OptionArg(
        "directory",
        short='C',
        global=true,
        about="Run as if Warren was started in this directory.",
      ),
    ],
    subcommands=[
      Command(
        "dev",
        positionals=[
          PositionArg("mbtx", about="Standalone .mbtx browser entry.", conflicts_with=[
            "browser-entry", "server-entry", "server-target",
          ]),
        ],
        options=[
          OptionArg(
            "browser-entry",
            about="Browser entry package directory. Default: ./cmd/browser; an empty value is invalid.",
          ),
          OptionArg(
            "server-entry",
            about="Server entry package directory. Default: ./cmd/server when present; pass an empty value to disable it.",
          ),
          OptionArg(
            "server-target",
            about="Server target: wasm (default) or native.",
          ),
          OptionArg(
            "public-dir",
            about="Static files directory. Defaults to ./public when present.",
          ),
          OptionArg("port", about="Local preview server port. Default: 4300."),
        ],
        flags=[
          FlagArg(
            "direct",
            about="Serve the application as the top-level page and disable the server entry. Implies --server-entry \"\".",
          ),
        ],
        about="Start a local preview server with live reload.",
      ),
      Command(
        "build",
        positionals=[
          PositionArg("mbtx", about="Standalone .mbtx browser entry.", conflicts_with=[
            "browser-entry", "server-entry", "server-target",
          ]),
        ],
        options=[
          OptionArg(
            "browser-entry",
            about="Browser entry package directory. Default: ./cmd/browser; an empty value is invalid.",
          ),
          OptionArg(
            "server-entry",
            about="Server entry package directory. Default: ./cmd/server when present; pass an empty value to disable it.",
          ),
          OptionArg(
            "server-target",
            about="Server target: wasm (default) or native.",
          ),
          OptionArg(
            "public-dir",
            about="Static files directory. Defaults to ./public when present.",
          ),
          OptionArg("dist", about="Build output directory. Default: ./dist."),
        ],
        about="Build browser and optional server release artifacts.",
      ),
      Command(
        "new",
        positionals=[
          PositionArg(
            "dir_name",
            about="Directory name for the new Warren project.",
          ),
        ],
        options=[
          OptionArg(
            "template",
            about="Project template to use. Default: default. Available: default, minimized.",
          ),
        ],
        about="Create a minimal Rabbita project.",
      ),
    ],
    about="Preview and build full-stack MoonBit applications.",
  )
}

///|
fn option_value(matches : @argparse.Matches, name : String) -> String? {
  match matches.values.get(name) {
    Some([value]) => Some(value)
    _ => None
  }
}

///|
fn dev_server_entry_value(matches : @argparse.Matches) -> String? raise {
  let value = option_value(matches, "server-entry")
  if matches.flags.get("direct") is Some(true) {
    if value is Some(raw) && raw != "" {
      fail("--direct cannot be used with a non-empty --server-entry.")
    }
    Some("")
  } else {
    value
  }
}

///|
async fn run_cli() -> Unit {
  let cli = warren_cli().parse()
  guard cli.subcommand is Some((subcmd, submatches)) else { return }
  let directory = match option_value(submatches, "directory") {
    Some(path) => Some(path)
    None => option_value(cli, "directory")
  }
  let root = effective_root(directory)
  let mbtx_entry = option_value(submatches, "mbtx")
  match subcmd {
    "dev" => {
      let direct = submatches.flags.get("direct") is Some(true)
      let layout = if mbtx_entry is Some(raw) {
        resolve_mbtx_layout(root, raw, option_value(submatches, "public-dir"))
      } else {
        resolve_project_layout(
          root,
          option_value(submatches, "browser-entry"),
          dev_server_entry_value(submatches),
          option_value(submatches, "public-dir"),
        )
      }
      let target_raw = option_value(submatches, "server-target")
      let server_target = parse_server_target(target_raw)
      if target_raw is Some(_) && layout.server_entry is None {
        fail("--server-target requires a server entry.")
      }
      let port = parse_port(option_value(submatches, "port"))
      dev_project(layout, server_target, port, direct)
    }
    "build" => {
      let layout = if mbtx_entry is Some(raw) {
        resolve_mbtx_layout(root, raw, option_value(submatches, "public-dir"))
      } else {
        resolve_project_layout(
          root,
          option_value(submatches, "browser-entry"),
          option_value(submatches, "server-entry"),
          option_value(submatches, "public-dir"),
        )
      }
      let target_raw = option_value(submatches, "server-target")
      let server_target = parse_server_target(target_raw)
      if target_raw is Some(_) && layout.server_entry is None {
        fail("--server-target requires a server entry.")
      }
      let dist = resolve_dist_dir(
        root,
        option_value(submatches, "dist").unwrap_or("dist"),
      )
      validate_dist_inputs(
        root,
        dist,
        layout.browser_entry,
        layout.server_entry,
        layout.public_dir,
      )
      build_project(layout, server_target, dist)
    }
    "new" =>
      match submatches.values.get("dir_name") {
        Some([dir]) => {
          let template = match submatches.values.get("template") {
            Some([name]) => name
            _ => default_new_project_template
          }
          new_project(root, dir, template)
        }
        _ => println("Usage: warren new <dir_name> [--template <template>]")
      }
    _ => ()
  }
}

///|
async fn main {
  run_cli()
}

///|
fn inject_preview_assets(html : String) -> String {
  let html = inject_preview_base(html)
  let patch = preview_assets_for(html)
  inject_assets(html, patch)
}

///|
fn inject_direct_assets(html : String) -> String {
  let html = inject_preview_base(html)
  let patch = preview_assets_for(html) + direct_client_for(html)
  inject_assets(html, patch)
}

///|
fn inject_assets(html : String, patch : String) -> String {
  guard patch != "" else { html }
  let tag = match html.rev_find("</head>") {
    None => html.rev_find("</html>")
    x => x
  }
  match tag {
    Some(p) => (html[:p] + patch + html[p:]).to_owned()
    None => {
      log("warn", "No </head> or </html> tag in index.html")
      if html.has_suffix("\n") {
        html + patch
      } else {
        html + "\n" + patch
      }
    }
  }
}

///|
fn direct_client_for(html : String) -> String {
  if html.contains("/__warren/direct.js") {
    ""
  } else {
    direct_client_patch + "\n"
  }
}

///|
fn inject_preview_base(html : String) -> String {
  guard !html.contains("<base ") else { html }
  let head_end = match html.find("<head>") {
    Some(p) => Some(p + "<head>".length())
    None => None
  }
  match head_end {
    Some(p) => (html[:p] + "\n" + preview_base_patch + html[p:]).to_owned()
    None => preview_base_patch + "\n" + html
  }
}

///|
fn preview_assets_for(html : String) -> String {
  let script = if html.contains("index.js") {
    ""
  } else {
    preview_entry_script_patch + "\n"
  }
  let stylesheet = if html.contains("styles.css") {
    ""
  } else {
    preview_stylesheet_patch + "\n"
  }
  script + stylesheet
}

///|
test "inject_preview_assets puts base before relative assets" {
  let html =
    $|<html>
    $|<head>
    $|    <link rel="stylesheet" type="text/css" href="./styles.css"></link>
    $|    <script src="./index.js" type="module"></script>
    $|</head>
    $|<body></body>
    $|</html>
  inspect(
    inject_preview_assets(html),
    content=(
      $|<html>
      $|<head>
      $|<base href="/">
      $|    <link rel="stylesheet" type="text/css" href="./styles.css"></link>
      $|    <script src="./index.js" type="module"></script>
      $|</head>
      $|<body></body>
      $|</html>
    ),
  )
}

///|
test "CLI accepts global -C and full-stack entry options" {
  let matches = warren_cli().parse(
    argv=[
      "-C", "project", "dev", "--browser-entry", "frontend", "--server-entry", "backend",
      "--server-target", "wasm",
    ],
    env={},
  )
  assert_eq(option_value(matches, "directory"), Some("project"))
  let entries = match matches.subcommand {
    Some(("dev", submatches)) =>
      (
        option_value(submatches, "browser-entry"),
        option_value(submatches, "server-entry"),
        option_value(submatches, "server-target"),
      )
    _ => (None, None, None)
  }
  assert_eq(entries.0, Some("frontend"))
  assert_eq(entries.1, Some("backend"))
  assert_eq(entries.2, Some("wasm"))
}

///|
test "CLI preserves explicitly empty entry options" {
  let matches = warren_cli().parse(
    argv=["dev", "--browser-entry", "", "--server-entry", ""],
    env={},
  )
  let entries = if matches.subcommand is Some(("dev", submatches)) {
    (
      option_value(submatches, "browser-entry"),
      option_value(submatches, "server-entry"),
    )
  } else {
    (None, None)
  }
  assert_eq(entries.0, Some(""))
  assert_eq(entries.1, Some(""))
}

///|
test "--direct implies an empty server entry" {
  let matches = warren_cli().parse(argv=["dev", "--direct"], env={})
  let value = if matches.subcommand is Some(("dev", submatches)) {
    dev_server_entry_value(submatches)
  } else {
    None
  }
  assert_eq(value, Some(""))
}

///|
test "--direct conflicts with a non-empty server entry" {
  let matches = warren_cli().parse(
    argv=["dev", "--direct", "--server-entry", "backend"],
    env={},
  )
  let rejected = try {
    if matches.subcommand is Some(("dev", submatches)) {
      ignore(dev_server_entry_value(submatches))
    }
    false
  } catch {
    Failure(_) => true
    _ => false
  } noraise {
    _ => false
  }
  assert_true(rejected)
}
