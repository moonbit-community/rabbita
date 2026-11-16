///|
async fn write_bundle_fixture(
  root : SourcePath,
  files : Map[String, String],
) -> Unit {
  for name, source in files {
    let file = root.join(name)
    @fs.mkdir(
      Path::dirname(file.to_string()).to_string(),
      permission=0o755,
      recursive=true,
      allow_exist=true,
    )
    @fs.write_file(
      file.to_string(),
      source,
      create_mode=CreateOrTruncate,
      permission=0o644,
    )
  }
}

///|
async fn run_bundle_fixture(artifact : SourcePath, cwd : SourcePath) -> String {
  let (code, stdout, stderr) = @process.collect_output(
    artifact.to_string(),
    [],
    cwd=cwd.to_string(),
    inherit_env=true,
  )
  guard code == 0 else { fail(stderr.text()) }
  stdout.text().trim().to_owned()
}

///|
async test "bundle preserves package identity and local build context" {
  for workspace in [true, false] {
    let fixture_string = @fs.tmpdir(prefix="warren-bundle-test")
    let fixture = SourcePath::new(@fs.realpath(fixture_string))
    defer @fs.rmdir(fixture.to_string(), recursive=true)
    let project = fixture.join("project")
    let app = project.join("app")
    let stub = "fn warren_assets() -> Map[String, Bytes] { {} }\n"
    let manifest =
      #|import { "example/app/cmd/server/internal/helper", }
      #|pkgtype(kind: "executable")
      #|options("native-stub": ["stub.c"])
    write_bundle_fixture(fixture, {
      "shared/moon.mod": "name = \"example/shared\"\nversion = \"0.1.0\"\n",
      "shared/moon.pkg": "",
      "shared/shared.mbt": "pub fn ready() -> Bool { true }\n",
      "project/app/src/cmd/browser/moon.pkg": "pkgtype(kind: \"executable\")\n",
      "project/app/src/cmd/browser/main.mbt": "fn main { println(\"browser\") }\n",
      "project/app/src/cmd/server/moon.pkg": manifest,
      "project/app/src/cmd/server/warren_assets.mbt": stub,
      "project/app/src/cmd/server/main.mbt": (
        #|extern "C" fn native_ready() -> Bool = "bundle_native_ready"
        #|fn main {
        #|  println(if @helper.ready() && native_ready() &&
        #|    warren_assets().contains("/index.js") &&
        #|    warren_assets().get("/asset.txt") == Some(b"bundled") {
        #|    "bundled"
        #|  } else {
        #|    "plain"
        #|  })
        #|}
      ),
      "project/app/src/cmd/server/internal/helper/moon.pkg": if workspace {
        "import { \"example/shared\", }"
      } else {
        ""
      },
      "project/app/src/cmd/server/internal/helper/helper.mbt": if workspace {
        "pub fn ready() -> Bool { @shared.ready() }"
      } else {
        "pub fn ready() -> Bool { true }"
      },
      "project/app/src/cmd/server/stub.c": (
        #|#include "../../../../native/marker.h"
      ),
      "project/native/marker.h": (
        #|#include <stdint.h>
        #|int32_t bundle_native_ready(void) { return 1; }
      ),
      "project/app/public/asset.txt": "bundled",
    })
    let workspace_source =
      $|// Workspace 📦
      $|members = [\{SourcePath::new(fixture_string).join("project/app").to_string().escape()}, "../shared"]
      $|preferred_target = "native"
    if workspace {
      write_bundle_fixture(project, {
        "moon.work": workspace_source,
        "app/moon.mod": (
          #|name = "example/app"
          #|version = "0.1.0"
          #|source = "src"
          #|import { "example/shared@0.1.0", }
        ),
      })
    } else {
      write_bundle_fixture(app, {
        "moon.mod": (
          #|name = "example/app"
          #|version = "0.1.0"
          #|source = "src"
        ),
      })
    }
    let entry = app.join("src/cmd/server")
    let layout : ProjectLayout = {
      root: app,
      browser_entry: app.join("src/cmd/browser"),
      server_entry: Some(entry),
      public_dir: Some(app.join("public")),
    }
    let original = run_build_only(app, entry, "native", true)
    @test.assert_eq(run_bundle_fixture(original, fixture), "plain")
    let dist = app.join("output")
    let parent = if workspace { fixture } else { project }
    let neighbors = @fs.readdir(
      parent.to_string(),
      include_hidden=true,
      sort=true,
    )
    build_bundle(layout, Native, dist)
    let name = Path::basename(original.to_string()).to_owned()
    let executable = dist.join(name)
    @test.assert_eq(@fs.readdir(dist.to_string()), [name])
    @test.assert_eq(run_bundle_fixture(executable, fixture), "bundled")
    @test.assert_eq(
      @fs.read_file(entry.join("warren_assets.mbt").to_string()).text(),
      stub,
    )
    @test.assert_eq(
      @fs.read_file(entry.join("moon.pkg").to_string()).text(),
      manifest,
    )
    if workspace {
      @test.assert_eq(
        @fs.read_file(project.join("moon.work").to_string()).text(),
        workspace_source,
      )
    }
    @test.assert_eq(
      @fs.readdir(parent.to_string(), include_hidden=true, sort=true),
      neighbors,
    )
    let previous = @fs.read_file(executable.to_string()).binary()
    write_bundle_fixture(entry, { "main.mbt": "not valid MoonBit" })
    @test.assert_raise_async(() => build_bundle(layout, Native, dist))
    @test.assert_eq(@fs.read_file(executable.to_string()).binary(), previous)
    @test.assert_eq(
      @fs.read_file(entry.join("warren_assets.mbt").to_string()).text(),
      stub,
    )
    @test.assert_eq(
      @fs.readdir(parent.to_string(), include_hidden=true, sort=true),
      neighbors,
    )
  }
}

///|
#cfg(not(platform="windows"))
async test "bundle snapshot keeps links outside the entry isolated" {
  let fixture = SourcePath::new(
    @fs.realpath(@fs.tmpdir(prefix="warren-bundle-links")),
  )
  defer @fs.rmdir(fixture.to_string(), recursive=true)
  let root = fixture.join("project")
  let staging = fixture.join("snapshot")
  let entry = root.join("cmd/server")
  write_bundle_fixture(root, {
    "cmd/server/warren_assets.mbt": "stub",
    "text": "original",
    "output/previous": "previous bundle",
    "_build/generated": "build cache",
  })
  @fs.symlink(
    target=root.join("text").to_string(),
    root.join("README").to_string(),
  )
  @fs.symlink(target=root.to_string(), root.join("loop").to_string())
  @fs.mkdir(staging.to_string(), permission=0o700)
  stage_bundle_project(root, staging, entry, root.join("output"))
  @test.assert_eq(
    @fs.realpath(staging.join("README").to_string()),
    staging.join("text").to_string(),
  )
  @test.assert_eq(
    @fs.realpath(staging.join("loop").to_string()),
    staging.to_string(),
  )
  assert_false(@fs.exists(staging.join("output").to_string()))
  assert_false(@fs.exists(staging.join("_build").to_string()))
  write_bundle_fixture(staging, { "text": "snapshot" })
  @test.assert_eq(
    @fs.read_file(root.join("text").to_string()).text(),
    "original",
  )
  @fs.rmdir(staging.to_string(), recursive=true)
  @test.assert_eq(
    @fs.read_file(root.join("text").to_string()).text(),
    "original",
  )
  @fs.symlink(
    target=root.join("text").to_string(),
    entry.join("link").to_string(),
  )
  @fs.mkdir(staging.to_string(), permission=0o700)
  @test.assert_raise_async(() => {
    stage_bundle_project(root, staging, entry, root.join("output"))
  })
}
