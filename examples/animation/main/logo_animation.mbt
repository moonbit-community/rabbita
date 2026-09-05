///|
/// Adapted from:
/// https://github.com/elm/elm-lang.org/blob/master/src/Logo.elm
///
/// Copyright (c) 2012-present Evan Czaplicki
/// Licensed under the BSD 3-Clause License.
/// See ../THIRD_PARTY_NOTICES.md for the copied license text.
///
/// The spring/damping step model and pattern coordinates below are ported
/// directly from Elm's home page logo animation.

///|
enum LogoShape {
  Static(Double, Double, Double)
  Moving(Double, Double, Double, Double, Double, Double, Double, Double, Double)
} derive(Eq)

///|
struct LogoModel {
  tb1 : LogoShape
  tb2 : LogoShape
  tm : LogoShape
  sqr : LogoShape
  par : LogoShape
  ts1 : LogoShape
  ts2 : LogoShape
} derive(Eq)

///|
struct Target {
  tx : Double
  ty : Double
  ta : Double
}

///|
struct Pattern {
  tb1 : Target
  tb2 : Target
  tm : Target
  sqr : Target
  par : Target
  ts1 : Target
  ts2 : Target
}

///|
let triangle_big : Array[(Int, Int)] = [(-280, -90), (0, 190), (280, -90)]

///|
let triangle_medium : Array[(Int, Int)] = [(-198, -66), (0, 132), (198, -66)]

///|
let triangle_small : Array[(Int, Int)] = [(-130, -44), (0, 86), (130, -44)]

///|
let square_points : Array[(Int, Int)] = [
  (-130, 0),
  (0, -130),
  (130, 0),
  (0, 130),
]

///|
let parallelogram_points : Array[(Int, Int)] = [
  (-191, 61),
  (69, 61),
  (191, -61),
  (-69, -61),
]

///|
let logo_pattern : Pattern = {
  tb1: { tx: 0.0, ty: -210.0, ta: 0.0, },
  tb2: { tx: -210.0, ty: 0.0, ta: 90.0, },
  tm: { tx: 207.0, ty: 207.0, ta: 45.0, },
  sqr: { tx: 150.0, ty: 0.0, ta: 0.0, },
  par: { tx: -89.0, ty: 239.0, ta: 0.0, },
  ts1: { tx: 0.0, ty: 106.0, ta: 180.0, },
  ts2: { tx: 256.0, ty: -150.0, ta: 270.0, },
}

///|
let heart_pattern : Pattern = {
  tb1: { tx: -160.0, ty: 120.0, ta: 0.0, },
  tb2: { tx: 150.0, ty: -90.0, ta: 180.0, },
  tm: { tx: -270.0, ty: -93.0, ta: 45.0, },
  sqr: { tx: 0.0, ty: -300.0, ta: 0.0, },
  par: { tx: 231.0, ty: 91.0, ta: 0.0, },
  ts1: { tx: 150.0, ty: 224.0, ta: 0.0, },
  ts2: { tx: -106.0, ty: -150.0, ta: 90.0, },
}

///|
let bird_pattern : Pattern = {
  tb1: { tx: -296.0, ty: 166.0, ta: 45.0, },
  tb2: { tx: 0.0, ty: 40.0, ta: 225.0, },
  tm: { tx: 200.0, ty: 136.0, ta: 270.0, },
  sqr: { tx: -42.0, ty: -212.0, ta: 45.0, },
  par: { tx: -138.0, ty: -424.0, ta: 135.0, },
  ts1: { tx: 139.0, ty: -181.0, ta: 315.0, },
  ts2: { tx: 352.0, ty: 214.0, ta: 225.0, },
}

///|
let child_pattern : Pattern = {
  tb1: { tx: -88.0, ty: -46.0, ta: 135.0, },
  tb2: { tx: 208.0, ty: 86.0, ta: -45.0, },
  tm: { tx: 120.0, ty: -300.0, ta: 0.0, },
  sqr: { tx: 104.0, ty: 352.0, ta: 36.0, },
  par: { tx: -140.0, ty: -300.0, ta: 315.0, },
  ts1: { tx: -404.0, ty: -380.0, ta: 315.0, },
  ts2: { tx: 328.0, ty: -434.0, ta: 180.0, },
}

///|
let house_pattern : Pattern = {
  tb1: { tx: 0.0, ty: -250.0, ta: 0.0, },
  tb2: { tx: 96.0, ty: 54.0, ta: 0.0, },
  tm: { tx: -218.0, ty: -152.0, ta: 315.0, },
  sqr: { tx: -106.0, ty: 266.0, ta: 45.0, },
  par: { tx: -212.0, ty: 56.0, ta: 315.0, },
  ts1: { tx: 162.0, ty: -104.0, ta: 180.0, },
  ts2: { tx: 264.0, ty: -206.0, ta: 270.0, },
}

///|
let cat_pattern : Pattern = {
  tb1: { tx: -40.0, ty: -120.0, ta: 90.0, },
  tb2: { tx: 20.0, ty: -420.0, ta: 135.0, },
  tm: { tx: -226.0, ty: -38.0, ta: 270.0, },
  sqr: { tx: -220.0, ty: 276.0, ta: 0.0, },
  par: { tx: 350.0, ty: -462.0, ta: 315.0, },
  ts1: { tx: -320.0, ty: 428.0, ta: 90.0, },
  ts2: { tx: -120.0, ty: 428.0, ta: 270.0, },
}

///|
let camel_pattern : Pattern = {
  tb1: { tx: -250.0, ty: -256.0, ta: 315.0, },
  tb2: { tx: 100.0, ty: -260.0, ta: 270.0, },
  tm: { tx: -190.0, ty: -30.0, ta: 0.0, },
  sqr: { tx: 40.0, ty: 40.0, ta: 0.0, },
  par: { tx: 278.0, ty: 40.0, ta: 90.0, },
  ts1: { tx: 262.0, ty: 276.0, ta: 90.0, },
  ts2: { tx: 366.0, ty: 380.0, ta: 180.0, },
}

///|
let rabbit_pattern : Pattern = {
  tb1: { tx: -180.0, ty: -176.4, ta: 315.0, },
  tb2: { tx: 111.6, ty: -240.0, ta: 0.0, },
  tm: { tx: 125.0, ty: -420.0, ta: 180.0, },
  sqr: { tx: -150.0, ty: 69.9, ta: 45.0, },
  par: { tx: -80, ty: 345.0, ta: 90.0, },
  ts1: { tx: -280.0, ty: 420.8, ta: 225.0, },
  ts2: { tx: -220.0, ty: 280.8, ta: 45, },
}

///|
let pstiffness = 220.0

///|
let pdamping = 10.0

///|
let astiffness = 200.0

///|
let adamping = 10.0

///|
fn logo_pattern_name(index : Int) -> String {
  match index {
    0 => "logo"
    1 => "heart"
    2 => "bird"
    3 => "child"
    4 => "house"
    5 => "cat"
    6 => "camel"
    _ => "rabbit"
  }
}

///|
fn logo_pattern_at(index : Int) -> Pattern {
  match index {
    0 => logo_pattern
    1 => heart_pattern
    2 => bird_pattern
    3 => child_pattern
    4 => house_pattern
    5 => cat_pattern
    6 => camel_pattern
    _ => rabbit_pattern
  }
}

///|
fn logo_start() -> LogoModel {
  {
    tb1: Static(0.0, -210.0, 0.0),
    tb2: Static(-210.0, 0.0, 90.0),
    tm: Static(207.0, 207.0, 45.0),
    sqr: Static(150.0, 0.0, 0.0),
    par: Static(-89.0, 239.0, 0.0),
    ts1: Static(0.0, 106.0, 180.0),
    ts2: Static(256.0, -150.0, 270.0),
  }
}

///|
fn logo_view_shape(
  color : String,
  shape : LogoShape,
  coordinates : Array[(Int, Int)],
) -> @svg.Svg {
  match shape {
    Static(x, y, a) => logo_view_shape_help(color, x, y, a, coordinates)
    Moving(_, _, _, x, y, a, _, _, _) =>
      logo_view_shape_help(color, x, y, a, coordinates)
  }
}

///|
fn logo_view_shape_help(
  color : String,
  x : Double,
  y : Double,
  a : Double,
  coordinates : Array[(Int, Int)],
) -> @svg.Svg {
  @svg.polygon(
    fill=color,
    points=coordinates,
    transform="translate(\{x} \{y}) rotate(\{0.0 - a})",
  )
}

///|
fn logo_view(model : LogoModel) -> @html.Html {
  @svg.svg(
    view_box="-600 -600 1200 1200",
    width=400,
    height=400,
    class="tangram",
    [
      @svg.g(transform="scale(1 -1)", [
        logo_view_shape("rgba(18, 147, 216, 1)", model.tb1, triangle_big),
        logo_view_shape("rgba(18, 147, 216, 1)", model.tb2, triangle_big),
        logo_view_shape("rgba(18, 147, 216, 0.75)", model.tm, triangle_medium),
        logo_view_shape("rgba(18, 147, 216, 1)", model.sqr, square_points),
        logo_view_shape(
          "rgba(18, 147, 216, 0.75)",
          model.par,
          parallelogram_points,
        ),
        logo_view_shape("rgba(18, 147, 216, 0.75)", model.ts1, triangle_small),
        logo_view_shape("rgba(18, 147, 216, 0.75)", model.ts2, triangle_small),
      ]),
    ],
  )
}

///|
fn logo_set_pattern(target : Pattern, model : LogoModel) -> LogoModel {
  {
    tb1: logo_set_shape(target.tb1, model.tb1),
    tb2: logo_set_shape(target.tb2, model.tb2),
    tm: logo_set_shape(target.tm, model.tm),
    sqr: logo_set_shape(target.sqr, model.sqr),
    par: logo_set_shape(target.par, model.par),
    ts1: logo_set_shape(target.ts1, model.ts1),
    ts2: logo_set_shape(target.ts2, model.ts2),
  }
}

///|
fn logo_set_pattern_by_index(index : Int, model : LogoModel) -> LogoModel {
  logo_set_pattern(logo_pattern_at(index), model)
}

///|
fn logo_static_pattern(index : Int) -> LogoModel {
  let target = logo_pattern_at(index)
  {
    tb1: Static(
      target.tb1.tx,
      target.tb1.ty,
      logo_normalize_angle(target.tb1.ta),
    ),
    tb2: Static(
      target.tb2.tx,
      target.tb2.ty,
      logo_normalize_angle(target.tb2.ta),
    ),
    tm: Static(target.tm.tx, target.tm.ty, logo_normalize_angle(target.tm.ta)),
    sqr: Static(
      target.sqr.tx,
      target.sqr.ty,
      logo_normalize_angle(target.sqr.ta),
    ),
    par: Static(
      target.par.tx,
      target.par.ty,
      logo_normalize_angle(target.par.ta),
    ),
    ts1: Static(
      target.ts1.tx,
      target.ts1.ty,
      logo_normalize_angle(target.ts1.ta),
    ),
    ts2: Static(
      target.ts2.tx,
      target.ts2.ty,
      logo_normalize_angle(target.ts2.ta),
    ),
  }
}

///|
fn logo_set_shape(target : Target, shape : LogoShape) -> LogoShape {
  match shape {
    Static(x, y, a) =>
      Moving(0.0, 0.0, 0.0, x, y, a, target.tx, target.ty, target.ta)
    Moving(vx, vy, va, x, y, a, _, _, _) =>
      Moving(vx, vy, va, x, y, a, target.tx, target.ty, target.ta)
  }
}

///|
fn logo_step(time_delta_ms : Double, model : LogoModel) -> LogoModel {
  let dt = time_delta_ms / 1000.0
  {
    tb1: logo_step_shape(dt, model.tb1),
    tb2: logo_step_shape(dt, model.tb2),
    tm: logo_step_shape(dt, model.tm),
    sqr: logo_step_shape(dt, model.sqr),
    par: logo_step_shape(dt, model.par),
    ts1: logo_step_shape(dt, model.ts1),
    ts2: logo_step_shape(dt, model.ts2),
  }
}

///|
fn logo_step_shape(dt : Double, shape : LogoShape) -> LogoShape {
  match shape {
    Static(_, _, _) => shape
    Moving(vx, vy, va, x, y, a, tx, ty, ta) => {
      let tt = logo_to_nearest_angle(a, ta)
      let ax = pstiffness * (tx - x) - pdamping * vx
      let ay = pstiffness * (ty - y) - pdamping * vy
      let at = astiffness * (tt - a) - adamping * va
      let nvx = vx + ax * dt
      let nvy = vy + ay * dt
      let nva = va + at * dt
      let nx = x + nvx * dt
      let ny = y + nvy * dt
      let na = a + nva * dt
      let dx = (tx - nx).abs()
      let dy = (ty - ny).abs()
      let da = (tt - na).abs()
      if dx < 1.0 &&
        dy < 1.0 &&
        da < 1.0 &&
        nvx.abs() < 0.6 &&
        nvy.abs() < 0.6 &&
        nva.abs() < 0.6 {
        Static(tx, ty, logo_normalize_angle(ta))
      } else {
        Moving(nvx, nvy, nva, nx, ny, na, tx, ty, ta)
      }
    }
  }
}

///|
fn logo_to_nearest_angle(current : Double, target : Double) -> Double {
  let distance = target - current
  if distance < -180.0 {
    target + 360.0
  } else if distance > 180.0 {
    target - 360.0
  } else {
    target
  }
}

///|
fn logo_normalize_angle(angle : Double) -> Double {
  if angle < 0.0 {
    angle + 360.0
  } else if angle > 360.0 {
    angle - 360.0
  } else {
    angle
  }
}

///|
fn logo_is_moving(model : LogoModel) -> Bool {
  logo_is_moving_shape(model.tb1) ||
  logo_is_moving_shape(model.tb2) ||
  logo_is_moving_shape(model.tm) ||
  logo_is_moving_shape(model.sqr) ||
  logo_is_moving_shape(model.par) ||
  logo_is_moving_shape(model.ts1) ||
  logo_is_moving_shape(model.ts2)
}

///|
fn logo_is_moving_shape(shape : LogoShape) -> Bool {
  match shape {
    Static(_, _, _) => false
    Moving(_, _, _, _, _, _, _, _, _) => true
  }
}
