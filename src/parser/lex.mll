{
 open Parse
 exception Eof
}
rule token = parse
  [' ' '\t' '\n' '\r']	{ token lexbuf }
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
| ['0'-'9']+ as lxm { INT(int_of_string lxm) }
| eof { EOF }
| _ as lxm { Printf.printf "Illegal character %c" lxm; failwith "Bad input" }


