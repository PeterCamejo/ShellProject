%{#include <stdio.h>
#include <string.h>
#include "shell.h"


void yyerror ( const char *str) {fprintf ( stderr , "error: %s\n" , str);}
int yywrap(){return 1;}

%}

%union
{
	int intval;
	char *strval;
	float floatval;
}

%token NUMBER HELLO BYE CD FILEPATH SPACE CDHOME PRINT_ENV ALIAS UN_ALIAS LIST_ALIAS NAME COMMAND
%token <strval> SET_ENV

%type <strval> setenv_case;


%%

commands: /*empty */
		| commands command;

command:
		hello_case|bye_case|cd_case|cd_home_case|setenv_case|printenv_case|list_alias_case|add_alias_case|unalias_case;
hello_case:
		HELLO 			{CMD = OK; builtin = 1; command = HELLOFRIEND; return 0;};
bye_case:
		BYE 			{CMD = EXIT; return 0;};
cd_case: 
		CD FILEPATH 	{CMD = OK; builtin = 1; command = CDX; cd_filepath = yylval.strval ; return 0;}
		|CD NAME  {CMD = OK; builtin = 1; command = CDX; cd_filepath = yylval.strval ; return 0;};
cd_home_case:
		CDHOME			{CMD = OK; builtin = 1; command = CDH; return 0;};
setenv_case:
		SET_ENV FILEPATH FILEPATH {CMD = OK; builtin = 1; command = SETENV; envvar = $<strval>2; envvar_value = $<strval>3;return 0;};
printenv_case:
		PRINT_ENV 		{CMD = OK; builtin = 1; command = PRINTENV; return 0;};
add_alias_case:
		ALIAS NAME COMMAND      {CMD = OK ; builtin =1 ; command = ADDALIAS; alias_name = $<strval>2; alias_command = $<strval>3; return 0;};

list_alias_case:
		LIST_ALIAS 		{CMD = OK; builtin = 1; command = LISTALIAS; return 0;};
unalias_case:
		UN_ALIAS NAME 	{CMD = OK; builtin = 1; command = UNALIAS; alias_name = $<strval>2;return 0; };
