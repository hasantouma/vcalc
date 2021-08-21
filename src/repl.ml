open Ast
open Interp
open Lexer
open Parser
open Pp

let parse_file (name : string) : expr =
  let chan = open_in name in
  let lexbuf = Lexing.from_channel chan in
  let e : expr = main token lexbuf in
  close_in chan;
  e

let handle_exit repl_in =
  if repl_in = "#quit" then
    exit 0

let rec repl () : unit =
  output_string stdout "> ";
  flush stdout;
  let repl_in = (input_line stdin) in
  handle_exit repl_in;
  let lexbuf = Lexing.from_string repl_in in
  let e : expr = main token lexbuf in
  print_endline (string_of_int (interp e));
  repl ()

let interp_file (file_name : string) : unit =
  let e : expr = parse_file file_name in
  print_endline (pp e);
  let i = interp e in
  print_endline (string_of_int i)

