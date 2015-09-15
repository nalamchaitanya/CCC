%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    int yylex(void);
    void yyerror();
    extern FILE *yyin;
    extern FILE *yyout;
%}
