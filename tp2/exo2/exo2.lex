%{
#include <stdio.h>
#include <stdlib.h>
%}

%option yylineno

%%

"/\*"([^\*]|\*+[^/])*"\*/" {
    printf("Valid multi-line comment: %s\n", yytext);
}

"//".*  {
    printf("Single-line comment: %s\n", yytext);
}

. { 
    /* Catch-all for other characters */
}

%%

int main() {
    printf("Starting lexical analysis...\n");
    yylex();            
    printf("Total lines processed: %d\n", yylineno);  
    return 0;
}

int yywrap() {
    return 1; // Signals the end of the input
}
