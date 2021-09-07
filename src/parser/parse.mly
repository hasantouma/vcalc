%{
  open Ast
%}

%token <Big_int.big_int> INT
%token LP RP LB RB LCB RCB
%token PLUS MINUS TIMES DIV
%token EOF
%start main
%type <Ast.expr> main
%left PLUS MINUS
%left TIMES DIV
%%
main:
  expr EOF { $1 }
expr:
| n = INT { EInt n }
| l = expr; PLUS; r = expr { EBinOp (l, BPlus, r) }
| l = expr; MINUS; r = expr { EBinOp (l, BMinus, r) }
| l = expr; TIMES; r = expr { EBinOp (l, BTimes, r) }
| l = expr; DIV; r = expr { EBinOp (l, BDiv, r) }
| LP; e = expr; RP { e }
| LB; e = expr; RB { e }
| LCB; e = expr; RCB { e }

