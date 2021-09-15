open Ast
open Big_int

let pp_bop bop =
  match bop with
  | BPlus -> "+"
  | BMinus -> "-"
  | BTimes -> "*"
  | BDiv -> "/"

let rec pp expr =
  match expr with
  | EInt n ->
    let s = string_of_big_int n in
    if sign_big_int n < 0 then
      "(" ^ s ^ ")"
    else
      s
  | EBinOp (l, bop, r) ->
    let left = pp l in
    let right = pp r in
    "(" ^ left ^ " " ^ pp_bop bop ^ " " ^ right ^ ")"
