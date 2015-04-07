

%{

#include <stdio.h>
#include "y.tab.h"
#include "shell.h"
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
{WORD}+			{if(processAlias(yytext) == 1){yylval.strval = strdup(yytext); return WORD;}};
{FILEPATH}+		{yylval.strval = strdup(yytext); return FILEPATH;};
{COMMAND}		{yylval.strval = strdup(yytext); return COMMAND;};

					


%%

int processAlias(char * alias){
	char * alias_cmd;
	alias_caught = 0;
	int k = 0;

	if(aliastable[0][0] == 0){
		return 1;
	}

	int i = 0;
	while(aliastable[i][0] != 0){
		if(strcmp(alias , aliastable[i][0]) == 0){
			
			alias_caught = 1;

			//Remove quotes from alias command
			alias_cmd = aliastable[i][1];
			for(int j = 0; j < strlen(alias_cmd) ; j++){
				if(alias_cmd[i] == '\\'){
					alias_cmd[k++] = alias_cmd[j++];
					alias_cmd[k++] = alias_cmd[j];

					if(alias_cmd[j] == '\0'){
						break;
					}
				}
				else if (alias_cmd[j] != '"'){
					alias_cmd[k++] = alias_cmd[j];
				}
			}
			alias_cmd[k] = '\0';
			alias_cmd[k+1] = '\0';


			//Input alias command through flex/bison again.
			printf("\t Alias recognized : %s\n\t The command is %s\n" , aliastable[i][0] , alias_cmd);
			YY_BUFFER_STATE newbuffer;
			newbuffer = yy_scan_string(alias_cmd);
			yy_switch_to_buffer(newbuffer);
			yy_delete_buffer(newbuffer);


			return 0;
		}
		i++;
	}
	return 1;
}
