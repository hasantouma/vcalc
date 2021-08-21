open Ast

let get_bop bop =
  match bop with
  | BPlus -> (+)
  | BMinus -> (-)
  | BTimes -> ( * )
  | BDiv -> (/)

let rec interp expr =
  match expr with
  | EInt n -> n
  | EBinOp(l, bop, r) ->
      let left = interp l in
      let right = interp r in
      (get_bop bop) left right

