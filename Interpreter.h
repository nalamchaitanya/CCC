/*
    Nalam V S S Krishna Chaitanya
    Interpreter
*/
#include <stdio.h>
#include <stdlib.h>

#ifndef INTERPRETER_H
#define INTERPRETER_H

typedef struct _Symbol
{
    int used;
    char *name;
    int index;
}Symbol;

typedef struct _Context
{
    Symbol* symbols;
    int strcnt;
    int varcount;
    char *fname;
    int *strlbl;
    char **strings;
}Context;

char* printHeader(Context *context);

char* printFooter(Context *context);

void initContext(Context **context,int index,char *name);

char* printPrintf(Context **context,int index,char *str,char* args,int strcnt);

int getIndex(Context **context,int index,char *varname);

#endif
