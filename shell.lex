

%{

#include <stdio.h>
#include "y.tab.h"
%}

FILEPATH	[A-Za-z0-9_/\-]

%%

printenv		return PRINT_ENV;
cd				return CD;
cd\n 			return CDHOME;
setenv			return SET_ENV;
[0-9]+			return NUMBER;
hello			return HELLO;
bye				return BYE;
\n 				/*ignore end of line*/
[:space:]		return SPACE;
{FILEPATH}+		{yylval.strval = strdup(yytext); return FILEPATH;}


%%
