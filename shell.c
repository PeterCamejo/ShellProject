#include "shell.h"
#include <stdlib.h>


/* do_it() runs built in commands */

void do_it(){
	switch(command){
		//TODO: Add functionality after fixing Flex/Bison Error;
		case CDX :  // CD with a directory specified.
			printf("CD w/ filepath recognized. Filepath is : %s\n", cd_filepath);
			CMD = 0;
			break;
		case CDH: 	// CD with no directory specified.
			chdir(getenv("HOME"));
			printf("CD HOME recognized\n"); //TODO: Remove this after testing.
			CMD = 0;
			break;
		/*case ALIASHOME
		case UNALIAS
		case SETENV
		case PRINTENV*/
	}
}


void prompt(){
	printf("$");
	return;
}


int getCommand(){
	if(yyparse()){  	//If yyparse is anything but '0' , there is a parsing error.
		printf("Parsing Error Encountered \n");
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
		switch(CMD){
			case OK: 
				if(builtin){
					do_it();
				}
				/*else{
					execute();
				};*/
				
				break;
			case EXIT:
				printf("\t Exiting...\n");
				exit(0);
			case SYSERR:
				printf("Nonvalid command");
				//	recover();
		}

	}
	return 0;
}