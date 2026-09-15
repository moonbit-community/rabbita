# __WARREN_PROJECT_NAME__

Start the app with live reload:

```sh
warren dev --server-target native
```

Build the frontend and server into `dist/`:

```sh
warren build --server-target native
```

Build a single executable containing the frontend and all `public/` files:

```sh
warren build --bundle
```

Run the executable emitted in `dist/`. The server defaults to
`http://127.0.0.1:4300/`; `WARREN_HOST` and `WARREN_PORT` override its address.
The example API is available at `/api/hello`.

Edit `cmd/browser/main.mbt` for the frontend and `cmd/server/main.mbt` for
server routes. The resource integration is already wired up; no extra bundle
setup is needed. Keep `cmd/server/warren_assets.mbt` in version control.

Direct `moon build --target native` also works. To serve frontend files when
running the server from Moon's build directory, set `WARREN_DIST` to a directory
containing the built frontend. Warren sets this automatically in development.
