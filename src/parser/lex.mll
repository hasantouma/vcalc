{
 open Big_int
 open Exceptions
 open Parse
 exception Eof
}

let white = [' ' '\t' '\n' '\r']*
rule token = parse
  white	{ token lexbuf }
| '(' { LP }
| ')' { RP }
| '[' { LB }
| ']' { RB }
| '{' { LCB }
| '}' { RCB }
| '+' { PLUS }
| '-' { MINUS }
| '*' { TIMES }
| '/' { DIV }
| ('-'?)['0'-'9']+ as lxm { INT(big_int_of_string lxm) }
| eof { EOF }
| _ as lxm { raise (BadInput (Printf.sprintf "Illegal character %c" lxm)) }


