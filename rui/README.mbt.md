# RUI (Experimental)

> RUI is experimental. Its API and component behavior may change before a
> stable release.

RUI (`Yoorkin/rui`) is a native component library for
[Rabbita](https://github.com/moonbit-community/rabbita), inspired by the
shadcn/ui Vega visual language.

[Browse the component showcase](https://moonbit-community.github.io/rabbita/components/)

## Design

- Black-box components with public APIs for common customization.
- No Tailwind, external CSS import, code generator, or extra build step.
- Shared inline base styles, with `theme` providing tokens and the static rules
  needed for hover, focus, and motion.
- Interactive state is owned by Rabbita incremental components.
- Native HTML and ARIA behavior is used where the browser provides it.
- JavaScript provides browser interaction.

RUI includes components for forms, data display, navigation, disclosure,
overlays, menus, and feedback. Exact APIs and copyable examples are available
in the [showcase](https://moonbit-community.github.io/rabbita/components/) and
the generated `pkg.generated.mbti` interface.

## Customization

Use `--rui-*` theme tokens, component `style` parameters, and `attrs` for normal
customization. Copy the relevant `.mbt` source when you need to change a
component's DOM structure, state model, or interaction policy.

## Reactive dialog content

Use `dialog_with_input` when a dialog displays changing application data or a
stateful child component. Build the dialog once and pass a `Val` as `input`;
the builder receives the current input alongside the usual `DialogScope`.
Input changes update the contents while preserving the dialog's open state,
focus behavior, and pending close transition. `default_open` is an initial
value, not a controlled open property.

```mbt nocheck
fn profile_dialog() -> @rabbita.Val[@html.Html] {
  let (name, set_name) = @rabbita.create_variable("Rabbita team")
  @rui.dialog_with_input(id="profile", input=name, (scope, name) => {
    @html.fragment([
      @rui.dialog_trigger(scope, "Edit profile"),
      @rui.dialog_portal([
        @rui.dialog_content(scope, described=false, [
          @rui.dialog_header([
            @rui.dialog_title(scope, "Edit profile"),
          ]),
          @rui.label(for_="profile-name", "Display name"),
          @rui.input(
            id="profile-name",
            value=name,
            on_input=set_name.map(value => _ => value),
          ),
          @html.p("Hello, \{name}!"),
          @rui.dialog_footer(@rui.dialog_close(scope, "Done")),
        ]),
      ]),
    ])
  })
}
```

## License

RUI is available under the [MIT License](./LICENSE). See
[`THIRD_PARTY_NOTICES.md`](./THIRD_PARTY_NOTICES.md) for upstream attribution.
