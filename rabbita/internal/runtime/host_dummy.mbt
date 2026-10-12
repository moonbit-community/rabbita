///|
priv struct DummyHost {
  stores : @slotmap.SlotMap[Store]
}

///|
impl Host for DummyHost with fn get_stores(self) {
  self.stores
}

///|
impl Context for DummyHost with fn get_base_uri(_self) {
  ""
}

///|
impl Context for DummyHost with fn inject_url_changed(_self, _url) {
  @cmd.none
}

///|
impl Context for DummyHost with fn inject_url_request(_self, _url) {
  @cmd.none
}

///|
impl Scheduler for DummyHost with fn queue_command(_self, _cmd) {
  ()
}

///|
impl Scheduler for DummyHost with fn set_url_changed_injector(_self, _injector) {
  ()
}

///|
impl Scheduler for DummyHost with fn set_url_request_injector(_self, _injector) {
  ()
}

///|
impl Host for DummyHost with fn flush(_self) {
  ()
}

///|
impl Host for DummyHost with fn cleanup(_self) {
  ()
}
