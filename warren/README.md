# warren

`warren` previews and builds browser-only or full-stack MoonBit applications.

## Install

```sh
moon install moonbit-community/warren
```

## Project entries

Warren uses package directories as entries and does not inspect `moon.mod`,
`moon.pkg`, or `moon.work` contents:

- `cmd/browser` is the default browser entry and is always built for `js`.
- `cmd/server` is the optional server entry and is built for `wasm` by default,
  or `native` with `--server-target native`.

Override either convention when needed:

```sh
warren dev --browser-entry frontend --server-entry backend
warren build --browser-entry frontend --server-entry backend
```

Standalone `.mbtx` files can also be used as browser entries:

```sh
warren dev page.mbtx
warren build page.mbtx
```

Pass an empty server entry to ignore an existing `cmd/server` and select the
browser-only workflow. The browser entry cannot be empty.

```sh
warren dev --server-entry ""
warren build --server-entry ""
```

The browser entry is required. If no server entry exists, `warren dev` starts
the built-in development server with its diagnostics, live reload, and optional
`--direct` mode. If a server entry exists, Warren starts that program instead,
sets `WARREN_DIST` to the absolute static directory and `WARREN_PORT` to the
selected port, and leaves HTTP/static serving to the program. In `warren dev`,
`--direct` implies `--server-entry ""` and therefore uses the built-in server.
Warren also sets `WARREN_CLIENT` to an external reload script served by its
development hub. Rabbita SSR applications can inject this script through
`moonbit-community/rabbita/server/plugin`, without depending on a particular
HTTP server library. `WARREN_MODE` is set to `DEV`.
Successful browser rebuilds replace the assets in `WARREN_DIST` and reload
connected pages without modifying `index.js` or restarting an unchanged server.

Use `-C` (or `--directory`) with every subcommand to choose the project root:

```sh
warren -C path/to/project dev
warren build -C path/to/project
warren -C path/to/parent new my-app
```

Entry, public, and output paths must stay inside that project root. Build output
must be a safe child directory and cannot overlap an entry or the public
directory. The minimized template's root browser entry is the one exception:
its `dist/` child is safe because Warren deletes only that child.

## Development

```sh
warren dev
warren dev --public-dir shared/public --port 4301
warren dev --server-target native
```

`public/` is used automatically when it exists. Warren watches the whole
project root and ignores `.git`, `_build`, `.mooncakes`, every directory named
`dist`, and its own temporary build directory.

Browser-only build failures are reported in the development UI while the last
successful static output remains available. In full-stack mode, a build failure
stops the server and exits Warren. A native server is restarted only when its
artifact changes or the previous process has exited.

## Release build

```sh
warren build
warren build --public-dir shared/public --dist output
warren build --server-target native
```

The default output directory is `dist/`. Warren clears it at the start, copies
public files, writes the browser artifact as `index.js`, creates or updates
`index.html`, and copies an optional server artifact under its original
basename. Browser and server builds run serially in release mode, reuse Moon's
default build cache, and locate artifacts only from the `--build-only` JSON
result without inspecting `_build`. After a wasm server build, Warren prints the
command for starting the copied artifact, for example:

```sh
cd /absolute/path/to/dist && moon run server.wasm
```

## Single-executable bundles

```sh
warren build --bundle
warren build page.mbtx --bundle
warren build --bundle --browser-entry main --dist output
```

`--bundle` selects a native release build. An explicit `--server-target wasm`
is rejected. The build embeds the final `index.js`, `index.html`, and every
file in `public/`, including nested and hidden files, CSS, images, and fonts.
Only the executable is placed in `dist/`; it can serve these resources from
any working directory without Warren, Moon, or a separate static directory.
This packages static resources, not external libraries or other runtime data
used by application code. Native executables target the build machine's OS
and architecture.

Files are encoded as MoonBit byte constants and served directly from
memory. Large files use multiline `Bytes` literals to stay within compiler
source-line limits without allocating and rebuilding their contents at startup.
Their original bytes are preserved; resources are neither base64-encoded nor
extracted at startup. The HTML still loads `/index.js` through its normal
script URL. Symlinks and special files in bundle inputs are rejected.

For a browser-only project (including `.mbtx`), Warren generates a small
static HTTP server using Moonback 0.8.3's `from_assets()` middleware.
It defaults to `127.0.0.1:4300`; use `WARREN_HOST` and `WARREN_PORT` to configure
it at runtime. It supports GET/HEAD, MIME types, and directory `index.html`
pages. Unknown paths return 404; there is no automatic SPA history fallback.

### Existing server entries

An existing server keeps its startup logic, port configuration, SSR, and API
routes. Add `warren_assets.mbt` to the server entry package and commit this
empty implementation:

```moonbit
///|
fn warren_assets() -> Map[String, Bytes] {
  {}
}
```

Pass its result to the new `assets` parameter of `rabbita/server.Server`:

```moonbit
let server = @rabbita_server.Server(
  api~,
  port=3000,
  dist=@path.Path("./dist"),
  assets=warren_assets(),
  component?,
)
```

`examples/document/cmd/server` demonstrates this integration:

```sh
warren -C examples/document build --browser-entry main --bundle
```

In production a non-empty asset map replaces disk static serving. An empty
map preserves the ordinary `dist` behavior. In development the server uses
Warren's live files. A supplied SSR `component` still owns `/`; embedded
`/index.html` remains accessible directly. Static assets take precedence over
matching application routes; missing assets fall through to the application.

Other HTTP frameworks can consume the same `Map[String, Bytes]`, whose keys
are absolute URL paths such as `/index.js`. The server must actually use this
map; Warren cannot automatically integrate arbitrary request handlers.

Moonback applications can pass the map directly to
`@static.from_assets(warren_assets(), rewrite_trailing_slash_index=true)`
from `moonbitlang/moonback/middlewares/unstable_static` (Moonback 0.8.3 or later).
Rabbita's `Server(assets=...)` uses this middleware internally.

Warren compiles a temporary sibling copy of the server entry with a generated
`warren_assets.mbt`. It does not edit the original stub or package manifest.
Imports retain their module/workspace context; entry-local files and relative
references to neighboring files are preserved. Custom build rules that
hard-code the original entry's package path need to accommodate the copied
entry. The temporary source is cleaned up on success and failure. Browser
and server compilation finish before the previous `dist/` is replaced, so a
compilation failure retains the previous bundle.

## New project

The bundled templates predate the `cmd/browser` convention, so their entry is
explicit:

```sh
warren new my-app
cd my-app
warren dev --browser-entry main
```

For the minimized root-package template:

```sh
warren new tiny-app --template minimized
cd tiny-app
warren dev --browser-entry .
```

## Help

```sh
warren --help
warren new --help
warren dev --help
warren build --help
```
