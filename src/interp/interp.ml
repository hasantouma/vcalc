open Ast

let get_bop bop =
  match bop with
  | BPlus -> (+)
  | BMinus -> (-)
  | BTimes -> ( * )
  | BDiv -> (/)

let rec interp expr =
  match expr with
  | EInt n -> Some n
  | EBinOp(l, bop, r) ->
      (match interp l with
      | Some left ->
          (match interp r with
          | Some right ->
              (try Some ((get_bop bop) left right) with
                Division_by_zero -> None)
          | None -> None)
      | None -> None)

