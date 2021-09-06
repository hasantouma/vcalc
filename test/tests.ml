open Ast
open Big_int
open OUnit2

let total_counter = ref 0

let counter = ref 0

let call_bc (s : string) =
  let in_channel : in_channel = Unix.open_process_in (Printf.sprintf "echo \"%s\" | bc" s) in
  let response : string = input_line in_channel in
  response

let test_rand _ctxt =
  while !counter < 100 do
    print_endline (string_of_int !total_counter);
    total_counter := !total_counter + 1;
    let r : expr = Generator.rand_expr 5 in
    let p = Pp.pp r in
    match Interp.interp r with
    | Some i ->
      counter := !counter + 1;
      assert_equal (string_of_big_int i) (call_bc p) ~msg:("interp: " ^ p)
    | None -> print_endline "Divide by zero case"
  done

let suite = "tests" >::: [ "test_rand" >:: test_rand ]

let _ = run_test_tt_main suite
