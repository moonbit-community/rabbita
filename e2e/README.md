# End-to-end tests

The Playwright suite starts dedicated MoonBit applications under `apps/` with
Warren and tests them in Chromium. These fixtures belong to the test suite and
do not depend on applications under `examples/`.

The non-RUI applications use Warren's minimized root-package layout:

- `apps/counter` on port `4300`
- `apps/state-and-messages` on port `4301`
- `apps/forms-and-events` on port `4302`
- `apps/collections-lifecycle` on port `4303`
- `apps/navigation-history` on port `4304`
- `apps/commands-and-async` on port `4305`
- `apps/http` on port `4306`
- `apps/subscriptions` on port `4307`
- `apps/dom-api` on port `4308`
- `apps/memo` on port `4310`

The suite covers stable public behavior: state and message composition, forms
and DOM events, incremental collection lifecycles, same-origin navigation,
commands and asynchronous work, mocked HTTP, and subscription lifecycles. It
also exercises the public DOM bindings against real browser objects. It does
not assert ordering for batched or nested messages.

`apps/forms-and-events` also covers omitted DOM properties: native boolean state,
input/textarea/select values, and custom properties follow Elm's empty-string/null
reset convention. The tests verify node reuse, explicit updates, re-adding
properties, and preservation of user edits while a property remains omitted.

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

RUI fixtures share the module `apps/rui`, with one executable package per spec:
`tests/rui.<name>.spec.ts` runs against `apps/rui/<name>` in project
`rui-<name>-chromium`. Each component fixture is served at `/`; only `routing`
keeps multiple routes for navigation and history tests.

Within each app, organize files by component. Keep a component's state, update
logic, and rendering in the same file. `main.mbt` only assembles components and
starts the application.

Ports follow the alphabetical `ruiFixtures` list in `playwright.config.ts`:

| Fixture | Port | Coverage |
| --- | --- | --- |
| `calendar` | 4320 | Single, range, and multiple calendars; date pickers |
| `carousel` | 4321 | Slides, looping, keyboard navigation, and swipes |
| `command` | 4322 | Filtering, selection, empty states, and command dialogs |
| `context-menu` | 4323 | Right-click menus, checked items, and submenus |
| `controls` | 4324 | Checkboxes, switches, toggles, and toggle groups |
| `data-table` | 4325 | Filtering, sorting, pagination, selection, and columns |
| `dialogs` | 4326 | Modal, non-modal, and alert dialogs; sheets |
| `disclosure` | 4327 | Accordions, collapsibles, and tabs |
| `drawer` | 4328 | Opening, focus trapping, and dismissal |
| `forms` | 4329 | Field semantics, controlled input, submit, native select, and OTP |
| `interaction-extended` | 4330 | Multiple combobox selection and multi-thumb sliders |
| `layout-extended` | 4331 | Three-panel resizing and managed scroll areas |
| `menu` | 4332 | Dropdowns, menubars, pointer highlights, and keyboard focus |
| `message-scroller` | 4333 | Scroll-edge tracking and jump controls |
| `navigation-menu` | 4334 | Hover switching, keyboard navigation, and viewport content |
| `popover` | 4335 | Opening and button, Escape, or outside-press dismissal |
| `radio` | 4336 | Single selection and keyboard navigation |
| `resizable` | 4337 | Range semantics, keyboard resizing, and size limits |
| `routing` | 4338 | SPA navigation, history, and not-found routes |
| `select-combobox` | 4339 | Selection, filtering, typeahead, and keyboard navigation |
| `semantic-components` | 4340 | Accessible roles, compound structure, and display semantics |
| `sidebar` | 4341 | Collapse, tooltips, rail resizing, and mobile sheets |
| `slider` | 4342 | Native range values, keyboard steps, and limits |
| `toast` | 4343 | Timers, hover pause, swipe dismissal, and queue limits |
| `tooltip` | 4344 | Pointer and keyboard tooltips; hover cards |

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

Run one RUI fixture, or start its Playwright UI in a browser:

```sh
npm test -- --project=rui-menu-chromium
npm run test:ui -- --project=rui-menu-chromium --ui-host=127.0.0.1 --ui-port=9323
```

Open `http://127.0.0.1:9323` for the UI.

Without a saved selection, the UI selects the first project. Use the Projects
filter to select other fixtures or all projects. Run tests with the arrow beside
a test or `Run all`; the preview's play button replays an existing trace.

To serve the menu fixture manually:

```sh
warren -C ./apps/rui dev --browser-entry ./menu --direct --port 4332
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
3. Add its name and a unique port to `mainApps` in `playwright.config.ts`.
4. Add `tests/<name>.spec.ts`; the matching Playwright project will run it.

For an RUI fixture, add `apps/rui/<name>` inside the existing module,
`tests/rui.<name>.spec.ts`, and an alphabetically sorted entry in `ruiFixtures`.
Update the fixture table when ports change.
