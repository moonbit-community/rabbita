# Duplix

> **Note:** This module is experimental.

Duplix is a reactive graph built from two paired strands: value dependencies and 
dirty propagation.

It aims to provide bounded retention and does not require manual disposal to 
avoid memory leak, especially in RC runtime. It also provides lazy computation,
cutoff propagation, and at-most-once recomputation per node after each update.

## Core idea

```text
parent <--derived--- child1 <--derived--- child2
```

For a reactive graph `child2 -> child1 -> parent`, Duplix splits the graph into
two strands:

- Dirty propagation: propagates dirty flags after values change.
- Value dependencies: update node values when nodes are read.

Initially, the whole graph is dirty, so the dirty-propagation edges are not
built yet:

```text
  Node(parent) --ref-> Node(child1) --ref-> Node(child2)
      |                    |                    |
     ref                  ref                  ref
      |                    |                    |
      v                    v                    v
 Dirty(parent)        Dirty(child1)       Dirty(child2)
```

When the user reads `parent`, Duplix recomputes the value through the value
dependencies and builds the dirty-propagation edges for the next update:

```text
  Node(parent) --ref-> Node(child1) --ref-> Node(child2)
      |                    |                    |
     ref                  ref                  ref
      |                    |                    |
      v                    v                    v
 Dirty(parent) <-ref-- Dirty(child1) <-ref-- Dirty(child2)
```

The next time `child2` changes, Duplix marks the related dirty nodes and cuts
the dirty-propagation edges. This brings the graph back to the initial dirty
state, where the edges can be rebuilt on demand by the next read.

At no point does the value graph contain a reference cycle.

Dynamic nodes (`bind` and `assoc`) pull their control inputs first, update the
active dependency edges, and only then pull the selected branches. A removed or
replaced branch is detached before its pending updates are evaluated.

For `assoc`, an index derived from the source updates value cells for the active
keys. Each row projection depends on that index, so it sees the current row even
when another consumer pulls it before the collection output. The cells contain
values, not row graphs, which avoids a reference cycle from the index back to
its dependents. Removing a key detaches its row projection from the index;
retained row handles keep their last value, and reinsertion creates a new cell
and branch lifetime. No reactive input writes are needed during reconciliation.


