///|
fn physical_root_app() -> Val[Html] {
  let (revision, advance) = @rabbita.create_variable(0)
  let next = advance(revision => revision + 1)
  let a = div(id="physical-root") <| [
    p(id="physical-root-value", "A"),
    button(on_click=next, "Advance root"),
  ]
  let b = div(id="physical-root") <| [
    p(id="physical-root-value", "B"),
    button(on_click=next, "Advance root"),
  ]
  revision.view(revision => if revision == 2 || revision == 3 { b } else { a })
}

///|
fn physical_document_app() -> Val[Html] {
  let (revision, advance) = @rabbita.create_variable(0)
  let refresh = button(on_click=@rabbita.none, "Refresh document")
  let update = button(
    on_click=advance(revision => revision + 1),
    "Update document",
  )
  let a = div(id="hydrated-element", "element A")
  let b = div(id="hydrated-element", "element B")
  let text = @html.text("shared text")
  let fragment = @html.fragment([span(id="hydrated-fragment", "fragment")])
  let thunk = @html.memo(0, _ => div(id="hydrated-thunk", "thunk"))
  revision.view(revision => {
    @html.html(id="physical-hydrated", [
      @html.head([@html.title("Physical document \{revision}")]),
      @html.body([
        refresh,
        update,
        p(id="document-version", "revision: \{revision}"),
        if revision == 2 || revision == 3 {
          b
        } else {
          a
        },
        text,
        fragment,
        thunk,
      ]),
    ])
  })
}
