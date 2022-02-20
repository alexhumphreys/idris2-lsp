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

Think about a way to navigate by like next+prev sibling/parent/child

Useful stuff:
`findPointInTreeLoc` et al functions here: https://github.com/idris-community/idris2-lsp/blob/67064efabb2322bdefd64aaf2de90f074c47ab70/src/Server/Utils.idr#L175
Later useful stuff
`PrintDef` maybe whatever :printdef is doing https://github.com/idris-lang/Idris2/blob/80ff76b357a174feaaeed84a93ef7ba64a94b8d2/src/Idris/REPL.idr#L798
whatever `:eval` is doing https://github.com/idris-lang/Idris2/blob/80ff76b357a174feaaeed84a93ef7ba64a94b8d2/src/Idris/REPL.idr#L745
`PosMap` probably gonna use whatever this type is: https://github.com/idris-lang/Idris2/blob/main/src/Libraries/Data/PosMap.idr

`K` in vim makes the follow lsp log lines:
```
[DEBUG][2022-02-20 15:18:55] .../lua/vim/lsp.lua:1023   "LSP[idris2_lsp]"       "client.request"        1       "textDocument/hover"    {  position = {    character = 32,    line = 316  },  textDocument = {    uri = "file:///Users/alexhumphreys/misc/idris2-lsp/src/Server/ProcessMessage.idr"  }} <function 1>    1
[DEBUG][2022-02-20 15:18:55] .../vim/lsp/rpc.lua:347    "rpc.send"      {  id = 5,  jsonrpc = "2.0",  method = "textDocument/hover",  params = {    position = {      character = 32,      line = 316    },    textDocument = {      uri = "file:///Users/alexhumphreys/misc/idris2-lsp/src/Server/ProcessMessage.idr"    }  }}
[ERROR][2022-02-20 15:18:55] .../vim/lsp/rpc.lua:420    "rpc"   "idris2-lsp"    "stderr"        'LOG DEBUG:Communication.Channel: Received message: {"params":{"textDocument":{"uri":"file:\\/\\/\\/Users\\/alexhumphreys\\/misc\\/idris2-lsp\\/src\\/Server\\/ProcessMessage.idr"},"position":{"character":32,"line":316}},"method":"textDocument\\/hover","id":5,"jsonrpc":"2.0"}\nLOG INFO:Communication.Channel: Received request for method "textDocument/hover"\nLOG INFO:Communication.Channel: Received hover request for file:///Users/alexhumphreys/misc/idris2-lsp/src/Server/ProcessMessage.idr\nLOG DEBUG:Request.Hover: Found name Prelude.Show.show\nLOG INFO:Communication.Channel: Sent response message for method "textDocument/hover"\nLOG DEBUG:Communication.Channel: Response sent: {"jsonrpc":"2.0","id":5,"result":{"contents":{"kind":"plaintext","value":"Prelude.show : Show ty => ty -> String"}}}\n'
[DEBUG][2022-02-20 15:18:55] .../vim/lsp/rpc.lua:454    "rpc.receive"   {  id = 5,  jsonrpc = "2.0",  result = {    contents = {      kind = "plaintext",      value = "Prelude.show : Show ty => ty -> String"    }  }}
```

next step is to hook into some vim keyboard shortcut so i can execute something
