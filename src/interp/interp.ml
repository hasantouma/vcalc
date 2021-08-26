open Ast
open Big_int

let get_bop bop =
  match bop with
  | BPlus -> add_big_int
  | BMinus -> sub_big_int
  | BTimes -> mult_big_int
  | BDiv -> (fun x y ->
      if (sign_big_int x >= 0 && sign_big_int y >= 0) ||
         (sign_big_int x <= 0 && sign_big_int y <= 0) then
        let x = abs_big_int x in
        let y = abs_big_int y in
        div_big_int x y
      else
        let x = abs_big_int x in
        let y = abs_big_int y in
        minus_big_int (div_big_int x y)
    )

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

