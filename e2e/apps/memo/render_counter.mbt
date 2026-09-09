///|
priv struct RenderCounter {
  mut value : Int
}

///|
priv struct CounterSnapshot {
  reading : Int
  value : Int
} derive(Eq)

///|
// Expose a snapshot through an independent view so reading the count does not
// rerun the measured component.
fn render_counter(name : String) -> (RenderCounter, Val[Html]) {
  let counter = RenderCounter::{ value: 0, }
  let (snapshot, set_snapshot) = @rabbita.create_variable({
    reading: 0,
    value: 0,
  })
  let view = snapshot.view(snapshot => {
    div <| [
      button(
        on_click=set_snapshot(snapshot => {
          reading: snapshot.reading + 1,
          value: counter.value,
        }),
        "Read \{name} count",
      ),
      p(id="count-\{name}", "\{snapshot.value}"),
      p(id="count-\{name}-reading", "\{snapshot.reading}"),
    ]
  })
  (counter, view)
}
