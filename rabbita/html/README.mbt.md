# HTML

The `html` package provides wrapper functions for all HTML elements. Basic usage:

```moonbit check
///|
fn view(emit : Emit[Msg], model : Model) -> Html {
  div(id="counter", style=["border: 1px solid black"], [
    h1(id="title", "the count is \{model.count}"),
    button(class="...", on_click=emit(Inc), "+"),
    button(class="...", on_click=emit(Dec), "-"),
  ])
}
```

Frequently used attributes are exposed as optional arguments. To access any HTML
attribute, see [Attribute Builder](#attribute-builder). Most HTML wrappers accept
a positional argument whose type is constrained by `IsChildren`, so you can pass
an `Array[Html]` or a `String`. See [Children](#children) for details.

There are also a few special helpers you will use frequently:

- `text()`

  To represent text in HTML, use the `text` function.
  
  ```mbt nocheck
  ///|
  let _ = p([text("hello world")])
  let _ = p("hello world") // equivalent to above
  ```

- `nothing`

  It does not represent an actual HTML element. This is useful when handling
  multiple `Option` values in your model:

  ```mbt nocheck
  ///|
  fn bad(path : Path, tag : Tag?) {
    let path = foo(path)
    let tag = match tag {
      None => []
      Some(x) => [view(x)] // Yuck!
    }
    div([path] + tag) // Don't do this
  }

  ///|
  fn good(path : Path, tag : Tag?) {
    let path = foo(path)
    let tag = match tag {
      None => nothing
      Some(x) => view(x)
    }
    div([path, tag]) // Use @html.nothing
  }
  ```

## Children

Almost every HTML element accepts a positional argument whose type is bounded by
the `IsChildren` trait. This means you can pass any type that implements this
trait as children to the HTML wrapper.

Currently it accepts the following types:

|type|example|
|-|-|
|`Array[Html]`|`div([html1, html2])`|
|`String`|`div("string here")`|
|`Html`|`div(p([...]))`|
|`Map[String,Html]`|`div({"k1": html1, "k2": html2})`|

## Keyed Children

When children are passed as `Map[String, Html]`, Rabbita treats them as **keyed children**.
Keys are used to match and reuse nodes across updates, which helps preserve DOM and Cell
state when items are inserted, removed, or reordered.

- Keys must be **unique and stable** (use a business ID, not an array index).
- Changing a key means the old node is removed and a new one is created.

Example:

```mbt check
///|
let html : Html = @html.ul({
  "todo-1": @html.li("Buy milk"),
  "todo-2": @html.li("Write docs"),
  "todo-3": @html.li("Write code"),
})
```

## Event Handlers

Rabbita separates event callbacks from UI views to manage side effects and avoid stale state, keeping UI predictable as code grows.

HTML wrappers provide common events as optional arguments like `on_click`,
`on_mouseup`, `on_scroll`, and `on_submit`. Each requires a `Cmd` binding to a
`Msg` you define. When an event fires, the `Msg` (and any extra payload) is
forwarded to the centralized state update function.

Registering the same event more than once composes the handlers in registration
order. When a wrapper receives both an event in `attrs` and its matching named
event argument, the `attrs` handler runs first and the named handler runs
second. Non-event attributes and properties keep their usual last-write-wins
behavior.

Example:

```moonbit check
///|
#cfg(target="js")
fn update2(msg : Msg2, _ : Model2) -> Model2 {
  match msg {
    StartDraw(mouse) => println("start at \{mouse.offset_pos()}")
    EndDraw(mouse) => println("end at \{mouse.offset_pos()}")
  }
}

///|
fn view2(emit : Emit[Msg2], _ : Model2) -> Html {
  @html.canvas(
    on_mousedown=m => emit(StartDraw(m)),
    on_mouseup=m => emit(EndDraw(m)),
    @html.nothing,
  )
}
```

## Advanced Usage

### Attribute Builder

The attribute builder is a **workaround** for cases where the HTML wrapper does
not expose a specific attribute or event. It is not the primary API and may be
less ergonomic or less type-safe than the dedicated wrapper parameters. Prefer
the wrapper options when available, and fall back to the builder only when
needed.

Example:

```mbt check
///|
let html1 : Html = div(
  attrs=@html.Attrs::build().class("card").style("gap", "12px").data("..."),
  [@html.text("Hello")],
)
```

### Escape Hatch

The wrapper functions and properties provided here may not cover all possible use cases. If you encounter missing functionality, feel free to file an issue or use the `node()` function as a workaround. The `node()` function allows you to manually specify the tag name, attributes, and children for your HTML element, offering flexibility for advanced or uncommon scenarios.

```mbt check
///|
let html2 : Html = node(
  "div",
  @html.Attrs::build().class("card").style("gap", "12px").data("..."),
  [@html.p("text1"), @html.p("text2")],
)
```

  
