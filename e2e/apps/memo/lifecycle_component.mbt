///|
priv enum Shape {
  PlainElement
  PlainText
  PlainFragment
  MemoElement
  MemoText
  MemoFragment
  NestedMemo
} derive(Eq, Hash)

///|
fn memo_shape(
  shape : Shape,
  value : Int,
  revision : Int,
  select : Emit[Int],
  computes : RenderCounter,
  nested_computes : RenderCounter,
) -> Html {
  match shape {
    PlainElement => div(id="plain-element", "plain element \{value}")
    PlainText => @html.text("plain text \{value}")
    PlainFragment =>
      @html.fragment([
        span(id="plain-first", "plain first \{value}"),
        span(id="plain-second", "plain second \{value}"),
      ])
    MemoElement | MemoText | MemoFragment | NestedMemo =>
      @html.memo((shape, value, revision), input => {
        computes.value += 1
        let (shape, value, _) = input
        match shape {
          MemoText => @html.text("memo text \{value}")
          MemoFragment =>
            @html.fragment([
              span(id="memo-first", "memo first \{value}"),
              button(
                id="memo-second",
                on_click=select(value),
                "Choose fragment value \{value}",
              ),
            ])
          NestedMemo =>
            @html.memo(value, value => {
              nested_computes.value += 1
              @html.fragment([
                span(id="nested-first", "nested first \{value}"),
                button(
                  id="nested-second",
                  on_click=select(value),
                  "Choose nested value \{value}",
                ),
              ])
            })
          _ => div(id="memo-element", "memo element \{value}")
        }
      })
  }
}

///|
fn memo_lifecycle_component(
  parent : Val[Int],
  value : Val[Int],
  select : Emit[Int],
) -> Val[Html] {
  let (shape, set_shape) = @rabbita.create_variable(MemoElement)
  let (shown, set_shown) = @rabbita.create_variable(true)
  let (revision, set_revision) = @rabbita.create_variable(0)
  let (views, view_counter) = render_counter("lifecycle_view")
  let (computes, compute_counter) = render_counter("shape")
  let (nested_computes, nested_counter) = render_counter("nested")
  let content = parent.view5(value, shape, shown, revision, (
    _,
    value,
    shape,
    shown,
    revision,
  ) => {
    views.value += 1
    div <| [
      div <| [
        button(on_click=set_shape(_ => PlainElement), "Plain element"),
        button(on_click=set_shape(_ => PlainText), "Plain text"),
        button(on_click=set_shape(_ => PlainFragment), "Plain fragment"),
        button(on_click=set_shape(_ => MemoElement), "Memo element"),
        button(on_click=set_shape(_ => MemoText), "Memo text"),
        button(on_click=set_shape(_ => MemoFragment), "Memo fragment"),
        button(on_click=set_shape(_ => NestedMemo), "Nested memo"),
        button(on_click=set_shown(_ => false), "Hide memo shape"),
        button(on_click=set_shown(_ => true), "Show memo shape"),
        button(
          on_click=set_revision(value => value + 1),
          "Invalidate outer memo",
        ),
      ],
      p(id="outer-revision", "outer revision: \{revision}"),
      div(id="transition-stage") <| [
        span(id="before-shape", "before"),
        if shown {
          memo_shape(shape, value, revision, select, computes, nested_computes)
        } else {
          @html.nothing
        },
        span(id="after-shape", "after"),
      ],
    ]
  })
  content.map4(view_counter, compute_counter, nested_counter, (
    content,
    view_counter,
    compute_counter,
    nested_counter,
  ) => div([content, view_counter, compute_counter, nested_counter]))
}
