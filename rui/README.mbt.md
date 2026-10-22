# RUI (Experimental)

> RUI is experimental. Its API and component behavior may change before a
> stable release.

RUI (`moonbit-community/rui`) is a native component library for
[Rabbita](https://github.com/moonbit-community/rabbita), inspired by the
[shadcn/ui Nova](https://ui.shadcn.com/r/styles/base-nova/registry.json) visual language.

[Browse the component showcase](https://moonbit-community.github.io/rabbita/components/)

## Design

- Black-box components with public APIs for common customization.
- No Tailwind, external CSS import, code generator, or extra build step.
- Shared inline base styles, with `theme` providing tokens and the static rules
  needed for hover, focus, and motion.
- Interactive state is owned by Rabbita incremental components where needed;
  tooltips use ordinary HTML and CSS hover state.
- Native HTML and ARIA behavior is used where the browser provides it.
- JavaScript provides browser interaction.

RUI includes components for forms, data display, navigation, disclosure,
overlays, menus, and feedback. Exact APIs and copyable examples are available
in the [showcase](https://moonbit-community.github.io/rabbita/components/) and
the generated `pkg.generated.mbti` interface.

## Customization

For Markdown documents, import `moonbit-community/rui/markdown` and use
`@markdown.markdown(source)`. The synchronous renderer includes shadcn Typeset typography with Nova tokens,
tables, task lists and footnotes. See the [Markdown package](markdown/README.mbt.md)
for supported syntax and source-rendering behavior.

Use `--rui-*` theme tokens, component `style` parameters, and `attrs` for normal
customization. Copy the relevant `.mbt` source when you need to change a
component's DOM structure, state model, or interaction policy.

## Tooltips

`tooltip` and `sidebar_menu_button_with_tooltip` return `Html` directly. Place
these inside `theme` and compose them like buttons, without `Val::map` or
`Val::view`. Hovering the trigger shows the tooltip; leaving it hides the tooltip.
CSS handles visibility, positioning, and the entry/exit animations. Tooltip
construction does not read or modify the DOM or register event listeners. This
also works when the HTML is mounted later or removed and inserted again.

`tooltip_provider` supplies `delay` and `close_delay` through CSS variables;
individual tooltips can override them. Both delays default to zero. Entry fades
and scales in from 95% with a small directional slide; exit fades and scales out
over 100 ms. Reduced-motion preferences disable these animations. Arrows remain
available through `show_arrow` and are enabled by default.

Migration: remove `.map`/`.view` wrappers around tooltip results. Tooltip
`default_open`, `close_on_click`, `hoverable`, `on_open_change`, part `open`,
sidebar `on_tooltip_open_change`, and provider `timeout` parameters have been
removed, along with `tooltip_open`, `tooltip_close`, and `tooltip_toggle`.
Visibility follows trigger hover only; focus, clicks, and Escape do not maintain
or dismiss tooltip state. `on_trigger_click` remains an optional application
callback and does not control tooltip visibility.

Tooltips use CSS anchor positioning when supported and absolute positioning
otherwise. They no longer use the native Popover top layer or automatic
collision flipping. Ancestor clipping and stacking contexts therefore apply;
choose the placement and container overflow accordingly.

## License

RUI is available under the [MIT License](./LICENSE). See
[`THIRD_PARTY_NOTICES.md`](./THIRD_PARTY_NOTICES.md) for upstream attribution.
