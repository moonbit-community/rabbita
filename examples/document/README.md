# Document

A full-stack Rabbita example. The component in `app/` renders the whole
document — `<html>`, `<head>`, `<title>` included — so the same tree is
server-rendered by the native server and hydrated in the browser.

- `app/` — the shared component, built for every target
- `main/` — the browser entry, hydrates the server-rendered document
- `cmd/server/` — the server entry, a [MoonBack][moonback] app assembled by
  `@rabbita/server`

`cmd/server` registers a single `/issues` route as a `@moonback.Module`;
`@rabbita/server` adds the server-rendered page and serves the browser bundle.
`create_resource` fetches `/issues` during SSR, so the list is already in the
response document instead of being requested again after hydration.

## Run in development

In this directory:

```sh
moon install moonbit-community/warren
warren dev --browser-entry main --server-target native
```

Then open the local URL shown by warren. Warren rebuilds the browser bundle and
reloads the page on change, and passes the port and static directory to the
server through `WARREN_PORT` and `WARREN_DIST`.

## Run the native server

Build the browser bundle first, then start the server:

```sh
warren build --browser-entry main --server-entry "" --dist dist
moon run --target native cmd/server
```

The server listens on <http://127.0.0.1:3002>.

[moonback]: https://mooncakes.io/docs/hackwaly/moonback
