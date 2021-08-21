open Lib

let parse_cmd_line_args () =
  let speclist = [
    ("-f", Arg.String Repl.interp_file, "<file_path> Parsing file")
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
      Repl.repl ()
    end

