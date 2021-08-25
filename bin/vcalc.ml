open Repl

let parse_cmd_line_args () =
  let speclist = [
    ("-f", Arg.String interp_file, "<file_path> Parsing file");
    ("-g", Arg.Int (rand_expr false), "<int> Generate random program of size n");
    ("-gv", Arg.Int (rand_expr true), "<int> Generate, and visualize, random program of size n");
    ("-v", Arg.String visualize, "<file_path> File to visualize")
  ] in
  let usage_msg = "vcalc (Visual Calculator)" in
  Arg.parse speclist print_endline usage_msg



let () =
  let args_len = Array.length Sys.argv in
  if args_len > 1 then
    parse_cmd_line_args ()
  else
    begin
      print_endline "Welcome to the 'Visual Calculator' REPL";
      repl ()
    end

