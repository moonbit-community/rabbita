///|
test "dev and build accept .mbtx entries" {
  let dev = warren_cli().parse(argv=["dev", "page.mbtx"], env={})
  guard dev.subcommand is Some(("dev", dev_matches)) else {
    fail("expected dev subcommand")
  }
  assert_eq(option_value(dev_matches, "mbtx"), Some("page.mbtx"))
  let build = warren_cli().parse(argv=["build", "page.mbtx"], env={})
  guard build.subcommand is Some(("build", build_matches)) else {
    fail("expected build subcommand")
  }
  assert_eq(option_value(build_matches, "mbtx"), Some("page.mbtx"))
}

///|
test ".mbtx entries conflict with package and server options" {
  for
    argv in [
      ["dev", "page.mbtx", "--browser-entry", "frontend"],
      ["dev", "page.mbtx", "--server-entry", "backend"],
      ["build", "page.mbtx", "--server-entry", ""],
      ["build", "page.mbtx", "--server-target", "wasm"],
      ["build", "page.mbtx", "--", "argument"],
    ] {
    let rejected = try warren_cli().parse(argv~, env={}) catch {
      _ => true
    } noraise {
      _ => false
    }
    assert_true(rejected)
  }
}

///|
async test ".mbtx layout is browser-only and keeps public discovery" {
  let root_string = @fs.tmpdir(prefix="warren-mbtx-layout")
  let root = SourcePath::new(@fs.realpath(root_string))
  let page = root.join("page.mbtx")
  @fs.write_file(
    source_path_to_string(page),
    "fn main { println(\"page\") }\n",
    create_mode=CreateOrTruncate,
    permission=0o644,
  )
  @fs.mkdir(
    source_path_to_string(root.join("cmd/server")),
    permission=0o755,
    recursive=true,
  )
  @fs.mkdir(source_path_to_string(root.join("public")), permission=0o755)
  let layout = resolve_mbtx_layout(root, "page.mbtx", None)
  assert_eq(layout.browser_entry, page)
  assert_true(layout.server_entry is None)
  assert_eq(layout.public_dir, Some(root.join("public")))
  @fs.rmdir(root_string, recursive=true)
}

///|
async test ".mbtx entry must be a regular file inside the project root" {
  let root_string = @fs.tmpdir(prefix="warren-mbtx-entry")
  let root = SourcePath::new(@fs.realpath(root_string))
  @fs.mkdir(source_path_to_string(root.join("folder.mbtx")), permission=0o755)
  let outside_string = @fs.tmpdir(prefix="warren-mbtx-outside")
  let outside = Path::join(outside_string, "outside.mbtx").to_string()
  @fs.write_file(
    outside,
    "fn main { println(\"outside\") }\n",
    create_mode=CreateOrTruncate,
    permission=0o644,
  )
  for raw in ["page.mbt", "missing.mbtx", "folder.mbtx", outside] {
    let rejected = try resolve_mbtx_layout(root, raw, None) catch {
      Failure(_) => true
      _ => false
    } noraise {
      _ => false
    }
    assert_true(rejected)
  }
  @fs.rmdir(root_string, recursive=true)
  @fs.rmdir(outside_string, recursive=true)
}

///|
#cfg(not(platform="windows"))
async test ".mbtx symlinks must resolve inside the project root" {
  let root_string = @fs.tmpdir(prefix="warren-mbtx-symlink")
  let root = SourcePath::new(@fs.realpath(root_string))
  let page = root.join("page.mbtx")
  @fs.write_file(
    source_path_to_string(page),
    "fn main { println(\"page\") }\n",
    create_mode=CreateOrTruncate,
    permission=0o644,
  )
  let inside_link = root.join("inside.mbtx")
  @fs.symlink(
    target=source_path_to_string(page),
    source_path_to_string(inside_link),
  )
  assert_eq(resolve_mbtx_layout(root, "inside.mbtx", None).browser_entry, page)
  let outside_string = @fs.tmpdir(prefix="warren-mbtx-symlink-outside")
  let outside = Path::join(outside_string, "outside.mbtx").to_string()
  @fs.write_file(
    outside,
    "fn main { println(\"outside\") }\n",
    create_mode=CreateOrTruncate,
    permission=0o644,
  )
  let outside_link = root.join("outside.mbtx")
  @fs.symlink(target=outside, source_path_to_string(outside_link))
  let rejected = try resolve_mbtx_layout(root, "outside.mbtx", None) catch {
    Failure(_) => true
    _ => false
  } noraise {
    _ => false
  }
  assert_true(rejected)
  @fs.rmdir(root_string, recursive=true)
  @fs.rmdir(outside_string, recursive=true)
}
