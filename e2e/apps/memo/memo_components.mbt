///|
fn basic_memo_component(
  parent : Val[Int],
  value : Val[Int],
  select : Emit[Int],
) -> Val[Html] {
  let (views, view_counter) = render_counter("basic_view")
  let (computes, compute_counter) = render_counter("basic")
  let (sibling_computes, sibling_counter) = render_counter("sibling")
  // Keep parent as a dependency so these updates exercise VDOM memoization,
  // rather than being skipped by the component's incremental view.
  let content = parent.view2(value, (_, value) => {
    views.value += 1
    @html.fragment([
      @html.memo(value, value => {
        computes.value += 1
        div(id="basic-memo") <| [
          p(id="basic-value", "memo value: \{value}"),
          input(placeholder="Memo draft"),
          button(on_click=select(value), "Choose memo value"),
        ]
      }),
      // Equal inputs in different positions must retain independent caches.
      @html.memo(value, value => {
        sibling_computes.value += 1
        p(id="sibling-value", "sibling value: \{value}")
      }),
    ])
  })
  content.map4(view_counter, compute_counter, sibling_counter, (
    content,
    view_counter,
    compute_counter,
    sibling_counter,
  ) => div([content, view_counter, compute_counter, sibling_counter]))
}

///|
// This deliberately has no Hash implementation: memo_by accepts arbitrary input.
priv struct CustomInput {
  value : Int
  _ignored : Int
}

///|
fn custom_memo_component(
  parent : Val[Int],
  value : Val[Int],
  select : Emit[Int],
) -> Val[Html] {
  let (ignored, set_ignored) = @rabbita.create_variable(0)
  let (views, view_counter) = render_counter("custom_view")
  let (computes, compute_counter) = render_counter("custom")
  let content = parent.view3(value, ignored, (_, value, ignored) => {
    views.value += 1
    div <| [
      p(id="ignored-version", "ignored: \{ignored}"),
      button(on_click=set_ignored(value => value + 1), "Update ignored field"),
      @html.memo_by(
        CustomInput::{ value, _ignored: ignored, },
        input => {
          computes.value += 1
          div(id="custom-memo") <| [
            p(id="custom-value", "custom value: \{input.value}"),
            button(on_click=select(input.value), "Choose custom value"),
          ]
        },
        by=input => input.value,
      ),
    ]
  })
  content.map3(view_counter, compute_counter, (
    content,
    view_counter,
    compute_counter,
  ) => div([content, view_counter, compute_counter]))
}
