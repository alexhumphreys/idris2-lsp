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

`<leader>j` to jump to metavars makes the following log lines:
```
[DEBUG][2022-02-20 15:35:25] .../lua/vim/lsp.lua:1023   "LSP[idris2_lsp]"       "client.request"        1       "workspace/executeCommand"      {  command = "metavars"}        <function 1>    1
[DEBUG][2022-02-20 15:35:25] .../vim/lsp/rpc.lua:347    "rpc.send"      {  id = 5,  jsonrpc = "2.0",  method = "workspace/executeCommand",  params = {    command = "metavars"  }}
[ERROR][2022-02-20 15:35:25] .../vim/lsp/rpc.lua:420    "rpc"   "idris2-lsp"    "stderr"        'LOG DEBUG:Communication.Channel: Received message: {"method":"workspace\\/executeCommand","jsonrpc":"2.0","id":5,"params":{"command":"metavars"}}\nLOG INFO:Communication.Channel: Received request for method "workspace/executeCommand"\nLOG INFO:Communication.Channel: Received metavars command request\nLOG INFO:Request.Command.Metavars: Fetching metavars\nLOG INFO:Request.Command.Metavars: Metavars fetched, found 1\nLOG INFO:Communication.Channel: Sent response message for method "workspace/executeCommand"\nLOG DEBUG:Communication.Channel: Response sent: {"jsonrpc":"2.0","id":5,"result":[{"name":"Language.LSP.Message.Hover.bar","location":{"uri":"file:///Users/alexhumphreys/misc/idris2-lsp/src/Language/LSP/Message/Hover.idr","range":{"start":{"line":55,"character":6},"end":{"line":55,"character":10}}},"type":"String","premises":[]}]}\n'
[DEBUG][2022-02-20 15:35:25] .../vim/lsp/rpc.lua:454    "rpc.receive"   {  id = 5,  jsonrpc = "2.0",  result = { {      location = {        range = {          end = {            character = 10,            line = 55          },          start = {            character = 6,            line = 55          }        },        uri = "file:///Users/alexhumphreys/misc/idris2-lsp/src/Language/LSP/Message/Hover.idr"      },      name = "Language.LSP.Message.Hover.bar",      premises = {},      type = "String"    } }}
```

next step is to hook into some vim keyboard shortcut so i can execute something. metavars command seems easiest to copy

in vimscript use `:call cursor(l,c)` to place to cursor at line l and column c
`25|` in vim normal mode will jump to character 25 of the current line
`10gg` will jump to line 10 in normal mode.

tail lsp/neovim with `tail -f /Users/alexhumphreys/.cache/nvim/lsp.log`

can call my random executeCommand stuff with:
```
:lua vim.lsp.buf_request(0, 'workspace/executeCommand', { command = 'alex' })
```

`processMap` here is an interesting function: https://github.com/idris-lang/Idris2/blob/1011cc6162bad580b0c51237c86fbf4fe2035fbe/src/Idris/ProcessIdr.idr#L278

it also calls `Parser.Source.runParser` which could be useful: https://github.com/idris-lang/Idris2/blob/1011cc6162bad580b0c51237c86fbf4fe2035fbe/src/Idris/ProcessIdr.idr#L333

conversation on the discord about this: https://discord.com/channels/827106007712661524/861619141470584852/947042105245700167

that `runParser` call in `processMap` returns a Module: https://github.com/idris-lang/Idris2/blob/c8a5ad6d97519077cd011113ab445f821d42f6e0/src/Idris/Syntax.idr#L649

`Module` has a list of `PDecl`: https://github.com/idris-lang/Idris2/blob/c8a5ad6d97519077cd011113ab445f821d42f6e0/src/Idris/Syntax.idr#L421

`PDecl` contains `PTerm`: https://github.com/idris-lang/Idris2/blob/c8a5ad6d97519077cd011113ab445f821d42f6e0/src/Idris/Syntax.idr#L65

so if i traverse the list of `PDecl`, then traverse each `PDecl` to get the `PTerm`s, I should be able to get a tree of `FC` ranges I need!

lets take an example:

```
(sqrt (- (* (+ x w) (/ y z))
         (- t u)))
```
sqrt (0,0)(1,18)
- (0,7)(1,17)
* (0,10)(0,28)
+ (0,13)(0,19)
/ (0,23)(0,27)
- (1,10)(1,16)

Next to add the terms, then put that into a finger tree and see what happens

hmm might want to use NonEmptyFC since i'm only interested in stuff that ends up in the text files.

gonna try make a PosMap (NonEmptyFC, PTerm), see if that's all the info i need. Worried it might be too big to put in the metadata, let's see.
