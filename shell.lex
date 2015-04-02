

%{

#include <stdio.h>
#include "y.tab.h"
%}

FILEPATH	[A-Za-z0-9_/\-]

%%


cd				return CD;
[0-9]+			return NUMBER;
hello			return HELLO;
bye				return BYE;
on|off			return STATE;
\n 				return NEWLINE;
[:space:]		return SPACE;
{FILEPATH}+		{yylval.strval = strdup(yytext); return FILEPATH;}


%%
