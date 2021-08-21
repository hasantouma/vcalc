type bop =
  | BPlus
  | BMinus
  | BTimes
  | BDiv

type expr =
  | EInt of int
  | EBinOp of expr * bop * expr

