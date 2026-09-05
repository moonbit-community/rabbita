///|
using @rabbita {type Cmd, type Emit, type Html, type Val}

///|
using @html {button, div, h1, p}

///|
extern "js" fn resolved(value : String) -> @js.Promise = "(value) => Promise.resolve(value)"

///|
extern "js" fn rejected() -> @js.Promise = "() => Promise.reject(new Error('expected failure'))"

///|
priv struct Model {
  initialized : String
  delayed : String
  performed : String
  attempted : String
  batch_a : Bool
  batch_b : Bool
} derive(Eq)

///|
priv enum Msg {
  Initialized(String)
  StartDelay
  DelayFinished
  StartPerform
  PerformFinished(String)
  StartAttempt
  AttemptFinished(Result[String, Error])
  StartBatch
  BatchA
  BatchB
}

///|
fn update(model : Model, message : Msg, emit : Emit[Msg]) -> (Model, Cmd) {
  match message {
    Initialized(value) => ({ ..model, initialized: value, }, @rabbita.none)
    StartDelay =>
      (
        { ..model, delayed: "waiting", },
        @rabbita.delay(emit(DelayFinished), 1000),
      )
    DelayFinished => ({ ..model, delayed: "finished", }, @rabbita.none)
    StartPerform =>
      (
        { ..model, performed: "running", },
        @rabbita.perform(value => emit(PerformFinished(value)), async fn() noraise {
          resolved("performed").wait().cast() catch {
            _ => "unexpected failure"
          }
        }),
      )
    PerformFinished(value) => ({ ..model, performed: value, }, @rabbita.none)
    StartAttempt =>
      (
        { ..model, attempted: "running", },
        @rabbita.attempt(result => emit(AttemptFinished(result)), async fn() {
          rejected().wait().cast()
        }),
      )
    AttemptFinished(result) =>
      (
        {
          ..model,
          attempted: match result {
            Ok(value) => value
            Err(_) => "failed"
          },
        },
        @rabbita.none,
      )
    StartBatch =>
      (
        { ..model, batch_a: false, batch_b: false, },
        @rabbita.batch([emit(BatchA), emit(BatchB)]),
      )
    BatchA => ({ ..model, batch_a: true, }, @rabbita.none)
    BatchB => ({ ..model, batch_b: true, }, @rabbita.none)
  }
}

///|
fn app() -> Val[Html] {
  let (model, emit) = @rabbita.create_state_with_init(
    init=fn(emit) {
      (
        {
          initialized: "starting",
          delayed: "idle",
          performed: "idle",
          attempted: "idle",
          batch_a: false,
          batch_b: false,
        },
        @rabbita.perform(value => emit(Initialized(value)), async fn() noraise {
          resolved("ready").wait().cast() catch {
            _ => "unexpected failure"
          }
        }),
      )
    },
    update~,
  )
  model.view(model => {
    div <| [
      h1("Commands and async"),
      p(id="init-command", "init: \{model.initialized}"),
      button(on_click=emit(StartDelay), "Run delayed command"),
      p(id="delay-status", "delay: \{model.delayed}"),
      button(on_click=emit(StartPerform), "Run perform"),
      p(id="perform-status", "perform: \{model.performed}"),
      button(on_click=emit(StartAttempt), "Run failing attempt"),
      p(id="attempt-status", "attempt: \{model.attempted}"),
      button(on_click=emit(StartBatch), "Run batch"),
      p(
        id="batch-status",
        if model.batch_a && model.batch_b {
          "batch: complete"
        } else {
          "batch: incomplete"
        },
      ),
    ]
  })
}
