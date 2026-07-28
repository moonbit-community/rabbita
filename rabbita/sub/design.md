# Design of Subscriptions

## Diff problem in VDOM and Subscriptions

The `subscriptions` function returns a list of `Sub` each time the Model is updated.
When new subscriptions appear, they should be registered. When existing ones are 
no longer present, they should be unregistered.

The main challenge is determining whether a subscription is truly new.
In practice, closures cannot be compared reliably. For example:

```mbt nocheck
fn subscriptions(model : Model, emit : Emit[Msg]) -> Sub {
  @sub.on_resize(rect => emit(Resize(rect)))
}
```

This function creates a new closure inside on_resize on every call, even when the 
logic remains unchanged.

A straightforward approach is to always unregister the old subscription and 
register a new one, which means updating DOM event listeners every time. This 
approach is inefficient.

A better solution is to keep a stable reference to the closure. Event listeners 
call this reference when triggered. The subscriptions function only updates the 
reference, so there is no need to recreate listeners on every update. This is 
the approach used by frameworks such as Elm, React, and Vue.

## Extensible Subscriptions 

To support splitting APIs into separate packages, such as moving WebSocket 
related commands and subscriptions into a dedicated module, it is useful for 
the Sub type to be extensible.

As discussed earlier, solving the diffing problem requires comparing old and 
new subscriptions and updating the stored closure reference.

If the API is defined using trait objects, this becomes difficult because the 
trait is not object safe:

```mbt nocheck
trait ExtensibleSub {
  update(Self, Self) -> Unit
}
```

An extensible enum works well in this scenario:

```mbt check
type Key = Int 

suberror ExtSub {
  Sub1(Key, Ref[() -> Unit])
  Sub2(Key, String, Ref[() -> Unit])
}

fn update(x : Error, y : Error) -> Unit {
  match (x,y) {
    (Sub1(k1, f1), Sub1(k2, f2)) if k1 == k2 => {
      f1.val = f2.val 
      ... // add listener
    }
    (Sub2(k1, p1, f1), Sub2(k2, p2, f2)) if k1 == k2 && p1 == p2 => {
      f1.val = f2.val 
      ... // add listener
    }
    ...
  }
}

fn add_sub(payload : Error, need_update : (Error,Error) -> Bool) -> Unit {
  // store the hook for later use
}
```
