

%{

#include <stdio.h>
#include "y.tab.h"
%}

FILEPATH	[A-Za-z0-9_/\-]
WORD		[A-Za-z0-9]
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
{WORD}+			{yylval.strval = strdup(yytext); return WORD;};
{FILEPATH}+		{yylval.strval = strdup(yytext); return FILEPATH;};
{COMMAND}		{yylval.strval = strdup(yytext); return COMMAND;};


%%
