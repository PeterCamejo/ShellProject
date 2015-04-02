#include "shell.h"
#include <stdlib.h>



/* changes directory when CD+filepath command recieved */
void changedir(char * directory){
	if(chdir(directory) == -1){
		printf("\t %s is not a directory\n" , directory);
	}
	return;
}

/* do_it() runs built in commands */
void do_it(){
	switch(command){
		case CDX :  // CD with a directory specified.
			changedir(cd_filepath);
			printf("\t CD w/ filepath recognized. Filepath is : %s\n", cd_filepath);
			CMD = 0;
			break;
		case CDH: 	// CD with no directory specified.
			chdir(getenv("HOME"));
			printf("\t CD HOME recognized\n"); //TODO: Remove this after testing.
			CMD = 0;
			break;
		/*case ALIASHOME
		case UNALIAS
		case SETENV
		case PRINTENV*/
	}
}

/* Prompts shell input each line */
void prompt(){
	printf("SHELL:%s$ " , getenv("PWD"));
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