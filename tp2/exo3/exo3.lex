%{
#include <stdio.h>
#include <string.h>

// Function to extract and print attributes
void attributes(const char *tag) {
    const char *start = strchr(tag, ' ');
    if (start) {
        start++; // Skip the initial space
        while (*start) {
            const char *end = strchr(start, '=');
            if (!end) break;

            printf("Attribute: ");
            fwrite(start, 1, end - start, stdout);

            start = strchr(end, '"'); // Move to the first "
            if (!start) break;
            start++;

            const char *value_end = strchr(start, '"'); // Find the closing " 
            if (!value_end) break;

            printf("=\"");
            fwrite(start, 1, value_end - start, stdout);
            printf("\"\n");

            start = value_end + 1; // Move past the closing "
        }
    }
}
%}

%%

"<"[a-zA-Z0-9]+([^>]*)">" {
    printf("Opening Tag: %s\n", yytext);
    attributes(yytext);
}


"</"[a-zA-Z0-9]+">" {
    printf("Closing Tag: %s\n", yytext);
}

[^<>\n]+            {
    // Match content between tags
    printf("Content: %s\n", yytext);
}

[\t\n\r ]+ { /* Ignore spaces, tabs, and newlines */ }

. { /* Catch-all for unexpected characters */ }

%%

int main() {
    printf("Starting lexical analysis...\n");
    yylex(); // Call the lexer
    return 0;
}

int yywrap() {
    return 1; // Signals the end of input
}
