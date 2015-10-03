letter  [a-zA-Z]
digit   [0-9]

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"
    extern YYSTYPE yylval;
    extern FILE *yyin;
    void yyerror();
%}

%%

("int")             {return INT;}

("void")            {
                        return VOID;
                    }

("printf")          {return PRINT;}

({digit})*          {
                        yylval.number = atoi(yytext);
                        return NUMBER;
                    }

[+-{}();=]          {return *yytext;}

[\"]([^\"])*[\"]    {
                        char *temp = strdup(yytext);
                        temp++;
                        yylval.string = strndup(temp,strlen(temp)-1);
                        return STRING;
                    }

[/][/]([^\n])*[\n]  {;}

[ \t\n\r]+          {;}

({letter}({letter}|{digit})*)  {yylval.string = strdup(yytext);
                                return VARIABLE;}

.                {yyerror();}

%%

int yywrap(void)
{
    return 1;
}
