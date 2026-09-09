# End-to-end tests

The Playwright suite starts dedicated MoonBit applications under `apps/` with
Warren and tests them in Chromium. These fixtures belong to the test suite and
do not depend on applications under `examples/`.

Each application uses Warren's minimized root-package layout. The fixtures are:

- `apps/counter` on port `4300`
- `apps/state-and-messages` on port `4301`
- `apps/forms-and-events` on port `4302`
- `apps/collections-lifecycle` on port `4303`
- `apps/navigation-history` on port `4304`
- `apps/commands-and-async` on port `4305`
- `apps/http` on port `4306`
- `apps/subscriptions` on port `4307`
- `apps/dom-api` on port `4308`
- `apps/rui` on port `4309`
- `apps/memo` on port `4310`

The suite covers stable public behavior: state and message composition, forms
and DOM events, incremental collection lifecycles, same-origin navigation,
commands and asynchronous work, mocked HTTP, and subscription lifecycles. It
also exercises the public DOM bindings against real browser objects. It does
not assert ordering for batched or nested messages.

`apps/memo` verifies memo compute counts, independent caches, custom hashes,
event updates, and transitions between ordinary, fragment, and nested memo
nodes, including removal and remounting. It also covers keyed fragment moves,
empty fragment boundaries, and independent invalidation of nested memo caches. Run it with
`npm test -- --project=memo-chromium`.
Its components use `create_variable` for state and expose MoonBit render counters
through DOM snapshots. Each snapshot has a reading number so tests wait for a
fresh result without accessing JavaScript globals or adding FFI probes.
For manual checks, `Toggle keyed trailing marker` removes the final sibling so
keyed fragments can also move directly to the end of their container.

`apps/rui` is a single-page showcase of the RUI (`Yoorkin/rui`) component
library. One Playwright project drives it and the `rui.*.spec.ts` files cover
representative user-visible behavior per component: disclosure open/close,
keyboard navigation, pointer selection, ARIA roles and states, and Escape or
outside-press dismissal for floating layers.

## Prerequisites

- Node.js 22 or newer
- MoonBit
- Warren installed from this checkout. Run this from the repository root:

  ```sh
  moon install ./warren
  ```

## Setup

From the `e2e` directory:

```sh
npm ci
npx playwright install chromium
```

## Run

```sh
npm test
```

Playwright starts each application on its configured port. During local
development it reuses servers already listening at those addresses.

Additional commands:

```sh
npm run test:headed
npm run test:ui
npm run report
```

Tests should prefer accessible roles, labels, and visible text. Add a
`data-testid` only when the user-facing semantics cannot provide a stable
locator.

Keep tests deterministic. Mock HTTP with Playwright routes, use the Playwright
clock for timers, and rely on retrying assertions or event-driven barriers
instead of fixed sleeps.

## Add an application

1. Create a minimized Warren application under `apps/<name>`.
2. Add it to the repository workspace with `moon work use e2e/apps/<name>`.
3. Add its name and a unique port to `apps` in `playwright.config.ts`.
4. Add `tests/<name>.spec.ts`; the matching Playwright project will run it.
