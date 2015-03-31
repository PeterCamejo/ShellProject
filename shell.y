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

%token NUMBER HELLO STATE BYE
%token <strval> COMMAND


%%

commands: /*empty */
		| commands command;

command:
		hello_case|bye_case|state_number_case;

hello_case:
		HELLO 	{printf("\t hello back!! \n"); return 0;};
bye_case:
		BYE 	{CMD = EXIT; return 0;};
state_number_case:
		STATE NUMBER 	{printf("\t state with number recieved \n"); return 0;};