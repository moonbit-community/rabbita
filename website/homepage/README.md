# Rabbita website

Built with MoonBit, Rabbita, and Warren.

## Setup

```sh
moon update
moon install moonbit-community/warren
```

## Dev

```sh
moon run --target native scripts/assets.mbtx
warren dev --browser-entry main --public-dir public
```

The component showcase is served by the same application at `/components/`.

## Build

```sh
moon run --target native scripts/assets.mbtx
warren build --browser-entry main --dist dist
```
