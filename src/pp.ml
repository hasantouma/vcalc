open Ast

let pp_bop bop =
  match bop with
  | BPlus -> "+"
  | BMinus -> "-"
  | BTimes -> "*"
  | BDiv -> "/"

let pp expr =
  let rec pp_aux expr indent =
    match expr with
    | EInt n -> string_of_int n
    | EBinOp(l, bop, r) ->
        let left = pp_aux l (indent + 3) in
        let spaces = String.make (indent + 3) ' ' in
        let right = pp_aux r (indent + 3) in
        "(" ^ left ^ "\n" ^ spaces ^ (pp_bop bop) ^ right ^ ")"
  in pp_aux expr 0

