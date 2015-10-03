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

("int ")             {printf("%s",yytext);return INT;}

("void")            {
                        return VOID;
                    }

("printf")          {return PRINT;}

({digit})*          {
                        yylval.number = atoi(yytext);
                        return NUMBER;
                    }

("+"|"-"|"{"|"}"|"("|")"|";"|"="|",") {printf("%s ",yytext);return *yytext;}

[\"]([^\"])*[\"]    {
                        char *temp = strdup(yytext);
                        temp++;
                        yylval.string = strndup(temp,strlen(temp)-1);
                        printf("%s",yytext);
                        return STRING;
                    }

[/][/]([^\n])*[\n]  {printf("%s",yytext);}

[ \t\n\r]+          {;}

({letter}({letter}|{digit})*)   {
                                    yylval.string = strdup(yytext);
                                    printf("%s",yytext);
                                    return VARIABLE;
                                }

.                {printf("well\n");yyerror();}

%%

int yywrap(void)
{
    return 1;
}
