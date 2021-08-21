%{
  open Ast
%}

%token <int> INT
%token LP RP LB RB LCB RCB
%token PLUS MINUS TIMES DIV
%token EOF
%start main
%type <Ast.expr> main
%left PLUS MINUS
%left TIMES DIV
%nonassoc LB
%%
main:
  expr EOF { $1 }
expr:
| INT { EInt $1 }
| expr PLUS expr { EBinOp($1, BPlus, $3) }
| expr MINUS expr { EBinOp($1, BMinus, $3) }
| expr TIMES expr { EBinOp($1, BTimes, $3) }
| expr DIV expr { EBinOp($1, BDiv, $3) }
| LP expr RP { $2 }
| LB expr RB { $2 }
| LCB expr RCB { $2 }

