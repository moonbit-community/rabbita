///|
using @rabbita {type Cmd, type Emit, type Html, type Val}

///|
using @html {button, div, h1, p}

///|
priv struct Model {
  active : Bool
  resize_count : Int
  width : Double
  height : Double
  key_count : Int
  last_key : String
  use_new_tagger : Bool
  old_tagger_count : Int
  new_tagger_count : Int
  barrier : Int
} derive(Eq)

///|
priv enum Msg {
  SetActive(Bool)
  Resized(@common.Viewport)
  OldTaggedKey(@common.Keyboard)
  NewTaggedKey(@common.Keyboard)
  UseOldTagger
  UseNewTagger
  Barrier
}

///|
fn update(model : Model, message : Msg, _ : Emit[Msg]) -> (Model, Cmd) {
  match message {
    SetActive(active) => ({ ..model, active, }, @rabbita.none)
    Resized(viewport) =>
      (
        {
          ..model,
          resize_count: model.resize_count + 1,
          width: viewport.width,
          height: viewport.height,
        },
        @rabbita.none,
      )
    OldTaggedKey(keyboard) =>
      (
        {
          ..model,
          key_count: model.key_count + 1,
          last_key: keyboard.key(),
          old_tagger_count: model.old_tagger_count + 1,
        },
        @rabbita.none,
      )
    NewTaggedKey(keyboard) =>
      (
        {
          ..model,
          key_count: model.key_count + 1,
          last_key: keyboard.key(),
          new_tagger_count: model.new_tagger_count + 1,
        },
        @rabbita.none,
      )
    UseOldTagger => ({ ..model, use_new_tagger: false, }, @rabbita.none)
    UseNewTagger => ({ ..model, use_new_tagger: true, }, @rabbita.none)
    Barrier => ({ ..model, barrier: model.barrier + 1, }, @rabbita.none)
  }
}

///|
fn subscriptions(model : Model, emit : Emit[Msg]) -> @sub.Sub {
  if model.active {
    @sub.batch([
      @sub.on_resize(emit.map(viewport => Resized(viewport))),
      @sub.on_key_down(
        emit.map(keyboard => {
          if model.use_new_tagger {
            NewTaggedKey(keyboard)
          } else {
            OldTaggedKey(keyboard)
          }
        }),
      ),
    ])
  } else {
    @sub.none
  }
}

///|
fn app() -> Val[Html] {
  let initial : Model = {
    active: true,
    resize_count: 0,
    width: 0.0,
    height: 0.0,
    key_count: 0,
    last_key: "",
    use_new_tagger: false,
    old_tagger_count: 0,
    new_tagger_count: 0,
    barrier: 0,
  }
  let (model, emit) = @rabbita.create_state(initial, update~, subscriptions~)
  model.view(model => {
    div <| [
      h1("Subscriptions"),
      p(
        id="subscription-state",
        if model.active {
          "active"
        } else {
          "inactive"
        },
      ),
      button(on_click=emit(SetActive(false)), "Disable subscriptions"),
      button(on_click=emit(SetActive(true)), "Enable subscriptions"),
      button(on_click=emit(Barrier), "Flush barrier"),
      p(id="barrier", "barrier: \{model.barrier}"),
      p(id="resize-count", "resizes: \{model.resize_count}"),
      p(id="viewport", "viewport: \{model.width}x\{model.height}"),
      p(id="key-count", "keys: \{model.key_count}"),
      p(id="last-key", "last key: \{model.last_key}"),
      p(
        id="tagger-mode",
        if model.use_new_tagger {
          "tagger: new"
        } else {
          "tagger: old"
        },
      ),
      button(on_click=emit(UseOldTagger), "Use old tagger"),
      button(on_click=emit(UseNewTagger), "Use new tagger"),
      p(id="old-tagger-count", "old tagger: \{model.old_tagger_count}"),
      p(id="new-tagger-count", "new tagger: \{model.new_tagger_count}"),
    ]
  })
}
