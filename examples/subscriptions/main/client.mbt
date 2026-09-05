///|
using @html {button, code, div, fragment, h1, nothing, p}

///|
using @common {type Keyboard, type Mouse, type Scroll, type Viewport}

///|
using @rabbita {type Cmd, type Emit, type Html, type Val}

///|
enum Tab {
  Every
  Resize
  Scroll
  KeyDown
  KeyUp
  VisibilityChange
  MouseMove
} derive(Eq)

///|
impl @rabbita.Enumerate for Tab with fn tag(self) {
  tab_id(self).to_string()
}

///|
enum Msg {
  SelectTab(Tab)
  Tick
  ToggleTicker
  ViewportChanged(Viewport)
  PageScrolled(Scroll)
  KeyPressed(Keyboard)
  KeyReleased(Keyboard)
  VisibilityChanged(Bool)
  MouseMoved(Mouse)
}

///|
struct Model {
  active_tab : Tab
  tick_count : Int
  ticking : Bool
  resize_count : Int
  viewport_width : Double
  viewport_height : Double
  scroll_count : Int
  scroll_x : Double
  scroll_y : Double
  scroll_width : Double
  scroll_height : Double
  keydown_count : Int
  last_key_down : String
  last_key_down_code : String
  last_key_down_repeat : Bool
  keyup_count : Int
  last_key_up : String
  last_key_up_code : String
  visibility_hidden : Bool
  visibility_count : Int
  mouse_moves : Int
  mouse_x : Double
  mouse_y : Double
} derive(Eq)

///|
fn tab_id(tab : Tab) -> Int {
  match tab {
    Every => 0
    Resize => 1
    Scroll => 2
    KeyDown => 3
    KeyUp => 4
    VisibilityChange => 5
    MouseMove => 6
  }
}

///|
fn tabs() -> Array[Tab] {
  [Every, Resize, Scroll, KeyDown, KeyUp, VisibilityChange, MouseMove]
}

///|
fn tab_title(tab : Tab) -> String {
  match tab {
    Every => "every"
    Resize => "on_resize"
    Scroll => "on_scroll"
    KeyDown => "on_key_down"
    KeyUp => "on_key_up"
    VisibilityChange => "on_visibility_change"
    MouseMove => "on_mouse_move"
  }
}

///|
fn tab_signature(tab : Tab) -> String {
  match tab {
    Every => "@sub.every(1000, emit(Tick))"
    Resize => "@sub.on_resize(v => emit(ViewportChanged(v)))"
    Scroll => "@sub.on_scroll(s => emit(PageScrolled(s)))"
    KeyDown => "@sub.on_key_down(k => emit(KeyPressed(k)))"
    KeyUp => "@sub.on_key_up(k => emit(KeyReleased(k)))"
    VisibilityChange =>
      "@sub.on_visibility_change(hidden => emit(VisibilityChanged(hidden)))"
    MouseMove => "@sub.on_mouse_move(m => emit(MouseMoved(m)))"
  }
}

///|
fn bool_label(value : Bool) -> String {
  if value {
    "true"
  } else {
    "false"
  }
}

///|
fn line(label : String, value : String) -> Html {
  div(class="line") <| [
    code(class="line-label", label),
    p(class="line-value", value),
  ]
}

///|
fn tab_button(emit : Emit[Msg], active : Tab, tab : Tab) -> Html {
  let class = if tab_id(active) == tab_id(tab) { "tab active" } else { "tab" }
  button(class~, on_click=emit(SelectTab(tab)), tab_title(tab))
}

///|
fn output_lines(model : Model) -> Array[Html] {
  match model.active_tab {
    Every =>
      [
        line("ticking", bool_label(model.ticking)),
        line("tick_count", "\{model.tick_count}"),
      ]
    Resize =>
      [
        line("resize_count", "\{model.resize_count}"),
        line("viewport_width", "\{model.viewport_width}"),
        line("viewport_height", "\{model.viewport_height}"),
      ]
    Scroll =>
      [
        line("scroll_count", "\{model.scroll_count}"),
        line("scroll_x", "\{model.scroll_x}"),
        line("scroll_y", "\{model.scroll_y}"),
        line("scroll_width", "\{model.scroll_width}"),
        line("scroll_height", "\{model.scroll_height}"),
      ]
    KeyDown =>
      [
        line("keydown_count", "\{model.keydown_count}"),
        line("last_key", model.last_key_down),
        line("last_code", model.last_key_down_code),
        line("repeat", bool_label(model.last_key_down_repeat)),
      ]
    KeyUp =>
      [
        line("keyup_count", "\{model.keyup_count}"),
        line("last_key", model.last_key_up),
        line("last_code", model.last_key_up_code),
      ]
    VisibilityChange =>
      [
        line("hidden", bool_label(model.visibility_hidden)),
        line("visibility_count", "\{model.visibility_count}"),
      ]
    MouseMove =>
      [
        line("mouse_moves", "\{model.mouse_moves}"),
        line("client_x", "\{model.mouse_x}"),
        line("client_y", "\{model.mouse_y}"),
      ]
  }
}

///|
fn active_actions(emit : Emit[Msg], model : Model) -> Array[Html] {
  match model.active_tab {
    Every =>
      [
        button(
          class="toggle",
          on_click=emit(ToggleTicker),
          if model.ticking {
            "pause"
          } else {
            "resume"
          },
        ),
      ]
    _ => []
  }
}

///|
fn update(_ : Emit[Msg], msg : Msg, model : Model) -> (Cmd, Model) {
  match msg {
    SelectTab(tab) => (@rabbita.none, { ..model, active_tab: tab, })
    Tick => (@rabbita.none, { ..model, tick_count: model.tick_count + 1, })
    ToggleTicker => (@rabbita.none, { ..model, ticking: !model.ticking, })
    ViewportChanged(viewport) =>
      (
        @rabbita.none,
        {
          ..model,
          resize_count: model.resize_count + 1,
          viewport_width: viewport.width,
          viewport_height: viewport.height,
        },
      )
    PageScrolled(scroll) => {
      let pos = scroll.offset_pos()
      (
        @rabbita.none,
        {
          ..model,
          scroll_count: model.scroll_count + 1,
          scroll_x: pos.x,
          scroll_y: pos.y,
          scroll_width: scroll.width(),
          scroll_height: scroll.height(),
        },
      )
    }
    KeyPressed(event) =>
      (
        @rabbita.none,
        {
          ..model,
          keydown_count: model.keydown_count + 1,
          last_key_down: event.key(),
          last_key_down_code: event.code(),
          last_key_down_repeat: event.repeat(),
        },
      )
    KeyReleased(event) =>
      (
        @rabbita.none,
        {
          ..model,
          keyup_count: model.keyup_count + 1,
          last_key_up: event.key(),
          last_key_up_code: event.code(),
        },
      )
    VisibilityChanged(hidden) =>
      (
        @rabbita.none,
        {
          ..model,
          visibility_hidden: hidden,
          visibility_count: model.visibility_count + 1,
        },
      )
    MouseMoved(event) => {
      let pos = event.client_pos()
      (
        @rabbita.none,
        {
          ..model,
          mouse_moves: model.mouse_moves + 1,
          mouse_x: pos.x,
          mouse_y: pos.y,
        },
      )
    }
  }
}

///|
fn subscriptions(model : Model, emit : Emit[Msg]) -> @sub.Sub {
  match model.active_tab {
    Every =>
      if model.ticking {
        @sub.every(1000, emit(Tick))
      } else {
        @sub.none
      }
    Resize => @sub.on_resize(v => emit(ViewportChanged(v)))
    Scroll => @sub.on_scroll(s => emit(PageScrolled(s)))
    KeyDown => @sub.on_key_down(k => emit(KeyPressed(k)))
    KeyUp => @sub.on_key_up(k => emit(KeyReleased(k)))
    VisibilityChange =>
      @sub.on_visibility_change(h => emit(VisibilityChanged(h)))
    MouseMove => @sub.on_mouse_move(m => emit(MouseMoved(m)))
  }
}

///|
fn page_class_view(tab : Val[Tab]) -> Val[String] {
  tab.map(tab => {
    if tab_id(tab) == tab_id(Scroll) {
      "page scroll-mode"
    } else {
      "page"
    }
  })
}

///|
fn tabs_view(emit : Emit[Msg], tab : Val[Tab]) -> Val[Html] {
  tab.map(active_tab => {
    div(class="tabs") <| tabs().map(tab => tab_button(emit, active_tab, tab))
  })
}

///|
fn subscription_view(tab : Val[Tab]) -> Val[Html] {
  tab.map(tab => {
    div(class="section") <| [
      p(class="section-title", "subscription"),
      code(class="snippet", tab_signature(tab)),
    ]
  })
}

///|
fn actions_view(emit : Emit[Msg], model : Val[Model]) -> Val[Html] {
  model.map(model => div(class="actions") <| active_actions(emit, model))
}

///|
fn output_view(tab : Val[Tab], model : Val[Model]) -> Val[Html] {
  tab.switch(tab => {
    model.map(model => {
      div(class="section") <| [
        p(class="section-title", "output"),
        div(class="output") <| output_lines({ ..model, active_tab: tab, }),
      ]
    })
  })
}

///|
fn scroll_spacer_view(tab : Val[Tab]) -> Val[Html] {
  tab.map(tab => {
    if tab_id(tab) == tab_id(Scroll) {
      div(class="scroll-spacer") <| [
        p(class="scroll-hint", "scroll the page to trigger on_scroll"),
      ]
    } else {
      nothing
    }
  })
}

///|
fn view(emit : Emit[Msg], model : Val[Model]) -> Val[Html] {
  let tab = model.map(model => model.active_tab)
  let page_class = page_class_view(tab)
  let tabs = tabs_view(emit, tab)
  let subscription = subscription_view(tab)
  let actions = actions_view(emit, model)
  let output = output_view(tab, model)
  let scroll_spacer = scroll_spacer_view(tab)
  let detail = actions.map2(output, (actions, output) => {
    fragment([actions, output])
  })
  let panel = tabs.map3(subscription, detail, (tabs, subscription, detail) => {
    div(class="panel") <| [
      h1(class="title", "subscriptions"),
      tabs,
      subscription,
      detail,
    ]
  })
  page_class.map3(panel, scroll_spacer, (page_class, panel, scroll_spacer) => {
    div(class=page_class) <| [
      panel, scroll_spacer,
    ]
  })
}

///|
#cfg(target="js")
fn main {
  fn app() {
    let (model, emit) = @rabbita.create_state(
      {
        active_tab: Every,
        tick_count: 0,
        ticking: true,
        resize_count: 0,
        viewport_width: @dom.window().inner_width(),
        viewport_height: @dom.window().inner_height(),
        scroll_count: 0,
        scroll_x: @dom.window().scroll_x(),
        scroll_y: @dom.window().scroll_y(),
        scroll_width: 0,
        scroll_height: 0,
        keydown_count: 0,
        last_key_down: "-",
        last_key_down_code: "-",
        last_key_down_repeat: false,
        keyup_count: 0,
        last_key_up: "-",
        last_key_up_code: "-",
        visibility_hidden: @dom.document().hidden(),
        visibility_count: 0,
        mouse_moves: 0,
        mouse_x: 0,
        mouse_y: 0,
      },
      update=fn(model, msg, emit) {
        let (cmd, model) = update(emit, msg, model)
        (model, cmd)
      },
      subscriptions~,
    )
    view(emit, model)
  }
  @rabbita.new(app).mount("app")
}
