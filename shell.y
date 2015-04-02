%{#include <stdio.h>
#include <string.h>
#include "shell.h"

void yyerror ( const char *str) {fprintf ( stderr , "error: %s\n" , str);}
int yywrap(){return 1;}
/* main(){yyparse();}  // Can't have two main()*/
%}

%union
{
	int intval;
	char *strval;
	float floatval;
}

%token NUMBER HELLO BYE CD FILEPATH SPACE CDHOME
%token <strval> COMMAND


%%

commands: /*empty */
		| commands command;

command:
		hello_case|bye_case|cd_case|cd_home_case;
hello_case:
		HELLO 			{printf("\t hello back!! \n"); return 0;};
bye_case:
		BYE 			{CMD = EXIT; return 0;};
cd_case: 
		CD FILEPATH 	{CMD = OK; builtin = 1; command = CDX; cd_filepath = yylval.strval ; return 0;};
cd_home_case:
		CDHOME			{CMD = OK; builtin = 1; command = CDH; return 0;};
