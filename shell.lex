

%{

#include <stdio.h>
#include "y.tab.h"
#include "shell.h"
%}


WORD		[A-Za-z0-9{}$_/\-]
COMMAND		\"[A-Za-z0-9<>|[:space:]_/\-]+\"


%%

unalias			{unaliasing = 1; printf("\t Caught unalias\n");return UN_ALIAS;};
alias 			return ALIAS;
printenv		return PRINT_ENV;
cd				return CD;
setenv			return SET_ENV;
hello			return HELLO;
bye				return BYE;
&				return AMPER;
\\[^n]			{yylval.strval = strdup(yytext); return ESCAPE;};
\<				return LT;
\>\>			return GT2;
\>				return GT;
\|				return PIPE;
{WORD}+			{
					yylval.strval = strdup(yytext); 
					char * text = yylval.strval;
					int length = strlen(text);
					
					//If the word is found to be an alias
					if(isAlias(text) == 1 && unaliasing != 1){
						alias_caught = 1;  //signal alias catch
						char * alias_cmd;
						int i = 0;

						while(aliastable[i][0] != 0){	//traverse alias table
							
							if(strcmp(text , aliastable[i][0]) == 0){  //if word matched to alias
								
								alias_name  = text;

								//Remove quotes from alias command
								alias_cmd = aliastable[i][1];
								length = strlen(alias_cmd);
								char final_cmd[length-1];

								for(int j = 0; j < length-2 ; ++j){
									final_cmd[j] = alias_cmd[j+1];
								}

								final_cmd[length-2] = '\0';  //Add NULL pointer.

								alias_command = final_cmd; //Set alias command as the final, processed command.						
							}

							i++;
						}
						return WORD;
					}
					else if(text[0] == '$' && text[1] == '{'){
						expanding = 1;
						char * env_name = malloc(sizeof(text));
						char * env_value;

						for(int i = 2; i < length; i++ ){					
							if(text[i+1] == '}'){					
								strncpy(env_name , text+2 , i-1);
								strcat(env_name , "\0");
								break;
							}
						}
						env_value = getenv(env_name);
						if(env_value == NULL){
							printf("\tError: Not a valid Environmental Variable name \n");
						}
						else{
							yylval.strval = env_value;
						}
						return WORD;
					}
					else{
												
						yylval.strval =strdup(yytext);
						return WORD;
					}

				};




{COMMAND}		{yylval.strval = strdup(yytext); return COMMAND;};
\n 				return NEWLINE;
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
