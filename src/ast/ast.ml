type bop =
  | BPlus
  | BMinus
  | BTimes
  | BDiv

type expr =
  | EInt of Big_int.big_int
  | EBinOp of expr * bop * expr

