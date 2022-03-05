module Data.Interfaces

import Core.FC
import Libraries.Data.PosMap
import Idris.Syntax

data ASTShape
  = Single FC
  | Two FC ASTShape
  | TwoLS FC ASTShape (List ASTShape)
  | Three FC ASTShape ASTShape
  | ThreeLS FC ASTShape ASTShape (List ASTShape)
  | Four FC ASTShape ASTShape ASTShape
  | FiveLS FC ASTShape ASTShape ASTShape ASTShape (List ASTShape)

Measure PTerm where
  measure p =
    let fc = getPTermLoc p
      in case fc of
              (MkFC x y z) => (y, z)
              (MkVirtualFC x y z) => (y, z)
              EmptyFC => ?lkjl_2

go : FC -> a -> PosMap (NonEmptyFC, a) -> PosMap (NonEmptyFC, a)
go fc x pm = let nonEmpty = isNonEmptyFC fc in
  case nonEmpty of
       Nothing => pm
       (Just z) => insert (z, x) pm

getPDeclFCs : PosMap (NonEmptyFC, PDecl) -> PDecl -> PosMap (NonEmptyFC, PDecl)

getPTermFCs : PosMap (NonEmptyFC, PTerm) -> PTerm -> PosMap (NonEmptyFC, PTerm)
getPTermFCs pm p@(PRef fc x) =
  go fc p pm
getPTermFCs pm p@(PPi fc x y z argTy retTy) = ?lkjlkk12
getPTermFCs pm p@(PLam fc x y z argTy scope) = ?lkjlkk13
getPTermFCs pm p@(PLet fc x pat nTy nVal scope alts) = ?getPTermFCs_rhs_3
getPTermFCs pm p@(PCase fc x xs) = ?getPTermFCs_rhs_4
getPTermFCs pm p@(PLocal fc xs scope) = ?getPTermFCs_rhs_5
getPTermFCs pm p@(PUpdate fc xs) = ?getPTermFCs_rhs_6
getPTermFCs pm p@(PApp fc x y) = ?getPTermFCs_rhs_7
getPTermFCs pm p@(PWithApp fc x y) = ?getPTermFCs_rhs_8
getPTermFCs pm p@(PNamedApp fc x y z) = ?getPTermFCs_rhs_9
getPTermFCs pm p@(PAutoApp fc x y) = ?getPTermFCs_rhs_10
getPTermFCs pm p@(PDelayed fc x y) = ?getPTermFCs_rhs_11
getPTermFCs pm p@(PDelay fc x) = ?getPTermFCs_rhs_12
getPTermFCs pm p@(PForce fc x) = ?getPTermFCs_rhs_13
getPTermFCs pm p@(PSearch fc depth) = ?getPTermFCs_rhs_14
getPTermFCs pm p@(PPrimVal fc x) = ?getPTermFCs_rhs_15
getPTermFCs pm p@(PQuote fc x) = ?getPTermFCs_rhs_16
getPTermFCs pm p@(PQuoteName fc x) = ?getPTermFCs_rhs_17
getPTermFCs pm p@(PQuoteDecl fc xs) = ?getPTermFCs_rhs_18
getPTermFCs pm p@(PUnquote fc x) = ?getPTermFCs_rhs_19
getPTermFCs pm p@(PRunElab fc x) = ?getPTermFCs_rhs_20
getPTermFCs pm p@(PHole fc bracket holename) = ?getPTermFCs_rhs_21
getPTermFCs pm p@(PType fc) = ?getPTermFCs_rhs_22
getPTermFCs pm p@(PAs fc nameFC x pattern) = ?getPTermFCs_rhs_23
getPTermFCs pm p@(PDotted fc x) = ?getPTermFCs_rhs_24
getPTermFCs pm p@(PImplicit fc) = ?getPTermFCs_rhs_25
getPTermFCs pm p@(PInfer fc) = ?getPTermFCs_rhs_26
getPTermFCs pm p@(POp full opFC x y z) = ?getPTermFCs_rhs_27
getPTermFCs pm p@(PPrefixOp full opFC x y) = ?getPTermFCs_rhs_28
getPTermFCs pm p@(PSectionL full opFC x y) = ?getPTermFCs_rhs_29
getPTermFCs pm p@(PSectionR full opFC x y) = ?getPTermFCs_rhs_30
getPTermFCs pm p@(PEq fc x y) = ?getPTermFCs_rhs_31
getPTermFCs pm p@(PBracketed fc x) = ?getPTermFCs_rhs_32
getPTermFCs pm p@(PString fc xs) = ?getPTermFCs_rhs_33
getPTermFCs pm p@(PMultiline fc indent xs) = ?getPTermFCs_rhs_34
getPTermFCs pm p@(PDoBlock fc x xs) = ?getPTermFCs_rhs_35
getPTermFCs pm p@(PBang fc x) = ?getPTermFCs_rhs_36
getPTermFCs pm p@(PIdiom fc x y) = ?getPTermFCs_rhs_37
getPTermFCs pm p@(PList full nilFC xs) = ?getPTermFCs_rhs_38
getPTermFCs pm p@(PSnocList full nilFC sx) = ?getPTermFCs_rhs_39
getPTermFCs pm p@(PPair fc x y) = ?getPTermFCs_rhs_40
getPTermFCs pm p@(PDPair full opFC x y z) = ?getPTermFCs_rhs_41
getPTermFCs pm p@(PUnit fc) = ?getPTermFCs_rhs_42
getPTermFCs pm p@(PIfThenElse fc x y z) = ?getPTermFCs_rhs_43
getPTermFCs pm p@(PComprehension fc x xs) = ?getPTermFCs_rhs_44
getPTermFCs pm p@(PRewrite fc x y) = ?getPTermFCs_rhs_45
getPTermFCs pm p@(PRange fc x y z) = ?getPTermFCs_rhs_46
getPTermFCs pm p@(PRangeStream fc x y) = ?getPTermFCs_rhs_47
getPTermFCs pm p@(PPostfixApp fc x xs) = ?getPTermFCs_rhs_48
getPTermFCs pm p@(PPostfixAppPartial fc xs) = ?getPTermFCs_rhs_49
getPTermFCs pm p@(PUnifyLog fc x y) = ?getPTermFCs_rhs_50
getPTermFCs pm p@(PWithUnambigNames fc xs x) = ?getPTermFCs_rhs_51

getPClauseFCs : PosMap PClause -> PClause -> PosMap (NonEmptyFC, PClause)
getPClauseFCs pm (MkPatClause fc lhs rhs whereblock) = ?lkja123
getPClauseFCs pm (MkWithClause fc lhs rig wval prf xs ys) = ?lkja124
getPClauseFCs pm (MkImpossible fc lhs) = ?lkja125


mutual
  Functor PTerm' where
    map a b = ?foo5

  Functor PDecl' where
    map a b = ?foo1

  Functor PClause' where
    map a b = ?foo3

{-
((0,0), (1,18)) "sqrt"
((0,7), (1,17)) "-"
((0,10), (0,28)) "*"
((0,13), (0,19)) "+"
((0,23), (0,27)) "/"
((1,10), (1,16)) "-"
-}

data Expr = MkExpr (FilePos, FilePos) string

Measure Expr where
  measure (MkExpr fp _) = fp

exprLs : List (Expr)
exprLs =
  [ MkExpr ((0,0), (1,18)) "sqrt"
  , MkExpr ((0,7), (1,17)) "-"
  , MkExpr ((0,10), (0,28)) "*"
  , MkExpr ((0,13), (0,19)) "+"
  , MkExpr ((0,23), (0,27)) "/"
  , MkExpr ((1,10), (1,16)) "-"
  ]

ex : PosMap Expr
ex = empty

addStuff : PosMap Expr
addStuff = foldl (flip insert) ex exprLs

exp11 : List Expr
exp11 = searchPos (0,24) addStuff
