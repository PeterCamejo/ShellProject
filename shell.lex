

%{

#include <stdio.h>
#include "y.tab.h"
%}

FILEPATH	[A-Za-z0-9_/\-]
NAME		[A-Za-z]
COMMAND		\"[A-Za-z0-9<>|[:space:]_/\-]+\"

%%

unalias			return UN_ALIAS;
alias 			return ALIAS;
alias\n         return LIST_ALIAS;
printenv		return PRINT_ENV;
cd				return CD;
cd\n 			return CDHOME;
setenv			return SET_ENV;
[0-9]+			return NUMBER;
hello			return HELLO;
bye				return BYE;
\n 				/*ignore end of line*/
[:space:]		return SPACE;
{NAME}+			{yylval.strval = strdup(yytext); return NAME;};
{FILEPATH}+		{yylval.strval = strdup(yytext); return FILEPATH;};
{COMMAND}		{yylval.strval = strdup(yytext); return COMMAND;};


%%
