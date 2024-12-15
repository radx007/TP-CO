%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
void yyerror(const char *s);
int yylex(void);

// Symbol table to manage variables
 typedef struct {
 char name[32];
 int value;
 } variable;


 #define MAX_VARIABLES 100

 variable symbol_table[MAX_VARIABLES];

 int symbol_count = 0;

 // Functions to manage the symbol table
 int get_variable_value(const char *name);
 void set_variable_value(const char *name, int value);


%}

/* Declare value type for symbols */
%union {
    int int_value;
    bool bool_value;
    char *name;
}

/* Declare tokens and their types */
%token <int_value> NUMBER
%token <bool_value> BOOLEAN
%token <name> ID
%token PLUS MINUS TIMES DIVIDE MODULO RESOIT
%token GT LT GTE LTE EQ NEQ
%token AND OR NOT
%token IF THEN ELSE
%token NEWLINE
%token QUIT
%token LPAREN RPAREN
%token QUESTION COLON

/* Declare type for non-terminals */
%type <int_value> expression arithmetic_expr term factor conditional_stmt 
%type <bool_value> boolean_expr comparison_expr logical_expr

/* Define operator precedence (lowest to highest) */
%left RESOIT 
%right QUESTION COLON
%left OR
%left AND
%right NOT
%left LT GT LTE GTE EQ NEQ
%left PLUS MINUS
%left TIMES DIVIDE MODULO
%right UMINUS

%%
/* Grammar rules */
calculator:
    /* empty */
    | calculator line
;

line:
    NEWLINE
    | expression NEWLINE          { printf("Result: %d\n", $1); }
    | boolean_expr NEWLINE        { printf("Boolean Result: %s\n", $1 ? "true" : "false"); }
    | QUIT NEWLINE                { printf("Goodbye!\n"); exit(0); }
;

/* Unified expression rule */
expression:
    arithmetic_expr
    | conditional_stmt
    | ID RESOIT LPAREN comparison_expr RPAREN QUESTION expression COLON expression {
       
        $$ = $4 ? $7 : $9;
    1}
;
 

/* Arithmetic Expressions */
arithmetic_expr:
    term
    | arithmetic_expr PLUS term   { $$ = $1 + $3; }
    | arithmetic_expr MINUS term  { $$ = $1 - $3; }
;

term:
    factor
    | term TIMES factor           { $$ = $1 * $3; }
    | term DIVIDE factor          {
        if ($3 == 0) {
            yyerror("division by zero");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
    | term MODULO factor          {
        if ($3 == 0) {
            yyerror("modulo by zero");
            $$ = 0;
        } else {
            $$ = $1 % $3;
        }
    }
;

factor:
    NUMBER                        { $$ = $1; }
    | LPAREN arithmetic_expr RPAREN { $$ = $2; }
    | MINUS factor %prec UMINUS   { $$ = -$2; }
    | ID                          { $$ = get_variable_value($1); }
    ;

/* Boolean Expressions */
boolean_expr:
    BOOLEAN                      { $$ = $1; }
    | comparison_expr            { $$ = $1; }
    | logical_expr               { $$ = $1; }
    | NOT boolean_expr           { $$ = !$2; }
;

comparison_expr:
    arithmetic_expr GT arithmetic_expr   { $$ = $1 > $3; }
    | arithmetic_expr LT arithmetic_expr { $$ = $1 < $3; }
    | arithmetic_expr GTE arithmetic_expr { $$ = $1 >= $3; }
    | arithmetic_expr LTE arithmetic_expr { $$ = $1 <= $3; }
    | arithmetic_expr EQ arithmetic_expr { $$ = $1 == $3; }
    | arithmetic_expr NEQ arithmetic_expr { $$ = $1 != $3; }
;

logical_expr:
    boolean_expr AND boolean_expr { $$ = $1 && $3; }
    | boolean_expr OR boolean_expr { $$ = $1 || $3; }
    | LPAREN boolean_expr RPAREN   { $$ = $2; }
;

/* Conditional Statements */
conditional_stmt:
    IF boolean_expr THEN arithmetic_expr ELSE arithmetic_expr {
        $$ = $2 ? $4 : $6;
    }
;

%%

 /* Symbol table functions */
 int get_variable_value(const char *name) {
 for (int i = 0; i < symbol_count; i++) {
 if (strcmp(symbol_table[i].name, name) == 0) {
 return symbol_table[i].value;
 }
 }
 printf("Error: Variable '%s' is not defined\n", name);
 exit(1);
 }


void set_variable_value(const char *name, int value) {
 for (int i = 0; i < symbol_count; i++) {
 if (strcmp(symbol_table[i].name, name) == 0) {
 symbol_table[i].value = value;
 return;
 }
 }
 if (symbol_count < MAX_VARIABLES) {
 strcpy(symbol_table[symbol_count].name, name);
 symbol_table[symbol_count].value = value;
 symbol_count++;
 } else {
 printf("Error: Symbol table overflow\n");
 exit(1);
 }
 }

 
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    printf("Extended Calculator\n");
    printf("Supports arithmetic, boolean expressions, and conditionals\n");
    printf("Enter expressions, or 'quit' to exit\n");
    yyparse();
    return 0;
}
