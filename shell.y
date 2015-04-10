%{#include <stdio.h>
#include <string.h>
#include "shell.h"

extern FILE * yyin;

void yyerror ( const char *str) {fprintf ( stderr , "error: %s\n" , str);}
int yywrap(){return 1;}


%}

%union
{
	int intval;
	char *strval;
	float floatval;
}

%token NUMBER HELLO BYE CD FILEPATH SPACE PRINT_ENV ALIAS UN_ALIAS WORD COMMAND SET_ENV NEWLINE
%type <strval> setenv_case;


%%

commands: /*empty */
		| commands command;

command:
		hello_case|bye_case|cd_case|setenv_case|printenv_case|add_alias_case|unalias_case|word_case|no_command_case;
hello_case:
		HELLO NEWLINE 			{CMD = OK; builtin = 1; command = HELLOFRIEND; return 0;};
bye_case:
		BYE NEWLINE			{CMD = EXIT; return 0;};
cd_case: 
		CD FILEPATH NEWLINE	{CMD = OK; builtin = 1; command = CDX; cd_filepath = yylval.strval ; return 0;}
		|CD WORD NEWLINE  {CMD = OK; builtin = 1; command = CDX; cd_filepath = yylval.strval ; return 0;};
		|CD NEWLINE		  {CMD = OK; builtin = 1; command = CDH; return 0;};
setenv_case:
		SET_ENV FILEPATH FILEPATH NEWLINE{CMD = OK; builtin = 1; command = SETENV; envvar = $<strval>2; envvar_value = $<strval>3;return 0;};
printenv_case:
		PRINT_ENV NEWLINE 	{CMD = OK; builtin = 1; command = PRINTENV; return 0;};
add_alias_case:
		ALIAS WORD COMMAND NEWLINE      {CMD = OK ; builtin =1 ; command = ADDALIAS; alias_name = $<strval>2; alias_command = $<strval>3; return 0;};
		|ALIAS NEWLINE				{CMD = OK; builtin = 1; command = LISTALIAS; return 0;};
unalias_case:
		UN_ALIAS WORD NEWLINE 	{CMD = OK; builtin = 1; command = UNALIAS; alias_name = $<strval>2;return 0; };
word_case:
		WORD NEWLINE			{if(alias_caught == 0){ CMD = SYSERR;} return 0;};
no_command_case:
		NEWLINE					{return 0;};
