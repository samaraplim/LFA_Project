%{
#define YYSTYPE double
#include "projetoSam.tab.h"
#include <stdlib.h>
%}

space [ \t]+
dig [0-9]
int {dig}+
exp [eE][+-]?{int}
float {int}("."{int})?{exp}?

%%

{space} { }
{float} { yylval=atof(yytext); 
 return NUMBER;
}

"+" return SUM;
"-" return LESS;
"*" return MULT;
"/" return DIV;
"^" return POT;
"(" return LEFT;
")" return RIGHT;
"\n" return END;
"ls" return LS;
"ps" return PS;
"quit" return QUIT;
"kill" return KILL;
"mkdir" 	return MKDIR;

%%