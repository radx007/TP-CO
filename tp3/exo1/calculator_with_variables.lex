%{
#include <stdbool.h>
#include "calculator_with_variables.tab.h"
void yyerror(const char *s);
%}
%option noyywrap
%option yylineno

/* Definitions */
DIGIT [0-9]+
WHITESPACE [ \t]+

%%

{WHITESPACE}               {  }
{DIGIT}                    { yylval.int_value = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*     { yylval.name = strdup(yytext); return ID; }

"="                        { return RESOIT; }

"+"                        { return PLUS; }
"-"                        { return MINUS; }
"*"                        { return TIMES; }
"/"                        { return DIVIDE; }
"%"                        { return MODULO; }

">"                        { return GT; }
"<"                        { return LT; }
">="                       { return GTE; }
"<="                       { return LTE; }
"=="                       { return EQ; }
"!="                       { return NEQ; }

"and"                      { return AND; }
"or"                       { return OR; }
"not"                      { return NOT; }

"true"                     { yylval.bool_value = true; return BOOLEAN; }
"false"                    { yylval.bool_value = false; return BOOLEAN; }

"?"                        { return QUESTION; }
":"                        { return COLON; }

"("                        { return LPAREN; }
")"                        { return RPAREN; }

"quit"                     { return QUIT; }

\n                         { return NEWLINE; }

.                          { yyerror("Invalid character"); }
