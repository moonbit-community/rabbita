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
