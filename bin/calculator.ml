open Repl

let parse_cmd_line_args () =
  let speclist = [
    ("-f", Arg.String interp_file, "<file_path> Parsing file");
    ("-g", Arg.Int interp_rand_expr, "<int> Generate random program of size n");
    ("-v", Arg.String visualize, "<file_path> File to visualize")
  ] in
  let usage_msg = "Visual Calculator" in
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

