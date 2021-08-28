open Ast
open Big_int
open Generator
open Interp
open Parser.Lex
open Parser.Parse
open Pp
open Viz

let parse_file (name : string) : expr =
  let chan = open_in name in
  let lexbuf = Lexing.from_channel chan in
  let e : expr = main token lexbuf in
  close_in chan;
  e

let handle_exit repl_in =
  if repl_in = "#quit" then
    exit 0

let handle_display (e : expr) : unit =
  match interp e with
  | Some n ->
      let answer = string_of_big_int n in
      print_endline ((pp e) ^ " = " ^ answer)
  | None ->
      print_endline "Error: Divide by zero"

let rec repl () : unit =
  output_string stdout "> ";
  flush stdout;
  let repl_in = (input_line stdin) in
  handle_exit repl_in;
  let lexbuf = Lexing.from_string repl_in in
  let e : expr = main token lexbuf in
  handle_display e;
  repl ()

let interp_file (file_name : string) : unit =
  let e : expr = parse_file file_name in
  handle_display e

let interp_stdin (s : string) : unit =
  let lexbuf = Lexing.from_string s in
  let e : expr = main token lexbuf in
  handle_display e;
  exit 0

let visualize (file_name : string) : unit =
  let e : expr = parse_file file_name in
  handle_display e;
  write_expr_to_graphviz e

let rand_expr (viz : bool) (n : int) : unit =
  let r : expr = rand_expr n in
  handle_display r;
  if viz then
    write_expr_to_graphviz r
  else
    ()

