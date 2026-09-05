///|
using @devhub {type Devhub}

///|
struct ArtifactDigest {
  hash : Int
  length : Int
} derive(Eq)

///|
struct RunningServer {
  process : @process.Process
  digest : ArtifactDigest
}

///|
async fn artifact_digest(path : SourcePath) -> ArtifactDigest {
  let bytes = @fs.read_file(source_path_to_string(path)).binary()
  { hash: bytes.hash(), length: bytes.length(), }
}

///|
fn ArtifactDigest::directory_name(self : ArtifactDigest) -> String {
  "\{self.hash}-\{self.length}"
}

///|
fn server_needs_restart(
  previous : ArtifactDigest?,
  previous_running : Bool,
  next : ArtifactDigest,
) -> Bool {
  match previous {
    None => true
    Some(previous) => previous != next || !previous_running
  }
}

///|
fn wasm_server_args(
  project_root : SourcePath,
  server_entry : SourcePath,
) -> Array[String] {
  ["run", "--target", "wasm", moon_entry(project_root, server_entry)]
}

///|
fn mount_browser_pages(
  vfs : @vfs.VirtualFileSystem,
  app_html : String,
  direct : Bool,
) -> Unit {
  if direct {
    vfs.mount("/index.html", FileContent(inject_direct_assets(app_html)))
    vfs.mount("/__warren/direct.js", FileContent(direct_client_js))
  } else {
    vfs.mount(
      "/__warren/preview/index.html",
      FileContent(inject_preview_assets(app_html)),
    )
    vfs.mount("/index.html", FileContent(shell_html_template))
    vfs.mount("/warren_devtool.js", FileContent(embbed_devtool_js))
    vfs.mount("/warren_devtool.css", FileContent(embbed_devtool_css))
  }
}

///|
async fn publish_browser_static(
  vfs : @vfs.VirtualFileSystem,
  static_dir : SourcePath,
  direct : Bool,
) -> Unit {
  vfs.mount("/", DirectoryMapping(static_dir))
  let index = static_dir.join("index.html")
  let app_html = if @fs.exists(source_path_to_string(index)) {
    @fs.read_file(source_path_to_string(index)).text()
  } else {
    app_html_template
  }
  mount_browser_pages(vfs, app_html, direct)
}

///|
async fn browser_dev(
  layout : ProjectLayout,
  temp : SourcePath,
  port : UInt,
  direct : Bool,
) -> Unit {
  let root = source_path_to_string(layout.root)
  let temp_relative = temp.relative(layout.root)
  let watcher = @fs.Watcher(root, ignored_paths=path => {
    ignored_watch_path_with_temp(path, temp_relative)
  })
  defer watcher.close()
  let vfs = @vfs.new(Map([]))
  mount_browser_pages(vfs, app_html_template, direct)
  let mut next_static = temp.join("static")
  let mut standby_static = temp.join("static-next")
  @async.with_task_group <| group => {
    let html_fallback_path = if direct { Some("/index.html") } else { None }
    let hub = Devhub(port, vfs, html_fallback_path?)
    group.spawn_bg(no_wait=true, allow_failure=true, () => hub.run_forever())
    log("info", "Running server on http://127.0.0.1:\{hub.port()}")
    while true {
      hub.broadcast(Building)
      log("warren", "Building browser entry...")
      try {
        let browser_artifact = run_build_only(
          layout.root,
          layout.browser_entry,
          "js",
          false,
        )
        assemble_static(
          layout.root,
          layout.public_dir,
          browser_artifact,
          next_static,
          false,
        )
        publish_browser_static(vfs, next_static, direct)
      } catch {
        error if @async.is_being_cancelled() => raise error
        error => {
          let diagnostics = match error {
            Failure(message) => message
            error => "\{error}"
          }
          hub.broadcast(BuildFailed(diagnostics))
          log("error", diagnostics)
        }
      } noraise {
        _ => {
          let old_active = next_static
          next_static = standby_static
          standby_static = old_active
          hub.broadcast(Reload)
          log("warren", "Changes detected. Reloading...")
        }
      }
      watcher.wait_any()
    }
  }
}

///|
fn process_is_running(process : @process.Process) -> Bool {
  try process.try_wait() catch {
    _ => false
  } noraise {
    None => true
    Some(_) => false
  }
}

///|
async fn stop_server(server : RunningServer?) -> Unit {
  if server is Some(server) {
    if process_is_running(server.process) {
      // `Process::cancel()` cancels its monitoring task, so a following
      // `wait()` raises `Cancelled` even after the child has terminated.
      // Run the same graceful handler separately and keep waiting for the OS
      // process; once it exits, this group cancels the pending forced kill.
      @async.with_task_group <| group => {
        group.spawn_bg(no_wait=true, () => {
          @process.graceful_cancel(timeout=5000)(server.process.pid)
        })
        ignore(server.process.wait())
      }
    } else {
      ignore(server.process.wait())
    }
  }
}

///|
async fn stage_native_server(
  artifact : SourcePath,
  run_dir : SourcePath,
  digest : ArtifactDigest,
) -> SourcePath {
  let directory = run_dir.join(digest.directory_name())
  if !@fs.exists(source_path_to_string(directory)) {
    @fs.mkdir(
      source_path_to_string(directory),
      permission=0o755,
      recursive=true,
    )
  }
  let basename = Path::basename(source_path_to_string(artifact)).to_owned()
  let executable = directory.join(basename)
  if !@fs.exists(source_path_to_string(executable)) {
    copy(src=artifact, dst=executable)
    chmod_executable(executable)
  }
  executable
}

///|
fn dev_server_environment(
  static_dir : SourcePath,
  port : UInt,
  client : String,
) -> Map[String, String] {
  {
    "WARREN_MODE": "DEV",
    "WARREN_PORT": "\{port}",
    "WARREN_CLIENT": client,
    "WARREN_DIST": source_path_to_string(static_dir),
  }
}

///|
async fn start_server(
  group : @async.TaskGroup[Unit],
  layout : ProjectLayout,
  target : ServerTarget,
  run_dir : SourcePath,
  artifact : SourcePath,
  digest : ArtifactDigest,
  static_dir : SourcePath,
  port : UInt,
  dev_client : String,
) -> @process.Process {
  let environment = dev_server_environment(static_dir, port, dev_client)
  match target {
    Native => {
      let executable = stage_native_server(artifact, run_dir, digest)
      log("server", "Starting \{executable} with WARREN_PORT=\{port}")
      @process.spawn(
        group,
        source_path_to_string(executable),
        [],
        cwd=source_path_to_string(layout.root),
        extra_env=environment,
        inherit_env=true,
        cancel_handler=@process.graceful_cancel(timeout=5000),
        no_wait=true,
      )
    }
    Wasm => {
      let server_entry = match layout.server_entry {
        Some(entry) => entry
        None => fail("Cannot start a wasm server without a server entry.")
      }
      let args = wasm_server_args(layout.root, server_entry)
      log("server", "Running `moon \{args.join(" ")}` with WARREN_PORT=\{port}")
      @process.spawn(
        group,
        "moon",
        args,
        cwd=source_path_to_string(layout.root),
        extra_env=environment,
        inherit_env=true,
        cancel_handler=@process.graceful_cancel(timeout=5000),
        no_wait=true,
      )
    }
  }
}

///|
async fn fullstack_dev(
  layout : ProjectLayout,
  server_entry : SourcePath,
  target : ServerTarget,
  temp : SourcePath,
  port : UInt,
) -> Unit {
  let root = source_path_to_string(layout.root)
  let static_dir = temp.join("static")
  let run_dir = temp.join("run")
  let temp_relative = temp.relative(layout.root)
  let watcher = @fs.Watcher(root, ignored_paths=path => {
    ignored_watch_path_with_temp(path, temp_relative)
  })
  defer watcher.close()
  @async.with_task_group <| group => {
    let hub = Devhub(
      0U,
      @vfs.new({ "/__warren/client.js": FileContent(fullstack_client_js) }),
    )
    group.spawn_bg(no_wait=true, allow_failure=true, () => hub.run_forever())
    let events_port = hub.port()
    let dev_client = "http://127.0.0.1:\{events_port}/__warren/client.js"
    let mut running : RunningServer? = None
    while true {
      hub.broadcast(Building)
      log("warren", "Building browser entry...")
      let browser_artifact = run_build_only(
        layout.root,
        layout.browser_entry,
        "js",
        false,
      )
      assemble_static(
        layout.root,
        layout.public_dir,
        browser_artifact,
        static_dir,
        false,
      )
      log("warren", "Building server entry...")
      let server_artifact = run_build_only(
        layout.root,
        server_entry,
        target.moon_target(),
        false,
      )
      let digest = artifact_digest(server_artifact)
      let (previous_digest, previous_running) = match running {
        None => (None, false)
        Some(server) =>
          (Some(server.digest), process_is_running(server.process))
      }
      let restart = server_needs_restart(
        previous_digest, previous_running, digest,
      )
      if restart {
        stop_server(running)
        let process = start_server(
          group, layout, target, run_dir, server_artifact, digest, static_dir, port,
          dev_client,
        )
        running = Some({ process, digest, })
      } else {
        log(
          "server", "Server artifact is unchanged; keeping the server running.",
        )
      }
      hub.broadcast(Reload)
      log("warren", "Changes detected. Reloading browser resources...")
      watcher.wait_any()
    }
  }
}

///|
async fn dev_project(
  layout : ProjectLayout,
  server_target : ServerTarget,
  port : UInt,
  direct : Bool,
) -> Unit {
  let temp = SourcePath::new(@fs.tmpdir(prefix="warren-dev"))
  match layout.server_entry {
    None => browser_dev(layout, temp, port, direct)
    Some(server_entry) =>
      fullstack_dev(layout, server_entry, server_target, temp, port)
  }
}

///|
test "server restart depends on digest and process state" {
  let digest : ArtifactDigest = { hash: 42, length: 10, }
  inspect(server_needs_restart(None, false, digest), content="true")
  inspect(server_needs_restart(Some(digest), true, digest), content="false")
  inspect(server_needs_restart(Some(digest), false, digest), content="true")
  inspect(
    server_needs_restart(Some(digest), true, { hash: 43, length: 10, }),
    content="true",
  )
}

///|
test "fullstack server receives the Warren development environment" {
  let static_dir = SourcePath::new("static")
  let client = "http://127.0.0.1:43123/__warren/client.js"
  let environment = dev_server_environment(static_dir, 4300U, client)
  assert_eq(environment.length(), 4)
  assert_eq(environment.get("WARREN_MODE"), Some("DEV"))
  assert_eq(environment.get("WARREN_PORT"), Some("4300"))
  assert_eq(environment.get("WARREN_CLIENT"), Some(client))
  assert_eq(
    environment.get("WARREN_DIST"),
    Some(source_path_to_string(static_dir)),
  )
}

///|
test "wasm server is launched through moon run" {
  let root = SourcePath::new("test-project")
  let args = wasm_server_args(root, root.join("cmd/server"))
  inspect(args.length(), content="4")
  inspect(args[0], content="run")
  inspect(args[2], content="wasm")
  inspect(args.contains("--target-dir"), content="false")
  inspect(args[3] == "cmd/server" || args[3] == "cmd\\server", content="true")
}
