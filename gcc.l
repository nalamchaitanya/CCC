letter  [a-zA-Z]
digit   [0-9]

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"
    extern YYSTYPE yylval;
    void yyerror();
%}

%%

("int")         {return INT;}

("char")        {return CHAR;}

("for")         {return FOR;}

("while")       {return WHILE;}

("if")          {return IF;}

("else")        {return ELSE;}

("return")      {return RETURN;}
