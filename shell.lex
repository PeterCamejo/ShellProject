

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
\n 				/* ignore newline */
[:space:]		return SPACE;
{WORD}+			{
					yylval.strval = strdup(yytext); 
					char * text = yylval.strval;
					
					//If the word is found to be an alias
					if(isAlias(text) == 1){
						alias_caught = 1;  //signal alias catch
						char * alias_cmd;
						int len  = 0;
						int i = 0;

						while(aliastable[i][0] != 0){
							
							if(strcmp(text , aliastable[i][0]) == 0){
								

								//Remove quotes from alias command
								alias_cmd = aliastable[i][1];
								len = strlen(alias_cmd);
								char final_cmd[len-1];

								for(int j = 0; j < len-2 ; ++j){
									final_cmd[j] = alias_cmd[j+1];
								}

								final_cmd[len-2] = '\0';  //Add NULL pointer.

								alias_command = final_cmd; //Set alias command as the final, processed command.						
							}

							i++;
						}
						return WORD;
					}
					else{
						alias_caught = 0;
						return WORD;
					}

				};




{FILEPATH}+		{yylval.strval = strdup(yytext); return FILEPATH;};
{COMMAND}		{yylval.strval = strdup(yytext); return COMMAND;};
[ \t]+			/*ignore whitespace */

<<EOF>>  {
	
			yypop_buffer_state();

			if(!YY_CURRENT_BUFFER){
				yyterminate();

			}
}

%%

int isAlias(char * alias){
	alias_caught = 0;
	if(aliastable[0][0] == 0){
		return 0;
	}

	int i = 0;
	while(aliastable[i][0] != 0){
		if(strcmp(alias , aliastable[i][0]) == 0){
			alias_caught = 1; //alias recognized.

			return 1;
		}
		i++;
	}
	return 0;
}



void reflex(char * alias_cmd){
	alias_caught = 0; //reset alias catching for nested alias use.

	int length = strlen(alias_cmd);
	char newbuffer[length+2];
	strcpy(newbuffer , alias_cmd);
	strcat(newbuffer , "\n");


	yypush_buffer_state(YY_CURRENT_BUFFER);
	yy_scan_string(newbuffer);


	if(yyparse()){
		printf("\t Parsing error in reflex()\n");
	}

	return;
}
