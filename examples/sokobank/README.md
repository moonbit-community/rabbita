# Sokoban Time Travel

This example is a small Sokoban game built with Rabbita and The Elm Architecture.

The model stores a persistent `@immut/vector.Vector[World]` history plus a cursor.
Moving after rewinding truncates future states and appends a new immutable snapshot.

## Run

```bash
moon install moonbit-community/warren
warren dev
```
