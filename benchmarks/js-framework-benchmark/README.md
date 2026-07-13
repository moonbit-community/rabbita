# Rabbita js-framework-benchmark

This is a keyed implementation of
[js-framework-benchmark](https://github.com/krausest/js-framework-benchmark).
It deliberately uses Rabbita's incremental graph and `@html.lazy` together:

- the row collection and selected row are separate `Val`s;
- one `Val::map2` combines the row collection with selected state, avoiding
  per-row incremental graph allocation in the 10,000-row create benchmark;
- each keyed row is wrapped in `@html.lazy` with a hash containing every
  rendered input (`view_version` and selected state), analogous to a memoized
  row component;
- the `tbody` receives a keyed `Map[String, Html]`, so remove and swap retain
  DOM identity.

Build from this directory:

```sh
npm install
npm run build-prod
```

For an upstream validation run after `@html.lazy` is available in a published
Rabbita release, copy this directory to `frameworks/keyed/rabbita` in a
js-framework-benchmark checkout and run:

```sh
npm run rebuild-ci keyed/rabbita
```

For the current development version, build this module from the Rabbita
workspace first so Moon resolves the local framework source. Then expose this
directory (including the generated `dist/main.js`) as
`frameworks/keyed/rabbita`, start the upstream server, and run its checks:

```sh
cd webdriver-ts
npm run isKeyed -- --headless --framework keyed/rabbita
npm run bench -- --headless --framework keyed/rabbita --count 1
```

Do not commit generated upstream result or trace files.
