# Rabbita Playground

MoonBit + Rabbita playground, served by Warren.

## Dev

Install `warren` once:

```sh
moon install moonbit-community/warren
```

```sh
cd website/playground
export MOONBIT_PLAYGROUND_CORE_BUNDLE="$HOME/.moon/lib/core/_build/js/release/bundle"

moon run --target native scripts/assets.mbtx
warren dev --browser-entry main --public-dir public --port 4300
```

Open: `http://127.0.0.1:4300`

## Build

```sh
cd website/playground
export MOONBIT_PLAYGROUND_CORE_BUNDLE="$HOME/.moon/lib/core/_build/js/release/bundle"

moon run --target native scripts/assets.mbtx
warren build --browser-entry main --dist dist
```

Only CI/release build writes `dist/`. `MOON_BIN` can override `moon`.
