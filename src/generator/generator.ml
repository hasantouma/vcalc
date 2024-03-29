open Ast
open Big_int

(* Initialize random generator *)
let () = Random.init (int_of_float (Unix.time ()))

(* Initialize float generator - for coin flip *)
let random_float_gen : float -> float = Random.float

let next_float () : float = random_float_gen 1.0

(* Initialize int generator - for random value *)
let random_int_gen : int -> int = Random.int

let next_int () : big_int = big_int_of_int (random_int_gen 1024)

let random_bop () =
  match next_float () with
  | f when f < 0.25 -> BPlus
  | f when f >= 0.25 && f < 0.5 -> BMinus
  | f when f >= 0.5 && f < 0.75 -> BTimes
  | _ -> BDiv

let rec rand_expr n =
  if n = 0 then
    let sign =
      if next_float () < 0.5 then
        1
      else
        -1
    in
    let n = mult_int_big_int sign (next_int ()) in
    EInt n
  else
    let left = rand_expr (n - 1) in
    let right = rand_expr (n - 1) in
    let bop = random_bop () in
    EBinOp (left, bop, right)
