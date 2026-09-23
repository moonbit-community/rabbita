# ripgrep README fixture

The complete, unmodified `BurntSushi/ripgrep` README is pinned to commit
`3fce3b5bb0236da2df6d99672afb8a719642eca7`.

- Source: https://github.com/BurntSushi/ripgrep/blob/3fce3b5bb0236da2df6d99672afb8a719642eca7/README.md
- SHA-256: `945622d974f65e4e141ef9726c948c2640eebd222c5b101afb6445728283921e`
- Size: 21,599 bytes; 541 lines.
- License: MIT, retained in `ripgrep-LICENSE-MIT`.

Both package tests and the website showcase embed this same file at build time.
Tests do not download or rewrite the README. Relative links remain unchanged;
the four remote images in the README require network access in the showcase.
Focused tests supplement syntax absent from the original (tasks, footnotes,
raw HTML, math and malformed/unsafe destinations).

`../ripgrep_test.mbt` is the generated embedding, checked in so a fresh package
can discover the black-box fixture before pre-build commands run. `moon tool
embed` regenerates it from the original on builds; do not edit it by hand.
