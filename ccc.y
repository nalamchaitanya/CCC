%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    int yylex(void);
    void yyerror();
    extern FILE *yyin;
    extern FILE *yyout;
%}

%union
{
	char* string;
    int number;
};

%token <string> VARIABLE STRING
%token <number> NUMBER
%token INT VOID PRINT
%type  <number> pargs var_list


%%

program:
        block program
        | block
        ;

block:
        VOID VARIABLE '(' ')' '{' statements '}'
        ;

statements:
        statement statements
        | statement
        ;

statement:
        INT var_list ';'
        | INT ';'
        | VARIABLE '=' expr ';'
        | PRINT '(' STRING pargs ')' ';'    {if($4=1){printf("hi\n");}}
        | PRINT '(' STRING ')' ';'
        | VARIABLE '(' ')' ';'
        | ';'
        |
        ;

pargs:
        ',' VARIABLE pargs              {$$=0;}
        | ',' NUMBER pargs              {$$=0;}
        ;

expr:
        literal op expr
        | literal
        ;

literal:
        VARIABLE
        | NUMBER
        ;

op:
        '+'
        | '-'
        ;

var_list:
        VARIABLE ',' var_list           {$$=0;}
        | VARIABLE                      {$$=0;}
        ;

%%

void yyerror(char *text)
{
	printf("ERROR\n");
	exit(0);
}

int main(int argc,char *argv[])
{
    yyin=fopen(argv[1],"r");
    yyparse();
    return 0;
}
