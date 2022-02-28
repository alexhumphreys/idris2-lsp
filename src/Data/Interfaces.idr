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

getPDeclFCs : PDecl -> ASTShape

getPTermFCs : PTerm -> ASTShape
getPTermFCs (PRef fc x) = Single fc
getPTermFCs (PPi fc x y z argTy retTy) = Three fc (getPTermFCs argTy) (getPTermFCs retTy)
getPTermFCs (PLam fc x y z argTy scope) = Four fc (getPTermFCs z) (getPTermFCs argTy) (getPTermFCs scope)
getPTermFCs (PLet fc x pat nTy nVal scope alts) = ?getPTermFCs_rhs_3
getPTermFCs (PCase fc x xs) = ?getPTermFCs_rhs_4
getPTermFCs (PLocal fc xs scope) = ?getPTermFCs_rhs_5
getPTermFCs (PUpdate fc xs) = ?getPTermFCs_rhs_6
getPTermFCs (PApp fc x y) = ?getPTermFCs_rhs_7
getPTermFCs (PWithApp fc x y) = ?getPTermFCs_rhs_8
getPTermFCs (PNamedApp fc x y z) = ?getPTermFCs_rhs_9
getPTermFCs (PAutoApp fc x y) = ?getPTermFCs_rhs_10
getPTermFCs (PDelayed fc x y) = ?getPTermFCs_rhs_11
getPTermFCs (PDelay fc x) = ?getPTermFCs_rhs_12
getPTermFCs (PForce fc x) = ?getPTermFCs_rhs_13
getPTermFCs (PSearch fc depth) = ?getPTermFCs_rhs_14
getPTermFCs (PPrimVal fc x) = ?getPTermFCs_rhs_15
getPTermFCs (PQuote fc x) = ?getPTermFCs_rhs_16
getPTermFCs (PQuoteName fc x) = ?getPTermFCs_rhs_17
getPTermFCs (PQuoteDecl fc xs) = ?getPTermFCs_rhs_18
getPTermFCs (PUnquote fc x) = ?getPTermFCs_rhs_19
getPTermFCs (PRunElab fc x) = ?getPTermFCs_rhs_20
getPTermFCs (PHole fc bracket holename) = ?getPTermFCs_rhs_21
getPTermFCs (PType fc) = ?getPTermFCs_rhs_22
getPTermFCs (PAs fc nameFC x pattern) = ?getPTermFCs_rhs_23
getPTermFCs (PDotted fc x) = ?getPTermFCs_rhs_24
getPTermFCs (PImplicit fc) = ?getPTermFCs_rhs_25
getPTermFCs (PInfer fc) = ?getPTermFCs_rhs_26
getPTermFCs (POp full opFC x y z) = ?getPTermFCs_rhs_27
getPTermFCs (PPrefixOp full opFC x y) = ?getPTermFCs_rhs_28
getPTermFCs (PSectionL full opFC x y) = ?getPTermFCs_rhs_29
getPTermFCs (PSectionR full opFC x y) = ?getPTermFCs_rhs_30
getPTermFCs (PEq fc x y) = ?getPTermFCs_rhs_31
getPTermFCs (PBracketed fc x) = ?getPTermFCs_rhs_32
getPTermFCs (PString fc xs) = ?getPTermFCs_rhs_33
getPTermFCs (PMultiline fc indent xs) = ?getPTermFCs_rhs_34
getPTermFCs (PDoBlock fc x xs) = ?getPTermFCs_rhs_35
getPTermFCs (PBang fc x) = ?getPTermFCs_rhs_36
getPTermFCs (PIdiom fc x y) = ?getPTermFCs_rhs_37
getPTermFCs (PList full nilFC xs) = ?getPTermFCs_rhs_38
getPTermFCs (PSnocList full nilFC sx) = ?getPTermFCs_rhs_39
getPTermFCs (PPair fc x y) = ?getPTermFCs_rhs_40
getPTermFCs (PDPair full opFC x y z) = ?getPTermFCs_rhs_41
getPTermFCs (PUnit fc) = ?getPTermFCs_rhs_42
getPTermFCs (PIfThenElse fc x y z) = ?getPTermFCs_rhs_43
getPTermFCs (PComprehension fc x xs) = ?getPTermFCs_rhs_44
getPTermFCs (PRewrite fc x y) = ?getPTermFCs_rhs_45
getPTermFCs (PRange fc x y z) = ?getPTermFCs_rhs_46
getPTermFCs (PRangeStream fc x y) = ?getPTermFCs_rhs_47
getPTermFCs (PPostfixApp fc x xs) = ?getPTermFCs_rhs_48
getPTermFCs (PPostfixAppPartial fc xs) = ?getPTermFCs_rhs_49
getPTermFCs (PUnifyLog fc x y) = ?getPTermFCs_rhs_50
getPTermFCs (PWithUnambigNames fc xs x) = ?getPTermFCs_rhs_51

getPClauseFCs : PClause -> ASTShape
getPClauseFCs (MkPatClause fc lhs rhs whereblock) =
  ThreeLS fc (getPTermFCs lhs) (getPTermFCs rhs) (map getPDeclFCs whereblock)
getPClauseFCs (MkWithClause fc lhs rig wval prf xs ys) =
  ThreeLS fc (getPTermFCs lhs) (getPTermFCs wval) (map getPClauseFCs ys)
getPClauseFCs (MkImpossible fc lhs) =
  Two fc (getPTermFCs lhs)


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
