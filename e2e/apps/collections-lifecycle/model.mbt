///|
#derive(Eq)
priv struct ListModel {
  reversed : Bool
  has_first : Bool
}

///|
#derive(Eq)
priv struct RowState {
  clicks : Int32
  draft : String
}

///|
priv enum ListMsg {
  Reorder
  RemoveFirst
  AddFirst
}

///|
fn update_list(model : ListModel, message : ListMsg) -> ListModel {
  match message {
    Reorder => { ..model, reversed: !model.reversed, }
    RemoveFirst => { ..model, has_first: false, }
    AddFirst => { ..model, has_first: true, }
  }
}

///|
fn list_items(model : ListModel) -> @vector.Vector[(Int32, String)] {
  match (model.has_first, model.reversed) {
    (true, false) => @vector.from_array([(1, "one"), (2, "two")])
    (true, true) => @vector.from_array([(2, "two"), (1, "one")])
    (false, _) => @vector.from_array([(2, "two")])
  }
}

///|
#derive(Eq)
priv enum CacheTab {
  CacheA
  CacheB
}

///|
impl @rabbita.Enumerate for CacheTab with fn tag(self) {
  match self {
    CacheA => "cache-a"
    CacheB => "cache-b"
  }
}

///|
#derive(Eq)
priv enum SwitchTab {
  SwitchA
  SwitchB
}

///|
impl @rabbita.Enumerate for SwitchTab with fn tag(self) {
  match self {
    SwitchA => "switch-a"
    SwitchB => "switch-b"
  }
}
