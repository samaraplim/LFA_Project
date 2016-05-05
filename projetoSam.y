%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE double
%}

%token NUM
%token SUM LESS MULT DIV
%token LEFT RIGHT
%token END
%token LS PS QUIT KILL

%left SUM LESS
%left MULT DIV
%left NEG

%start Input
%%

Input:
     | Input Line
;

Line:
     END
     | Expr END { printf("Resultado: %f\n", $1); } 
     | LS END { system("ls"); }
     | PS END { system("ps"); }
     | QUIT END { printf("Aguarde, O Shell será finalizado. \n"); exit(0); }
;

Expr:
     NUM{ $$ = $1; }
	| Expr SUM Expr { $$ = $1 + $3; } //Adição
	| Expr LESS Expr { $$ = $1 - $3; } //Subtração
	| Expr MULT Expr { $$ = $1 * $3; } //Multiplicação
	| Expr DIV Expr { if($3)$$ = $1 / $3; else {yyerror("Erro pois não é possível dividir um número por zero"); return(0);}} //Divisão com tratamento de erro
	| LESS Expr %prec NEG { $$ = - $2; } //Numeros negativos
	| LEFT Expr RIGHT { $$ = $2; } //Parenteses
;


%%

 
int yyerror(char *s) {
  printf("%s\n", s);
}

int main() {
  if (yyparse())
     fprintf(stderr, "Compilado com sucesso!\n");
  else
     fprintf(stderr, "Erro encontrado, verifique.\n");
}
