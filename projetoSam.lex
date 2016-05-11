%{
#include <stdio.h>
#define YY_DECL int yylex()
#include "projetoSam.tab.h"
%}
white [ \t]+
digito [0-9]
inteiro {digito}+
expoente [eE][+-]?{inteiro}
real {inteiro}("."{inteiro})?{expoente}?
%%
{white} { }
{real} { yylval.pfloat =atof(yytext);
return NUM;
}
"+" return SUM;
"-" return LESS;
"*" return MULT;
"/" return DIV;
"(" return LEFT;
")" return RIGHT;
"ls" return LS;
"ps" return PS;
"quit" return QUIT;
"calculo" return CALC;
"kill" return KILL;
"mkdir" return MKDIR;
"rmdir" return RMDIR;
"cd" return CD;
"touch" return TOUCH;
"ifconfig" return IFCONFIG;
"start" return START;
[a-zA-Z0-9./\()_]+[.]?[a-zA-Z0-9]* {
yylval.sval = strdup(yytext);
return ARGUMENTO;
}
"\n" return END;
. return ERROR;
%%
