#include "shell.h"
#include <stdlib.h>


/* do_it() runs built in commands */
/*
void do_it(){
	switch(command){
		case CDHome:
		case CD : 
		case ALIAS
		case UNALIAS
		case SETENV
		case PRINTENV
	}
}
*/

void prompt(){
	printf("$");
	return;
}


int getCommand(){
	if(yyparse()){  	//If yyparse is anything but '0' , there is a parsing error.
		printf("Parsing Error Encountered");
	}
	return 0;
}


int main(){
	/* initilization */
	//shell_int();

	/* Shell Loop */
	while(1){	
		prompt();
		getCommand();
		switch(CMD /*= getCommand()*/){
			case OK: 
				/*if(builtin){
					do_it();
				}
				else{
					execute();
				};*/
				printf("OK");
			case EXIT:
				printf("Exiting...\n");
				exit(0);
			case SYSERR:
				printf("Nonvalid command");
				//	recover();
		}

	}
	return 0;
}