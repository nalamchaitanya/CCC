#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Interpreter.h"

char* printHeader(Context *context)
{
    char *str = (char*)malloc(sizeof(char)*1000);
    *str='\0';
    //strcat(str,"\t.section\t.rodata\n");
    char *temp = (char*)malloc(sizeof(char)*100);
    int i;
    i=0;
    while(i<context->strcnt)
    {
        sprintf(temp,".LC%d:\n\t.string\t%s\n",context->strlbl[i],context->strings[i]);
        strcat(str,temp);
        i++;
    }
    sprintf(temp,"\t.globl\t%s\n%s:\n",context->fname,context->fname);
    strcat(str,temp);
    strcat(str,"\tpushq\t%%rbp\n");
    strcat(str,"\tmovq\t%%rsp, %%rbp\n");
    strcat(str,"\tsubq\t$512, %%rsp\n");
    return str;
}

char* printFooter(Context *context){return "\tleave\n\tret\n";}

void initContext(Context **context,int index,char *name)
{
    context[index] = (Context*)malloc(sizeof(Context));
    context[index]->symbols=(Symbol*)malloc(sizeof(Symbol)*20);
    context[index]->strcnt=0;
    context[index]->varcount=0;
    context[index]->fname=name;
    context[index]->strings=(char**)malloc(sizeof(char*)*20);
    context[index]->strlbl=(int*)malloc(sizeof(int)*20);
    return;
}

char* printPrintf(Context **context,int index,char *str,char* args,int strcnt)
{
    char *temp = (char*)malloc(sizeof(char)*500);
    *temp='\0';
    char *tmp = (char*)malloc(sizeof(char)*30);
    char **strs = (char**)malloc(sizeof(char*)*5);
    strs[0]="%esi";
    strs[1]="%edx";
    strs[2]="%ecx";
    strs[3]="%r8d";
    strs[4]="%r9d";
    if(args!=NULL)
    {
        int i,count;
        i = 0;
        count=0;
        while(args[i]!='\0')
        {
            if(args[i]==',')
                count++;
            i++;
        }
        char **syms = (char**)malloc(sizeof(char*)*count);
        syms[0]=strtok(args,",");
        i=1;
        while(i<count)
        {
            syms[i]=strtok(NULL,",");
            i++;
        }
        i=0;
        while(i<count)
        {
            if(i<5)
            {
                sprintf(tmp,"\tmovl\t%d(%%rbp), %s\n",getIndex(context,index,syms[i]),strs[i]);
                strcat(temp,tmp);
            }
            else
            {
                sprintf(tmp,"\tmovl\t%d(%%rbp), %%eax\n",getIndex(context,index,syms[i]));
                strcat(temp,tmp);
                sprintf(tmp,"\tmovl\t%%eax, %d(%%rsp)",8*(i-5));
                strcat(temp,tmp);
            }
            i++;
        }

    }
    sprintf(tmp,"\tmovl\t$.LC%d, %%edi\n",context[index]->strlbl[context[index]->strcnt]);
    strcat(temp,tmp);
    strcat(temp,"\tmovl\t$0, %%eax\n");
    strcat(temp,"\tcall\tprintf\n");
    context[index]->strcnt++;
}

int getIndex(Context **context,int fcount,char *varname)
{
    int i =0;
    int varcount = context[fcount]->varcount;
    while(i<varcount)
    {
        if(strcmp(varname,context[fcount]->symbols[i].name)!=0)
            i++;
        else
            break;
    }
    return -4*(varcount-i);
}
