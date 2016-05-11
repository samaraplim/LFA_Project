%{

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);
%}

%union {
int integer;
float pfloat;
char *sval;
}

%token <pfloat> NUM
%token LEFT RIGHT
%token END
%token LS PS KILL MKDIR RMDIR CD TOUCH IFCONFIG START CALC QUIT ERROR
%left SUM LESS MULT DIV NEG
%token <sval> ARGUMENTO
%type <pfloat> Exp
%start Input
%%

Input: {
char shellName[1024] = "Samara:";
char dir[1024];
getcwd(dir, sizeof(dir));
strcat(shellName,dir);
strcat(shellName,">> ");
printf("%s",shellName);
}

| Input Line {
char shellName[1024] = "Samara:";
char dir[1024];
getcwd(dir, sizeof(dir));
strcat(shellName,dir);
strcat(shellName,">> ");
printf("%s",shellName);
}
;

Line: END
| CALC Exp END { 
printf("Resultado: %f\n", $2); }
| LS END {
system("ls");}
| PS END {
system("ps");}
| KILL NUM END {
char commandS[1024]; int n; n=(int)$2; snprintf(commandS, 1024, "kill %d", n); system(commandS);}
| MKDIR ARGUMENTO END {
char cmd[1024]; strcpy(cmd,"/bin/mkdir ");strcat(cmd, $2); system(cmd);}
| RMDIR ARGUMENTO END {
}
| CD ARGUMENTO END {
int response = 0;
char dir_path[1024];
getcwd(dir_path, sizeof(dir_path));
strcat(dir_path, "/");
strcat(dir_path, $2);
response = chdir(dir_path);
if(response != 0){
printf("Não encontrado diretório pedido\n");}
}
| TOUCH ARGUMENTO END {
char cmd[1024]; strcpy(cmd,"/bin/touch ");strcat(cmd, $2); system(cmd);}
| IFCONFIG END {
system("ifconfig");}
| START ARGUMENTO END {
char start[1024]; strcpy(start, $2); strcat(start, "&"); system(start);}
| QUIT END {
printf("Encerrando o shell\n"); exit(0);}
|ARGUMENTO END {
yyerror("Comando solicitado inválido") ; return(0);}
;

Exp:
NUM { $$ = $1; }
| Exp SUM Exp { $$ = $1 + $3; } 
| Exp LESS Exp { $$ = $1 - $3; } 
| Exp MULT Exp { $$ = $1 * $3; } 
| Exp DIV Exp { if($3)$$ = $1 / $3; else {yyerror("não existe essa divisão"); return(0);}} 
| LESS Exp %prec NEG { $$ = - $2; } 
| LEFT Exp RIGHT { $$ = $2; } 
;

%%

void yyerror(const char *s) {
fprintf(stderr, "Comando solicitado inválido. Erro: %s\n", s);}

int main() {
yyin = stdin;
do {
yyparse();
} while(!feof(yyin));
return 0;}
