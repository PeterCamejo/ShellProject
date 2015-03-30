%{#include <stdio.h>
#include <string.h>
#include "shell.h"

void yyerror ( const char *str) {fprintf ( stderr , "error: %s\n" , str);}
int yywrap(){return 1;}
main(){yyparse();}
%}

%token NUMBER HELLO BYE STATE
%%

commands: /*empty */
		| commands command;

command:
		hello_case|bye_case|state_number_case;

hello_case:
		HELLO 	{printf("\t hello back!! \n");};
bye_case:
		BYE 	{printf("\t bye back !! \n");};
state_number_case:
		STATE NUMBER 	{printf("\t state with number recieved \n");};