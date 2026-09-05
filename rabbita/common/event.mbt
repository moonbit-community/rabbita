///|
struct Mouse {
  screen : Pos
  offset : Pos
  client : Pos
} derive(Debug)

///|
pub fn Mouse::new(screen~ : Pos, offset~ : Pos, client~ : Pos) -> Self {
  { screen, offset, client, }
}

///|
pub fn Mouse::screen_pos(self : Mouse) -> Pos {
  self.screen
}

///|
pub fn Mouse::offset_pos(self : Mouse) -> Pos {
  self.offset
}

///|
pub fn Mouse::client_pos(self : Mouse) -> Pos {
  self.client
}

///|
pub(all) struct Pos {
  x : Double
  y : Double
} derive(Debug)

///|
pub impl Show for Pos with fn output(self, buf) {
  Show::output(self.to_repr(), buf)
}

///|
struct Keyboard {
  key_value : String
  code_value : String
  alt_pressed : Bool
  ctrl_pressed : Bool
  shift_pressed : Bool
  meta_pressed : Bool
  composing : Bool
  repeated : Bool
  location_value : Int
} derive(Debug)

///|
pub fn Keyboard::new(
  key~ : String,
  code~ : String,
  alt_key~ : Bool,
  ctrl_key~ : Bool,
  shift_key~ : Bool,
  meta_key~ : Bool,
  is_composing~ : Bool,
  repeat~ : Bool,
  location~ : Int,
) -> Self {
  {
    key_value: key,
    code_value: code,
    alt_pressed: alt_key,
    ctrl_pressed: ctrl_key,
    shift_pressed: shift_key,
    meta_pressed: meta_key,
    composing: is_composing,
    repeated: repeat,
    location_value: location,
  }
}

///|
pub fn Keyboard::key(self : Keyboard) -> String {
  self.key_value
}

///|
pub fn Keyboard::code(self : Keyboard) -> String {
  self.code_value
}

///|
pub fn Keyboard::alt_key(self : Keyboard) -> Bool {
  self.alt_pressed
}

///|
pub fn Keyboard::ctrl_key(self : Keyboard) -> Bool {
  self.ctrl_pressed
}

///|
pub fn Keyboard::shift_key(self : Keyboard) -> Bool {
  self.shift_pressed
}

///|
pub fn Keyboard::meta_key(self : Keyboard) -> Bool {
  self.meta_pressed
}

///|
pub fn Keyboard::is_composing(self : Keyboard) -> Bool {
  self.composing
}

///|
pub fn Keyboard::repeat(self : Keyboard) -> Bool {
  self.repeated
}

///|
pub fn Keyboard::location(self : Keyboard) -> Int {
  self.location_value
}

///|
struct Scroll {
  scroll_offset : Pos
  scroll_width : Double
  scroll_height : Double
} derive(Debug)

///|
pub fn Scroll::new(offset~ : Pos, width~ : Double, height~ : Double) -> Self {
  { scroll_offset: offset, scroll_width: width, scroll_height: height, }
}

///|
pub fn Scroll::offset_pos(self : Self) -> Pos {
  self.scroll_offset
}

///|
pub fn Scroll::width(self : Self) -> Double {
  self.scroll_width
}

///|
pub fn Scroll::height(self : Self) -> Double {
  self.scroll_height
}

///|
pub(all) struct Viewport {
  width : Double
  height : Double
} derive(Debug)

///|
pub impl Show for Viewport with fn output(self, buf) {
  Show::output(self.to_repr(), buf)
}
