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
%type  <number> pargs
%type  <number> var_list


%%

program:
        block program
        | block
        ;

block:
        VOID VARIABLE '(' ')' '{' statements '}'    {printf("%s is completed.",$2);}
        ;

statements:
        statement ';' statements
        | statement ';'
        ;

statement:
        INT var_list                     {printf("in varlist");}
        | VARIABLE '=' expr
        | PRINT '(' STRING pargs ')'     {if($4=1){printf("hi\n");}}
        | VARIABLE '(' ')'
        | expr
        |
        ;

pargs:
        ',' VARIABLE pargs              {$$=$3+1;}
        | ',' NUMBER pargs              {$$=$3+1;}
        |                               {$$=0;}
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
        VARIABLE ',' var_list           {$$=$3+1;printf("variable\n");}
        | VARIABLE                      {printf("in varlist %s",$1);$$=1;}
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
