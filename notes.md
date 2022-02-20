want to add semantic selections, maybe then navigation and evaluation

general design:

example.
```
(x + foo) + (y + z)
```

- given a location in a source file (filename, line, column) (`_,0,6` would correspond to cursor on first letter of `foo` above)
- find the bounds of the innermost expression (`_,0,6` -> `_,0,8`)
- from there, have some way of finding the bounds of the parent expression (`_,0,1` -> `_,0,8` would be `x + foo`. 
- and keep finding parent expressions. next one in the example is the topmost expression `(x + foo) + (y + z)`, so `_,0,0` -> `_,0,18`

Probably best to use the raw source AST then later IRs as this is so tied to the positions in the file. We'll see how that works with evaluation later.

Useful stuff:
`findPointInTreeLoc` et al functions here: https://github.com/idris-community/idris2-lsp/blob/67064efabb2322bdefd64aaf2de90f074c47ab70/src/Server/Utils.idr#L175
Later useful stuff
`PrintDef` maybe whatever :printdef is doing https://github.com/idris-lang/Idris2/blob/80ff76b357a174feaaeed84a93ef7ba64a94b8d2/src/Idris/REPL.idr#L798
whatever `:eval` is doing https://github.com/idris-lang/Idris2/blob/80ff76b357a174feaaeed84a93ef7ba64a94b8d2/src/Idris/REPL.idr#L745

