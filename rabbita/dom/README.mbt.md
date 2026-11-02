# DOM API

This package exposes low-level DOM bindings for the JavaScript backend. The API
is intentionally thin and incomplete: it mirrors browser APIs, keeps nullability
explicit, and avoids convenience layers. Most users should prefer the `@html`
package and only drop to `@dom` for imperative interop.

**Warning:** This package is JS-backend only and not guaranteed to stay stable.
Using it may reduce cross-platform compatibility.

## Quick examples

### Query and set attributes

```mbt nocheck
///|
test {
  let doc = @dom.document()
  if doc.get_element_by_id("hero").to_option() is Some(el) {
    el.set_attribute("data-ready", "true")
  }
}
```

### Add an event listener

```mbt nocheck
///|
#cfg(target="js")
test {
  if @dom.document().get_element_by_id("btn").to_option() is Some(el) {
    el.add_event_listener("click", event => {
      guard event.to_mouse_event() is Some(mouse) else { return }
      let _x = mouse.get_client_x()
      let _y = mouse.get_client_y()
    })
  }
}
```

### Canvas context

```mbt nocheck
///|
test {
  let doc = @dom.document()
  if doc.get_element_by_id("canvas").to_option() is Some(el) &&
    el.to_html_canvas_element() is Some(canvas) &&
    canvas.get_context("2d").to0() {
    ctx.fill_rect(0, 0, 100, 60)
  }
}
```

### Fetch

`fetch` and the `Request` constructor use the sealed `IsRequestInfo` marker trait.
Both `String` and `Request` implement this trait and can be passed directly.
Native value conversion uses their existing `@js.Cast` implementations.
Body readers return native promises. HTTP error
statuses fulfill the fetch promise; check `get_ok()` or `get_status()` explicitly.

```mbt nocheck
///|
async test {
  let text = @dom.fetch("/api/message")
    .flat_map(response => response.text())
    .wait()
  println(text)
}
```

`Headers::new(init=[("X-Rabbit", "first"), ("X-Rabbit", "second")])` accepts
`FixedArray[(String, String)]`, preserving duplicate names. The binding converts
each tuple to the two-element JS array expected by the native constructor.
Omitting `init` creates empty headers.

`RequestInit::new` and `ResponseInit::new` omit unspecified fields and pass supplied
values through to the browser. `body` accepts native JS body values wrapped with
`@js.Value::cast_from`, such as a `String`, `Bytes`, `Blob`, or `FormData`.
`Request::json()` and `Response::json()` return `Promise[Json]`, converting the
native parsing result to MoonBit `Json`. Conversion failures reject the promise.
`Response::with_json` accepts MoonBit `Json`, converts it internally, and calls
the native `Response.json()` factory. Browser support, validation errors, body
consumption, and abort behavior follow the native Fetch API.

## Nullability and optional parameters

- Values that can be `null` use `@js.Nullable[T]`. Convert them with
  `to_option()` and pattern match on `Some/None`.
- Optional JS parameters use `@js.Optional[T]` with default
  `@js.Optional::undefined()`.

## Array-shaped values

Using MoonBit `Array` directly in JavaScript FFI does not have a stable ABI.

| JavaScript or Web IDL value | MoonBit binding |
| --- | --- |
| `sequence<T>` | `FixedArray[T]` |
| `FrozenArray<T>` | `ReadOnlyArray[T]` |
| ordinary JavaScript `Array` | `@js.JsArray[T]` |
| `ObservableArray<T>` | a dedicated observable wrapper |
| `NodeList`, `HTMLCollection`, typed arrays, and similar collections | their dedicated DOM types |

Bindings and wrappers preserve the original JavaScript object without copying.
APIs explicitly documented as conversions or serialization may allocate the
target representation.

## Naming conventions and file structure

- Each DOM type and its methods live in a corresponding file.
- Types use `CamelCase`; methods use `snake_case`.
- DOM properties are exposed as `get_*/set_*` methods.
- Overloads are disambiguated with suffixes based on parameter shapes.
- Union types use `@js.UnionN[A, B, ...]`.
- Conversions 
  - Upcasts return the target type directly, use `as_<type>`.
  - Downcasts return `T?` and must be checked, use `to_<type>`.

## Type relationships (partial)

```plaintext
Event <- AnimationEvent
      <- BlobEvent
      <- BeforeUnloadEvent
      <- ClipboardEvent
      <- CloseEvent
      <- CompositionEvent
      <- CustomEvent
      <- UIEvent <- MouseEvent <- DragEvent
                 <- FocusEvent
                 <- InputEvent
                 <- KeyboardEvent
                 <- WheelEvent

EventTarget <- Window
            <- Node <- Document
                    <- DocumentFragment
                    <- Element <- HTMLElement <- HTMLCanvasElement
                                              <- HTMLInputElement
                                              <- HTMLDialogElement
                                              <- HTMLImageElement
                                              <- HTMLMediaElement <- HTMLVideoElement
                               <- SVGElement <- SVGGraphicsElement
                                             <- SVGImageElement
```

## Contribution

Contributions are welcome.

  If you would like to contribute a patch, please follow these
  guidelines:

  - Keep APIs low-level and explicit about nullability.
  - Follow the naming conventions above.
  - Add an MDN link near new extern bindings.
  - Prefer small, focused PRs.

You can also contribute by reporting issues and bugs.
