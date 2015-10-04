%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "Interpreter.h"
    int yylex(void);
    void yyerror();
    extern FILE *yyin;
    extern FILE *yyout;
    char *str;
    int fcount;
    int strcount;
    Context **contexts;
%}

%union
{
	char* string;
    int number;
};

%token <string> VARIABLE STRING
%token <number> NUMBER
%token INT VOID PRINT
%type  <string> pargs
%type  <number> var_list
%type  <string> statement
%type  <string> statements
%type  <string> block
%type  <string> expr

%%

program:
        block program               {
                                        strcat(str,$1);
                                    }
        | block                     {
                                        strcat(str,$1);
                                    }
        ;

block:
        fdecl '{' statements '}'    {
                                        char *temp = (char*)malloc(sizeof(char)*10000);
                                        *temp ='\0';
                                        strcat(temp,printHeader(contexts[fcount]));
                                        strcat(temp,$3);
                                        strcat(temp,printFooter(contexts[fcount]));
                                        $$ = temp;
                                        fcount++;
                                    }
        ;

fdecl:
        VOID VARIABLE '(' ')'       {
                                        int i =0;
                                        while(i<fcount)
                                        {
                                            if(strcmp($2,contexts[i]->fname)==0)
                                                yyerror();
                                            i++;
                                        }
                                        initContext(contexts,fcount,$2);
                                    }
        ;

statements:
        statement ';' statements        {
                                            char* temp = (char*)malloc(sizeof(char)*10000);
                                            *temp='\0';
                                            strcat(temp,$1);
                                            strcat(temp,$3);
                                            $$=temp;
                                        }
        | statement ';'                 {
                                            $$=$1;
                                        }
        ;

statement:
        INT var_list                    {
                                            $$="\0";
                                        }
        | VARIABLE '=' NUMBER           {
                                            char *temp = (char*)malloc(sizeof(char)*30);
                                            int i =0;
                                            int varcount = contexts[fcount]->varcount;
                                            while(i<varcount)
                                            {
                                                if(strcmp($1,contexts[fcount]->symbols[i].name)!=0)
                                                    i++;
                                                else
                                                    break;
                                            }
                                            if(i==varcount)
                                                yyerror();
                                            sprintf(temp,"\tmovl\t$%d, %d(%%rbp)\n",$3,-4*(varcount-i));
                                            $$=temp;
                                        }
        | VARIABLE '=' expr             {
                                            char *tmp=(char*)malloc(sizeof(char)*1000);
                                            char *temp = (char*)malloc(sizeof(char)*30);
                                            int i =0;
                                            int varcount = contexts[fcount]->varcount;
                                            while(i<varcount)
                                            {
                                                if(strcmp($1,contexts[fcount]->symbols[i].name)!=0)
                                                    i++;
                                                else
                                                    break;
                                            }
                                            if(i==varcount)
                                                yyerror();
                                            sprintf(temp,"\tmovl\t%%eax, %d(%%rbp)\n",-4*(varcount-i));
                                            *tmp='\0';
                                            strcat(tmp,$3);
                                            strcat(tmp,temp);
                                            $$=tmp;
                                        }
        | PRINT '(' STRING pargs ')'    {
                                            contexts[fcount]->strlbl[contexts[fcount]->strcnt]=strcount;
                                            contexts[fcount]->strings[contexts[fcount]->strcnt]=$3;
                                            contexts[fcount]->strcnt++;
                                            $$=printPrintf(contexts,fcount,$3,$4,strcount);
                                            strcount++;
                                        }
        | VARIABLE '(' ')'              {
                                            int i =0;
                                            while(i<fcount)
                                            {
                                                if(strcmp($1,contexts[i]->fname)!=0)
                                                    i++;
                                                else
                                                    break;
                                            }
                                            if(i==fcount)
                                                yyerror();
                                            else
                                            {
                                                char *temp = (char*)malloc(sizeof(char)*30);
                                                sprintf(temp,"\tcall\t%s\n",contexts[i]->fname);
                                                $$=temp;
                                            }
                                        }
        | expr                          {
                                            $$="\0";
                                        }
        |                               {
                                            $$="\0";
                                        }
        ;

pargs:
        ',' VARIABLE pargs              {
                                            int i =0;
                                            int varcount = contexts[fcount]->varcount;
                                            while(i<varcount)
                                            {
                                                if(strcmp($2,contexts[fcount]->symbols[i].name)!=0)
                                                    i++;
                                                else
                                                    break;
                                            }
                                            if(i==varcount)
                                                yyerror();
                                            char *temp=(char*)malloc(sizeof(char)*500);
                                            sprintf(temp,",%s%s",$2,$3);
                                            printf("helo2\n");
                                            $$=temp;
                                        }
        | ',' NUMBER pargs              {
                                            char *temp=(char*)malloc(sizeof(char)*500);
                                            sprintf(temp,",%d%s",$2,$3);
                                            $$=temp;
                                        }
        |                               {printf("helo\n");$$="\0";}
        ;

expr:
        VARIABLE '+' expr               {
                                            char *temp = (char*)malloc(sizeof(char)*10000);
                                            int i =0;
                                            int varcount = contexts[fcount]->varcount;
                                            while(i<varcount)
                                            {
                                                if(strcmp($1,contexts[fcount]->symbols[i].name)!=0)
                                                    i++;
                                                else
                                                {
                                                    break;
                                                }
                                            }
                                            if(i==varcount)
                                                yyerror();
                                            *temp='\0';
                                            strcat(temp,$3);
                                            char *tmp=(char*)malloc(sizeof(char)*30);
                                            sprintf(tmp,"\taddl\t%d(%%rbp), %%eax\n",-4*(varcount-i));
                                            strcat(temp,tmp);
                                            $$=temp;
                                        }
        | VARIABLE '-' expr             {
                                            char *temp = (char*)malloc(sizeof(char)*10000);
                                            int i =0;
                                            int varcount = contexts[fcount]->varcount;
                                            while(i<varcount)
                                            {
                                                if(strcmp($1,contexts[fcount]->symbols[i].name)!=0)
                                                    i++;
                                                else
                                                {
                                                    break;
                                                }
                                            }
                                            if(i==varcount)
                                                yyerror();
                                            *temp='\0';
                                            strcat(temp,$3);
                                            char *tmp=(char*)malloc(sizeof(char)*30);
                                            sprintf(tmp,"\tsubq\t%d(%%rbp), %%eax\n",-4*(varcount-i));
                                            strcat(temp,tmp);
                                            $$=temp;
                                        }
        | NUMBER '+' expr               {
                                            char *temp = (char*)malloc(sizeof(char)*10000);
                                            *temp='\0';
                                            strcat(temp,$3);
                                            char *tmp=(char*)malloc(sizeof(char)*30);
                                            sprintf(tmp,"\taddl\t$%d, %%eax\n",$1);
                                            strcat(temp,tmp);
                                            $$=temp;
                                        }
        | NUMBER '-' expr               {
                                            char *temp = (char*)malloc(sizeof(char)*10000);
                                            *temp='\0';
                                            strcat(temp,$3);
                                            char *tmp = (char*)malloc(sizeof(char)*30);
                                            sprintf(tmp,"\tmovl\t$%d, %%edx\n",$1);
                                            strcat(temp,tmp);
                                            strcat(temp,"\tsubq\t%%eax, %%edx\n");
                                            strcat(temp,"\tmovl\t%%edx, %%eax\n");
                                            $$=temp;
                                        }
        | VARIABLE                      {
                                            char *temp = (char*)malloc(sizeof(char)*30);
                                            int i =0;
                                            int varcount = contexts[fcount]->varcount;
                                            while(i<varcount)
                                            {
                                                if(strcmp($1,contexts[fcount]->symbols[i].name)!=0)
                                                    i++;
                                                else
                                                {
                                                    break;
                                                }
                                            }
                                            if(i==varcount)
                                                yyerror();
                                            sprintf(temp,"\tmovl\t%d(%%rbp), %%eax\n",-4*(varcount-i));
                                            $$=temp;
                                        }
        | VARIABLE '+' NUMBER           {
                                            char *temp = (char*)malloc(sizeof(char)*100);
                                            char *tmp = (char*)malloc(sizeof(char)*30);
                                            int i =0;
                                            int varcount = contexts[fcount]->varcount;
                                            while(i<varcount)
                                            {
                                                if(strcmp($1,contexts[fcount]->symbols[i].name)!=0)
                                                    i++;
                                                else
                                                {
                                                    break;
                                                }
                                            }
                                            if(i==varcount)
                                                yyerror();
                                            *temp='\0';
                                            sprintf(tmp,"\tmovl\t%d(%%rbp), %%eax\n",-4*(varcount-i));
                                            strcat(temp,tmp);
                                            sprintf(tmp,"\taddl\t$%d, %%eax\n",$3);
                                            strcat(temp,tmp);
                                            $$=temp;
                                        }
        | VARIABLE '-' NUMBER           {
                                            char *temp = (char*)malloc(sizeof(char)*100);
                                            char *tmp = (char*)malloc(sizeof(char)*30);
                                            int i =0;
                                            int varcount = contexts[fcount]->varcount;
                                            while(i<varcount)
                                            {
                                                if(strcmp($1,contexts[fcount]->symbols[i].name)!=0)
                                                    i++;
                                                else
                                                {
                                                    break;
                                                }
                                            }
                                            if(i==varcount)
                                                yyerror();
                                            *temp='\0';
                                            sprintf(tmp,"\tmovl\t%d(%%rbp), %%eax\n",-4*(varcount-i));
                                            strcat(temp,tmp);
                                            sprintf(tmp,"\tsubq\t$%d, %%eax\n",$3);
                                            strcat(temp,tmp);
                                            $$=temp;
                                        }
        | NUMBER '+' NUMBER           {
                                            char *temp = (char*)malloc(sizeof(char)*100);
                                            char *tmp = (char*)malloc(sizeof(char)*30);
                                            *temp='\0';
                                            sprintf(tmp,"\tmovl\t$%d, %%eax\n",$1);
                                            strcat(temp,tmp);
                                            sprintf(tmp,"\taddl\t$%d, %%eax\n",$3);
                                            strcat(temp,tmp);
                                            $$=temp;
                                        }
        | NUMBER '-' NUMBER             {
                                            char *temp = (char*)malloc(sizeof(char)*100);
                                            char *tmp = (char*)malloc(sizeof(char)*30);
                                            *temp='\0';
                                            sprintf(tmp,"\tmovl\t$%d, %%eax\n",$1);
                                            strcat(temp,tmp);
                                            sprintf(tmp,"\tsubq\t$%d, %%eax\n",$3);
                                            strcat(temp,tmp);
                                            $$=temp;
                                        }
        ;

var_list:
        VARIABLE ',' var_list           {
                                            int i =0;
                                            int varcount = contexts[fcount]->varcount;
                                            while(i<varcount)
                                            {
                                                if(strcmp($1,contexts[fcount]->symbols[i].name)==0)
                                                    yyerror();
                                                i++;
                                            }
                                            contexts[fcount]->symbols[varcount].used=0;
                                            contexts[fcount]->symbols[varcount].index=varcount;
                                            contexts[fcount]->symbols[varcount].name=$1;
                                            contexts[fcount]->varcount++;
                                            $$=$3+1;
                                        }
        | VARIABLE                      {
                                            int i =0;
                                            int varcount = contexts[fcount]->varcount;
                                            while(i<varcount)
                                            {
                                                if(strcmp($1,contexts[fcount]->symbols[i].name)==0)
                                                    yyerror();
                                                i++;
                                            }
                                            contexts[fcount]->symbols[varcount].used=0;
                                            contexts[fcount]->symbols[varcount].index=varcount;
                                            contexts[fcount]->symbols[varcount].name=$1;
                                            contexts[fcount]->varcount++;
                                            $$=1;
                                        }
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
    contexts =(Context**)malloc(sizeof(Context*)*100);
    fcount=0;
    strcount=0;
    str=(char*)malloc(sizeof(char)*100000);
    *str='\t';
    strcat(str,".file\t\"");
    strcat(str,argv[1]);
    strcat(str,"\"\n");
    yyparse();
    printf("%s\n",str);
    return 0;
}
