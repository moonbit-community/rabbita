///|
using @common {type Keyboard}

///|
using @html {div, input, label, main_, nothing, section, span}

///|
using @rabbita {type Emit, type Html, new, simple_cell_with_emit}

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
}

///|
enum Msg {
  KeyPressed(Keyboard)
  JumpTo(String)
}

///|
struct Model {
  world : World
  history : Vector[World]
  cursor : Int
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
fn update(msg : Msg, model : Model) -> Model {
  match msg {
    KeyPressed(event) =>
      delta_from_key(event)
      .bind(delta => try_move(delta, model.world))
      .map(next => {
        let history = model.history.take(model.cursor + 1).push(next)
        { world: next, history, cursor: model.cursor + 1 }
      })
      .unwrap_or(model)
    JumpTo(value) => {
      let max_index = model.history.length() - 1
      let cursor = Int::min(
        Int::max(0, parse_int(value) catch { _ => 0 }),
        max_index,
      )
      {
        ..model,
        world: model.history.get(cursor).unwrap_or(model.world),
        cursor,
      }
    }
  }
}

///|
fn subscriptions(emit : Emit[Msg], _ : Model) -> Sub {
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
        nothing,
      ),
    ],
  ]
}

///|
fn view(emit : Emit[Msg], model : Model) -> Html {
  main_(class="page") <| [
    section(class="hero") <| [
      div(class="stage-wrap") <| [
        board_view(model.world),
      ],
      div(class="bottom-deck") <| [
        timeline_view(emit, model),
      ],
    ],
  ]
}

///|
#cfg(target="js")
fn main {
  let initial_world = {
    player: { x: 2, y: 5 },
    crates: from_array([{ x: 3, y: 2 }, { x: 3, y: 3 }, { x: 3, y: 4 }]),
  }
  let (_, app) = simple_cell_with_emit(
    model={ world: initial_world, history: singleton(initial_world), cursor: 0 },
    update~,
    view~,
    subscriptions~,
  )
  new(app).mount("app")
}
