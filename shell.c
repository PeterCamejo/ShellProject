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
		/* environ and i for use in printenv (Cant declare variables inside cases) */
		extern char ** environ;
		int i = 0;

		case CDX :  // CD with a directory specified.
			changedir(cd_filepath);
			CMD = 0;
			break;
		case CDH: 	// CD with no directory specified.
			chdir(getenv("HOME"));
			CMD = 0;
			break;
		case SETENV:
			if(setenv( envvar , envvar_value, 1) == -1){
				printf("\t Error: Failed to set %s as %s\n", envvar , envvar_value);
			}
			CMD = 0;
			break;
		case PRINTENV:
			while(environ[i]){
				printf("%s\n" , environ[i++]);
			}
			CMD = 0;
			break;
		/*case ALIASHOME
		case UNALIAS
		
		*/
	}
}

/* Prompts shell input each line */
void prompt(){
	char *curdir = get_current_dir_name(); //current working directory
	printf("SHELL:%s$ " , curdir);
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