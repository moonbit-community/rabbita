///|
using @common {type Keyboard}

///|
using @html {div, input, label, main_, nothing, section, span}

///|
using @rabbita {type Emit, type Html, type Val, new, create_state, none}

///|
using @string {parse_int}

///|
using @sub {type Sub, on_key_down}

///|
using @vector {type Vector, from_array, singleton}

///|
enum Tile {
  Wall
  Floor
  Goal
} derive(Eq)

///|
struct Pos {
  x : Int
  y : Int
} derive(Eq)

///|
struct World {
  player : Pos
  crates : Vector[Pos]
} derive(Eq)

///|
enum Msg {
  KeyPressed(Keyboard)
  JumpTo(String)
}

///|
let board : Vector[Vector[Tile]] = from_array([
  from_array([Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall]),
  from_array([Wall, Floor, Floor, Floor, Floor, Floor, Wall, Floor, Floor, Wall]),
  from_array([Wall, Floor, Floor, Floor, Floor, Floor, Goal, Floor, Floor, Wall]),
  from_array([Wall, Floor, Floor, Floor, Floor, Floor, Goal, Floor, Floor, Wall]),
  from_array([Wall, Floor, Floor, Floor, Floor, Floor, Goal, Floor, Floor, Wall]),
  from_array([
    Wall,
    Floor,
    Floor,
    Floor,
    Floor,
    Floor,
    Floor,
    Floor,
    Floor,
    Wall,
  ]),
  from_array([Wall, Floor, Floor, Floor, Floor, Floor, Wall, Wall, Floor, Wall]),
  from_array([Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall]),
])

///|
fn tile_at(position : Pos) -> Tile {
  guard position.x >= 0 && position.y >= 0 else { Wall }
  board.get(position.y).bind(row => row.get(position.x)).unwrap_or(Wall)
}

///|
fn crate_index_at(crates : Vector[Pos], position : Pos) -> Int? {
  for index in 0..<crates.length() {
    if crates[index] == position {
      break Some(index)
    }
  } nobreak {
    None
  }
}

///|
fn try_move(delta : Pos, world : World) -> World? {
  let target = { x: world.player.x + delta.x, y: world.player.y + delta.y }
  guard tile_at(target) != Wall else { None }
  match crate_index_at(world.crates, target) {
    Some(crate_index) => {
      let crate_target = { x: target.x + delta.x, y: target.y + delta.y }
      guard tile_at(crate_target) != Wall &&
        !world.crates.contains(crate_target) else {
        None
      }
      Some({
        player: target,
        crates: world.crates.set(crate_index, crate_target),
      })
    }
    None => Some({ ..world, player: target })
  }
}

///|
fn delta_from_key(event : Keyboard) -> Pos? {
  match event.key().to_lower() {
    "arrowup" | "w" | "k" => Some({ x: 0, y: -1 })
    "arrowdown" | "s" | "j" => Some({ x: 0, y: 1 })
    "arrowleft" | "a" | "h" => Some({ x: -1, y: 0 })
    "arrowright" | "d" | "l" => Some({ x: 1, y: 0 })
    _ => None
  }
}

///|
struct Model {
  history : Vector[World]
  cursor : Int
} derive(Eq)

///|
fn update(msg : Msg, model : Model) -> Model {
  match msg {
    KeyPressed(keyboard) => {
      guard delta_from_key(keyboard) is Some(delta) else { model }
      guard try_move(delta, model.history[model.cursor]) is Some(next) else {
        model
      }
      let cursor = model.cursor + 1
      let history = model.history.take(cursor).push(next)
      { history, cursor }
    }
    JumpTo(point) => {
      let idx = parse_int(point) catch { _ => 0 }
      let cursor = clamp(0, model.history.length() - 1, idx)
      { ..model, cursor, }
    }
  }
}

///|
fn clamp(min : Int, max : Int, idx : Int) -> Int {
  Int::min(Int::max(min, idx), max)
}

///|
fn subscriptions(_ : Model, emit : Emit[Msg]) -> Sub {
  on_key_down(event => emit(KeyPressed(event)))
}

///|
fn board_view(world : World) -> Html {
  let rows = board.length()
  let cols = board.get(0).map_or(0, row => row.length())
  div(class="board", style=["--cols: \{cols}", "--rows: \{rows}"]) <| Array::makei(
    cols * rows,
    index => {
      let position = { x: index % cols, y: index / cols }
      let tile = tile_at(position)
      let state = (
        world.crates.contains(position),
        world.player == position,
        tile,
      )
      let base = match tile {
        Wall => "tile wall"
        Goal => "tile floor goal"
        Floor => "tile floor"
      }
      let class = match state {
        (true, _, Goal) => base + " crate-home"
        (true, _, _) => base + " crate"
        (_, true, _) => base + " player-here"
        _ => base
      }
      div(class~) <| [
        match state {
          (true, _, _) =>
            div(class="crate-block") <| [
              div(class="crate-shine", nothing),
            ]
          (_, true, _) =>
            div(class="player") <| [
              div(class="player-core", nothing),
            ]
          (_, _, Goal) => div(class="goal-ring", nothing)
          _ => nothing
        },
      ]
    },
  )
}

///|
fn timeline_view(emit : Emit[Msg], model : Model) -> Html {
  let max_index = model.history.length() - 1
  let steps = Int::max(1, max_index)
  section(class="timeline") <| [
    div(class="timeline-head") <| [
      label(class="timeline-title", for_="history-range", "world history"),
      span(class="timeline-count", "\{model.cursor} / \{max_index}"),
    ],
    div(
      class="timeline-bar",
      style=[
        "--progress: \{model.cursor * 100 / steps}%",
        "--segments: \{steps}",
      ],
    ) <| [
      input(
        id="history-range",
        class="history-range",
        input_type=Range,
        min=0,
        max=max_index,
        step=1,
        value="\{model.cursor}",
        on_input=emit.map(value => JumpTo(value)),
      ),
    ],
  ]
}

///|
fn view(emit : Emit[Msg], model : Val[Model]) -> Val[Html] {
  let world = model.map(model => model.history[model.cursor])
  let board = world.map(world => board_view(world))
  let timeline = model.map(model => timeline_view(emit, model))
  board.map2(timeline, (board, timeline) => {
    main_(class="page") <| [
      section(class="hero") <| [
        div(class="stage-wrap") <| [
          board,
        ],
        div(class="bottom-deck") <| [
          timeline,
        ],
      ],
    ]
  })
}

///|
#cfg(target="js")
fn main {
  let initial_world = {
    player: { x: 2, y: 5 },
    crates: from_array([{ x: 3, y: 2 }, { x: 3, y: 3 }, { x: 3, y: 4 }]),
  }
  fn app() {
    let (model, emit) = create_state(
      { history: singleton(initial_world), cursor: 0 },
      update=fn(model, msg, _) { (update(msg, model), none) },
      subscriptions~,
    )
    view(emit, model)
  }
  new(app).mount("app")
}
