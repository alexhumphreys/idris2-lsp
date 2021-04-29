module Language.LSP.CodeAction.MakeCase

import Core.Context
import Core.Core
import Core.Env
import Core.Metadata
import Core.UnifyState
import Data.List
import Data.List1
import Data.String
import Idris.IDEMode.CaseSplit
import Idris.IDEMode.MakeClause
import Idris.REPL.Opts
import Idris.Syntax
import Language.JSON
import Language.LSP.Message
import Libraries.Data.List.Extra
import Libraries.Data.PosMap
import Server.Configuration
import Server.Response
import Server.Utils
import Server.Log
import System.File
import TTImp.Interactive.CaseSplit
import TTImp.TTImp
import Language.LSP.CodeAction.CaseSplit

currentLineRange : Int -> String -> Range
currentLineRange i origLine =
  MkRange (MkPosition i 0)
          (MkPosition i (cast $ Prelude.String.length origLine))

export
handleMakeCase : Ref LSPConf LSPConfiguration
         => Ref MD Metadata
         => Ref Ctxt Defs
         => Ref UST UState
         => Ref Syn SyntaxInfo
         => Ref ROpts REPLOpts
         => OneOf [Int, String, Null] -> CodeActionParams -> Core (Maybe CodeAction)
handleMakeCase msgId params = do
  let True = params.range.start.line == params.range.end.line
    | _ => do logString Debug $ "not a Make-case: range extends over multiple lines"
              pure Nothing

  meta <- get MD
  let line = params.range.start.line
  let col = params.range.start.character
  let Just name = findInTree (line, col) (nameLocMap meta)
  | Nothing =>
      do logString Debug $
           "not a Make-case: couldn't find name in tree for position (\{show line},\{show col})"
         pure Nothing

  defs <- get Ctxt
  let True = !(isHole defs name) -- should only work on holes
    | _ => do logString Debug $ "not a Make-case: \(show name) is not a hole"
              pure Nothing

  original <- originalLine line col
  let name' = dropAllNS name
  let newText = makeCase False name' original -- TODO sort out brackets arg
  let rng = currentLineRange line original
  let edit = MkTextEdit rng newText

  let docURI = params.textDocument.uri
  let dummyWorkspaceEdit = MkWorkspaceEdit
        { changes           = Just (singleton docURI [edit])
        , documentChanges   = Nothing
        , changeAnnotations = Nothing
        }
  let dummyCodeAction = MkCodeAction
        { title       = "Make case for hole ?\{show name'}"
        , kind        = Just $ Other "make-case"
        , diagnostics = Just []
        , isPreferred = Just False -- not a quickfix
        , disabled    = Nothing
        , edit        = Just dummyWorkspaceEdit
        , command     = Nothing
        , data_       = Nothing
        }
  pure $ Just dummyCodeAction
  where
    isHole : Defs -> Name -> Core Bool
    isHole defs n
        = do Just def <- lookupCtxtExact n (gamma defs)
                  | Nothing => do
                      logString Debug $ "name \{show n} is not a hole, not found in Ctxt"
                      pure False
             case definition def of
                  Hole _ _ => do
                    logString Debug $ "name \{show n}'s Def is of type Hole"
                    pure True
                  _ => pure False
