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

Render `dialog` inside a `Val::map` or `Val::view` when its contents depend on
changing application data. The browser owns the dialog's open state, so content
updates do not reset it. Keep the dialog at a stable position with the same ID,
and leave `open` unset when opening it with a command. The trigger is an ordinary
button outside the dialog; import `moonbit-community/rabbita/dialog` as `@dialog`
to use `@dialog.show`.

```mbt nocheck
fn profile_dialog() -> @rabbita.Val[@html.Html] {
  let (name, set_name) = @rabbita.create_variable("Rabbita team")
  name.map(name => {
    @html.fragment([
      @rui.button(on_click=@dialog.show("profile"), "Edit profile"),
      @rui.dialog(
        id="profile",
        attrs=@html.Attrs::build().aria_labelledby("profile-title"),
        [
          @rui.dialog_header([
            @rui.dialog_title(id="profile-title", "Edit profile"),
          ]),
          @rui.label(for_="profile-name", "Display name"),
          @rui.input(
            id="profile-name",
            value=name,
            on_input=set_name.map(value => _ => value),
          ),
          @html.p("Hello, \{name}!"),
          @rui.dialog_footer(
            @html.form(
              method_="dialog",
              @rui.button(type_="submit", "Done"),
            ),
          ),
        ],
      ),
    ])
  })
}
```

## License

RUI is available under the [MIT License](./LICENSE). See
[`THIRD_PARTY_NOTICES.md`](./THIRD_PARTY_NOTICES.md) for upstream attribution.
