%{
#include <stdio.h>
#include <stdlib.h>
%}

%option yylineno

%%

(if|else|while|for) {
    printf("mot cle: %s\n", yytext);
}

[a-zA-Z_][a-zA-Z0-9_]* {
    printf("Identifier: %s\n", yytext);
}

[0-9]+(\.[0-9]+)? {
    printf("numero: %s\n", yytext);
}

\"[^"]*\" {
    printf("String: %s\n", yytext);
}

(+|-|*|/|=) {
    printf("OPERATOR: %s\n", yytext);
}

(\(|\)|\{|\}|;) {
    printf("Delimiters: %s\n", yytext);
}


\n {
    printf("Line %d Done\n", yylineno - 1); 
}

. {
   
}

%%

int main() {
    printf("Starting lexical analysis...\n");
    yylineno = 1;       
    yylex();            
    printf("Total lines processed: %d\n", yylineno);
    return 0;
}

int yywrap() {
    return 1; // Signals end of input
}
